From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 17/45] ebtables.h: include stdint.h in userspace
Date: Tue, 17 Feb 2015 00:05:20 +0100
Message-ID: <1424127948-22484-18-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes compilation error:

linux/netfilter_bridge/ebtables.h:38:2: error: unknown type name =E2=80=
=98uint64_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/netfilter_bridge/ebtables.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/netfilter_bridge/ebtables.h b/include/u=
api/linux/netfilter_bridge/ebtables.h
index ba99336..9e8d6b4 100644
--- a/include/uapi/linux/netfilter_bridge/ebtables.h
+++ b/include/uapi/linux/netfilter_bridge/ebtables.h
@@ -12,6 +12,11 @@
=20
 #ifndef _UAPI__LINUX_BRIDGE_EFF_H
 #define _UAPI__LINUX_BRIDGE_EFF_H
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
 #include <linux/if.h>
 #include <linux/netfilter_bridge.h>
 #include <linux/if_ether.h>
--=20
2.1.4
