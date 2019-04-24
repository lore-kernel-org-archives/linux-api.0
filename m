From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v17 1/3] proc: add /proc/<pid>/arch_status
Date: Wed, 24 Apr 2019 23:18:04 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1904242310040.1762@nanos.tec.linutronix.de>
References: <20190421183529.9141-1-aubrey.li@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190421183529.9141-1-aubrey.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aubrey Li <aubrey.li@linux.intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, hpa@zytor.com, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, akpm@linux-foundation.org, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, 22 Apr 2019, Aubrey Li wrote:
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 5ad92419be19..d5a9c5ddd453 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -208,6 +208,7 @@ config X86
>  	select USER_STACKTRACE_SUPPORT
>  	select VIRT_TO_BUS
>  	select X86_FEATURE_NAMES		if PROC_FS
> +	select PROC_PID_ARCH_STATUS		if PROC_FS

Can you please stop mixing arch and proc code? There is no point in
enabling this on x86 right away.

> +
> +config PROC_PID_ARCH_STATUS
> +	bool "Enable /proc/<pid>/arch_status file"

Why is this switchable? x86 selects it if PROC_FS is enabled and all other
architectures are absolutely not interested in this.

> +	default n
> +	help
> +	  Provides a way to examine process architecture specific information.
> +	  See <file:Documentation/filesystems/proc.txt> for more information.

Which contains zero information about this file when only this patch is
applied. 

> @@ -94,6 +94,7 @@
>  #include <linux/sched/debug.h>
>  #include <linux/sched/stat.h>
>  #include <linux/posix-timers.h>
> +#include <linux/processor.h>

That include is required because it does NOT contain anything useful for
this, right?

> +/*
> + * Add support for task architecture specific output in /proc/pid/arch_status.
> + * task_arch_status() must be defined in asm/processor.h
> + */
> +#ifdef CONFIG_PROC_PID_ARCH_STATUS
> +# ifndef task_arch_status
> +# define task_arch_status(m, task)
> +# endif

What exactly is the point of this macro mess? If an architecture selects
CONFIG_PROC_PID_ARCH_STATUS then it has to provide proc_task_arch_status()
and the prototype should be in include/linux/proc_fs.h.

> +static int proc_pid_arch_status(struct seq_file *m, struct pid_namespace *ns,
> +				struct pid *pid, struct task_struct *task)
> +{
> +	task_arch_status(m, task);
> +	return 0;
> +}
> +#endif /* CONFIG_PROC_PID_ARCH_STATUS */

Thanks,

	tglx
