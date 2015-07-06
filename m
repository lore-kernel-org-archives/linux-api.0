From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 04/24] kernel: move next_tgid from fs/proc
Date: Mon,  6 Jul 2015 11:47:05 +0300
Message-ID: <1436172445-6979-5-git-send-email-avagin@openvz.org>
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
 fs/proc/base.c          | 43 -------------------------------------------
 include/linux/proc_fs.h |  7 +++++++
 kernel/pid.c            | 39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 43 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1d540b3..88cf6ae 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2994,49 +2994,6 @@ out:
 	return ERR_PTR(result);
 }
 
-/*
- * Find the first task with tgid >= tgid
- *
- */
-struct tgid_iter {
-	unsigned int tgid;
-	struct task_struct *task;
-};
-static struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter iter)
-{
-	struct pid *pid;
-
-	if (iter.task)
-		put_task_struct(iter.task);
-	rcu_read_lock();
-retry:
-	iter.task = NULL;
-	pid = find_ge_pid(iter.tgid, ns);
-	if (pid) {
-		iter.tgid = pid_nr_ns(pid, ns);
-		iter.task = pid_task(pid, PIDTYPE_PID);
-		/* What we to know is if the pid we have find is the
-		 * pid of a thread_group_leader.  Testing for task
-		 * being a thread_group_leader is the obvious thing
-		 * todo but there is a window when it fails, due to
-		 * the pid transfer logic in de_thread.
-		 *
-		 * So we perform the straight forward test of seeing
-		 * if the pid we have found is the pid of a thread
-		 * group leader, and don't worry if the task we have
-		 * found doesn't happen to be a thread group leader.
-		 * As we don't care in the case of readdir.
-		 */
-		if (!iter.task || !has_group_leader_pid(iter.task)) {
-			iter.tgid += 1;
-			goto retry;
-		}
-		get_task_struct(iter.task);
-	}
-	rcu_read_unlock();
-	return iter;
-}
-
 #define TGID_OFFSET (FIRST_PROCESS_ENTRY + 2)
 
 /* for the /proc/ directory itself, after non-process stuff has been done */
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index b97bf2e..136b6ed 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -82,4 +82,11 @@ static inline struct proc_dir_entry *proc_net_mkdir(
 	return proc_mkdir_data(name, 0, parent, net);
 }
 
+struct tgid_iter {
+	unsigned int tgid;
+	struct task_struct *task;
+};
+
+struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter iter);
+
 #endif /* _LINUX_PROC_FS_H */
diff --git a/kernel/pid.c b/kernel/pid.c
index 4fd07d5..2acb0a9 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -569,6 +569,45 @@ struct pid *find_ge_pid(int nr, struct pid_namespace *ns)
 }
 
 /*
+ * Find the first task with tgid >= tgid
+ *
+ */
+struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter iter)
+{
+	struct pid *pid;
+
+	if (iter.task)
+		put_task_struct(iter.task);
+	rcu_read_lock();
+retry:
+	iter.task = NULL;
+	pid = find_ge_pid(iter.tgid, ns);
+	if (pid) {
+		iter.tgid = pid_nr_ns(pid, ns);
+		iter.task = pid_task(pid, PIDTYPE_PID);
+		/* What we to know is if the pid we have find is the
+		 * pid of a thread_group_leader.  Testing for task
+		 * being a thread_group_leader is the obvious thing
+		 * todo but there is a window when it fails, due to
+		 * the pid transfer logic in de_thread.
+		 *
+		 * So we perform the straight forward test of seeing
+		 * if the pid we have found is the pid of a thread
+		 * group leader, and don't worry if the task we have
+		 * found doesn't happen to be a thread group leader.
+		 * As we don't care in the case of readdir.
+		 */
+		if (!iter.task || !has_group_leader_pid(iter.task)) {
+			iter.tgid += 1;
+			goto retry;
+		}
+		get_task_struct(iter.task);
+	}
+	rcu_read_unlock();
+	return iter;
+}
+
+/*
  * The pid hash table is scaled according to the amount of memory in the
  * machine.  From a minimum of 16 slots up to 4096 slots at one gigabyte or
  * more.
-- 
2.1.0
