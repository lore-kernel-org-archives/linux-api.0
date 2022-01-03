Return-Path: <linux-api-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB81C433FE
	for <linux-api@archiver.kernel.org>; Mon,  3 Jan 2022 21:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiACVeA (ORCPT <rfc822;linux-api@archiver.kernel.org>);
        Mon, 3 Jan 2022 16:34:00 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:53460 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbiACVdy (ORCPT
        <rfc822;linux-api@vger.kernel.org>); Mon, 3 Jan 2022 16:33:54 -0500
Received: from in02.mta.xmission.com ([166.70.13.52]:58906)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4Uxk-008tm1-Ss; Mon, 03 Jan 2022 14:33:52 -0700
Received: from ip68-110-24-146.om.om.cox.net ([68.110.24.146]:54408 helo=localhost.localdomain)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1n4Uxh-006zvm-6k; Mon, 03 Jan 2022 14:33:52 -0700
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date:   Mon,  3 Jan 2022 15:33:04 -0600
Message-Id: <20220103213312.9144-9-ebiederm@xmission.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
References: <87r19opkx1.fsf_-_@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-XM-SPF: eid=1n4Uxh-006zvm-6k;;;mid=<20220103213312.9144-9-ebiederm@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.110.24.146;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+y48VyZYQuysk3s96g6DwRz5UUcdOr+6o=
X-SA-Exim-Connect-IP: 68.110.24.146
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH 09/17] ptrace: Move setting/clearing ptrace_message into ptrace_stop
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-api.vger.kernel.org>
X-Mailing-List: linux-api@vger.kernel.org

Today ptrace_message is easy to overlook as it not a core part of
ptrace_stop.  It has been overlooked so much that there are places
that set ptrace_message and don't clear it, and places that never set
it.  So if you get an unlucky sequence of events the ptracer may be
able to read a ptrace_message that does not apply to the current
ptrace stop.

Move setting of ptrace_message into ptrace_stop so that it always gets
set before the stop, and always gets cleared after the stop.  This
prevents non-sense from being reported to userspace and makes
ptrace_message more visible in the ptrace API so that kernel
developers can see it.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/ptrace.h    |  5 ++---
 include/linux/tracehook.h |  6 ++----
 kernel/signal.c           | 19 +++++++++++--------
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 8aee2945ff08..06f27736c6f8 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -60,7 +60,7 @@ extern int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned
 extern void ptrace_disable(struct task_struct *);
 extern int ptrace_request(struct task_struct *child, long request,
 			  unsigned long addr, unsigned long data);
-extern void ptrace_notify(int exit_code);
+extern void ptrace_notify(int exit_code, unsigned long message);
 extern void __ptrace_link(struct task_struct *child,
 			  struct task_struct *new_parent,
 			  const struct cred *ptracer_cred);
@@ -155,8 +155,7 @@ static inline bool ptrace_event_enabled(struct task_struct *task, int event)
 static inline void ptrace_event(int event, unsigned long message)
 {
 	if (unlikely(ptrace_event_enabled(current, event))) {
-		current->ptrace_message = message;
-		ptrace_notify((event << 8) | SIGTRAP);
+		ptrace_notify((event << 8) | SIGTRAP, message);
 	} else if (event == PTRACE_EVENT_EXEC) {
 		/* legacy EXEC report via SIGTRAP */
 		if ((current->ptrace & (PT_PTRACED|PT_SEIZED)) == PT_PTRACED)
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 88c007ab5ebc..5e60af8a11fc 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -61,8 +61,7 @@ static inline int ptrace_report_syscall(unsigned long message)
 	if (!(ptrace & PT_PTRACED))
 		return 0;
 
-	current->ptrace_message = message;
-	ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0));
+	ptrace_notify(SIGTRAP | ((ptrace & PT_TRACESYSGOOD) ? 0x80 : 0), message);
 
 	/*
 	 * this isn't the same as continuing with a signal, but it will do
@@ -74,7 +73,6 @@ static inline int ptrace_report_syscall(unsigned long message)
 		current->exit_code = 0;
 	}
 
-	current->ptrace_message = 0;
 	return fatal_signal_pending(current);
 }
 
@@ -143,7 +141,7 @@ static inline void tracehook_report_syscall_exit(struct pt_regs *regs, int step)
 static inline void tracehook_signal_handler(int stepping)
 {
 	if (stepping)
-		ptrace_notify(SIGTRAP);
+		ptrace_notify(SIGTRAP, 0);
 }
 
 /**
diff --git a/kernel/signal.c b/kernel/signal.c
index 802acca0207b..75bb062d8534 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2197,7 +2197,8 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
  * If we actually decide not to stop at all because the tracer
  * is gone, we keep current->exit_code unless clear_code.
  */
