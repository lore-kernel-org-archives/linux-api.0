Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E97A3C433EF
	for <linux-api@archiver.kernel.org>; Fri, 24 Sep 2021 00:11:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBA3761241
	for <linux-api@archiver.kernel.org>; Fri, 24 Sep 2021 00:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243667AbhIXAMu (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 23 Sep 2021 20:12:50 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41614 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243656AbhIXAMt (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 23 Sep 2021 20:12:49 -0400
Received: from in02.mta.xmission.com ([166.70.13.52]:33162)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mTYo9-005GHU-6P; Thu, 23 Sep 2021 18:11:17 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:57290 helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mTYo7-008617-LO; Thu, 23 Sep 2021 18:11:16 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, <linux-api@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
References: <87v92qx2c6.fsf@disp2133>
Date:   Thu, 23 Sep 2021 19:11:08 -0500
In-Reply-To: <87v92qx2c6.fsf@disp2133> (Eric W. Biederman's message of "Thu,
        23 Sep 2021 19:08:09 -0500")
Message-ID: <87a6k2x277.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mTYo7-008617-LO;;;mid=<87a6k2x277.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+mRGgujfjxQcT6DhZ0b7fSGVrUsAZ73Og=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 4/6] exit: Factor coredump_exit_mm out of exit_mm
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


Separate the coredump logic from the ordinary exit_mm logic
by moving the coredump logic out of exit_mm into it's own
function coredump_exit_mm.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/coredump.c |  6 ++--
 kernel/exit.c | 76 +++++++++++++++++++++++++++------------------------
 mm/oom_kill.c |  6 ++--
 3 files changed, 47 insertions(+), 41 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 3224dee44d30..5e0e08a7fb9b 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -404,8 +404,8 @@ static int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
 	 *
 	 * do_exit:
 	 *	The caller holds mm->mmap_lock. This means that the task which
-	 *	uses this mm can't pass exit_mm(), so it can't exit or clear
-	 *	its ->mm.
+	 *	uses this mm can't pass coredump_exit_mm(), so it can't exit or
+	 *	clear its ->mm.
 	 *
 	 * de_thread:
 	 *	It does list_replace_rcu(&leader->tasks, &current->tasks),
@@ -500,7 +500,7 @@ static void coredump_finish(struct mm_struct *mm, bool core_dumped)
 		next = curr->next;
 		task = curr->task;
 		/*
-		 * see exit_mm(), curr->task must not see
+		 * see coredump_exit_mm(), curr->task must not see
 		 * ->task == NULL before we read ->next.
 		 */
 		smp_mb();
diff --git a/kernel/exit.c b/kernel/exit.c
index 91a43e57a32e..cb1619d8fd64 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -339,6 +339,46 @@ kill_orphaned_pgrp(struct task_struct *tsk, struct task_struct *parent)
 	}
 }
 
+static void coredump_exit_mm(struct mm_struct *mm)
+{
+	struct core_state *core_state;
+
+	/*
+	 * Serialize with any possible pending coredump.
+	 * We must hold mmap_lock around checking core_state
+	 * and clearing tsk->mm.  The core-inducing thread
+	 * will increment ->nr_threads for each thread in the
+	 * group with ->mm != NULL.
+	 */
+	core_state = mm->core_state;
+	if (core_state) {
+		struct core_thread self;
+
+		mmap_read_unlock(mm);
+
+		self.task = current;
+		if (self.task->flags & PF_SIGNALED)
+			self.next = xchg(&core_state->dumper.next, &self);
+		else
+			self.task = NULL;
+		/*
+		 * Implies mb(), the result of xchg() must be visible
+		 * to core_state->dumper.
+		 */
+		if (atomic_dec_and_test(&core_state->nr_threads))
+			complete(&core_state->startup);
+
+		for (;;) {
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			if (!self.task) /* see coredump_finish() */
+				break;
+			freezable_schedule();
+		}
+		__set_current_state(TASK_RUNNING);
+		mmap_read_lock(mm);
+	}
+}
+
 #ifdef CONFIG_MEMCG
 /*
  * A task is exiting.   If it owned this mm, find a new owner for the mm.
@@ -434,47 +474,13 @@ void mm_update_next_owner(struct mm_struct *mm)
 static void exit_mm(void)
 {
 	struct mm_struct *mm = current->mm;
-	struct core_state *core_state;
 
 	exit_mm_release(current, mm);
 	if (!mm)
 		return;
 	sync_mm_rss(mm);
-	/*
-	 * Serialize with any possible pending coredump.
-	 * We must hold mmap_lock around checking core_state
-	 * and clearing tsk->mm.  The core-inducing thread
-	 * will increment ->nr_threads for each thread in the
-	 * group with ->mm != NULL.
-	 */
 	mmap_read_lock(mm);
-	core_state = mm->core_state;
-	if (core_state) {
-		struct core_thread self;
-
-		mmap_read_unlock(mm);
-
-		self.task = current;
-		if (self.task->flags & PF_SIGNALED)
-			self.next = xchg(&core_state->dumper.next, &self);
-		else
-			self.task = NULL;
-		/*
-		 * Implies mb(), the result of xchg() must be visible
-		 * to core_state->dumper.
-		 */
-		if (atomic_dec_and_test(&core_state->nr_threads))
-			complete(&core_state->startup);
-
-		for (;;) {
-			set_current_state(TASK_UNINTERRUPTIBLE);
-			if (!self.task) /* see coredump_finish() */
-				break;
-			freezable_schedule();
-		}
-		__set_current_state(TASK_RUNNING);
-		mmap_read_lock(mm);
-	}
+	coredump_exit_mm(mm);
 	mmgrab(mm);
 	BUG_ON(mm != current->active_mm);
 	/* more a memory barrier than a real lock */
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 831340e7ad8b..295c8bdfd6c8 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -787,9 +787,9 @@ static inline bool __task_will_free_mem(struct task_struct *task)
 	struct signal_struct *sig = task->signal;
 
 	/*
-	 * A coredumping process may sleep for an extended period in exit_mm(),
-	 * so the oom killer cannot assume that the process will promptly exit
-	 * and release memory.
+	 * A coredumping process may sleep for an extended period in
+	 * coredump_exit_mm(), so the oom killer cannot assume that
+	 * the process will promptly exit and release memory.
 	 */
 	if (sig->flags & SIGNAL_GROUP_COREDUMP)
 		return false;
-- 
2.20.1

