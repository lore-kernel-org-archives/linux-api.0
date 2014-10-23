From: Yasuaki Ishimatsu <isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH V2] kernel, add bug_on_warn
Date: Thu, 23 Oct 2014 09:39:32 +0900
Message-ID: <54484E44.3080904@jp.fujitsu.com>
References: <1413910077-9464-1-git-send-email-prarit@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413910077-9464-1-git-send-email-prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

(2014/10/22 1:47), Prarit Bhargava wrote:
> There have been several times where I have had to rebuild a kernel to
> cause a panic when hitting a WARN() in the code in order to get a crash
> dump from a system.  Sometimes this is easy to do, other times (such as
> in the case of a remote admin) it is not trivial to send new images to the
> user.
> 
> A much easier method would be a switch to change the WARN() over to a
> BUG().  This makes debugging easier in that I can now test the actual
> image the WARN() was seen on and I do not have to engage in remote
> debugging.
> 
> This patch adds a bug_on_warn kernel parameter, which calls BUG() in the
> warn_slowpath_common() path.  The function will still print out the
> location of the warning.
> 
> An example of the bug_on_warn output:
> 
> The first line below is from the WARN_ON() to output the WARN_ON()'s location.
> After that the new BUG() call is displayed.
> 
>   WARNING: CPU: 27 PID: 3204 at
> /home/rhel7/redhat/debug/dummy-module/dummy-module.c:25 init_dummy+0x28/0x30
> [dummy_module]()
>   bug_on_warn set, calling BUG()...
>   ------------[ cut here ]------------
>   kernel BUG at kernel/panic.c:434!
>   invalid opcode: 0000 [#1] SMP
>   Modules linked in: dummy_module(OE+) sg nfsv3 rpcsec_gss_krb5 nfsv4
> dns_resolver nfs fscache cfg80211 rfkill x86_pkg_temp_thermal intel_powerclamp
> coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel
> ghash_clmulni_intel igb iTCO_wdt aesni_intel iTCO_vendor_support lrw gf128mul
> sb_edac ptp edac_core glue_helper lpc_ich ioatdma pcspkr ablk_helper pps_core
> i2c_i801 mfd_core cryptd dca shpchp ipmi_si wmi ipmi_msghandler acpi_cpufreq
> nfsd auth_rpcgss nfs_acl lockd grace sunrpc xfs libcrc32c sr_mod cdrom sd_mod
> mgag200 syscopyarea sysfillrect sysimgblt i2c_algo_bit drm_kms_helper isci ttm
> drm libsas ahci libahci scsi_transport_sas libata i2c_core dm_mirror
> dm_region_hash dm_log dm_mod
>   CPU: 27 PID: 3204 Comm: insmod Tainted: G           OE  3.17.0+ #19
>   Hardware name: Intel Corporation S2600CP/S2600CP, BIOS
> RMLSDP.86I.00.29.D696.1311111329 11/11/2013
>   task: ffff880034e75160 ti: ffff8807fc5ac000 task.ti: ffff8807fc5ac000
>   RIP: 0010:[<ffffffff81076b81>]  [<ffffffff81076b81>] warn_slowpath_common+0xc1/0xd0
>   RSP: 0018:ffff8807fc5afc68  EFLAGS: 00010246
>   RAX: 0000000000000021 RBX: ffff8807fc5afcb0 RCX: 0000000000000000
>   RDX: 0000000000000000 RSI: ffff88081efee5f8 RDI: ffff88081efee5f8
>   RBP: ffff8807fc5afc98 R08: 0000000000000096 R09: 0000000000000000
>   R10: 0000000000000711 R11: ffff8807fc5af93e R12: ffffffffa0424070
>   R13: 0000000000000019 R14: ffffffffa0423068 R15: 0000000000000009
>   FS:  00007f2d4b034740(0000) GS:ffff88081efe0000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00007f2d4a99f3c0 CR3: 00000007fd88b000 CR4: 00000000001407e0
>   Stack:
>    ffff8807fc5afcb8 ffffffff8199f020 ffff88080e396160 0000000000000000
>    ffffffffa0423040 ffffffffa0425000 ffff8807fc5afd08 ffffffff81076be5
>    0000000000000008 ffffffffa0424053 ffff880700000018 ffff8807fc5afd18
>   Call Trace:
>    [<ffffffffa0423040>] ? dummy_greetings+0x40/0x40 [dummy_module]
>    [<ffffffff81076be5>] warn_slowpath_fmt+0x55/0x70
>    [<ffffffffa0423068>] init_dummy+0x28/0x30 [dummy_module]
>    [<ffffffff81002144>] do_one_initcall+0xd4/0x210
>    [<ffffffff811b52c2>] ? __vunmap+0xc2/0x110
>    [<ffffffff810f8889>] load_module+0x16a9/0x1b30
>    [<ffffffff810f3d30>] ? store_uevent+0x70/0x70
>    [<ffffffff810f49b9>] ? copy_module_from_fd.isra.44+0x129/0x180
>    [<ffffffff810f8ec6>] SyS_finit_module+0xa6/0xd0
>    [<ffffffff8166ce29>] system_call_fastpath+0x12/0x17
>   Code: c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 c7 c7 20 42 8a 81 31 c0 e8 fc
> 80 5e 00 eb 80 48 c7 c7 78 42 8a 81 31 c0 e8 ec 80 5e 00 <0f> 0b 66 66 66 66 2e
> 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55
>   RIP  [<ffffffff81076b81>] warn_slowpath_common+0xc1/0xd0
>    RSP <ffff8807fc5afc68>
>   ---[ end trace 428218934a12088b ]---
> 
> Successfully tested by me.
> 
> Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
> Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
> Cc: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
> Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org
> Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> [v2]: add /proc/sys/kernel/bug_on_warn, additional documentation, modify
>        !slowpath cases
> ---
>   Documentation/kdump/kdump.txt       |    7 +++++++
>   Documentation/kernel-parameters.txt |    3 +++
>   Documentation/sysctl/kernel.txt     |   12 ++++++++++++
>   include/asm-generic/bug.h           |   12 ++++++++++--
>   include/linux/kernel.h              |    1 +
>   include/uapi/linux/sysctl.h         |    1 +
>   kernel/panic.c                      |   21 ++++++++++++++++++++-
>   kernel/sysctl.c                     |    7 +++++++
>   kernel/sysctl_binary.c              |    1 +
>   9 files changed, 62 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
> index 6c0b9f2..a04ed72 100644
> --- a/Documentation/kdump/kdump.txt
> +++ b/Documentation/kdump/kdump.txt
> @@ -471,6 +471,13 @@ format. Crash is available on Dave Anderson's site at the following URL:
>   
>      http://people.redhat.com/~anderson/
>   
> +Trigger Kdump on WARN()
> +=======================
> +
> +The kernel parameter, bug_on_warn, calls BUG() in all WARN() paths.  This
> +will cause a kdump to occur at the BUG() call.  In cases where a user
> +wants to specify this during runtime, /proc/sys/kernel/bug_on_warn can be
> +set to 1 to achieve the same behaviour.
>   
>   Contact
>   =======
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 988160a..3890a3a 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -553,6 +553,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>   	bttv.pll=	See Documentation/video4linux/bttv/Insmod-options
>   	bttv.tuner=
>   
> +	bug_on_warn	BUG() instead of WARN().  Useful to cause kdump
> +			on a WARN().
> +
>   	bulk_remove=off	[PPC]  This parameter disables the use of the pSeries
>   			firmware feature for flushing multiple hpte entries
>   			at a time.
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 57baff5..dcadcdc 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -23,6 +23,7 @@ show up in /proc/sys/kernel:
>   - auto_msgmni
>   - bootloader_type	     [ X86 only ]
>   - bootloader_version	     [ X86 only ]
> +- bug_on_warn
>   - callhome		     [ S390 only ]
>   - cap_last_cap
>   - core_pattern
> @@ -152,6 +153,17 @@ Documentation/x86/boot.txt for additional information.
>   
>   ==============================================================
>   
> +bug_on_warn:
> +
> +Calls BUG() in the WARN() path when set to 1.  This is useful to avoid
> +a kernel rebuild when attempting to kdump at the location of a WARN().
> +
> +0: only WARN(), default behaviour.
> +
> +1: call BUG() after printing out WARN() location.
> +
> +==============================================================
> +
>   callhome:
>   
>   Controls the kernel's callhome behavior in case of a kernel panic.
> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> index 630dd23..4d0c763 100644
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -75,10 +75,18 @@ extern void warn_slowpath_null(const char *file, const int line);
>   #define __WARN_printf_taint(taint, arg...)				\
>   	warn_slowpath_fmt_taint(__FILE__, __LINE__, taint, arg)
>   #else
> -#define __WARN()		__WARN_TAINT(TAINT_WARN)
> +#define check_bug_on_warn()						\
> +	do {								\
> +		if (bug_on_warn)					\
> +			BUG();						\
> +	} while (0)
> +
> +#define __WARN()							\
> +	do { __WARN_TAINT(TAINT_WARN); check_bug_on_warn(); } while (0)
> +
>   #define __WARN_printf(arg...)	do { printk(arg); __WARN(); } while (0)
>   #define __WARN_printf_taint(taint, arg...)				\
> -	do { printk(arg); __WARN_TAINT(taint); } while (0)
> +	do { printk(arg); __WARN_TAINT(taint); check_bug_on_warn(); } while (0)
>   #endif
>   
>   #ifndef WARN_ON
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 40728cf..4094a60 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -422,6 +422,7 @@ extern int panic_on_oops;
>   extern int panic_on_unrecovered_nmi;
>   extern int panic_on_io_nmi;
>   extern int sysctl_panic_on_stackoverflow;
> +extern int bug_on_warn;
>   /*
>    * Only to be used by arch init code. If the user over-wrote the default
>    * CONFIG_PANIC_TIMEOUT, honor it.
> diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
> index 43aaba1..2ba0a58 100644
> --- a/include/uapi/linux/sysctl.h
> +++ b/include/uapi/linux/sysctl.h
> @@ -153,6 +153,7 @@ enum
>   	KERN_MAX_LOCK_DEPTH=74, /* int: rtmutex's maximum lock depth */
>   	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
>   	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
> +	KERN_BUG_ON_WARN=77, /* int: call BUG() in WARN() functions */
>   };
>   
>   
> diff --git a/kernel/panic.c b/kernel/panic.c
> index d09dc5c..a6d2e2f 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -33,6 +33,7 @@ static int pause_on_oops;
>   static int pause_on_oops_flag;
>   static DEFINE_SPINLOCK(pause_on_oops_lock);
>   static bool crash_kexec_post_notifiers;
> +int bug_on_warn;
>   
>   int panic_timeout = CONFIG_PANIC_TIMEOUT;
>   EXPORT_SYMBOL_GPL(panic_timeout);
> @@ -420,13 +421,24 @@ static void warn_slowpath_common(const char *file, int line, void *caller,
>   {
>   	disable_trace_on_warning();
>   
> -	pr_warn("------------[ cut here ]------------\n");
> +	if (!bug_on_warn)
> +		pr_warn("------------[ cut here ]------------\n");
>   	pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS()\n",
>   		raw_smp_processor_id(), current->pid, file, line, caller);
>   
>   	if (args)
>   		vprintk(args->fmt, args->args);
>   
> +	if (bug_on_warn) {
> +		pr_warn("bug_on_warn set, calling BUG()...\n");
> +		/*
> +		 * A flood of WARN()s may occur.  Prevent further WARN()s
> +		 * from panicking the system.
> +		 */
> +		bug_on_warn = 0;
> +		BUG();
> +	}
> +
>   	print_modules();
>   	dump_stack();
>   	print_oops_end_marker();
> @@ -501,3 +513,10 @@ static int __init oops_setup(char *s)
>   	return 0;
>   }
>   early_param("oops", oops_setup);
> +
> +static int __init bug_on_warn_setup(char *s)
> +{
> +	bug_on_warn = 1;
> +	return 0;
> +}
> +early_param("bug_on_warn", bug_on_warn_setup);
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 4aada6d..030bb5d 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1103,6 +1103,13 @@ static struct ctl_table kern_table[] = {
>   		.proc_handler	= proc_dointvec,
>   	},
>   #endif
> +	{
> +		.procname	= "bug_on_warn",
> +		.data		= &bug_on_warn,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,

> +		.proc_handler	= proc_dointvec,

How about use:
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = &zero,
+		.extra2         = &one,

Document says as follows but it can set other vaule.

> +0: only WARN(), default behaviour.
> +
> +1: call BUG() after printing out WARN() location.

Thanks,
Yasuaki Ishimatsu

> +	},
>   	{ }
>   };
>   
> diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
> index 9a4f750..28376bf 100644
> --- a/kernel/sysctl_binary.c
> +++ b/kernel/sysctl_binary.c
> @@ -137,6 +137,7 @@ static const struct bin_table bin_kern_table[] = {
>   	{ CTL_INT,	KERN_COMPAT_LOG,		"compat-log" },
>   	{ CTL_INT,	KERN_MAX_LOCK_DEPTH,		"max_lock_depth" },
>   	{ CTL_INT,	KERN_PANIC_ON_NMI,		"panic_on_unrecovered_nmi" },
> +	{ CTL_INT,	KERN_BUG_ON_WARN,		"bug_on_warn" },
>   	{}
>   };
>   
> 
