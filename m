From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Wed, 10 Aug 2016 01:10:31 -0700
Message-ID: <CALCETrUTpq6qX5SS170y_VtwiPc-SeR03bt-1Q98n+YMZMqopA@mail.gmail.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com>
 <20160803131940.GM6862@twins.programming.kicks-ass.net> <656745027.6624.1470773200334.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <656745027.6624.1470773200334.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Boqun Feng <boqun.feng@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 9, 2016 at 1:06 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> ----- On Aug 3, 2016, at 9:19 AM, Peter Zijlstra peterz@infradead.org wrote:
>

>>
>>> +#endif
>>>  /* CPU-specific state of this task */
>>>      struct thread_struct thread;
>>>  /*
>>> @@ -3387,4 +3392,67 @@ void cpufreq_add_update_util_hook(int cpu, struct
>>> update_util_data *data,
>>>  void cpufreq_remove_update_util_hook(int cpu);
>>>  #endif /* CONFIG_CPU_FREQ */
>>>
>>> +#ifdef CONFIG_RSEQ
>>> +static inline void rseq_set_notify_resume(struct task_struct *t)
>>> +{
>>> +    if (t->rseq)
>>> +            set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
>>> +}
>>
>> Maybe I missed it, but why do we want to hook into NOTIFY_RESUME and not
>> have our own TIF flag?
>
> The short answer is that used the same approach as Paul Turner's patchset. ;)
>
> Through a deeper look into this, the only times we set the flag is when
> preempting and delivering a signal to a thread that has registered to
> rseq.
>
> Upon return to user-space with the flag set, the performance difference
> between having our own flag and hopping into the NOTIFY_RESUME bandwagon
> is that we can skip the various tests in exit_to_usermode_loop()
> with our own flag, at the expense of crowding the thread flags even
> nearer to filling up 32 bits, which will at some point require extra
> tests on the fast-path.

I don't think we're anywhere near running out.  Several of those flags
can probably go away pretty easily, too.

>
> Thinking about it, one benchmark I have not done so far is to modify
> hackbench so it registers its threads with the rseq system call. We
> can then figure out whether reserving a flag for rseq is justified or
> not.
>
> Comparing 10 runs of hackbench registering its sender/receiver threads
> with unmodified hackbench: (hackbench -l 100000)
>
>     Configuration: 2 sockets * 8-core Intel(R) Xeon(R) CPU E5-2630 v3 @
>     2.40GHz (directly on hardware, hyperthreading disabled in BIOS, energy
>     saving disabled in BIOS, turboboost disabled in BIOS, cpuidle.off=1
>     kernel parameter), with a Linux v4.7 defconfig+localyesconfig,
>     restartable sequences series applied.
>
>                                     Avg. Time (s)    Std.dev. (s)
> Unmodified Hackbench                    40.5            0.1
> Rseq-Registered Hackbench Threads       40.4            0.1
>
> So initial results seems to indicate that adding the notify_resume
> handling upon preemption does not have noticeable effects on
> performance, so I don't consider it worthwhile to try optimizing
> it by reserving its own thread flag. Or perhaps am I missing something
> important here ?
>

I don't think so.  One benefit of using do_notify_resume would be less
arch code.

> Actually, we want copy_from_user() there. This executes upon
> resume to user-space, so we can take a page fault is needed, so
> no "inatomic" needed. I therefore suggest:

Running the code below via exit_to_usermode_loop...

>
> static bool rseq_get_rseq_cs(struct task_struct *t,
>                 void __user **start_ip,
>                 void __user **post_commit_ip,
>                 void __user **abort_ip)
> {
>         unsigned long ptr;
>         struct rseq_cs __user *urseq_cs;
>         struct rseq_cs rseq_cs;
>
>         if (__get_user(ptr, &t->rseq->rseq_cs))
>                 return false;
>         if (!ptr)
>                 return true;
> #ifdef CONFIG_COMPAT
>         if (in_compat_syscall()) {
>                 urseq_cs = compat_ptr((compat_uptr_t)ptr);
>                 if (copy_from_user(&rseq_cs, urseq_cs, sizeof(*rseq_cs)))
>                         return false;
>                 *start_ip = compat_ptr((compat_uptr_t)rseq_cs.start_ip);
>                 *post_commit_ip = compat_ptr((compat_uptr_t)rseq_cs.post_commit_ip);
>                 *abort_ip = compat_ptr((compat_uptr_t)rseq_cs.abort_ip);
>                 return true;
>         }
> #endif

...means that in_compat_syscall() is nonsense.  (It *works* there, but
I can't imagine that it does anything that is actually sensible for
this use.)

Can't you just define the ABI so that no compat junk is needed?
(Also, CRIU will thank you for doing that.)


>>> +SYSCALL_DEFINE2(rseq, struct rseq __user *, rseq, int, flags)
>>> +{
>>> +    if (unlikely(flags))
>>> +            return -EINVAL;
>>
>> (add whitespace)
>
> fixed.
>
>>
>>> +    if (!rseq) {
>>> +            if (!current->rseq)
>>> +                    return -ENOENT;
>>> +            return 0;
>>> +    }

This looks entirely wrong.  Setting rseq to NULL fails if it's already
NULL but silently does nothing if rseq is already set?  Surely it
should always succeed and it should actually do something if rseq is
set.


-- 
Andy Lutomirski
AMA Capital Management, LLC
