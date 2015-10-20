From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v8 04/14] task_isolation: add initial support
Date: Tue, 20 Oct 2015 14:26:34 -0700
Message-ID: <CALCETrX6e+mqfy-rNV3sA8xGVDNHviQ9vHBBhAPULeLecno7XQ@mail.gmail.com>
References: <1445373372-6567-1-git-send-email-cmetcalf@ezchip.com>
 <1445373372-6567-5-git-send-email-cmetcalf@ezchip.com> <CALCETrWzhrYreizoKG0w6Jtz3RLFjNx9Qk_JLykcLLUQcCXBEA@mail.gmail.com>
 <5626B00E.3010309@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5626B00E.3010309-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 20, 2015 at 2:20 PM, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org> wrote:
> On 10/20/2015 04:56 PM, Andy Lutomirski wrote:
>>
>> On Tue, Oct 20, 2015 at 1:36 PM, Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
>> wrote:
>>>
>>> +/*
>>> + * In task isolation mode we try to return to userspace only after
>>> + * attempting to make sure we won't be interrupted again.  To handle
>>> + * the periodic scheduler tick, we test to make sure that the tick is
>>> + * stopped, and if it isn't yet, we request a reschedule so that if
>>> + * another task needs to run to completion first, it can do so.
>>> + * Similarly, if any other subsystems require quiescing, we will need
>>> + * to do that before we return to userspace.
>>> + */
>>> +bool _task_isolation_ready(void)
>>> +{
>>> +       WARN_ON_ONCE(!irqs_disabled());
>>> +
>>> +       /* If we need to drain the LRU cache, we're not ready. */
>>> +       if (lru_add_drain_needed(smp_processor_id()))
>>> +               return false;
>>> +
>>> +       /* If vmstats need updating, we're not ready. */
>>> +       if (!vmstat_idle())
>>> +               return false;
>>> +
>>> +       /* If the tick is running, request rescheduling; we're not ready.
>>> */
>>> +       if (!tick_nohz_tick_stopped()) {
>>> +               set_tsk_need_resched(current);
>>> +               return false;
>>> +       }
>>> +
>>> +       return true;
>>> +}
>>
>> I still don't get why this is a loop.
>
>
> You mean, why is this code called from prepare_exit_to_userspace()
> in the loop, instead of after the loop?  It's because the actual functions
> that clean up the LRU, vmstat worker, etc., may need interrupts enabled,
> may reschedule internally, etc.  (refresh_cpu_vm_stats() calls
> cond_resched(), for example.)

Yuck.  I guess that's a reasonable argument, although it could also be fixed.

>  Even more importantly, we rely on
> rescheduling to take care of the fact that the scheduler tick may still
> be running, and therefore loop back to the schedule() call that's run
> when TIF_NEED_RESCHED gets set.

This just seems like a mis-design.  We don't know why the scheduler
tick is on, so we're just going to reschedule until the problem goes
away?

>
>> BTW, should isolation just be a scheduler class (SCHED_ISOLATED)?
>
>
> So a scheduler class is an interesting idea certainly, although not
> one I know immediately how to implement.  I'm not sure whether
> it makes sense to require a user be root or have a suitable rtprio
> rlimit, but perhaps so.  The nice thing about the current patch
> series is that you can affinitize yourself to a nohz_full core and
> declare that you want to run task-isolated, and none of that
> requires root nor really is there a reason it should.

Your patches more or less implement "don't run me unless I'm
isolated".  A scheduler class would be more like "isolate me (and
maybe make me super high priority so it actually happens)".

I'm not a scheduler person, so I don't know.  But "don't run me unless
I'm isolated" seems like a design that will, at best, only ever work
by dumb luck.  You have to disable migration, avoid other runnable
tasks, hope that the kernel keeps working the way it did when you
wrote the patch, hope you continue to get lucky enough that you ever
get to user mode in the first place, etc.

--Andy
