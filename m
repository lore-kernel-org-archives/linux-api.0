Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A2BBC433EF
	for <linux-api@archiver.kernel.org>; Tue, 16 Nov 2021 05:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 233A463214
	for <linux-api@archiver.kernel.org>; Tue, 16 Nov 2021 05:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbhKPFiI convert rfc822-to-8bit (ORCPT
        <rfc822;linux-api@archiver.kernel.org>);
        Tue, 16 Nov 2021 00:38:08 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:57792 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234717AbhKPFhs (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Tue, 16 Nov 2021 00:37:48 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:55522)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mmr7B-00AaPP-Mf; Mon, 15 Nov 2021 22:34:41 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:45578 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mmr7A-001l92-Ea; Mon, 15 Nov 2021 22:34:41 -0700
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
Date:   Mon, 15 Nov 2021 23:34:33 -0600
In-Reply-To: <87bl2kekig.fsf_-_@email.froward.int.ebiederm.org> (Eric
        W. Biederman's message of "Mon, 15 Nov 2021 23:29:11 -0600")
Message-ID: <87tugcd5p2.fsf_-_@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1mmr7A-001l92-Ea;;;mid=<87tugcd5p2.fsf_-_@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+onuKKUGqsUIK08Xm/5KwhYxu4ZLme44k=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 3/3] signal: Requeue ptrace signals
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org


Kyle Huey <me@kylehuey.com> writes:

> rr, a userspace record and replay debugger[0], uses the recorded register
> state at PTRACE_EVENT_EXIT to find the point in time at which to cease
> executing the program during replay.
>
> If a SIGKILL races with processing another signal in get_signal, it is
> possible for the kernel to decline to notify the tracer of the original
> signal. But if the original signal had a handler, the kernel proceeds
> with setting up a signal handler frame as if the tracer had chosen to
> deliver the signal unmodified to the tracee. When the kernel goes to
> execute the signal handler that it has now modified the stack and registers
> for, it will discover the pending SIGKILL, and terminate the tracee
> without executing the handler. When PTRACE_EVENT_EXIT is delivered to
> the tracer, however, the effects of handler setup will be visible to
> the tracer.
>
> Because rr (the tracer) was never notified of the signal, it is not aware
> that a signal handler frame was set up and expects the state of the program
> at PTRACE_EVENT_EXIT to be a state that will be reconstructed naturally
> by allowing the program to execute from the last event. When that fails
> to happen during replay, rr will assert and die.
>
> The following patches add an explicit check for a newly pending SIGKILL
> after the ptracer has been notified and the siglock has been reacquired.
> If this happens, we stop processing the current signal and proceed
> immediately to handling the SIGKILL. This makes the state reported at
> PTRACE_EVENT_EXIT the unmodified state of the program, and also avoids the
> work to set up a signal handler frame that will never be used.
>
> [0] https://rr-project.org/

The problem is that while the traced process makes it into ptrace_stop,
the tracee is killed before the tracer manages to wait for the
tracee and discover which signal was about to be delivered.

More generally the problem is that while siglock was dropped a signal
with process wide effect is short cirucit delivered to the entire
process killing it, but the process continues to try and deliver another
signal.

In general it impossible to avoid all cases where work is performed
after the process has been killed.  In particular if the process is
killed after get_signal returns the code will simply not know it has
been killed until after delivering the signal frame to userspace.

On the other hand when the code has already discovered the process
has been killed and taken user space visible action that shows
the kernel knows the process has been killed, it is just silly
to then write the signal frame to the user space stack.

Instead of being silly detect the process has been killed
in ptrace_signal and requeue the signal so the code can pretend
it was simply never dequeued for delivery.

To test the process has been killed I use fatal_signal_pending rather
than signal_group_exit to match the test in signal_pending_state which
is used in schedule which is where ptrace_stop detects the process has
been killed.

Requeuing the signal so the code can pretend it was simply never
dequeued improves the user space visible behavior that has been
present since ebf5ebe31d2c ("[PATCH] signal-fixes-2.5.59-A4").

Kyle Huey verified that this change in behavior and makes rr happy.

Reported-by: Kyle Huey <khuey@kylehuey.com>
Reported-by: Marko Mäkelä <marko.makela@mariadb.com>
History Tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.gi
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/signal.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 43e8b7e362b0..621401550f0f 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2565,7 +2565,8 @@ static int ptrace_signal(int signr, kernel_siginfo_t *info, enum pid_type type)
 	}
 
 	/* If the (new) signal is now blocked, requeue it.  */
-	if (sigismember(&current->blocked, signr)) {
+	if (sigismember(&current->blocked, signr) ||
+	    fatal_signal_pending(current)) {
 		send_signal(signr, info, current, type);
 		signr = 0;
 	}
-- 
2.20.1

