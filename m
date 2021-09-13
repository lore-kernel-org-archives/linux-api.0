Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37FB2C433F5
	for <linux-api@archiver.kernel.org>; Mon, 13 Sep 2021 17:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EA7960E97
	for <linux-api@archiver.kernel.org>; Mon, 13 Sep 2021 17:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239370AbhIMRyn (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 13 Sep 2021 13:54:43 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57648 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239506AbhIMRye (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 13 Sep 2021 13:54:34 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id DA46C1F42D19
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     kernel@collabora.com, krisman@collabora.com,
        linux-api@vger.kernel.org, libc-alpha@sourceware.org,
        mtk.manpages@gmail.com, Davidlohr Bueso <dave@stgolabs.net>,
        Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
Subject: [PATCH v3 3/6] futex2: wire up syscall for x86
Date:   Mon, 13 Sep 2021 14:52:46 -0300
Message-Id: <20210913175249.81074-4-andrealmeid@collabora.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913175249.81074-1-andrealmeid@collabora.com>
References: <20210913175249.81074-1-andrealmeid@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Wire up syscall entry point for x86 arch, for both i386 and x86_64.

Signed-off-by: André Almeida <andrealmeid@collabora.com>
---
 arch/x86/entry/syscalls/syscall_32.tbl | 1 +
 arch/x86/entry/syscalls/syscall_64.tbl | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 960a021d543e..7e25543693de 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -453,3 +453,4 @@
 446	i386	landlock_restrict_self	sys_landlock_restrict_self
 447	i386	memfd_secret		sys_memfd_secret
 448	i386	process_mrelease	sys_process_mrelease
+449	i386	futex_waitv		sys_futex_waitv
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 18b5500ea8bf..fe8f8dd157b4 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -370,6 +370,7 @@
 446	common	landlock_restrict_self	sys_landlock_restrict_self
 447	common	memfd_secret		sys_memfd_secret
 448	common	process_mrelease	sys_process_mrelease
+449	common	futex_waitv		sys_futex_waitv
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
-- 
2.33.0

