From: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] percpu system call: fast userspace percpu critical sections
Date: Fri, 22 May 2015 15:06:47 -0700
Message-ID: <CADroS=4KKb4SKWNToqsqYm5qPq10OPy00yOTBkzaZO65kib1-w@mail.gmail.com>
References: <1432219487-13364-1-git-send-email-mathieu.desnoyers@efficios.com>
	<CAHO5Pa0Kok4_QN0v3JNWyzGT=GbZNZcRyLhu02R2npV9hSdt7g@mail.gmail.com>
	<CALCETrUSBqHG3tbOq1yFz33v1_ckEgLNorgAxwLFi7MkjNcwLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUSBqHG3tbOq1yFz33v1_ckEgLNorgAxwLFi7MkjNcwLA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, May 22, 2015 at 1:53 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> Create an array of user-managed locks, one per cpu.  Call them lock[i]
> for 0 <= i < ncpus.
>
> To acquire, look up your CPU number.  Then, atomically, check that
> lock[cpu] isn't held and, if so, mark it held and record both your tid
> and your lock acquisition count.  If you learn that the lock *was*
> held after all, signal the holder (with kill or your favorite other
> mechanism), telling it which lock acquisition count is being aborted.
> Then atomically steal the lock, but only if the lock acquisition count
> hasn't changed.
>

We had to deploy the userspace percpu API (percpu sharded locks,
{double,}compare-and-swap, atomic-increment, etc) universally to the
fleet without waiting for 100% kernel penetration, not to mention
wanting to disable the kernel acceleration in case of kernel bugs.
(Since this is mostly used in core infrastructure--malloc, various
statistics platforms, etc--in userspace, checking for availability
isn't feasible. The primitives have to work 100% of the time or it
would be too complex for our developers to bother using them.)

So we did basically this (without the lock stealing...): we have a
single per-cpu spin lock manipulated with atomics, which we take very
briefly to implement (e.g.) compare-and-swap.  The performance is
hugely worse; typical overheads are in the 10x range _without_ any
on-cpu contention. Uncontended atomics are much cheaper than they were
on pre-Nehalem chips, but they still can't hold a candle to
unsynchronized instructions.

As a fallback path for userspace, this is fine--if 5% of binaries on
busted kernels aren't quite as fast, we can work with that in exchange
for being able to write a percpu op without worrying about what to do
on -ENOSYS.  But it's just not fast enough to compete as the intended
way to do things.

AHH
