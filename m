From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 70/98] include/uapi/linux/netfilter/xt_HMARK.h: include linux/netfilter.h
Date: Sat, 30 May 2015 17:39:02 +0200
Message-ID: <1433000370-19509-71-git-send-email-mikko.rapeli@iki.fi>
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

=46ixes userspace compilation errors:

error: field =E2=80=98src_mask=E2=80=99 has incomplete type
  union nf_inet_addr src_mask;
error: field =E2=80=98dst_mask=E2=80=99 has incomplete type
  union nf_inet_addr dst_mask;

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/netfilter/xt_HMARK.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netfilter/xt_HMARK.h b/include/uapi/lin=
ux/netfilter/xt_HMARK.h
index 826fc58..3fb48c8 100644
--- a/include/uapi/linux/netfilter/xt_HMARK.h
+++ b/include/uapi/linux/netfilter/xt_HMARK.h
@@ -2,6 +2,7 @@
 #define XT_HMARK_H_
=20
 #include <linux/types.h>
+#include <linux/netfilter.h>
=20
 enum {
 	XT_HMARK_SADDR_MASK,
--=20
2.1.4
