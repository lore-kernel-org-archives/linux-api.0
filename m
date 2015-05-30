From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 85/98] include/uapi/linux/scc.h: include linux/sockios.h
Date: Sat, 30 May 2015 17:39:17 +0200
Message-ID: <1433000370-19509-86-git-send-email-mikko.rapeli@iki.fi>
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

error: =E2=80=98SIOCDEVPRIVATE=E2=80=99 undeclared here (not in a funct=
ion)
  SIOCSCCRESERVED =3D SIOCDEVPRIVATE

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/scc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/scc.h b/include/uapi/linux/scc.h
index 72b6b81..2992b88 100644
--- a/include/uapi/linux/scc.h
+++ b/include/uapi/linux/scc.h
@@ -3,6 +3,7 @@
 #ifndef _UAPI_SCC_H
 #define _UAPI_SCC_H
=20
+#include <linux/sockios.h>
=20
 /* selection of hardware types */
=20
--=20
2.1.4
