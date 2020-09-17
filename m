Return-Path: <SRS0=RkrY=C2=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFCEC43461
	for <linux-api@archiver.kernel.org>; Thu, 17 Sep 2020 07:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20E3A21D41
	for <linux-api@archiver.kernel.org>; Thu, 17 Sep 2020 07:48:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vOBv8tax"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgIQHsj (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgIQHsi (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 17 Sep 2020 03:48:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6661FC06174A;
        Thu, 17 Sep 2020 00:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=FWSWdjkt7SDTdU0fRV8XsXQQqviseOrbspWhwRmZ8GI=; b=vOBv8taxWre55z7SD5btqt4Zuv
        rS3fzD4SNpNFoLaDo9NZgElHM/uW7PuKA7uE9DiKjaCZLieV63NoHtF8WgTAUCZYEe9hzLkJbkI9A
        6nHbzOysPMH1TGyHtXTWUayvQWO4zQLTZbi4G6dQ/ZavUcaDIvhltFFMCbczifd0tX3fuVpB2J8Ul
        7PcSJPKiTqrL/5gsDwJ5ZKXE7FHi3RnxTJwh6G98+Hedce7g9dc5BgsSUIGE/zpEfxSOYIs23PVOP
        NP49YaECTPLH8tLRdXMyOW/M0BGpcDnbZkew/w56d3EzpVxtfPTPf9L22eJV+nEqmizFrniQpIS1+
        nMMzY1Cw==;
Received: from 089144214092.atnat0023.highway.a1.net ([89.144.214.92] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIoeg-0006k7-0q; Thu, 17 Sep 2020 07:48:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     x86@kernel.org, Jan Kara <jack@suse.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 2/3] compat: add a compat_need_64bit_alignment_fixup() helper
Date:   Thu, 17 Sep 2020 09:41:58 +0200
Message-Id: <20200917074159.2442167-3-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200917074159.2442167-1-hch@lst.de>
References: <20200917074159.2442167-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Add a helper to check if the calling syscall needs a fixup for
non-natural 64-bit type alignment in the compat ABI.  This will only
return true for i386 syscalls on x86_64.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/x86/include/asm/compat.h | 1 +
 include/linux/compat.h        | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
index bf547701f41f87..0e327a01f50fbb 100644
--- a/arch/x86/include/asm/compat.h
+++ b/arch/x86/include/asm/compat.h
@@ -209,6 +209,7 @@ static inline bool in_compat_syscall(void)
 	return in_32bit_syscall();
 }
 #define in_compat_syscall in_compat_syscall	/* override the generic impl */
+#define compat_need_64bit_alignment_fixup in_ia32_syscall
 #endif
 
 struct compat_siginfo;
diff --git a/include/linux/compat.h b/include/linux/compat.h
index b354ce58966e2d..fd10c3a692c2cc 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -932,6 +932,15 @@ static inline bool in_compat_syscall(void) { return false; }
 
 #endif /* CONFIG_COMPAT */
 
+/*
+ * Some legacy ABIs like the i386 one use less than natural alignment for 64-bit
+ * types, and will need special compat treatment for that.  Most architectures
+ * don't need that special handling even for compat syscalls.
+ */
+#ifndef compat_need_64bit_alignment_fixup
+#define compat_need_64bit_alignment_fixup()		false
+#endif
+
 /*
  * A pointer passed in from user mode. This should not
  * be used for syscall parameters, just declare them
-- 
2.28.0

