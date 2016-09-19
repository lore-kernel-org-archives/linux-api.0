From: Kyle Huey <me-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v4 6/6] x86/arch_prctl Add ARCH_[GET|SET]_CPUID
Date: Sun, 18 Sep 2016 21:17:18 -0700
Message-ID: <20160919041718.4608-7-khuey@kylehuey.com>
References: <20160919041718.4608-1-khuey@kylehuey.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160919041718.4608-1-khuey-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert O'Callahan <robert-7ok7fSEJICeEi8DpZVb4nw@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Dmitry Safonov <dsafonov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Rafael J . Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, user-mode-linux-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, user-mode-linux-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Intel supports faulting on the CPUID instruction beginning with Ivy Bridge.
When enabled, the processor will fault on attempts to execute the CPUID
instruction with CPL>0. Exposing this feature to userspace will allow a
ptracer to trap and emulate the CPUID instruction.

When supported, this feature is controlled by toggling bit 0 of
MSR_MISC_FEATURES_ENABLES. It is documented in detail in Section 2.3.2 of
http://www.intel.com/content/dam/www/public/us/en/documents/application-notes/virtualization-technology-flexmigration-application-note.pdf

Implement a new pair of arch_prctls, available on both x86-32 and x86-64.

ARCH_GET_CPUID: Returns the current CPUID faulting state, either
  ARCH_CPUID_ENABLE or ARCH_CPUID_SIGSEGV. arg2 must be 0.

ARCH_SET_CPUID: Set the CPUID faulting state to arg2, which must be either
  ARCH_CPUID_ENABLE or ARCH_CPUID_SIGSEGV. Returns EINVAL if arg2 is
  another value or CPUID faulting is not supported on this system.

The state of the CPUID faulting flag is propagated across forks, but reset
upon exec.

Signed-off-by: Kyle Huey <khuey-OhBmq/TcCDJWk0Htik3J/w@public.gmane.org>
---
 arch/x86/include/asm/msr-index.h          |   1 +
 arch/x86/include/asm/thread_info.h        |   6 +-
 arch/x86/include/uapi/asm/prctl.h         |   6 +
 arch/x86/kernel/process.c                 |  94 +++++++++++-
 fs/exec.c                                 |   1 +
 include/linux/thread_info.h               |   4 +
 tools/testing/selftests/x86/Makefile      |   2 +-
 tools/testing/selftests/x86/cpuid-fault.c | 231 ++++++++++++++++++++++++++++++
 8 files changed, 342 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/x86/cpuid-fault.c

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 39aa563..cddefdd 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -53,6 +53,7 @@
 #define MSR_MTRRcap			0x000000fe
 #define MSR_IA32_BBL_CR_CTL		0x00000119
 #define MSR_IA32_BBL_CR_CTL3		0x0000011e
+#define MSR_MISC_FEATURES_ENABLES	0x00000140
 
 #define MSR_IA32_SYSENTER_CS		0x00000174
 #define MSR_IA32_SYSENTER_ESP		0x00000175
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 8b7c8d8..1bc79bc 100644
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
@@ -293,6 +295,8 @@ static inline bool in_ia32_syscall(void)
 extern void arch_task_cache_init(void);
 extern int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src);
 extern void arch_release_task_struct(struct task_struct *tsk);
+extern void arch_post_exec(void);
+#define arch_post_exec arch_post_exec
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* _ASM_X86_THREAD_INFO_H */
diff --git a/arch/x86/include/uapi/asm/prctl.h b/arch/x86/include/uapi/asm/prctl.h
index 3ac5032..c087e55 100644
--- a/arch/x86/include/uapi/asm/prctl.h
+++ b/arch/x86/include/uapi/asm/prctl.h
@@ -6,4 +6,10 @@
 #define ARCH_GET_FS 0x1003
 #define ARCH_GET_GS 0x1004
 
