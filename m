From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 62/98] include/uapi/linux/netfilter_bridge/ebt_ip6.h: include linux/in6.h
Date: Sat, 30 May 2015 17:38:54 +0200
Message-ID: <1433000370-19509-63-git-send-email-mikko.rapeli@iki.fi>
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

=46ixes userspace compiler errors like

error: field =E2=80=98saddr=E2=80=99 has incomplete type
  struct in6_addr saddr;

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/netfilter_bridge/ebt_ip6.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netfilter_bridge/ebt_ip6.h b/include/ua=
pi/linux/netfilter_bridge/ebt_ip6.h
index 42b8896..a062f0c 100644
--- a/include/uapi/linux/netfilter_bridge/ebt_ip6.h
+++ b/include/uapi/linux/netfilter_bridge/ebt_ip6.h
@@ -13,6 +13,7 @@
 #define __LINUX_BRIDGE_EBT_IP6_H
=20
 #include <linux/types.h>
+#include <linux/in6.h>
=20
 #define EBT_IP6_SOURCE 0x01
 #define EBT_IP6_DEST 0x02
--=20
2.1.4
