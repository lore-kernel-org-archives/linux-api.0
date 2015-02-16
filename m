From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 43/45] include/uapi/linux/netfilter_bridge.h: include if.h
Date: Tue, 17 Feb 2015 00:05:46 +0100
Message-ID: <1424127948-22484-44-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors like:

error: field =E2=80=98in=E2=80=99 has incomplete type
struct in_addr in;

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/netfilter_bridge.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netfilter_bridge.h b/include/uapi/linux=
/netfilter_bridge.h
index a5eda6d..5bb0528 100644
--- a/include/uapi/linux/netfilter_bridge.h
+++ b/include/uapi/linux/netfilter_bridge.h
@@ -4,6 +4,7 @@
 /* bridge-specific defines for netfilter.=20
  */
=20
+#include <linux/if.h>
 #include <linux/netfilter.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
--=20
2.1.4
