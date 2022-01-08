Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8133C433FE
	for <linux-api@archiver.kernel.org>; Sat,  8 Jan 2022 18:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiAHSQC (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Sat, 8 Jan 2022 13:16:02 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:57896 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiAHSQB (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Sat, 8 Jan 2022 13:16:01 -0500
Received: from in01.mta.xmission.com ([166.70.13.51]:45214)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n6GG0-0010gX-AF; Sat, 08 Jan 2022 11:16:00 -0700
Received: from ip68-110-24-146.om.om.cox.net ([68.110.24.146]:33968 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n6GFz-000wMo-EX; Sat, 08 Jan 2022 11:15:59 -0700
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
Date:   Sat, 08 Jan 2022 12:15:52 -0600
In-Reply-To: <87bl0m14ew.fsf@email.froward.int.ebiederm.org> (Eric
        W. Biederman's message of "Sat, 08 Jan 2022 12:13:59 -0600")
Message-ID: <87zgo6ytyf.fsf_-_@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1n6GFz-000wMo-EX;;;mid=<87zgo6ytyf.fsf_-_@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.110.24.146;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX193qILMax3IbglF3xPQ+2Hp9i5erwfkqmQ=
X-SA-Exim-Connect-IP: 68.110.24.146
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 2/2] signal: Make coredump handling explicit in complete_signal
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


Ever since commit 6cd8f0acae34 ("coredump: ensure that SIGKILL always
kills the dumping thread") it has been possible for a SIGKILL received
during a coredump to set SIGNAL_GROUP_EXIT and trigger a process
shutdown (for a second time).

Update the logic to explicitly allow coredumps so that coredumps can
set SIGNAL_GROUP_EXIT and shutdown like an ordinary process.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index f95a4423519d..0706c1345a71 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1032,7 +1032,7 @@ static void complete_signal(int sig, struct task_struct *p, enum pid_type type)
 	 * then start taking the whole group down immediately.
 	 */
 	if (sig_fatal(p, sig) &&
-	    !(signal->flags & SIGNAL_GROUP_EXIT) &&
+	    (signal->core_state || !(signal->flags & SIGNAL_GROUP_EXIT)) &&
 	    !sigismember(&t->real_blocked, sig) &&
 	    (sig == SIGKILL || !p->ptrace)) {
 		/*
-- 
2.29.2

