From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 66/98] include/uapi/linux/netfilter_bridge/ebt_nat.h: include linux/if_ether.h
Date: Sat, 30 May 2015 17:38:58 +0200
Message-ID: <1433000370-19509-67-git-send-email-mikko.rapeli@iki.fi>
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
 unsigned char mac[ETH_ALEN];

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/netfilter_bridge/ebt_nat.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/netfilter_bridge/ebt_nat.h b/include/ua=
pi/linux/netfilter_bridge/ebt_nat.h
index 5e74e3b..c990d74 100644
--- a/include/uapi/linux/netfilter_bridge/ebt_nat.h
+++ b/include/uapi/linux/netfilter_bridge/ebt_nat.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_BRIDGE_EBT_NAT_H
 #define __LINUX_BRIDGE_EBT_NAT_H
=20
+#include <linux/if_ether.h>
+
 #define NAT_ARP_BIT  (0x00000010)
 struct ebt_nat_info {
 	unsigned char mac[ETH_ALEN];
--=20
2.1.4
