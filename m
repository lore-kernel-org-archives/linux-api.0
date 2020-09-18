Return-Path: <SRS0=J0k9=C3=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B539C43464
	for <linux-api@archiver.kernel.org>; Fri, 18 Sep 2020 02:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D517123772
	for <linux-api@archiver.kernel.org>; Fri, 18 Sep 2020 02:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600396761;
	bh=R+FcVsk4idUsCIqnF7xfPVNJV0Y4c5vyctAqVvnmUIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CJpwQ5KKiED2eQBMqg579tWQo4Aimb4fD5ALQiajp30IBxjqrCATRihcGZqz4cITq
	 6d4NB/xY38t7eIcsmRWYm/bvjSfp5t5qVIx4FtubMRUPYwcjS/PlURCSf0Z/UFeA1G
	 w1aOb7B92zL0Qde4/AYUTNL4JakwX+VUU5l/kdCQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgIRCjB (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:39:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728743AbgIRCMK (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Thu, 17 Sep 2020 22:12:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1319208E4;
        Fri, 18 Sep 2020 02:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395130;
        bh=R+FcVsk4idUsCIqnF7xfPVNJV0Y4c5vyctAqVvnmUIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVz1Iq8H7TP2zQe4IVm6ZK7yfjeGfTnvQ1T2ycaDJWqwAtwakEvtIPCwITdLNgp4V
         sbKcDbIdLQfJacR2rRtgANAH9DERXgJ9mhilC2tO8//cOoJ6KSh+dVSWtUw3t3lYL2
         UPbjtccjyLn5oZSY0WRsqgRSAHiW9AZ+oPdl+Afc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 200/206] selftests/x86/syscall_nt: Clear weird flags after each test
Date:   Thu, 17 Sep 2020 22:07:56 -0400
Message-Id: <20200918020802.2065198-200-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

[ Upstream commit a61fa2799ef9bf6c4f54cf7295036577cececc72 ]

Clear the weird flags before logging to improve strace output --
logging results while, say, TF is set does no one any favors.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/907bfa5a42d4475b8245e18b67a04b13ca51ffdb.1593191971.git.luto@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/x86/syscall_nt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/x86/syscall_nt.c b/tools/testing/selftests/x86/syscall_nt.c
index 43fcab367fb0a..74e6b3fc2d09e 100644
--- a/tools/testing/selftests/x86/syscall_nt.c
+++ b/tools/testing/selftests/x86/syscall_nt.c
@@ -67,6 +67,7 @@ static void do_it(unsigned long extraflags)
 	set_eflags(get_eflags() | extraflags);
 	syscall(SYS_getpid);
 	flags = get_eflags();
+	set_eflags(X86_EFLAGS_IF | X86_EFLAGS_FIXED);
 	if ((flags & extraflags) == extraflags) {
 		printf("[OK]\tThe syscall worked and flags are still set\n");
 	} else {
-- 
2.25.1

