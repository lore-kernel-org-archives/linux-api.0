From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] Update membarrier manpage for 4.14, 4.15
Date: Sun, 19 Nov 2017 12:12:10 +0100
Message-ID: <038c0532-f45c-7beb-5b47-e34816f5b082@gmail.com>
References: <20171116151711.19001-1-mathieu.desnoyers@efficios.com>
 <20171116151711.19001-4-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171116151711.19001-4-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catali>
List-Id: linux-api@vger.kernel.org

Hi Mathieu,

On 11/16/2017 04:17 PM, Mathieu Desnoyers wrote:
> Add documentation for those new membarrier commands:
> 
> New in 4.14:
>         MEMBARRIER_CMD_PRIVATE_EXPEDITED
>         MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED
> 
> Adapt the MEMBARRIER_CMD_SHARED return value documentation to reflect
> that it now returns -EINVAL when issued on a system configured for
> nohz_full.
> 
> New in 4.15:
>         MEMBARRIER_CMD_SHARED_EXPEDITED
>         MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED

Combining details into one patch in this way makes things more difficult
for me. I would prefer these details to be split into separate pieces
for the 4.14 and 4.15 changes, in part because of the way the man-pages
release cycle currently works (roughly synchronized with kernel releases)
and also because the 4.15 details might change.

I've applied the 4.14 details from this patch to the man page; if you had a 
chance to check whether I did that job correctly, that would be great.
See the patch below.

Once the pieces get merged for 4.15, could you ping me/resend a patch for
the 4.15 changes please.

Cheers,

Michael


diff --git a/man2/membarrier.2 b/man2/membarrier.2
index bbf611e10..6390f9693 100644
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
@@ -87,6 +87,25 @@ order between entry to and return from the
 .BR membarrier ()
 system call.
 All threads on the system are targeted by this command.
+.TP
+.BR MEMBARRIER_CMD_PRIVATE_EXPEDITED " (since Linux 4.14)"
+Execute a memory barrier on each running thread belonging to the same
+process as the current thread.
+Upon return from system call, the calling
+thread is assured that all its running threads siblings have passed
+through a state where all memory accesses to user-space addresses match
+program order between entry to and return from the system call
+(non-running threads are de facto in such a state).
+This covers only threads from the same process as the calling thread.
+.IP
+The "expedited" commands complete faster than the non-expedited ones;
+they never block, but have the downside of causing extra overhead.
+A process needs to register its intent to use the private
+expedited command prior to using it.
+.TP
+.BR MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED " (since Linux 4.14)"
+Register the process's intent to use
+.BR MEMBARRIER_CMD_PRIVATE_EXPEDITED .
 .PP
 The
 .I flags
@@ -117,9 +136,12 @@ The pair ordering is detailed as (O: ordered, X: not ordered):
 .SH RETURN VALUE
 On success, the
 .B MEMBARRIER_CMD_QUERY
-operation returns a bit mask of supported commands and the
-.B MEMBARRIER_CMD_SHARED
-operation returns zero.
+operation returns a bit mask of supported commands, and the
+.B MEMBARRIER_CMD_SHARED ,
+.B MEMBARRIER_CMD_PRIVATE_EXPEDITED ,
+and
+.B MEMBARRIER_CMD_REGISTER_PRIVATE_EXPEDITED ,
+operations return zero.
 On error, \-1 is returned,
 and
 .I errno
@@ -138,22 +160,22 @@ set to 0, error handling is required only for the first call to
 .TP
 .B EINVAL
 .I cmd
-is invalid or
+is invalid, or
 .I flags
-is non-zero.
+is non-zero, or the
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
@@ -162,6 +184,10 @@ system call was added in Linux 4.3.
 .SH CONFORMING TO
 .BR membarrier ()
 is Linux-specific.
+.\" .SH SEE ALSO
+.\" FIXME See if the following syscalls make it into Linux 4.15 or later
+.\" .BR cpu_opv (2),
+.\" .BR rseq (2)
 .SH NOTES
 A memory barrier instruction is part of the instruction set of
 architectures with weakly-ordered memory models.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
