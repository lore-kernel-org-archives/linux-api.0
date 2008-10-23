From: Daniel Gollub <dgollub-l3A5Bk7waGM@public.gmane.org>
Subject: [patch 2/3] [man-pages] Remove "bufsize is not positive" from readlink(2) error section
Date: Thu, 23 Oct 2008 16:50:57 +0200
Message-ID: <20081023150549.038994457@marvin.suse.de>
References: <20081023145054.998439866@marvin.suse.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=man-pages-readlink-2.diff
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ltp-list-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

The error statement "bufsize is not positive" is obsolete, if this proposed
syscall interface change get accepted.

Note: Kernel 2.6.27 and older shipped sys_readlink with a signed "bufsiz" 
argument. Man-page document the readlink syscall always as unsigend (size_t).

Signed-off-by: Daniel Gollub <dgollub-l3A5Bk7waGM@public.gmane.org>

---

 man2/readlink.2 |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/man2/readlink.2 b/man2/readlink.2
index b94db21..470c222 100644
--- a/man2/readlink.2
+++ b/man2/readlink.2
@@ -86,10 +86,6 @@ Search permission is denied for a component of the path prefix.
 extends outside the process's allocated address space.
 .TP
 .B EINVAL
-.I bufsiz
-is not positive.
-.TP
-.B EINVAL
 The named file is not a symbolic link.
 .TP
 .B EIO

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
