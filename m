Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAAEBC4167D
	for <linux-api@archiver.kernel.org>; Wed, 16 Feb 2022 15:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbiBPP7a (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 16 Feb 2022 10:59:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235834AbiBPP73 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 16 Feb 2022 10:59:29 -0500
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE56C2A797D;
        Wed, 16 Feb 2022 07:59:14 -0800 (PST)
Received: from in01.mta.xmission.com ([166.70.13.51]:58018)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMi2-009INN-4C; Wed, 16 Feb 2022 08:59:14 -0700
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37452 helo=localhost.localdomain)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nKMi0-002YPH-Jr; Wed, 16 Feb 2022 08:59:13 -0700
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
Date:   Wed, 16 Feb 2022 09:58:31 -0600
Message-Id: <20220216155832.680775-4-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <87ilteiz4a.fsf_-_@email.froward.int.ebiederm.org>
References: <87ilteiz4a.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1nKMi0-002YPH-Jr;;;mid=<20220216155832.680775-4-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+ooX4vhp2sZhuHKwMTsjIRkVQYwVLWDik=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH v2 4/5] ucounts: Move RLIMIT_NPROC handling after set_user
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

During set*id() which cred->ucounts to charge the the current process
to is not known until after set_cred_ucounts.  So move the
RLIMIT_NPROC checking into a new helper flag_nproc_exceeded and call
flag_nproc_exceeded after set_cred_ucounts.

This is very much an arbitrary subset of the places where we currently
change the RLIMIT_NPROC accounting, designed to preserve the existing
logic.

Fixing the existing logic will be the subject of another series of
changes.

Cc: stable@vger.kernel.org
Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/sys.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 8dd938a3d2bf..97dc9e5d6bf9 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -472,6 +472,16 @@ static int set_user(struct cred *new)
 	if (!new_user)
 		return -EAGAIN;
 
+	free_uid(new->user);
+	new->user = new_user;
+	return 0;
+}
+
+static void flag_nproc_exceeded(struct cred *new)
+{
+	if (new->ucounts == current_ucounts())
+		return;
+
 	/*
 	 * We don't fail in case of NPROC limit excess here because too many
 	 * poorly written programs don't check set*uid() return code, assuming
@@ -480,14 +490,10 @@ static int set_user(struct cred *new)
 	 * failure to the execve() stage.
 	 */
 	if (is_ucounts_overlimit(new->ucounts, UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC)) &&
-			new_user != INIT_USER)
+			new->user != INIT_USER)
 		current->flags |= PF_NPROC_EXCEEDED;
 	else
 		current->flags &= ~PF_NPROC_EXCEEDED;
-
-	free_uid(new->user);
-	new->user = new_user;
-	return 0;
 }
 
 /*
@@ -562,6 +568,7 @@ long __sys_setreuid(uid_t ruid, uid_t euid)
 	if (retval < 0)
 		goto error;
 
+	flag_nproc_exceeded(new);
 	return commit_creds(new);
 
 error:
@@ -624,6 +631,7 @@ long __sys_setuid(uid_t uid)
 	if (retval < 0)
 		goto error;
 
+	flag_nproc_exceeded(new);
 	return commit_creds(new);
 
 error:
@@ -703,6 +711,7 @@ long __sys_setresuid(uid_t ruid, uid_t euid, uid_t suid)
 	if (retval < 0)
 		goto error;
 
+	flag_nproc_exceeded(new);
 	return commit_creds(new);
 
 error:
-- 
2.29.2

