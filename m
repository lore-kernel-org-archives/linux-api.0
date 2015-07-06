From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 09/24] proc: move task_next_child() from fs/proc
Date: Mon,  6 Jul 2015 11:47:10 +0300
Message-ID: <1436172445-6979-10-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

It's going to be used in task_diag.

Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 fs/proc/array.c         | 53 -------------------------------------------------
 include/linux/proc_fs.h |  3 +++
 kernel/pid.c            | 53 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 53 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 52c4a7b..e22266d 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -579,59 +579,6 @@ int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 
 #ifdef CONFIG_PROC_CHILDREN
 static struct task_struct *
-task_next_child(struct task_struct *parent, struct task_struct *prev, unsigned int pos)
-{
-	struct task_struct *task;
-
-	read_lock(&tasklist_lock);
-	/*
-	 * Lets try to continue searching first, this gives
-	 * us significant speedup on children-rich processes.
-	 */
-	if (prev) {
-		task = prev;
-		if (task && task->real_parent == parent &&
-		    !(list_empty(&task->sibling))) {
-			if (list_is_last(&task->sibling, &parent->children)) {
-				task = NULL;
-				goto out;
-			}
-			task = list_first_entry(&task->sibling,
-						struct task_struct, sibling);
-			goto out;
-		}
-	}
-
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
-	list_for_each_entry(task, &parent->children, sibling) {
-		if (pos-- == 0)
-			goto out;
-	}
-	task = NULL;
-out:
-	if (prev)
-		put_task_struct(prev);
-	if (task)
-		get_task_struct(task);
-	read_unlock(&tasklist_lock);
-	return task;
-}
-
-static struct task_struct *
 get_children_pid(struct inode *inode, struct task_struct *prev, loff_t pos)
 {
 	struct task_struct *start, *task = NULL;
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 136b6ed..497e58c 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -89,4 +89,7 @@ struct tgid_iter {
 
 struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter iter);
 
+struct task_struct *
+task_next_child(struct task_struct *parent, struct task_struct *prev, unsigned int pos);
+
 #endif /* _LINUX_PROC_FS_H */
diff --git a/kernel/pid.c b/kernel/pid.c
index 2acb0a9..42a6b40 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -607,6 +607,59 @@ retry:
 	return iter;
 }
 
+struct task_struct *
+task_next_child(struct task_struct *parent, struct task_struct *prev, unsigned int pos)
+{
+	struct task_struct *task;
+
+	read_lock(&tasklist_lock);
+	/*
+	 * Lets try to continue searching first, this gives
+	 * us significant speedup on children-rich processes.
+	 */
+	if (prev) {
+		task = prev;
+		if (task && task->real_parent == parent &&
+		    !(list_empty(&task->sibling))) {
+			if (list_is_last(&task->sibling, &parent->children)) {
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
+	list_for_each_entry(task, &parent->children, sibling) {
+		if (pos-- == 0)
+			goto out;
+	}
+	task = NULL;
+out:
+	if (prev)
+		put_task_struct(prev);
+	if (task)
+		get_task_struct(task);
+	read_unlock(&tasklist_lock);
+	return task;
+}
+
 /*
  * The pid hash table is scaled according to the amount of memory in the
  * machine.  From a minimum of 16 slots up to 4096 slots at one gigabyte or
-- 
2.1.0
