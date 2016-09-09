From: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 1/3] tracing/syscalls: remove syscall_nr from syscall metadata
Date: Fri, 9 Sep 2016 10:03:27 +0200
Message-ID: <1473408209-17335-2-git-send-email-marcin.nowakowski@imgtec.com>
References: <1473408209-17335-1-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473408209-17335-1-git-send-email-marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
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
At the moment it doesn't seem possible to generate the required
syscall map table at build time - as the syscall numbers are assigned
in very arch-specific ways, so any change would require a lot of
arch-specific changes to map things appropriately. It doesn't seem like
a sensible thing to do for tracing purposes without a major change in
how syscall tables and numbers are defined for each arch.

Signed-off-by: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>

---
 include/linux/syscalls.h      |   1 -
 include/trace/syscall.h       |   2 -
 kernel/trace/trace_syscalls.c | 150 ++++++++++++++++++++++++++++--------------
 3 files changed, 100 insertions(+), 53 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index d022390..c13aadd 100644
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
index b2b6efc..1da10ca 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -404,17 +404,26 @@ static int reg_event_syscall_enter(struct trace_event_file *file,
 	struct trace_array *tr = file->tr;
 	int ret = 0;
 	int num;
+	const char *name;
+
+	name = ((const struct syscall_metadata *)call->data)->name;
 
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
+		    arch_syscall_match_sym_name(syscalls_metadata[num]->name,
+				    name))
+			rcu_assign_pointer(tr->enter_syscall_files[num], file);
 	}
+	tr->sys_refcount_enter++;
+
+out_unlock:
 	mutex_unlock(&syscall_trace_lock);
 	return ret;
 }
