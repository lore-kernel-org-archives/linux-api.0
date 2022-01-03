Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C867C433EF
	for <linux-api@archiver.kernel.org>; Mon,  3 Jan 2022 21:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiACVeP (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 3 Jan 2022 16:34:15 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55732 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiACVeA (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 3 Jan 2022 16:34:00 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:54216)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4Uxr-008wCI-UK; Mon, 03 Jan 2022 14:33:59 -0700
Received: from ip68-110-24-146.om.om.cox.net ([68.110.24.146]:54408 helo=localhost.localdomain)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4Uxq-006zvm-VO; Mon, 03 Jan 2022 14:33:59 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date:   Mon,  3 Jan 2022 15:33:07 -0600
Message-Id: <20220103213312.9144-12-ebiederm@xmission.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
References: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1n4Uxq-006zvm-VO;;;mid=<20220103213312.9144-12-ebiederm@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.110.24.146;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19dmJ8eKxvuQTy3KtHmk9FlXTI4tuhzGNw=
X-SA-Exim-Connect-IP: 68.110.24.146
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 12/17] signal: Compute the process exit_code in get_signal
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

In prepartion for moving the work of sys_exit and sys_group_exit into
get_signal compute exit_code in get_signal, make PF_SIGNALED depend on
the exit_code and pass the exit_code to do_group_exit.

Anytime there is a group exit the exit_code may differ from the signal
number.

To match the historical precedent as best I can make the exit_code 0
during exec. (The exit_code field would not have been set but probably
would have been left at a value of 0).

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/signal.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index fd3c404de8b6..2a24cca00ca1 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2707,6 +2707,7 @@ bool get_signal(struct ksignal *ksig)
 	for (;;) {
 		struct k_sigaction *ka;
 		enum pid_type type;
+		int exit_code;
 
 		/* Has this task already been marked for death? */
 		if ((signal->flags & SIGNAL_GROUP_EXIT) ||
@@ -2716,6 +2717,10 @@ bool get_signal(struct ksignal *ksig)
 			trace_signal_deliver(SIGKILL, SEND_SIG_NOINFO,
 				&sighand->action[SIGKILL - 1]);
 			recalc_sigpending();
+			if (signal->flags & SIGNAL_GROUP_EXIT)
+				exit_code = signal->group_exit_code;
+			else
+				exit_code = 0;
 			goto fatal;
 		}
 
@@ -2837,15 +2842,17 @@ bool get_signal(struct ksignal *ksig)
 			continue;
 		}
 
+		/*
+		 * Anything else is fatal, maybe with a core dump.
+		 */
+		exit_code = signr;
 	fatal:
 		spin_unlock_irq(&sighand->siglock);
 		if (unlikely(cgroup_task_frozen(current)))
 			cgroup_leave_frozen(true);
 
-		/*
-		 * Anything else is fatal, maybe with a core dump.
-		 */
-		current->flags |= PF_SIGNALED;
+		if (exit_code & 0x7f)
+			current->flags |= PF_SIGNALED;
 
 		if (sig_kernel_coredump(signr)) {
 			if (print_fatal_signals)
@@ -2873,7 +2880,7 @@ bool get_signal(struct ksignal *ksig)
 		/*
 		 * Death signals, no core dump.
 		 */
-		do_group_exit(ksig->info.si_signo);
+		do_group_exit(exit_code);
 		/* NOTREACHED */
 	}
 	spin_unlock_irq(&sighand->siglock);
-- 
2.29.2

