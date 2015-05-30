From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 46/98] include/uapi/linux/ipv6_route.h: include linux/in6.h
Date: Sat, 30 May 2015 17:38:38 +0200
Message-ID: <1433000370-19509-47-git-send-email-mikko.rapeli@iki.fi>
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

error: field =E2=80=98rtmsg_dst=E2=80=99 has incomplete type
  struct in6_addr  rtmsg_dst;

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/ipv6_route.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/ipv6_route.h b/include/uapi/linux/ipv6_=
route.h
index 2be7bd1..e300640 100644
--- a/include/uapi/linux/ipv6_route.h
+++ b/include/uapi/linux/ipv6_route.h
@@ -14,6 +14,7 @@
 #define _UAPI_LINUX_IPV6_ROUTE_H
=20
 #include <linux/types.h>
+#include <linux/in6.h>
=20
 #define RTF_DEFAULT	0x00010000	/* default - learned via ND	*/
 #define RTF_ALLONLINK	0x00020000	/* (deprecated and will be removed)
--=20
2.1.4
