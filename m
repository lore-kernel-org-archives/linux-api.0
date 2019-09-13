From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 5.3 2/3] rseq: Fix: Unregister rseq for CLONE_SETTLS
Date: Fri, 13 Sep 2019 11:12:19 -0400
Message-ID: <20190913151220.3105-2-mathieu.desnoyers@efficios.com>
References: <20190913151220.3105-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190913151220.3105-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>, Dmitry Vyukov <dvyukov@google.com>, linux-api@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-api@vger.kernel.org

It has been reported by Google that rseq is not behaving properly
with respect to clone when CLONE_VM is used without CLONE_THREAD.
It keeps the prior thread's rseq TLS registered when the TLS of the
thread has moved, so the kernel deals with the wrong TLS.

The approach of clearing the per task-struct rseq registration
on clone with CLONE_THREAD flag is incomplete. It does not cover
the use-case of clone with CLONE_VM set, but without CLONE_THREAD.

Looking more closely at each of the clone flags:

- CLONE_THREAD,
- CLONE_VM,
- CLONE_SETTLS.

It appears that the flag we really want to track is CLONE_SETTLS, which
moves the location of the TLS for the child, making the rseq
registration point to the wrong TLS.

Suggested-by: "H . Peter Anvin" <hpa@zytor.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: linux-api@vger.kernel.org
Cc: <stable@vger.kernel.org>
---
 include/linux/sched.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9f51932bd543..76bf55b5cccf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1919,11 +1919,11 @@ static inline void rseq_migrate(struct task_struct *t)
 
 /*
  * If parent process has a registered restartable sequences area, the
- * child inherits. Only applies when forking a process, not a thread.
+ * child inherits. Unregister rseq for a clone with CLONE_SETTLS set.
  */
 static inline void rseq_fork(struct task_struct *t, unsigned long clone_flags)
 {
-	if (clone_flags & CLONE_THREAD) {
+	if (clone_flags & CLONE_SETTLS) {
 		t->rseq = NULL;
 		t->rseq_sig = 0;
 		t->rseq_event_mask = 0;
-- 
2.17.1
