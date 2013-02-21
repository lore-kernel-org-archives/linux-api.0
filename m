From: Pavel Emelyanov <xemul@parallels.com>
Subject: [PATCH 2/3] posix-timers: Introduce /proc/<pid>/timers file
Date: Thu, 21 Feb 2013 22:22:41 +0400
Message-ID: <512665F1.8080206@parallels.com>
References: <512665BA.9040802@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <512665BA.9040802@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Matthew Helsley <matt.helsley@gmail.com>, linux-api@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This file is about to contain info about posix timers armed by
a process. Since these timers are shared between threads, this
file is present on tgid level only, no such thing in tid subdirs.

The file format is expected to be the "/proc/<pid>/smaps"-like,
i.e. each timer will occupy seveal lines to allow for future
extending.

Each new timer entry starts with the

ID: <number>

line which is added by this patch.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
---
 fs/proc/base.c |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9b43ff77..fc73d19 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -85,6 +85,7 @@
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
 #include <linux/flex_array.h>
+#include <linux/posix-timers.h>
 #ifdef CONFIG_HARDWALL
 #include <asm/hardwall.h>
 #endif
@@ -2012,6 +2013,85 @@ static const struct file_operations proc_map_files_operations = {
 	.llseek		= default_llseek,
 };
 
+struct timers_private {
+	struct pid *pid;
+	struct task_struct *task;
+	struct sighand_struct *sighand;
+	unsigned long flags;
+};
+
+static void *timers_start(struct seq_file *m, loff_t *pos)
+{
+	struct timers_private *tp = m->private;
+
+	tp->task = get_pid_task(tp->pid, PIDTYPE_PID);
+	if (!tp->task)
+		return ERR_PTR(-ESRCH);
+
+	tp->sighand = lock_task_sighand(tp->task, &tp->flags);
+	if (!tp->sighand)
+		return ERR_PTR(-ESRCH);
+
+	return seq_list_start(&tp->task->signal->posix_timers, *pos);
+}
+
+static void *timers_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct timers_private *tp = m->private;
+	return seq_list_next(v, &tp->task->signal->posix_timers, pos);
+}
+
+static void timers_stop(struct seq_file *m, void *v)
+{
+	struct timers_private *tp = m->private;
+
+	if (tp->sighand) {
+		unlock_task_sighand(tp->task, &tp->flags);
+		tp->sighand = NULL;
+	}
+
+	if (tp->task) {
+		put_task_struct(tp->task);
+		tp->task = NULL;
+	}
+}
+
+static int show_timer(struct seq_file *m, void *v)
+{
+	struct k_itimer *timer;
+
+	timer = list_entry((struct list_head *)v, struct k_itimer, list);
+	seq_printf(m, "ID: %d\n", timer->it_id);
+
+	return 0;
+}
+
+static const struct seq_operations proc_timers_seq_ops = {
+	.start	= timers_start,
+	.next	= timers_next,
+	.stop	= timers_stop,
+	.show	= show_timer,
+};
+
+static int proc_timers_open(struct inode *inode, struct file *file)
+{
+	struct timers_private *tp;
+
+	tp = __seq_open_private(file, &proc_timers_seq_ops,
+			sizeof(struct timers_private));
+	if (!tp)
+		return -ENOMEM;
+
+	tp->pid = proc_pid(inode);
+	return 0;
+}
+
+static const struct file_operations proc_timers_operations = {
+	.open		= proc_timers_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release_private,
+};
 #endif /* CONFIG_CHECKPOINT_RESTORE */
 
 static struct dentry *proc_pident_instantiate(struct inode *dir,
@@ -2582,6 +2662,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
 #endif
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	REG("timers",	  S_IRUGO, proc_timers_operations),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file * filp,
-- 
1.7.6.5
