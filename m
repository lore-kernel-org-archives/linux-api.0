From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 68/98] include/uapi/linux/netfilter/ipset/ip_set_hash.h: include linux/netfilter/ipset/ip_set.h
Date: Sat, 30 May 2015 17:39:00 +0200
Message-ID: <1433000370-19509-69-git-send-email-mikko.rapeli@iki.fi>
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

=46ixes userspace compilation error:

error: =E2=80=98IPSET_ERR_TYPE_SPECIFIC=E2=80=99 undeclared here (not i=
n a function)
  IPSET_ERR_HASH_FULL =3D IPSET_ERR_TYPE_SPECIFIC,

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/netfilter/ipset/ip_set_hash.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/netfilter/ipset/ip_set_hash.h b/include=
/uapi/linux/netfilter/ipset/ip_set_hash.h
index 352eecc..82deeb8 100644
--- a/include/uapi/linux/netfilter/ipset/ip_set_hash.h
+++ b/include/uapi/linux/netfilter/ipset/ip_set_hash.h
@@ -1,6 +1,8 @@
 #ifndef _UAPI__IP_SET_HASH_H
 #define _UAPI__IP_SET_HASH_H
=20
+#include <linux/netfilter/ipset/ip_set.h>
+
 /* Hash type specific error codes */
 enum {
 	/* Hash is full */
--=20
2.1.4
