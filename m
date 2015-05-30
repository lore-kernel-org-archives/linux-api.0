From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 59/98] include/uapi/linux/netfilter: include linux/if.h in several headers
Date: Sat, 30 May 2015 17:38:51 +0200
Message-ID: <1433000370-19509-60-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Pablo Neira Ayuso <pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org>, Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>, Jozsef Kadlecsik <kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org>, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, coreteam-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compile errors:

error: =E2=80=98IFNAMSIZ=E2=80=99 undeclared here (not in a function)

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/netfilter/xt_RATEEST.h      | 1 +
 include/uapi/linux/netfilter/xt_hashlimit.h    | 1 +
 include/uapi/linux/netfilter/xt_physdev.h      | 2 +-
 include/uapi/linux/netfilter/xt_rateest.h      | 1 +
 include/uapi/linux/netfilter_arp/arp_tables.h  | 1 +
 include/uapi/linux/netfilter_ipv6/ip6_tables.h | 1 +
 6 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/xt_RATEEST.h b/include/uapi/l=
inux/netfilter/xt_RATEEST.h
index 6605e20..ec1b570 100644
--- a/include/uapi/linux/netfilter/xt_RATEEST.h
+++ b/include/uapi/linux/netfilter/xt_RATEEST.h
@@ -2,6 +2,7 @@
 #define _XT_RATEEST_TARGET_H
=20
 #include <linux/types.h>
+#include <linux/if.h>
=20
 struct xt_rateest_target_info {
 	char			name[IFNAMSIZ];
diff --git a/include/uapi/linux/netfilter/xt_hashlimit.h b/include/uapi=
/linux/netfilter/xt_hashlimit.h
index cbfc43d..6db90372 100644
--- a/include/uapi/linux/netfilter/xt_hashlimit.h
+++ b/include/uapi/linux/netfilter/xt_hashlimit.h
@@ -2,6 +2,7 @@
 #define _UAPI_XT_HASHLIMIT_H
=20
 #include <linux/types.h>
+#include <linux/if.h>
=20
 /* timings are in milliseconds. */
 #define XT_HASHLIMIT_SCALE 10000
diff --git a/include/uapi/linux/netfilter/xt_physdev.h b/include/uapi/l=
inux/netfilter/xt_physdev.h
index db7a298..ccdde87 100644
--- a/include/uapi/linux/netfilter/xt_physdev.h
+++ b/include/uapi/linux/netfilter/xt_physdev.h
@@ -2,7 +2,7 @@
 #define _UAPI_XT_PHYSDEV_H
=20
 #include <linux/types.h>
-
+#include <linux/if.h>
=20
 #define XT_PHYSDEV_OP_IN		0x01
 #define XT_PHYSDEV_OP_OUT		0x02
diff --git a/include/uapi/linux/netfilter/xt_rateest.h b/include/uapi/l=
inux/netfilter/xt_rateest.h
index d40a619..13fe50d 100644
--- a/include/uapi/linux/netfilter/xt_rateest.h
+++ b/include/uapi/linux/netfilter/xt_rateest.h
@@ -2,6 +2,7 @@
 #define _XT_RATEEST_MATCH_H
=20
 #include <linux/types.h>
+#include <linux/if.h>
=20
 enum xt_rateest_match_flags {
 	XT_RATEEST_MATCH_INVERT	=3D 1<<0,
diff --git a/include/uapi/linux/netfilter_arp/arp_tables.h b/include/ua=
pi/linux/netfilter_arp/arp_tables.h
index a5a86a4..ece3ad4 100644
--- a/include/uapi/linux/netfilter_arp/arp_tables.h
+++ b/include/uapi/linux/netfilter_arp/arp_tables.h
@@ -11,6 +11,7 @@
=20
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/if.h>
 #include <linux/netfilter_arp.h>
=20
 #include <linux/netfilter/x_tables.h>
diff --git a/include/uapi/linux/netfilter_ipv6/ip6_tables.h b/include/u=
api/linux/netfilter_ipv6/ip6_tables.h
index 649c680..d1b2265 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6_tables.h
@@ -17,6 +17,7 @@
=20
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/if.h>
 #include <linux/netfilter_ipv6.h>
=20
 #include <linux/netfilter/x_tables.h>
--=20
2.1.4
