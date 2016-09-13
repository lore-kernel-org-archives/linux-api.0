From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/5] proc.5: describe new ProtectionKey smaps field
Date: Tue, 13 Sep 2016 12:46:42 -0700
Message-ID: <20160913194642.01BA814A@ray>
References: <20160913194406.20CBFD0C@ray>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160913194406.20CBFD0C@ray>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Signed-off-by: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---

 b/man5/proc.5 |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN man5/proc.5~proc man5/proc.5
--- a/man5/proc.5~proc	2016-09-13 12:42:57.123959275 -0700
+++ b/man5/proc.5	2016-09-13 12:42:57.127959275 -0700
@@ -1633,6 +1633,13 @@ The codes are the following:
     nh  - no-huge page advise flag
     mg  - mergeable advise flag
 
+"ProtectionKey" field contains the memory protection key (see
+.BR pkeys (5))
+associated with the virtual memory area.
+Only present if the kernel was built with the
+.B CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS
+configuration option. (since Linux 4.6)
+
 The
 .IR /proc/[pid]/smaps
 file is present only if the
_
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
