From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 53/98] include/uapi/linux/mroute.h: include linux/in.h
Date: Sat, 30 May 2015 17:38:45 +0200
Message-ID: <1433000370-19509-54-git-send-email-mikko.rapeli@iki.fi>
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

=46ixes userspace compile errors like:

error: field =E2=80=98vifc_lcl_addr=E2=80=99 has incomplete type
 struct in_addr vifc_lcl_addr;     /* Local interface address */

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/mroute.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/mroute.h b/include/uapi/linux/mroute.h
index a382d2c..b1f9428 100644
--- a/include/uapi/linux/mroute.h
+++ b/include/uapi/linux/mroute.h
@@ -3,6 +3,7 @@
=20
 #include <linux/sockios.h>
 #include <linux/types.h>
+#include <linux/in.h>
=20
 /*
  *	Based on the MROUTING 3.5 defines primarily to keep
--=20
2.1.4