@@ -424,13 +433,17 @@ static void unreg_event_syscall_enter(struct trace_event_file *file,
 {
 	struct trace_array *tr = file->tr;
 	int num;
+	const char *name;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
-		return;
+	name = ((const struct syscall_metadata *)call->data)->name;
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_enter--;
-	RCU_INIT_POINTER(tr->enter_syscall_files[num], NULL);
+	for (num = 0; num < NR_syscalls; num++) {
+		if (syscalls_metadata[num] &&
+		   arch_syscall_match_sym_name(syscalls_metadata[num]->name,
+				   name))
+			RCU_INIT_POINTER(tr->enter_syscall_files[num], NULL);
+	}
 	if (!tr->sys_refcount_enter)
 		unregister_trace_sys_enter(ftrace_syscall_enter, tr);
 	mutex_unlock(&syscall_trace_lock);
@@ -442,17 +455,26 @@ static int reg_event_syscall_exit(struct trace_event_file *file,
 	struct trace_array *tr = file->tr;
 	int ret = 0;
 	int num;
+	const char *name;
+
+	name = ((const struct syscall_metadata *)call->data)->name;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
-		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
-	if (!tr->sys_refcount_exit)
-		ret = register_trace_sys_exit(ftrace_syscall_exit, tr);
-	if (!ret) {
-		rcu_assign_pointer(tr->exit_syscall_files[num], file);
-		tr->sys_refcount_exit++;
+	if (!tr->sys_refcount_exit) {
+		ret = register_trace_sys_enter(ftrace_syscall_exit, tr);
+		if (ret)
+			goto out_unlock;
+	}
+
+	for (num = 0; num < NR_syscalls; num++) {
+		if (syscalls_metadata[num] &&
+		    arch_syscall_match_sym_name(syscalls_metadata[num]->name,
+				    name))
+			rcu_assign_pointer(tr->exit_syscall_files[num], file);
 	}
+	tr->sys_refcount_exit++;
+
+out_unlock:
 	mutex_unlock(&syscall_trace_lock);
 	return ret;
 }
@@ -462,13 +484,18 @@ static void unreg_event_syscall_exit(struct trace_event_file *file,
 {
 	struct trace_array *tr = file->tr;
 	int num;
+	const char *name;
+
+	name = ((const struct syscall_metadata *)call->data)->name;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
-	if (WARN_ON_ONCE(num < 0 || num >= NR_syscalls))
-		return;
 	mutex_lock(&syscall_trace_lock);
 	tr->sys_refcount_exit--;
-	RCU_INIT_POINTER(tr->exit_syscall_files[num], NULL);
+	for (num = 0; num < NR_syscalls; num++) {
+		if (syscalls_metadata[num] &&
+		   arch_syscall_match_sym_name(syscalls_metadata[num]->name,
+				   name))
+			RCU_INIT_POINTER(tr->exit_syscall_files[num], NULL);
+	}
 	if (!tr->sys_refcount_exit)
 		unregister_trace_sys_exit(ftrace_syscall_exit, tr);
 	mutex_unlock(&syscall_trace_lock);
@@ -477,14 +504,6 @@ static void unreg_event_syscall_exit(struct trace_event_file *file,
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
@@ -547,7 +566,6 @@ void __init init_ftrace_syscalls(void)
 		if (!meta)
 			continue;
 
-		meta->syscall_nr = i;
 		syscalls_metadata[i] = meta;
 	}
 }
@@ -603,19 +621,29 @@ static int perf_sysenter_enable(struct trace_event_call *call)
 {
 	int ret = 0;
 	int num;
+	const char *name;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
+	name = ((const struct syscall_metadata *)call->data)->name;
 
 	mutex_lock(&syscall_trace_lock);
-	if (!sys_perf_refcount_enter)
+	if (!sys_perf_refcount_enter) {
 		ret = register_trace_sys_enter(perf_syscall_enter, NULL);
-	if (ret) {
-		pr_info("event trace: Could not activate"
+		if (ret) {
+			pr_info("event trace: Could not activate"
 				"syscall entry trace point");
-	} else {
-		set_bit(num, enabled_perf_enter_syscalls);
-		sys_perf_refcount_enter++;
+			goto out_unlock;
+		}
+	}
+
+	for (num = 0; num < NR_syscalls; num++) {
+		if (syscalls_metadata[num] &&
+		    arch_syscall_match_sym_name(syscalls_metadata[num]->name,
+				    name))
+			set_bit(num, enabled_perf_enter_syscalls);
 	}
+	sys_perf_refcount_enter++;
+
+out_unlock:
 	mutex_unlock(&syscall_trace_lock);
 	return ret;
 }
@@ -623,12 +651,18 @@ static int perf_sysenter_enable(struct trace_event_call *call)
 static void perf_sysenter_disable(struct trace_event_call *call)
 {
 	int num;
+	const char *name;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
+	name = ((const struct syscall_metadata *)call->data)->name;
 
 	mutex_lock(&syscall_trace_lock);
 	sys_perf_refcount_enter--;
-	clear_bit(num, enabled_perf_enter_syscalls);
+	for (num = 0; num < NR_syscalls; num++) {
+		if (syscalls_metadata[num] &&
+		    arch_syscall_match_sym_name(syscalls_metadata[num]->name,
+				    name))
+			clear_bit(num, enabled_perf_enter_syscalls);
+	}
 	if (!sys_perf_refcount_enter)
 		unregister_trace_sys_enter(perf_syscall_enter, NULL);
 	mutex_unlock(&syscall_trace_lock);
@@ -675,19 +709,29 @@ static int perf_sysexit_enable(struct trace_event_call *call)
 {
 	int ret = 0;
 	int num;
+	const char *name;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
+	name = ((const struct syscall_metadata *)call->data)->name;
 
 	mutex_lock(&syscall_trace_lock);
-	if (!sys_perf_refcount_exit)
+	if (!sys_perf_refcount_exit) {
 		ret = register_trace_sys_exit(perf_syscall_exit, NULL);
-	if (ret) {
-		pr_info("event trace: Could not activate"
+		if (ret) {
+			pr_info("event trace: Could not activate"
 				"syscall exit trace point");
-	} else {
-		set_bit(num, enabled_perf_exit_syscalls);
-		sys_perf_refcount_exit++;
+			goto out_unlock;
+		}
 	}
+
+	for (num = 0; num < NR_syscalls; num++) {
+		if (syscalls_metadata[num] &&
+		    arch_syscall_match_sym_name(syscalls_metadata[num]->name,
+				    name))
+			set_bit(num, enabled_perf_exit_syscalls);
+	}
+	sys_perf_refcount_exit++;
+
+out_unlock:
 	mutex_unlock(&syscall_trace_lock);
 	return ret;
 }
@@ -695,12 +739,18 @@ static int perf_sysexit_enable(struct trace_event_call *call)
 static void perf_sysexit_disable(struct trace_event_call *call)
 {
 	int num;
+	const char *name;
 
-	num = ((struct syscall_metadata *)call->data)->syscall_nr;
+	name = ((const struct syscall_metadata *)call->data)->name;
 
 	mutex_lock(&syscall_trace_lock);
 	sys_perf_refcount_exit--;
-	clear_bit(num, enabled_perf_exit_syscalls);
+	for (num = 0; num < NR_syscalls; num++) {
+		if (syscalls_metadata[num] &&
+		    arch_syscall_match_sym_name(syscalls_metadata[num]->name,
+				    name))
+			clear_bit(num, enabled_perf_exit_syscalls);
+	}
 	if (!sys_perf_refcount_exit)
 		unregister_trace_sys_exit(perf_syscall_exit, NULL);
 	mutex_unlock(&syscall_trace_lock);
-- 
2.7.4
