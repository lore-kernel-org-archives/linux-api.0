From: Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] prctl,x86 Add PR_[GET|SET]_CPUID for controlling the CPUID instruction.
Date: Sun, 11 Sep 2016 17:29:23 -0700
Message-ID: <1473640169-24145-1-git-send-email-khuey@kylehuey.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert O'Callahan <robert-7ok7fSEJICeEi8DpZVb4nw@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "maintainer:X86 ARCHITECTURE 32-BIT AND 64-BIT" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Huang Rui <ray.huang-5C7GfCeVMHo@public.gmane.org>, Aravind Gopalakrishnan <Aravind.Gopalakrishnan-5C7GfCeVMHo@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Vladimir Zapolskiy <vladimir_zapolskiy-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys
List-Id: linux-api@vger.kernel.org

rr (http://rr-project.org/), a userspace record-and-replay reverse-
execution debugger, would like to trap and emulate the CPUID instruction.
This would allow us to a) mask away certain hardware features that rr does
not support (e.g. RDRAND) and b) enable trace portability across machines
by providing constant results.

Intel supports faulting on the CPUID instruction in newer processors. Bit
31 of MSR_PLATFORM_INFO advertises support for this feature. It is
documented in detail in Section 2.3.2 of
http://www.intel.com/content/dam/www/public/us/en/documents/application-notes/virtualization-technology-flexmigration-application-note.pdf.

I would like to thank Trevor Saunders <tbsaunde-lLNik5A/BD1g9hUCZPvPmw@public.gmane.org> for drafting
an earlier version of this patch.

Signed-off-by Kyle Huey <khuey-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
---
 arch/x86/include/asm/msr-index.h   |  1 +
 arch/x86/include/asm/processor.h   |  7 ++++
 arch/x86/include/asm/thread_info.h |  4 +-
 arch/x86/kernel/process.c          | 79 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/prctl.h         |  6 +++
 kernel/sys.c                       | 12 ++++++
 6 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 56f4c66..28b0736 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -52,6 +52,7 @@
 #define MSR_MTRRcap			0x000000fe
 #define MSR_IA32_BBL_CR_CTL		0x00000119
 #define MSR_IA32_BBL_CR_CTL3		0x0000011e
+#define MSR_MISC_FEATURES_ENABLES	0x00000140
 
 #define MSR_IA32_SYSENTER_CS		0x00000174
 #define MSR_IA32_SYSENTER_ESP		0x00000175
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 63def95..661c4c1 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -805,6 +805,13 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
 extern int get_tsc_mode(unsigned long adr);
 extern int set_tsc_mode(unsigned int val);
 
