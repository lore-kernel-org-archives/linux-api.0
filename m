From: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Subject: [PATCH 4/6] pkey_get.2: New page desribing pkey rights manipulation syscalls
Date: Wed, 08 Jun 2016 10:35:56 -0700
Message-ID: <20160608173556.7C83620F@ray>
References: <20160608173351.5CF7B2D3@ray>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160608173351.5CF7B2D3@ray>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Signed-off-by: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---

 b/man2/pkey_get.2 |  109 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff -puN /dev/null man2/pkey_get.2
--- /dev/null	2016-03-09 16:12:12.816871985 -0800
+++ b/man2/pkey_get.2	2016-06-08 10:32:43.916409601 -0700
@@ -0,0 +1,109 @@
+.\" Copyright (C) 2016 Intel Corporation
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
+.TH PKEY_GET 2 2016-03-03 "Linux" "Linux Programmer's Manual"
+.SH NAME
+pkey_get, pkey_set \- manage protection key access permissions
+.SH SYNOPSIS
+.nf
+.B #include <sys/mman.h>
+.sp
+.BI "int pkey_get(int " pkey ", unsigned long " flags ");
+.BI "int pkey_set(int " pkey ", unsigned long " access_rights ", unsigned long " flags ");"
+.fi
+.SH DESCRIPTION
+.BR pkey_set ()
+sets the current set of rights for the calling
+thread for the protection key specified by
+.IR pkey .
+When rights for a key are disabled, any future access
+to any memory region with that key set will generate a
+.B SIGSEGV
+signal.
+Access rights are private to each thread.
+.PP
+.I access_rights
+may contain zero or more disable operations:
+.TP
+.B PKEY_DISABLE_ACCESS
+Disable all access to memory protected by the specified protection key.
+.TP
+.B PKEY_DISABLE_WRITE
+Disable write access to memory protected by the specified protection key.
+.SH RETURN VALUE
+On success,
+.BR pkey_set ()
+returns zero.
+.BR pkey_get ()
+returns a mask containing zero or more of the disable operations
+listed above.
+On error, \-1 is returned, and
+.I errno
+is set appropriately.
+.SH ERRORS
+.TP
+.B EINVAL
+.I pkey
+or
+.I access_rights
+is invalid.
+.SH NOTES
+When any signal handler is invoked, the thread is temporarily
+given a new, default set of protection key rights that override
+whatever rights were set in the interrupted context.
+The thread's protection key rights are restored when the signal
+handler returns.
+
+The effects of a call to
+.BR pkey_set ()
+from a signal handler will not persist when control passes out of
+the signal handler.
+This is true both when the handler returns to a normal,
+nonsignal context, and when the signal handler is interrupted
+by another signal handler.
+
+This signal behavior is unusual and is due to the fact that
+the x86 PKRU register (which stores \fIaccess_rights\fP)
+is managed with the same hardware mechanism (XSAVE) that
+manages
+floating-point registers.
+The signal behavior is the same as that of a floating point
+register.
+.SH VERSIONS
+.BR pkey_get ()
+and
+.BR pkey_set ()
+were added to Linux in kernel <FIXME>;
+library support was added to glibc in version <FIXME>.
+.SH CONFORMING TO
+The
+.BR pkey_get ()
+and
+.BR pkey_set ()
+system calls are Linux-specific.
+.SH SEE ALSO
+.BR pkey_alloc (2),
+.BR pkey_free (2),
+.BR pkey_mprotect (2),
+.BR pkey (7),
_
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