+/* Get/set the process' ability to use the CPUID instruction */
+#define ARCH_GET_CPUID 0x1005
+#define ARCH_SET_CPUID 0x1006
+# define ARCH_CPUID_ENABLE		1	/* allow the use of the CPUID instruction */
+# define ARCH_CPUID_SIGSEGV		2	/* throw a SIGSEGV instead of reading the CPUID */
+
 #endif /* _ASM_X86_PRCTL_H */
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 97aa104..3ac90eb 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -32,6 +32,7 @@
 #include <asm/tlbflush.h>
 #include <asm/mce.h>
 #include <asm/vm86.h>
+#include <asm/prctl.h>
 
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
@@ -191,6 +192,68 @@ int set_tsc_mode(unsigned int val)
 	return 0;
 }
 
+static void switch_cpuid_faulting(bool on)
+{
+	if (on)
+		msr_set_bit(MSR_MISC_FEATURES_ENABLES, 0);
+	else
+		msr_clear_bit(MSR_MISC_FEATURES_ENABLES, 0);
+}
+
+static void disable_cpuid(void)
+{
+	preempt_disable();
+	if (!test_and_set_thread_flag(TIF_NOCPUID))
+		/*
+		 * Must flip the CPU state synchronously with
+		 * TIF_NOCPUID in the current running context.
+		 */
+		switch_cpuid_faulting(true);
+	preempt_enable();
+}
+
+static void enable_cpuid(void)
+{
+	preempt_disable();
+	if (test_and_clear_thread_flag(TIF_NOCPUID))
+		/*
+		 * Must flip the CPU state synchronously with
+		 * TIF_NOCPUID in the current running context.
+		 */
+		switch_cpuid_faulting(false);
+	preempt_enable();
+}
+
+int get_cpuid_mode(void)
+{
+	return test_thread_flag(TIF_NOCPUID) ? ARCH_CPUID_SIGSEGV : ARCH_CPUID_ENABLE;
+}
+
+int set_cpuid_mode(struct task_struct *task, unsigned long val)
+{
+	/* Only disable_cpuid() if it is supported on this hardware. */
+	bool cpuid_fault_supported = static_cpu_has(X86_FEATURE_CPUID_FAULT);
+
+	if (val == ARCH_CPUID_ENABLE)
+		enable_cpuid();
+	else if (val == ARCH_CPUID_SIGSEGV && cpuid_fault_supported)
+		disable_cpuid();
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * Called immediately after a successful exec.
+ */
+void arch_post_exec(void)
+{
+	/* If cpuid was previously disabled for this task, re-enable it. */
+	if (test_thread_flag(TIF_NOCPUID))
+		enable_cpuid();
+}
+
 void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		      struct tss_struct *tss)
 {
@@ -210,6 +273,15 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 		update_debugctlmsr(debugctl);
 	}
 
+	if (test_tsk_thread_flag(prev_p, TIF_NOCPUID) ^
+	    test_tsk_thread_flag(next_p, TIF_NOCPUID)) {
+		/* prev and next are different */
+		if (test_tsk_thread_flag(next_p, TIF_NOCPUID))
+			switch_cpuid_faulting(true);
+		else
+			switch_cpuid_faulting(false);
+	}
+
 	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
 	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
 		/* prev and next are different */
