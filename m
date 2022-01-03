Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F95CC433EF
	for <linux-api@archiver.kernel.org>; Mon,  3 Jan 2022 21:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbiACVed (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 3 Jan 2022 16:34:33 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:45950 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiACVeP (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 3 Jan 2022 16:34:15 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:57238)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4Uy6-00ET2Z-UJ; Mon, 03 Jan 2022 14:34:14 -0700
Received: from ip68-110-24-146.om.om.cox.net ([68.110.24.146]:54408 helo=localhost.localdomain)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4Uy3-006zvm-E6; Mon, 03 Jan 2022 14:34:14 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date:   Mon,  3 Jan 2022 15:33:12 -0600
Message-Id: <20220103213312.9144-17-ebiederm@xmission.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
References: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1n4Uy3-006zvm-E6;;;mid=<20220103213312.9144-17-ebiederm@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.110.24.146;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/n11MnW3+3bV0i/GFwB5zyneexXh1Bojw=
X-SA-Exim-Connect-IP: 68.110.24.146
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 17/17] signal: Always set SIGNAL_GROUP_EXIT on process exit
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Track how many threads have not started exiting and when
the last thread starts exiting set SIGNAL_GROUP_EXIT.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/coredump.c                |  4 ----
 include/linux/sched/signal.h |  1 +
 kernel/exit.c                |  8 +-------
 kernel/fork.c                |  2 ++
 kernel/signal.c              | 10 +++++++---
 5 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index c54b502bf648..029d0f98aa90 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -352,10 +352,6 @@ static int zap_process(struct task_struct *start, int exit_code)
 	struct task_struct *t;
 	int nr = 0;
 
-	start->signal->flags = SIGNAL_GROUP_EXIT;
-	start->signal->group_exit_code = exit_code;
-	start->signal->group_stop_count = 0;
-
 	for_each_thread(start, t) {
 		schedule_task_exit_locked(t, exit_code);
 		if (t != current && !(t->flags & PF_POSTCOREDUMP))
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index e8034ecaee84..bd9435e934a1 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -94,6 +94,7 @@ struct signal_struct {
 	refcount_t		sigcnt;
 	atomic_t		live;
 	int			nr_threads;
+	int			quick_threads;
 	struct list_head	thread_head;
 
 	wait_queue_head_t	wait_chldexit;	/* for wait4() */
diff --git a/kernel/exit.c b/kernel/exit.c
index e95500e2d27c..be867a12de65 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -924,14 +924,8 @@ do_group_exit(int exit_code)
 		else {
 			struct task_struct *t;
 
-			sig->group_exit_code = exit_code;
-			sig->flags = SIGNAL_GROUP_EXIT;
-			sig->group_stop_count = 0;
-			__for_each_thread(sig, t) {
-				if (t == current)
-					continue;
+			__for_each_thread(sig, t)
 				schedule_task_exit_locked(t, exit_code);
-			}
 		}
 		spin_unlock_irq(&sighand->siglock);
 	}
diff --git a/kernel/fork.c b/kernel/fork.c
index 6f0293cb29c9..d973189a4014 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1644,6 +1644,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 		return -ENOMEM;
 
 	sig->nr_threads = 1;
+	sig->quick_threads = 1;
 	atomic_set(&sig->live, 1);
 	refcount_set(&sig->sigcnt, 1);
 
@@ -2383,6 +2384,7 @@ static __latent_entropy struct task_struct *copy_process(
 			__this_cpu_inc(process_counts);
 		} else {
 			current->signal->nr_threads++;
+			current->signal->quick_threads++;
 			atomic_inc(&current->signal->live);
 			refcount_inc(&current->signal->sigcnt);
 			task_join_group_stop(p);
diff --git a/kernel/signal.c b/kernel/signal.c
index e8fac8a3c935..9bd835fcb1dc 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1052,9 +1052,6 @@ static void complete_signal(int sig, struct task_struct *p, enum pid_type type)
 			 * running and doing things after a slower
 			 * thread has the fatal signal pending.
 			 */
-			signal->flags = SIGNAL_GROUP_EXIT;
-			signal->group_exit_code = sig;
-			signal->group_stop_count = 0;
 			t = p;
 			do {
 				schedule_task_exit_locked(t, sig);
@@ -1365,10 +1362,17 @@ int force_sig_info(struct kernel_siginfo *info)
 void schedule_task_exit_locked(struct task_struct *task, int exit_code)
 {
 	if (!(task->jobctl & JOBCTL_WILL_EXIT)) {
+		struct signal_struct *signal = task->signal;
 		task_clear_jobctl_pending(task, JOBCTL_PENDING_MASK);
 		task->jobctl |= JOBCTL_WILL_EXIT;
 		task->exit_code = exit_code;
 		signal_wake_up(task, 1);
+		signal->quick_threads--;
+		if (signal->quick_threads == 0) {
+			signal->flags = SIGNAL_GROUP_EXIT;
+			signal->group_exit_code = exit_code;
+			signal->group_stop_count = 0;
+		}
 	}
 }
 
-- 
2.29.2

