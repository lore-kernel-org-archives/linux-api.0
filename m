Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E9BC433F5
	for <linux-api@archiver.kernel.org>; Tue, 16 Nov 2021 05:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC8DF61A07
	for <linux-api@archiver.kernel.org>; Tue, 16 Nov 2021 05:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbhKPFgC (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Tue, 16 Nov 2021 00:36:02 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:38420 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234516AbhKPFf7 (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 16 Nov 2021 00:35:59 -0500
Received: from in01.mta.xmission.com ([166.70.13.51]:34744)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mmr5X-005ujB-T1; Mon, 15 Nov 2021 22:32:59 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:45502 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mmr5V-00CP21-Sq; Mon, 15 Nov 2021 22:32:59 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     <linux-kernel@vger.kernel.org>
Cc:     Kyle Huey <me@kylehuey.com>, Jens Axboe <axboe@kernel.dk>,
        Peter Zijlstra <peterz@infradead.org>,
        Marco Elver <elver@google.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Collingbourne <pcc@google.com>,
        Alexey Gladkov <legion@kernel.org>,
        "Robert O'Callahan" <rocallahan@gmail.com>,
        Marko =?utf-8?B?TcOka2Vs?= =?utf-8?B?w6Q=?= 
        <marko.makela@mariadb.com>, <linux-api@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>
References: <20211101034147.6203-1-khuey@kylehuey.com>
        <877ddqabvs.fsf@disp2133>
        <CAP045AqJVXA60R9RF8Gb2PWGBsK6bZ7tVBkdCcPYYrp6rOkG-Q@mail.gmail.com>
        <87fsse8maf.fsf@disp2133>
        <CAP045ApAX725ZfujaK-jJNkfCo5s+oVFpBvNfPJk+DKY8K7d=Q@mail.gmail.com>
        <CAP045AqsstnxfTyXhhCGDSucqGN7BTtfHJ5s6ZxUQC5K-JU56A@mail.gmail.com>
        <87bl2kekig.fsf_-_@email.froward.int.ebiederm.org>
Date:   Mon, 15 Nov 2021 23:32:50 -0600
In-Reply-To: <87bl2kekig.fsf_-_@email.froward.int.ebiederm.org> (Eric
        W. Biederman's message of "Mon, 15 Nov 2021 23:29:11 -0600")
Message-ID: <875yssekcd.fsf_-_@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mmr5V-00CP21-Sq;;;mid=<875yssekcd.fsf_-_@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18nSLMNxq2NVHb2kqhlpUyfVui5RNnA3JM=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 1/3] signal: In get_signal test for signal_group_exit every time through the loop
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


Recently while investigating a problem with rr and signals I noticed
that siglock is dropped in ptrace_signal and get_signal does not jump
to relock.

Looking farther to see if the problem is anywhere else I see that
do_signal_stop also returns if signal_group_exit is true.  I believe
that test can now never be true, but it is a bit hard to trace
through and be certain.

Testing signal_group_exit is not expensive, so move the test for
signal_group_exit into the for loop inside of get_signal to ensure
the test is never skipped improperly.

This has been a potential since I added the test for signal_group_exit
was added.

Fixes: 35634ffa1751 ("signal: Always notice exiting tasks")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/signal.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 7c4b7ae714d4..986fa69c15c5 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2662,19 +2662,19 @@ bool get_signal(struct ksignal *ksig)
 		goto relock;
 	}
 
-	/* Has this task already been marked for death? */
-	if (signal_group_exit(signal)) {
-		ksig->info.si_signo = signr = SIGKILL;
-		sigdelset(&current->pending.signal, SIGKILL);
-		trace_signal_deliver(SIGKILL, SEND_SIG_NOINFO,
-				&sighand->action[SIGKILL - 1]);
-		recalc_sigpending();
-		goto fatal;
-	}
-
 	for (;;) {
 		struct k_sigaction *ka;
 
+		/* Has this task already been marked for death? */
+		if (signal_group_exit(signal)) {
+			ksig->info.si_signo = signr = SIGKILL;
+			sigdelset(&current->pending.signal, SIGKILL);
+			trace_signal_deliver(SIGKILL, SEND_SIG_NOINFO,
+				&sighand->action[SIGKILL - 1]);
+			recalc_sigpending();
+			goto fatal;
+		}
+
 		if (unlikely(current->jobctl & JOBCTL_STOP_PENDING) &&
 		    do_signal_stop(0))
 			goto relock;
-- 
2.20.1

