Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B0DC433EF
	for <linux-api@archiver.kernel.org>; Mon, 13 Dec 2021 22:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244018AbhLMWyw (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 13 Dec 2021 17:54:52 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:38062 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244002AbhLMWyv (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 13 Dec 2021 17:54:51 -0500
Received: from in01.mta.xmission.com ([166.70.13.51]:41912)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mwuDa-00DAeK-RX; Mon, 13 Dec 2021 15:54:50 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:60446 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mwuDZ-007pqT-PB; Mon, 13 Dec 2021 15:54:50 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Gladkov <legion@kernel.org>,
        Kyle Huey <me@kylehuey.com>, Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date:   Mon, 13 Dec 2021 16:53:48 -0600
Message-Id: <20211213225350.27481-6-ebiederm@xmission.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <87a6ha4zsd.fsf@email.froward.int.ebiederm.org>
References: <87a6ha4zsd.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1mwuDZ-007pqT-PB;;;mid=<20211213225350.27481-6-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18QrWns4LNTXESQlhnolOyBIKXd1fvvRhM=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 6/8] coredump: Stop setting signal->group_exit_task
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Currently the coredump code sets group_exit_task so that
signal_group_exit() will return true during a coredump.  Now that the
coredump code always sets SIGNAL_GROUP_EXIT there is no longer a need
to set signal->group_exit_task.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/coredump.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 2c9d16d4b57a..ef56595a0d87 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -377,7 +377,6 @@ static int zap_threads(struct task_struct *tsk,
 	spin_lock_irq(&tsk->sighand->siglock);
 	if (!signal_group_exit(tsk->signal)) {
 		tsk->signal->core_state = core_state;
-		tsk->signal->group_exit_task = tsk;
 		nr = zap_process(tsk, exit_code);
 		clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
 		tsk->flags |= PF_DUMPCORE;
@@ -426,7 +425,6 @@ static void coredump_finish(bool core_dumped)
 	spin_lock_irq(&current->sighand->siglock);
 	if (core_dumped && !__fatal_signal_pending(current))
 		current->signal->group_exit_code |= 0x80;
-	current->signal->group_exit_task = NULL;
 	next = current->signal->core_state->dumper.next;
 	current->signal->core_state = NULL;
 	spin_unlock_irq(&current->sighand->siglock);
-- 
2.29.2

