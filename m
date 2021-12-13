Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A77C433EF
	for <linux-api@archiver.kernel.org>; Mon, 13 Dec 2021 22:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243975AbhLMWym (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 13 Dec 2021 17:54:42 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41786 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234858AbhLMWyl (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 13 Dec 2021 17:54:41 -0500
Received: from in01.mta.xmission.com ([166.70.13.51]:50904)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mwuDQ-0081Vk-QH; Mon, 13 Dec 2021 15:54:40 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:60446 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mwuDP-007pqT-NN; Mon, 13 Dec 2021 15:54:40 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Gladkov <legion@kernel.org>,
        Kyle Huey <me@kylehuey.com>, Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date:   Mon, 13 Dec 2021 16:53:44 -0600
Message-Id: <20211213225350.27481-2-ebiederm@xmission.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <87a6ha4zsd.fsf@email.froward.int.ebiederm.org>
References: <87a6ha4zsd.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1mwuDP-007pqT-NN;;;mid=<20211213225350.27481-2-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+c92wFPwUv8392NprGtfCDOlVLwBLUWmE=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 2/8] signal: Drop signals received after a fatal signal has been processed
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

In 403bad72b67d ("coredump: only SIGKILL should interrupt the
coredumping task") Oleg modified the kernel to drop all signals that
come in during a coredump except SIGKILL, and suggested that it might
be a good idea to generalize that to other cases after the process has
received a fatal signal.

Semantically it does not make sense to perform any signal delivery
after the process has already been killed.

When a signal is sent while a process is dying today the signal is
placed in the signal queue by __send_signal and a single task of the
process is woken up with signal_wake_up, if there are any tasks that
have not set PF_EXITING.

Take things one step farther and have prepare_signal report that all
signals that come after a process has been killed should be ignored.
While retaining the historical exception of allowing SIGKILL to
interrupt coredumps.

Remove the SIGNAL_GROUP_EXIT test from complete_signal, as it is no
longer possible for signal processing to reach complete_signal when
SIGNAL_GROUP_EXIT is true.

Update the comment in fs/coredump.c to make it clear coredumps are
special in being able to receive SIGKILL.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/coredump.c   | 2 +-
 kernel/signal.c | 5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 7b91fb32dbb8..a9c25f20118f 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -352,7 +352,7 @@ static int zap_process(struct task_struct *start, int exit_code, int flags)
 	struct task_struct *t;
 	int nr = 0;
 
-	/* ignore all signals except SIGKILL, see prepare_signal() */
+	/* Allow SIGKILL, see prepare_signal() */
 	start->signal->flags = SIGNAL_GROUP_COREDUMP | flags;
 	start->signal->group_exit_code = exit_code;
 	start->signal->group_stop_count = 0;
diff --git a/kernel/signal.c b/kernel/signal.c
index 7e305a8ec7c2..cdccbacac685 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -914,11 +914,11 @@ static bool prepare_signal(int sig, struct task_struct *p, bool force)
 				sigaddset(&dumper->pending.signal, SIGKILL);
 				signal_wake_up(dumper, 1);
 			}
-			return false;
 		}
 		/*
-		 * The process is in the middle of dying, nothing to do.
+		 * The process is in the middle of dying, drop the signal.
 		 */
+		return false;
 	} else if (sig_kernel_stop(sig)) {
 		/*
 		 * This is a stop signal.  Remove SIGCONT from all queues.
@@ -1039,7 +1039,6 @@ static void complete_signal(int sig, struct task_struct *p, enum pid_type type)
 	 * then start taking the whole group down immediately.
 	 */
 	if (sig_fatal(p, sig) &&
-	    !(signal->flags & SIGNAL_GROUP_EXIT) &&
 	    !sigismember(&t->real_blocked, sig) &&
 	    (sig == SIGKILL || !p->ptrace)) {
 		/*
-- 
2.29.2

