From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH 11/24] arm64: introduce is_a32_task and is_a32_thread (for AArch32 compat)
Date: Wed, 16 May 2018 11:18:56 +0300
Message-ID: <20180516081910.10067-12-ynorov@caviumnetworks.com>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Cc: Yury Norov <ynorov@caviumnetworks.com>, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, James Morse <james.morse@arm.com>, Joseph Myers <joseph@codesourcery.com>, Lin Yongting <linyongting@huawei.com>, Manuel Montezelo <manuel.montezelo@gmail.>
List-Id: linux-api@vger.kernel.org

Based on patch of Andrew Pinski.

This patch introduces is_a32_compat_task and is_a32_thread so it is
easier to say this is a a32 specific thread or a generic compat
thread/task.  Corresponding functions are located in <asm/is_compat.h>
to avoid mess in headers.

Some files include both <linux/compat.h> and <asm/compat.h>,
and this is wrong because <linux/compat.h> has <asm/compat.h> already
included. It was fixed too.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Andrew Pinski <Andrew.Pinski@caviumnetworks.com>
Signed-off-by: Bamvor Jian Zhang <bamv2005@gmail.com>
---
 arch/arm64/include/asm/compat.h      | 19 ++--------
 arch/arm64/include/asm/elf.h         | 10 +++---
 arch/arm64/include/asm/ftrace.h      |  2 +-
 arch/arm64/include/asm/is_compat.h   | 52 ++++++++++++++++++++++++++++
 arch/arm64/include/asm/processor.h   |  9 ++---
 arch/arm64/include/asm/syscall.h     |  2 +-
 arch/arm64/include/asm/thread_info.h |  2 +-
 arch/arm64/kernel/hw_breakpoint.c    |  8 ++---
 arch/arm64/kernel/perf_regs.c        |  2 +-
 arch/arm64/kernel/process.c          |  7 ++--
 arch/arm64/kernel/ptrace.c           | 11 +++---
 arch/arm64/kernel/signal.c           |  4 +--
 arch/arm64/kernel/traps.c            |  3 +-
 arch/arm64/mm/mmap.c                 |  2 +-
 14 files changed, 85 insertions(+), 48 deletions(-)
 create mode 100644 arch/arm64/include/asm/is_compat.h

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index c00c62e1a4a3..412d7c07a3dd 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -25,6 +25,8 @@
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
 
+#include <asm/is_compat.h>
+
 #define COMPAT_USER_HZ		100
 #ifdef __AARCH64EB__
 #define COMPAT_UTS_MACHINE	"armv8b\0\0"
@@ -234,23 +236,6 @@ struct compat_shmid64_ds {
 	compat_ulong_t __unused5;
 };
 
-static inline int is_compat_task(void)
-{
-	return test_thread_flag(TIF_32BIT);
-}
-
-static inline int is_compat_thread(struct thread_info *thread)
-{
-	return test_ti_thread_flag(thread, TIF_32BIT);
-}
-
-#else /* !CONFIG_COMPAT */
-
-static inline int is_compat_thread(struct thread_info *thread)
-{
-	return 0;
-}
-
 #endif /* CONFIG_COMPAT */
 #endif /* __KERNEL__ */
 #endif /* __ASM_COMPAT_H */
diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index fac1c4de7898..b4b10eefc667 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -16,6 +16,10 @@
 #ifndef __ASM_ELF_H
 #define __ASM_ELF_H
 
+#ifndef __ASSEMBLY__
+#include <linux/compat.h>
+#endif
+
 #include <asm/hwcap.h>
 
 /*
@@ -156,13 +160,9 @@ extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 				       int uses_interp);
 
 /* 1GB of VA */
-#ifdef CONFIG_COMPAT
-#define STACK_RND_MASK			(test_thread_flag(TIF_32BIT) ? \
+#define STACK_RND_MASK			(is_compat_task() ? \
 						0x7ff >> (PAGE_SHIFT - 12) : \
 						0x3ffff >> (PAGE_SHIFT - 12))
-#else
-#define STACK_RND_MASK			(0x3ffff >> (PAGE_SHIFT - 12))
-#endif
 
 #ifdef __AARCH64EB__
 #define COMPAT_ELF_PLATFORM		("v8b")
diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
index caa955f10e19..0feb28ad10dd 100644
--- a/arch/arm64/include/asm/ftrace.h
+++ b/arch/arm64/include/asm/ftrace.h
@@ -54,7 +54,7 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 #define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS
 static inline bool arch_trace_is_compat_syscall(struct pt_regs *regs)
 {
-	return is_compat_task();
+	return is_a32_compat_task();
 }
 #endif /* ifndef __ASSEMBLY__ */
 
diff --git a/arch/arm64/include/asm/is_compat.h b/arch/arm64/include/asm/is_compat.h
new file mode 100644
index 000000000000..19868588fbef
--- /dev/null
+++ b/arch/arm64/include/asm/is_compat.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+#ifndef __ASM_IS_COMPAT_H
+#define __ASM_IS_COMPAT_H
+#ifndef __ASSEMBLY__
+
+#include <linux/thread_bits.h>
+
+#ifdef CONFIG_AARCH32_EL0
+
+static inline int is_a32_compat_task(void)
+{
+	return test_thread_flag(TIF_32BIT);
+}
+
+static inline int is_a32_compat_thread(struct thread_info *thread)
+{
+	return test_ti_thread_flag(thread, TIF_32BIT);
+}
+
+#else
+
+static inline int is_a32_compat_task(void)
+
+{
+	return 0;
+}
+
+static inline int is_a32_compat_thread(struct thread_info *thread)
+{
+	return 0;
+}
+
+#endif /* CONFIG_AARCH32_EL0 */
+
+#ifdef CONFIG_COMPAT
+
+static inline int is_compat_task(void)
+{
+	return is_a32_compat_task();
+}
+
+#endif /* CONFIG_COMPAT */
+
+static inline int is_compat_thread(struct thread_info *thread)
+{
+	return is_a32_compat_thread(thread);
+}
+
+
+#endif /* !__ASSEMBLY__ */
+#endif /* __ASM_IS_COMPAT_H */
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 79cbc385f52a..78f9e71ad6fc 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -37,6 +37,7 @@
 #include <linux/string.h>
 
 #include <asm/alternative.h>
+#include <asm/is_compat.h>
 #include <asm/fpsimd.h>
 #include <asm/hw_breakpoint.h>
 #include <asm/lse.h>
@@ -50,9 +51,9 @@
  */
 #ifdef CONFIG_COMPAT
 #define TASK_SIZE_32		UL(0x100000000)
-#define TASK_SIZE		(test_thread_flag(TIF_32BIT) ? \
+#define TASK_SIZE		(is_compat_task() ?		\
 				TASK_SIZE_32 : TASK_SIZE_64)
-#define TASK_SIZE_OF(tsk)	(test_tsk_thread_flag(tsk, TIF_32BIT) ? \
+#define TASK_SIZE_OF(tsk)	(is_compat_thread(tsk) ? \
 				TASK_SIZE_32 : TASK_SIZE_64)
 #else
 #define TASK_SIZE		TASK_SIZE_64
@@ -63,7 +64,7 @@
 #define STACK_TOP_MAX		TASK_SIZE_64
 #ifdef CONFIG_COMPAT
 #define AARCH32_VECTORS_BASE	0xffff0000
-#define STACK_TOP		(test_thread_flag(TIF_32BIT) ? \
+#define STACK_TOP		(is_compat_task() ? \
 				AARCH32_VECTORS_BASE : STACK_TOP_MAX)
 #else
 #define STACK_TOP		STACK_TOP_MAX
