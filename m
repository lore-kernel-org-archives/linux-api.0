From: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 3/3] posix-timers: Show sigevent info in proc file
Date: Mon, 11 Mar 2013 13:13:08 +0400
Message-ID: <513DA024.80404@parallels.com>
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

Previous patch added proc file to list posix timers created by task.
Expand the information provided in this file by adding info about
notification method, with which timers were created. I.e. after
the "ID:" line there go

1. "signal:" line, that shows signal number and sigval bits;
2. "notify:" line, that shows the timer notification method.

Thus the timer entry would looke like this:

ID: 123
signal: 14/0000000000b005d0
notify: signal/pid.732

This information is enough to understand how the timer_create() was
called for each particular timer.

Signed-off-by: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 fs/proc/base.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 01def9f..a193086 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2018,6 +2018,7 @@ struct timers_private {
 	struct pid *pid;
 	struct task_struct *task;
 	struct sighand_struct *sighand;
+	struct pid_namespace *ns;
 	unsigned long flags;
 };
 
@@ -2060,9 +2061,24 @@ static void timers_stop(struct seq_file *m, void *v)
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
@@ -2084,6 +2100,7 @@ static int proc_timers_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	tp->pid = proc_pid(inode);
+	tp->ns = inode->i_sb->s_fs_info;
 	return 0;
 }
 
-- 
1.7.6.5
