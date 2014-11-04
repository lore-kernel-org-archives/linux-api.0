From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] kernel, add panic_on_warn
Date: Tue,  4 Nov 2014 10:41:28 -0500
Message-ID: <1415115688-12239-1-git-send-email-prarit@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

There have been several times where I have had to rebuild a kernel to
cause a panic when hitting a WARN() in the code in order to get a crash
dump from a system.  Sometimes this is easy to do, other times (such as
in the case of a remote admin) it is not trivial to send new images to the
user.

A much easier method would be a switch to change the WARN() over to a
panic.  This makes debugging easier in that I can now test the actual
image the WARN() was seen on and I do not have to engage in remote
debugging.

This patch adds a panic_on_warn kernel parameter and
/proc/sys/kernel/panic_on_warn calls panic() in the warn_slowpath_common()
path.  The function will still print out the location of the warning.

An example of the panic_on_warn output:

The first line below is from the WARN_ON() to output the WARN_ON()'s location.
After that the panic() output is displayed.

WARNING: CPU: 30 PID: 11698 at /home/prarit/dummy_module/dummy-module.c:25 init_dummy+0x1f/0x30 [dummy_module]()
Kernel panic - not syncing: panic_on_warn set ...

CPU: 30 PID: 11698 Comm: insmod Tainted: G        W  OE  3.17.0+ #57
Hardware name: Intel Corporation S2600CP/S2600CP, BIOS RMLSDP.86I.00.29.D696.1311111329 11/11/2013
 0000000000000000 000000008e3f87df ffff88080f093c38 ffffffff81665190
 0000000000000000 ffffffff818aea3d ffff88080f093cb8 ffffffff8165e2ec
 ffffffff00000008 ffff88080f093cc8 ffff88080f093c68 000000008e3f87df
Call Trace:
 [<ffffffff81665190>] dump_stack+0x46/0x58
 [<ffffffff8165e2ec>] panic+0xd0/0x204
 [<ffffffffa038e05f>] ? init_dummy+0x1f/0x30 [dummy_module]
 [<ffffffff81076b90>] warn_slowpath_common+0xd0/0xd0
 [<ffffffffa038e040>] ? dummy_greetings+0x40/0x40 [dummy_module]
 [<ffffffff81076c8a>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa038e05f>] init_dummy+0x1f/0x30 [dummy_module]
 [<ffffffff81002144>] do_one_initcall+0xd4/0x210
 [<ffffffff811b52c2>] ? __vunmap+0xc2/0x110
 [<ffffffff810f8889>] load_module+0x16a9/0x1b30
 [<ffffffff810f3d30>] ? store_uevent+0x70/0x70
 [<ffffffff810f49b9>] ? copy_module_from_fd.isra.44+0x129/0x180
 [<ffffffff810f8ec6>] SyS_finit_module+0xa6/0xd0
 [<ffffffff8166cf29>] system_call_fastpath+0x12/0x17

Successfully tested by me.

Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
Cc: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org
Cc: jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

[v2]: add /proc/sys/kernel/panic_on_warn, additional documentation, modify
      !slowpath cases
[v3]: use proc_dointvec_minmax() in sysctl handler
[v4]: remove !slowpath cases, and add __read_mostly
[v5]: change to panic_on_warn, re-alphabetize Documentation/sysctl/kernel.txt
[v6]: disable on kdump kernel to avoid bogus panicks.
[v7]: swithch to core param, and remove change from v6
---
 Documentation/kdump/kdump.txt       |    7 ++++++
 Documentation/kernel-parameters.txt |    3 +++
 Documentation/sysctl/kernel.txt     |   40 +++++++++++++++++++++++------------
 include/linux/kernel.h              |    1 +
 include/uapi/linux/sysctl.h         |    1 +
 kernel/panic.c                      |   15 ++++++++++++-
 kernel/sysctl.c                     |    9 ++++++++
 kernel/sysctl_binary.c              |    1 +
 8 files changed, 62 insertions(+), 15 deletions(-)

diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
index 6c0b9f2..bc4bd5a 100644
--- a/Documentation/kdump/kdump.txt
+++ b/Documentation/kdump/kdump.txt
@@ -471,6 +471,13 @@ format. Crash is available on Dave Anderson's site at the following URL:
 
    http://people.redhat.com/~anderson/
 
+Trigger Kdump on WARN()
+=======================
+
+The kernel parameter, panic_on_warn, calls panic() in all WARN() paths.  This
+will cause a kdump to occur at the panic() call.  In cases where a user wants
+to specify this during runtime, /proc/sys/kernel/panic_on_warn can be set to 1
+to achieve the same behaviour.
 
 Contact
 =======
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4c81a86..ea5d57c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2509,6 +2509,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			timeout < 0: reboot immediately
 			Format: <timeout>
 
