From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 (was ghak32) V4 01/10] audit: collect audit task parameters
Date: Tue, 31 Jul 2018 16:07:36 -0400
Message-ID: <8e617ab568df28a66dfbe3284452de186b42fb0f.1533065887.git.rgb@redhat.com>
References: <cover.1533065887.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1533065887.git.rgb@redhat.com>
In-Reply-To: <cover.1533065887.git.rgb@redhat.com>
References: <cover.1533065887.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc: luto@kernel.org, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

The audit-related parameters in struct task_struct should ideally be
collected together and accessed through a standard audit API.

Collect the existing loginuid, sessionid and audit_context together in a
new struct audit_task_info called "audit" in struct task_struct.

Use kmem_cache to manage this pool of memory.
Un-inline audit_free() to be able to always recover that memory.

See: https://github.com/linux-audit/audit-kernel/issues/81

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h | 34 ++++++++++++++++++++++++----------
 include/linux/sched.h |  5 +----
 init/init_task.c      |  3 +--
 init/main.c           |  2 ++
 kernel/auditsc.c      | 51 ++++++++++++++++++++++++++++++++++++++++++---------
 kernel/fork.c         |  4 +++-
 6 files changed, 73 insertions(+), 26 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 9334fbe..8964332 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -219,8 +219,15 @@ static inline void audit_log_task_info(struct audit_buffer *ab,
 
 /* These are defined in auditsc.c */
 				/* Public API */
+struct audit_task_info {
+	kuid_t			loginuid;
+	unsigned int		sessionid;
+	struct audit_context	*ctx;
+};
+extern struct audit_task_info init_struct_audit;
+extern void __init audit_task_init(void);
 extern int  audit_alloc(struct task_struct *task);
-extern void __audit_free(struct task_struct *task);
+extern void audit_free(struct task_struct *task);
 extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
 				  unsigned long a2, unsigned long a3);
 extern void __audit_syscall_exit(int ret_success, long ret_value);
@@ -242,12 +249,15 @@ extern void audit_seccomp_actions_logged(const char *names,
 
 static inline void audit_set_context(struct task_struct *task, struct audit_context *ctx)
 {
-	task->audit_context = ctx;
+	task->audit->ctx = ctx;
 }
 
 static inline struct audit_context *audit_context(void)
 {
-	return current->audit_context;
+	if (current->audit)
+		return current->audit->ctx;
+	else
+		return NULL;
 }
 
 static inline bool audit_dummy_context(void)
@@ -255,11 +265,7 @@ static inline bool audit_dummy_context(void)
 	void *p = audit_context();
 	return !p || *(int *)p;
 }
-static inline void audit_free(struct task_struct *task)
-{
-	if (unlikely(task->audit_context))
-		__audit_free(task);
-}
+
 static inline void audit_syscall_entry(int major, unsigned long a0,
 				       unsigned long a1, unsigned long a2,
 				       unsigned long a3)
