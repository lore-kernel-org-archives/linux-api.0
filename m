From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH v9] kernel, add panic_on_warn
Date: Wed, 12 Nov 2014 10:59:27 +0900
Message-ID: <5462BEFF.9060705@jp.fujitsu.com>
References: <1415709301-24783-1-git-send-email-prarit@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1415709301-24783-1-git-send-email-prarit@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Fabian Frederick <fabf@skynet.be>, vgoyal@redhat.com, jbaron@akamai.com, linux-doc@vger.kernel.org, kexec@lists.infradead.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

(2014/11/11 21:35), Prarit Bhargava wrote:
> There have been several times where I have had to rebuild a kernel to
> cause a panic when hitting a WARN() in the code in order to get a crash
> dump from a system.  Sometimes this is easy to do, other times (such as
> in the case of a remote admin) it is not trivial to send new images to the
> user.
> 
> A much easier method would be a switch to change the WARN() over to a
> panic.  This makes debugging easier in that I can now test the actual
> image the WARN() was seen on and I do not have to engage in remote
> debugging.
> 
> This patch adds a panic_on_warn kernel parameter and
> /proc/sys/kernel/panic_on_warn calls panic() in the warn_slowpath_common()
> path.  The function will still print out the location of the warning.
> 
> An example of the panic_on_warn output:
> 
> The first line below is from the WARN_ON() to output the WARN_ON()'s location.
> After that the panic() output is displayed.
> 
> WARNING: CPU: 30 PID: 11698 at /home/prarit/dummy_module/dummy-module.c:25 init_dummy+0x1f/0x30 [dummy_module]()
> Kernel panic - not syncing: panic_on_warn set ...
> 
> CPU: 30 PID: 11698 Comm: insmod Tainted: G        W  OE  3.17.0+ #57
> Hardware name: Intel Corporation S2600CP/S2600CP, BIOS RMLSDP.86I.00.29.D696.1311111329 11/11/2013
>   0000000000000000 000000008e3f87df ffff88080f093c38 ffffffff81665190
>   0000000000000000 ffffffff818aea3d ffff88080f093cb8 ffffffff8165e2ec
>   ffffffff00000008 ffff88080f093cc8 ffff88080f093c68 000000008e3f87df
> Call Trace:
>   [<ffffffff81665190>] dump_stack+0x46/0x58
>   [<ffffffff8165e2ec>] panic+0xd0/0x204
>   [<ffffffffa038e05f>] ? init_dummy+0x1f/0x30 [dummy_module]
>   [<ffffffff81076b90>] warn_slowpath_common+0xd0/0xd0
>   [<ffffffffa038e040>] ? dummy_greetings+0x40/0x40 [dummy_module]
>   [<ffffffff81076c8a>] warn_slowpath_null+0x1a/0x20
>   [<ffffffffa038e05f>] init_dummy+0x1f/0x30 [dummy_module]
>   [<ffffffff81002144>] do_one_initcall+0xd4/0x210
>   [<ffffffff811b52c2>] ? __vunmap+0xc2/0x110
>   [<ffffffff810f8889>] load_module+0x16a9/0x1b30
>   [<ffffffff810f3d30>] ? store_uevent+0x70/0x70
>   [<ffffffff810f49b9>] ? copy_module_from_fd.isra.44+0x129/0x180
>   [<ffffffff810f8ec6>] SyS_finit_module+0xa6/0xd0
>   [<ffffffff8166cf29>] system_call_fastpath+0x12/0x17
> 
> Successfully tested by me.
> 
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Fabian Frederick <fabf@skynet.be>
> Cc: vgoyal@redhat.com
> Cc: isimatu.yasuaki@jp.fujitsu.com
> Cc: jbaron@akamai.com
> Cc: linux-doc@vger.kernel.org
> Cc: kexec@lists.infradead.org
> Cc: linux-api@vger.kernel.org
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> 
> [v2]: add /proc/sys/kernel/panic_on_warn, additional documentation, modify
>        !slowpath cases
> [v3]: use proc_dointvec_minmax() in sysctl handler
> [v4]: remove !slowpath cases, and add __read_mostly
> [v5]: change to panic_on_warn, re-alphabetize Documentation/sysctl/kernel.txt
> [v6]: disable on kdump kernel to avoid bogus panicks.
> [v7]: swithch to core param, and remove change from v6
> [v8]: remove include file
> [v9]: restore cut line, and fix panic_on_warn comment
> ---
Looks goot to me.

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>   Documentation/kdump/kdump.txt       |    7 ++++++
>   Documentation/kernel-parameters.txt |    3 +++
>   Documentation/sysctl/kernel.txt     |   40 +++++++++++++++++++++++------------
>   include/linux/kernel.h              |    1 +
>   include/uapi/linux/sysctl.h         |    1 +
>   kernel/panic.c                      |   13 ++++++++++++
>   kernel/sysctl.c                     |    9 ++++++++
>   kernel/sysctl_binary.c              |    1 +
>   8 files changed, 61 insertions(+), 14 deletions(-)
> 
> diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
> index 6c0b9f2..bc4bd5a 100644
> --- a/Documentation/kdump/kdump.txt
> +++ b/Documentation/kdump/kdump.txt
> @@ -471,6 +471,13 @@ format. Crash is available on Dave Anderson's site at the following URL:
>   
>      http://people.redhat.com/~anderson/
>   
> +Trigger Kdump on WARN()
> +=======================
> +
> +The kernel parameter, panic_on_warn, calls panic() in all WARN() paths.  This
> +will cause a kdump to occur at the panic() call.  In cases where a user wants
> +to specify this during runtime, /proc/sys/kernel/panic_on_warn can be set to 1
> +to achieve the same behaviour.
>   
>   Contact
>   =======
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 4c81a86..ea5d57c 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2509,6 +2509,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>   			timeout < 0: reboot immediately
>   			Format: <timeout>
>   
> +	panic_on_warn	panic() instead of WARN().  Useful to cause kdump
> +			on a WARN().
> +
>   	crash_kexec_post_notifiers
>   			Run kdump after running panic-notifiers and dumping
>   			kmsg. This only for the users who doubt kdump always
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 57baff5..b5d0c85 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -54,8 +54,9 @@ show up in /proc/sys/kernel:
>   - overflowuid
>   - panic
>   - panic_on_oops
> -- panic_on_unrecovered_nmi
>   - panic_on_stackoverflow
> +- panic_on_unrecovered_nmi
> +- panic_on_warn
>   - pid_max
>   - powersave-nap               [ PPC only ]
>   - printk
> @@ -527,19 +528,6 @@ the recommended setting is 60.
>   
>   ==============================================================
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
>   panic_on_oops:
>   
>   Controls the kernel's behaviour when an oops or BUG is encountered.
> @@ -563,6 +551,30 @@ This file shows up if CONFIG_DEBUG_STACKOVERFLOW is enabled.
>   
>   ==============================================================
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
>   perf_cpu_time_max_percent:
>   
>   Hints to the kernel how much CPU time it should be allowed to
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 3d770f55..d60d31d 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -422,6 +422,7 @@ extern int panic_timeout;
>   extern int panic_on_oops;
>   extern int panic_on_unrecovered_nmi;
>   extern int panic_on_io_nmi;
> +extern int panic_on_warn;
>   extern int sysctl_panic_on_stackoverflow;
>   /*
>    * Only to be used by arch init code. If the user over-wrote the default
> diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
> index 43aaba1..0956373 100644
> --- a/include/uapi/linux/sysctl.h
> +++ b/include/uapi/linux/sysctl.h
> @@ -153,6 +153,7 @@ enum
>   	KERN_MAX_LOCK_DEPTH=74, /* int: rtmutex's maximum lock depth */
>   	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
>   	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
> +	KERN_PANIC_ON_WARN=77, /* int: call panic() in WARN() functions */
>   };
>   
>   
> diff --git a/kernel/panic.c b/kernel/panic.c
> index d09dc5c..f9412c0 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -33,6 +33,7 @@ static int pause_on_oops;
>   static int pause_on_oops_flag;
>   static DEFINE_SPINLOCK(pause_on_oops_lock);
>   static bool crash_kexec_post_notifiers;
> +int panic_on_warn __read_mostly;
>   
>   int panic_timeout = CONFIG_PANIC_TIMEOUT;
>   EXPORT_SYMBOL_GPL(panic_timeout);
> @@ -427,6 +428,17 @@ static void warn_slowpath_common(const char *file, int line, void *caller,
>   	if (args)
>   		vprintk(args->fmt, args->args);
>   
> +	if (panic_on_warn) {
> +		/*
> +		 * This thread may hit another WARN() in the panic path.
> +		 * Resetting this prevents additional WARN() from panicking the
> +		 * system on this thread.  Other threads are blocked by the
> +		 * panic_mutex in panic().
> +		 */
> +		panic_on_warn = 0;
> +		panic("panic_on_warn set ...\n");
> +	}
> +
>   	print_modules();
>   	dump_stack();
>   	print_oops_end_marker();
> @@ -484,6 +496,7 @@ EXPORT_SYMBOL(__stack_chk_fail);
>   
>   core_param(panic, panic_timeout, int, 0644);
>   core_param(pause_on_oops, pause_on_oops, int, 0644);
> +core_param(panic_on_warn, panic_on_warn, int, 0644);
>   
>   static int __init setup_crash_kexec_post_notifiers(char *s)
>   {
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 15f2511..7c54ff7 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1104,6 +1104,15 @@ static struct ctl_table kern_table[] = {
>   		.proc_handler	= proc_dointvec,
>   	},
>   #endif
> +	{
> +		.procname	= "panic_on_warn",
> +		.data		= &panic_on_warn,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= &zero,
> +		.extra2		= &one,
> +	},
>   	{ }
>   };
>   
> diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
> index 9a4f750..7e7746a 100644
> --- a/kernel/sysctl_binary.c
> +++ b/kernel/sysctl_binary.c
> @@ -137,6 +137,7 @@ static const struct bin_table bin_kern_table[] = {
>   	{ CTL_INT,	KERN_COMPAT_LOG,		"compat-log" },
>   	{ CTL_INT,	KERN_MAX_LOCK_DEPTH,		"max_lock_depth" },
>   	{ CTL_INT,	KERN_PANIC_ON_NMI,		"panic_on_unrecovered_nmi" },
> +	{ CTL_INT,	KERN_PANIC_ON_WARN,		"panic_on_warn" },
>   	{}
>   };
>   
> 


