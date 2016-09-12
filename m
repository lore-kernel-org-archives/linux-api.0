From: Kyle Huey <me@kylehuey.com>
Subject: Re: [PATCH] prctl,x86 Add PR_[GET|SET]_CPUID for controlling the
 CPUID instruction.
Date: Mon, 12 Sep 2016 07:15:16 -0700
Message-ID: <CAP045ArcuopWtoUTMFLW6zYse6OFX+SUDRqg=fn+Ty6vCPUJ8Q@mail.gmail.com>
References: <1473640169-24145-1-git-send-email-khuey@kylehuey.com> <20160912090722.2yal3mucf2x6j7pi@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160912090722.2yal3mucf2x6j7pi@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Cc: Robert O'Callahan <robert@ocallahan.org>, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Len Brown <len.brown@intel.com>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Huang Rui <ray.huang@amd.com>, Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Andy Lutomirski <luto@kernel.org>, Juergen Gross <jgross@suse.com>, Fenghua Yu <fenghua.yu@intel.com>, "Luis R. Rodriguez" <mcgrof@kernel>
List-Id: linux-api@vger.kernel.org

Thanks for the review!

On Mon, Sep 12, 2016 at 2:07 AM, Borislav Petkov <bp@suse.de> wrote:
> On Sun, Sep 11, 2016 at 05:29:23PM -0700, Kyle Huey wrote:
>> rr (http://rr-project.org/), a userspace record-and-replay reverse-
>> execution debugger, would like to trap and emulate the CPUID instruction.
>> This would allow us to a) mask away certain hardware features that rr does
>> not support (e.g. RDRAND) and b) enable trace portability across machines
>> by providing constant results.
>>
>> Intel supports faulting on the CPUID instruction in newer processors. Bit
>> 31 of MSR_PLATFORM_INFO advertises support for this feature. It is
>> documented in detail in Section 2.3.2 of
>> http://www.intel.com/content/dam/www/public/us/en/documents/application-notes/virtualization-technology-flexmigration-application-note.pdf.
>>
>> I would like to thank Trevor Saunders <tbsaunde@tbsaunde.org> for drafting
>> an earlier version of this patch.
>>
>> Signed-off-by Kyle Huey <khuey@kylehuey.com>
>> ---
>>  arch/x86/include/asm/msr-index.h   |  1 +
>>  arch/x86/include/asm/processor.h   |  7 ++++
>>  arch/x86/include/asm/thread_info.h |  4 +-
>>  arch/x86/kernel/process.c          | 79 ++++++++++++++++++++++++++++++++++++++
>>  include/uapi/linux/prctl.h         |  6 +++
>>  kernel/sys.c                       | 12 ++++++
>>  6 files changed, 108 insertions(+), 1 deletion(-)
>
> ...
>
>> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
>> index 62c0b0e..a189516 100644
>> --- a/arch/x86/kernel/process.c
>> +++ b/arch/x86/kernel/process.c
>> @@ -191,6 +191,76 @@ int set_tsc_mode(unsigned int val)
>>       return 0;
>>  }
>>
>> +static void hard_disable_CPUID(void)
>
> Why hard_disable? I don't see any soft_disable.

Copied from PR_SET_TSC. Would you prefer something like
disable_cpuid/disable_cpuid_and_set_flag for
hard_disable_CPUID/disable_CPUID?

> Also, I can't say that I like all that screaming "CPUID" :-)
>
> disable_cpuid() looks just fine to me too.

Ok.

