From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 08/24] proc: pick out a function to iterate task children
Date: Mon,  6 Jul 2015 11:47:09 +0300
Message-ID: <1436172445-6979-9-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Roger Luethi <rl-7uj+XXdSDtwfv37vnLkPlQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pavel Odintsov <pavel.odintsov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This function will be used in task_diag.

Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 fs/proc/array.c | 67 ++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 27 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index ce065cf..52c4a7b 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -578,31 +578,26 @@ int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 }
 
 #ifdef CONFIG_PROC_CHILDREN
-static struct pid *
-get_children_pid(struct inode *inode, struct pid *pid_prev, loff_t pos)
+static struct task_struct *
+task_next_child(struct task_struct *parent, struct task_struct *prev, unsigned int pos)
 {
-	struct task_struct *start, *task;
-	struct pid *pid = NULL;
+	struct task_struct *task;
 
 	read_lock(&tasklist_lock);
-
-	start = pid_task(proc_pid(inode), PIDTYPE_PID);
-	if (!start)
-		goto out;
-
 	/*
 	 * Lets try to continue searching first, this gives
 	 * us significant speedup on children-rich processes.
 	 */
-	if (pid_prev) {
-		task = pid_task(pid_prev, PIDTYPE_PID);
-		if (task && task->real_parent == start &&
+	if (prev) {
+		task = prev;
+		if (task && task->real_parent == parent &&
 		    !(list_empty(&task->sibling))) {
-			if (list_is_last(&task->sibling, &start->children))
+			if (list_is_last(&task->sibling, &parent->children)) {
+				task = NULL;
 				goto out;
+			}
 			task = list_first_entry(&task->sibling,
 						struct task_struct, sibling);
-			pid = get_pid(task_pid(task));
 			goto out;
 		}
 	}
@@ -622,16 +617,34 @@ get_children_pid(struct inode *inode, struct pid *pid_prev, loff_t pos)
 	 * So one need to stop or freeze the leader and all
 	 * its children to get a precise result.
 	 */
-	list_for_each_entry(task, &start->children, sibling) {
-		if (pos-- == 0) {
-			pid = get_pid(task_pid(task));
-			break;
-		}
+	list_for_each_entry(task, &parent->children, sibling) {
+		if (pos-- == 0)
+			goto out;
 	}
-
+	task = NULL;
 out:
+	if (prev)
+		put_task_struct(prev);
+	if (task)
+		get_task_struct(task);
 	read_unlock(&tasklist_lock);
-	return pid;
+	return task;
+}
+
+static struct task_struct *
+get_children_pid(struct inode *inode, struct task_struct *prev, loff_t pos)
+{
+	struct task_struct *start, *task = NULL;
+
+	start = get_proc_task(inode);
+	if (!start)
+		goto out;
+
+	task = task_next_child(start, prev, pos);
+
+	put_task_struct(start);
+out:
+	return task;
 }
 
 static int children_seq_show(struct seq_file *seq, void *v)
@@ -639,7 +652,7 @@ static int children_seq_show(struct seq_file *seq, void *v)
 	struct inode *inode = seq->private;
 	pid_t pid;
 
-	pid = pid_nr_ns(v, inode->i_sb->s_fs_info);
+	pid = task_pid_nr_ns(v, inode->i_sb->s_fs_info);
 	seq_printf(seq, "%d ", pid);
 
 	return 0;
@@ -652,18 +665,18 @@ static void *children_seq_start(struct seq_file *seq, loff_t *pos)
 
 static void *children_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct pid *pid;
+	struct task_struct *task;
 
-	pid = get_children_pid(seq->private, v, *pos + 1);
-	put_pid(v);
+	task = get_children_pid(seq->private, v, *pos + 1);
 
 	++*pos;
-	return pid;
+	return task;
 }
 
 static void children_seq_stop(struct seq_file *seq, void *v)
 {
-	put_pid(v);
+	if (v)
+		put_task_struct(v);
 }
 
 static const struct seq_operations children_seq_ops = {
-- 
2.1.0
