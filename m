From: Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [PATCH 0/3] epoll: Add epoll_pwait1 syscall
Date: Thu, 08 Jan 2015 10:12:52 +0100
Message-ID: <1420708372.18399.15.camel@suse.cz>
References: <1420705550-24245-1-git-send-email-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1420705550-24245-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Juri Lelli <juri.lelli@gmail.com>, Zach Brown <zab@zabbo.net>, David Drysdale <drysdale@google.com>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@plumgrid.com>, David Herrmann <dh.herrmann@gmail.com>, Dario Faggioli <raistlin@linux.it>, Theodore Ts'o <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Oleg Nesterov <oleg@redhat.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Fabian Frederick <fabf@skynet.be>, Josh Triplett <josh@joshtriplett.org>D
List-Id: linux-api@vger.kernel.org

On Thu, 2015-01-08 at 16:25 +0800, Fam Zheng wrote:
> Applications could use epoll interface when then need to poll a big number of
> files in their main loops, to achieve better performance than ppoll(2). Except
> for one concern: epoll only takes timeout parameters in microseconds, rather
> than nanoseconds.
> 
> That is a drawback we should address. For a real case in QEMU, we run into a
> scalability issue with ppoll(2) when many devices are attached to guest, in
> which case many host fds, such as virtual disk images and sockets, need to be
> polled by the main loop. As a result we are looking at switching to epoll, but
> the coarse timeout precision is a trouble, as explained below. 
> 
> We're already using prctl(PR_SET_TIMERSLACK, 1) which is necessary to implement
> timers in the main loop; and we call ppoll(2) with the next firing timer as
> timeout, so when ppoll(2) returns, we know that we have more work to do (either
> handling IO events, or fire a timer callback). This is natual and efficient,
> except that ppoll(2) itself is slow.
> 
> Now that we want to switch to epoll, to speed up the polling. However the timer
> slack setting will be effectively undone, because that way we will have to
> round up the timeout to microseconds honoring timer contract. But consequently,
> this hurts the general responsiveness.
> 
> Note: there are two alternatives, without changing kernel:
> 
> 1) Leading ppoll(2), with the epollfd only and a nanosecond timeout. It won't
> be slow as one fd is polled. No more scalability issue. And if there are
> events, we know from ppoll(2)'s return, then we do the epoll_wait(2) with
> timeout=0; otherwise, there can't be events for the epoll, skip the following
> epoll_wait and just continue with other work.
> 
> 2) Setup and add a timerfd to epoll, then we do epoll_wait(..., timeout=-1).
> The timerfd will hopefully force epoll_wait to return when it timeouts, even if
> no other events have arrived. This will inheritly give us timerfd's precision.
> Note that for each poll, the desired timeout is different because the next
> timer is different, so that, before each epoll_wait(2), there will be a
> timerfd_settime syscall to set it to a proper value.
> 
> Unfortunately, both approaches require one more syscall per iteration, compared
> to the original single ppoll(2), cost of which is unneglectable when we talk
> about nanosecond granularity.

Please consider adding a "flags" argument to the new syscall (and
returning EINVAL if non-zero).  See this article, which shows that
extended syscalls almost always want flags, and they often get it only
on the second try:

http://lwn.net/Articles/585415/

Thanks,
Miklos

P.S. stray apostrophes in To: and Cc: lines seems to be causing trouble.
