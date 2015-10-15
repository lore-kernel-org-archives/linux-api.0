From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH v4 56/79] include/uapi/linux/auto_fs.h: include linux/limits.h
Date: Thu, 15 Oct 2015 07:56:34 +0200
Message-ID: <1444888618-4506-57-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mikko.rapeli-X3B1VOXEql0@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation error:

error: =E2=80=98NAME_MAX=E2=80=99 undeclared here (not in a function)

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/auto_fs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/auto_fs.h b/include/uapi/linux/auto_fs.=
h
index bb991df..edffdd5 100644
--- a/include/uapi/linux/auto_fs.h
+++ b/include/uapi/linux/auto_fs.h
@@ -15,6 +15,7 @@
 #define _UAPI_LINUX_AUTO_FS_H
=20
 #include <linux/types.h>
+#include <linux/limits.h>
 #ifndef __KERNEL__
 #include <sys/ioctl.h>
 #endif /* __KERNEL__ */
--=20
2.5.0
