From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU number (x86)
Date: Mon, 13 Jul 2015 11:36:02 -0700
Message-ID: <CALCETrUKSa7Y9ChUodasxiEGs6haCSrtXCnuZmjNE5oAOwnOnQ@mail.gmail.com>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
 <CALCETrV1suAbvMgD1jOEFyn3JcDE_hhi6X7+sGs9e3Oqw_6jUw@mail.gmail.com> <1050138282.1065.1436801252018.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1050138282.1065.1436801252018.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Jul 13, 2015 9:27 AM, "Mathieu Desnoyers"
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>
> ----- On Jul 12, 2015, at 11:38 PM, Andy Lutomirski luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org wrote:
>
> > On Jul 12, 2015 12:06 PM, "Mathieu Desnoyers"
> > <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
> >>
> >> Expose a new system call allowing threads to register a userspace memory
> >> area where to store the current CPU number. Scheduler migration sets the
> >> TIF_NOTIFY_RESUME flag on the current thread. Upon return to user-space,
> >> a notify-resume handler updates the current CPU value within that
> >> user-space memory area.
> >>
> >> This getcpu cache is an alternative to the sched_getcpu() vdso which has
> >> a few benefits:
> >> - It is faster to do a memory read that to call a vDSO,
> >> - This cache value can be read from within an inline assembly, which
> >>   makes it a useful building block for restartable sequences.
> >>
> >
> > Let's wait and see what the final percpu atomic solution is.  If it
> > involves percpu segments, then this is unnecessary.
>
> percpu segments will likely not solve everything. I have a use-case
> with dynamically allocated per-cpu ring buffer in user-space (lttng-ust)
> which can be a challenge for percpu segments. Having a fast getcpu()
> is a win in those cases.
>

Even so, percpu segments will give you fast getcpu without introducing
a new scheduler hook.

> >
> > Also, this will need to be rebased onto -tip, and that should wait
> > until the big exit rewrite is farther along.
>
> I don't really care which thread flag it ends up using, and this is
> more or less an internal implementation detail. The important part is
> the ABI exposed to user-space, and it's good to start the discussion
> on this aspect early.
>

Agreed.

> >
> >> This approach is inspired by Paul Turner and Andrew Hunter's work
> >> on percpu atomics, which lets the kernel handle restart of critical
> >> sections:
> >> Ref.:
> >> * https://lkml.org/lkml/2015/6/24/665
> >> * https://lwn.net/Articles/650333/
> >> *
> >> http://www.linuxplumbersconf.org/2013/ocw/system/presentations/1695/original/LPC%20-%20PerCpu%20Atomics.pdf
> >>
> >> Benchmarking sched_getcpu() vs tls cache approach. Getting the
> >> current CPU number:
> >>
> >> - With Linux vdso:            12.7 ns
> >
> > This is a bit unfair, because the glibc wrapper sucks and the
> > __vdso_getcpu interface is overcomplicated.  We can fix it with a
> > better API.  It won't make it *that* much faster, though.
>
> Even if we improve the vDSO function, we are at a point where just
> the function call is not that cheap.
>

True, and the LSL isn't likely to go away.  The branches can go, though.

--Andy
