From: Djalal Harouni <tixxdz@gmail.com>
Subject: [PATCH RFC v2 1/3] LSM: Allow per LSM module per "struct task_struct" blob.
Date: Sun,  9 Apr 2017 12:42:08 +0200
Message-ID: <1491734530-25002-2-git-send-email-tixxdz@gmail.com>
References: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org
Cc: Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, serge@hallyn.com, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Since several modules are planning to use per "struct task_struct" blob,
we need a layer for isolating it. Therefore, this patch introduces per LSM
module per "struct task_struct" blob.

It would be possible to remember location in security_hook_heads.task_alloc
list and undo up to the corresponding security_hook_heads.task_free list
when task_alloc hook failed. But this patch calls all task_free hooks
without checking whether the corresponding task_alloc hook was called
since most modules should be able to handle this correctly.

How to calculate amount of needed bytes and allocate memory for initial
task is a chicken-or-egg syndrome. We need to know how many bytes needs
to be allocated for initial task's security blobs before security_init()
is called. But security_reserve_task_blob_index() which calculates amount
of needed bytes is called from security_init(). We will need to split
module registration into three steps. The first step is call
security_reserve_task_blob_index() on all modules which should be
activated. The second step is allocate memory for the initial task's
security blob. The third step is actually activate all modules which
should be activated.

Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/lsm_hooks.h | 36 +++++++++++++++++++++++++++++++++++-
 security/security.c       | 37 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 080f34e..ca19cdb 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -27,6 +27,7 @@
 #include <linux/security.h>
 #include <linux/init.h>
 #include <linux/rculist.h>
+#include <linux/sched.h> /* "struct task_struct" */
 
 /**
  * Security hooks for program execution operations.
@@ -536,7 +537,10 @@
  * @task_alloc:
  *	@task task being allocated.
  *	@clone_flags contains the flags indicating what should be shared.
- *	Handle allocation of task-related resources.
+ *	Handle allocation of task-related resources. Note that task_free is
+ *	called even if task_alloc failed. This means that all task_free users
+ *	have to be prepared for task_free being called without corresponding
+ *	task_alloc call.
  *	Returns a zero on success, negative values on failure.
  * @task_free:
  *	@task task about to be freed.
@@ -1947,4 +1951,34 @@ void __init loadpin_add_hooks(void);
 static inline void loadpin_add_hooks(void) { };
 #endif
 
+/*
+ * Per "struct task_struct" security blob is managed using index numbers.
+ *
+ * Any user who wants to use per "struct task_struct" security blob reserves an
+ * index number using security_reserve_task_blob_index() before calling
+ * security_add_hooks().
+ *
+ * security_reserve_task_blob_index() returns an index number which has to be
+ * passed to task_security() by that user when fetching security blob of given
+ * "struct task_struct" for that user.
+ *
+ * Security blob for newly allocated "struct task_struct" is allocated and
+ * initialized with 0 inside security_task_alloc(), before calling each user's
+ * task_alloc hook. Be careful with task_free hook, for security_task_free()
+ * can be called when calling each user's task_alloc hook failed.
+ *
+ * Note that security_reserve_task_blob_index() uses "u16". It is not a good
+ * idea to directly reserve large amount. Sum of reserved amount by all users
+ * should be less than PAGE_SIZE bytes, for per "struct task_struct" security
+ * blob is allocated for each "struct task_struct" using kcalloc().
+ */
+extern u16 __init security_reserve_task_blob_index(const u16 size);
+static inline void *task_security(const struct task_struct *task,
+				  const u16 index)
+{
+	unsigned long *p = task->security;
+
+	return p + index;
+}
+
 #endif /* ! __LINUX_LSM_HOOKS_H */
diff --git a/security/security.c b/security/security.c
index 549bddc..4dc6bca 100644
--- a/security/security.c
+++ b/security/security.c
@@ -32,6 +32,7 @@
 /* Maximum number of letters for an LSM name string */
 #define SECURITY_NAME_MAX	10
 
+static u16 lsm_max_per_task_blob_index __ro_after_init;
 struct security_hook_heads security_hook_heads __lsm_ro_after_init;
 char *lsm_names;
 /* Boot-time LSM user choice */
@@ -75,6 +76,15 @@ int __init security_init(void)
 	 */
 	do_security_initcalls();
 
+	/*
+	 * Allocate per "struct task_struct" blob for initial task.
+	 * Initialization is done later by each module which needs it.
+	 */
+	if (lsm_max_per_task_blob_index)
+		current->security = kcalloc(lsm_max_per_task_blob_index,
+					    sizeof(unsigned long),
+					    GFP_KERNEL | __GFP_NOFAIL);
+
 	return 0;
 }
 
@@ -86,6 +96,15 @@ static int __init choose_lsm(char *str)
 }
 __setup("security=", choose_lsm);
 
+u16 __init security_reserve_task_blob_index(const u16 size)
+{
+	const u16 index = lsm_max_per_task_blob_index;
+	u16 requested = DIV_ROUND_UP(size, sizeof(unsigned long));
+
+	lsm_max_per_task_blob_index += requested;
+	return index;
+}
+
 static int lsm_append(char *new, char **result)
 {
 	char *cp;
@@ -939,12 +958,28 @@ int security_task_create(unsigned long clone_flags)
 
 int security_task_alloc(struct task_struct *task, unsigned long clone_flags)
 {
-	return call_int_hook(task_alloc, 0, task, clone_flags);
+	int rc;
+	const unsigned long index = lsm_max_per_task_blob_index;
+
+	if (index) {
+		task->security = kcalloc(index, sizeof(unsigned long),
+					 GFP_KERNEL);
+		if (unlikely(!task->security))
+			return -ENOMEM;
+	}
+	rc = call_int_hook(task_alloc, 0, task, clone_flags);
+	if (unlikely(rc))
+		security_task_free(task);
+	return rc;
 }
 
 void security_task_free(struct task_struct *task)
 {
 	call_void_hook(task_free, task);
+	if (lsm_max_per_task_blob_index) {
+		kfree(task->security);
+		task->security = NULL;
+	}
 }
 
 int security_cred_alloc_blank(struct cred *cred, gfp_t gfp)
-- 
2.10.2