+	panic_on_warn	panic() instead of WARN().  Useful to cause kdump
+			on a WARN().
+
 	crash_kexec_post_notifiers
 			Run kdump after running panic-notifiers and dumping
 			kmsg. This only for the users who doubt kdump always
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 57baff5..b5d0c85 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -54,8 +54,9 @@ show up in /proc/sys/kernel:
 - overflowuid
 - panic
 - panic_on_oops
-- panic_on_unrecovered_nmi
 - panic_on_stackoverflow
+- panic_on_unrecovered_nmi
+- panic_on_warn
 - pid_max
 - powersave-nap               [ PPC only ]
 - printk
@@ -527,19 +528,6 @@ the recommended setting is 60.
 
 ==============================================================
 
-panic_on_unrecovered_nmi:
-
-The default Linux behaviour on an NMI of either memory or unknown is
-to continue operation. For many environments such as scientific
-computing it is preferable that the box is taken out and the error
-dealt with than an uncorrected parity/ECC error get propagated.
-
-A small number of systems do generate NMI's for bizarre random reasons
-such as power management so the default is off. That sysctl works like
-the existing panic controls already in that directory.
-
-==============================================================
-
 panic_on_oops:
 
 Controls the kernel's behaviour when an oops or BUG is encountered.
@@ -563,6 +551,30 @@ This file shows up if CONFIG_DEBUG_STACKOVERFLOW is enabled.
 
 ==============================================================
 
+panic_on_unrecovered_nmi:
+
+The default Linux behaviour on an NMI of either memory or unknown is
+to continue operation. For many environments such as scientific
+computing it is preferable that the box is taken out and the error
+dealt with than an uncorrected parity/ECC error get propagated.
+
+A small number of systems do generate NMI's for bizarre random reasons
+such as power management so the default is off. That sysctl works like
+the existing panic controls already in that directory.
+
+==============================================================
+
+panic_on_warn:
+
+Calls panic() in the WARN() path when set to 1.  This is useful to avoid
+a kernel rebuild when attempting to kdump at the location of a WARN().
+
+0: only WARN(), default behaviour.
+
+1: call panic() after printing out WARN() location.
+
+==============================================================
+
 perf_cpu_time_max_percent:
 
 Hints to the kernel how much CPU time it should be allowed to
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3d770f55..d60d31d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -422,6 +422,7 @@ extern int panic_timeout;
 extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
 extern int panic_on_io_nmi;
+extern int panic_on_warn;
 extern int sysctl_panic_on_stackoverflow;
 /*
  * Only to be used by arch init code. If the user over-wrote the default
diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index 43aaba1..0956373 100644
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -153,6 +153,7 @@ enum
 	KERN_MAX_LOCK_DEPTH=74, /* int: rtmutex's maximum lock depth */
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_PANIC_ON_WARN=77, /* int: call panic() in WARN() functions */
 };
 
 
diff --git a/kernel/panic.c b/kernel/panic.c
index d09dc5c..db37c35 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -23,6 +23,7 @@
 #include <linux/sysrq.h>
 #include <linux/init.h>
 #include <linux/nmi.h>
+#include <linux/crash_dump.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -33,6 +34,7 @@ static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
 static bool crash_kexec_post_notifiers;
+int panic_on_warn __read_mostly;
 
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
@@ -420,13 +422,23 @@ static void warn_slowpath_common(const char *file, int line, void *caller,
 {
 	disable_trace_on_warning();
 
-	pr_warn("------------[ cut here ]------------\n");
+	if (!panic_on_warn)
+		pr_warn("------------[ cut here ]------------\n");
 	pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS()\n",
 		raw_smp_processor_id(), current->pid, file, line, caller);
 
 	if (args)
 		vprintk(args->fmt, args->args);
 
+	if (panic_on_warn) {
+		/*
+		 * A flood of WARN()s may occur.  Prevent further WARN()s
+		 * from panicking the system.
+		 */
+		panic_on_warn = 0;
+		panic("panic_on_warn set ...\n");
+	}
+
 	print_modules();
 	dump_stack();
 	print_oops_end_marker();
@@ -484,6 +496,7 @@ EXPORT_SYMBOL(__stack_chk_fail);
 
 core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
+core_param(panic_on_warn, panic_on_warn, int, 0644);
 
 static int __init setup_crash_kexec_post_notifiers(char *s)
 {
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 15f2511..7c54ff7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1104,6 +1104,15 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+	{
+		.procname	= "panic_on_warn",
+		.data		= &panic_on_warn,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 	{ }
 };
 
diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 9a4f750..7e7746a 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -137,6 +137,7 @@ static const struct bin_table bin_kern_table[] = {
 	{ CTL_INT,	KERN_COMPAT_LOG,		"compat-log" },
 	{ CTL_INT,	KERN_MAX_LOCK_DEPTH,		"max_lock_depth" },
 	{ CTL_INT,	KERN_PANIC_ON_NMI,		"panic_on_unrecovered_nmi" },
+	{ CTL_INT,	KERN_PANIC_ON_WARN,		"panic_on_warn" },
 	{}
 };
 
-- 
1.7.9.3