@@ -570,5 +642,25 @@ unsigned long get_wchan(struct task_struct *p)
 
 long do_arch_prctl(struct task_struct *task, int code, unsigned long arg2)
 {
-	return -EINVAL;
+	int ret = 0;
+
+	switch (code) {
+	case ARCH_GET_CPUID: {
+		if (arg2 != 0)
+			ret = -EINVAL;
+		else
+			ret = get_cpuid_mode();
+		break;
+	}
+	case ARCH_SET_CPUID: {
+		ret = set_cpuid_mode(task, arg2);
+		break;
+	}
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
 }
diff --git a/fs/exec.c b/fs/exec.c
index 6fcfb3f..0272b7e 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1287,6 +1287,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 	else
 		set_dumpable(current->mm, suid_dumpable);
 
+	arch_post_exec();
 	perf_event_exec();
 	__set_task_comm(current, kbasename(bprm->filename), true);
 
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 2b5b10e..22a3f61 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -130,6 +130,10 @@ static inline void check_object_size(const void *ptr, unsigned long n,
 { }
 #endif /* CONFIG_HARDENED_USERCOPY */
 
+#ifndef arch_post_exec
+static inline void arch_post_exec(void) {}
+#endif
+
 #endif	/* __KERNEL__ */
 
 #endif /* _LINUX_THREAD_INFO_H */
diff --git a/tools/testing/selftests/x86/Makefile b/tools/testing/selftests/x86/Makefile
index 4f747ee..fbf34d3 100644
--- a/tools/testing/selftests/x86/Makefile
+++ b/tools/testing/selftests/x86/Makefile
@@ -5,7 +5,7 @@ include ../lib.mk
 .PHONY: all all_32 all_64 warn_32bit_failure clean
 
 TARGETS_C_BOTHBITS := single_step_syscall sysret_ss_attrs syscall_nt ptrace_syscall test_mremap_vdso \
-			check_initial_reg_state sigreturn ldt_gdt iopl mpx-mini-test
+			check_initial_reg_state sigreturn ldt_gdt iopl mpx-mini-test cpuid-fault
 TARGETS_C_32BIT_ONLY := entry_from_vm86 syscall_arg_fault test_syscall_vdso unwind_vdso \
 			test_FCMOV test_FCOMI test_FISTTP \
 			vdso_restorer
diff --git a/tools/testing/selftests/x86/cpuid-fault.c b/tools/testing/selftests/x86/cpuid-fault.c
new file mode 100644
index 0000000..b1ec908
--- /dev/null
+++ b/tools/testing/selftests/x86/cpuid-fault.c
@@ -0,0 +1,231 @@
+
+/*
+ * Tests for arch_prctl(ARCH_GET_CPUID, ...) / prctl(ARCH_SET_CPUID, ...)
+ *
+ * Basic test to test behaviour of ARCH_GET_CPUID and ARCH_SET_CPUID
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <signal.h>
+#include <inttypes.h>
+#include <cpuid.h>
+#include <err.h>
+#include <errno.h>
+#include <sys/wait.h>
+
+#include <sys/prctl.h>
+#include <linux/prctl.h>
+
+const char *cpuid_names[] = {
+	[0] = "[not set]",
+	[ARCH_CPUID_ENABLE] = "ARCH_CPUID_ENABLE",
+	[ARCH_CPUID_SIGSEGV] = "ARCH_CPUID_SIGSEGV",
+};
+
+int arch_prctl(int code, unsigned long arg2)
+{
+	return syscall(SYS_arch_prctl, code, arg2);
+}
+
+int cpuid(unsigned int *eax, unsigned int *ebx, unsigned int *ecx,
+	  unsigned int *edx)
+{
+	return __get_cpuid(0, eax, ebx, ecx, edx);
+}
+
+int do_child_exec_test(int eax, int ebx, int ecx, int edx)
+{
+	int cpuid_val = 0, child = 0, status = 0;
+
+	printf("arch_prctl(ARCH_GET_CPUID); ");
+
+	cpuid_val = arch_prctl(ARCH_GET_CPUID, 0);
+	if (cpuid_val < 0)
+		errx(1, "ARCH_GET_CPUID fails now, but not before?");
+
+	printf("cpuid_val == %s\n", cpuid_names[cpuid_val]);
+	if (cpuid_val != ARCH_CPUID_SIGSEGV)
+		errx(1, "How did cpuid get re-enabled on fork?");
+
+	if ((child = fork()) == 0) {
+		cpuid_val = arch_prctl(ARCH_GET_CPUID, 0);
+		if (cpuid_val < 0)
+			errx(1, "ARCH_GET_CPUID fails now, but not before?");
+
+		printf("cpuid_val == %s\n", cpuid_names[cpuid_val]);
+		if (cpuid_val != ARCH_CPUID_SIGSEGV)
+			errx(1, "How did cpuid get re-enabled on fork?");
+
+		printf("exec\n");
+		execl("/proc/self/exe", "cpuid-fault", "-early-return", NULL);
+	}
+
+	if (child != waitpid(child, &status, 0))
+		errx(1, "waitpid failed!?");
+
+	if (WEXITSTATUS(status) != 0)
+		errx(1, "Execed child exited abnormally");
+
+	return 0;
+}
+
+int child_received_signal;
+
+void child_sigsegv_cb(int sig)
+{
+	int cpuid_val = 0;
+
+	child_received_signal = 1;
+	printf("[ SIG_SEGV ]\n");
+	printf("arch_prctl(ARCH_GET_CPUID); ");
+
+	cpuid_val = arch_prctl(ARCH_GET_CPUID, 0);
+	if (cpuid_val < 0)
+		errx(1, "ARCH_GET_CPUID fails now, but not before?");
+
+	printf("cpuid_val == %s\n", cpuid_names[cpuid_val]);
+	printf("arch_prctl(ARCH_SET_CPUID, ARCH_CPUID_ENABLE)\n");
+	if (arch_prctl(ARCH_SET_CPUID, ARCH_CPUID_ENABLE) != 0)
+		exit(errno);
+
+	printf("cpuid() == ");
+}
+
+int do_child_test(void)
+{
+	unsigned int eax = 0, ebx = 0, ecx = 0, edx = 0;
+
+	signal(SIGSEGV, child_sigsegv_cb);
+
+	/* the child starts out with cpuid disabled, the signal handler
+	 * attempts to enable and retry
+	 */
+	printf("cpuid() == ");
+	cpuid(&eax, &ebx, &ecx, &edx);
+	printf("{%x, %x, %x, %x}\n", eax, ebx, ecx, edx);
+	return child_received_signal ? 0 : 42;
+}
+
+int signal_count;
+
+void sigsegv_cb(int sig)
+{
+	int cpuid_val = 0;
+
+	signal_count++;
+	printf("[ SIG_SEGV ]\n");
+	printf("arch_prctl(ARCH_GET_CPUID); ");
+
+	cpuid_val = arch_prctl(ARCH_GET_CPUID, 0);
+	if (cpuid_val < 0)
+		errx(1, "ARCH_GET_CPUID fails now, but not before?");
+
+	printf("cpuid_val == %s\n", cpuid_names[cpuid_val]);
+	printf("arch_prctl(ARC_SET_CPUID, ARCH_CPUID_ENABLE)\n");
+	if (arch_prctl(ARCH_SET_CPUID, ARCH_CPUID_ENABLE) != 0)
+		errx(1, "ARCH_SET_CPUID failed!");
+
+	printf("cpuid() == ");
+}
+
+int main(int argc, char **argv)
+{
+	int cpuid_val = 0, child = 0, status = 0;
+	unsigned int eax = 0, ebx = 0, ecx = 0, edx = 0;
+
+	signal(SIGSEGV, sigsegv_cb);
+	setvbuf(stdout, NULL, _IONBF, 0);
+
+	cpuid(&eax, &ebx, &ecx, &edx);
+	printf("cpuid() == {%x, %x, %x, %x}\n", eax, ebx, ecx, edx);
+	printf("arch_prctl(ARCH_GET_CPUID); ");
+
+	cpuid_val = arch_prctl(ARCH_GET_CPUID, 0);
+	if (cpuid_val < 0) {
+		if (errno == EINVAL) {
+			printf("ARCH_GET_CPUID is unsupported on this system.\n");
+			fflush(stdout);
+			exit(0); /* no ARCH_GET_CPUID on this system */
+		} else {
+			errx(errno, "ARCH_GET_CPUID failed unexpectedly!");
+		}
+	}
+
+	printf("cpuid_val == %s\n", cpuid_names[cpuid_val]);
+	cpuid(&eax, &ebx, &ecx, &edx);
+	printf("cpuid() == {%x, %x, %x, %x}\n", eax, ebx, ecx, edx);
+	printf("arch_prctl(ARCH_SET_CPUID, ARCH_CPUID_ENABLE)\n");
+
+	if (arch_prctl(ARCH_SET_CPUID, ARCH_CPUID_ENABLE) != 0) {
+		if (errno == EINVAL) {
+			printf("ARCH_SET_CPUID is unsupported on this system.");
+			exit(0); /* no ARCH_SET_CPUID on this system */
+		} else {
+			errx(errno, "ARCH_SET_CPUID failed unexpectedly!");
+		}
+	}
+
+
+	cpuid(&eax, &ebx, &ecx, &edx);
+	printf("cpuid() == {%x, %x, %x, %x}\n", eax, ebx, ecx, edx);
+	printf("arch_prctl(ARCH_SET_CPUID, ARCH_CPUID_SIGSEGV)\n");
+	fflush(stdout);
+
+	if (arch_prctl(ARCH_SET_CPUID, ARCH_CPUID_SIGSEGV) == -1)
+		errx(1, "ARCH_SET_CPUID failed!");
+
+	printf("cpuid() == ");
+	eax = ebx = ecx = edx = 0;
+	cpuid(&eax, &ebx, &ecx, &edx);
+	printf("{%x, %x, %x, %x}\n", eax, ebx, ecx, edx);
+	printf("arch_prctl(ARCH_SET_CPUID, ARCH_CPUID_SIGSEGV)\n");
+
+	if (signal_count != 1)
+		errx(1, "cpuid didn't fault!");
+
+	if (arch_prctl(ARCH_SET_CPUID, ARCH_CPUID_SIGSEGV) == -1)
+		errx(1, "ARCH_SET_CPUID failed!");
+
+	if (argc > 1)
+		exit(0); /* Don't run the whole test again if we were execed */
+
+	printf("do_child_test\n");
+	if ((child = fork()) == 0)
+		return do_child_test();
+
+	if (child != waitpid(child, &status, 0))
+		errx(1, "waitpid failed!?");
+
+	if (WEXITSTATUS(status) != 0)
+		errx(1, "Child exited abnormally!");
+
+	/* The child enabling cpuid should not have affected us */
+	printf("cpuid() == ");
+	eax = ebx = ecx = edx = 0;
+	cpuid(&eax, &ebx, &ecx, &edx);
+	printf("{%x, %x, %x, %x}\n", eax, ebx, ecx, edx);
+	printf("arch_prctl(ARCH_SET_CPUID, ARCH_CPUID_SIGSEGV)\n");
+
+	if (signal_count != 2)
+		errx(1, "cpuid didn't fault!");
+
+	if (arch_prctl(ARCH_SET_CPUID, ARCH_CPUID_SIGSEGV) == -1)
+		errx(1, "ARCH_SET_CPUID failed!");
+
+	/* Our ARCH_CPUID_SIGSEGV should not propagate through exec */
+	printf("do_child_exec_test\n");
+	fflush(stdout);
+	if ((child = fork()) == 0)
+		return do_child_exec_test(eax, ebx, ecx, edx);
+
+	if (child != waitpid(child, &status, 0))
+		errx(1, "waitpid failed!?");
+
+	if (WEXITSTATUS(status) != 0)
+		errx(1, "Child exited abnormally!");
+
+	printf("All tests passed!\n");
+	exit(EXIT_SUCCESS);
+}
-- 
2.9.3
