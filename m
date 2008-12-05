From: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Subject: [RFC v11][PATCH 10/13] External checkpoint of a task other than ourself
Date: Fri,  5 Dec 2008 12:31:19 -0500
Message-ID: <1228498282-11804-11-git-send-email-orenl__48961.2238518477$1228498885$gmane$org@cs.columbia.edu>
References: <1228498282-11804-1-git-send-email-orenl@cs.columbia.edu>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1228498282-11804-1-git-send-email-orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, MinChan Kim <minchan.kim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Now we can do "external" checkpoint, i.e. act on another task.

sys_checkpoint() now looks up the target pid (in our namespace) and
checkpoints that corresponding task. That task should be the root of
a container.

sys_restart() remains the same, as the restart is always done in the
context of the restarting task.

Changelog[v11]:
  - Copy contents of 'init->fs->root' instead of pointing to them

Changelog[v10]:
  - Grab vfs root of container init, rather than current process

Signed-off-by: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Acked-by: Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
---
 checkpoint/checkpoint.c    |   72 ++++++++++++++++++++++++++++++++++++++++++-
 checkpoint/restart.c       |    4 +-
 checkpoint/sys.c           |    6 ++++
 include/linux/checkpoint.h |    2 +
 4 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/checkpoint/checkpoint.c b/checkpoint/checkpoint.c
index 75c7cd3..f2d91f8 100644
--- a/checkpoint/checkpoint.c
+++ b/checkpoint/checkpoint.c
@@ -10,6 +10,7 @@
 
 #include <linux/version.h>
 #include <linux/sched.h>
+#include <linux/ptrace.h>
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/file.h>
@@ -225,6 +226,13 @@ static int cr_write_task(struct cr_ctx *ctx, struct task_struct *t)
 {
 	int ret;
 
+	/* TODO: verity that the task is frozen (unless self) */
+
+	if (t->state == TASK_DEAD) {
+		pr_warning("c/r: task may not be in state TASK_DEAD\n");
+		return -EAGAIN;
+	}
+
 	ret = cr_write_task_struct(ctx, t);
 	cr_debug("task_struct: ret %d\n", ret);
 	if (ret < 0)
@@ -247,22 +255,82 @@ static int cr_write_task(struct cr_ctx *ctx, struct task_struct *t)
 	return ret;
 }
 
+static int cr_get_container(struct cr_ctx *ctx, pid_t pid)
+{
+	struct task_struct *task = NULL;
+	struct nsproxy *nsproxy = NULL;
+	int err = -ESRCH;
+
+	ctx->root_pid = pid;
+
+	read_lock(&tasklist_lock);
+	task = find_task_by_vpid(pid);
+	if (task)
+		get_task_struct(task);
+	read_unlock(&tasklist_lock);
+
+	if (!task)
+		goto out;
+
+#if 0	/* enable to use containers */
+	if (!is_container_init(task)) {
+		err = -EINVAL;
+		goto out;
+	}
+#endif
+
+	if (!ptrace_may_access(task, PTRACE_MODE_READ)) {
+		err = -EPERM;
+		goto out;
+	}
+
+	rcu_read_lock();
+	if (task_nsproxy(task)) {
+		nsproxy = task_nsproxy(task);
+		get_nsproxy(nsproxy);
+	}
+	rcu_read_unlock();
+
+	if (!nsproxy)
+		goto out;
+
+	/* TODO: verify that the container is frozen */
+
+	ctx->root_task = task;
+	ctx->root_nsproxy = nsproxy;
+
+	return 0;
+
+ out:
+	if (task)
+		put_task_struct(task);
+	return err;
+}
+
+/* setup checkpoint-specific parts of ctx */
 static int cr_ctx_checkpoint(struct cr_ctx *ctx, pid_t pid)
 {
 	struct fs_struct *fs;
+	int ret;
 
 	ctx->root_pid = pid;
 
+	ret = cr_get_container(ctx, pid);
+	if (ret < 0)
+		return ret;
+
 	/*
 	 * assume checkpointer is in container's root vfs
 	 * FIXME: this works for now, but will change with real containers
 	 */
 
-	fs = current->fs;
+	task_lock(ctx->root_task);
+	fs = ctx->root_task->fs;
 	read_lock(&fs->lock);
 	ctx->fs_mnt = fs->root;
 	path_get(&ctx->fs_mnt);
 	read_unlock(&fs->lock);
+	task_unlock(ctx->root_task);
 
 	return 0;
 }
@@ -277,7 +345,7 @@ int do_checkpoint(struct cr_ctx *ctx, pid_t pid)
 	ret = cr_write_head(ctx);
 	if (ret < 0)
 		goto out;
-	ret = cr_write_task(ctx, current);
+	ret = cr_write_task(ctx, ctx->root_task);
 	if (ret < 0)
 		goto out;
 	ret = cr_write_tail(ctx);
diff --git a/checkpoint/restart.c b/checkpoint/restart.c
index 22e7995..f4f737d 100644
--- a/checkpoint/restart.c
+++ b/checkpoint/restart.c
@@ -277,7 +277,7 @@ static int cr_read_task(struct cr_ctx *ctx)
 }
 
 /* setup restart-specific parts of ctx */
-static int cr_ctx_restart(struct cr_ctx *ctx)
+static int cr_ctx_restart(struct cr_ctx *ctx, pid_t pid)
 {
 	return 0;
 }
@@ -286,7 +286,7 @@ int do_restart(struct cr_ctx *ctx, pid_t pid)
 {
 	int ret;
 
-	ret = cr_ctx_restart(ctx);
+	ret = cr_ctx_restart(ctx, pid);
 	if (ret < 0)
 		goto out;
 	ret = cr_read_head(ctx);
diff --git a/checkpoint/sys.c b/checkpoint/sys.c
index c077cd9..7083fff 100644
--- a/checkpoint/sys.c
+++ b/checkpoint/sys.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/sched.h>
+#include <linux/nsproxy.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/file.h>
@@ -141,6 +142,11 @@ static void cr_ctx_free(struct cr_ctx *ctx)
 	cr_pgarr_free(ctx);
 	cr_objhash_free(ctx);
 
+	if (ctx->root_nsproxy)
+		put_nsproxy(ctx->root_nsproxy);
+	if (ctx->root_task)
+		put_task_struct(ctx->root_task);
+
 	kfree(ctx);
 }
 
diff --git a/include/linux/checkpoint.h b/include/linux/checkpoint.h
index 3649f9c..3c29f8e 100644
--- a/include/linux/checkpoint.h
+++ b/include/linux/checkpoint.h
@@ -19,6 +19,8 @@ struct cr_ctx {
 	int crid;		/* unique checkpoint id */
 
 	pid_t root_pid;		/* container identifier */
+	struct task_struct *root_task;	/* container root task */
+	struct nsproxy *root_nsproxy;	/* container root nsproxy */
 
 	unsigned long flags;
 	unsigned long oflags;	/* restart: old flags */
-- 
1.5.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