>> +{
>> +     msr_set_bit(MSR_MISC_FEATURES_ENABLES, 0);
>> +}
>> +
>> +static void disable_CPUID(void)
>> +{
>> +     preempt_disable();
>> +     if (!test_and_set_thread_flag(TIF_NOCPUID))
>> +             /*
>> +              * Must flip the CPU state synchronously with
>> +              * TIF_NOCPUID in the current running context.
>> +              */
>> +             hard_disable_CPUID();
>> +     preempt_enable();
>> +}
>> +
>> +static void hard_enable_CPUID(void)
>> +{
>> +     msr_clear_bit(MSR_MISC_FEATURES_ENABLES, 0);
>> +}
>> +
>> +static void enable_CPUID(void)
>> +{
>> +     preempt_disable();
>> +     if (test_and_clear_thread_flag(TIF_NOCPUID))
>> +             /*
>> +              * Must flip the CPU state synchronously with
>> +              * TIF_NOCPUID in the current running context.
>> +              */
>> +             hard_enable_CPUID();
>> +     preempt_enable();
>> +}
>> +
>> +static int supports_CPUID_faulting(void)
>> +{
>> +     unsigned int lo, hi;
>> +
>> +     rdmsr(MSR_PLATFORM_INFO, lo, hi);
>
> rdmsr_safe()

Ok.

>> +     if ((lo & (1 << 31)))
>> +             return 1;
>> +     else
>> +             return 0;
>> +}
>>
>> +int get_cpuid_mode(unsigned long adr)
>> +{
>> +     unsigned int val;
>> +
>> +     if (test_thread_flag(TIF_NOCPUID))
>> +             val = PR_CPUID_SIGSEGV;
>> +     else
>> +             val = PR_CPUID_ENABLE;
>> +
>> +     return put_user(val, (unsigned int __user *)adr);
>> +}
>> +
>> +int set_cpuid_mode(unsigned int val)
>> +{
>> +     // Only disable/enable_CPUID() if it is supported on this hardware.
>
> Use /* ... */ for comments in the kernel.

Ok.

>> +     if (val == PR_CPUID_SIGSEGV && supports_CPUID_faulting())
>> +             disable_CPUID();
>> +     else if (val == PR_CPUID_ENABLE && supports_CPUID_faulting())
>> +             enable_CPUID();
>> +     else
>> +             return -EINVAL;
>> +
>> +     return 0;
>> +}
>> +
>>  void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
>>                     struct tss_struct *tss)
>>  {
>> @@ -210,6 +280,15 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
>>               update_debugctlmsr(debugctl);
>>       }
>>
>> +     if (test_tsk_thread_flag(prev_p, TIF_NOCPUID) ^
>> +         test_tsk_thread_flag(next_p, TIF_NOCPUID)) {
>> +             /* prev and next are different */
>> +             if (test_tsk_thread_flag(next_p, TIF_NOCPUID))
>> +                     hard_disable_CPUID();
>> +             else
>> +                     hard_enable_CPUID();
>> +     }
>> +
>
> Frankly, I can't say that I'm thrilled by this: if this is a niche
> feature which has only a very narrow usage for debugging, I'd much
> prefer if this whole thing were implemented with a static_key which was
> false on the majority of the systems so that __switch_to() tests it much
> cheaply.
>
> Then and only then if your debugger runs arch_prctl(), it would enable
> the key and then set_cpuid_mode() can query the MSR directly instead of
> using another flag in the thread_info flags.
>
> This would keep this niche feature out of the way of the hot paths.

My code is already in the slow path in __switch_to_xtra(), along with
other debugging features like TIF_BLOCKSTEP and TIF_NOTSC. Adding a
bit to the mask tested in __switch_to() shouldn't affect performance
of the hot path.

>>       if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
>>           test_tsk_thread_flag(next_p, TIF_NOTSC)) {
>>               /* prev and next are different */
>> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
>> index a8d0759..641d12b 100644
>> --- a/include/uapi/linux/prctl.h
>> +++ b/include/uapi/linux/prctl.h
>> @@ -197,4 +197,10 @@ struct prctl_mm_map {
>>  # define PR_CAP_AMBIENT_LOWER                3
>>  # define PR_CAP_AMBIENT_CLEAR_ALL    4
>>
>> +/* Get/set the process' ability to use the CPUID instruction */
>> +#define PR_GET_CPUID 48
>> +#define PR_SET_CPUID 49
>> +# define PR_CPUID_ENABLE             1       /* allow the use of the CPUID instruction */
>> +# define PR_CPUID_SIGSEGV            2       /* throw a SIGSEGV instead of reading the CPUID */
>> +
>>  #endif /* _LINUX_PRCTL_H */
>> diff --git a/kernel/sys.c b/kernel/sys.c
>> index 89d5be4..997c6519 100644
>> --- a/kernel/sys.c
>> +++ b/kernel/sys.c
>> @@ -91,6 +91,12 @@
>>  #ifndef SET_TSC_CTL
>>  # define SET_TSC_CTL(a)              (-EINVAL)
>>  #endif
>> +#ifndef GET_CPUID_CTL
>> +# define GET_CPUID_CTL(a)    (-EINVAL)
>> +#endif
>> +#ifndef SET_CPUID_CTL
>> +# define SET_CPUID_CTL(a)    (-EINVAL)
>> +#endif
>>  #ifndef MPX_ENABLE_MANAGEMENT
>>  # define MPX_ENABLE_MANAGEMENT()     (-EINVAL)
>>  #endif
>> @@ -2162,6 +2168,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>>       case PR_SET_TSC:
>>               error = SET_TSC_CTL(arg2);
>>               break;
>> +     case PR_GET_CPUID:
>> +             error = GET_CPUID_CTL(arg2);
>> +             break;
>> +     case PR_SET_CPUID:
>> +             error = SET_CPUID_CTL(arg2);
>> +             break;
>>       case PR_TASK_PERF_EVENTS_DISABLE:
>>               error = perf_event_task_disable();
>>               break;
>
> This whole fun should be in arch_prctl() as it is arch-specific.

Yeah, I was debating about that, and did it this way because of
PR_SET_TSC.  Will fix.

> And wherever it ends, it needs documenting in the man page.

Indeed.

Would like to reach consensus on the TIF vs. static key thing before
updating the patch.

Thanks!

- Kyle
