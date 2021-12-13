Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03CC0C433EF
	for <linux-api@archiver.kernel.org>; Mon, 13 Dec 2021 22:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbhLMWyt (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 13 Dec 2021 17:54:49 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:38032 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244011AbhLMWyr (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 13 Dec 2021 17:54:47 -0500
Received: from in01.mta.xmission.com ([166.70.13.51]:41784)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mwuDW-00DAdl-5e; Mon, 13 Dec 2021 15:54:46 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:60446 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mwuDU-007pqT-JZ; Mon, 13 Dec 2021 15:54:45 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arch@vger.kernel.org, linux-api@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Gladkov <legion@kernel.org>,
        Kyle Huey <me@kylehuey.com>, Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date:   Mon, 13 Dec 2021 16:53:46 -0600
Message-Id: <20211213225350.27481-4-ebiederm@xmission.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <87a6ha4zsd.fsf@email.froward.int.ebiederm.org>
References: <87a6ha4zsd.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1mwuDU-007pqT-JZ;;;mid=<20211213225350.27481-4-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/gG/C6H7+2ECMw1uH4op8AfaQeb/Psxp0=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 4/8] signal: During coredumps set SIGNAL_GROUP_EXIT in zap_process
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

There are only a few places that test SIGNAL_GROUP_EXIT and
are not also already testing SIGNAL_GROUP_COREDUMP.

This will not affect the callers of signal_group_exit as zap_process
also sets group_exit_task so signal_group_exit will continue to return
true at the same times.

This does not affect wait_task_zombie as the none of the threads
wind up in EXIT_ZOMBIE state during a coredump.

This does not affect oom_kill.c:__task_will_free_mem as
sig->core_state is tested and handled before SIGNAL_GROUP_EXIT is
tested for.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/coredump.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index a9c25f20118f..5e5a90de7be3 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -347,13 +347,13 @@ static int format_corename(struct core_name *cn, struct coredump_params *cprm,
 	return ispipe;
 }
 
-static int zap_process(struct task_struct *start, int exit_code, int flags)
+static int zap_process(struct task_struct *start, int exit_code)
 {
 	struct task_struct *t;
 	int nr = 0;
 
 	/* Allow SIGKILL, see prepare_signal() */
-	start->signal->flags = SIGNAL_GROUP_COREDUMP | flags;
+	start->signal->flags = SIGNAL_GROUP_EXIT | SIGNAL_GROUP_COREDUMP;
 	start->signal->group_exit_code = exit_code;
 	start->signal->group_stop_count = 0;
 
@@ -378,7 +378,7 @@ static int zap_threads(struct task_struct *tsk,
 	if (!signal_group_exit(tsk->signal)) {
 		tsk->signal->core_state = core_state;
 		tsk->signal->group_exit_task = tsk;
-		nr = zap_process(tsk, exit_code, 0);
+		nr = zap_process(tsk, exit_code);
 		clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
 		tsk->flags |= PF_DUMPCORE;
 		atomic_set(&core_state->nr_threads, nr);
-- 
2.29.2

