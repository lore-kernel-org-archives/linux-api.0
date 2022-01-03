Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F95C433EF
	for <linux-api@archiver.kernel.org>; Mon,  3 Jan 2022 21:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiACVdr (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 3 Jan 2022 16:33:47 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:45860 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbiACVdm (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 3 Jan 2022 16:33:42 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:56344)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4UxY-00ET0Q-W5; Mon, 03 Jan 2022 14:33:41 -0700
Received: from ip68-110-24-146.om.om.cox.net ([68.110.24.146]:54408 helo=localhost.localdomain)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4UxX-006zvm-MV; Mon, 03 Jan 2022 14:33:40 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Balbir Singh <bsingharora@gmail.com>
Date:   Mon,  3 Jan 2022 15:33:00 -0600
Message-Id: <20220103213312.9144-5-ebiederm@xmission.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
References: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1n4UxX-006zvm-MV;;;mid=<20220103213312.9144-5-ebiederm@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.110.24.146;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+CRWzVLNnenVGaaRiHLlq9SOWL8zsSG+U=
X-SA-Exim-Connect-IP: 68.110.24.146
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 05/17] taskstats: Cleanup the use of task->exit_code
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

In the function bacct_add_task the code reading task->exit_code was
introduced in commit f3cef7a99469 ("[PATCH] csa: basic accounting over
taskstats"), and it is not entirely clear what the taskstats interface
is trying to return as only returning the exit_code of the first task
in a process doesn't make a lot of sense.

As best as I can figure the intent is to return task->exit_code after
a task exits.  The field is returned with per task fields, so the
exit_code of the entire process is not wanted.  Only the value of the
first task is returned so this is not a useful way to get the per task
ptrace stop code.  The ordinary case of returning this value is
returning after a task exits, which also precludes use for getting
a ptrace value.

It is common to for the first task of a process to also be the last
task of a process so this field may have done something reasonable by
accident in testing.

Make ac_exitcode a reliable per task value by always returning it for
every exited task.

Setting ac_exitcode in a sensible mannter makes it possible to continue
to provide this value going forward.

Cc: Balbir Singh <bsingharora@gmail.com>
Fixes: f3cef7a99469 ("[PATCH] csa: basic accounting over taskstats")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/tsacct.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index f00de83d0246..1d261fbe367b 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -38,11 +38,10 @@ void bacct_add_tsk(struct user_namespace *user_ns,
 	stats->ac_btime = clamp_t(time64_t, btime, 0, U32_MAX);
 	stats->ac_btime64 = btime;
 
-	if (thread_group_leader(tsk)) {
+	if (tsk->flags & PF_EXITING)
 		stats->ac_exitcode = tsk->exit_code;
-		if (tsk->flags & PF_FORKNOEXEC)
-			stats->ac_flag |= AFORK;
-	}
+	if (thread_group_leader(tsk) && (tsk->flags & PF_FORKNOEXEC))
+		stats->ac_flag |= AFORK;
 	if (tsk->flags & PF_SUPERPRIV)
 		stats->ac_flag |= ASU;
 	if (tsk->flags & PF_DUMPCORE)
-- 
2.29.2

