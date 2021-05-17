Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA64C433ED
	for <linux-api@archiver.kernel.org>; Mon, 17 May 2021 20:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D052160FF2
	for <linux-api@archiver.kernel.org>; Mon, 17 May 2021 20:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237461AbhEQUG1 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 17 May 2021 16:06:27 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49328 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236497AbhEQUG0 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 17 May 2021 16:06:26 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lijUD-008wn0-6v; Mon, 17 May 2021 14:05:09 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.int.ebiederm.org)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lijNr-0001rb-0e; Mon, 17 May 2021 13:58:35 -0600
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
Date:   Mon, 17 May 2021 14:57:44 -0500
Message-Id: <20210517195748.8880-1-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <m1a6ot5e2h.fsf_-_@fess.ebiederm.org>
References: <m1a6ot5e2h.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1lijNr-0001rb-0e;;;mid=<20210517195748.8880-1-ebiederm@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/fN9eCwd6Pf3euOoMd6UjKgwMo0ARlihE=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH v4 1/5] siginfo: Move si_trapno inside the union inside _si_fault
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

It turns out that linux uses si_trapno very sparingly, and as such it
can be considered extra information for a very narrow selection of
signals, rather than information that is present with every fault
reported in siginfo.

As such move si_trapno inside the union inside of _si_fault.  This
results in no change in placement, and makes it eaiser
to extend _si_fault in the future as this reduces the number of
special cases.  In particular with si_trapno included in the union it
is no longer a concern that the union must be pointer aligned on most
architectures because the union follows immediately after si_addr
which is a pointer.

This change results in a difference in siginfo field placement on
sparc and alpha for the fields si_addr_lsb, si_lower, si_upper,
si_pkey, and si_perf.  These architectures do not implement the
signals that would use si_addr_lsb, si_lower, si_upper, si_pkey, and
si_perf.  Further these architecture have not yet implemented the
userspace that would use si_perf.

The point of this change is in fact to correct these placement issues
before sparc or alpha grow userspace that cares.  This change was
discussed[1] and the agreement is that this change is currently safe.

[1]: https://lkml.kernel.org/r/CAK8P3a0+uKYwL1NhY6Hvtieghba2hKYGD6hcKx5n8=4Gtt+pHA@mail.gmail.com
Acked-by: Marco Elver <elver@google.com>
v1: https://lkml.kernel.org/r/m1tunns7yf.fsf_-_@fess.ebiederm.org
v2: https://lkml.kernel.org/r/20210505141101.11519-5-ebiederm@xmission.com
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/x86/kernel/signal_compat.c    | 3 +++
 include/linux/compat.h             | 5 ++---
 include/uapi/asm-generic/siginfo.h | 7 ++-----
 kernel/signal.c                    | 1 +
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/signal_compat.c b/arch/x86/kernel/signal_compat.c
index 0e5d0a7e203b..a9fcabd8a5e5 100644
--- a/arch/x86/kernel/signal_compat.c
+++ b/arch/x86/kernel/signal_compat.c
@@ -127,6 +127,9 @@ static inline void signal_compat_build_tests(void)
 	BUILD_BUG_ON(offsetof(siginfo_t, si_addr) != 0x10);
 	BUILD_BUG_ON(offsetof(compat_siginfo_t, si_addr) != 0x0C);
 
+	BUILD_BUG_ON(offsetof(siginfo_t, si_trapno) != 0x18);
+	BUILD_BUG_ON(offsetof(compat_siginfo_t, si_trapno) != 0x10);
+
 	BUILD_BUG_ON(offsetof(siginfo_t, si_addr_lsb) != 0x18);
 	BUILD_BUG_ON(offsetof(compat_siginfo_t, si_addr_lsb) != 0x10);
 
diff --git a/include/linux/compat.h b/include/linux/compat.h
index f0d2dd35d408..6af7bef15e94 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -214,12 +214,11 @@ typedef struct compat_siginfo {
 		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS, SIGTRAP, SIGEMT */
 		struct {
 			compat_uptr_t _addr;	/* faulting insn/memory ref. */
-#ifdef __ARCH_SI_TRAPNO
-			int _trapno;	/* TRAP # which caused the signal */
-#endif
 #define __COMPAT_ADDR_BND_PKEY_PAD  (__alignof__(compat_uptr_t) < sizeof(short) ? \
 				     sizeof(short) : __alignof__(compat_uptr_t))
 			union {
+				/* used on alpha and sparc */
+				int _trapno;	/* TRAP # which caused the signal */
 				/*
 				 * used when si_code=BUS_MCEERR_AR or
 				 * used when si_code=BUS_MCEERR_AO
diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
index 03d6f6d2c1fe..e663bf117b46 100644
--- a/include/uapi/asm-generic/siginfo.h
+++ b/include/uapi/asm-generic/siginfo.h
@@ -63,9 +63,6 @@ union __sifields {
 	/* SIGILL, SIGFPE, SIGSEGV, SIGBUS, SIGTRAP, SIGEMT */
 	struct {
 		void __user *_addr; /* faulting insn/memory ref. */
-#ifdef __ARCH_SI_TRAPNO
-		int _trapno;	/* TRAP # which caused the signal */
-#endif
 #ifdef __ia64__
 		int _imm;		/* immediate value for "break" */
 		unsigned int _flags;	/* see ia64 si_flags */
@@ -75,6 +72,8 @@ union __sifields {
 #define __ADDR_BND_PKEY_PAD  (__alignof__(void *) < sizeof(short) ? \
 			      sizeof(short) : __alignof__(void *))
 		union {
+			/* used on alpha and sparc */
+			int _trapno;	/* TRAP # which caused the signal */
 			/*
 			 * used when si_code=BUS_MCEERR_AR or
 			 * used when si_code=BUS_MCEERR_AO
@@ -150,9 +149,7 @@ typedef struct siginfo {
 #define si_int		_sifields._rt._sigval.sival_int
 #define si_ptr		_sifields._rt._sigval.sival_ptr
 #define si_addr		_sifields._sigfault._addr
-#ifdef __ARCH_SI_TRAPNO
 #define si_trapno	_sifields._sigfault._trapno
-#endif
 #define si_addr_lsb	_sifields._sigfault._addr_lsb
 #define si_lower	_sifields._sigfault._addr_bnd._lower
 #define si_upper	_sifields._sigfault._addr_bnd._upper
diff --git a/kernel/signal.c b/kernel/signal.c
index c3017aa8024a..65888aec65a0 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -4607,6 +4607,7 @@ static inline void siginfo_buildtime_checks(void)
 
 	/* sigfault */
 	CHECK_OFFSET(si_addr);
+	CHECK_OFFSET(si_trapno);
 	CHECK_OFFSET(si_addr_lsb);
 	CHECK_OFFSET(si_lower);
 	CHECK_OFFSET(si_upper);
-- 
2.30.1

