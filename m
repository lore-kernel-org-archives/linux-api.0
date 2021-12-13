Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14577C43217
	for <linux-api@archiver.kernel.org>; Mon, 13 Dec 2021 22:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244035AbhLMWyx (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 13 Dec 2021 17:54:53 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41836 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243998AbhLMWyt (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 13 Dec 2021 17:54:49 -0500
Received: from in01.mta.xmission.com ([166.70.13.51]:51148)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mwuDY-0081Wq-Jq; Mon, 13 Dec 2021 15:54:48 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:60446 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mwuDX-007pqT-D7; Mon, 13 Dec 2021 15:54:47 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Gladkov <legion@kernel.org>,
        Kyle Huey <me@kylehuey.com>, Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date:   Mon, 13 Dec 2021 16:53:47 -0600
Message-Id: <20211213225350.27481-5-ebiederm@xmission.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <87a6ha4zsd.fsf@email.froward.int.ebiederm.org>
References: <87a6ha4zsd.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1mwuDX-007pqT-D7;;;mid=<20211213225350.27481-5-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19D0HVmSWopdKjRTRDZCrYjQyUqNBe5SLc=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 5/8] signal: Remove SIGNAL_GROUP_COREDUMP
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

After the previous cleanups "signal->core_state" is set whenever
SIGNAL_GROUP_COREDUMP is set and "signal->core_state" is tested
whenver the code wants to know if a coredump is in progress.  The
remaining tests of SIGNAL_GROUP_COREDUMP also test to see if
SIGNAL_GROUP_EXIT is set.  Similarly the only place that sets
SIGNAL_GROUP_COREDUMP also sets SIGNAL_GROUP_EXIT.

Which makes SIGNAL_GROUP_COREDUMP unecessary and redundant so
stop setting SIGNAL_GROUP_COREDUMP, stop testing SIGNAL_GROUP_COREDUMP
and remove it's definition makeing the code slightly simpler.

With the setting of SIGNAL_GROUP_COREDUMP gone coredump_finish no
longer needs to clear SIGNAL_GROUP_COREDUMP out of signal->flags
by setting SIGNAL_GROUP_EXIT.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/coredump.c                | 3 +--
 include/linux/sched/signal.h | 3 +--
 kernel/signal.c              | 2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 5e5a90de7be3..2c9d16d4b57a 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -353,7 +353,7 @@ static int zap_process(struct task_struct *start, int exit_code)
 	int nr = 0;
 
 	/* Allow SIGKILL, see prepare_signal() */
-	start->signal->flags = SIGNAL_GROUP_EXIT | SIGNAL_GROUP_COREDUMP;
+	start->signal->flags = SIGNAL_GROUP_EXIT;
 	start->signal->group_exit_code = exit_code;
 	start->signal->group_stop_count = 0;
 
@@ -427,7 +427,6 @@ static void coredump_finish(bool core_dumped)
 	if (core_dumped && !__fatal_signal_pending(current))
 		current->signal->group_exit_code |= 0x80;
 	current->signal->group_exit_task = NULL;
-	current->signal->flags = SIGNAL_GROUP_EXIT;
 	next = current->signal->core_state->dumper.next;
 	current->signal->core_state = NULL;
 	spin_unlock_irq(&current->sighand->siglock);
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index fa26d2a58413..ecc10e148799 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -256,7 +256,6 @@ struct signal_struct {
 #define SIGNAL_STOP_STOPPED	0x00000001 /* job control stop in effect */
 #define SIGNAL_STOP_CONTINUED	0x00000002 /* SIGCONT since WCONTINUED reap */
 #define SIGNAL_GROUP_EXIT	0x00000004 /* group exit in progress */
-#define SIGNAL_GROUP_COREDUMP	0x00000008 /* coredump in progress */
 /*
  * Pending notifications to parent.
  */
@@ -272,7 +271,7 @@ struct signal_struct {
 static inline void signal_set_stop_flags(struct signal_struct *sig,
 					 unsigned int flags)
 {
-	WARN_ON(sig->flags & (SIGNAL_GROUP_EXIT|SIGNAL_GROUP_COREDUMP));
+	WARN_ON(sig->flags & SIGNAL_GROUP_EXIT);
 	sig->flags = (sig->flags & ~SIGNAL_STOP_MASK) | flags;
 }
 
diff --git a/kernel/signal.c b/kernel/signal.c
index cdccbacac685..9eb3e2c1f9f7 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -906,7 +906,7 @@ static bool prepare_signal(int sig, struct task_struct *p, bool force)
 	struct task_struct *t;
 	sigset_t flush;
 
-	if (signal->flags & (SIGNAL_GROUP_EXIT | SIGNAL_GROUP_COREDUMP)) {
+	if (signal->flags & SIGNAL_GROUP_EXIT) {
 		struct core_state *core_state = signal->core_state;
 		if (core_state) {
 			if (sig == SIGKILL) {
-- 
2.29.2

