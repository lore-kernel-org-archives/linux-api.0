From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] workqueue: Show the latest workqueue name in /proc/PID/{comm,stat,status}
Date: Wed, 16 May 2018 21:34:48 -0700
Message-ID: <20180517043448.3152269-7-tj@kernel.org>
References: <20180517043448.3152269-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180517043448.3152269-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, jiangshanlai@gmail.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@fb.com, csmall@enc.com.au, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

There can be a lot of workqueue workers and they all show up with the
cryptic kworker/* names making it difficult to understand which is
doing what and how they came to be.

  # ps -ef | grep kworker
  root           4       2  0 Feb25 ?        00:00:00 [kworker/0:0H]
  root           6       2  0 Feb25 ?        00:00:00 [kworker/u112:0]
  root          19       2  0 Feb25 ?        00:00:00 [kworker/1:0H]
  root          25       2  0 Feb25 ?        00:00:00 [kworker/2:0H]
  root          31       2  0 Feb25 ?        00:00:00 [kworker/3:0H]
  ...

This patch makes workqueue workers report the latest workqueue it was
executing for through /proc/PID/{comm,stat,status}.  The extra
information is appended to the kthread name with intervening '+' if
currently executing, otherwise '-'.

  # cat /proc/25/comm
  kworker/2:0-events_power_efficient
  # cat /proc/25/stat
  25 (kworker/2:0-events_power_efficient) I 2 0 0 0 -1 69238880 0 0...
  # grep Name /proc/25/status
  Name:   kworker/2:0-events_power_efficient

Unfortunately, ps(1) truncates comm to 15 characters,

  # ps 25
    PID TTY      STAT   TIME COMMAND
     25 ?        I      0:00 [kworker/2:0-eve]

making it a lot less useful; however, this should be an easy fix from
ps(1) side.

Signed-off-by: Tejun Heo <tj@kernel.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Craig Small <csmall@enc.com.au>
---
 fs/proc/array.c           |  7 +++++--
 include/linux/workqueue.h |  1 +
 kernel/workqueue.c        | 39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index f29221e..bb1d361 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -99,10 +99,13 @@ void proc_task_name(struct seq_file *m, struct task_struct *p, bool escape)
 {
 	char *buf;
 	size_t size;
-	char tcomm[sizeof(p->comm)];
+	char tcomm[64];
 	int ret;
 
-	get_task_comm(tcomm, p);
+	if (p->flags & PF_WQ_WORKER)
+		wq_worker_comm(tcomm, sizeof(tcomm), p);
+	else
+		__get_task_comm(tcomm, sizeof(tcomm), p);
 
 	size = seq_get_buf(m, &buf);
 	if (escape) {
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 39a0e21..60d673e 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -494,6 +494,7 @@ extern unsigned int work_busy(struct work_struct *work);
 extern __printf(1, 2) void set_worker_desc(const char *fmt, ...);
 extern void print_worker_info(const char *log_lvl, struct task_struct *task);
 extern void show_workqueue_state(void);
+extern void wq_worker_comm(char *buf, size_t size, struct task_struct *task);
 
 /**
  * queue_work - queue work on a workqueue
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3fbe007..b4a39a1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4577,6 +4577,45 @@ void show_workqueue_state(void)
 	rcu_read_unlock_sched();
 }
 
+/* used to show worker information through /proc/PID/{comm,stat,status} */
+void wq_worker_comm(char *buf, size_t size, struct task_struct *task)
+{
+	struct worker *worker;
+	struct worker_pool *pool;
+	int off;
+
+	/* always show the actual comm */
+	off = strscpy(buf, task->comm, size);
+	if (off < 0)
+		return;
+
+	/* stabilize worker pool association */
+	mutex_lock(&wq_pool_attach_mutex);
+
+	worker = kthread_data(task);
+	pool = worker->pool;
+
+	if (pool) {
+		spin_lock_irq(&pool->lock);
+		/*
+		 * ->desc tracks information (wq name or set_worker_desc())
+		 * for the latest execution.  If current, prepend '+',
+		 * otherwise '-'.
+		 */
+		if (worker->desc[0] != '\0') {
+			if (worker->current_work)
+				scnprintf(buf + off, size - off, "+%s",
+					  worker->desc);
+			else
+				scnprintf(buf + off, size - off, "-%s",
+					  worker->desc);
+		}
+		spin_unlock_irq(&pool->lock);
+	}
+
+	mutex_unlock(&wq_pool_attach_mutex);
+}
+
 /*
  * CPU hotplug.
  *
-- 
2.9.5
