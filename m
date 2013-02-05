From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/3] signal: add a helper for dequeuing signals from a specified queue (v2)
Date: Tue,  5 Feb 2013 13:00:14 +0100
Message-ID: <1360065614-1496-1-git-send-email-avagin@openvz.org>
References: <1358849741-9611-2-git-send-email-avagin@openvz.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358849741-9611-2-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

v2: export the symbol do_dequeue_signal

Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 include/linux/sched.h | 13 ++++++++++++-
 kernel/signal.c       | 12 +++++++-----
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 206bb08..45871f1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2221,7 +2221,18 @@ extern void flush_signals(struct task_struct *);
 extern void __flush_signals(struct task_struct *);
 extern void ignore_signals(struct task_struct *);
 extern void flush_signal_handlers(struct task_struct *, int force_default);
-extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info);
+
+#define SIGQUEUE_SHARED		1
+#define SIGQUEUE_PRIVATE	2
+extern int do_dequeue_signal(struct task_struct *tsk,
+				sigset_t *mask, siginfo_t *info, int qmask);
+
+static inline int dequeue_signal(struct task_struct *tsk,
+					sigset_t *mask, siginfo_t *info)
+{
+	return do_dequeue_signal(tsk, mask, info,
+					SIGQUEUE_SHARED | SIGQUEUE_PRIVATE);
+}
 
 static inline int dequeue_signal_lock(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 {
diff --git a/kernel/signal.c b/kernel/signal.c
index ac5f5e7..9d1cfc6 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -600,15 +600,17 @@ static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
  *
  * All callers have to hold the siglock.
  */
-int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
+int do_dequeue_signal(struct task_struct *tsk, sigset_t *mask,
+					siginfo_t *info, int qmask)
 {
-	int signr;
+	int signr = 0;
 
 	/* We only dequeue private signals from ourselves, we don't let
 	 * signalfd steal them
 	 */
-	signr = __dequeue_signal(&tsk->pending, mask, info);
-	if (!signr) {
+	if (qmask & SIGQUEUE_PRIVATE)
+		signr = __dequeue_signal(&tsk->pending, mask, info);
+	if (!signr && (qmask & SIGQUEUE_SHARED)) {
 		signr = __dequeue_signal(&tsk->signal->shared_pending,
 					 mask, info);
 		/*
@@ -2479,7 +2481,7 @@ out:
 }
 
 EXPORT_SYMBOL(recalc_sigpending);
-EXPORT_SYMBOL_GPL(dequeue_signal);
+EXPORT_SYMBOL_GPL(do_dequeue_signal);
 EXPORT_SYMBOL(flush_signals);
 EXPORT_SYMBOL(force_sig);
 EXPORT_SYMBOL(send_sig);
-- 
1.7.11.7
