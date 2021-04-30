Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA25FC43461
	for <linux-api@archiver.kernel.org>; Fri, 30 Apr 2021 23:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DE846141E
	for <linux-api@archiver.kernel.org>; Fri, 30 Apr 2021 23:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbhD3XoR (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 30 Apr 2021 19:44:17 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39932 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhD3XoQ (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 30 Apr 2021 19:44:16 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lccn9-00Cty4-Kg; Fri, 30 Apr 2021 17:43:27 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lccn6-0000UE-Es; Fri, 30 Apr 2021 17:43:26 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
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
        kasan-dev <kasan-dev@googlegroups.com>
References: <YIpkvGrBFGlB5vNj@elver.google.com>
        <m11rat9f85.fsf@fess.ebiederm.org>
        <CAK8P3a0+uKYwL1NhY6Hvtieghba2hKYGD6hcKx5n8=4Gtt+pHA@mail.gmail.com>
        <m15z031z0a.fsf@fess.ebiederm.org> <YIxVWkT03TqcJLY3@elver.google.com>
        <m1zgxfs7zq.fsf_-_@fess.ebiederm.org>
Date:   Fri, 30 Apr 2021 18:43:20 -0500
In-Reply-To: <m1zgxfs7zq.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's
        message of "Fri, 30 Apr 2021 17:49:45 -0500")
Message-ID: <m17dkjqqxz.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lccn6-0000UE-Es;;;mid=<m17dkjqqxz.fsf_-_@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+W2OA1W2SlAwE5XeYrhZGR3rJ/oNhsGXY=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 6/3] signal: Factor force_sig_perf out of perf_sigtrap
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


Separate generating the signal from deciding it needs to be sent.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/sched/signal.h |  1 +
 kernel/events/core.c         | 11 ++---------
 kernel/signal.c              | 13 +++++++++++++
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 7daa425f3055..1e2f61a1a512 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -318,6 +318,7 @@ int send_sig_mceerr(int code, void __user *, short, struct task_struct *);
 
 int force_sig_bnderr(void __user *addr, void __user *lower, void __user *upper);
 int force_sig_pkuerr(void __user *addr, u32 pkey);
+int force_sig_perf(void __user *addr, u32 type, u64 sig_data);
 
 int force_sig_fault_trapno(int sig, int code, void __user *addr, int trapno);
 int send_sig_fault_trapno(int sig, int code, void __user *addr, int trapno,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 928b166d888e..48ea8863183b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6394,8 +6394,6 @@ void perf_event_wakeup(struct perf_event *event)
 
 static void perf_sigtrap(struct perf_event *event)
 {
-	struct kernel_siginfo info;
-
 	/*
 	 * We'd expect this to only occur if the irq_work is delayed and either
 	 * ctx->task or current has changed in the meantime. This can be the
@@ -6410,13 +6408,8 @@ static void perf_sigtrap(struct perf_event *event)
 	if (current->flags & PF_EXITING)
 		return;
 
-	clear_siginfo(&info);
-	info.si_signo = SIGTRAP;
-	info.si_code = TRAP_PERF;
-	info.si_errno = event->attr.type;
-	info.si_perf = event->attr.sig_data;
-	info.si_addr = (void __user *)event->pending_addr;
-	force_sig_info(&info);
+	force_sig_perf((void __user *)event->pending_addr,
+		       event->attr.type, event->attr.sig_data);
 }
 
 static void perf_pending_event_disable(struct perf_event *event)
diff --git a/kernel/signal.c b/kernel/signal.c
index 690921960d8b..5b1ad7f080ab 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1753,6 +1753,19 @@ int force_sig_pkuerr(void __user *addr, u32 pkey)
 }
 #endif
 
+int force_sig_perf(void __user *pending_addr, u32 type, u64 sig_data)
+{
+	struct kernel_siginfo info;
+
+	clear_siginfo(&info);
+	info.si_signo = SIGTRAP;
+	info.si_errno = type;
+	info.si_code  = TRAP_PERF;
+	info.si_addr  = pending_addr;
+	info.si_perf  = sig_data;
+	return force_sig_info(&info);
+}
+
 #if IS_ENABLED(SPARC)
 int force_sig_fault_trapno(int sig, int code, void __user *addr, int trapno)
 {
-- 
2.30.1

