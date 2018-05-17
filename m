From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] proc: Consolidate task->comm formatting into proc_task_name()
Date: Wed, 16 May 2018 21:34:47 -0700
Message-ID: <20180517043448.3152269-6-tj@kernel.org>
References: <20180517043448.3152269-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180517043448.3152269-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, jiangshanlai@gmail.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@fb.com, csmall@enc.com.au, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

proc shows task->comm in three places - comm, stat, status - and each
is fetching and formatting task->comm slighly differently.  This patch
renames task_name() to proc_task_name(), makes it more generic, and
updates all three paths to use it.

This will enable expanding comm reporting for workqueue workers.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/proc/array.c    | 26 +++++++++++++++-----------
 fs/proc/base.c     |  5 ++---
 fs/proc/internal.h |  2 ++
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index ae2c807..f29221e 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -95,7 +95,7 @@
 #include <asm/processor.h>
 #include "internal.h"
 
-static inline void task_name(struct seq_file *m, struct task_struct *p)
+void proc_task_name(struct seq_file *m, struct task_struct *p, bool escape)
 {
 	char *buf;
 	size_t size;
@@ -104,13 +104,17 @@ static inline void task_name(struct seq_file *m, struct task_struct *p)
 
 	get_task_comm(tcomm, p);
 
-	seq_puts(m, "Name:\t");
-
 	size = seq_get_buf(m, &buf);
-	ret = string_escape_str(tcomm, buf, size, ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
-	seq_commit(m, ret < size ? ret : -1);
+	if (escape) {
+		ret = string_escape_str(tcomm, buf, size,
+					ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
+		if (ret >= size)
+			ret = -1;
+	} else {
+		ret = strscpy(buf, tcomm, size);
+	}
 
-	seq_putc(m, '\n');
+	seq_commit(m, ret);
 }
 
 /*
@@ -365,7 +369,10 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
 {
 	struct mm_struct *mm = get_task_mm(task);
 
-	task_name(m, task);
+	seq_puts(m, "Name:\t");
+	proc_task_name(m, task, true);
+	seq_putc(m, '\n');
+
 	task_state(m, ns, pid, task);
 
 	if (mm) {
@@ -400,7 +407,6 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	u64 cutime, cstime, utime, stime;
 	u64 cgtime, gtime;
 	unsigned long rsslim = 0;
-	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
 
 	state = *get_task_state(task);
@@ -427,8 +433,6 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		}
 	}
 
-	get_task_comm(tcomm, task);
-
 	sigemptyset(&sigign);
 	sigemptyset(&sigcatch);
 	cutime = cstime = utime = stime = 0;
@@ -495,7 +499,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 
 	seq_put_decimal_ull(m, "", pid_nr_ns(pid, ns));
 	seq_puts(m, " (");
-	seq_puts(m, tcomm);
+	proc_task_name(m, task, false);
 	seq_puts(m, ") ");
 	seq_putc(m, state);
 	seq_put_decimal_ll(m, " ", ppid);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2eee4d7..eb17917ca 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1581,9 +1581,8 @@ static int comm_show(struct seq_file *m, void *v)
 	if (!p)
 		return -ESRCH;
 
-	task_lock(p);
-	seq_printf(m, "%s\n", p->comm);
-	task_unlock(p);
+	proc_task_name(m, p, false);
+	seq_putc(m, '\n');
 
 	put_task_struct(p);
 
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 0f1692e..b823fac62 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -131,6 +131,8 @@ unsigned name_to_int(const struct qstr *qstr);
  */
 extern const struct file_operations proc_tid_children_operations;
 
+extern void proc_task_name(struct seq_file *m, struct task_struct *p,
+			   bool escape);
 extern int proc_tid_stat(struct seq_file *, struct pid_namespace *,
 			 struct pid *, struct task_struct *);
 extern int proc_tgid_stat(struct seq_file *, struct pid_namespace *,
-- 
2.9.5
