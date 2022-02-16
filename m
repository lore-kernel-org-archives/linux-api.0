Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 160A5C433FE
	for <linux-api@archiver.kernel.org>; Wed, 16 Feb 2022 15:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235836AbiBPP73 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 16 Feb 2022 10:59:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235811AbiBPP72 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 16 Feb 2022 10:59:28 -0500
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89822A797C;
        Wed, 16 Feb 2022 07:59:11 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:51766)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMhw-00Facl-Uw; Wed, 16 Feb 2022 08:59:08 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37452 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMhv-002YPH-QG; Wed, 16 Feb 2022 08:59:08 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alexey Gladkov <legion@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Solar Designer <solar@openwall.com>,
        Ran Xiaokai <ran.xiaokai@zte.com.cn>,
        containers@lists.linux-foundation.org,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, stable@vger.kernel.org
Date:   Wed, 16 Feb 2022 09:58:29 -0600
Message-Id: <20220216155832.680775-2-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87ilteiz4a.fsf_-_@email.froward.int.ebiederm.org>
References: <87ilteiz4a.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1nKMhv-002YPH-QG;;;mid=<20220216155832.680775-2-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19jMI1eR5e/rjuLRVwV70HFF3fBrIweiqc=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH v2 2/5] ucounts: Enforce RLIMIT_NPROC not RLIMIT_NPROC+1
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Michal Koutný <mkoutny@suse.com> wrote:

> It was reported that v5.14 behaves differently when enforcing
> RLIMIT_NPROC limit, namely, it allows one more task than previously.
> This is consequence of the commit 21d1c5e386bc ("Reimplement
> RLIMIT_NPROC on top of ucounts") that missed the sharpness of
> equality in the forking path.

This can be fixed either by fixing the test or by moving the increment
to be before the test.  Fix it my moving copy_creds which contains
the increment before is_ucounts_overlimit.

In the case of CLONE_NEWUSER the ucounts in the task_cred changes.
The function is_ucounts_overlimit needs to use the final version of
the ucounts for the new process.  Which means moving the
is_ucounts_overlimit test after copy_creds is necessary.

Both the test in fork and the test in set_user were semantically
changed when the code moved to ucounts.  The change of the test in
fork was bad because it was before the increment.  The test in
set_user was wrong and the change to ucounts fixed it.  So this
fix only restores the old behavior in one lcation not two.

Link: https://lkml.kernel.org/r/20220204181144.24462-1-mkoutny@suse.com
Cc: stable@vger.kernel.org
Reported-by: Michal Koutný <mkoutny@suse.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/fork.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index d75a528f7b21..17d8a8c85e3b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2021,18 +2021,18 @@ static __latent_entropy struct task_struct *copy_process(
 #ifdef CONFIG_PROVE_LOCKING
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
+	retval = copy_creds(p, clone_flags);
+	if (retval < 0)
+		goto bad_fork_free;
+
 	retval = -EAGAIN;
 	if (is_ucounts_overlimit(task_ucounts(p), UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC))) {
 		if (p->real_cred->user != INIT_USER &&
 		    !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
-			goto bad_fork_free;
+			goto bad_fork_cleanup_count;
 	}
 	current->flags &= ~PF_NPROC_EXCEEDED;
 
-	retval = copy_creds(p, clone_flags);
-	if (retval < 0)
-		goto bad_fork_free;
-
 	/*
 	 * If multiple threads are within copy_process(), then this check
 	 * triggers too late. This doesn't hurt, the check is only there
-- 
2.29.2

