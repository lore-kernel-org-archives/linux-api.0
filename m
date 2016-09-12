From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] prctl,x86 Add PR_[GET|SET]_CPUID for controlling the
 CPUID instruction.
Date: Mon, 12 Sep 2016 11:07:22 +0200
Message-ID: <20160912090722.2yal3mucf2x6j7pi@pd.tnic>
References: <1473640169-24145-1-git-send-email-khuey@kylehuey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473640169-24145-1-git-send-email-khuey-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Cc: Robert O'Callahan <robert-7ok7fSEJICeEi8DpZVb4nw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Huang Rui <ray.huang-5C7GfCeVMHo@public.gmane.org>, Aravind Gopalakrishnan <Aravind.Gopalakrishnan-5C7GfCeVMHo@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Vladimir Zapolskiy <vladimir_zapolskiy-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Luis R. Rodriguez" <mcgrof@kernel.o>
List-Id: linux-api@vger.kernel.org

On Sun, Sep 11, 2016 at 05:29:23PM -0700, Kyle Huey wrote:
> rr (http://rr-project.org/), a userspace record-and-replay reverse-
> execution debugger, would like to trap and emulate the CPUID instruction.
> This would allow us to a) mask away certain hardware features that rr does
> not support (e.g. RDRAND) and b) enable trace portability across machines
> by providing constant results.
> 
> Intel supports faulting on the CPUID instruction in newer processors. Bit
> 31 of MSR_PLATFORM_INFO advertises support for this feature. It is
> documented in detail in Section 2.3.2 of
> http://www.intel.com/content/dam/www/public/us/en/documents/application-notes/virtualization-technology-flexmigration-application-note.pdf.
> 
> I would like to thank Trevor Saunders <tbsaunde-lLNik5A/BD1g9hUCZPvPmw@public.gmane.org> for drafting
> an earlier version of this patch.
> 
> Signed-off-by Kyle Huey <khuey-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
> ---
>  arch/x86/include/asm/msr-index.h   |  1 +
>  arch/x86/include/asm/processor.h   |  7 ++++
>  arch/x86/include/asm/thread_info.h |  4 +-
>  arch/x86/kernel/process.c          | 79 ++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/prctl.h         |  6 +++
>  kernel/sys.c                       | 12 ++++++
>  6 files changed, 108 insertions(+), 1 deletion(-)

...

> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 62c0b0e..a189516 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -191,6 +191,76 @@ int set_tsc_mode(unsigned int val)
>  	return 0;
>  }
>  
> +static void hard_disable_CPUID(void)

Why hard_disable? I don't see any soft_disable.

Also, I can't say that I like all that screaming "CPUID" :-)

disable_cpuid() looks just fine to me too.

