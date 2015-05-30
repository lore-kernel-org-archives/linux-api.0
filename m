From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 45/98] include/uapi/linux/ipv6_route.h: include linux/in6.h
Date: Sat, 30 May 2015 17:38:37 +0200
Message-ID: <1433000370-19509-46-git-send-email-mikko.rapeli@iki.fi>
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

error: field =E2=80=98mf6cc_origin=E2=80=99 has incomplete type
  struct sockaddr_in6 mf6cc_origin;  /* Origin of mcast */

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/mroute6.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/mroute6.h b/include/uapi/linux/mroute6.=
h
index ce91215..5e17444 100644
--- a/include/uapi/linux/mroute6.h
+++ b/include/uapi/linux/mroute6.h
@@ -3,6 +3,7 @@
=20
 #include <linux/types.h>
 #include <linux/sockios.h>
+#include <linux/in6.h>
=20
 /*
  *	Based on the MROUTING 3.5 defines primarily to keep
--=20
2.1.4
