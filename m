From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 62/79] include/uapi/linux/btrfs.h: define NULL
Date: Thu, 15 Oct 2015 07:56:40 +0200
Message-ID: <1444888618-4506-63-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, Chris Mason <clm@fb.com>, Takeuchi Satoru <takeuchi_satoru@jp.fujitsu.com>, David Sterba <dsterba@suse.cz>, Eryu Guan <guaneryu@gmail.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Copied the NULL definition from include/linux/stddef.h which does not h=
ave
it in userspace.

=46ixes userspace compilation error:

error: =E2=80=98NULL=E2=80=99 undeclared (first use in this function)
    return NULL;

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
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
2.5.0
