From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 73/98] include/uapi/linux/netfilter/xt_ipvs.h: include linux/netfilter.h
Date: Sat, 30 May 2015 17:39:05 +0200
Message-ID: <1433000370-19509-74-git-send-email-mikko.rapeli@iki.fi>
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

error: field =E2=80=98vaddr=E2=80=99 has incomplete type
  union nf_inet_addr vaddr, vmask;
error: field =E2=80=98vmask=E2=80=99 has incomplete type
  union nf_inet_addr vaddr, vmask;

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/netfilter/xt_ipvs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netfilter/xt_ipvs.h b/include/uapi/linu=
x/netfilter/xt_ipvs.h
index eff34ac..e03b9c3 100644
--- a/include/uapi/linux/netfilter/xt_ipvs.h
+++ b/include/uapi/linux/netfilter/xt_ipvs.h
@@ -2,6 +2,7 @@
 #define _XT_IPVS_H
=20
 #include <linux/types.h>
+#include <linux/netfilter.h>
=20
 enum {
 	XT_IPVS_IPVS_PROPERTY =3D	1 << 0, /* all other options imply this one=
 */
--=20
2.1.4
