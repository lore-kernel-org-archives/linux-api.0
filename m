From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Subject: [RFC PATCH 2/3] tracing/syscalls: add handling for compat tasks
Date: Fri, 9 Sep 2016 10:03:28 +0200
Message-ID: <1473408209-17335-3-git-send-email-marcin.nowakowski@imgtec.com>
References: <1473408209-17335-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473408209-17335-1-git-send-email-marcin.nowakowski@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, Marcin Nowakowski <marcin.nowakowski@imgtec.com>
List-Id: linux-api@vger.kernel.org

Extend the syscall tracing subsystem by adding a handler for compat
tasks. For some architectures, where compat tasks' syscall numbers have
an exclusive set of syscall numbers, this already works since the
removal of syscall_nr.
Architectures where the same syscall may use a different syscall number
for compat tasks need to define ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP and
define a method arch_trace_is_compat_syscall(struct pt_regs*) that tells
if a current task is a compat one.
For architectures that define ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP the
number of trace event files is doubled and all syscall trace events are
identified by the syscall number offset by NR_syscalls.

Note that as this patch series is posted as an RFC, this currently only
includes arch updates for MIPS and x86 (and has only been tested on
MIPS and x86_64). I will work on updating other arch trees after this
solution is reviewed.

Signed-off-by: Marcin Nowakowski <marcin.nowakowski@imgtec.com>

---
 arch/mips/kernel/ftrace.c     |   4 +-
 arch/x86/include/asm/ftrace.h |  10 +---
 arch/x86/kernel/ftrace.c      |  14 ++++++
 include/linux/ftrace.h        |   2 +-
 kernel/trace/trace.h          |  11 +++-
 kernel/trace/trace_syscalls.c | 113 +++++++++++++++++++++++++-----------------
 6 files changed, 94 insertions(+), 60 deletions(-)

diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
index 937c54b..e150cf6 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -412,7 +412,7 @@ out:
 #ifdef CONFIG_FTRACE_SYSCALLS
 
 #ifdef CONFIG_32BIT
-unsigned long __init arch_syscall_addr(int nr)
+unsigned long __init arch_syscall_addr(int nr, int compat)
 {
 	return (unsigned long)sys_call_table[nr - __NR_O32_Linux];
 }
@@ -420,7 +420,7 @@ unsigned long __init arch_syscall_addr(int nr)
 
 #ifdef CONFIG_64BIT
 
-unsigned long __init arch_syscall_addr(int nr)
+unsigned long __init arch_syscall_addr(int nr, int compat)
 {
 #ifdef CONFIG_MIPS32_N32
 	if (nr >= __NR_N32_Linux && nr <= __NR_N32_Linux + __NR_N32_Linux_syscalls)
diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index a4820d4..a24a21c 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -47,15 +47,7 @@ int ftrace_int3_handler(struct pt_regs *regs);
 #if defined(CONFIG_FTRACE_SYSCALLS) && defined(CONFIG_IA32_EMULATION)
 #include <asm/compat.h>
 
-/*
- * Because ia32 syscalls do not map to x86_64 syscall numbers
- * this screws up the trace output when tracing a ia32 task.
- * Instead of reporting bogus syscalls, just do not trace them.
- *
- * If the user really wants these, then they should use the
- * raw syscall tracepoints with filtering.
- */
-#define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS 1
+#define ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP 1
 static inline bool arch_trace_is_compat_syscall(struct pt_regs *regs)
 {
 	if (in_compat_syscall())
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index d036cfb..78f3e36 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -28,6 +28,7 @@
 #include <asm/kprobes.h>
 #include <asm/ftrace.h>
 #include <asm/nops.h>
+#include <asm/syscall.h>
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
@@ -1035,3 +1036,16 @@ void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
 	}
 }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
