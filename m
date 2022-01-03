Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FEC5C4332F
	for <linux-api@archiver.kernel.org>; Mon,  3 Jan 2022 21:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiACVeR (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 3 Jan 2022 16:34:17 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55742 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiACVeC (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 3 Jan 2022 16:34:02 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:54298)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4Uxu-008wCZ-5g; Mon, 03 Jan 2022 14:34:02 -0700
Received: from ip68-110-24-146.om.om.cox.net ([68.110.24.146]:54408 helo=localhost.localdomain)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4Uxt-006zvm-1z; Mon, 03 Jan 2022 14:34:01 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date:   Mon,  3 Jan 2022 15:33:08 -0600
Message-Id: <20220103213312.9144-13-ebiederm@xmission.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
References: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1n4Uxt-006zvm-1z;;;mid=<20220103213312.9144-13-ebiederm@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.110.24.146;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/ve0A1nOdiKJFClkslmix271YQhosArc8=
X-SA-Exim-Connect-IP: 68.110.24.146
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 13/17] signal: Make individual tasks exiting a first class concept
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Add a helper schedule_task_exit_locked that is equivalent to
asynchronously calling exit(2) except for not having an exit code.

This is a generalization of what happens in de_thread, zap_process,
prepare_signal, complete_signal, and zap_other_threads when individual
tasks are asked to shutdown.

The various code paths optimize away the setting sigaddset and
signal_wake_up based on different conditions.  Neither sigaddset nor
signal_wake_up are needed if the task has already started running
do_exit.  So skip the work if PF_POSTCOREDUMP is set.  Which is the
earliest any of the original hand rolled implementations used.

Update get_signal to detect either signal group exit or a single task
exit by testing for __fatal_signal_pending.  This works because the
all of the tasks in group exits are killed with
schedule_task_exit_locked.

For clarity the code in get_signal has been updated to call do_exit
instead of do_group_exit when a single task is exiting.

While this schedule_task_exit_locked is a generalization of what
happens in prepare_signal I do not change prepare_signal to use
schedule_task_exit_locked to deliver SIGKILL to a coredumping process.
This keeps all of the specialness delivering a signal to a coredumping
process limited to prepare_signal and the coredump code itself.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/coredump.c                |  7 ++-----
 include/linux/sched/signal.h |  2 ++
 kernel/signal.c              | 36 +++++++++++++++++++++---------------
 3 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 09302a6a0d80..9559e29daada 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -358,12 +358,9 @@ static int zap_process(struct task_struct *start, int exit_code)
 	start->signal->group_stop_count = 0;
 
 	for_each_thread(start, t) {
-		task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
-		if (t != current && !(t->flags & PF_POSTCOREDUMP)) {
-			sigaddset(&t->pending.signal, SIGKILL);
-			signal_wake_up(t, 1);
+		schedule_task_exit_locked(t);
+		if (t != current && !(t->flags & PF_POSTCOREDUMP))
 			nr++;
-		}
 	}
 
 	return nr;
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index b6ecb9fc4cd2..7c62b7c29cc0 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -427,6 +427,8 @@ static inline void ptrace_signal_wake_up(struct task_struct *t, bool resume)
 	signal_wake_up_state(t, resume ? __TASK_TRACED : 0);
 }
 
+void schedule_task_exit_locked(struct task_struct *task);
+
 void task_join_group_stop(struct task_struct *task);
 
 #ifdef TIF_RESTORE_SIGMASK
diff --git a/kernel/signal.c b/kernel/signal.c
index 2a24cca00ca1..cbfb9020368e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1056,9 +1056,7 @@ static void complete_signal(int sig, struct task_struct *p, enum pid_type type)
 			signal->group_stop_count = 0;
 			t = p;
 			do {
-				task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
-				sigaddset(&t->pending.signal, SIGKILL);
-				signal_wake_up(t, 1);
+				schedule_task_exit_locked(t);
 			} while_each_thread(p, t);
 			return;
 		}
@@ -1363,6 +1361,16 @@ int force_sig_info(struct kernel_siginfo *info)
 	return force_sig_info_to_task(info, current, HANDLER_CURRENT);
 }
 
+void schedule_task_exit_locked(struct task_struct *task)
+{
+	task_clear_jobctl_pending(task, JOBCTL_PENDING_MASK);
+	/* Only bother with threads that might be alive */
+	if (!(task->flags & PF_POSTCOREDUMP)) {
+		sigaddset(&task->pending.signal, SIGKILL);
+		signal_wake_up(task, 1);
+	}
+}
+
 /*
  * Nuke all other threads in the group.
  */
@@ -1374,16 +1382,9 @@ int zap_other_threads(struct task_struct *p)
 	p->signal->group_stop_count = 0;
 
 	while_each_thread(p, t) {
-		task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);
 		count++;
-
-		/* Don't bother with already dead threads */
-		if (t->exit_state)
-			continue;
-		sigaddset(&t->pending.signal, SIGKILL);
-		signal_wake_up(t, 1);
+		schedule_task_exit_locked(t);
 	}
-
 	return count;
 }
 
@@ -2706,12 +2707,12 @@ bool get_signal(struct ksignal *ksig)
 
 	for (;;) {
 		struct k_sigaction *ka;
+		bool group_exit = true;
 		enum pid_type type;
 		int exit_code;
 
 		/* Has this task already been marked for death? */
-		if ((signal->flags & SIGNAL_GROUP_EXIT) ||
-		     signal->group_exec_task) {
+		if (__fatal_signal_pending(current)) {
 			ksig->info.si_signo = signr = SIGKILL;
 			sigdelset(&current->pending.signal, SIGKILL);
 			trace_signal_deliver(SIGKILL, SEND_SIG_NOINFO,
@@ -2719,8 +2720,10 @@ bool get_signal(struct ksignal *ksig)
 			recalc_sigpending();
 			if (signal->flags & SIGNAL_GROUP_EXIT)
 				exit_code = signal->group_exit_code;
-			else
+			else {
 				exit_code = 0;
+				group_exit = false;
+			}
 			goto fatal;
 		}
 
@@ -2880,7 +2883,10 @@ bool get_signal(struct ksignal *ksig)
 		/*
 		 * Death signals, no core dump.
 		 */
-		do_group_exit(exit_code);
+		if (group_exit)
+			do_group_exit(exit_code);
+		else
+			do_exit(exit_code);
 		/* NOTREACHED */
 	}
 	spin_unlock_irq(&sighand->siglock);
-- 
2.29.2

