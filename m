Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC0EC43470
	for <linux-api@archiver.kernel.org>; Mon,  3 May 2021 20:38:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33D4061165
	for <linux-api@archiver.kernel.org>; Mon,  3 May 2021 20:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhECUju (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 3 May 2021 16:39:50 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58866 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhECUju (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 3 May 2021 16:39:50 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1ldfLC-00Gyhb-SW; Mon, 03 May 2021 14:38:54 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.int.ebiederm.org)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1ldfLB-00E76Y-RV; Mon, 03 May 2021 14:38:54 -0600
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
        "Eric W . Biederman" <ebiederm@xmission.com>
Date:   Mon,  3 May 2021 15:38:04 -0500
Message-Id: <20210503203814.25487-2-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210503203814.25487-1-ebiederm@xmission.com>
References: <m14kfjh8et.fsf_-_@fess.ebiederm.org>
 <20210503203814.25487-1-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1ldfLB-00E76Y-RV;;;mid=<20210503203814.25487-2-ebiederm@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/4zhIRBt7xIq/JpUB9A8MZN6cAuKB/qQs=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 02/12] arm: Add compile-time asserts for siginfo_t offsets
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: Marco Elver <elver@google.com>

To help catch ABI breaks at compile-time, add compile-time assertions to
verify the siginfo_t layout.

This could have caught that we cannot portably add 64-bit integers to
siginfo_t on 32-bit architectures like Arm before reaching -next:
https://lkml.kernel.org/r/20210422191823.79012-1-elver@google.com

Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/arm/kernel/signal.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
index a3a38d0a4c85..2dac5d2c5cf6 100644
--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -725,3 +725,39 @@ asmlinkage void do_rseq_syscall(struct pt_regs *regs)
 	rseq_syscall(regs);
 }
 #endif
+
+/*
+ * Compile-time assertions for siginfo_t offsets. Check NSIG* as well, as
+ * changes likely come with new fields that should be added below.
+ */
+static_assert(NSIGILL	== 11);
+static_assert(NSIGFPE	== 15);
+static_assert(NSIGSEGV	== 9);
+static_assert(NSIGBUS	== 5);
+static_assert(NSIGTRAP	== 6);
+static_assert(NSIGCHLD	== 6);
+static_assert(NSIGSYS	== 2);
+static_assert(offsetof(siginfo_t, si_signo)	== 0x00);
+static_assert(offsetof(siginfo_t, si_errno)	== 0x04);
+static_assert(offsetof(siginfo_t, si_code)	== 0x08);
+static_assert(offsetof(siginfo_t, si_pid)	== 0x0c);
+static_assert(offsetof(siginfo_t, si_uid)	== 0x10);
+static_assert(offsetof(siginfo_t, si_tid)	== 0x0c);
+static_assert(offsetof(siginfo_t, si_overrun)	== 0x10);
+static_assert(offsetof(siginfo_t, si_status)	== 0x14);
+static_assert(offsetof(siginfo_t, si_utime)	== 0x18);
+static_assert(offsetof(siginfo_t, si_stime)	== 0x1c);
+static_assert(offsetof(siginfo_t, si_value)	== 0x14);
+static_assert(offsetof(siginfo_t, si_int)	== 0x14);
+static_assert(offsetof(siginfo_t, si_ptr)	== 0x14);
+static_assert(offsetof(siginfo_t, si_addr)	== 0x0c);
+static_assert(offsetof(siginfo_t, si_addr_lsb)	== 0x10);
+static_assert(offsetof(siginfo_t, si_lower)	== 0x14);
+static_assert(offsetof(siginfo_t, si_upper)	== 0x18);
+static_assert(offsetof(siginfo_t, si_pkey)	== 0x14);
+static_assert(offsetof(siginfo_t, si_perf)	== 0x10);
+static_assert(offsetof(siginfo_t, si_band)	== 0x0c);
+static_assert(offsetof(siginfo_t, si_fd)	== 0x10);
+static_assert(offsetof(siginfo_t, si_call_addr)	== 0x0c);
+static_assert(offsetof(siginfo_t, si_syscall)	== 0x10);
+static_assert(offsetof(siginfo_t, si_arch)	== 0x14);
-- 
2.30.1