+#ifdef CONFIG_FTRACE_SYSCALLS
+
+unsigned long arch_syscall_addr(int nr, int compat)
+{
+#if defined(CONFIG_X86_64) && defined(CONFIG_IA32_EMULATION)
+	if (compat)
+		return (unsigned long)ia32_sys_call_table[nr];
+#endif
+	return (unsigned long)sys_call_table[nr];
+}
+
+#endif /* CONFIG_FTRACE_SYSCALLS */
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 7d565af..110f95d 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -938,7 +938,7 @@ static inline void  disable_trace_on_warning(void) { }
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 
-unsigned long arch_syscall_addr(int nr);
+unsigned long arch_syscall_addr(int nr, int compat);
 
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f783df4..102a41a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -234,8 +234,15 @@ struct trace_array {
 #ifdef CONFIG_FTRACE_SYSCALLS
 	int			sys_refcount_enter;
 	int			sys_refcount_exit;
-	struct trace_event_file __rcu *enter_syscall_files[NR_syscalls];
-	struct trace_event_file __rcu *exit_syscall_files[NR_syscalls];
+
+#ifdef ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP
+#define FTRACE_SYSCALL_CNT (NR_syscalls * (1 + IS_ENABLED(CONFIG_COMPAT)))
+#else
+#define FTRACE_SYSCALL_CNT (NR_syscalls)
+#endif
+
+	struct trace_event_file __rcu *enter_syscall_files[FTRACE_SYSCALL_CNT];
+	struct trace_event_file __rcu *exit_syscall_files[FTRACE_SYSCALL_CNT];
 #endif
 	int			stop_count;
 	int			clock_id;
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 1da10ca..dc7df38 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -44,37 +44,35 @@ static inline bool arch_syscall_match_sym_name(const char *sym, const char *name
 }
 #endif
 
-#ifdef ARCH_TRACE_IGNORE_COMPAT_SYSCALLS
+#ifdef ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP
 /*
  * Some architectures that allow for 32bit applications
  * to run on a 64bit kernel, do not map the syscalls for
  * the 32bit tasks the same as they do for 64bit tasks.
  *
- *     *cough*x86*cough*
- *
- * In such a case, instead of reporting the wrong syscalls,
- * simply ignore them.
- *
- * For an arch to ignore the compat syscalls it needs to
- * define ARCH_TRACE_IGNORE_COMPAT_SYSCALLS as well as
+ * If a set of syscall numbers for 32-bit tasks overlaps
+ * the set of syscall numbers for 64-bit tasks, define
+ * ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP as well as
  * define the function arch_trace_is_compat_syscall() to let
- * the tracing system know that it should ignore it.
+ * the tracing system know that a compat syscall is being handled.
  */
-static int
-trace_get_syscall_nr(struct task_struct *task, struct pt_regs *regs)
+static inline bool trace_is_compat_syscall(struct pt_regs *regs)
 {
-	if (unlikely(arch_trace_is_compat_syscall(regs)))
-		return -1;
-
-	return syscall_get_nr(task, regs);
+	return arch_trace_is_compat_syscall(regs);
 }
 #else
+static inline bool trace_is_compat_syscall(struct pt_regs *regs)
+{
+	return false;
+}
+#endif /* ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP */
+
 static inline int
 trace_get_syscall_nr(struct task_struct *task, struct pt_regs *regs)
 {
 	return syscall_get_nr(task, regs);
 }
-#endif /* ARCH_TRACE_IGNORE_COMPAT_SYSCALLS */
+
 
 static __init struct syscall_metadata *
 find_syscall_meta(unsigned long syscall)
@@ -98,9 +96,9 @@ find_syscall_meta(unsigned long syscall)
 	return NULL;
 }
 
