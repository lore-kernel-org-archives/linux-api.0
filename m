Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A38CC43600
	for <linux-api@archiver.kernel.org>; Wed,  5 May 2021 14:11:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0062B613C7
	for <linux-api@archiver.kernel.org>; Wed,  5 May 2021 14:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbhEEOMO (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Wed, 5 May 2021 10:12:14 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57964 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbhEEOMN (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Wed, 5 May 2021 10:12:13 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1leIFA-002t7g-4X; Wed, 05 May 2021 08:11:16 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.int.ebiederm.org)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1leIF8-00007y-RE; Wed, 05 May 2021 08:11:15 -0600
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
Date:   Wed,  5 May 2021 09:10:52 -0500
Message-Id: <20210505141101.11519-3-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210505141101.11519-1-ebiederm@xmission.com>
References: <m1tuni8ano.fsf_-_@fess.ebiederm.org>
 <20210505141101.11519-1-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1leIF8-00007y-RE;;;mid=<20210505141101.11519-3-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+Y8qFMI5/OgNAO5HO1YL2oS8W5frXUgSc=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH v3 03/12] arm64: Add compile-time asserts for siginfo_t offsets
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: Marco Elver <elver@google.com>

To help catch ABI breaks at compile-time, add compile-time assertions to
verify the siginfo_t layout.

Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/arm64/kernel/signal.c   | 36 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/signal32.c | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 6237486ff6bb..af8bd2af1298 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -973,3 +973,39 @@ void __init minsigstksz_setup(void)
 		round_up(sizeof(struct frame_record), 16) +
 		16; /* max alignment padding */
 }
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
+static_assert(offsetof(siginfo_t, si_pid)	== 0x10);
+static_assert(offsetof(siginfo_t, si_uid)	== 0x14);
+static_assert(offsetof(siginfo_t, si_tid)	== 0x10);
+static_assert(offsetof(siginfo_t, si_overrun)	== 0x14);
+static_assert(offsetof(siginfo_t, si_status)	== 0x18);
+static_assert(offsetof(siginfo_t, si_utime)	== 0x20);
+static_assert(offsetof(siginfo_t, si_stime)	== 0x28);
+static_assert(offsetof(siginfo_t, si_value)	== 0x18);
+static_assert(offsetof(siginfo_t, si_int)	== 0x18);
+static_assert(offsetof(siginfo_t, si_ptr)	== 0x18);
+static_assert(offsetof(siginfo_t, si_addr)	== 0x10);
+static_assert(offsetof(siginfo_t, si_addr_lsb)	== 0x18);
+static_assert(offsetof(siginfo_t, si_lower)	== 0x20);
+static_assert(offsetof(siginfo_t, si_upper)	== 0x28);
+static_assert(offsetof(siginfo_t, si_pkey)	== 0x20);
+static_assert(offsetof(siginfo_t, si_perf)	== 0x18);
+static_assert(offsetof(siginfo_t, si_band)	== 0x10);
+static_assert(offsetof(siginfo_t, si_fd)	== 0x18);
+static_assert(offsetof(siginfo_t, si_call_addr)	== 0x10);
+static_assert(offsetof(siginfo_t, si_syscall)	== 0x18);
+static_assert(offsetof(siginfo_t, si_arch)	== 0x1c);
diff --git a/arch/arm64/kernel/signal32.c b/arch/arm64/kernel/signal32.c
index 2f507f565c48..b6afb646515f 100644
--- a/arch/arm64/kernel/signal32.c
+++ b/arch/arm64/kernel/signal32.c
@@ -457,3 +457,39 @@ void compat_setup_restart_syscall(struct pt_regs *regs)
 {
        regs->regs[7] = __NR_compat_restart_syscall;
 }
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
+static_assert(offsetof(compat_siginfo_t, si_signo)	== 0x00);
+static_assert(offsetof(compat_siginfo_t, si_errno)	== 0x04);
+static_assert(offsetof(compat_siginfo_t, si_code)	== 0x08);
+static_assert(offsetof(compat_siginfo_t, si_pid)	== 0x0c);
+static_assert(offsetof(compat_siginfo_t, si_uid)	== 0x10);
+static_assert(offsetof(compat_siginfo_t, si_tid)	== 0x0c);
+static_assert(offsetof(compat_siginfo_t, si_overrun)	== 0x10);
+static_assert(offsetof(compat_siginfo_t, si_status)	== 0x14);
+static_assert(offsetof(compat_siginfo_t, si_utime)	== 0x18);
+static_assert(offsetof(compat_siginfo_t, si_stime)	== 0x1c);
+static_assert(offsetof(compat_siginfo_t, si_value)	== 0x14);
+static_assert(offsetof(compat_siginfo_t, si_int)	== 0x14);
+static_assert(offsetof(compat_siginfo_t, si_ptr)	== 0x14);
+static_assert(offsetof(compat_siginfo_t, si_addr)	== 0x0c);
+static_assert(offsetof(compat_siginfo_t, si_addr_lsb)	== 0x10);
+static_assert(offsetof(compat_siginfo_t, si_lower)	== 0x14);
+static_assert(offsetof(compat_siginfo_t, si_upper)	== 0x18);
+static_assert(offsetof(compat_siginfo_t, si_pkey)	== 0x14);
+static_assert(offsetof(compat_siginfo_t, si_perf)	== 0x10);
+static_assert(offsetof(compat_siginfo_t, si_band)	== 0x0c);
+static_assert(offsetof(compat_siginfo_t, si_fd)		== 0x10);
+static_assert(offsetof(compat_siginfo_t, si_call_addr)	== 0x0c);
+static_assert(offsetof(compat_siginfo_t, si_syscall)	== 0x10);
+static_assert(offsetof(compat_siginfo_t, si_arch)	== 0x14);
-- 
2.30.1

