From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH manpages 3/3] Update membarrier manpage for 4.14, 4.15
Date: Wed, 15 Nov 2017 14:13:16 -0500
Message-ID: <20171115191316.828-4-mathieu.desnoyers@efficios.com>
References: <20171115191316.828-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115191316.828-1-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Add documentation for those new membarrier commands:

New in 4.14:
        MEMBARRIER_CMD_PRIVATE_EXPEDITED
        MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED

Adapt the MEMBARRIER_CMD_SHARED return value documentation to reflect
that it now returns -EINVAL when issued on a system configured for
nohz_full.

New in 4.15:
        MEMBARRIER_CMD_SHARED_EXPEDITED
        MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED
        MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE
        MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_SYNC_CORE

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
CC: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
CC: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
CC: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
CC: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
CC: Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
CC: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
CC: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
CC: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
CC: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
CC: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
CC: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
CC: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 man2/membarrier.2 | 98 +++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 84 insertions(+), 14 deletions(-)

diff --git a/man2/membarrier.2 b/man2/membarrier.2
index bbf611e10..6720d20f3 100644
--- a/man2/membarrier.2
+++ b/man2/membarrier.2
@@ -1,4 +1,4 @@
-.\" Copyright 2015 Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
+.\" Copyright 2015-2017 Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
 .\"
 .\" %%%LICENSE_START(VERBATIM)
 .\" Permission is granted to make and distribute verbatim copies of this
@@ -22,7 +22,7 @@
 .\" the source, must acknowledge the copyright and authors of this work.
 .\" %%%LICENSE_END
 .\"
-.TH MEMBARRIER 2 2017-09-15 "Linux" "Linux Programmer's Manual"
+.TH MEMBARRIER 2 2017-11-15 "Linux" "Linux Programmer's Manual"
 .SH NAME
 membarrier \- issue memory barriers on a set of threads
 .SH SYNOPSIS
@@ -87,6 +87,60 @@ order between entry to and return from the
 .BR membarrier ()
 system call.
 All threads on the system are targeted by this command.
+.TP
+.B MEMBARRIER_CMD_SHARED_EXPEDITED
+Execute a memory barrier on all running threads part of a process which
+previously registered with
+.BR MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED .
+Upon return from system call, the caller thread is ensured that all
+running threads have passed through a state where all memory accesses to
+user-space addresses match program order between entry to and return
+from the system call (non-running threads are de facto in such a state).
+This only covers threads from processes which registered with
+.BR MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED .
+Given that registration is about the intent to receive the barriers, it
+is valid to invoke
+.BR MEMBARRIER_CMD_SHARED_EXPEDITED
+from a non-registered process.
+.TP
+.B MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED
+Register the process intent to receive
+.BR MEMBARRIER_CMD_SHARED_EXPEDITED
+memory barriers.
+.TP
+.B MEMBARRIER_CMD_PRIVATE_EXPEDITED
+Execute a memory barrier on each running thread belonging to the same
+process as the current thread. Upon return from system call, the caller
+thread is ensured that all its running threads siblings have passed
+through a state where all memory accesses to user-space addresses match
+program order between entry to and return from the system call
+(non-running threads are de facto in such a state). This only covers
+threads from the same process as the caller thread. The "expedited"
+commands complete faster than the non-expedited ones, they never block,
+but have the downside of causing extra overhead. A process needs to
+register its intent to use the private expedited command prior to using
+it.
+.TP
+.B MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED
+Register the process intent to use
+.BR MEMBARRIER_CMD_PRIVATE_EXPEDITED .
+.TP
+.B MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE
+In addition to provide memory ordering guarantees described in
+.BR MEMBARRIER_CMD_PRIVATE_EXPEDITED ,
+ensure the caller thread, upon return from system call, that all its
+running threads siblings have executed a core serializing instruction.
+(architectures are required to guarantee that non-running threads issue
+core serializing instructions before they resume user-space execution).
+This only covers threads from the same process as the caller thread.
+The "expedited" commands complete faster than the non-expedited ones,
+they never block, but have the downside of causing extra overhead. A
+process needs to register its intent to use the private expedited sync
+core command prior to using it.
+.TP
+.B MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_SYNC_CORE
+Register the process intent to use
+.BR MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE .
 .PP
 The
 .I flags
@@ -117,9 +171,16 @@ The pair ordering is detailed as (O: ordered, X: not ordered):
 .SH RETURN VALUE
 On success, the
 .B MEMBARRIER_CMD_QUERY
-operation returns a bit mask of supported commands and the
-.B MEMBARRIER_CMD_SHARED
-operation returns zero.
+operation returns a bit mask of supported commands, and the
+.B MEMBARRIER_CMD_SHARED ,
+.B MEMBARRIER_CMD_SHARED_EXPEDITED ,
+.B MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED ,
+.B MEMBARRIER_CMD_PRIVATE_EXPEDITED ,
+.B MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED ,
+.B MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE ,
+and
+.B MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_SYNC_CORE 
+operations return zero.
 On error, \-1 is returned,
 and
 .I errno
@@ -138,22 +199,27 @@ set to 0, error handling is required only for the first call to
 .TP
 .B EINVAL
 .I cmd
-is invalid or
+is invalid, or
 .I flags
-is non-zero.
+is non-zero, or
+the architecture does not implement the
+.BR MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE
+and
+.BR MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED_SYNC_CORE
+commands, or the
+.BR MEMBARRIER_CMD_SHARED
+command is disabled because the
+.I nohz_full
+CPU parameter has been set.
 .TP
 .B ENOSYS
 The
 .BR membarrier ()
 system call is not implemented by this kernel.
 .TP
-.BR ENOSYS " (since Linux 4.11)"
-.\" 907565337ebf998a68cb5c5b2174ce5e5da065eb
-The
-.BR membarrier ()
-system call is disabled because the
-.I nohz_full
-CPU parameter has been set.
+.B EPERM
+The current process was not registered prior to using private expedited
+commands.
 .SH VERSIONS
 The
 .BR membarrier ()
@@ -162,6 +228,10 @@ system call was added in Linux 4.3.
 .SH CONFORMING TO
 .BR membarrier ()
 is Linux-specific.
+.in
+.SH SEE ALSO
+.BR cpu_opv (2) ,
+.BR rseq (2)
 .SH NOTES
 A memory barrier instruction is part of the instruction set of
 architectures with weakly-ordered memory models.
-- 
2.11.0
