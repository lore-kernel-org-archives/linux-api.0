From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] pkey.7: add description of signal handling behavior
Date: Mon, 17 Oct 2016 15:07:12 -0700
Message-ID: <20161017220712.389C9EE6@ray>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


From: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

The signal behavior of pkeys is special compared to many other
processor and OS features.  Add a special section to describe
the behavior.

This was previously a part of the pkey_get manpage, but that
page was removed from my submission when we removed the
syscall itself.  I've essentially moved the content from that
page to the main pkey.7 page.

Signed-off-by: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---

 b/man7/pkeys.7 |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN man7/pkeys.7~pkey-signal-behavior man7/pkeys.7
--- a/man7/pkeys.7~pkey-signal-behavior	2016-10-17 08:59:31.081217165 -0700
+++ b/man7/pkeys.7	2016-10-17 13:36:48.525030174 -0700
@@ -135,6 +135,22 @@ appropriate for child threads at the tim
 .BR clone (2)
 is called, or ensure that each child thread can perform its
 own initialization of protection key rights.
+
+.SS Signal Handler Behavior
+Each time a signal handler is invoked (including nested signals), the
+thread is temporarily given a new, default set of protection key rights
+that override the rights from the interrupted context.
+This means that applications must re-establish their desired protection
+key rights upon entering a signal handler if the desired rights differ
+from the defaults.
+The rights of any interrupted context are restored when the signal
+handler returns.
+
+This signal behavior is unusual and is due to the fact that the x86 PKRU
+register (which stores protection key access rights) is managed with the
+same hardware mechanism (XSAVE) that manages floating-point registers.
+The signal behavior is the same as that of floating point registers.
+
 .SS Protection Keys system calls
 The Linux kernel implements the following pkey-related system calls:
 .BR pkey_mprotect (2),
_
