Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE790C433ED
	for <linux-api@archiver.kernel.org>; Wed,  5 May 2021 14:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4C9E613DD
	for <linux-api@archiver.kernel.org>; Wed,  5 May 2021 14:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbhEEOMX (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 5 May 2021 10:12:23 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:42806 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbhEEOMU (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 5 May 2021 10:12:20 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1leIFH-00CGQe-KR; Wed, 05 May 2021 08:11:23 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.int.ebiederm.org)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1leIFB-00007y-QN; Wed, 05 May 2021 08:11:23 -0600
From:   "Eric W. Beiderman" <ebiederm@xmission.com>
To:     Marco Elver <elver@google.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Collingbourne <pcc@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date:   Wed,  5 May 2021 09:10:53 -0500
Message-Id: <20210505141101.11519-4-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210505141101.11519-1-ebiederm@xmission.com>
References: <m1tuni8ano.fsf_-_@fess.ebiederm.org>
 <20210505141101.11519-1-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1leIFB-00007y-QN;;;mid=<20210505141101.11519-4-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/JGDMvjy6XiN+Ew7kFPT6FL7zERSVABb0=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH v3 04/12] signal: Verify the alignment and size of siginfo_t
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Update the static assertions about siginfo_t to also describe
it's alignment and size.

While investigating if it was possible to add a 64bit field into
siginfo_t[1] it became apparent that the alignment of siginfo_t
is as much a part of the ABI as the size of the structure.

If the alignment changes siginfo_t when embedded in another structure
can move to a different offset.  Which is not acceptable from an ABI
structure.

So document that fact and add static assertions to notify developers
if they change change the alignment by accident.

[1] https://lkml.kernel.org/r/YJEZdhe6JGFNYlum@elver.google.com
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/arm/kernel/signal.c           | 2 ++
 arch/arm64/kernel/signal.c         | 2 ++
 arch/arm64/kernel/signal32.c       | 2 ++
 arch/sparc/kernel/signal32.c       | 2 ++
 arch/sparc/kernel/signal_64.c      | 2 ++
 arch/x86/kernel/signal_compat.c    | 6 ++++++
 include/uapi/asm-generic/siginfo.h | 5 +++++
 7 files changed, 21 insertions(+)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index 2dac5d2c5cf6..643bcb0f091b 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -737,6 +737,8 @@ static_assert(NSIGBUS	== 5);
 static_assert(NSIGTRAP	== 6);
 static_assert(NSIGCHLD	== 6);
 static_assert(NSIGSYS	== 2);
+static_assert(sizeof(siginfo_t) == 128);
+static_assert(__alignof__(siginfo_t) == 4);
 static_assert(offsetof(siginfo_t, si_signo)	== 0x00);
 static_assert(offsetof(siginfo_t, si_errno)	== 0x04);
 static_assert(offsetof(siginfo_t, si_code)	== 0x08);
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index af8bd2af1298..ad4bd27fc044 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -985,6 +985,8 @@ static_assert(NSIGBUS	== 5);
 static_assert(NSIGTRAP	== 6);
 static_assert(NSIGCHLD	== 6);
 static_assert(NSIGSYS	== 2);
+static_assert(sizeof(siginfo_t) == 128);
+static_assert(__alignof__(siginfo_t) == 8);
 static_assert(offsetof(siginfo_t, si_signo)	== 0x00);
 static_assert(offsetof(siginfo_t, si_errno)	== 0x04);
 static_assert(offsetof(siginfo_t, si_code)	== 0x08);
diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
index b6afb646515f..ee6c7484e130 100644
--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -469,6 +469,8 @@ static_assert(NSIGBUS	== 5);
 static_assert(NSIGTRAP	== 6);
 static_assert(NSIGCHLD	== 6);
 static_assert(NSIGSYS	== 2);
+static_assert(sizeof(compat_siginfo_t) == 128);
+static_assert(__alignof__(compat_siginfo_t) == 4);
 static_assert(offsetof(compat_siginfo_t, si_signo)	== 0x00);
 static_assert(offsetof(compat_siginfo_t, si_errno)	== 0x04);
 static_assert(offsetof(compat_siginfo_t, si_code)	== 0x08);
diff --git a/arch/sparc/kernel/signal32.c b/arch/sparc/kernel/signal32.c
index 778ed5c26d4a..32b977f253e3 100644
--- a/arch/sparc/kernel/signal32.c
+++ b/arch/sparc/kernel/signal32.c
@@ -757,6 +757,8 @@ static_assert(NSIGBUS	== 5);
 static_assert(NSIGTRAP	== 6);
 static_assert(NSIGCHLD	== 6);
 static_assert(NSIGSYS	== 2);
+static_assert(sizeof(compat_siginfo_t) == 128);
+static_assert(__alignof__(compat_siginfo_t) == 4);
 static_assert(offsetof(compat_siginfo_t, si_signo)	== 0x00);
 static_assert(offsetof(compat_siginfo_t, si_errno)	== 0x04);
 static_assert(offsetof(compat_siginfo_t, si_code)	== 0x08);
diff --git a/arch/sparc/kernel/signal_64.c b/arch/sparc/kernel/signal_64.c
index c9bbf5f29078..e9dda9db156c 100644
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -567,6 +567,8 @@ static_assert(NSIGBUS	== 5);
 static_assert(NSIGTRAP	== 6);
 static_assert(NSIGCHLD	== 6);
 static_assert(NSIGSYS	== 2);
+static_assert(sizeof(siginfo_t) == 128);
+static_assert(__alignof__(siginfo_t) == 8);
 static_assert(offsetof(siginfo_t, si_signo)	== 0x00);
 static_assert(offsetof(siginfo_t, si_errno)	== 0x04);
 static_assert(offsetof(siginfo_t, si_code)	== 0x08);
diff --git a/arch/x86/kernel/signal_compat.c b/arch/x86/kernel/signal_compat.c
index 0e5d0a7e203b..e735bc129331 100644
--- a/arch/x86/kernel/signal_compat.c
+++ b/arch/x86/kernel/signal_compat.c
@@ -34,7 +34,13 @@ static inline void signal_compat_build_tests(void)
 	BUILD_BUG_ON(NSIGSYS  != 2);
 
 	/* This is part of the ABI and can never change in size: */
+	BUILD_BUG_ON(sizeof(siginfo_t) != 128);
 	BUILD_BUG_ON(sizeof(compat_siginfo_t) != 128);
+
+	/* This is a part of the ABI and can never change in alignment */
+	BUILD_BUG_ON(__alignof__(siginfo_t) != 8);
+	BUILD_BUG_ON(__alignof__(compat_siginfo_t) != 4);
+
 	/*
 	 * The offsets of all the (unioned) si_fields are fixed
 	 * in the ABI, of course.  Make sure none of them ever
diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
index 03d6f6d2c1fe..91c80d0c10c5 100644
--- a/include/uapi/asm-generic/siginfo.h
+++ b/include/uapi/asm-generic/siginfo.h
@@ -29,6 +29,11 @@ typedef union sigval {
 #define __ARCH_SI_ATTRIBUTES
 #endif
 
+/*
+ * Be careful when extending this union.  On 32bit siginfo_t is 32bit
+ * aligned.  Which means that a 64bit field or any other field that
+ * would increase the alignment of siginfo_t will break the ABI.
+ */
 union __sifields {
 	/* kill() */
 	struct {
-- 
2.30.1

