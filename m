From: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Subject: [PATCH 2/6] mprotect.2: add pkey_mprotect() syscall
Date: Wed, 08 Jun 2016 10:34:54 -0700
Message-ID: <20160608173454.016D2496@ray>
References: <20160608173351.5CF7B2D3@ray>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160608173351.5CF7B2D3@ray>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Signed-off-by: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---

 b/man2/mprotect.2 |   44 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff -puN man2/mprotect.2~mprotect man2/mprotect.2
--- a/man2/mprotect.2~mprotect	2016-06-08 10:32:43.328409612 -0700
+++ b/man2/mprotect.2	2016-06-08 10:32:43.328409612 -0700
@@ -38,16 +38,19 @@
 .\"
 .TH MPROTECT 2 2015-07-23 "Linux" "Linux Programmer's Manual"
 .SH NAME
-mprotect \- set protection on a region of memory
+mprotect, pkey_mprotect \- set protection on a region of memory
 .SH SYNOPSIS
 .nf
 .B #include <sys/mman.h>
 .sp
 .BI "int mprotect(void *" addr ", size_t " len ", int " prot );
+.BI "int pkey_mprotect(void *" addr ", size_t " len ", int " prot ", int " pkey ");
 .fi
 .SH DESCRIPTION
 .BR mprotect ()
-changes protection for the calling process's memory page(s)
+and
+.BR pkey_mprotect ()
+change protection for the calling process's memory page(s)
 containing any part of the address range in the
 interval [\fIaddr\fP,\ \fIaddr\fP+\fIlen\fP\-1].
 .I addr
@@ -74,10 +77,19 @@ The memory can be modified.
 .TP
 .B PROT_EXEC
 The memory can be executed.
+.PP
+.I pkey
+is the protection key to assign to the memory.
+A pkey must be allocated with
+.BR pkey_alloc (2)
+before it is passed to
+.BR pkey_mprotect ().
 .SH RETURN VALUE
 On success,
 .BR mprotect ()
-returns zero.
+and
+.BR pkey_mprotect ()
+return zero.
 On error, \-1 is returned, and
 .I errno
 is set appropriately.
@@ -95,6 +107,8 @@ to mark it
 .B EINVAL
 \fIaddr\fP is not a valid pointer,
 or not a multiple of the system page size.
+Or: \fIpkey\fP has not been allocated with
+.BR pkey_alloc (2)
 .\" Or: both PROT_GROWSUP and PROT_GROWSDOWN were specified in 'prot'.
 .TP
 .B ENOMEM
@@ -165,6 +179,29 @@ but at a minimum can allow write access
 has been set, and must not allow any access if
 .B PROT_NONE
 has been set.
+
+Applications should be careful when mixing use of
+.BR mprotect ()
+and
+.BR pkey_mprotect () .
+On x86, when
+.BR mprotect ()
+is used with
+.IR prot
+set to
+.B PROT_EXEC
+a pkey is may be allocated and set on the memory implicitly
+by the kernel, but only when the pkey was 0 previously.
+
+On systems that do not support protection keys in hardware,
+.BR pkey_mprotect ()
+may still be used, but
+.IR pkey
+must be set to 0.
+When called this way, the operation of
+.BR pkey_mprotect ()
+is equivalent to
+.BR mprotect ().
 .SH EXAMPLE
 .\" sigaction.2 refers to this example
 .PP
@@ -246,3 +283,4 @@ main(int argc, char *argv[])
 .SH SEE ALSO
 .BR mmap (2),
 .BR sysconf (3)
+.BR pkey (7)
_
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
