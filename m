Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ADDEC55ABD
	for <linux-api@archiver.kernel.org>; Fri, 13 Nov 2020 02:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C52AC22241
	for <linux-api@archiver.kernel.org>; Fri, 13 Nov 2020 02:53:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BUBvf88l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgKMCxp (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Thu, 12 Nov 2020 21:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgKMCxp (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Thu, 12 Nov 2020 21:53:45 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12954C0613D1
        for <linux-api@vger.kernel.org>; Thu, 12 Nov 2020 18:53:45 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id 198so4928126qkj.7
        for <linux-api@vger.kernel.org>; Thu, 12 Nov 2020 18:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ygGnL3mRCd+dIJRzIWujb3ScKZ0x4r/fVg2nxqC4gq4=;
        b=BUBvf88lOW0IMOoQ8xVYrgKOAKGBusN3/e0T2JacIxSORJQSXrBSQwKtd1VphzpOjn
         xykRXI74C0uU03oA4rOYZOaKVin9DNgdWI4NK/uGGqaG9iUBtgsGPFTatRk7G75jRbLP
         aUSLw/K0puXR7pIpBy1jle9yVkIjdMOwvaSD43cIib63C+8TcUN5qffGDr/UQTnIxk9R
         SPHhbia+VR0t+h2UxJF6JusbPqKJ8cHpbPrWkEOK0EkaKNITWJlO7QLXTcD7IT3edQg+
         XYVTZC+S7BHg6YWizm89jGfcW2yZHq9IdAbQR1I2firDp+6XAsXGrBdcOg0RamMhduDK
         wOpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ygGnL3mRCd+dIJRzIWujb3ScKZ0x4r/fVg2nxqC4gq4=;
        b=JDsnJDqpC6mdePULBhIBP4Zb47Z5zcMsT3QMXnWaDljaueOiR2hnZrrloDaaDKq8gt
         fwx6yXzS/KdHd4emxpLozChK8kTIEocUgEqq8RLpEUXmztmQlb5fa+z2GPkvZ4f9g6XL
         Kd1DHwV/novfjNITfuzlgUG/l2QOVyZc7lENufpK/Z24QWQLrFhK+agTwgrRRZNlwvm/
         UVM3Mzbo2qLRg8CAGDHekr9kW9Z8m4ULOyzAYAo0eu1HFzURShl+YXjbOJxj0UuzbLV/
         eVrdfJu5vRc0191srB4BKG22nB/sLR7cKd8QSA/JBJ0Us290OTYgE9WfpK8O9z+CArnD
         up3Q==
X-Gm-Message-State: AOAM532IfY6kFHPmtbxfr8Oa9uF9IXzezUSij0oyExk8wobMlnL2YNnM
        y3+a3uiid2Kg4AuUmb55O/ptf7Q=
X-Google-Smtp-Source: ABdhPJwMI6AYBkl5OpDGhN5m9DC1SS+CDVziLDgBOmaHQAc3EQ/ztzIhyENSGvm1Gv1hUBkFAVbFVs0=
Sender: "pcc via sendgmr" <pcc@pcc-desktop.svl.corp.google.com>
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:0:7220:84ff:fe09:385a])
 (user=pcc job=sendgmr) by 2002:ad4:53c8:: with SMTP id k8mr402399qvv.40.1605236024196;
 Thu, 12 Nov 2020 18:53:44 -0800 (PST)
Date:   Thu, 12 Nov 2020 18:53:31 -0800
In-Reply-To: <cover.1605235762.git.pcc@google.com>
Message-Id: <a75b8eb7bb9eac1cf73fb119eb53e5892d6e9656.1605235762.git.pcc@google.com>
Mime-Version: 1.0
References: <cover.1605235762.git.pcc@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [PATCH v16 1/6] parisc: Drop parisc special case for __sighandler_t
From:   Peter Collingbourne <pcc@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Will Deacon <will@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Cc:     Peter Collingbourne <pcc@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        linux-api@vger.kernel.org, Helge Deller <deller@gmx.de>,
        David Spickett <david.spickett@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: Helge Deller <deller@gmx.de>

I believe we can and *should* drop this parisc-specific typedef for
__sighandler_t when compiling a 64-bit kernel. The reasons:

1. We don't have a 64-bit userspace yet, so nothing (on userspace side)
can break.

2. Inside the Linux kernel, this is only used in kernel/signal.c, in
function kernel_sigaction() where the signal handler is compared against
SIG_IGN.  SIG_IGN is defined as (__sighandler_t)1), so only the pointers
are compared.

3. Even when a 64-bit userspace gets added at some point, I think
__sighandler_t should be defined what it is: a function pointer struct.

I compiled kernel/signal.c with and without the patch, and the produced code
is identical in both cases.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Peter Collingbourne <pcc@google.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Reviewed-by: Peter Collingbourne <pcc@google.com>
Link: https://linux-review.googlesource.com/id/I21c43f21b264f339e3aa395626af838646f62d97
---
 arch/parisc/include/uapi/asm/signal.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/parisc/include/uapi/asm/signal.h b/arch/parisc/include/uapi/asm/signal.h
index e605197b462c..d9c51769851a 100644
--- a/arch/parisc/include/uapi/asm/signal.h
+++ b/arch/parisc/include/uapi/asm/signal.h
@@ -85,16 +85,8 @@
 struct siginfo;
 
 /* Type of a signal handler.  */
-#if defined(__LP64__)
-/* function pointers on 64-bit parisc are pointers to little structs and the
- * compiler doesn't support code which changes or tests the address of
- * the function in the little struct.  This is really ugly -PB
- */
-typedef char __user *__sighandler_t;
-#else
 typedef void __signalfn_t(int);
 typedef __signalfn_t __user *__sighandler_t;
-#endif
 
 typedef struct sigaltstack {
 	void __user *ss_sp;
-- 
2.29.2.299.gdc1121823c-goog

