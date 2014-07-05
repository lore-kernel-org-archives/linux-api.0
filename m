From: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org>
Subject: [PATCH 1/1] include/uapi: Define AT_FDNODIR constant as future
 guarantee
Date: Sat, 05 Jul 2014 19:51:19 +0000 (GMT)
Message-ID: <fb469d6277ef.53b85737@langara.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-disposition: inline
Content-language: en
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org

This constant means that in the far future it might be possible to
define other AT_FD* constants.

Signed-off-by: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org>
---

This is my first kernel patch but this is really trivial so I hope I'm doing
this right.

diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index 074b886..92223f0 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -38,9 +38,15 @@
 #define DN_ATTRIB	0x00000020	/* File changed attibutes */
 #define DN_MULTISHOT	0x80000000	/* Don't remove notifier */
 
+#define AT_FDNODDIR		-1      /* Special value used to indicate
+					   openat should not use any directory.
+					   Currently, other values work for this
+					   but in the future that might
+					   change. */
 #define AT_FDCWD		-100    /* Special value used to indicate
-                                           openat should use the current
-                                           working directory. */
+					   openat should use the current
+					   working directory. */
+
 #define AT_SYMLINK_NOFOLLOW	0x100   /* Do not follow symbolic links.  */
 #define AT_REMOVEDIR		0x200   /* Remove directory instead of
                                            unlinking file.  */
