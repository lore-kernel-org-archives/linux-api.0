From: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] tracing/syscalls: allow multiple syscall numbers per syscall
Date: Mon, 29 Aug 2016 11:30:06 +0200
Message-ID: <1472463007-6469-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-mips-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Syscall metadata makes an assumption that only a single syscall number
corresponds to a given method. This is true for most archs, but
can break tracing otherwise.

For MIPS platforms, depending on the choice of supported ABIs, up to 3
system call numbers can correspond to the same call - depending on which
ABI the userspace app uses.

When init_ftrace_syscalls() sets up the syscall_nr field in metadata, it
would overwrite that with the highest number matching a given syscall.

To avoid this, change the syscall_nr member of syscall_metadata to an
array - for most archs the array will be of size 1 and is not going to
add any overhead. If an arch requires multiple syscall_nr to be
supported, it needs to define its own NR_syscall_tables to override the
default behaviour.

Signed-off-by: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
---
 include/linux/syscalls.h      |   2 +-
 include/trace/syscall.h       |   5 +-
 kernel/trace/trace_syscalls.c | 103 ++++++++++++++++++++++++++++++------------
 3 files changed, 78 insertions(+), 32 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index d022390..6f4af11 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -160,7 +160,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	static struct syscall_metadata __used			\
 	  __syscall_meta_##sname = {				\
 		.name 		= "sys"#sname,			\
-		.syscall_nr	= -1,	/* Filled in at boot */	\
+		.syscall_nr[0 ... (NR_syscall_tables-1)] = -1,	/* Filled in at boot */	\
 		.nb_args 	= nb,				\
 		.types		= nb ? types_##sname : NULL,	\
 		.args		= nb ? args_##sname : NULL,	\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 7434f0f..f7073922 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -8,6 +8,9 @@
 
 #include <asm/ptrace.h>
 
