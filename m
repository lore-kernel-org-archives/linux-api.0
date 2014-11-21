From: Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>
Subject: Re: [musl] Re: [RFC] Possible new execveat(2) Linux syscall
Date: Fri, 21 Nov 2014 09:11:26 -0500
Message-ID: <20141121141125.GX22465@brightrain.aerifal.cx>
References: <CAHse=S8ccC2No5EYS0Pex=Ng3oXjfDB9woOBmMY_k+EgxtODZA@mail.gmail.com>
 <20141116195246.GX22465@brightrain.aerifal.cx>
 <20141121101318.GG8866@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141121101318.GG8866-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, musl-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 21, 2014 at 02:13:18AM -0800, Christoph Hellwig wrote:
> On Sun, Nov 16, 2014 at 02:52:46PM -0500, Rich Felker wrote:
> > I've been following the discussions so far and everything looks mostly
> > okay. There are still issues to be resolved with the different
> > semantics between Linux O_PATH and what POSIX requires for O_EXEC (and
> > O_SEARCH) but as long as the intent is that, once O_EXEC is defined to
> > save the permissions at the time of open and cause them to be used in
> > place of the current file permissions at the time of execveat
> 
> As far as I can tell we only need the little patch below to make Linux
> O_PATH a valid O_SEARCH implementation.  Rich, you said you wanted to
> look over it?

I think the below looks correct, but it's not complete. The *at
functions also need to use FMODE_EXEC rather than rechecking +x
permissions at the time of the operation.

> For O_EXEC my interpretation is that we basically just need this new
> execveat syscall + a patch to add FMODE_EXEC and enforce it.  So we
> wouldn't even need the O_PATH|3 hack.  But unless someone more familar
> with the arcane details of the Posix language verifies it I'm tempted to
> give up trying to help to implent these flags :(

O_EXEC/O_SEARCH cannot be equal to O_PATH, because of differing
semantics on open. With O_NOFOLLOW, O_PATH yields a file descriptor
referring to the symlink itself. With O_EXEC or O_SEARCH, O_NOFOLLOW
is required to make open fail if the target is a symlink. It would be
a serious regression to eliminate the ability of O_PATH to open
symlinks like this.

Note that enforcing O_NOFOLLOW failure on symlinks can be implemented
in userspace instead of (or in addition to, for better behavior with
old kernels) kernelspace, but it still requires a different value from
O_PATH or userspace would be eliminating access to an important O_PATH
feature.

Further, O_PATH|3 was the best value I could find to yield nearly
reasonable fallback behavior on most old kernels. Simply using 3 fails
to open directories and files to which the caller does not have write
permission (mode 3 is a nearly-undocumented hack for opening devices
for ioctl-only read-write access, it seems). On pre-O_PATH kernels,
using O_PATH|3 would fallback to this failing case, yielding spurious
failure-to-open for all O_SEARCH and some O_EXEC operations, but those
kernels are old enough to be irrelevant to most users anyway. On
kernels that do have O_PATH, using O_PATH|3 ignores the 3 and yields
the current O_PATH semantics, which are nearly correct.

Of course O_PATH|1 or O_PATH|2 would also work in principle, as would
adding a completely new bit in addition to O_PATH, but these all seem
less desirable.

Rich
