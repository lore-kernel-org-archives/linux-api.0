From: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Subject: [PATCH v4 01/12] tracing/syscalls: remove syscall_nr from syscall metadata
Date: Fri, 14 Oct 2016 10:35:03 +0200
Message-ID: <1476434115-25428-2-git-send-email-marcin.nowakowski@imgtec.com>
References: <1476434115-25428-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476434115-25428-1-git-send-email-marcin.nowakowski@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, Marcin Nowakowski <marcin.nowakowski@imgtec.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-api@vger.kernel.org

Some architectures map multiple syscall numbers to a single syscall.
This meant that on those platforms, some system calls could not be
properly traced using syscall event tracing mechanism, as a different
number of a syscall was used for registration to the one used by
applications.
We can use syscall lookup together with the syscall metadata table
traversal to register for appropriate events instead. This slightly
increases the overhead during event (un)registration, but does not
impact the trace events themselves, which still use syscall numbers
directly.

Signed-off-by: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
 include/linux/syscalls.h      |   1 -
 include/trace/syscall.h       |   2 -
 kernel/trace/trace_syscalls.c | 125 ++++++++++++++++++++++++------------------
 3 files changed, 72 insertions(+), 56 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 0d7abb8..88324cc 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -160,7 +160,6 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	static struct syscall_metadata __used			\
 	  __syscall_meta_##sname = {				\
 		.name 		= "sys"#sname,			\
-		.syscall_nr	= -1,	/* Filled in at boot */	\
 		.nb_args 	= nb,				\
 		.types		= nb ? types_##sname : NULL,	\
 		.args		= nb ? args_##sname : NULL,	\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 7434f0f..b5fbebe 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -13,7 +13,6 @@
  * A syscall entry in the ftrace syscalls array.
  *
  * @name: name of the syscall
- * @syscall_nr: number of the syscall
  * @nb_args: number of parameters it takes
  * @types: list of types as strings
  * @args: list of args as strings (args[i] matches types[i])
