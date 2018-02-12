From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH manpages] membarrier.2: New membarrier commands introduced in 4.16
Date: Mon, 12 Feb 2018 14:55:49 -0500
Message-ID: <20180212195549.11485-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andrew Hunter <ahh@google.com>, Maged Michael <maged.michael@gmail.com>, Avi Kivity <avi@scylladb.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Dave Watson <davejwatson@fb.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrea Parri <parri.andrea@gmail.com>, Russell King <linux@armlinux.org.uk>, Greg Hackmann <ghackmann@google.com>, Will Deacon <will.deacon@arm.com>, David
List-Id: linux-api@vger.kernel.org

Document the following membarrier commands introduced in 4.16:
- MEMBARRIER_CMD_GLOBAL_EXPEDITED (the old enum label
  MEMBARRIER_CMD_SHARED is now an alias to preserve header backward
  compatibility),
- MEMBARRIER_CMD_GLOBAL_EXPEDITED,
- MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED,
- MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE,
- MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_SYNC_CORE.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 man2/membarrier.2 | 73 ++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 62 insertions(+), 11 deletions(-)

diff --git a/man2/membarrier.2 b/man2/membarrier.2
index c47bc875a..e878301ca 100644
--- a/man2/membarrier.2
+++ b/man2/membarrier.2
@@ -80,7 +80,7 @@ This command is always supported (on kernels where
 .BR membarrier ()
 is provided).
 .TP
-.B MEMBARRIER_CMD_SHARED
+.B MEMBARRIER_CMD_GLOBAL " (since Linux 4.16)"
 Ensure that all threads from all processes on the system pass through a
 state where all memory accesses to user-space addresses match program
 order between entry to and return from the
@@ -88,7 +88,30 @@ order between entry to and return from the
 system call.
 All threads on the system are targeted by this command.
 .TP
-.BR MEMBARRIER_CMD_PRIVATE_EXPEDITED " (since Linux 4.14)"
+.B MEMBARRIER_CMD_GLOBAL_EXPEDITED " (since Linux 4.16)"
+Execute a memory barrier on all running threads of all processes which
+previously registered with
+.BR MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED .
+Upon return from system call, the caller thread is ensured that all
+running threads have passed through a state where all memory accesses to
+user-space addresses match program order between entry to and return
+from the system call (non-running threads are de facto in such a state).
+This only covers threads from processes which registered with
+.BR MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED .
+Given that registration is about the intent to receive the barriers, it
+is valid to invoke
+.BR MEMBARRIER_CMD_GLOBAL_EXPEDITED
+from a non-registered process.
+.IP
+The "expedited" commands complete faster than the non-expedited ones;
+they never block, but have the downside of causing extra overhead.
+.TP
+.B MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED " (since Linux 4.16)"
+Register the process intent to receive
+.BR MEMBARRIER_CMD_GLOBAL_EXPEDITED
+memory barriers.
+.TP
+.B MEMBARRIER_CMD_PRIVATE_EXPEDITED " (since Linux 4.14)"
 Execute a memory barrier on each running thread belonging to the same
 process as the current thread.
 Upon return from system call, the calling
@@ -103,9 +126,29 @@ they never block, but have the downside of causing extra overhead.
 A process needs to register its intent to use the private
 expedited command prior to using it.
 .TP
-.BR MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED " (since Linux 4.14)"
+.B MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED " (since Linux 4.14)"
 Register the process's intent to use
-.BR MEMBARRIER_CMD_PRIVATE_EXPEDITED .
+.B MEMBARRIER_CMD_PRIVATE_EXPEDITED .
+.TP
+.B MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE " (since Linux 4.16)"
+In addition to provide memory ordering guarantees described in
+.BR MEMBARRIER_CMD_PRIVATE_EXPEDITED ,
+ensure the caller thread, upon return from system call, that all its
+running threads siblings have executed a core serializing instruction.
+This only covers threads from the same process as the caller thread.
+The "expedited" commands complete faster than the non-expedited ones,
+they never block, but have the downside of causing extra overhead. A
+process needs to register its intent to use the private expedited sync
+core command prior to using it.
+.TP
+.B MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_SYNC_CORE " (since Linux 4.16)"
+Register the process intent to use
+.BR MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE .
+.TP
+.B MEMBARRIER_CMD_SHARED
+ Alias to
+.BR MEMBARRIER_CMD_GLOBAL .
+Provided for header backward compatibility.
 .PP
 The
 .I flags
@@ -137,10 +180,14 @@ The pair ordering is detailed as (O: ordered, X: not ordered):
 On success, the
 .B MEMBARRIER_CMD_QUERY
 operation returns a bit mask of supported commands, and the
-.B MEMBARRIER_CMD_SHARED ,
+.B MEMBARRIER_CMD_GLOBAL ,
+.B MEMBARRIER_CMD_GLOBAL_EXPEDITED ,
+.B MEMBARRIER_CMD_REGISTER_GLOBAL_EXPEDITED ,
 .B MEMBARRIER_CMD_PRIVATE_EXPEDITED ,
-and
 .B MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED ,
+.B MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE ,
+and
+.B MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_SYNC_CORE
 operations return zero.
 On error, \-1 is returned,
 and
@@ -163,10 +210,14 @@ set to 0, error handling is required only for the first call to
 is invalid, or
 .I flags
 is nonzero, or the
-.BR MEMBARRIER_CMD_SHARED
+.BR MEMBARRIER_CMD_GLOBAL
 command is disabled because the
 .I nohz_full
-CPU parameter has been set.
+CPU parameter has been set, or the
+.BR MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE
+and
+.BR MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_SYNC_CORE
+commands are not implemented by the architecture.
 .TP
 .B ENOSYS
 The
@@ -294,9 +345,9 @@ init_membarrier(void)
         return \-1;
     }
 
-    if (!(ret & MEMBARRIER_CMD_SHARED)) {
+    if (!(ret & MEMBARRIER_CMD_GLOBAL)) {
         fprintf(stderr,
-            "membarrier does not support MEMBARRIER_CMD_SHARED\\n");
+            "membarrier does not support MEMBARRIER_CMD_GLOBAL\\n");
         return \-1;
     }
 
@@ -315,7 +366,7 @@ static void
 slow_path(int *read_a)
 {
     b = 1;
-    membarrier(MEMBARRIER_CMD_SHARED, 0);
+    membarrier(MEMBARRIER_CMD_GLOBAL, 0);
     *read_a = a;
 }
 
-- 
2.11.0
