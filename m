From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Subject: [PATCH v4 08/12] arm64/tracing: fix compat syscall handling
Date: Fri, 14 Oct 2016 10:35:11 +0200
Message-ID: <1476434115-25428-10-git-send-email-marcin.nowakowski@imgtec.com>
References: <1476434115-25428-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476434115-25428-1-git-send-email-marcin.nowakowski@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, Marcin Nowakowski <marcin.nowakowski@imgtec.com>, Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Add arch_syscall_addr for arm64 and define NR_compat_syscalls, as the
number of compat syscalls for arm64 exceeds the number defined by
NR_syscalls.
Convert the existing uses of __NR_compat_syscalls to the newly
introduced NR_compat_syscalls

Signed-off-by: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Acked-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/ftrace.h   | 12 +-----------
 arch/arm64/include/asm/unistd.h   |  2 +-
 arch/arm64/include/asm/unistd32.h |  2 +-
 arch/arm64/kernel/Makefile        |  1 +
 arch/arm64/kernel/entry.S         |  2 +-
 arch/arm64/kernel/ftrace.c        | 16 ++++++++++++++++
 arch/arm64/kernel/sys32.c         |  4 ++--
 7 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
index caa955f..b57ff7c 100644
--- a/arch/arm64/include/asm/ftrace.h
+++ b/arch/arm64/include/asm/ftrace.h
@@ -41,17 +41,7 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 
 #define ftrace_return_address(n) return_address(n)
 
-/*
- * Because AArch32 mode does not share the same syscall table with AArch64,
- * tracing compat syscalls may result in reporting bogus syscalls or even
- * hang-up, so just do not trace them.
- * See kernel/trace/trace_syscalls.c
- *
- * x86 code says:
- * If the user really wants these, then they should use the
- * raw syscall tracepoints with filtering.
- */
-#define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS
+#define ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP 1
 static inline bool arch_trace_is_compat_syscall(struct pt_regs *regs)
 {
 	return is_compat_task();
diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index e78ac26..df56ffc 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -44,7 +44,7 @@
 #define __ARM_NR_compat_cacheflush	(__ARM_NR_COMPAT_BASE+2)
 #define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE+5)
 
-#define __NR_compat_syscalls		394
+#define NR_compat_syscalls		394
 #endif
 
 #define __ARCH_WANT_SYS_CLONE
diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index b7e8ef1..0fd0909 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -812,5 +812,5 @@ __SYSCALL(__NR_pwritev2, compat_sys_pwritev2)
 
 /*
  * Please add new compat syscalls above this comment and update
- * __NR_compat_syscalls in asm/unistd.h.
+ * NR_compat_syscalls in asm/unistd.h.
  */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 7d66bba..7ea9cd3 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -30,6 +30,7 @@ $(obj)/%.stub.o: $(obj)/%.o FORCE
 arm64-obj-$(CONFIG_COMPAT)		+= sys32.o kuser32.o signal32.o 	\
 					   sys_compat.o entry32.o
 arm64-obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o entry-ftrace.o
+arm64-obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
 arm64-obj-$(CONFIG_MODULES)		+= arm64ksyms.o module.o
 arm64-obj-$(CONFIG_ARM64_MODULE_PLTS)	+= module-plts.o
 arm64-obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o perf_callchain.o
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 223d54a..9fb7ad1 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -518,7 +518,7 @@ el0_svc_compat:
 	 */
 	adrp	stbl, compat_sys_call_table	// load compat syscall table pointer
 	uxtw	scno, w7			// syscall number in w7 (r7)
-	mov     sc_nr, #__NR_compat_syscalls
+	mov     sc_nr, #NR_compat_syscalls
 	b	el0_svc_naked
 
 	.align	6
diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index 40ad08a..75d010f 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -176,4 +176,20 @@ int ftrace_disable_ftrace_graph_caller(void)
 	return ftrace_modify_graph_caller(false);
 }
 #endif /* CONFIG_DYNAMIC_FTRACE */
+
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
+#if (defined CONFIG_FTRACE_SYSCALLS) && (defined CONFIG_COMPAT)
+
+extern const void *sys_call_table[];
+extern const void *compat_sys_call_table[];
+
+unsigned long __init arch_syscall_addr(int nr, bool compat)
+{
+	if (compat)
+		return (unsigned long)compat_sys_call_table[nr];
+
+	return (unsigned long)sys_call_table[nr];
+}
+
+#endif /* CONFIG_FTRACE_SYSCALLS && CONFIG_COMPAT */
diff --git a/arch/arm64/kernel/sys32.c b/arch/arm64/kernel/sys32.c
index a40b134..ae7a992 100644
--- a/arch/arm64/kernel/sys32.c
+++ b/arch/arm64/kernel/sys32.c
@@ -46,7 +46,7 @@ asmlinkage long compat_sys_mmap2_wrapper(void);
  * The sys_call_table array must be 4K aligned to be accessible from
  * kernel/entry.S.
  */
-void * const compat_sys_call_table[__NR_compat_syscalls] __aligned(4096) = {
-	[0 ... __NR_compat_syscalls - 1] = sys_ni_syscall,
+void * const compat_sys_call_table[NR_compat_syscalls] __aligned(4096) = {
+	[0 ... NR_compat_syscalls - 1] = sys_ni_syscall,
 #include <asm/unistd32.h>
 };
-- 
2.7.4
