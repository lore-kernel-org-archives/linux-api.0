From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/5] sigaction.2: describe siginfo changes from pkey-induced signals
Date: Tue, 13 Sep 2016 12:46:11 -0700
Message-ID: <20160913194611.8B5CB94C@ray>
References: <20160913194406.20CBFD0C@ray>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160913194406.20CBFD0C@ray>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Signed-off-by: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---

 b/man2/sigaction.2 |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN man2/sigaction.2~sigaction man2/sigaction.2
--- a/man2/sigaction.2~sigaction	2016-09-13 12:42:56.883959277 -0700
+++ b/man2/sigaction.2	2016-09-13 12:42:56.883959277 -0700
@@ -311,6 +311,8 @@ siginfo_t {
                               (since Linux 3.5) */
     unsigned int si_arch;  /* Architecture of attempted system call
                               (since Linux 3.5) */
+    unsigned int si_pkey;  /* Protection key set on si_addr
+                              (since Linux <FIXME>) */
 }
 .fi
 .in
@@ -597,6 +599,13 @@ Coprocessor error.
 .TP
 .B ILL_BADSTK
 Internal stack error.
+.TP
+.B SEGV_PKUERR
+Access was denied by memory protection keys.
+See:
+.BR pkeys (7).
+The protection key which applied to this access is available via
+.I si_pkey
 .RE
 .PP
 The following values can be placed in
_
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
