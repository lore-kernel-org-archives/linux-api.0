Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6620DC433FE
	for <linux-api@archiver.kernel.org>; Mon,  3 Jan 2022 21:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiACVdv (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 3 Jan 2022 16:33:51 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:45890 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiACVdt (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 3 Jan 2022 16:33:49 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:56496)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4Uxf-00ET10-VJ; Mon, 03 Jan 2022 14:33:48 -0700
Received: from ip68-110-24-146.om.om.cox.net ([68.110.24.146]:54408 helo=localhost.localdomain)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4Uxe-006zvm-Oo; Mon, 03 Jan 2022 14:33:47 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon,  3 Jan 2022 15:33:03 -0600
Message-Id: <20220103213312.9144-8-ebiederm@xmission.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
References: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1n4Uxe-006zvm-Oo;;;mid=<20220103213312.9144-8-ebiederm@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.110.24.146;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19v1FHwGXBXGWLQ9gxNwRHnNBkfOqEsAZQ=
X-SA-Exim-Connect-IP: 68.110.24.146
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 08/17] ptrace/m68k: Stop open coding ptrace_report_syscall
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

The generic function ptrace_report_syscall does a little more
than syscall_trace on m68k.  The function ptrace_report_syscall
stops early if PT_TRACED is not set, it sets ptrace_message,
and returns the result of fatal_signal_pending.

Setting ptrace_message to a passed in value of 0 is effectively not
setting ptrace_message, making that additional work a noop.

Returning the result of fatal_signal_pending and letting the caller
ignore the result becomes a noop in this change.

When a process is ptraced, the flag PT_PTRACED is always set in
current->ptrace.  Testing for PT_PTRACED in ptrace_report_syscall is
just an optimization to fail early if the process is not ptraced.
Later on in ptrace_notify, ptrace_stop will test current->ptrace under
tasklist_lock and skip performing any work if the task is not ptraced.

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/m68k/kernel/ptrace.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/m68k/kernel/ptrace.c b/arch/m68k/kernel/ptrace.c
index 94b3b274186d..aa3a0b8d07e9 100644
--- a/arch/m68k/kernel/ptrace.c
+++ b/arch/m68k/kernel/ptrace.c
@@ -273,17 +273,7 @@ long arch_ptrace(struct task_struct *child, long request,
 
 asmlinkage void syscall_trace(void)
 {
-	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
-				 ? 0x80 : 0));
-	/*
-	 * this isn't the same as continuing with a signal, but it will do
-	 * for normal use.  strace only continues with a signal if the
-	 * stopping signal is not SIGTRAP.  -brl
-	 */
-	if (current->exit_code) {
-		send_sig(current->exit_code, current, 1);
-		current->exit_code = 0;
-	}
+	ptrace_report_syscall(0);
 }
 
 #if defined(CONFIG_COLDFIRE) || !defined(CONFIG_MMU)
-- 
2.29.2

