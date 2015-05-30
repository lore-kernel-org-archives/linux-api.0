From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 74/98] include/uapi/linux/netfilter/xt_mac.h: include linux/if_ether.h
Date: Sat, 30 May 2015 17:39:06 +0200
Message-ID: <1433000370-19509-75-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation error:

error: =E2=80=98ETH_ALEN=E2=80=99 undeclared here (not in a function)
     unsigned char srcaddr[ETH_ALEN];

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/netfilter/xt_mac.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/netfilter/xt_mac.h b/include/uapi/linux=
/netfilter/xt_mac.h
index b892cdc..9a19a08 100644
--- a/include/uapi/linux/netfilter/xt_mac.h
+++ b/include/uapi/linux/netfilter/xt_mac.h
@@ -1,6 +1,8 @@
 #ifndef _XT_MAC_H
 #define _XT_MAC_H
=20
+#include <linux/if_ether.h>
+
 struct xt_mac_info {
     unsigned char srcaddr[ETH_ALEN];
     int invert;
--=20
2.1.4
