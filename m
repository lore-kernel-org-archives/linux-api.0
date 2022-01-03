Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC1F4C433FE
	for <linux-api@archiver.kernel.org>; Mon,  3 Jan 2022 21:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiACVdi (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 3 Jan 2022 16:33:38 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55632 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiACVdh (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 3 Jan 2022 16:33:37 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:53662)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4UxU-008w9q-F0; Mon, 03 Jan 2022 14:33:36 -0700
Received: from ip68-110-24-146.om.om.cox.net ([68.110.24.146]:54408 helo=localhost.localdomain)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4UxS-006zvm-W0; Mon, 03 Jan 2022 14:33:36 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date:   Mon,  3 Jan 2022 15:32:58 -0600
Message-Id: <20220103213312.9144-3-ebiederm@xmission.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
References: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1n4UxS-006zvm-W0;;;mid=<20220103213312.9144-3-ebiederm@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.110.24.146;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX196ABXzRphm6Epu6ILDYOaOLYsB0yzq64Y=
X-SA-Exim-Connect-IP: 68.110.24.146
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 03/17] exit: Fix the exit_code for wait_task_zombie
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

The function wait_task_zombie is defined to always returns the process not
thread exit status.  Unfortunately when process group exit support
was added to wait_task_zombie the WNOWAIT case was overlooked.

Usually tsk->exit_code and tsk->signal->group_exit_code will be in sync
so fixing this is bug probably has no effect in practice.  But fix
it anyway so that people aren't scratching their heads about why
the two code paths are different.

History-Tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
Fixes: 2c66151cbc2c ("[PATCH] sys_exit() threading improvements, BK-curr")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/exit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 34c43037450f..7121db37c411 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1011,7 +1011,8 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		return 0;
 
 	if (unlikely(wo->wo_flags & WNOWAIT)) {
-		status = p->exit_code;
+		status = (p->signal->flags & SIGNAL_GROUP_EXIT)
+			? p->signal->group_exit_code : p->exit_code;
 		get_task_struct(p);
 		read_unlock(&tasklist_lock);
 		sched_annotate_sleep();
-- 
2.29.2

