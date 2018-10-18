From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v3 2/2] sysctl: handle overflow for file-max
Date: Thu, 18 Oct 2018 17:58:42 -0400
Message-ID: <20181018215842.GE20140@redhat.com>
References: <20181016223322.16844-1-christian@brauner.io>
 <20181016223322.16844-3-christian@brauner.io>
 <20181017003548.GA32577@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181017003548.GA32577@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christian Brauner <christian@brauner.io>, keescook@chromium.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com, mcgrof@kernel.org, akpm@linux-foundation.org, joe.lawrence@redhat.com, longman@redhat.com, linux@dominikbrodowski.net, adobriyan@gmail.com, linux-api@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Eric Dumazet <eric.dumazet@gmail.com>
List-Id: linux-api@vger.kernel.org

Hi Al,

On Wed, Oct 17, 2018 at 01:35:48AM +0100, Al Viro wrote:
> On Wed, Oct 17, 2018 at 12:33:22AM +0200, Christian Brauner wrote:
> > Currently, when writing
> > 
> > echo 18446744073709551616 > /proc/sys/fs/file-max
> > 
> > /proc/sys/fs/file-max will overflow and be set to 0. That quickly
> > crashes the system.
> > This commit sets the max and min value for file-max and returns -EINVAL
> > when a long int is exceeded. Any higher value cannot currently be used as
> > the percpu counters are long ints and not unsigned integers. This behavior
> > also aligns with other tuneables that return -EINVAL when their range is
> > exceeded. See e.g. [1], [2] and others.
> 
> Mostly sane, but...  get_max_files() users are bloody odd.  The one in
> file-max limit reporting looks like a half-arsed attempt in "[PATCH] fix
> file counting".  The one in af_unix.c, though...  I don't remember how
> that check had come to be - IIRC that was a strange fallout of a thread
> with me, Andrea and ANK involved, circa 1999, but I don't remember details;
> Andrea, any memories?  It might be worth reconsidering...  The change in
> question is in 2.2.4pre6; what do we use unix_nr_socks for?  We try to
> limit the number of PF_UNIX socks by 2 * max_files, but max_files can be
> huge *and* non-constant (i.e. it can decrease).  What's more, unix_tot_inflight
> is unsigned int and max_files might exceed 2^31 just fine since "fs: allow
> for more than 2^31 files" back in 2010...  Something's fishy there...

Feels like a lifetime ago :), but looking into I remembered some of
it. That thread was about some instability in unix sockets for an
unrelated bug in the garbage collector. While reviewing your fix, I
probably incidentally found a resource exhaustion problem in doing a
connect();close() loop on a listening stream af_unix. I found an
exploit somewhere in my home dated in 99 in ls -l. Then ANK found
another resource exhaustion by sending datagram sockets, which I also
found an exploit for in my home.

ANK pointed out that a connect syscall allocates two sockets, one to
be accepted by the listening process, the other is the connect
itself. That must be the explanation of the "*2".

The "max_files*2" is probably a patch was from you (which was not
overflowing back then), in attempt to fix the garbage collector issue
which initially looked like resource exhaustion.

I may have suggested to check sk_max_ack_backlog and fail connect() in
such case to solve the resource exhaustion, but my proposal was
obviously broken because connect() would return an error when the
backlog was full and I suppose I didn't implement anything like
unix_wait_for_peer. So I guess (not 100% sure) the get_max_files()*2
check stayed, not because of the bug in the garbage collector that was
fixed independently, but as a stop gap measure for the
connect();close() loop resource exhaustion.

I tried the exploit that does a connect();close() in a loop and it
gracefully hangs in unix_wait_for_peer() after sk_max_ack_backlog
connects.

Out of curiosity I tried also the dgram exploit and it hangs in
sock_alloc_send_pskb with sk_wmem_alloc_get(sk) < sk->sk_sndbuf
check. The file*2 limit couldn't have helped that one anyway.

If I set /proc/sys/net/core/somaxconn to 1000000 the exploit works
fine again and the connect;close loop again allocates infinite amount
of kernel RAM into a tiny RSS process and it triggered OOM (there was
no OOM killer in v2.2 I suppose). By default it's 128. There's also
sysctl_max_dgram_qlen for dgram that on Android is set to 600 (by
default 10).

I tend to think these resources are now capped by other means (notably
somaxconn, sysctl_max_dgram_qlen, sk_wmem_alloc_get) and unix_nr_socks
can be dropped. Or if that atomic counter is still needed it's not for
a trivial exploit anymore than just does listen(); SIGSTOP() from one
process and a connect();close() loop in another process. It'd require
more than a listening socket and heavily forking or a large increase
on the max number of file descriptors (a privileged op) to do a ton of
listens, but forking has its own memory footprint in userland too. At
the very least it should be a per-cpu counter synced to the atomic
global after a threshold.

The other reason for dropping is that it wasn't ideal that the trivial
exploit could still allocated max_files*2 SYN skbs with a loop of
connect;close, max_files*2 is too much already so I suppose it was
only a stop-gap measure to begin with.

Thanks,
Andrea
