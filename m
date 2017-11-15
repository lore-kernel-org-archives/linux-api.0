From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH manpages 2/3] Add rseq manpage
Date: Wed, 15 Nov 2017 14:13:15 -0500
Message-ID: <20171115191316.828-3-mathieu.desnoyers@efficios.com>
References: <20171115191316.828-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171115191316.828-1-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

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
 man2/rseq.2 | 268 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 268 insertions(+)
 create mode 100644 man2/rseq.2

diff --git a/man2/rseq.2 b/man2/rseq.2
new file mode 100644
index 000000000..2877c618c
--- /dev/null
+++ b/man2/rseq.2
@@ -0,0 +1,268 @@
+.\" Copyright 2015-2017 Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
+.\"
+.\" %%%LICENSE_START(VERBATIM)
+.\" Permission is granted to make and distribute verbatim copies of this
+.\" manual provided the copyright notice and this permission notice are
+.\" preserved on all copies.
+.\"
+.\" Permission is granted to copy and distribute modified versions of this
+.\" manual under the conditions for verbatim copying, provided that the
+.\" entire resulting derived work is distributed under the terms of a
+.\" permission notice identical to this one.
+.\"
+.\" Since the Linux kernel and libraries are constantly changing, this
+.\" manual page may be incorrect or out-of-date.  The author(s) assume no
+.\" responsibility for errors or omissions, or for damages resulting from
+.\" the use of the information contained herein.  The author(s) may not
+.\" have taken the same level of care in the production of this manual,
+.\" which is licensed free of charge, as they might when working
+.\" professionally.
+.\"
+.\" Formatted or processed versions of this manual, if unaccompanied by
+.\" the source, must acknowledge the copyright and authors of this work.
+.\" %%%LICENSE_END
+.\"
+.TH RSEQ 2 2017-11-10 "Linux" "Linux Programmer's Manual"
+.SH NAME
+rseq \- Restartable sequences and cpu number cache
+.SH SYNOPSIS
+.nf
+.B #include <linux/rseq.h>
+.sp
+.BI "int rseq(struct rseq * " rseq ", uint32_t " rseq_len ", int " flags ", uint32_t " sig ");
+.sp
+.SH DESCRIPTION
+The
+.BR rseq ()
+ABI accelerates user-space operations on per-cpu data by defining a
+shared data structure ABI between each user-space thread and the kernel.
+
+It allows user-space to perform update operations on per-cpu data
+without requiring heavy-weight atomic operations.
+
+Restartable sequences are atomic with respect to preemption (making it
+atomic with respect to other threads running on the same CPU), as well
+as signal delivery (user-space execution contexts nested over the same
+thread).
+
+It is suited for update operations on per-cpu data.
+
+It can be used on data structures shared between threads within a
+process, and on data structures shared between threads across different
+processes.
+
+.PP
+Some examples of operations that can be accelerated or improved
+by this ABI:
+.IP \[bu] 2
+Memory allocator per-cpu free-lists,
+.IP \[bu] 2
+Querying the current CPU number,
+.IP \[bu] 2
+Incrementing per-CPU counters,
+.IP \[bu] 2
+Modifying data protected by per-CPU spinlocks,
+.IP \[bu] 2
+Inserting/removing elements in per-CPU linked-lists,
+.IP \[bu] 2
+Writing/reading per-CPU ring buffers content.
+.IP \[bu] 2
+Accurately reading performance monitoring unit counters
+with respect to thread migration.
+
+.PP
+The
+.I rseq
+argument is a pointer to the thread-local rseq structure to be shared
+between kernel and user-space. A NULL
+.I rseq
+value unregisters the current thread rseq structure.
+
+.PP
+The layout of
+.B struct rseq
+is as follows:
+.TP
+.B Structure alignment
+This structure is aligned on multiples of 32 bytes.
+.TP
+.B Structure size
+This structure is extensible. Its size is passed as parameter to the
+rseq system call.
+.TP
+.B Fields
+
+.TP
+.in +4n
+.I cpu_id_start
+Optimistic cache of the CPU number on which the current thread is
+running. Its value is guaranteed to always be a possible CPU number,
+even when rseq is not initialized. The value it contains should always
+be confirmed by reading the cpu_id field.
+.in
+.TP
+.in +4n
+.I cpu_id
+Cache of the CPU number on which the current thread is running.
+-1 if uninitialized.
+.in
+.TP
+.in +4n
+.I rseq_cs
+The rseq_cs field is a pointer to a struct rseq_cs. Is is NULL when no
+rseq assembly block critical section is active for the current thread.
+Setting it to point to a critical section descriptor (struct rseq_cs)
+marks the beginning of the critical section.
+.in
+.TP
+.in +4n
+.I flags
+Flags indicating the restart behavior for the current thread. This is
+mainly used for debugging purposes. Can be either:
+.IP \[bu]
+RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT
+.IP \[bu]
+RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL
+.IP \[bu]
+RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
+.in
+
+.PP
+The layout of
+.B struct rseq_cs
+version 0 is as follows:
+.TP
+.B Structure alignment
+This structure is aligned on multiples of 32 bytes.
+.TP
+.B Structure size
+This structure has a fixed size of 32 bytes.
+.TP
+.B Fields
+
+.TP
+.in +4n
+.I version
+Version of this structure.
+.in
+.TP
+.in +4n
+.I flags
+Flags indicating the restart behavior of this structure. Can be
+either:
+.IP \[bu]
+RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT
+.IP \[bu]
+RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL
+.IP \[bu]
+RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
+.TP
+.in +4n
+.I start_ip
+Instruction pointer address of the first instruction of the sequence of
+consecutive assembly instructions.
+.in
+.TP
+.in +4n
+.I post_commit_offset
+Offset (from start_ip address) of the address after the last instruction
+of the sequence of consecutive assembly instructions.
+.in
+.TP
+.in +4n
+.I abort_ip
+Instruction pointer address where to move the execution flow in case of
+abort of the sequence of consecutive assembly instructions.
+.in
+
+.PP
+The
+.I rseq_len
+argument is the size of the
+.I struct rseq
+to register.
+
+.PP
+The
+.I flags
+argument is 0 for registration, and
+.IR RSEQ_FLAG_UNREGISTER
+for unregistration.
+
+.PP
+The
+.I sig
+argument is the 32-bit signature to be expected before the abort
+handler code.
+
+.PP
+A single library per process should keep the rseq structure in a
+thread-local storage variable.
+The
+.I cpu_id
+field should be initialized to -1, and the
+.I cpu_id_start
+field should be initialized to a possible CPU value (typically 0).
+
+.PP
+Each thread is responsible for registering and unregistering its rseq
+structure. No more than one rseq structure address can be registered
+per thread at a given time.
+
+.PP
+In a typical usage scenario, the thread registering the rseq
+structure will be performing loads and stores from/to that structure. It
+is however also allowed to read that structure from other threads.
+The rseq field updates performed by the kernel provide relaxed atomicity
+semantics, which guarantee that other threads performing relaxed atomic
+reads of the cpu number cache will always observe a consistent value.
+
+.SH RETURN VALUE
+A return value of 0 indicates success. On error, \-1 is returned, and
+.I errno
+is set appropriately.
+
+.SH ERRORS
+.TP
+.B EINVAL
+Either
+.I flags
+contains an invalid value, or
+.I rseq
+contains an address which is not appropriately aligned, or
+.I rseq_len
+contains a size that does not match the size received on registration.
+.TP
+.B ENOSYS
+The
+.BR rseq ()
+system call is not implemented by this kernel.
+.TP
+.B EFAULT
+.I rseq
+is an invalid address.
+.TP
+.B EBUSY
+Restartable sequence is already registered for this thread.
+.TP
+.B EPERM
+The
+.I sig
+argument on unregistration does not match the signature received
+on registration.
+
+.SH VERSIONS
+The
+.BR rseq ()
+system call was added in Linux 4.X
+.BR (TODO).
+
+.SH CONFORMING TO
+.BR rseq ()
+is Linux-specific.
+
+.in
+.SH SEE ALSO
+.BR sched_getcpu (3) ,
+.BR cpu_opv (2) ,
+.BR membarrier (2)
-- 
2.11.0
