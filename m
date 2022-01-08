Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259A3C433EF
	for <linux-api@archiver.kernel.org>; Sat,  8 Jan 2022 18:15:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbiAHSP2 (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sat, 8 Jan 2022 13:15:28 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:54338 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiAHSP2 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sat, 8 Jan 2022 13:15:28 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:48666)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n6GFT-006htb-3S; Sat, 08 Jan 2022 11:15:27 -0700
Received: from ip68-110-24-146.om.om.cox.net ([68.110.24.146]:33952 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n6GFS-005bqx-6Y; Sat, 08 Jan 2022 11:15:26 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Dmitry Osipenko <digetx@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-api@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Gladkov <legion@kernel.org>,
        Kyle Huey <me@kylehuey.com>, Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
References: <87a6ha4zsd.fsf@email.froward.int.ebiederm.org>
        <20211213225350.27481-1-ebiederm@xmission.com>
        <9363765f-9883-75ee-70f1-a1a8e9841812@gmail.com>
        <87pmp67y4r.fsf@email.froward.int.ebiederm.org>
        <5bbb54c4-7504-cd28-5dde-4e5965496625@gmail.com>
        <87bl0m14ew.fsf@email.froward.int.ebiederm.org>
Date:   Sat, 08 Jan 2022 12:15:19 -0600
In-Reply-To: <87bl0m14ew.fsf@email.froward.int.ebiederm.org> (Eric
        W. Biederman's message of "Sat, 08 Jan 2022 12:13:59 -0600")
Message-ID: <875yqu14co.fsf_-_@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1n6GFS-005bqx-6Y;;;mid=<875yqu14co.fsf_-_@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.110.24.146;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19tTDfi2jdTaShFJWnwopkYqBuAXeA1hg8=
X-SA-Exim-Connect-IP: 68.110.24.146
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 1/2] signal: Have prepare_signal detect coredumps using
 signal->core_state
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


In preparation for removing the flag SIGNAL_GROUP_COREDUMP, change
prepare_signal to test signal->core_state instead of the flag
SIGNAL_GROUP_COREDUMP.

Both fields are protected by siglock and both live in signal_struct so
there are no real tradeoffs here, just a change to which field is
being tested.

Link: https://lkml.kernel.org/r/20211213225350.27481-1-ebiederm@xmission.com
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/signal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 8272cac5f429..f95a4423519d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -906,8 +906,8 @@ static bool prepare_signal(int sig, struct task_struct *p, bool force)
 	struct task_struct *t;
 	sigset_t flush;
 
-	if (signal->flags & (SIGNAL_GROUP_EXIT | SIGNAL_GROUP_COREDUMP)) {
-		if (!(signal->flags & SIGNAL_GROUP_EXIT))
+	if ((signal->flags & SIGNAL_GROUP_EXIT) || signal->core_state) {
+		if (signal->core_state)
 			return sig == SIGKILL;
 		/*
 		 * The process is in the middle of dying, nothing to do.
-- 
2.29.2

