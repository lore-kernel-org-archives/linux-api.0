From: Markos Chandras <Markos.Chandras-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] MIPS,prctl: add PR_[GS]ET_FP_MODE prctl options for MIPS
Date: Tue, 13 Jan 2015 13:12:22 +0000
Message-ID: <54B519B6.5040604@imgtec.com>
References: <1420719457-690-1-git-send-email-paul.burton@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1420719457-690-1-git-send-email-paul.burton-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Burton <paul.burton-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org
Cc: Matthew Fortune <matthew.fortune-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 01/08/2015 12:17 PM, Paul Burton wrote:
> Userland code may be built using an ABI which permits linking to objects
> that have more restrictive floating point requirements. For example,
> userland code may be built to target the O32 FPXX ABI. Such code may be
> linked with other FPXX code, or code built for either one of the more
> restrictive FP32 or FP64. When linking with more restrictive code, the
> overall requirement of the process becomes that of the more restrictive
> code. The kernel has no way to know in advance which mode the process
> will need to be executed in, and indeed it may need to change during
> execution. The dynamic loader is the only code which will know the
> overall required mode, and so it needs to have a means to instruct the
> kernel to switch the FP mode of the process.
> 
> This patch introduces 2 new options to the prctl syscall which provide
> such a capability. The FP mode of the process is represented as a
> simple bitmask combining a number of mode bits mirroring those present
> in the hardware. Userland can either retrieve the current FP mode of
> the process:
> 
>   mode = prctl(PR_GET_FP_MODE);
> 
> or modify the current FP mode of the process:
> 
>   err = prctl(PR_SET_FP_MODE, new_mode);
> 
> Signed-off-by: Paul Burton <paul.burton-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
> Cc: Matthew Fortune <matthew.fortune-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
> Cc: Markos Chandras <markos.chandras-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Hi,

I think the "MIPS,prctl" in the title should be "MIPS: prctl"

I have also CC'd the LKML and the linux-api mailing lists since this
touches the kernel ABI with the new PR_[GS]ET_FP_MODE definitions.

(I intentionally leave the contents of the patch below so people can
comment on it)

