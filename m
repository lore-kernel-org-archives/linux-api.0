From: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 2/3] posix-timers: Introduce /proc/<pid>/timers file
Date: Mon, 11 Mar 2013 13:12:45 +0400
Message-ID: <513DA00D.6070009@parallels.com>
References: <513D9FD9.6020507@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <513D9FD9.6020507-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Helsley <matt.helsley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Currently kernel doesn't provide any API for getting info about
what posix timers are configured by tasks. It's implied, that
task, that configured some timers, knows what it did. However,
for external tools it's impossible to get this information. In
particular, this is critical for checkpoint-restore project to
have this info.

That said, the proposal is to introduce the per-pid proc file
with information about posix timers. Since these timers are shared
between threads, this file is present on tgid level only, no such
thing in tid subdirs.

The file format is expected to be the "/proc/<pid>/smaps"-like,
i.e. each timer will occupy seveal lines to allow for future
extending.

Each new timer entry starts with the

ID: <number>

line which is added by this patch.

Signed-off-by: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 fs/proc/base.c |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 69078c7..01def9f 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -86,6 +86,7 @@
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
 #include <linux/flex_array.h>
+#include <linux/posix-timers.h>
 #ifdef CONFIG_HARDWALL
 #include <asm/hardwall.h>
 #endif
@@ -2013,6 +2014,85 @@ static const struct file_operations proc_map_files_operations = {
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
@@ -2583,6 +2663,9 @@ static const struct pid_entry tgid_base_stuff[] = {
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
