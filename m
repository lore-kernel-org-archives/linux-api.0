Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2480EC433EF
	for <linux-api@archiver.kernel.org>; Mon,  3 Jan 2022 21:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiACVdr (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 3 Jan 2022 16:33:47 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55670 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiACVdo (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 3 Jan 2022 16:33:44 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:53832)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4Uxb-008wAq-Hp; Mon, 03 Jan 2022 14:33:43 -0700
Received: from ip68-110-24-146.om.om.cox.net ([68.110.24.146]:54408 helo=localhost.localdomain)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4Uxa-006zvm-2s; Mon, 03 Jan 2022 14:33:43 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date:   Mon,  3 Jan 2022 15:33:01 -0600
Message-Id: <20220103213312.9144-6-ebiederm@xmission.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
References: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1n4Uxa-006zvm-2s;;;mid=<20220103213312.9144-6-ebiederm@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.110.24.146;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/AooRDxSBy7IO0iwcfMe3FQDLmY0Bv32g=
X-SA-Exim-Connect-IP: 68.110.24.146
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 06/17] ptrace: Remove second setting of PT_SEIZED in ptrace_attach
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

The code is totally redundant remove it.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/ptrace.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index f8589bf8d7dc..eea265082e97 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -419,8 +419,6 @@ static int ptrace_attach(struct task_struct *task, long request,
 	if (task->ptrace)
 		goto unlock_tasklist;
 
-	if (seize)
-		flags |= PT_SEIZED;
 	task->ptrace = flags;
 
 	ptrace_link(task, current);
-- 
2.29.2

