From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 5.4 2/3] rseq: Fix: Unregister rseq for clone CLONE_VM
Date: Tue, 17 Sep 2019 14:29:58 -0400
Message-ID: <20190917182959.16333-3-mathieu.desnoyers@efficios.com>
References: <20190917182959.16333-1-mathieu.desnoyers@efficios.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190917182959.16333-1-mathieu.desnoyers@efficios.com>
Sender: stable-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>, linux-api@vger.kernel.org, stable@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Dmitry Vyukov <dvyukov@google.com>, Neel Natu <neelnatu@google.com>
List-Id: linux-api@vger.kernel.org

It has been reported by Google that rseq is not behaving properly
with respect to clone when CLONE_VM is used without CLONE_THREAD.
It keeps the prior thread's rseq TLS registered when the TLS of the
thread has moved, so the kernel can corrupt the TLS of the parent.

The approach of clearing the per task-struct rseq registration
on clone with CLONE_THREAD flag is incomplete. It does not cover
the use-case of clone with CLONE_VM set, but without CLONE_THREAD.

Here is the rationale for unregistering rseq on clone with CLONE_VM
flag set:

1) CLONE_THREAD requires CLONE_SIGHAND, which requires CLONE_VM to be
   set. Therefore, just checking for CLONE_VM covers all CLONE_THREAD
   uses. There is no point in checking for both CLONE_THREAD and
   CLONE_VM,

2) There is the possibility of an unlikely scenario where CLONE_SETTLS
   is used without CLONE_VM. In order to be an issue, it would require
   that the rseq TLS is in a shared memory area.

   I do not plan on adding CLONE_SETTLS to the set of clone flags which
   unregister RSEQ, because it would require that we also unregister RSEQ
   on set_thread_area(2) and arch_prctl(2) ARCH_SET_FS for completeness.
   So rather than doing a partial solution, it appears better to let
   user-space explicitly perform rseq unregistration across clone if
   needed in scenarios where CLONE_VM is not set.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Neel Natu <neelnatu@google.com>
Cc: linux-api@vger.kernel.org
Cc: <stable@vger.kernel.org>	# v4.18+
---
 include/linux/sched.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9f51932bd543..d1eab0012af1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1919,11 +1919,11 @@ static inline void rseq_migrate(struct task_struct *t)
 
 /*
  * If parent process has a registered restartable sequences area, the
- * child inherits. Only applies when forking a process, not a thread.
+ * child inherits. Unregister rseq for a clone with CLONE_VM set.
  */
 static inline void rseq_fork(struct task_struct *t, unsigned long clone_flags)
 {
-	if (clone_flags & CLONE_THREAD) {
+	if (clone_flags & CLONE_VM) {
 		t->rseq = NULL;
 		t->rseq_sig = 0;
 		t->rseq_event_mask = 0;
-- 
2.17.1