+/* Get/set a process' ability to use the CPUID instruction */
+#define GET_CPUID_CTL(adr)	get_cpuid_mode((adr))
+#define SET_CPUID_CTL(val)	set_cpuid_mode((val))
+
+extern int get_cpuid_mode(unsigned long adr);
+extern int set_cpuid_mode(unsigned int val);
+
 /* Register/unregister a process' MPX related resource */
 #define MPX_ENABLE_MANAGEMENT()	mpx_enable_management()
 #define MPX_DISABLE_MANAGEMENT()	mpx_disable_management()
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 8b7c8d8..ec93976 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -93,6 +93,7 @@ struct thread_info {
 #define TIF_SECCOMP		8	/* secure computing */
 #define TIF_USER_RETURN_NOTIFY	11	/* notify kernel of userspace return */
 #define TIF_UPROBE		12	/* breakpointed or singlestepping */
+#define TIF_NOCPUID		15	/* CPUID is not accessible in userland */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* IA32 compatibility process */
 #define TIF_FORK		18	/* ret_from_fork */
@@ -117,6 +118,7 @@ struct thread_info {
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_USER_RETURN_NOTIFY	(1 << TIF_USER_RETURN_NOTIFY)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
+#define _TIF_NOCPUID		(1 << TIF_NOCPUID)
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
@@ -146,7 +148,7 @@ struct thread_info {
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
-	(_TIF_IO_BITMAP|_TIF_NOTSC|_TIF_BLOCKSTEP)
+	(_TIF_IO_BITMAP|_TIF_NOCPUID|_TIF_NOTSC|_TIF_BLOCKSTEP)
 
 #define _TIF_WORK_CTXSW_PREV (_TIF_WORK_CTXSW|_TIF_USER_RETURN_NOTIFY)
 #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW)
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 62c0b0e..a189516 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -191,6 +191,76 @@ int set_tsc_mode(unsigned int val)
 	return 0;
 }
 
+static void hard_disable_CPUID(void)
+{
+	msr_set_bit(MSR_MISC_FEATURES_ENABLES, 0);
+}
+
+static void disable_CPUID(void)
+{
+	preempt_disable();
+	if (!test_and_set_thread_flag(TIF_NOCPUID))
+		/*
+		 * Must flip the CPU state synchronously with
+		 * TIF_NOCPUID in the current running context.
+		 */
+		hard_disable_CPUID();
+	preempt_enable();
+}
+
+static void hard_enable_CPUID(void)
+{
+	msr_clear_bit(MSR_MISC_FEATURES_ENABLES, 0);
+}
+
+static void enable_CPUID(void)
+{
+	preempt_disable();
+	if (test_and_clear_thread_flag(TIF_NOCPUID))
+		/*
+		 * Must flip the CPU state synchronously with
+		 * TIF_NOCPUID in the current running context.
+		 */
+		hard_enable_CPUID();
+	preempt_enable();
+}
+
+static int supports_CPUID_faulting(void)
+{
+	unsigned int lo, hi;
+
+	rdmsr(MSR_PLATFORM_INFO, lo, hi);
+	if ((lo & (1 << 31)))
+		return 1;
+	else
+		return 0;
+}
+
+int get_cpuid_mode(unsigned long adr)
+{
+	unsigned int val;
+
+	if (test_thread_flag(TIF_NOCPUID))
+		val = PR_CPUID_SIGSEGV;
+	else
+		val = PR_CPUID_ENABLE;
+
+	return put_user(val, (unsigned int __user *)adr);
+}
+
+int set_cpuid_mode(unsigned int val)
+{
+	// Only disable/enable_CPUID() if it is supported on this hardware.
+	if (val == PR_CPUID_SIGSEGV && supports_CPUID_faulting())
+		disable_CPUID();
+	else if (val == PR_CPUID_ENABLE && supports_CPUID_faulting())
+		enable_CPUID();
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
 void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		      struct tss_struct *tss)
 {
@@ -210,6 +280,15 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		update_debugctlmsr(debugctl);
 	}
 
+	if (test_tsk_thread_flag(prev_p, TIF_NOCPUID) ^
+	    test_tsk_thread_flag(next_p, TIF_NOCPUID)) {
+		/* prev and next are different */
+		if (test_tsk_thread_flag(next_p, TIF_NOCPUID))
+			hard_disable_CPUID();
+		else
+			hard_enable_CPUID();
+	}
+
 	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
 	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
 		/* prev and next are different */
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index a8d0759..641d12b 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -197,4 +197,10 @@ struct prctl_mm_map {
 # define PR_CAP_AMBIENT_LOWER		3
 # define PR_CAP_AMBIENT_CLEAR_ALL	4
 
+/* Get/set the process' ability to use the CPUID instruction */
+#define PR_GET_CPUID 48
+#define PR_SET_CPUID 49
+# define PR_CPUID_ENABLE		1	/* allow the use of the CPUID instruction */
+# define PR_CPUID_SIGSEGV		2	/* throw a SIGSEGV instead of reading the CPUID */
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 89d5be4..997c6519 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -91,6 +91,12 @@
 #ifndef SET_TSC_CTL
 # define SET_TSC_CTL(a)		(-EINVAL)
 #endif
+#ifndef GET_CPUID_CTL
+# define GET_CPUID_CTL(a)	(-EINVAL)
+#endif
+#ifndef SET_CPUID_CTL
+# define SET_CPUID_CTL(a)	(-EINVAL)
+#endif
 #ifndef MPX_ENABLE_MANAGEMENT
 # define MPX_ENABLE_MANAGEMENT()	(-EINVAL)
 #endif
@@ -2162,6 +2168,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	case PR_SET_TSC:
 		error = SET_TSC_CTL(arg2);
 		break;
+	case PR_GET_CPUID:
+		error = GET_CPUID_CTL(arg2);
+		break;
+	case PR_SET_CPUID:
+		error = SET_CPUID_CTL(arg2);
+		break;
 	case PR_TASK_PERF_EVENTS_DISABLE:
 		error = perf_event_task_disable();
 		break;
-- 
2.7.4
