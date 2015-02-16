From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 42/45] include/uapi/linux/rds.h: include linux/socket.h and linux/types.h always
Date: Tue, 17 Feb 2015 00:05:45 +0100
Message-ID: <1424127948-22484-43-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes compilation errors in userspace like:

error: unknown type name =E2=80=98__be32=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/rds.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
index 7ff0c70..47b1ede 100644
--- a/include/uapi/linux/rds.h
+++ b/include/uapi/linux/rds.h
@@ -34,9 +34,9 @@
 #ifndef _LINUX_RDS_H
 #define _LINUX_RDS_H
=20
-#ifdef __KERNEL__
 #include <linux/types.h>
-#else
+#include <linux/socket.h>
+#ifndef __KERNEL__
 #include <stdint.h>
 #endif
=20
--=20
2.1.4