@@ -331,12 +337,18 @@ extern int auditsc_get_stamp(struct audit_context *ctx,
 
 static inline kuid_t audit_get_loginuid(struct task_struct *tsk)
 {
-	return tsk->loginuid;
+	if (tsk->audit)
+		return tsk->audit->loginuid;
+	else
+		return INVALID_UID;
 }
 
 static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
 {
-	return tsk->sessionid;
+	if (tsk->audit)
+		return tsk->audit->sessionid;
+	else
+		return AUDIT_SID_UNSET;
 }
 
 extern void __audit_ipc_obj(struct kern_ipc_perm *ipcp);
@@ -461,6 +473,8 @@ static inline void audit_fanotify(unsigned int response)
 extern int audit_n_rules;
 extern int audit_signals;
 #else /* CONFIG_AUDITSYSCALL */
+static inline void __init audit_task_init(void)
+{ }
 static inline int audit_alloc(struct task_struct *task)
 {
 	return 0;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 87bf02d..e117272 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -30,7 +30,6 @@
 #include <linux/rseq.h>
 
 /* task_struct member predeclarations (sorted alphabetically): */
-struct audit_context;
 struct backing_dev_info;
 struct bio_list;
 struct blk_plug;
@@ -873,10 +872,8 @@ struct task_struct {
 
 	struct callback_head		*task_works;
 
-	struct audit_context		*audit_context;
 #ifdef CONFIG_AUDITSYSCALL
-	kuid_t				loginuid;
-	unsigned int			sessionid;
+	struct audit_task_info		*audit;
 #endif
 	struct seccomp			seccomp;
 
diff --git a/init/init_task.c b/init/init_task.c
index 74f60ba..4058840 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -119,8 +119,7 @@ struct task_struct init_task
 	.thread_group	= LIST_HEAD_INIT(init_task.thread_group),
 	.thread_node	= LIST_HEAD_INIT(init_signals.thread_head),
 #ifdef CONFIG_AUDITSYSCALL
-	.loginuid	= INVALID_UID,
-	.sessionid	= AUDIT_SID_UNSET,
+	.audit		= &init_struct_audit,
 #endif
 #ifdef CONFIG_PERF_EVENTS
 	.perf_event_mutex = __MUTEX_INITIALIZER(init_task.perf_event_mutex),
diff --git a/init/main.c b/init/main.c
index 3b4ada1..6aba171 100644
--- a/init/main.c
+++ b/init/main.c
@@ -92,6 +92,7 @@
 #include <linux/rodata_test.h>
 #include <linux/jump_label.h>
 #include <linux/mem_encrypt.h>
+#include <linux/audit.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -721,6 +722,7 @@ asmlinkage __visible void __init start_kernel(void)
 	nsfs_init();
 	cpuset_init();
 	cgroup_init();
+	audit_task_init();
 	taskstats_init_early();
 	delayacct_init();
 
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index fb20746..88779a7 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -841,7 +841,7 @@ static inline struct audit_context *audit_take_context(struct task_struct *tsk,
 						      int return_valid,
 						      long return_code)
 {
-	struct audit_context *context = tsk->audit_context;
+	struct audit_context *context = tsk->audit->ctx;
 
 	if (!context)
 		return NULL;
@@ -926,6 +926,15 @@ static inline struct audit_context *audit_alloc_context(enum audit_state state)
 	return context;
 }
 
+static struct kmem_cache *audit_task_cache;
+
+void __init audit_task_init(void)
+{
+	audit_task_cache = kmem_cache_create("audit_task",
+					     sizeof(struct audit_task_info),
+					     0, SLAB_PANIC, NULL);
+}
+
 /**
  * audit_alloc - allocate an audit context block for a task
  * @tsk: task
@@ -940,17 +949,28 @@ int audit_alloc(struct task_struct *tsk)
 	struct audit_context *context;
 	enum audit_state     state;
 	char *key = NULL;
+	struct audit_task_info *info;
+
+	info = kmem_cache_zalloc(audit_task_cache, GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+	info->loginuid = audit_get_loginuid(current);
+	info->sessionid = audit_get_sessionid(current);
+	tsk->audit = info;
 
 	if (likely(!audit_ever_enabled))
 		return 0; /* Return if not auditing. */
 
 	state = audit_filter_task(tsk, &key);
 	if (state == AUDIT_DISABLED) {
+		audit_set_context(tsk, NULL);
 		clear_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
 		return 0;
 	}
 
 	if (!(context = audit_alloc_context(state))) {
+		tsk->audit = NULL;
+		kmem_cache_free(audit_task_cache, info);
 		kfree(key);
 		audit_log_lost("out of memory in audit_alloc");
 		return -ENOMEM;
@@ -962,6 +982,12 @@ int audit_alloc(struct task_struct *tsk)
 	return 0;
 }
 
+struct audit_task_info init_struct_audit = {
+	.loginuid = INVALID_UID,
+	.sessionid = AUDIT_SID_UNSET,
+	.ctx = NULL,
+};
+
 static inline void audit_free_context(struct audit_context *context)
 {
 	audit_free_names(context);
@@ -1469,26 +1495,33 @@ static void audit_log_exit(struct audit_context *context, struct task_struct *ts
 }
 
 /**
- * __audit_free - free a per-task audit context
+ * audit_free - free a per-task audit context
  * @tsk: task whose audit context block to free
  *
  * Called from copy_process and do_exit
  */
-void __audit_free(struct task_struct *tsk)
+void audit_free(struct task_struct *tsk)
 {
 	struct audit_context *context;
+	struct audit_task_info *info;
 
 	context = audit_take_context(tsk, 0, 0);
-	if (!context)
-		return;
-
 	/* Check for system calls that do not go through the exit
 	 * function (e.g., exit_group), then free context block.
 	 * We use GFP_ATOMIC here because we might be doing this
 	 * in the context of the idle thread */
 	/* that can happen only if we are called from do_exit() */
-	if (context->in_syscall && context->current_state == AUDIT_RECORD_CONTEXT)
+	if (context && context->in_syscall &&
+	    context->current_state == AUDIT_RECORD_CONTEXT)
 		audit_log_exit(context, tsk);
+	/* Freeing the audit_task_info struct must be performed after
+	 * audit_log_exit() due to need for loginuid and sessionid.
+	 */
+	info = tsk->audit;
+	tsk->audit = NULL;
+	kmem_cache_free(audit_task_cache, info);
+	if (!context)
+		return;
 	if (!list_empty(&context->killed_trees))
 		audit_kill_trees(&context->killed_trees);
 
@@ -2071,8 +2104,8 @@ int audit_set_loginuid(kuid_t loginuid)
 			sessionid = (unsigned int)atomic_inc_return(&session_id);
 	}
 
-	task->sessionid = sessionid;
-	task->loginuid = loginuid;
+	task->audit->sessionid = sessionid;
+	task->audit->loginuid = loginuid;
 out:
 	audit_log_set_loginuid(oldloginuid, loginuid, oldsessionid, sessionid, rc);
 	return rc;
diff --git a/kernel/fork.c b/kernel/fork.c
index 9440d61..1bfb0ff 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1721,7 +1721,9 @@ static __latent_entropy struct task_struct *copy_process(
 	p->start_time = ktime_get_ns();
 	p->real_start_time = ktime_get_boot_ns();
 	p->io_context = NULL;
-	audit_set_context(p, NULL);
+#ifdef CONFIG_AUDITSYSCALL
+	p->audit = NULL;
+#endif /* CONFIG_AUDITSYSCALL */
 	cgroup_fork(p);
 #ifdef CONFIG_NUMA
 	p->mempolicy = mpol_dup(p->mempolicy);
-- 
1.8.3.1
