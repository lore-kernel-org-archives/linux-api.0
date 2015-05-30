From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 55/98] include/uapi/linux/ip6_tunnel.h: include linux/if.h and linux/in6.h
Date: Sat, 30 May 2015 17:38:47 +0200
Message-ID: <1433000370-19509-56-git-send-email-mikko.rapeli@iki.fi>
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

error: =E2=80=98IFNAMSIZ=E2=80=99 undeclared here (not in a function)
error: field =E2=80=98laddr=E2=80=99 has incomplete type
  struct in6_addr laddr; /* local tunnel end-point address */

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/ip6_tunnel.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/ip6_tunnel.h b/include/uapi/linux/ip6_t=
unnel.h
index 48af63c..21cfd62 100644
--- a/include/uapi/linux/ip6_tunnel.h
+++ b/include/uapi/linux/ip6_tunnel.h
@@ -2,6 +2,8 @@
 #define _IP6_TUNNEL_H
=20
 #include <linux/types.h>
+#include <linux/if.h>
+#include <linux/in6.h>
=20
 #define IPV6_TLV_TNL_ENCAP_LIMIT 4
 #define IPV6_DEFAULT_TNL_ENCAP_LIMIT 4
--=20
2.1.4
