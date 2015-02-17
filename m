From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 5/7] kernel: add ability to iterate children of a specified task
Date: Tue, 17 Feb 2015 11:20:24 +0300
Message-ID: <1424161226-15176-6-git-send-email-avagin@openvz.org>
References: <1424161226-15176-1-git-send-email-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424161226-15176-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Andrey Vagin <avagin@openvz.org>
List-Id: linux-api@vger.kernel.org

The interface is similar with the tgid iterator. It is used in
procfs and it will be used in task_diag.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/proc/array.c         | 58 +++++++++++++------------------------------------
 include/linux/proc_fs.h |  6 +++++
 kernel/pid.c            | 55 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 43 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index bd117d0..7197c6a 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -579,54 +579,26 @@ get_children_pid(struct inode *inode, struct pid *pid_prev, loff_t pos)
 {
 	struct task_struct *start, *task;
 	struct pid *pid = NULL;
+	struct child_iter iter;
 
-	read_lock(&tasklist_lock);
-
-	start = pid_task(proc_pid(inode), PIDTYPE_PID);
+	start = get_proc_task(inode);
 	if (!start)
-		goto out;
+		return NULL;
 
-	/*
-	 * Lets try to continue searching first, this gives
-	 * us significant speedup on children-rich processes.
-	 */
-	if (pid_prev) {
-		task = pid_task(pid_prev, PIDTYPE_PID);
-		if (task && task->real_parent == start &&
-		    !(list_empty(&task->sibling))) {
-			if (list_is_last(&task->sibling, &start->children))
-				goto out;
-			task = list_first_entry(&task->sibling,
-						struct task_struct, sibling);
-			pid = get_pid(task_pid(task));
-			goto out;
-		}
-	}
+	if (pid_prev)
+		task = get_pid_task(pid_prev, PIDTYPE_PID);
+	else
+		task = NULL;
 
-	/*
-	 * Slow search case.
-	 *
-	 * We might miss some children here if children
-	 * are exited while we were not holding the lock,
-	 * but it was never promised to be accurate that
-	 * much.
-	 *
-	 * "Just suppose that the parent sleeps, but N children
-	 *  exit after we printed their tids. Now the slow paths
-	 *  skips N extra children, we miss N tasks." (c)
-	 *
-	 * So one need to stop or freeze the leader and all
-	 * its children to get a precise result.
-	 */
-	list_for_each_entry(task, &start->children, sibling) {
-		if (pos-- == 0) {
-			pid = get_pid(task_pid(task));
-			break;
-		}
-	}
+	iter.parent = start;
+	iter.task = task;
+	iter.pos = pos;
+
+	iter = next_child(iter);
 
-out:
-	read_unlock(&tasklist_lock);
+	put_task_struct(start);
+	if (iter.task)
+		pid = get_pid(task_pid(iter.task));
 	return pid;
 }
 
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 136b6ed..eba98bc 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -89,4 +89,10 @@ struct tgid_iter {
 
 struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter iter);
 
+struct child_iter {
+	struct task_struct      *task, *parent;
+	unsigned int		pos;
+};
+
+struct child_iter next_child(struct child_iter iter);
 #endif /* _LINUX_PROC_FS_H */
diff --git a/kernel/pid.c b/kernel/pid.c
index 082307a..6e3e42a 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -606,6 +606,61 @@ retry:
 	return iter;
 }
 
+struct child_iter next_child(struct child_iter iter)
+{
+	struct task_struct *task;
+	loff_t pos = iter.pos;
+
+	read_lock(&tasklist_lock);
+
+	/*
+	 * Lets try to continue searching first, this gives
+	 * us significant speedup on children-rich processes.
+	 */
+	if (iter.task) {
+		task = iter.task;
+		if (task && task->real_parent == iter.parent &&
+		    !(list_empty(&task->sibling))) {
+			if (list_is_last(&task->sibling, &iter.parent->children)) {
+				task = NULL;
+				goto out;
+			}
+			task = list_first_entry(&task->sibling,
+						struct task_struct, sibling);
+			goto out;
+		}
+	}
+
+	/*
+	 * Slow search case.
+	 *
+	 * We might miss some children here if children
+	 * are exited while we were not holding the lock,
+	 * but it was never promised to be accurate that
+	 * much.
+	 *
+	 * "Just suppose that the parent sleeps, but N children
+	 *  exit after we printed their tids. Now the slow paths
+	 *  skips N extra children, we miss N tasks." (c)
+	 *
+	 * So one need to stop or freeze the leader and all
+	 * its children to get a precise result.
+	 */
+	list_for_each_entry(task, &iter.parent->children, sibling) {
+		if (pos-- == 0)
+			goto out;
+	}
+	task = NULL;
+out:
+	if (iter.task)
+		put_task_struct(iter.task);
+	if (task)
+		get_task_struct(task);
+	iter.task = task;
+	read_unlock(&tasklist_lock);
+	return iter;
+}
+
 /*
  * The pid hash table is scaled according to the amount of memory in the
  * machine.  From a minimum of 16 slots up to 4096 slots at one gigabyte or
-- 
2.1.0
