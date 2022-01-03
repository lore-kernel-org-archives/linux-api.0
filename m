Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94323C4332F
	for <linux-api@archiver.kernel.org>; Mon,  3 Jan 2022 21:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiACVdf (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 3 Jan 2022 16:33:35 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:53438 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiACVde (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 3 Jan 2022 16:33:34 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:58468)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4UxR-008tlQ-S4; Mon, 03 Jan 2022 14:33:33 -0700
Received: from ip68-110-24-146.om.om.cox.net ([68.110.24.146]:54408 helo=localhost.localdomain)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4UxQ-006zvm-PT; Mon, 03 Jan 2022 14:33:33 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date:   Mon,  3 Jan 2022 15:32:57 -0600
Message-Id: <20220103213312.9144-2-ebiederm@xmission.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
References: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1n4UxQ-006zvm-PT;;;mid=<20220103213312.9144-2-ebiederm@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.110.24.146;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18ByO9TYSZ0MQyaKTM4mgHM9rHBx1s2UCg=
X-SA-Exim-Connect-IP: 68.110.24.146
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 02/17] exit: Coredumps reach do_group_exit
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

The comment about coredumps not reaching do_group_exit and the
corresponding BUG_ON are bogus.

What happens and has happened for years is that get_signal calls
do_coredump (which sets SIGNAL_GROUP_EXIT and group_exit_code) and
then do_group_exit passing the signal number.  Then do_group_exit
ignores the exit_code it is passed and uses signal->group_exit_code
from the coredump.

The comment and BUG_ON were correct when they were added during the
2.5 development cycle, but became obsolete and incorrect when
get_signal was changed to fall through to do_group_exit after
do_coredump in 2.6.10-rc2.

So remove the stale comment and BUG_ON

Fixes: 63bd6144f191 ("[PATCH] Invalid BUG_ONs in signal.c")
History-Tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/exit.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index b5c35b520fda..34c43037450f 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -904,8 +904,6 @@ do_group_exit(int exit_code)
 {
 	struct signal_struct *sig = current->signal;
 
-	BUG_ON(exit_code & 0x80); /* core dumps don't get here */
-
 	if (sig->flags & SIGNAL_GROUP_EXIT)
 		exit_code = sig->group_exit_code;
 	else if (sig->group_exec_task)
-- 
2.29.2