@@ -23,7 +22,6 @@
  */
 struct syscall_metadata {
 	const char	*name;
-	int		syscall_nr;
 	int		nb_args;
 	const char	**types;
 	const char	**args;
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 5e10395..f50563a 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -405,16 +405,21 @@ static int reg_event_syscall_enter(struct trace_event_file *file,
 	int ret = 0;
 	int num;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
-		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
-	if (!tr->sys_refcount_enter)
+	if (!tr->sys_refcount_enter) {
 		ret = register_trace_sys_enter(ftrace_syscall_enter, tr);
-	if (!ret) {
-		rcu_assign_pointer(tr->enter_syscall_files[num], file);
-		tr->sys_refcount_enter++;
+		if (ret)
+			goto out_unlock;
+	}
+
+	for (num = 0; num < NR_syscalls; num++) {
+		if (syscalls_metadata[num] &&
+		   (syscalls_metadata[num] == call->data))
+			rcu_assign_pointer(tr->enter_syscall_files[num], file);
 	}
+	tr->sys_refcount_enter++;
+
+out_unlock:
 	mutex_unlock(&syscall_trace_lock);
 	return ret;
 }
@@ -425,12 +430,13 @@ static void unreg_event_syscall_enter(struct trace_event_file *file,
 	struct trace_array *tr = file->tr;
 	int num;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
-		return;
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_enter--;
-	RCU_INIT_POINTER(tr->enter_syscall_files[num], NULL);
+	for (num = 0; num < NR_syscalls; num++) {
+		if (syscalls_metadata[num] &&
+		   (syscalls_metadata[num] == call->data))
+			RCU_INIT_POINTER(tr->enter_syscall_files[num], NULL);
+	}
 	if (!tr->sys_refcount_enter)
 		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
 	mutex_unlock(&syscall_trace_lock);
@@ -443,16 +449,21 @@ static int reg_event_syscall_exit(struct trace_event_file *file,
 	int ret = 0;
 	int num;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
-		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
-	if (!tr->sys_refcount_exit)
+	if (!tr->sys_refcount_exit) {
 		ret = register_trace_sys_exit(ftrace_syscall_exit, tr);
-	if (!ret) {
-		rcu_assign_pointer(tr->exit_syscall_files[num], file);
-		tr->sys_refcount_exit++;
+		if (ret)
+			goto out_unlock;
 	}
+
+	for (num = 0; num < NR_syscalls; num++) {
+		if (syscalls_metadata[num] &&
+		   (syscalls_metadata[num] == call->data))
+			rcu_assign_pointer(tr->exit_syscall_files[num], file);
+	}
+	tr->sys_refcount_exit++;
+
+out_unlock:
 	mutex_unlock(&syscall_trace_lock);
 	return ret;
 }
@@ -463,12 +474,13 @@ static void unreg_event_syscall_exit(struct trace_event_file *file,
 	struct trace_array *tr = file->tr;
 	int num;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
-		return;
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_exit--;
-	RCU_INIT_POINTER(tr->exit_syscall_files[num], NULL);
+	for (num = 0; num < NR_syscalls; num++) {
+		if (syscalls_metadata[num] &&
+		   (syscalls_metadata[num] == call->data))
+			RCU_INIT_POINTER(tr->exit_syscall_files[num], NULL);
+	}
 	if (!tr->sys_refcount_exit)
 		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
 	mutex_unlock(&syscall_trace_lock);
@@ -477,14 +489,6 @@ static void unreg_event_syscall_exit(struct trace_event_file *file,
 static int __init init_syscall_trace(struct trace_event_call *call)
 {
 	int id;
-	int num;
-
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (num < 0 || num >= NR_syscalls) {
-		pr_debug("syscall %s metadata not mapped, disabling ftrace event\n",
-				((struct syscall_metadata *)call->data)->name);
-		return -ENOSYS;
-	}
 
 	if (set_syscall_print_fmt(call) < 0)
 		return -ENOMEM;
@@ -547,7 +551,6 @@ void __init init_ftrace_syscalls(void)
 		if (!meta)
 			continue;
 
-		meta->syscall_nr = i;
 		syscalls_metadata[i] = meta;
 	}
 }
@@ -604,17 +607,23 @@ static int perf_sysenter_enable(struct trace_event_call *call)
 	int ret = 0;
 	int num;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-
 	mutex_lock(&syscall_trace_lock);
-	if (!sys_perf_refcount_enter)
+	if (!sys_perf_refcount_enter) {
 		ret = register_trace_sys_enter(perf_syscall_enter, NULL);
-	if (ret) {
-		pr_info("event trace: Could not activate syscall entry trace point");
-	} else {
-		set_bit(num, enabled_perf_enter_syscalls);
-		sys_perf_refcount_enter++;
+		if (ret) {
+			pr_info("event trace: Could not activate syscall entry trace point");
+			goto out_unlock;
+		}
+	}
+
+	for (num = 0; num < NR_syscalls; num++) {
+		if (syscalls_metadata[num] &&
+		   (syscalls_metadata[num] == call->data))
+			set_bit(num, enabled_perf_enter_syscalls);
 	}
+	sys_perf_refcount_enter++;
+
+out_unlock:
 	mutex_unlock(&syscall_trace_lock);
 	return ret;
 }
@@ -623,11 +632,13 @@ static void perf_sysenter_disable(struct trace_event_call *call)
 {
 	int num;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-
 	mutex_lock(&syscall_trace_lock);
 	sys_perf_refcount_enter--;
-	clear_bit(num, enabled_perf_enter_syscalls);
+	for (num = 0; num < NR_syscalls; num++) {
+		if (syscalls_metadata[num] &&
+		   (syscalls_metadata[num] == call->data))
+			clear_bit(num, enabled_perf_enter_syscalls);
+	}
 	if (!sys_perf_refcount_enter)
 		unregister_trace_sys_enter(perf_syscall_enter, NULL);
 	mutex_unlock(&syscall_trace_lock);
@@ -675,17 +686,23 @@ static int perf_sysexit_enable(struct trace_event_call *call)
 	int ret = 0;
 	int num;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-
 	mutex_lock(&syscall_trace_lock);
-	if (!sys_perf_refcount_exit)
+	if (!sys_perf_refcount_exit) {
 		ret = register_trace_sys_exit(perf_syscall_exit, NULL);
-	if (ret) {
-		pr_info("event trace: Could not activate syscall exit trace point");
-	} else {
-		set_bit(num, enabled_perf_exit_syscalls);
-		sys_perf_refcount_exit++;
+		if (ret) {
+			pr_info("event trace: Could not activate syscall exit trace point");
+			goto out_unlock;
+		}
+	}
+
+	for (num = 0; num < NR_syscalls; num++) {
+		if (syscalls_metadata[num] &&
+		   (syscalls_metadata[num] == call->data))
+			set_bit(num, enabled_perf_exit_syscalls);
 	}
+	sys_perf_refcount_exit++;
+
+out_unlock:
 	mutex_unlock(&syscall_trace_lock);
 	return ret;
 }
@@ -694,11 +711,13 @@ static void perf_sysexit_disable(struct trace_event_call *call)
 {
 	int num;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-
 	mutex_lock(&syscall_trace_lock);
 	sys_perf_refcount_exit--;
-	clear_bit(num, enabled_perf_exit_syscalls);
+	for (num = 0; num < NR_syscalls; num++) {
+		if (syscalls_metadata[num] &&
+		   (syscalls_metadata[num] == call->data))
+			clear_bit(num, enabled_perf_exit_syscalls);
+	}
 	if (!sys_perf_refcount_exit)
 		unregister_trace_sys_exit(perf_syscall_exit, NULL);
 	mutex_unlock(&syscall_trace_lock);
-- 
2.7.4