> ---
>  arch/mips/include/asm/mmu.h         |  3 ++
>  arch/mips/include/asm/mmu_context.h |  2 +
>  arch/mips/include/asm/processor.h   | 11 +++++
>  arch/mips/kernel/process.c          | 92 +++++++++++++++++++++++++++++++++++++
>  arch/mips/kernel/traps.c            | 19 ++++++++
>  include/uapi/linux/prctl.h          |  5 ++
>  kernel/sys.c                        | 12 +++++
>  7 files changed, 144 insertions(+)
> 
> diff --git a/arch/mips/include/asm/mmu.h b/arch/mips/include/asm/mmu.h
> index c436138..1afa1f9 100644
> --- a/arch/mips/include/asm/mmu.h
> +++ b/arch/mips/include/asm/mmu.h
> @@ -1,9 +1,12 @@
>  #ifndef __ASM_MMU_H
>  #define __ASM_MMU_H
>  
> +#include <linux/atomic.h>
> +
>  typedef struct {
>  	unsigned long asid[NR_CPUS];
>  	void *vdso;
> +	atomic_t fp_mode_switching;
>  } mm_context_t;
>  
>  #endif /* __ASM_MMU_H */
> diff --git a/arch/mips/include/asm/mmu_context.h b/arch/mips/include/asm/mmu_context.h
> index 2f82568..87f1107 100644
> --- a/arch/mips/include/asm/mmu_context.h
> +++ b/arch/mips/include/asm/mmu_context.h
> @@ -132,6 +132,8 @@ init_new_context(struct task_struct *tsk, struct mm_struct *mm)
>  	for_each_possible_cpu(i)
>  		cpu_context(i, mm) = 0;
>  
> +	atomic_set(&mm->context.fp_mode_switching, 0);
> +
>  	return 0;
>  }
>  
> diff --git a/arch/mips/include/asm/processor.h b/arch/mips/include/asm/processor.h
> index f1df4cb..9daa386 100644
> --- a/arch/mips/include/asm/processor.h
> +++ b/arch/mips/include/asm/processor.h
> @@ -399,4 +399,15 @@ unsigned long get_wchan(struct task_struct *p);
>  
>  #endif
>  
> +/*
> + * Functions & macros implementing the PR_GET_FP_MODE & PR_SET_FP_MODE options
> + * to the prctl syscall.
> + */
> +extern int mips_get_process_fp_mode(struct task_struct *task);
> +extern int mips_set_process_fp_mode(struct task_struct *task,
> +				    unsigned int value);
> +
> +#define GET_FP_MODE(task)		mips_get_process_fp_mode(task)
> +#define SET_FP_MODE(task,value)		mips_set_process_fp_mode(task, value)
> +
>  #endif /* _ASM_PROCESSOR_H */
> diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
> index eb76434..b732c0c 100644
> --- a/arch/mips/kernel/process.c
> +++ b/arch/mips/kernel/process.c
> @@ -25,6 +25,7 @@
>  #include <linux/completion.h>
>  #include <linux/kallsyms.h>
>  #include <linux/random.h>
> +#include <linux/prctl.h>
>  
>  #include <asm/asm.h>
>  #include <asm/bootinfo.h>
> @@ -550,3 +551,94 @@ void arch_trigger_all_cpu_backtrace(bool include_self)
>  {
>  	smp_call_function(arch_dump_stack, NULL, 1);
>  }
> +
> +int mips_get_process_fp_mode(struct task_struct *task)
> +{
> +	int value = 0;
> +
> +	if (!test_tsk_thread_flag(task, TIF_32BIT_FPREGS))
> +		value |= PR_FP_MODE_FR;
> +	if (test_tsk_thread_flag(task, TIF_HYBRID_FPREGS))
> +		value |= PR_FP_MODE_FRE;
> +
> +	return value;
> +}
> +
> +int mips_set_process_fp_mode(struct task_struct *task, unsigned int value)
> +{
> +	const unsigned int known_bits = PR_FP_MODE_FR | PR_FP_MODE_FRE;
> +	unsigned long switch_count;
> +	struct task_struct *t;
> +
> +	/* Check the value is valid */
> +	if (value & ~known_bits)
> +		return -EOPNOTSUPP;
> +
> +	/* Avoid inadvertently triggering emulation */
> +	if ((value & PR_FP_MODE_FR) && cpu_has_fpu &&
> +	    !(current_cpu_data.fpu_id & MIPS_FPIR_F64))
> +		return -EOPNOTSUPP;
> +	if ((value & PR_FP_MODE_FRE) && !cpu_has_fre)
> +		return -EOPNOTSUPP;
> +
> +	/* Save FP & vector context, then disable FPU & MSA */
> +	if (task->signal == current->signal)
> +		lose_fpu(1);
> +
> +	/* Prevent any threads from obtaining live FP context */
> +	atomic_set(&task->mm->context.fp_mode_switching, 1);
> +	smp_mb__after_atomic();
> +
> +	/*
> +	 * If there are multiple online CPUs then wait until all threads whose
> +	 * FP mode is about to change have been context switched. This approach
> +	 * allows us to only worry about whether an FP mode switch is in
> +	 * progress when FP is first used in a tasks time slice. Pretty much all
> +	 * of the mode switch overhead can thus be confined to cases where mode
> +	 * switches are actually occuring. That is, to here. However for the
> +	 * thread performing the mode switch it may take a while...
> +	 */
> +	if (num_online_cpus() > 1) {
> +		spin_lock_irq(&task->sighand->siglock);
> +
> +		for_each_thread(task, t) {
> +			if (t == current)
> +				continue;
> +
> +			switch_count = t->nvcsw + t->nivcsw;
> +
> +			do {
> +				spin_unlock_irq(&task->sighand->siglock);
> +				cond_resched();
> +				spin_lock_irq(&task->sighand->siglock);
> +			} while ((t->nvcsw + t->nivcsw) == switch_count);
> +		}
> +
> +		spin_unlock_irq(&task->sighand->siglock);
> +	}
> +
> +	/*
> +	 * There are now no threads of the process with live FP context, so it
> +	 * is safe to proceed with the FP mode switch.
> +	 */
> +	for_each_thread(task, t) {
> +		/* Update desired FP register width */
> +		if (value & PR_FP_MODE_FR) {
> +			clear_tsk_thread_flag(t, TIF_32BIT_FPREGS);
> +		} else {
> +			set_tsk_thread_flag(t, TIF_32BIT_FPREGS);
> +			clear_tsk_thread_flag(t, TIF_MSA_CTX_LIVE);
> +		}
> +
> +		/* Update desired FP single layout */
> +		if (value & PR_FP_MODE_FRE)
> +			set_tsk_thread_flag(t, TIF_HYBRID_FPREGS);
> +		else
> +			clear_tsk_thread_flag(t, TIF_HYBRID_FPREGS);
> +	}
> +
> +	/* Allow threads to use FP again */
> +	atomic_set(&task->mm->context.fp_mode_switching, 0);
> +
> +	return 0;
> +}
> diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
> index ad3d203..d5fbfb5 100644
> --- a/arch/mips/kernel/traps.c
> +++ b/arch/mips/kernel/traps.c
> @@ -1134,10 +1134,29 @@ static int default_cu2_call(struct notifier_block *nfb, unsigned long action,
>  	return NOTIFY_OK;
>  }
>  
> +static int wait_on_fp_mode_switch(atomic_t *p)
> +{
> +	/*
> +	 * The FP mode for this task is currently being switched. That may
> +	 * involve modifications to the format of this tasks FP context which
> +	 * make it unsafe to proceed with execution for the moment. Instead,
> +	 * schedule some other task.
> +	 */
> +	schedule();
> +	return 0;
> +}
> +
>  static int enable_restore_fp_context(int msa)
>  {
>  	int err, was_fpu_owner, prior_msa;
>  
> +	/*
> +	 * If an FP mode switch is currently underway, wait for it to
> +	 * complete before proceeding.
> +	 */
> +	wait_on_atomic_t(&current->mm->context.fp_mode_switching,
> +			 wait_on_fp_mode_switch, TASK_KILLABLE);
> +
>  	if (!used_math()) {
>  		/* First time FP context user. */
>  		preempt_disable();
> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> index 89f6350..31891d9 100644
> --- a/include/uapi/linux/prctl.h
> +++ b/include/uapi/linux/prctl.h
> @@ -185,4 +185,9 @@ struct prctl_mm_map {
>  #define PR_MPX_ENABLE_MANAGEMENT  43
>  #define PR_MPX_DISABLE_MANAGEMENT 44
>  
> +#define PR_SET_FP_MODE		45
> +#define PR_GET_FP_MODE		46
> +# define PR_FP_MODE_FR		(1 << 0)	/* 64b FP registers */
> +# define PR_FP_MODE_FRE		(1 << 1)	/* 32b compatibility */
> +
>  #endif /* _LINUX_PRCTL_H */
> diff --git a/kernel/sys.c b/kernel/sys.c
> index a8c9f5a..08b16bb 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -97,6 +97,12 @@
>  #ifndef MPX_DISABLE_MANAGEMENT
>  # define MPX_DISABLE_MANAGEMENT(a)	(-EINVAL)
>  #endif
> +#ifndef GET_FP_MODE
> +# define GET_FP_MODE(a)		(-EINVAL)
> +#endif
> +#ifndef SET_FP_MODE
> +# define SET_FP_MODE(a,b)	(-EINVAL)
> +#endif
>  
>  /*
>   * this is where the system-wide overflow UID and GID are defined, for
> @@ -2215,6 +2221,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>  	case PR_MPX_DISABLE_MANAGEMENT:
>  		error = MPX_DISABLE_MANAGEMENT(me);
>  		break;
> +	case PR_SET_FP_MODE:
> +		error = SET_FP_MODE(me, arg2);
> +		break;
> +	case PR_GET_FP_MODE:
> +		error = GET_FP_MODE(me);
> +		break;
>  	default:
>  		error = -EINVAL;
>  		break;
> 


-- 
markos
