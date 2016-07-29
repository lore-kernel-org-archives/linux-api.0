From: Francis Giraldeau <francis.giraldeau-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: clocksource_watchdog causing scheduling of timers every second
 (was [v13] support "task_isolation" mode)
Date: Fri, 29 Jul 2016 14:31:45 -0400
Message-ID: <CAC6yHM4LON5ASooVa_eUaDYsN1W0HYTMX76yHDxf8Mff0mKqiA@mail.gmail.com>
References: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com>
 <alpine.DEB.2.20.1607202059180.25838@east.gentwo.org> <e60d7fd1-022d-c823-52e6-d44a49d274b1@mellanox.com>
 <alpine.DEB.2.20.1607212118210.12213@east.gentwo.org> <7a3f66f7-5011-7d59-2e0e-f57e4e42e6b6@mellanox.com>
 <alpine.DEB.2.20.1607251133450.25354@east.gentwo.org> <alpine.DEB.2.20.1607270847460.24843@east.gentwo.org>
 <f8d72e47-7e84-cbd0-869f-69bf452a8bfb@mellanox.com> <alpine.DEB.2.20.1607271022130.25729@east.gentwo.org>
 <alpine.DEB.2.20.1607271030020.25729@east.gentwo.org> <f7553d2a-f4ab-b218-bb93-fcb436db1770@mellanox.com>
 <alpine.DEB.2.20.1607271355320.5760@east.gentwo.org> <eacd22ec-fc87-290e-ee5f-21b8e879b059@mellanox.com>
 <alpine.DEB.2.20.1607271452530.9567@east.gentwo.org> <2fefa17d-37c6-9669-724e-9ee0d841e7b2@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2fefa17d-37c6-9669-724e-9ee0d841e7b2-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Gilad Ben Yossef <giladb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

I tested this patch on 4.7 and confirm that irq_work does not occurs anymore on
the isolated cpu. Thanks!

I don't know of any utility to test the task isolation feature, so I started
one:

    https://github.com/giraldeau/taskisol

The script exp.sh runs the taskisol to test five different conditions, but some
behavior is not the one I would expect.

At startup, it does:
 - register a custom signal handler for SIGUSR1
 - sched_setaffinity() on CPU 1, which is isolated
 - mlockall(MCL_CURRENT) to prevent undesired page faults

The default strict mode is set with:

    prctl(PR_SET_TASK_ISOLATION, PR_TASK_ISOLATION_ENABLE)

And then, the syscall write() is called. From previous discussion, the SIGKILL
should be sent, but it does not occur. When instead of calling write() we force
a page fault, then the SIGKILL is correctly sent.

When instead a custom signal handler SIGUSR1:

    prctl(PR_SET_TASK_ISOLATION, PR_TASK_ISOLATION_USERSIG |
                      PR_TASK_ISOLATION_SET_SIG(SIGUSR1)

The signal is never delivered, either when the syscall is issued nor when the
page fault occurs.

I can confirm that, if two taskisol are created on the same CPU, the second one
fails with Resource temporarily unavailable, so that's fine.

I can add more test cases depending on your comments, such as the TLB events
triggered by another thread on a non-isolated core. But maybe there is already
a test suite?

Francis

2016-07-27 15:58 GMT-04:00 Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>:
> On 7/27/2016 3:53 PM, Christoph Lameter wrote:
>>
>> On Wed, 27 Jul 2016, Chris Metcalf wrote:
>>
>>> Looks good.  Did you omit the equivalent fix in
>>> clocksource_start_watchdog()
>>> on purpose?  For now I just took your change, but tweaked it to add the
>>> equivalent diff with cpumask_first_and() there.
>>
>> Can the watchdog be started on an isolated cpu at all? I would expect that
>> the code would start a watchdog only on a housekeeping cpu.
>
>
> The code just starts the watchdog initially on the first online cpu.
> In principle you could have configured that as an isolated cpu, so
> without any change to that code, you'd interrupt that cpu.
>
> I guess another way to slice it would be to start the watchdog on the
> current core.  But just using the same idiom as in clocksource_watchdog()
> seems cleanest to me.
>
> I added your patch to the series and pushed it up (along with adding your
> Tested-by to the x86 enablement commit).  It's still based on 4.6 so I'll
> need
> to rebase it once the merge window closes.
>
>
> --
> Chris Metcalf, Mellanox Technologies
> http://www.mellanox.com
>
