From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 5.5 1/2 v2] rseq: Fix: Clarify rseq.h UAPI rseq_cs memory reclaim requirements
Date: Fri, 20 Dec 2019 15:33:17 -0500
Message-ID: <20191220203318.18739-1-mathieu.desnoyers@efficios.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>, linux-api@vger.kernel.org, stable@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Florian Weimer <fw@deneb.enyo.de>, Dmitry Vyukov <dvyukov@google.com>, Neel Natu <neelnatu@google.com>
List-Id: linux-api@vger.kernel.org

The rseq.h UAPI documents that the rseq_cs field must be cleared
before reclaiming memory that contains the targeted struct rseq_cs.

We should extend this comment to also dictate that the rseq_cs field
must be cleared before reclaiming memory of the code pointed to by
the rseq_cs start_ip and post_commit_offset fields.

While we can expect that use of dlclose(3) will typically unmap
both struct rseq_cs and its associated code at once, nothing would
theoretically prevent a JIT from reclaiming the code without
reclaiming the struct rseq_cs, which would erroneously allow the
kernel to consider new code which is not a rseq critical section
as a rseq critical section following a code reclaim.

Suggested-by: Florian Weimer <fw@deneb.enyo.de>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Florian Weimer <fw@deneb.enyo.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Paul Turner <pjt@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Neel Natu <neelnatu@google.com>
Cc: linux-api@vger.kernel.org
---
 include/uapi/linux/rseq.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/rseq.h b/include/uapi/linux/rseq.h
index 9a402fdb60e9..d94afdfc4b7c 100644
--- a/include/uapi/linux/rseq.h
+++ b/include/uapi/linux/rseq.h
@@ -100,7 +100,9 @@ struct rseq {
 	 * instruction sequence block, as well as when the kernel detects that
 	 * it is preempting or delivering a signal outside of the range
 	 * targeted by the rseq_cs. Also needs to be set to NULL by user-space
-	 * before reclaiming memory that contains the targeted struct rseq_cs.
+	 * before reclaiming memory that contains the targeted struct rseq_cs
+	 * or reclaiming memory that contains the code referred to by the
+	 * start_ip and post_commit_offset fields of struct rseq_cs.
 	 *
 	 * Read and set by the kernel. Set by user-space with single-copy
 	 * atomicity semantics. This field should only be updated by the
-- 
2.17.1
