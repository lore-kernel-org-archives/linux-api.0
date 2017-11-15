From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: [RFC PATCH manpages 1/3] Add cpu_opv system call manpage
Date: Wed, 15 Nov 2017 14:13:14 -0500
Message-ID: <20171115191316.828-2-mathieu.desnoyers@efficios.com>
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
 man2/cpu_opv.2 | 297 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 297 insertions(+)
 create mode 100644 man2/cpu_opv.2

diff --git a/man2/cpu_opv.2 b/man2/cpu_opv.2
new file mode 100644
index 000000000..3d998dcbf
--- /dev/null
+++ b/man2/cpu_opv.2
@@ -0,0 +1,297 @@
+.\" Copyright 2017 Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
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
+.TH CPU_OPV 2 2017-11-10 "Linux" "Linux Programmer's Manual"
+.SH NAME
+cpu_opv \- CPU preempt-off operation vector system call
+.SH SYNOPSIS
+.nf
+.B #include <linux/cpu_opv.h>
+.sp
+.BI "int cpu_opv(struct cpu_op * " cpu_opv ", int " cpuopcnt ", int " cpu ", int " flags ");
+.sp
+.SH DESCRIPTION
+The cpu_opv system call executes a vector of operations on behalf of
+user-space on a specific CPU with preemption disabled.
+
+The operations available are: comparison, memcpy, add, or, and, xor,
+left shift, right shift, and memory barrier. The system call receives a
+CPU number from user-space as argument, which is the CPU on which those
+operations need to be performed. All preparation steps such as loading
+pointers, and applying offsets to arrays, need to be performed by
+user-space before invoking the system call. The "comparison" operation
+can be used to check that the data used in the preparation step did not
+change between preparation of system call inputs and operation execution
+within the preempt-off critical section.
+
+A maximum limit of 16 operations per cpu_opv syscall invocation is
+enforced, and a overall maximum length sum, so user-space cannot
+generate a too long preempt-off critical section. Each operation is
+also limited a length of PAGE_SIZE bytes, meaning that an operation
+can touch a maximum of 4 pages.
+
+If the thread is not running on the requested CPU, an attempt is made to
+migrate it to the requested CPU. If the requested CPU is not part of
+the cpus allowed mask of the thread, the system call fails with EINVAL.
+The system call will fail with EAGAIN if the scheduler migrated the
+thread away from the requested CPU between its migration and following
+execution with disabled preemption. User-space is then free to retry
+either with the same or with a different CPU number, depending on its
+algorithmic constraints.
+
+.PP
+The layout of
+.B struct cpu_opv
+is as follows:
+.TP
+.B Fields
+
+.TP
+.in +4n
+.I op
+Operation of type
+.B enum cpu_op_type
+to perform. This operation type selects the associated "u" union field.
+.in
+.TP
+.in +4n
+.I len
+Length (in bytes) of data to consider for this operation.
+.in
+.TP
+.in +4n
+.I u.compare_op
+For a
+.B CPU_COMPARE_EQ_OP , and
+.B CPU_COMPARE_NE_OP , contains the 
+.B a
+and
+.B b
+pointers to compare. The
+.B expect_fault_a
+and
+.B expect_fault_b
+fields indicate whether a page fault should be expected for each of
+those pointers.
+If
+.B expect_fault_a , or
+.B expect_fault_b
+is set, EAGAIN is returned on fault, else EFAULT is returned. The
+.B len
+field is allowed to take values from 0 to PAGE_SIZE for comparison
+operations.
+.in
+.TP
+.in +4n
+.I u.memcpy_op
+For a
+.B CPU_MEMCPY_OP ,
+contains the 
+.B dst
+and
+.B src
+pointers, expressing a copy of
+.B src
+into
+.B dst. The
+.B expect_fault_dst
+and
+.B expect_fault_src
+fields indicate whether a page fault should be expected for each of
+those pointers.
+If
+.B expect_fault_dst , or
+.B expect_fault_src
+is set, EAGAIN is returned on fault, else EFAULT is returned. The
+.B len
+field is allowed to take values from 0 to PAGE_SIZE for memcpy
+operations.
+.in
+.TP
+.in +4n
+.I u.arithmetic_op
+For a
+.B CPU_ADD_OP ,
+contains the
+.B p ,
+.B count , and
+.B expect_fault_p
+fields, which are respectively a pointer to the memory location to
+increment, the 64-bit signed integer value to add, and whether a page
+fault should be expected for
+.B p .
+If
+.B expect_fault_p
+is set, EAGAIN is returned on fault, else EFAULT is returned. The
+.B len
+field is allowed to take values of 1, 2, 4, 8 bytes for arithmetic
+operations.
+.in
+.TP
+.in +4n
+.I u.bitwise_op
+For a
+.B CPU_OR_OP ,
+.B CPU_AND_OP , and
+.B CPU_XOR_OP ,
+contains the
+.B p ,
+.B mask , and
+.B expect_fault_p
+fields, which are respectively a pointer to the memory location to
+target, the mask to apply, and whether a page fault should be
+expected for
+.B p .
+If
+.B expect_fault_p
+is set, EAGAIN is returned on fault, else EFAULT is returned. The
+.B len
+field is allowed to take values of 1, 2, 4, 8 bytes for bitwise
+operations.
+.in
+.TP
+.in +4n
+.I u.shift_op
+For a
+.B CPU_LSHIFT_OP , and
+.B CPU_RSHIFT_OP ,
+contains the
+.B p ,
+.B bits , and
+.B expect_fault_p
+fields, which are respectively a pointer to the memory location to
+target, the number of bits to shift either left of right, and whether a
+page fault should be expected for
+.B p .
+If
+.B expect_fault_p
+is set, EAGAIN is returned on fault, else EFAULT is returned. The
+.B len
+field is allowed to take values of 1, 2, 4, 8 bytes for shift
+operations. The
+.B bits
+field is allowed to take values between 0 and 63.
+.in
+
+.PP
+The enum cpu_op_types contains the following operations:
+.IP \[bu] 2
+CPU_COMPARE_EQ_OP: Compare whether two memory locations are equal,
+.IP \[bu] 2
+CPU_COMPARE_NE_OP: Compare whether two memory locations differ,
+.IP \[bu] 2
+CPU_MEMCPY_OP: Copy a source memory location into a destination,
+.IP \[bu] 2
+CPU_ADD_OP: Increment a target memory location of a given count,
+.IP \[bu] 2
+CPU_OR_OP: Apply a "or" mask to a memory location,
+.IP \[bu] 2
+CPU_AND_OP: Apply a "and" mask to a memory location,
+.IP \[bu] 2
+CPU_XOR_OP: Apply a "xor" mask to a memory location,
+.IP \[bu] 2
+CPU_LSHIFT_OP: Shift a memory location left of a given number of bits,
+.IP \[bu] 2
+CPU_RSHIFT_OP: Shift a memory location right of a given number of bits.
+.IP \[bu] 2
+CPU_MB_OP: Issue a memory barrier.
+
+All of the operations above provide single-copy atomicity guarantees for
+word-sized, word-aligned target pointers, for both loads and stores.
+
+.PP
+The
+.I cpuopcnt
+argument is the number of elements in the cpu_opv array. It can take
+values from 0 to 16.
+
+.PP
+The
+.I cpu
+argument is the CPU number on which the operation sequence needs to be
+executed.
+
+.PP
+The
+.I flags
+argument is expected to be 0.
+
+.SH RETURN VALUE
+A return value of 0 indicates success. On error, \-1 is returned, and
+.I errno
+is set appropriately.
+
+.SH ERRORS
+.TP
+.B EAGAIN
+.BR cpu_opv ()
+system call should be attempted again.
+.TP
+.B EINVAL
+Either
+.I flags
+contains an invalid value, or
+.I cpu
+contains an invalid value or a value not allowed by the current thread's
+allowed cpu mask, or
+.I cpuopcnt
+contains an invalid value, or the
+.I cpu_opv
+operation vector contains an invalid
+.I op
+value, or the
+.I cpu_opv
+operation vector contains an invalid
+.I len
+value, or the
+.I cpu_opv
+operation vector sum of
+.I len
+values is too large.
+
+.TP
+.B ENOSYS
+The
+.BR cpu_opv ()
+system call is not implemented by this kernel.
+.TP
+.B EFAULT
+.I cpu_opv
+is an invalid address, or a pointer contained within an operation
+is invalid (and a fault is not expected for that pointer).
+
+.SH VERSIONS
+The
+.BR cpu_opv ()
+system call was added in Linux 4.X
+.BR (TODO).
+
+.SH CONFORMING TO
+.BR cpu_opv ()
+is Linux-specific.
+
+.in
+.SH SEE ALSO
+.BR membarrier (2) ,
+.BR rseq (2)
-- 
2.11.0
