Return-Path: <SRS0=J0k9=C3=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D161C43463
	for <linux-api@archiver.kernel.org>; Fri, 18 Sep 2020 02:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52EC023119
	for <linux-api@archiver.kernel.org>; Fri, 18 Sep 2020 02:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600395859;
	bh=R+FcVsk4idUsCIqnF7xfPVNJV0Y4c5vyctAqVvnmUIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HD5Mhav7sK9T6hf4nu1t77sKiw01TYb9WMeVzUE6MMsCeGcnsHLAIdJ5Mf4DhcBEj
	 oMaeeCbpyiODmVEoY0ESmBTYZW9Mak4rnt3BbuQ4PE/ySld+1AnwdcuCVom4wYzE7u
	 WHniX/nRqBKFDHwWmQ21oPCJESeagLeh0emDmvYM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgIRCYI (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729435AbgIRCQl (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Thu, 17 Sep 2020 22:16:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82330235F7;
        Fri, 18 Sep 2020 02:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395401;
        bh=R+FcVsk4idUsCIqnF7xfPVNJV0Y4c5vyctAqVvnmUIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFPFK9ul9HgG415kdQodR3eqRsF0Cw53YcOqevcQQsV/dnzqO3dl8D6m0ZndnTa5F
         1T3BNt0eGGFx7rcLSLtdnr1avEaIlo9OGAuLA9Cfr7P9erYCNLsSu7VGXN+Ezc7E5I
         /sN5GwQT6Wt0x6hAc3puKJXpLhFZjasV8jR4yIUk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 89/90] selftests/x86/syscall_nt: Clear weird flags after each test
Date:   Thu, 17 Sep 2020 22:14:54 -0400
Message-Id: <20200918021455.2067301-89-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021455.2067301-1-sashal@kernel.org>
References: <20200918021455.2067301-1-sashal@kernel.org>
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

