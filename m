From: Pavel Emelyanov <xemul@parallels.com>
Subject: [PATCH 3/3] posix-timers: Show sigevent info in proc file
Date: Thu, 21 Feb 2013 22:22:58 +0400
Message-ID: <51266602.7000402@parallels.com>
References: <512665BA.9040802@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <512665BA.9040802@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Matthew Helsley <matt.helsley@gmail.com>, linux-api@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

After the "ID:" line there go

1. "signal:" line, that shows signal number and sigval bits;
2. "notify:" line, that shows the timer notification method.

The timer entry would looke like this:

ID: 123
signal: 14/0000000000b005d0
notify: signal/pid.732

This information is enough to understand ho the timer_create()
was called for each particular timer.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
---
 fs/proc/base.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index fc73d19..7f01e19 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2017,6 +2017,7 @@ struct timers_private {
 	struct pid *pid;
 	struct task_struct *task;
 	struct sighand_struct *sighand;
+	struct pid_namespace *ns;
 	unsigned long flags;
 };
 
@@ -2059,9 +2060,24 @@ static void timers_stop(struct seq_file *m, void *v)
 static int show_timer(struct seq_file *m, void *v)
 {
 	struct k_itimer *timer;
+	struct timers_private *tp = m->private;
+	int notify;
+	static char *nstr[] = {
+		[SIGEV_SIGNAL] = "signal",
+		[SIGEV_NONE] = "none",
+		[SIGEV_THREAD] = "thread",
+	};
 
 	timer = list_entry((struct list_head *)v, struct k_itimer, list);
+	notify = timer->it_sigev_notify;
+
 	seq_printf(m, "ID: %d\n", timer->it_id);
+	seq_printf(m, "signal: %d/%p\n", timer->sigq->info.si_signo,
+			timer->sigq->info.si_value.sival_ptr);
+	seq_printf(m, "notify: %s/%s.%d\n",
+		nstr[notify & ~SIGEV_THREAD_ID],
+		(notify & SIGEV_THREAD_ID) ? "tid" : "pid",
+		pid_nr_ns(timer->it_pid, tp->ns));
 
 	return 0;
 }
@@ -2083,6 +2099,7 @@ static int proc_timers_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	tp->pid = proc_pid(inode);
+	tp->ns = inode->i_sb->s_fs_info;
 	return 0;
 }
 
-- 
1.7.6.5
