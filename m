From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 64/98] include/uapi/linux/netfilter_bridge/ebt_arp.h: include linux/if_ether.h
Date: Sat, 30 May 2015 17:38:56 +0200
Message-ID: <1433000370-19509-65-git-send-email-mikko.rapeli@iki.fi>
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

=46ixes userspace compile error:

error: =E2=80=98ETH_ALEN=E2=80=99 undeclared here (not in a function)
 unsigned char smaddr[ETH_ALEN];

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/netfilter_bridge/ebt_arp.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netfilter_bridge/ebt_arp.h b/include/ua=
pi/linux/netfilter_bridge/ebt_arp.h
index 522f3e4..dd4df25 100644
--- a/include/uapi/linux/netfilter_bridge/ebt_arp.h
+++ b/include/uapi/linux/netfilter_bridge/ebt_arp.h
@@ -2,6 +2,7 @@
 #define __LINUX_BRIDGE_EBT_ARP_H
=20
 #include <linux/types.h>
+#include <linux/if_ether.h>
=20
 #define EBT_ARP_OPCODE 0x01
 #define EBT_ARP_HTYPE 0x02
--=20
2.1.4
