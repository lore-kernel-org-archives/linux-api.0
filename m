From: Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 16/24] proc: move first_tid and next_tid out of proc
Date: Mon,  6 Jul 2015 11:47:17 +0300
Message-ID: <1436172445-6979-17-git-send-email-avagin@openvz.org>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436172445-6979-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, Andrey Vagin <avagin@openvz.org>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Arnd Bergmann <arnd@arndb.de>, Arnaldo Carvalho de Melo <acme@kernel.org>, David Ahern <dsahern@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Pavel Odintsov <pavel.odintsov@gmail.com>
List-Id: linux-api@vger.kernel.org

They will be used in task_diag

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/proc/base.c          | 79 ++-----------------------------------------------
 include/linux/proc_fs.h |  4 +++
 kernel/pid.c            | 76 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+), 77 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index af797d9..4b72053 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3213,81 +3213,6 @@ out_no_task:
 	return ERR_PTR(result);
 }
 
-/*
- * Find the first tid of a thread group to return to user space.
- *
- * Usually this is just the thread group leader, but if the users
- * buffer was too small or there was a seek into the middle of the
- * directory we have more work todo.
- *
- * In the case of a short read we start with find_task_by_pid.
- *
- * In the case of a seek we start with the leader and walk nr
- * threads past it.
- */
-static struct task_struct *
-first_tid(struct task_struct *task, int tid, loff_t f_pos,
-					struct pid_namespace *ns)
-{
-	struct task_struct *pos;
-	unsigned long nr = f_pos;
-
-	if (nr != f_pos)	/* 32bit overflow? */
-		return NULL;
-
-	rcu_read_lock();
-
-	/* Attempt to start with the tid of a thread */
-	if (tid && nr) {
-		pos = find_task_by_pid_ns(tid, ns);
-		if (pos && same_thread_group(pos, task))
-			goto found;
-	}
-
-	/* If nr exceeds the number of threads there is nothing todo */
-	if (nr >= get_nr_threads(task))
-		goto fail;
-
-	/* If we haven't found our starting place yet start
-	 * with the leader and walk nr threads forward.
-	 */
-	pos = task = task->group_leader;
-	do {
-		if (!nr--)
-			goto found;
-	} while_each_thread(task, pos);
-fail:
-	pos = NULL;
-	goto out;
-found:
-	get_task_struct(pos);
-out:
-	rcu_read_unlock();
-	return pos;
-}
-
-/*
- * Find the next thread in the thread list.
- * Return NULL if there is an error or no next thread.
- *
- * The reference to the input task_struct is released.
- */
-static struct task_struct *next_tid(struct task_struct *start)
-{
-	struct task_struct *pos = NULL;
-	rcu_read_lock();
-	if (pid_alive(start)) {
-		pos = next_thread(start);
-		if (thread_group_leader(pos))
-			pos = NULL;
-		else
-			get_task_struct(pos);
-	}
-	rcu_read_unlock();
-	put_task_struct(start);
-	return pos;
-}
-
 /* for the /proc/TGID/task/ directories */
 static int proc_task_readdir(struct file *file, struct dir_context *ctx)
 {
@@ -3312,9 +3237,9 @@ static int proc_task_readdir(struct file *file, struct dir_context *ctx)
 	ns = inode->i_sb->s_fs_info;
 	tid = (int)file->f_version;
 	file->f_version = 0;
-	for (task = first_tid(start, tid, ctx->pos - 2, ns);
+	for (task = task_first_tid(start, tid, ctx->pos - 2, ns);
 	     task;
-	     task = next_tid(task), ctx->pos++) {
+	     task = task_next_tid(task), ctx->pos++) {
 		char name[PROC_NUMBUF];
 		int len;
 		tid = task_pid_nr_ns(task, ns);
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 62d0079..178f526 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -92,6 +92,10 @@ struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter iter);
 struct task_struct *
 task_next_child(struct task_struct *parent, struct task_struct *prev, unsigned int pos);
 
+struct task_struct *task_first_tid(struct task_struct *task, int tid, loff_t f_pos,
+					struct pid_namespace *ns);
+struct task_struct *task_next_tid(struct task_struct *start);
+
 struct mem_size_stats {
 	unsigned long resident;
 	unsigned long shared_clean;
diff --git a/kernel/pid.c b/kernel/pid.c
index 42a6b40..b66f370 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -661,6 +661,82 @@ out:
 }
 
 /*
+ * Find the first tid of a thread group to return to user space.
+ *
+ * Usually this is just the thread group leader, but if the users
+ * buffer was too small or there was a seek into the middle of the
+ * directory we have more work todo.
+ *
+ * In the case of a short read we start with find_task_by_pid.
+ *
+ * In the case of a seek we start with the leader and walk nr
+ * threads past it.
+ */
+struct task_struct *
+task_first_tid(struct task_struct *task, int tid, loff_t f_pos,
+					struct pid_namespace *ns)
+{
+	struct task_struct *pos;
+	unsigned long nr = f_pos;
+
+	if (nr != f_pos)	/* 32bit overflow? */
+		return NULL;
+
+	rcu_read_lock();
+
+	/* Attempt to start with the tid of a thread */
+	if (tid && nr) {
+		pos = find_task_by_pid_ns(tid, ns);
+		if (pos && same_thread_group(pos, task))
+			goto found;
+	}
+
+	/* If nr exceeds the number of threads there is nothing todo */
+	if (nr >= get_nr_threads(task))
+		goto fail;
+
+	/* If we haven't found our starting place yet start
+	 * with the leader and walk nr threads forward.
+	 */
+	pos = task = task->group_leader;
+	do {
+		if (!nr--)
+			goto found;
+	} while_each_thread(task, pos);
+fail:
+	pos = NULL;
+	goto out;
+found:
+	get_task_struct(pos);
+out:
+	rcu_read_unlock();
+	return pos;
+}
+
+/*
+ * Find the next thread in the thread list.
+ * Return NULL if there is an error or no next thread.
+ *
+ * The reference to the input task_struct is released.
+ */
+struct task_struct *task_next_tid(struct task_struct *start)
+{
+	struct task_struct *pos = NULL;
+	rcu_read_lock();
+	if (pid_alive(start)) {
+		pos = next_thread(start);
+		if (thread_group_leader(pos))
+			pos = NULL;
+		else
+			get_task_struct(pos);
+	}
+	rcu_read_unlock();
+	put_task_struct(start);
+	return pos;
+}
+
+
+/*
  * The pid hash table is scaled according to the amount of memory in the
  * machine.  From a minimum of 16 slots up to 4096 slots at one gigabyte or
  * more.
-- 
2.1.0
