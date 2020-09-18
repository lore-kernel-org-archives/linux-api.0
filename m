Return-Path: <SRS0=J0k9=C3=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E973AC43465
	for <linux-api@archiver.kernel.org>; Fri, 18 Sep 2020 02:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD83A235F8
	for <linux-api@archiver.kernel.org>; Fri, 18 Sep 2020 02:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600397631;
	bh=w4PyLfMXw28cvumyu67lhikdu0uy4bifbRxV2t7MvoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gAQzYDeLa2AxvjV5C1bbBGZFhl+4DR7OMQoQW90pBQV6bHzTP+sl9pTq160OjDUV/
	 yTI6sRHRZ49ezh8ZNsbdI3dMxMF8+iuCjAEkTlI2PFAAwNJz/YzVHJp1C6+I2JiuNG
	 PIsDXtSmct0+sGy2U5cfodgPsqHkcSmLncYUP/Ew=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgIRCxv (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:53:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgIRCHq (ORCPT <rfc822;linux-api@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04F382388E;
        Fri, 18 Sep 2020 02:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394865;
        bh=w4PyLfMXw28cvumyu67lhikdu0uy4bifbRxV2t7MvoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1zxcLa7pCZMbnf2Zcu2P9Bg//smLJu6Jw3kMelFpH/jiDMUkWIH0JCyVdFqEn7YUV
         A1HnBflRvhAtizciB+W+cp2sg19mBGmv0mDA7tCnIu59s1wmtoKhxY+Ciap/JcFgQW
         NKI9FuswfRMn9jAOvug7rPcI1+lBtjst4Qb+G0R8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 318/330] selftests/x86/syscall_nt: Clear weird flags after each test
Date:   Thu, 17 Sep 2020 22:00:58 -0400
Message-Id: <20200918020110.2063155-318-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
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
index 02309a1950413..a765f62ee7668 100644
--- a/tools/testing/selftests/x86/syscall_nt.c
+++ b/tools/testing/selftests/x86/syscall_nt.c
@@ -59,6 +59,7 @@ static void do_it(unsigned long extraflags)
 	set_eflags(get_eflags() | extraflags);
 	syscall(SYS_getpid);
 	flags = get_eflags();
+	set_eflags(X86_EFLAGS_IF | X86_EFLAGS_FIXED);
 	if ((flags & extraflags) == extraflags) {
 		printf("[OK]\tThe syscall worked and flags are still set\n");
 	} else {
-- 
2.25.1