> +{
> +	msr_set_bit(MSR_MISC_FEATURES_ENABLES, 0);
> +}
> +
> +static void disable_CPUID(void)
> +{
> +	preempt_disable();
> +	if (!test_and_set_thread_flag(TIF_NOCPUID))
> +		/*
> +		 * Must flip the CPU state synchronously with
> +		 * TIF_NOCPUID in the current running context.
> +		 */
> +		hard_disable_CPUID();
> +	preempt_enable();
> +}
> +
> +static void hard_enable_CPUID(void)
> +{
> +	msr_clear_bit(MSR_MISC_FEATURES_ENABLES, 0);
> +}
> +
> +static void enable_CPUID(void)
> +{
> +	preempt_disable();
> +	if (test_and_clear_thread_flag(TIF_NOCPUID))
> +		/*
> +		 * Must flip the CPU state synchronously with
> +		 * TIF_NOCPUID in the current running context.
> +		 */
> +		hard_enable_CPUID();
> +	preempt_enable();
> +}
> +
> +static int supports_CPUID_faulting(void)
> +{
> +	unsigned int lo, hi;
> +
> +	rdmsr(MSR_PLATFORM_INFO, lo, hi);

rdmsr_safe()

> +	if ((lo & (1 << 31)))
> +		return 1;
> +	else
> +		return 0;
> +}
>
> +int get_cpuid_mode(unsigned long adr)
> +{
> +	unsigned int val;
> +
> +	if (test_thread_flag(TIF_NOCPUID))
> +		val = PR_CPUID_SIGSEGV;
> +	else
> +		val = PR_CPUID_ENABLE;
> +
> +	return put_user(val, (unsigned int __user *)adr);
> +}
> +
> +int set_cpuid_mode(unsigned int val)
> +{
> +	// Only disable/enable_CPUID() if it is supported on this hardware.

Use /* ... */ for comments in the kernel.

> +	if (val == PR_CPUID_SIGSEGV && supports_CPUID_faulting())
> +		disable_CPUID();
> +	else if (val == PR_CPUID_ENABLE && supports_CPUID_faulting())
> +		enable_CPUID();
> +	else
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
>  		      struct tss_struct *tss)
>  {
> @@ -210,6 +280,15 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
>  		update_debugctlmsr(debugctl);
>  	}
>  
> +	if (test_tsk_thread_flag(prev_p, TIF_NOCPUID) ^
> +	    test_tsk_thread_flag(next_p, TIF_NOCPUID)) {
> +		/* prev and next are different */
> +		if (test_tsk_thread_flag(next_p, TIF_NOCPUID))
> +			hard_disable_CPUID();
> +		else
> +			hard_enable_CPUID();
> +	}
> +

Frankly, I can't say that I'm thrilled by this: if this is a niche
feature which has only a very narrow usage for debugging, I'd much
prefer if this whole thing were implemented with a static_key which was
false on the majority of the systems so that __switch_to() tests it much
cheaply.

Then and only then if your debugger runs arch_prctl(), it would enable
the key and then set_cpuid_mode() can query the MSR directly instead of
using another flag in the thread_info flags.

This would keep this niche feature out of the way of the hot paths.

>  	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
>  	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
>  		/* prev and next are different */
> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> index a8d0759..641d12b 100644
> --- a/include/uapi/linux/prctl.h
> +++ b/include/uapi/linux/prctl.h
> @@ -197,4 +197,10 @@ struct prctl_mm_map {
>  # define PR_CAP_AMBIENT_LOWER		3
>  # define PR_CAP_AMBIENT_CLEAR_ALL	4
>  
> +/* Get/set the process' ability to use the CPUID instruction */
> +#define PR_GET_CPUID 48
> +#define PR_SET_CPUID 49
> +# define PR_CPUID_ENABLE		1	/* allow the use of the CPUID instruction */
> +# define PR_CPUID_SIGSEGV		2	/* throw a SIGSEGV instead of reading the CPUID */
> +
>  #endif /* _LINUX_PRCTL_H */
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 89d5be4..997c6519 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -91,6 +91,12 @@
>  #ifndef SET_TSC_CTL
>  # define SET_TSC_CTL(a)		(-EINVAL)
>  #endif
> +#ifndef GET_CPUID_CTL
> +# define GET_CPUID_CTL(a)	(-EINVAL)
> +#endif
> +#ifndef SET_CPUID_CTL
> +# define SET_CPUID_CTL(a)	(-EINVAL)
> +#endif
>  #ifndef MPX_ENABLE_MANAGEMENT
>  # define MPX_ENABLE_MANAGEMENT()	(-EINVAL)
>  #endif
> @@ -2162,6 +2168,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  	case PR_SET_TSC:
>  		error = SET_TSC_CTL(arg2);
>  		break;
> +	case PR_GET_CPUID:
> +		error = GET_CPUID_CTL(arg2);
> +		break;
> +	case PR_SET_CPUID:
> +		error = SET_CPUID_CTL(arg2);
> +		break;
>  	case PR_TASK_PERF_EVENTS_DISABLE:
>  		error = perf_event_task_disable();
>  		break;

This whole fun should be in arch_prctl() as it is arch-specific.

And wherever it ends, it needs documenting in the man page.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
