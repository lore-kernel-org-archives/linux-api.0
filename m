From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 86/98] include/uapi/linux/btrfs.h: define NULL
Date: Sat, 30 May 2015 17:39:18 +0200
Message-ID: <1433000370-19509-87-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org>, Anand Jain <Anand.Jain-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Takeuchi Satoru <takeuchi_satoru-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Eryu Guan <guaneryu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Gerhard Heift <gerhard-CKiHmMNdoX1BDLzU/O5InQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Copied the NULL definition from include/linux/stddef.h which does not h=
ave
it in userspace.

=46ixes userspace compilation error:

error: =E2=80=98NULL=E2=80=99 undeclared (first use in this function)
    return NULL;

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/btrfs.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index b6dec05..a8ae69b 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -20,6 +20,12 @@
 #define _UAPI_LINUX_BTRFS_H
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/stddef.h>
+
+/* for userspace where linux/stddef.h doesn't define this */
+#ifndef NULL
+#define NULL ((void *)0)
+#endif
=20
 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
--=20
2.1.4
