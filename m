From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 40/98] include/uapi/linux/rds.h: include linux/socket.h and linux/types.h
Date: Sat, 30 May 2015 17:38:32 +0200
Message-ID: <1433000370-19509-41-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors like:

error: unknown type name =E2=80=98__be32=E2=80=99
error: field =E2=80=98dest_addr=E2=80=99 has incomplete type
   struct sockaddr_storage dest_addr;

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/rds.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
index 0f0da42..0b2ff1f 100644
--- a/include/uapi/linux/rds.h
+++ b/include/uapi/linux/rds.h
@@ -35,6 +35,7 @@
 #define _LINUX_RDS_H
=20
 #include <linux/types.h>
+#include <linux/socket.h>
=20
 #define RDS_IB_ABI_VERSION		0x301
=20
--=20
2.1.4
