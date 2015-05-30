From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 50/98] include/uapi/linux/packet_diag.h: include linux/netdevice.h
Date: Sat, 30 May 2015 17:38:42 +0200
Message-ID: <1433000370-19509-51-git-send-email-mikko.rapeli@iki.fi>
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

=46ixes userspace compilation error:

error: =E2=80=98MAX_ADDR_LEN=E2=80=99 undeclared here (not in a functio=
n)

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/packet_diag.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/packet_diag.h b/include/uapi/linux/pack=
et_diag.h
index d08c63f..2a75e97 100644
--- a/include/uapi/linux/packet_diag.h
+++ b/include/uapi/linux/packet_diag.h
@@ -2,6 +2,7 @@
 #define __PACKET_DIAG_H__
=20
 #include <linux/types.h>
+#include <linux/netdevice.h>
=20
 struct packet_diag_req {
 	__u8	sdiag_family;
--=20
2.1.4
