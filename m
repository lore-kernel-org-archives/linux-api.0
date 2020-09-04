Return-Path: <SRS0=+ro9=CN=vger.kernel.org=linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A171BC433E2
	for <linux-api@archiver.kernel.org>; Fri,  4 Sep 2020 20:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7372E208FE
	for <linux-api@archiver.kernel.org>; Fri,  4 Sep 2020 20:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgIDUcS (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Fri, 4 Sep 2020 16:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgIDUcR (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Fri, 4 Sep 2020 16:32:17 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABD6C061244;
        Fri,  4 Sep 2020 13:32:16 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 6224429B031
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     luto@kernel.org, tglx@linutronix.de, keescook@chromium.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, willy@infradead.org,
        linux-kselftest@vger.kernel.org, shuah@kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel@collabora.com
Subject: [PATCH v6 6/9] kernel: entry: Support Syscall User Dispatch for common syscall entry
Date:   Fri,  4 Sep 2020 16:31:44 -0400
Message-Id: <20200904203147.2908430-7-krisman@collabora.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904203147.2908430-1-krisman@collabora.com>
References: <20200904203147.2908430-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-api-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Syscall User Dispatch (SUD) must take precedence over seccomp, since the
use case is emulation (it can be invoked with a different ABI) such that
seccomp filtering by syscall number doesn't make sense in the first
place.  In addition, either the syscall is dispatched back to userspace,
in which case there is no resource for seccomp to protect, or the
syscall will be executed, and seccomp will execute next.

Regarding ptrace, I experimented with before and after, and while the
same ABI argument applies, I felt it was easier to debug if I let ptrace
happen for syscalls that are dispatched back to userspace.  In addition,
doing it after ptrace makes the code in syscall_exit_work slightly
simpler, since it doesn't require special handling for this feature.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 kernel/entry/common.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index 44fd089d59da..fdb0c543539d 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -6,6 +6,8 @@
 #include <linux/audit.h>
 #include <linux/syscall_intercept.h>
 
+#include "common.h"
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/syscalls.h>
 
@@ -47,6 +49,12 @@ static inline long do_syscall_intercept(struct pt_regs *regs)
 	int sysint_work = READ_ONCE(current->syscall_intercept);
 	int ret;
 
+	if (sysint_work & SYSINT_USER_DISPATCH) {
+		ret = do_syscall_user_dispatch(regs);
+		if (ret == -1L)
+			return ret;
+	}
+
 	if (sysint_work & SYSINT_SECCOMP) {
 		ret = __secure_computing(NULL);
 		if (ret == -1L)
-- 
2.28.0

