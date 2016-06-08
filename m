From: Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
Subject: [PATCH 3/6] pkey_alloc.2: New page describing protection key allocation and free
Date: Wed, 08 Jun 2016 10:35:25 -0700
Message-ID: <20160608173525.F3999733@ray>
References: <20160608173351.5CF7B2D3@ray>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160608173351.5CF7B2D3@ray>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Signed-off-by: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---

 b/man2/pkey_alloc.2 |  109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff -puN /dev/null man2/pkey_alloc.2
--- /dev/null	2016-03-09 16:12:12.816871985 -0800
+++ b/man2/pkey_alloc.2	2016-06-08 10:32:43.636409606 -0700
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
+.TH PKEY_ALLOC 2 2016-03-03 "Linux" "Linux Programmer's Manual"
+.SH NAME
+pkey_alloc, pkey_free \- allocate or free a protection key
+.SH SYNOPSIS
+.nf
+.B #include <sys/mman.h>
+.sp
+.BI "int pkey_alloc(unsigned long " flags ", unsigned long " access_rights ");"
+.BI "int pkey_free(int " pkey ");"
+.fi
+.SH DESCRIPTION
+.BR pkey_alloc ()
+allocates a protection key and allows it to be passed to
+the other interfaces that accept a protection key like
+.BR pkey_mprotect (),
+.BR pkey_set ()
+and
+.BR pkey_get ().
+.PP
+.BR pkey_free ()
+frees a protection key and makes it available for later
+allocations.
+After a protection key has been freed, it may no longer be used
+in any protection-key-related operations.
+An application should not call
+.BR pkey_free ()
+on any protection key which has been assigned to an address
+range by
+.BR pkey_mprotect ()
+and which is still in use.  The behavior in this case is
+undefined and may result in an error.
+.PP
+.RB ( pkey_alloc ())
+.I flags
+may contain zero or more disable operations:
+.TP
+.B PKEY_DISABLE_ACCESS
+Disable all data access to memory covered by the returned protection key.
+.TP
+.B PKEY_DISABLE_WRITE
+Disable write access to memory covered by the returned protection key.
+.SH RETURN VALUE
+On success,
+.BR pkey_alloc ()
+returns a positive protection key value.
+.BR pkey_free ()
+returns zero.
+On error, \-1 is returned, and
+.I errno
+is set appropriately.
+.SH ERRORS
+.TP
+.B EINVAL
+.IR pkey ,
+.IR flags ,
+or
+.I access_rights
+is invalid.
+.TP
+.B ENOSPC
+.(RB pkey_alloc ())
+All protection keys available for the current process have
+been allocated.
+The number of keys available is architecture-specific and
+implementation-specfic and may be reduced by kernel-internal use
+of certain keys.
+There are currently 15 keys available to user programs on x86.
+.SH VERSIONS
+.BR pkey_alloc ()
+and
+.BR pkey_free ()
+were added to Linux in kernel <FIXME>;
+library support was added to glibc in version <FIXME>.
+.SH CONFORMING TO
+The
+.BR pkey_alloc ()
+and
+.BR pkey_free ()
+system calls are Linux-specific.
+.SH
+.SH SEE ALSO
+.BR pkey_get (2),
+.BR pkey_mprotect (2),
+.BR pkey_set (2),
+.BR pkey (7)
_
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
