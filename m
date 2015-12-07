From: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Subject: Re: [PATCH 26/34] mm: implement new mprotect_key() system call
Date: Mon, 7 Dec 2015 08:44:23 -0800
Message-ID: <5665B767.8020802@sr71.net>
References: <20151204011424.8A36E365@viggo.jf.intel.com>
 <20151204011500.69487A6C@viggo.jf.intel.com> <5662894B.7090903@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070705030204010305060201"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5662894B.7090903-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is a multi-part message in MIME format.
--------------070705030204010305060201
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 12/04/2015 10:50 PM, Michael Kerrisk (man-pages) wrote:
> On 12/04/2015 02:15 AM, Dave Hansen wrote:
>> From: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>>
>> mprotect_key() is just like mprotect, except it also takes a
>> protection key as an argument.  On systems that do not support
>> protection keys, it still works, but requires that key=0.
>> Otherwise it does exactly what mprotect does.
> 
> Is there a man page for this API?

Yep.  Patch to man-pages source is attached.  I actually broke it up in
to a few separate pages.  I was planning on submitting these after the
patches themselves go upstream.

--------------070705030204010305060201
Content-Type: text/x-patch;
 name="pkeys.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pkeys.patch"

commit ebb12643876810931ed23992f92b7c77c2c36883
Author: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Mon Dec 7 08:42:57 2015 -0800

    pkeys

diff --git a/man2/mprotect.2 b/man2/mprotect.2
index ae305f6..a3c1e62 100644
--- a/man2/mprotect.2
+++ b/man2/mprotect.2
@@ -38,16 +38,19 @@
 .\"
 .TH MPROTECT 2 2015-07-23 "Linux" "Linux Programmer's Manual"
 .SH NAME
-mprotect \- set protection on a region of memory
+mprotect, mprotect_key \- set protection on a region of memory
 .SH SYNOPSIS
 .nf
 .B #include <sys/mman.h>
 .sp
 .BI "int mprotect(void *" addr ", size_t " len ", int " prot );
+.BI "int mprotect_key(void *" addr ", size_t " len ", int " prot , " int " key);
 .fi
 .SH DESCRIPTION
 .BR mprotect ()
-changes protection for the calling process's memory page(s)
+and
+.BR mprotect_key ()
+change protection for the calling process's memory page(s)
 containing any part of the address range in the
 interval [\fIaddr\fP,\ \fIaddr\fP+\fIlen\fP\-1].
 .I addr
@@ -74,10 +77,17 @@ The memory can be modified.
 .TP
 .B PROT_EXEC
 The memory can be executed.
+.PP
+.I key
+is the protection or storage key to assign to the memory.
+A key must be allocated with pkey_alloc () before it is
+passed to pkey_mprotect ().
 .SH RETURN VALUE
 On success,
 .BR mprotect ()
-returns zero.
+and
+.BR mprotect_key ()
+return zero.
 On error, \-1 is returned, and
 .I errno
 is set appropriately.
diff --git a/man2/pkey_alloc.2 b/man2/pkey_alloc.2
new file mode 100644
index 0000000..980ce3e
--- /dev/null
+++ b/man2/pkey_alloc.2
@@ -0,0 +1,72 @@
+.\" Copyright (C) 2007 Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+.\" and Copyright (C) 1995 Michael Shields <shields-QLfR772JJfgdnm+yROfE0A@public.gmane.org>.
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
+.\" the source, must acknowledge the copyright and author of this work.
+.\" %%%LICENSE_END
+.\"
+.\" Modified 2015-12-04 by Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
+.\"
+.\"
+.TH PKEY_ALLOC 2 2015-12-04 "Linux" "Linux Programmer's Manual"
+.SH NAME
+pkey_alloc, pkey_free \- allocate or free a protection key
+.SH SYNOPSIS
+.nf
+.B #include <sys/mman.h>
+.sp
+.BI "int pkey_alloc(unsigned long" flags ", unsigned long " init_val);
+.BI "int pkey_free(int " pkey);
+.fi
+.SH DESCRIPTION
+.BR pkey_alloc ()
+and
+.BR pkey_free ()
+allow or disallow the calling process's to use the given
+protection key for all protection-key-related operations.
+
+.PP
+.I flags
+is may contain zero or more disable operation:
+.B PKEY_DISABLE_ACCESS
+and/or
+.B PKEY_DISABLE_WRITE
+.SH RETURN VALUE
+On success,
+.BR pkey_alloc ()
+and
+.BR pkey_free ()
+return zero.
+On error, \-1 is returned, and
+.I errno
+is set appropriately.
+.SH ERRORS
+.TP
+.B EINVAL
+An invalid protection key, flag, or init_val was specified.
+.TP
+.B ENOSPC
+All protection keys available for the current process have
+been allocated.
+.SH SEE ALSO
+.BR mprotect_pkey (2),
+.BR pkey_get (2),
+.BR pkey_set (2),
diff --git a/man2/pkey_get.2 b/man2/pkey_get.2
new file mode 100644
index 0000000..4cfdea9
--- /dev/null
+++ b/man2/pkey_get.2
@@ -0,0 +1,76 @@
+.\" Copyright (C) 2007 Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+.\" and Copyright (C) 1995 Michael Shields <shields-QLfR772JJfgdnm+yROfE0A@public.gmane.org>.
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
+.\" the source, must acknowledge the copyright and author of this work.
+.\" %%%LICENSE_END
+.\"
+.\" Modified 2015-12-04 by Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
+.\"
+.\"
+.TH PKEY_GET 2 2015-12-04 "Linux" "Linux Programmer's Manual"
+.SH NAME
+pkey_get, pkey_set \- manage protection key access permissions
+.SH SYNOPSIS
+.nf
+.B #include <sys/mman.h>
+.sp
+.BI "int pkey_get(int " pkey);
+.BI "int pkey_set(int " pkey ", unsigned long " access_rights);
+.fi
+.SH DESCRIPTION
+.BR pkey_get ()
+and
+.BR pkey_set ()
+query or set the current set of rights for the calling
+task for the given protection key.
+When rights for a key are disabled, any future access
+to any memory region with that key set will generate
+a SIGSEGV.  The rights are local to the calling thread and
+do not affect any other threads.
+.PP
+Upon entering any signal handler, the process is given a
+default set of protection key rights which are separate from
+the main thread's.  Any calls to pkey_set () in a signal
+will not persist upon a return to the calling process.
+.PP
+.I access_rights
+is may contain zero or more disable operation:
+.B PKEY_DISABLE_ACCESS
+and/or
+.B PKEY_DISABLE_WRITE
+.SH RETURN VALUE
+On success,
+.BR pkey_get ()
+and
+.BR pkey_set ()
+return zero.
+On error, \-1 is returned, and
+.I errno
+is set appropriately.
+.SH ERRORS
+.TP
+.B EINVAL
+An invalid protection key or access_rights was specified.
+.SH SEE ALSO
+.BR mprotect_pkey (2),
+.BR pkey_alloc (2),
+.BR pkey_free (2),

--------------070705030204010305060201--
