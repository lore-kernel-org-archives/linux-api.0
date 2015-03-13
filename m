From: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 4/6] signal: Factor out a helper function to process
 task_struct exit_code
Date: Thu, 12 Mar 2015 18:40:45 -0700
Message-ID: <8a32364b6abda58bd85e08e0e671e3bfb14d489c.1426180120.git.josh@joshtriplett.org>
References: <cover.1426180120.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1426180120.git.josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Thiago Macieira <thiago.macieira@intel.com>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

do_notify_parent includes the code to convert the exit_code field of
struct task_struct to the code and status fields that accompany SIGCHLD.
Factor that out into a new helper function task_exit_code_status, to
allow other methods of task exit notification to share that code.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Thiago Macieira <thiago.macieira@intel.com>
---
 include/linux/sched.h |  1 +
 kernel/signal.c       | 24 +++++++++++++++---------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9ec36fd..668c58f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2386,6 +2386,7 @@ extern int kill_pid_info_as_cred(int, struct siginfo *, struct pid *,
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
+extern void task_exit_code_status(int exit_code, s32 *code, s32 *status);
 extern __must_check bool do_notify_parent(struct task_struct *, int);
 extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
 extern void force_sig(int, struct task_struct *);
diff --git a/kernel/signal.c b/kernel/signal.c
index a390499..f959d07 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1613,6 +1613,20 @@ ret:
 	return ret;
 }
 
+/* Translate exit_code to code and status. */
+void task_exit_code_status(int exit_code, s32 *code, s32 *status)
+{
+	*status = exit_code & 0x7f;
+	if (exit_code & 0x80)
+		*code = CLD_DUMPED;
+	else if (exit_code & 0x7f)
+		*code = CLD_KILLED;
+	else {
+		*code = CLD_EXITED;
+		*status = exit_code >> 8;
+	}
+}
+
 /*
  * Let a parent know about the death of a child.
  * For a stopped/continued status change, use do_notify_parent_cldstop instead.
@@ -1668,15 +1682,7 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	info.si_utime = cputime_to_clock_t(utime + tsk->signal->utime);
 	info.si_stime = cputime_to_clock_t(stime + tsk->signal->stime);
 
-	info.si_status = tsk->exit_code & 0x7f;
-	if (tsk->exit_code & 0x80)
-		info.si_code = CLD_DUMPED;
-	else if (tsk->exit_code & 0x7f)
-		info.si_code = CLD_KILLED;
-	else {
-		info.si_code = CLD_EXITED;
-		info.si_status = tsk->exit_code >> 8;
-	}
+	task_exit_code_status(tsk->exit_code, &info.si_code, &info.si_status);
 
 	psig = tsk->parent->sighand;
 	spin_lock_irqsave(&psig->siglock, flags);
-- 
2.1.4
