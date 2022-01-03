Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8123EC433FE
	for <linux-api@archiver.kernel.org>; Mon,  3 Jan 2022 21:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiACVeX (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 3 Jan 2022 16:34:23 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55768 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiACVeF (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 3 Jan 2022 16:34:05 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:54410)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4Uxw-008wD7-RU; Mon, 03 Jan 2022 14:34:04 -0700
Received: from ip68-110-24-146.om.om.cox.net ([68.110.24.146]:54408 helo=localhost.localdomain)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4Uxv-006zvm-8s; Mon, 03 Jan 2022 14:34:04 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date:   Mon,  3 Jan 2022 15:33:09 -0600
Message-Id: <20220103213312.9144-14-ebiederm@xmission.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
References: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1n4Uxv-006zvm-8s;;;mid=<20220103213312.9144-14-ebiederm@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.110.24.146;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/7rKcji5T4omSxiJmES4YaISAldVmmCdw=
X-SA-Exim-Connect-IP: 68.110.24.146
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 14/17] signal: Remove zap_other_threads
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

The two callers of zap_other_threads want different things. The
function do_group_exit wants to set the exit code and it does not care
about the number of threads exiting.  In de_thread the current thread
is not exiting so there is not really an exit code.

Since schedule_task_exit_locked factors out the tricky bits stop
sharing the loop in zap_other_threads between de_thread and
do_group_exit.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/exec.c                    | 12 +++++++++---
 include/linux/sched/signal.h |  1 -
 kernel/exit.c                |  9 ++++++++-
 kernel/signal.c              | 17 -----------------
 4 files changed, 17 insertions(+), 22 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 82db656ca709..b9f646fddc51 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1037,6 +1037,7 @@ static int de_thread(struct task_struct *tsk)
 	struct signal_struct *sig = tsk->signal;
 	struct sighand_struct *oldsighand = tsk->sighand;
 	spinlock_t *lock = &oldsighand->siglock;
+	struct task_struct *t;
 
 	if (thread_group_empty(tsk))
 		goto no_thread_group;
@@ -1055,9 +1056,14 @@ static int de_thread(struct task_struct *tsk)
 	}
 
 	sig->group_exec_task = tsk;
-	sig->notify_count = zap_other_threads(tsk);
-	if (!thread_group_leader(tsk))
-		sig->notify_count--;
+	sig->group_stop_count = 0;
+	sig->notify_count = 0;
+	__for_each_thread(sig, t) {
+		if (t == tsk)
+			continue;
+		sig->notify_count++;
+		schedule_task_exit_locked(t);
+	}
 
 	while (sig->notify_count) {
 		__set_current_state(TASK_KILLABLE);
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 7c62b7c29cc0..eed54f9ea2fc 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -343,7 +343,6 @@ extern void force_sig(int);
 extern void force_fatal_sig(int);
 extern void force_exit_sig(int);
 extern int send_sig(int, struct task_struct *, int);
-extern int zap_other_threads(struct task_struct *p);
 extern struct sigqueue *sigqueue_alloc(void);
 extern void sigqueue_free(struct sigqueue *);
 extern int send_sigqueue(struct sigqueue *, struct pid *, enum pid_type);
diff --git a/kernel/exit.c b/kernel/exit.c
index aedefe5eb0eb..27bc0ccfea78 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -918,9 +918,16 @@ do_group_exit(int exit_code)
 		else if (sig->group_exec_task)
 			exit_code = 0;
 		else {
+			struct task_struct *t;
+
 			sig->group_exit_code = exit_code;
 			sig->flags = SIGNAL_GROUP_EXIT;
-			zap_other_threads(current);
+			sig->group_stop_count = 0;
+			__for_each_thread(sig, t) {
+				if (t == current)
+					continue;
+				schedule_task_exit_locked(t);
+			}
 		}
 		spin_unlock_irq(&sighand->siglock);
 	}
diff --git a/kernel/signal.c b/kernel/signal.c
index cbfb9020368e..b0201e05be40 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1371,23 +1371,6 @@ void schedule_task_exit_locked(struct task_struct *task)
 	}
 }
 
-/*
- * Nuke all other threads in the group.
- */
-int zap_other_threads(struct task_struct *p)
-{
-	struct task_struct *t = p;
-	int count = 0;
-
-	p->signal->group_stop_count = 0;
-
-	while_each_thread(p, t) {
-		count++;
-		schedule_task_exit_locked(t);
-	}
-	return count;
-}
-
 struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
 					   unsigned long *flags)
 {
-- 
2.29.2

