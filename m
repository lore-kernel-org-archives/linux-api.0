From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 10/10] signal: Remove SEND_SIG_FORCED
Date: Mon,  3 Sep 2018 22:44:30 +0200
Message-ID: <20180903204430.25473-10-ebiederm@xmission.com>
References: <87musyl3fa.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87musyl3fa.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

There are no more users of SEND_SIG_FORCED so it may be safely removed.

Remove the definition of SEND_SIG_FORCED, it's use in is_si_special,
it's use in TP_STORE_SIGINFO, and it's use in __send_signal as without
any users the uses of SEND_SIG_FORCED are now unncessary.

This makes the code simpler, easier to understand and use.  Users of
signal sending functions now no longer need to ask themselves do I
need to use SEND_SIG_FORCED.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/sched/signal.h  | 1 -
 include/trace/events/signal.h | 3 +--
 kernel/signal.c               | 7 +++----
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 9b6968cbde14..9e07f3521549 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -477,7 +477,6 @@ static inline int kill_cad_pid(int sig, int priv)
 /* These can be the second arg to send_sig_info/send_group_sig_info.  */
 #define SEND_SIG_NOINFO ((struct siginfo *) 0)
 #define SEND_SIG_PRIV	((struct siginfo *) 1)
-#define SEND_SIG_FORCED	((struct siginfo *) 2)
 
 /*
  * True if we are on the alternate signal stack.
diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index 86582923d51c..3deeed50ffd0 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -11,8 +11,7 @@
 
 #define TP_STORE_SIGINFO(__entry, info)				\
 	do {							\
-		if (info == SEND_SIG_NOINFO ||			\
-		    info == SEND_SIG_FORCED) {			\
+		if (info == SEND_SIG_NOINFO) {			\
 			__entry->errno	= 0;			\
 			__entry->code	= SI_USER;		\
 		} else if (info == SEND_SIG_PRIV) {		\
diff --git a/kernel/signal.c b/kernel/signal.c
index d7d1adf735f4..ec136fda457a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -736,7 +736,7 @@ static void flush_sigqueue_mask(sigset_t *mask, struct sigpending *s)
 
 static inline int is_si_special(const struct siginfo *info)
 {
-	return info <= SEND_SIG_FORCED;
+	return info <= SEND_SIG_PRIV;
 }
 
 static inline bool si_fromuser(const struct siginfo *info)
@@ -1039,7 +1039,7 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 
 	result = TRACE_SIGNAL_IGNORED;
 	if (!prepare_signal(sig, t,
-			from_ancestor_ns || (info == SEND_SIG_PRIV) || (info == SEND_SIG_FORCED)))
+			from_ancestor_ns || (info == SEND_SIG_PRIV)))
 		goto ret;
 
 	pending = (type != PIDTYPE_PID) ? &t->signal->shared_pending : &t->pending;
@@ -1057,8 +1057,7 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
 	 * Skip useless siginfo allocation for SIGKILL SIGSTOP,
 	 * and kernel threads.
 	 */
-	if ((info == SEND_SIG_FORCED) ||
-	    sig_kernel_only(sig) || (t->flags & PF_KTHREAD))
+	if (sig_kernel_only(sig) || (t->flags & PF_KTHREAD))
 		goto out_set;
 
 	/*
-- 
2.17.1