-static void ptrace_stop(int exit_code, int why, int clear_code, kernel_siginfo_t *info)
+static void ptrace_stop(int exit_code, int why, int clear_code,
+			unsigned long message, kernel_siginfo_t *info)
 	__releases(&current->sighand->siglock)
 	__acquires(&current->sighand->siglock)
 {
@@ -2243,6 +2244,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, kernel_siginfo_t
 	 */
 	smp_wmb();
 
+	current->ptrace_message = message;
 	current->last_siginfo = info;
 	current->exit_code = exit_code;
 
@@ -2321,6 +2323,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, kernel_siginfo_t
 	 */
 	spin_lock_irq(&current->sighand->siglock);
 	current->last_siginfo = NULL;
+	current->ptrace_message = 0;
 
 	/* LISTENING can be set only during STOP traps, clear it */
 	current->jobctl &= ~JOBCTL_LISTENING;
@@ -2333,7 +2336,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, kernel_siginfo_t
 	recalc_sigpending_tsk(current);
 }
 
-static void ptrace_do_notify(int signr, int exit_code, int why)
+static void ptrace_do_notify(int signr, int exit_code, int why, unsigned long message)
 {
 	kernel_siginfo_t info;
 
@@ -2344,17 +2347,17 @@ static void ptrace_do_notify(int signr, int exit_code, int why)
 	info.si_uid = from_kuid_munged(current_user_ns(), current_uid());
 
 	/* Let the debugger run.  */
-	ptrace_stop(exit_code, why, 1, &info);
+	ptrace_stop(exit_code, why, 1, message, &info);
 }
 
-void ptrace_notify(int exit_code)
+void ptrace_notify(int exit_code, unsigned long message)
 {
 	BUG_ON((exit_code & (0x7f | ~0xffff)) != SIGTRAP);
 	if (unlikely(current->task_works))
 		task_work_run();
 
 	spin_lock_irq(&current->sighand->siglock);
-	ptrace_do_notify(SIGTRAP, exit_code, CLD_TRAPPED);
+	ptrace_do_notify(SIGTRAP, exit_code, CLD_TRAPPED, message);
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
@@ -2510,10 +2513,10 @@ static void do_jobctl_trap(void)
 			signr = SIGTRAP;
 		WARN_ON_ONCE(!signr);
 		ptrace_do_notify(signr, signr | (PTRACE_EVENT_STOP << 8),
-				 CLD_STOPPED);
+				 CLD_STOPPED, 0);
 	} else {
 		WARN_ON_ONCE(!signr);
-		ptrace_stop(signr, CLD_STOPPED, 0, NULL);
+		ptrace_stop(signr, CLD_STOPPED, 0, 0, NULL);
 		current->exit_code = 0;
 	}
 }
@@ -2567,7 +2570,7 @@ static int ptrace_signal(int signr, kernel_siginfo_t *info, enum pid_type type)
 	 * comment in dequeue_signal().
 	 */
 	current->jobctl |= JOBCTL_STOP_DEQUEUED;
-	ptrace_stop(signr, CLD_TRAPPED, 0, info);
+	ptrace_stop(signr, CLD_TRAPPED, 0, 0, info);
 
 	/* We're back.  Did the debugger cancel the sig?  */
 	signr = current->exit_code;
-- 
2.29.2

