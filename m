Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D22BC43611
	for <linux-api@archiver.kernel.org>; Mon,  3 May 2021 20:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63831613B3
	for <linux-api@archiver.kernel.org>; Mon,  3 May 2021 20:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhECUkj (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 3 May 2021 16:40:39 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:51174 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhECUkU (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 3 May 2021 16:40:20 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1ldfLi-008idl-2w; Mon, 03 May 2021 14:39:26 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.int.ebiederm.org)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1ldfLh-00E76Y-3k; Mon, 03 May 2021 14:39:25 -0600
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
Date:   Mon,  3 May 2021 15:38:14 -0500
Message-Id: <20210503203814.25487-12-ebiederm@xmission.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210503203814.25487-1-ebiederm@xmission.com>
References: <m14kfjh8et.fsf_-_@fess.ebiederm.org>
 <20210503203814.25487-1-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1ldfLh-00E76Y-3k;;;mid=<20210503203814.25487-12-ebiederm@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18ApcIKZTcHjAhTtt02Vp3dyDFJvqVtnoc=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 12/12] signalfd: Remove SIL_FAULT_PERF_EVENT fields from signalfd_siginfo
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

With the addition of ssi_perf_data and ssi_perf_type struct signalfd_siginfo
is dangerously close to running out of space.  All that remains is just
enough space for two additional 64bit fields.  A practice of adding all
possible siginfo_t fields into struct singalfd_siginfo can not be supported
as adding the missing fields ssi_lower, ssi_upper, and ssi_pkey would
require two 64bit fields and one 32bit fields.  In practice the fields
ssi_perf_data and ssi_perf_type can never be used by signalfd as the signal
that generates them always delivers them synchronously to the thread that
triggers them.

Therefore until someone actually needs the fields ssi_perf_data and
ssi_perf_type in signalfd_siginfo remove them.  This leaves a bit more room
for future expansion.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/signalfd.c                 | 16 ++++++----------
 include/uapi/linux/signalfd.h |  4 +---
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index 335ad39f3900..040e1cf90528 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -114,12 +114,13 @@ static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
 		break;
 	case SIL_FAULT_BNDERR:
 	case SIL_FAULT_PKUERR:
+	case SIL_FAULT_PERF_EVENT:
 		/*
-		 * Fall through to the SIL_FAULT case.  Both SIL_FAULT_BNDERR
-		 * and SIL_FAULT_PKUERR are only generated by faults that
-		 * deliver them synchronously to userspace.  In case someone
-		 * injects one of these signals and signalfd catches it treat
-		 * it as SIL_FAULT.
+		 * Fall through to the SIL_FAULT case.  SIL_FAULT_BNDERR,
+		 * SIL_FAULT_PKUERR, and SIL_FAULT_PERF_EVENT are only
+		 * generated by faults that deliver them synchronously to
+		 * userspace.  In case someone injects one of these signals
+		 * and signalfd catches it treat it as SIL_FAULT.
 		 */
 	case SIL_FAULT:
 		new.ssi_addr = (long) kinfo->si_addr;
@@ -132,11 +133,6 @@ static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
 		new.ssi_addr = (long) kinfo->si_addr;
 		new.ssi_addr_lsb = (short) kinfo->si_addr_lsb;
 		break;
-	case SIL_FAULT_PERF_EVENT:
-		new.ssi_addr = (long) kinfo->si_addr;
-		new.ssi_perf_type = kinfo->si_perf_type;
-		new.ssi_perf_data = kinfo->si_perf_data;
-		break;
 	case SIL_CHLD:
 		new.ssi_pid    = kinfo->si_pid;
 		new.ssi_uid    = kinfo->si_uid;
diff --git a/include/uapi/linux/signalfd.h b/include/uapi/linux/signalfd.h
index e78dddf433fc..83429a05b698 100644
--- a/include/uapi/linux/signalfd.h
+++ b/include/uapi/linux/signalfd.h
@@ -39,8 +39,6 @@ struct signalfd_siginfo {
 	__s32 ssi_syscall;
 	__u64 ssi_call_addr;
 	__u32 ssi_arch;
-	__u32 ssi_perf_type;
-	__u64 ssi_perf_data;
 
 	/*
 	 * Pad strcture to 128 bytes. Remember to update the
@@ -51,7 +49,7 @@ struct signalfd_siginfo {
 	 * comes out of a read(2) and we really don't want to have
 	 * a compat on read(2).
 	 */
-	__u8 __pad[16];
+	__u8 __pad[28];
 };
 
 
-- 
2.30.1