+#ifndef NR_syscall_tables
+#define NR_syscall_tables 1
+#endif
 
 /*
  * A syscall entry in the ftrace syscalls array.
@@ -23,7 +26,7 @@
  */
 struct syscall_metadata {
 	const char	*name;
-	int		syscall_nr;
+	int		syscall_nr[NR_syscall_tables];
 	int		nb_args;
 	const char	**types;
 	const char	**args;
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index b2b6efc..ed22c50 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -403,16 +403,24 @@ static int reg_event_syscall_enter(struct trace_event_file *file,
 {
 	struct trace_array *tr = file->tr;
 	int ret = 0;
-	int num;
+	int num, i;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
+	num = ((struct syscall_metadata *)call->data)->syscall_nr[0];
 	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!tr->sys_refcount_enter)
 		ret = register_trace_sys_enter(ftrace_syscall_enter, tr);
+
 	if (!ret) {
-		rcu_assign_pointer(tr->enter_syscall_files[num], file);
+		for (i = 0; i < NR_syscall_tables; i++) {
+			struct syscall_metadata *metadata = call->data;
+
+			num = metadata->syscall_nr[i];
+			if (num > 0 && num < NR_syscalls)
+				rcu_assign_pointer(
+					tr->enter_syscall_files[num], file);
+		}
 		tr->sys_refcount_enter++;
 	}
 	mutex_unlock(&syscall_trace_lock);
@@ -423,14 +431,18 @@ static void unreg_event_syscall_enter(struct trace_event_file *file,
 				      struct trace_event_call *call)
 {
 	struct trace_array *tr = file->tr;
-	int num;
+	int num, i;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
+	num = ((struct syscall_metadata *)call->data)->syscall_nr[0];
 	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return;
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_enter--;
-	RCU_INIT_POINTER(tr->enter_syscall_files[num], NULL);
+	for (i = 0; i < NR_syscall_tables; i++) {
+		num = ((struct syscall_metadata *)call->data)->syscall_nr[i];
+		if (num > 0 && num < NR_syscalls)
+			RCU_INIT_POINTER(tr->enter_syscall_files[num], NULL);
+	}
 	if (!tr->sys_refcount_enter)
 		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
 	mutex_unlock(&syscall_trace_lock);
@@ -441,16 +453,23 @@ static int reg_event_syscall_exit(struct trace_event_file *file,
 {
 	struct trace_array *tr = file->tr;
 	int ret = 0;
-	int num;
+	int num, i;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
+	num = ((struct syscall_metadata *)call->data)->syscall_nr[0];
 	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
 	if (!tr->sys_refcount_exit)
 		ret = register_trace_sys_exit(ftrace_syscall_exit, tr);
 	if (!ret) {
-		rcu_assign_pointer(tr->exit_syscall_files[num], file);
+		for (i = 0; i < NR_syscall_tables; i++) {
+			struct syscall_metadata *metadata = call->data;
+
+			num = metadata->syscall_nr[i];
+			if (num > 0 && num < NR_syscalls)
+				rcu_assign_pointer(
+					tr->exit_syscall_files[num], file);
+		}
 		tr->sys_refcount_exit++;
 	}
 	mutex_unlock(&syscall_trace_lock);
@@ -461,14 +480,18 @@ static void unreg_event_syscall_exit(struct trace_event_file *file,
 				     struct trace_event_call *call)
 {
 	struct trace_array *tr = file->tr;
-	int num;
+	int num, i;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
+	num = ((struct syscall_metadata *)call->data)->syscall_nr[0];
 	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
 		return;
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_exit--;
-	RCU_INIT_POINTER(tr->exit_syscall_files[num], NULL);
+	for (i = 0; i < NR_syscall_tables; i++) {
+		num = ((struct syscall_metadata *)call->data)->syscall_nr[i];
+		if (num > 0 && num < NR_syscalls)
+			RCU_INIT_POINTER(tr->exit_syscall_files[num], NULL);
+	}
 	if (!tr->sys_refcount_exit)
 		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
 	mutex_unlock(&syscall_trace_lock);
@@ -479,7 +502,7 @@ static int __init init_syscall_trace(struct trace_event_call *call)
 	int id;
 	int num;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
+	num = ((struct syscall_metadata *)call->data)->syscall_nr[0];
 	if (num < 0 || num >= NR_syscalls) {
 		pr_debug("syscall %s metadata not mapped, disabling ftrace event\n",
 				((struct syscall_metadata *)call->data)->name);
@@ -542,13 +565,19 @@ void __init init_ftrace_syscalls(void)
 	}
 
 	for (i = 0; i < NR_syscalls; i++) {
+		int j;
 		addr = arch_syscall_addr(i);
 		meta = find_syscall_meta(addr);
 		if (!meta)
 			continue;
 
-		meta->syscall_nr = i;
 		syscalls_metadata[i] = meta;
+		for (j = 0; j < NR_syscall_tables; j++) {
+			if (meta->syscall_nr[j] == -1) {
+				meta->syscall_nr[j] = i;
+				break;
+			}
+		}
 	}
 }
 
@@ -602,9 +631,7 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 static int perf_sysenter_enable(struct trace_event_call *call)
 {
 	int ret = 0;
-	int num;
-
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
+	int num, i;
 
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_perf_refcount_enter)
@@ -613,7 +640,13 @@ static int perf_sysenter_enable(struct trace_event_call *call)
 		pr_info("event trace: Could not activate"
 				"syscall entry trace point");
 	} else {
-		set_bit(num, enabled_perf_enter_syscalls);
+		for (i = 0; i < NR_syscall_tables; i++) {
+			struct syscall_metadata *metadata = call->data;
+
+			num = metadata->syscall_nr[i];
+			if (num > 0 && num < NR_syscalls)
+				set_bit(num, enabled_perf_enter_syscalls);
+		}
 		sys_perf_refcount_enter++;
 	}
 	mutex_unlock(&syscall_trace_lock);
@@ -622,13 +655,17 @@ static int perf_sysenter_enable(struct trace_event_call *call)
 
 static void perf_sysenter_disable(struct trace_event_call *call)
 {
-	int num;
-
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
+	int num, i;
 
 	mutex_lock(&syscall_trace_lock);
 	sys_perf_refcount_enter--;
-	clear_bit(num, enabled_perf_enter_syscalls);
+	for (i = 0; i < NR_syscall_tables; i++) {
+		struct syscall_metadata *metadata = call->data;
+
+		num = metadata->syscall_nr[i];
+		if (num > 0 && num < NR_syscalls)
+			clear_bit(num, enabled_perf_enter_syscalls);
+	}
 	if (!sys_perf_refcount_enter)
 		unregister_trace_sys_enter(perf_syscall_enter, NULL);
 	mutex_unlock(&syscall_trace_lock);
@@ -674,9 +711,7 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 static int perf_sysexit_enable(struct trace_event_call *call)
 {
 	int ret = 0;
-	int num;
-
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
+	int num, i;
 
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_perf_refcount_exit)
@@ -685,7 +720,13 @@ static int perf_sysexit_enable(struct trace_event_call *call)
 		pr_info("event trace: Could not activate"
 				"syscall exit trace point");
 	} else {
-		set_bit(num, enabled_perf_exit_syscalls);
+		for (i = 0; i < NR_syscall_tables; i++) {
+			struct syscall_metadata *metadata = call->data;
+
+			num = metadata->syscall_nr[i];
+			if (num > 0 && num < NR_syscalls)
+				set_bit(num, enabled_perf_exit_syscalls);
+		}
 		sys_perf_refcount_exit++;
 	}
 	mutex_unlock(&syscall_trace_lock);
@@ -694,13 +735,15 @@ static int perf_sysexit_enable(struct trace_event_call *call)
 
 static void perf_sysexit_disable(struct trace_event_call *call)
 {
-	int num;
-
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
+	int num, i;
 
 	mutex_lock(&syscall_trace_lock);
 	sys_perf_refcount_exit--;
-	clear_bit(num, enabled_perf_exit_syscalls);
+	for (i = 0; i < NR_syscall_tables; i++) {
+		num = ((struct syscall_metadata *)call->data)->syscall_nr[i];
+		if (num > 0 && num < NR_syscalls)
+			clear_bit(num, enabled_perf_exit_syscalls);
+	}
 	if (!sys_perf_refcount_exit)
 		unregister_trace_sys_exit(perf_syscall_exit, NULL);
 	mutex_unlock(&syscall_trace_lock);
-- 
2.7.4