-static struct syscall_metadata *syscall_nr_to_meta(int nr)
+static struct syscall_metadata *trace_syscall_nr_to_meta(int nr)
 {
-	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
+	if (!syscalls_metadata || nr >= FTRACE_SYSCALL_CNT || nr < 0)
 		return NULL;
 
 	return syscalls_metadata[nr];
@@ -110,7 +108,7 @@ const char *get_syscall_name(int syscall)
 {
 	struct syscall_metadata *entry;
 
-	entry = syscall_nr_to_meta(syscall);
+	entry = trace_syscall_nr_to_meta(syscall);
 	if (!entry)
 		return NULL;
 
@@ -130,7 +128,7 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
 
 	trace = (typeof(trace))ent;
 	syscall = trace->nr;
-	entry = syscall_nr_to_meta(syscall);
+	entry = trace_syscall_nr_to_meta(syscall);
 
 	if (!entry)
 		goto end;
@@ -176,7 +174,7 @@ print_syscall_exit(struct trace_iterator *iter, int flags,
 
 	trace = (typeof(trace))ent;
 	syscall = trace->nr;
-	entry = syscall_nr_to_meta(syscall);
+	entry = trace_syscall_nr_to_meta(syscall);
 
 	if (!entry) {
 		trace_seq_putc(s, '\n');
@@ -321,6 +319,9 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
 		return;
 
+	if (trace_is_compat_syscall(regs))
+		syscall_nr += NR_syscalls;
+
 	/* Here we're inside tp handler's rcu_read_lock_sched (__DO_TRACE) */
 	trace_file = rcu_dereference_sched(tr->enter_syscall_files[syscall_nr]);
 	if (!trace_file)
@@ -329,7 +330,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	if (trace_trigger_soft_disabled(trace_file))
 		return;
 
-	sys_data = syscall_nr_to_meta(syscall_nr);
+	sys_data = trace_syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
@@ -368,6 +369,9 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
 		return;
 
+	if (trace_is_compat_syscall(regs))
+		syscall_nr += NR_syscalls;
+
 	/* Here we're inside tp handler's rcu_read_lock_sched (__DO_TRACE()) */
 	trace_file = rcu_dereference_sched(tr->exit_syscall_files[syscall_nr]);
 	if (!trace_file)
@@ -376,7 +380,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (trace_trigger_soft_disabled(trace_file))
 		return;
 
-	sys_data = syscall_nr_to_meta(syscall_nr);
+	sys_data = trace_syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
@@ -415,7 +419,7 @@ static int reg_event_syscall_enter(struct trace_event_file *file,
 			goto out_unlock;
 	}
 
-	for (num = 0; num < NR_syscalls; num++) {
+	for (num = 0; num < FTRACE_SYSCALL_CNT; num++) {
 		if (syscalls_metadata[num] &&
 		    arch_syscall_match_sym_name(syscalls_metadata[num]->name,
 				    name))
@@ -438,7 +442,7 @@ static void unreg_event_syscall_enter(struct trace_event_file *file,
 	name = ((const struct syscall_metadata *)call->data)->name;
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_enter--;
-	for (num = 0; num < NR_syscalls; num++) {
+	for (num = 0; num < FTRACE_SYSCALL_CNT; num++) {
 		if (syscalls_metadata[num] &&
 		   arch_syscall_match_sym_name(syscalls_metadata[num]->name,
 				   name))
@@ -466,7 +470,7 @@ static int reg_event_syscall_exit(struct trace_event_file *file,
 			goto out_unlock;
 	}
 
-	for (num = 0; num < NR_syscalls; num++) {
+	for (num = 0; num < FTRACE_SYSCALL_CNT; num++) {
 		if (syscalls_metadata[num] &&
 		    arch_syscall_match_sym_name(syscalls_metadata[num]->name,
 				    name))
@@ -490,7 +494,7 @@ static void unreg_event_syscall_exit(struct trace_event_file *file,
 
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_exit--;
-	for (num = 0; num < NR_syscalls; num++) {
+	for (num = 0; num < FTRACE_SYSCALL_CNT; num++) {
 		if (syscalls_metadata[num] &&
 		   arch_syscall_match_sym_name(syscalls_metadata[num]->name,
 				   name))
@@ -542,38 +546,47 @@ struct trace_event_class __refdata event_class_syscall_exit = {
 	.raw_init	= init_syscall_trace,
 };
 
-unsigned long __init __weak arch_syscall_addr(int nr)
+unsigned long __init __weak arch_syscall_addr(int nr, int compat)
 {
 	return (unsigned long)sys_call_table[nr];
 }
 
-void __init init_ftrace_syscalls(void)
+void __init init_ftrace_syscalls_meta(int compat)
 {
 	struct syscall_metadata *meta;
 	unsigned long addr;
 	int i;
 
-	syscalls_metadata = kcalloc(NR_syscalls, sizeof(*syscalls_metadata),
-				    GFP_KERNEL);
-	if (!syscalls_metadata) {
-		WARN_ON(1);
-		return;
-	}
-
 	for (i = 0; i < NR_syscalls; i++) {
-		addr = arch_syscall_addr(i);
+		addr = arch_syscall_addr(i, compat);
 		meta = find_syscall_meta(addr);
 		if (!meta)
 			continue;
 
-		syscalls_metadata[i] = meta;
+		syscalls_metadata[compat * NR_syscalls + i] = meta;
 	}
 }
 
+void __init init_ftrace_syscalls(void)
+{
+	syscalls_metadata = kcalloc(FTRACE_SYSCALL_CNT,
+				    sizeof(*syscalls_metadata), GFP_KERNEL);
+	if (!syscalls_metadata) {
+		WARN_ON(1);
+		return;
+	}
+
+	init_ftrace_syscalls_meta(0);
+#ifdef ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP
+	if (IS_ENABLED(CONFIG_COMPAT))
+		init_ftrace_syscalls_meta(1);
+#endif
+}
+
 #ifdef CONFIG_PERF_EVENTS
 
-static DECLARE_BITMAP(enabled_perf_enter_syscalls, NR_syscalls);
-static DECLARE_BITMAP(enabled_perf_exit_syscalls, NR_syscalls);
+static DECLARE_BITMAP(enabled_perf_enter_syscalls, FTRACE_SYSCALL_CNT);
+static DECLARE_BITMAP(enabled_perf_exit_syscalls, FTRACE_SYSCALL_CNT);
 static int sys_perf_refcount_enter;
 static int sys_perf_refcount_exit;
 
@@ -589,10 +602,14 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
 		return;
+
+	if (trace_is_compat_syscall(regs))
+		syscall_nr += NR_syscalls;
+
 	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
 		return;
 
-	sys_data = syscall_nr_to_meta(syscall_nr);
+	sys_data = trace_syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
@@ -635,7 +652,7 @@ static int perf_sysenter_enable(struct trace_event_call *call)
 		}
 	}
 
-	for (num = 0; num < NR_syscalls; num++) {
+	for (num = 0; num < FTRACE_SYSCALL_CNT; num++) {
 		if (syscalls_metadata[num] &&
 		    arch_syscall_match_sym_name(syscalls_metadata[num]->name,
 				    name))
@@ -657,7 +674,7 @@ static void perf_sysenter_disable(struct trace_event_call *call)
 
 	mutex_lock(&syscall_trace_lock);
 	sys_perf_refcount_enter--;
-	for (num = 0; num < NR_syscalls; num++) {
+	for (num = 0; num < FTRACE_SYSCALL_CNT; num++) {
 		if (syscalls_metadata[num] &&
 		    arch_syscall_match_sym_name(syscalls_metadata[num]->name,
 				    name))
@@ -680,10 +697,14 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	syscall_nr = trace_get_syscall_nr(current, regs);
 	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
 		return;
+
+	if (trace_is_compat_syscall(regs))
+		syscall_nr += NR_syscalls;
+
 	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))
 		return;
 
-	sys_data = syscall_nr_to_meta(syscall_nr);
+	sys_data = trace_syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
@@ -723,7 +744,7 @@ static int perf_sysexit_enable(struct trace_event_call *call)
 		}
 	}
 
-	for (num = 0; num < NR_syscalls; num++) {
+	for (num = 0; num < FTRACE_SYSCALL_CNT; num++) {
 		if (syscalls_metadata[num] &&
 		    arch_syscall_match_sym_name(syscalls_metadata[num]->name,
 				    name))
@@ -745,7 +766,7 @@ static void perf_sysexit_disable(struct trace_event_call *call)
 
 	mutex_lock(&syscall_trace_lock);
 	sys_perf_refcount_exit--;
-	for (num = 0; num < NR_syscalls; num++) {
+	for (num = 0; num < FTRACE_SYSCALL_CNT; num++) {
 		if (syscalls_metadata[num] &&
 		    arch_syscall_match_sym_name(syscalls_metadata[num]->name,
 				    name))
-- 
2.7.4
