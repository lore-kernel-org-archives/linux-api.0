From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8] kernel, add panic_on_warn
Date: Wed, 5 Nov 2014 13:59:18 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1411051357050.31575@chino.kir.corp.google.com>
References: <1415187736-16242-1-git-send-email-prarit@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415187736-16242-1-git-send-email-prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org, jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 5 Nov 2014, Prarit Bhargava wrote:

> diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
> index 6c0b9f2..bc4bd5a 100644
> --- a/Documentation/kdump/kdump.txt
> +++ b/Documentation/kdump/kdump.txt
> @@ -471,6 +471,13 @@ format. Crash is available on Dave Anderson's site at the following URL:
>  
>     http://people.redhat.com/~anderson/
>  
> +Trigger Kdump on WARN()
> +=======================
> +
> +The kernel parameter, panic_on_warn, calls panic() in all WARN() paths.  This
> +will cause a kdump to occur at the panic() call.  In cases where a user wants
> +to specify this during runtime, /proc/sys/kernel/panic_on_warn can be set to 1
> +to achieve the same behaviour.
>  
>  Contact
>  =======
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 4c81a86..ea5d57c 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2509,6 +2509,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			timeout < 0: reboot immediately
>  			Format: <timeout>
>  
> +	panic_on_warn	panic() instead of WARN().  Useful to cause kdump
> +			on a WARN().
> +
>  	crash_kexec_post_notifiers
>  			Run kdump after running panic-notifiers and dumping
>  			kmsg. This only for the users who doubt kdump always
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 57baff5..b5d0c85 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -54,8 +54,9 @@ show up in /proc/sys/kernel:
>  - overflowuid
>  - panic
>  - panic_on_oops
> -- panic_on_unrecovered_nmi
>  - panic_on_stackoverflow
> +- panic_on_unrecovered_nmi
> +- panic_on_warn
>  - pid_max
>  - powersave-nap               [ PPC only ]
>  - printk
> @@ -527,19 +528,6 @@ the recommended setting is 60.
>  
>  ==============================================================
>  
> -panic_on_unrecovered_nmi:
> -
> -The default Linux behaviour on an NMI of either memory or unknown is
> -to continue operation. For many environments such as scientific
> -computing it is preferable that the box is taken out and the error
> -dealt with than an uncorrected parity/ECC error get propagated.
> -
> -A small number of systems do generate NMI's for bizarre random reasons
> -such as power management so the default is off. That sysctl works like
> -the existing panic controls already in that directory.
> -
> -==============================================================
> -
>  panic_on_oops:
>  
>  Controls the kernel's behaviour when an oops or BUG is encountered.
> @@ -563,6 +551,30 @@ This file shows up if CONFIG_DEBUG_STACKOVERFLOW is enabled.
>  
>  ==============================================================
>  
> +panic_on_unrecovered_nmi:
> +
> +The default Linux behaviour on an NMI of either memory or unknown is
> +to continue operation. For many environments such as scientific
> +computing it is preferable that the box is taken out and the error
> +dealt with than an uncorrected parity/ECC error get propagated.
> +
> +A small number of systems do generate NMI's for bizarre random reasons
> +such as power management so the default is off. That sysctl works like
> +the existing panic controls already in that directory.
> +
> +==============================================================
> +
> +panic_on_warn:
> +
> +Calls panic() in the WARN() path when set to 1.  This is useful to avoid
> +a kernel rebuild when attempting to kdump at the location of a WARN().
> +
> +0: only WARN(), default behaviour.
> +
> +1: call panic() after printing out WARN() location.
> +
> +==============================================================
> +
>  perf_cpu_time_max_percent:
>  
>  Hints to the kernel how much CPU time it should be allowed to
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 3d770f55..d60d31d 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -422,6 +422,7 @@ extern int panic_timeout;
>  extern int panic_on_oops;
>  extern int panic_on_unrecovered_nmi;
>  extern int panic_on_io_nmi;
> +extern int panic_on_warn;
>  extern int sysctl_panic_on_stackoverflow;
>  /*
>   * Only to be used by arch init code. If the user over-wrote the default
> diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
> index 43aaba1..0956373 100644
> --- a/include/uapi/linux/sysctl.h
> +++ b/include/uapi/linux/sysctl.h
> @@ -153,6 +153,7 @@ enum
>  	KERN_MAX_LOCK_DEPTH=74, /* int: rtmutex's maximum lock depth */
>  	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
>  	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
> +	KERN_PANIC_ON_WARN=77, /* int: call panic() in WARN() functions */
>  };
>  
>  
> diff --git a/kernel/panic.c b/kernel/panic.c
> index d09dc5c..c6a7723 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -33,6 +33,7 @@ static int pause_on_oops;
>  static int pause_on_oops_flag;
>  static DEFINE_SPINLOCK(pause_on_oops_lock);
>  static bool crash_kexec_post_notifiers;
> +int panic_on_warn __read_mostly;
>  
>  int panic_timeout = CONFIG_PANIC_TIMEOUT;
>  EXPORT_SYMBOL_GPL(panic_timeout);
> @@ -420,13 +421,23 @@ static void warn_slowpath_common(const char *file, int line, void *caller,
>  {
>  	disable_trace_on_warning();
>  
> -	pr_warn("------------[ cut here ]------------\n");
> +	if (!panic_on_warn)
> +		pr_warn("------------[ cut here ]------------\n");

Is this really necessary?

>  	pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS()\n",
>  		raw_smp_processor_id(), current->pid, file, line, caller);
>  
>  	if (args)
>  		vprintk(args->fmt, args->args);
>  
> +	if (panic_on_warn) {
> +		/*
> +		 * A flood of WARN()s may occur.  Prevent further WARN()s
> +		 * from panicking the system.
> +		 */

What synchronization is preventing this race and further WARN()s panicking 
the system?

> +		panic_on_warn = 0;
> +		panic("panic_on_warn set ...\n");
> +	}
> +
>  	print_modules();
>  	dump_stack();
>  	print_oops_end_marker();
