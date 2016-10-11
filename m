From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Subject: [PATCH v3 02/11] tracing/syscalls: add handling for compat tasks
Date: Tue, 11 Oct 2016 12:42:47 +0200
Message-ID: <1476182576-15247-3-git-send-email-marcin.nowakowski@imgtec.com>
References: <1476182576-15247-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476182576-15247-1-git-send-email-marcin.nowakowski@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, Marcin Nowakowski <marcin.nowakowski@imgtec.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-api@vger.kernel.org

Extend the syscall tracing subsystem by adding a handler for compat
tasks. For some architectures, where compat tasks' syscall numbers have
an exclusive set of syscall numbers, this already works since the
removal of syscall_nr.
Architectures where the same syscall may use a different syscall number
for compat tasks need to define ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP and
define a method arch_trace_is_compat_syscall(struct pt_regs*) that tells
if a current task is a compat one.
For architectures that define ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP:
- if an architecture defines NR_compat_syscalls, then the number of
  trace event files equals to NR_compat_syscalls + NR_syscalls
- if an architecture doesn't define NR_compat_syscalls, the number of
  trace event files is calculated as 2*NR_syscalls
Compat syscall trace events are identified by the syscall number offset
by NR_syscalls.

Signed-off-by: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/mips/kernel/ftrace.c     |   4 +-
 arch/powerpc/kernel/ftrace.c  |   2 +-
 include/linux/ftrace.h        |   2 +-
 kernel/trace/trace.h          |  17 +++++-
 kernel/trace/trace_syscalls.c | 137 +++++++++++++++++++++++++-----------------
 5 files changed, 102 insertions(+), 60 deletions(-)

diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
index 30a3b75..dd3dae3 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -412,7 +412,7 @@ void prepare_ftrace_return(unsigned long *parent_ra_addr, unsigned long self_ra,
 #ifdef CONFIG_FTRACE_SYSCALLS
 
 #ifdef CONFIG_32BIT
-unsigned long __init arch_syscall_addr(int nr)
+unsigned long __init arch_syscall_addr(int nr, bool compat)
 {
 	return (unsigned long)sys_call_table[nr - __NR_O32_Linux];
 }
@@ -420,7 +420,7 @@ unsigned long __init arch_syscall_addr(int nr)
 
 #ifdef CONFIG_64BIT
 
-unsigned long __init arch_syscall_addr(int nr)
+unsigned long __init arch_syscall_addr(int nr, bool compat)
 {
 #ifdef CONFIG_MIPS32_N32
 	if (nr >= __NR_N32_Linux && nr <= __NR_N32_Linux + __NR_N32_Linux_syscalls)
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index a95639b..5bfb35f 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -604,7 +604,7 @@ unsigned long prepare_ftrace_return(unsigned long parent, unsigned long ip)
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
 #if defined(CONFIG_FTRACE_SYSCALLS) && defined(CONFIG_PPC64)
-unsigned long __init arch_syscall_addr(int nr)
+unsigned long __init arch_syscall_addr(int nr, bool compat)
 {
 	return sys_call_table[nr*2];
 }
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index c45ed06..4d1ca1c 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -957,7 +957,7 @@ static inline void  disable_trace_on_warning(void) { }
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 
-unsigned long arch_syscall_addr(int nr);
+unsigned long arch_syscall_addr(int nr, bool compat);
 
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index fd24b1f..821ee82 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -237,8 +237,21 @@ struct trace_array {
 #ifdef CONFIG_FTRACE_SYSCALLS
 	int			sys_refcount_enter;
 	int			sys_refcount_exit;
-	struct trace_event_file __rcu *enter_syscall_files[NR_syscalls];
-	struct trace_event_file __rcu *exit_syscall_files[NR_syscalls];
+
+#if (defined ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP) && (defined CONFIG_COMPAT)
+
+#ifdef NR_compat_syscalls
+#define FTRACE_SYSCALL_CNT (NR_syscalls + NR_compat_syscalls)
+#else /* !NR_compat_syscalls */
+#define FTRACE_SYSCALL_CNT (2 * NR_syscalls)
+#endif /* NR_compat_syscalls */
+
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
index 07887b4..fe7fc33 100644
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
@@ -304,6 +302,26 @@ static int __init syscall_exit_define_fields(struct trace_event_call *call)
 	return ret;
 }
 
+static int ftrace_check_syscall_nr(struct pt_regs *regs)
+{
+	int syscall_nr;
+
+	syscall_nr = trace_get_syscall_nr(current, regs);
+	if (syscall_nr < 0)
+		return -1;
+
+	if (trace_is_compat_syscall(regs)) {
+		syscall_nr += NR_syscalls;
+		if (syscall_nr >= FTRACE_SYSCALL_CNT)
+			return -1;
+	} else {
+		if (syscall_nr > NR_syscalls)
+			return -1;
+	}
+
+	return syscall_nr;
+}
+
 static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 {
 	struct trace_array *tr = data;
@@ -317,8 +335,8 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	int syscall_nr;
 	int size;
 
-	syscall_nr = trace_get_syscall_nr(current, regs);
-	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
+	syscall_nr = ftrace_check_syscall_nr(regs);
+	if (syscall_nr < 0)
 		return;
 
 	/* Here we're inside tp handler's rcu_read_lock_sched (__DO_TRACE) */
@@ -329,7 +347,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	if (trace_trigger_soft_disabled(trace_file))
 		return;
 
-	sys_data = syscall_nr_to_meta(syscall_nr);
+	sys_data = trace_syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
@@ -364,8 +382,8 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	int pc;
 	int syscall_nr;
 
-	syscall_nr = trace_get_syscall_nr(current, regs);
-	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
+	syscall_nr = ftrace_check_syscall_nr(regs);
+	if (syscall_nr < 0)
 		return;
 
 	/* Here we're inside tp handler's rcu_read_lock_sched (__DO_TRACE()) */
@@ -376,7 +394,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (trace_trigger_soft_disabled(trace_file))
 		return;
 
-	sys_data = syscall_nr_to_meta(syscall_nr);
+	sys_data = trace_syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
@@ -412,7 +430,7 @@ static int reg_event_syscall_enter(struct trace_event_file *file,
 			goto out_unlock;
 	}
 
-	for (num = 0; num < NR_syscalls; num++) {
+	for (num = 0; num < FTRACE_SYSCALL_CNT; num++) {
 		if (syscalls_metadata[num] &&
 		   (syscalls_metadata[num] == call->data))
 			rcu_assign_pointer(tr->enter_syscall_files[num], file);
@@ -432,7 +450,7 @@ static void unreg_event_syscall_enter(struct trace_event_file *file,
 
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_enter--;
-	for (num = 0; num < NR_syscalls; num++) {
+	for (num = 0; num < FTRACE_SYSCALL_CNT; num++) {
 		if (syscalls_metadata[num] &&
 		   (syscalls_metadata[num] == call->data))
 			RCU_INIT_POINTER(tr->enter_syscall_files[num], NULL);
@@ -456,7 +474,7 @@ static int reg_event_syscall_exit(struct trace_event_file *file,
 			goto out_unlock;
 	}
 
-	for (num = 0; num < NR_syscalls; num++) {
+	for (num = 0; num < FTRACE_SYSCALL_CNT; num++) {
 		if (syscalls_metadata[num] &&
 		   (syscalls_metadata[num] == call->data))
 			rcu_assign_pointer(tr->exit_syscall_files[num], file);
@@ -476,7 +494,7 @@ static void unreg_event_syscall_exit(struct trace_event_file *file,
 
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_exit--;
-	for (num = 0; num < NR_syscalls; num++) {
+	for (num = 0; num < FTRACE_SYSCALL_CNT; num++) {
 		if (syscalls_metadata[num] &&
 		   (syscalls_metadata[num] == call->data))
 			RCU_INIT_POINTER(tr->exit_syscall_files[num], NULL);
@@ -527,38 +545,47 @@ struct trace_event_class __refdata event_class_syscall_exit = {
 	.raw_init	= init_syscall_trace,
 };
 
-unsigned long __init __weak arch_syscall_addr(int nr)
+unsigned long __init __weak arch_syscall_addr(int nr, bool compat)
 {
 	return (unsigned long)sys_call_table[nr];
 }
 
-void __init init_ftrace_syscalls(void)
+void __init init_ftrace_syscalls_meta(bool compat)
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
+	init_ftrace_syscalls_meta(false);
+#ifdef ARCH_COMPAT_SYSCALL_NUMBERS_OVERLAP
+	if (IS_ENABLED(CONFIG_COMPAT))
+		init_ftrace_syscalls_meta(true);
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
 
@@ -571,13 +598,14 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	int rctx;
 	int size;
 
-	syscall_nr = trace_get_syscall_nr(current, regs);
-	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
+	syscall_nr = ftrace_check_syscall_nr(regs);
+	if (syscall_nr < 0)
 		return;
+
 	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
 		return;
 
-	sys_data = syscall_nr_to_meta(syscall_nr);
+	sys_data = trace_syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
@@ -616,7 +644,7 @@ static int perf_sysenter_enable(struct trace_event_call *call)
 		}
 	}
 
-	for (num = 0; num < NR_syscalls; num++) {
+	for (num = 0; num < FTRACE_SYSCALL_CNT; num++) {
 		if (syscalls_metadata[num] &&
 		   (syscalls_metadata[num] == call->data))
 			set_bit(num, enabled_perf_enter_syscalls);
@@ -634,7 +662,7 @@ static void perf_sysenter_disable(struct trace_event_call *call)
 
 	mutex_lock(&syscall_trace_lock);
 	sys_perf_refcount_enter--;
-	for (num = 0; num < NR_syscalls; num++) {
+	for (num = 0; num < FTRACE_SYSCALL_CNT; num++) {
 		if (syscalls_metadata[num] &&
 		   (syscalls_metadata[num] == call->data))
 			clear_bit(num, enabled_perf_enter_syscalls);
@@ -653,13 +681,14 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	int rctx;
 	int size;
 
-	syscall_nr = trace_get_syscall_nr(current, regs);
-	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
+	syscall_nr = ftrace_check_syscall_nr(regs);
+	if (syscall_nr < 0)
 		return;
+
 	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))
 		return;
 
-	sys_data = syscall_nr_to_meta(syscall_nr);
+	sys_data = trace_syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
@@ -695,7 +724,7 @@ static int perf_sysexit_enable(struct trace_event_call *call)
 		}
 	}
 
-	for (num = 0; num < NR_syscalls; num++) {
+	for (num = 0; num < FTRACE_SYSCALL_CNT; num++) {
 		if (syscalls_metadata[num] &&
 		   (syscalls_metadata[num] == call->data))
 			set_bit(num, enabled_perf_exit_syscalls);
@@ -713,7 +742,7 @@ static void perf_sysexit_disable(struct trace_event_call *call)
 
 	mutex_lock(&syscall_trace_lock);
 	sys_perf_refcount_exit--;
-	for (num = 0; num < NR_syscalls; num++) {
+	for (num = 0; num < FTRACE_SYSCALL_CNT; num++) {
 		if (syscalls_metadata[num] &&
 		   (syscalls_metadata[num] == call->data))
 			clear_bit(num, enabled_perf_exit_syscalls);
-- 
2.7.4