@@ -130,7 +131,7 @@ static inline void arch_thread_struct_whitelist(unsigned long *offset,
 #define task_user_tls(t)						\
 ({									\
 	unsigned long *__tls;						\
-	if (is_compat_thread(task_thread_info(t)))			\
+	if (is_a32_compat_thread(task_thread_info(t)))			\
 		__tls = &(t)->thread.tp2_value;				\
 	else								\
 		__tls = &(t)->thread.tp_value;				\
diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
index 709a574468f0..ce09641f888d 100644
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -113,7 +113,7 @@ static inline void syscall_set_arguments(struct task_struct *task,
  */
 static inline int syscall_get_arch(void)
 {
-	if (is_compat_task())
+	if (is_a32_compat_task())
 		return AUDIT_ARCH_ARM;
 
 	return AUDIT_ARCH_AARCH64;
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 740aa03c5f0d..6d2d58daa9d7 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -91,7 +91,7 @@ void arch_release_task_struct(struct task_struct *tsk);
 #define TIF_FREEZE		19
 #define TIF_RESTORE_SIGMASK	20
 #define TIF_SINGLESTEP		21
-#define TIF_32BIT		22	/* 32bit process */
+#define TIF_32BIT		22	/* AARCH32 process */
 #define TIF_SVE			23	/* Scalable Vector Extension in use */
 #define TIF_SVE_VL_INHERIT	24	/* Inherit sve_vl_onexec across exec */
 
diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index 74bb56f656ef..55c09285f444 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -169,7 +169,7 @@ enum hw_breakpoint_ops {
 	HW_BREAKPOINT_RESTORE
 };
 
-static int is_compat_bp(struct perf_event *bp)
+static int is_a32_compat_bp(struct perf_event *bp)
 {
 	struct task_struct *tsk = bp->hw.target;
 
@@ -180,7 +180,7 @@ static int is_compat_bp(struct perf_event *bp)
 	 * deprecated behaviour if we use unaligned watchpoints in
 	 * AArch64 state.
 	 */
-	return tsk && is_compat_thread(task_thread_info(tsk));
+	return tsk && is_a32_compat_thread(task_thread_info(tsk));
 }
 
 /**
@@ -480,7 +480,7 @@ static int arch_build_bp_info(struct perf_event *bp)
 	 * Watchpoints can be of length 1, 2, 4 or 8 bytes.
 	 */
 	if (info->ctrl.type == ARM_BREAKPOINT_EXECUTE) {
-		if (is_compat_bp(bp)) {
+		if (is_a32_compat_bp(bp)) {
 			if (info->ctrl.len != ARM_BREAKPOINT_LEN_2 &&
 			    info->ctrl.len != ARM_BREAKPOINT_LEN_4)
 				return -EINVAL;
@@ -537,7 +537,7 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
 	 * AArch32 tasks expect some simple alignment fixups, so emulate
 	 * that here.
 	 */
-	if (is_compat_bp(bp)) {
+	if (is_a32_compat_bp(bp)) {
 		if (info->ctrl.len == ARM_BREAKPOINT_LEN_8)
 			alignment_mask = 0x7;
 		else
diff --git a/arch/arm64/kernel/perf_regs.c b/arch/arm64/kernel/perf_regs.c
index 513e279b12d3..6efbbd171670 100644
--- a/arch/arm64/kernel/perf_regs.c
+++ b/arch/arm64/kernel/perf_regs.c
@@ -47,7 +47,7 @@ int perf_reg_validate(u64 mask)
 
 u64 perf_reg_abi(struct task_struct *task)
 {
-	if (is_compat_thread(task_thread_info(task)))
+	if (is_a32_compat_thread(task_thread_info(task)))
 		return PERF_SAMPLE_REGS_ABI_32;
 	else
 		return PERF_SAMPLE_REGS_ABI_64;
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 105f79d126ee..50b1249844b7 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -51,7 +51,6 @@
 #include <linux/thread_info.h>
 
 #include <asm/alternative.h>
-#include <asm/compat.h>
 #include <asm/cacheflush.h>
 #include <asm/exec.h>
 #include <asm/fpsimd.h>
@@ -256,7 +255,7 @@ static void tls_thread_flush(void)
 {
 	write_sysreg(0, tpidr_el0);
 
-	if (is_compat_task()) {
+	if (is_a32_compat_task()) {
 		current->thread.tp_value = 0;
 
 		/*
@@ -340,7 +339,7 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
 		*task_user_tls(p) = read_sysreg(tpidr_el0);
 
 		if (stack_start) {
-			if (is_compat_thread(task_thread_info(p)))
+			if (is_a32_compat_thread(task_thread_info(p)))
 				childregs->compat_sp = stack_start;
 			else
 				childregs->sp = stack_start;
@@ -378,7 +377,7 @@ static void tls_thread_switch(struct task_struct *next)
 {
 	tls_preserve_current_state();
 
-	if (is_compat_thread(task_thread_info(next)))
+	if (is_a32_compat_thread(task_thread_info(next)))
 		write_sysreg(next->thread.tp_value, tpidrro_el0);
 	else if (!arm64_kernel_unmapped_at_el0())
 		write_sysreg(0, tpidrro_el0);
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 04e9b7973b28..4d0a541d049b 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -40,7 +40,6 @@
 #include <linux/tracehook.h>
 #include <linux/elf.h>
 
-#include <asm/compat.h>
 #include <asm/cpufeature.h>
 #include <asm/debug-monitors.h>
 #include <asm/pgtable.h>
@@ -189,7 +188,7 @@ static void ptrace_hbptriggered(struct perf_event *bp,
 	info.si_addr	= (void __user *)(bkpt->trigger);
 
 #ifdef CONFIG_AARCH32_EL0
-	if (is_compat_task()) {
+	if (is_a32_compat_task()) {
 		int si_errno = 0;
 		int i;
 
@@ -1592,9 +1591,9 @@ const struct user_regset_view *task_user_regset_view(struct task_struct *task)
 	 * 32-bit children use an extended user_aarch32_ptrace_view to allow
 	 * access to the TLS register.
 	 */
-	if (is_compat_task())
+	if (is_a32_compat_task())
 		return &user_aarch32_view;
-	else if (is_compat_thread(task_thread_info(task)))
+	else if (is_a32_compat_thread(task_thread_info(task)))
 		return &user_aarch32_ptrace_view;
 #endif
 	return &user_aarch64_view;
@@ -1621,7 +1620,7 @@ static void tracehook_report_syscall(struct pt_regs *regs,
 	 * A scratch register (ip(r12) on AArch32, x7 on AArch64) is
 	 * used to denote syscall entry/exit:
 	 */
-	regno = (is_compat_task() ? 12 : 7);
+	regno = (is_a32_compat_task() ? 12 : 7);
 	saved_reg = regs->regs[regno];
 	regs->regs[regno] = dir;
 
@@ -1732,7 +1731,7 @@ int valid_user_regs(struct user_pt_regs *regs, struct task_struct *task)
 	if (!test_tsk_thread_flag(task, TIF_SINGLESTEP))
 		regs->pstate &= ~DBG_SPSR_SS;
 
-	if (is_compat_thread(task_thread_info(task)))
+	if (is_a32_compat_thread(task_thread_info(task)))
 		return valid_compat_regs(regs);
 	else
 		return valid_native_regs(regs);
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index fb7c1a510ed4..0a829f6f1832 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -778,7 +778,7 @@ static int setup_rt_frame(int usig, struct ksignal *ksig, sigset_t *set,
 
 static void setup_restart_syscall(struct pt_regs *regs)
 {
-	if (is_compat_task())
+	if (is_a32_compat_task())
 		a32_setup_restart_syscall(regs);
 	else
 		regs->regs[8] = __NR_restart_syscall;
@@ -797,7 +797,7 @@ static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 	/*
 	 * Set up the stack frame
 	 */
-	if (is_compat_task()) {
+	if (is_a32_compat_task()) {
 		if (ksig->ka.sa.sa_flags & SA_SIGINFO)
 			ret = a32_setup_rt_frame(usig, ksig, oldset, regs);
 		else
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index d2ebfc2f4fbc..0d6eda51eca1 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/bug.h>
+#include <linux/compat.h>
 #include <linux/signal.h>
 #include <linux/personality.h>
 #include <linux/kallsyms.h>
@@ -519,7 +520,7 @@ asmlinkage long do_ni_syscall(struct pt_regs *regs)
 {
 #ifdef CONFIG_AARCH32_EL0
 	long ret;
-	if (is_compat_task()) {
+	if (is_a32_compat_task()) {
 		ret = a32_arm_syscall(regs);
 		if (ret != -ENOSYS)
 			return ret;
diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index decccffb03ca..65be0d308d75 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -54,7 +54,7 @@ unsigned long arch_mmap_rnd(void)
 	unsigned long rnd;
 
 #ifdef CONFIG_COMPAT
-	if (test_thread_flag(TIF_32BIT))
+	if (is_compat_task())
 		rnd = get_random_long() & ((1UL << mmap_rnd_compat_bits) - 1);
 	else
 #endif
-- 
2.17.0
