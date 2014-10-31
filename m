From: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
Subject: Re: [PATCH V2] kernel, add bug_on_warn
Date: Fri, 31 Oct 2014 10:55:28 +1030
Message-ID: <87ppd984qv.fsf@rustcorp.com.au>
References: <1413910077-9464-1-git-send-email-prarit@redhat.com> <87bnp491b3.fsf@rustcorp.com.au> <54478367.7030505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54478367.7030505-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> On 10/22/2014 12:27 AM, Rusty Russell wrote:
>> Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>>> There have been several times where I have had to rebuild a kernel to
>>> cause a panic when hitting a WARN() in the code in order to get a crash
>>> dump from a system.  Sometimes this is easy to do, other times (such as
>>> in the case of a remote admin) it is not trivial to send new images to the
>>> user.
>> 
>> What about during early boot?
>
> Hi Rusty,
>
> I really don't have a use case for this in early boot.  The kernel boots, the
> initramfs, and then we run whatever init (systemd in my case).  A systemd script
> configures kexec for kdump and that point kdump is "armed".  Doing a bug_on_warn
> before this will simply result in a panicked system.  I don't get any "new"
> information FWIW as I get a stack trace, etc., in both the WARN() and BUG() cases.
>
>> 
>> I'd recommend you use core_param().  Less code, and can be set on
>> commandline.
>
> Is that a general request, or is it dependent on the answer above?  Of course I
> have no problem doing it either way.

Oops, I read your initial patch too lightly: I see you added both
a sysctl (which I saw) and an early_param (which I didn't).

I still think it should be a core_param, like so (untested!):

diff --git a/Documentation/kdump/kdump.txt b/Documentation/kdump/kdump.txt
index 6c0b9f27e465..cf16cbe9f544 100644
--- a/Documentation/kdump/kdump.txt
+++ b/Documentation/kdump/kdump.txt
@@ -471,6 +471,13 @@ format. Crash is available on Dave Anderson's site at the following URL:
 
    http://people.redhat.com/~anderson/
 
+Trigger Kdump on WARN()
+=======================
+
+The kernel parameter, bug_on_warn, calls BUG() in all WARN() paths.  This
+will cause a kdump to occur at the BUG() call.  In cases where a user
+wants to specify this during runtime, /sys/module/kernel/bug_on_warn can be
+set to 1 to achieve the same behaviour.
 
 Contact
 =======
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 74339c57b914..aa1d3198e987 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -553,6 +553,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	bttv.pll=	See Documentation/video4linux/bttv/Insmod-options
 	bttv.tuner=
 
+	bug_on_warn	BUG() instead of WARN().  Useful to cause kdump
+			on a WARN().
+
 	bulk_remove=off	[PPC]  This parameter disables the use of the pSeries
 			firmware feature for flushing multiple hpte entries
 			at a time.
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 630dd2372238..4d0c763862b0 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -75,10 +75,18 @@ extern void warn_slowpath_null(const char *file, const int line);
 #define __WARN_printf_taint(taint, arg...)				\
 	warn_slowpath_fmt_taint(__FILE__, __LINE__, taint, arg)
 #else
-#define __WARN()		__WARN_TAINT(TAINT_WARN)
+#define check_bug_on_warn()						\
+	do {								\
+		if (bug_on_warn)					\
+			BUG();						\
+	} while (0)
+
+#define __WARN()							\
+	do { __WARN_TAINT(TAINT_WARN); check_bug_on_warn(); } while (0)
+
 #define __WARN_printf(arg...)	do { printk(arg); __WARN(); } while (0)
 #define __WARN_printf_taint(taint, arg...)				\
-	do { printk(arg); __WARN_TAINT(taint); } while (0)
+	do { printk(arg); __WARN_TAINT(taint); check_bug_on_warn(); } while (0)
 #endif
 
 #ifndef WARN_ON
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3d770f5564b8..d583df09ee82 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -423,6 +423,7 @@ extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
 extern int panic_on_io_nmi;
 extern int sysctl_panic_on_stackoverflow;
+extern bool bug_on_warn;
 /*
  * Only to be used by arch init code. If the user over-wrote the default
  * CONFIG_PANIC_TIMEOUT, honor it.
diff --git a/kernel/panic.c b/kernel/panic.c
index d09dc5c32c67..3d345357fcc8 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -33,6 +33,7 @@ static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
 static bool crash_kexec_post_notifiers;
+bool bug_on_warn;
 
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
@@ -420,13 +421,24 @@ static void warn_slowpath_common(const char *file, int line, void *caller,
 {
 	disable_trace_on_warning();
 
-	pr_warn("------------[ cut here ]------------\n");
+	if (!bug_on_warn)
+		pr_warn("------------[ cut here ]------------\n");
 	pr_warn("WARNING: CPU: %d PID: %d at %s:%d %pS()\n",
 		raw_smp_processor_id(), current->pid, file, line, caller);
 
 	if (args)
 		vprintk(args->fmt, args->args);
 
+	if (bug_on_warn) {
+		pr_warn("bug_on_warn set, calling BUG()...\n");
+		/*
+		 * A flood of WARN()s may occur.  Prevent further WARN()s
+		 * from panicking the system.
+		 */
+		bug_on_warn = false;
+		BUG();
+	}
+
 	print_modules();
 	dump_stack();
 	print_oops_end_marker();
@@ -484,6 +496,7 @@ EXPORT_SYMBOL(__stack_chk_fail);
 
 core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
+core_param(bug_on_warn, bug_on_warn, bool, 0644);
 
 static int __init setup_crash_kexec_post_notifiers(char *s)
 {
