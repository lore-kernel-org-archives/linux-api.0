From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 22/98] ebtables.h: use __u64 from linux/types.h
Date: Sat, 30 May 2015 17:38:14 +0200
Message-ID: <1433000370-19509-23-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Arturo Borrero Gonzalez <arturo.borrero.glez-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pablo Neira Ayuso <pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation error:

linux/netfilter_bridge/ebtables.h:38:2: error: unknown type name =E2=80=
=98uint64_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/netfilter_bridge/ebtables.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter_bridge/ebtables.h b/include/u=
api/linux/netfilter_bridge/ebtables.h
index 773dfe8..461145e 100644
--- a/include/uapi/linux/netfilter_bridge/ebtables.h
+++ b/include/uapi/linux/netfilter_bridge/ebtables.h
@@ -12,6 +12,8 @@
=20
 #ifndef _UAPI__LINUX_BRIDGE_EFF_H
 #define _UAPI__LINUX_BRIDGE_EFF_H
+#include <linux/types.h>
+#include <linux/if.h>
 #include <linux/netfilter_bridge.h>
=20
 #define EBT_TABLE_MAXNAMELEN 32
@@ -33,8 +35,8 @@ struct xt_match;
 struct xt_target;
=20
 struct ebt_counter {
-	uint64_t pcnt;
-	uint64_t bcnt;
+	__u64 pcnt;
+	__u64 bcnt;
 };
=20
 struct ebt_replace {
--=20
2.1.4
