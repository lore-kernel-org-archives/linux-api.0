From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 72/98] include/uapi/linux/netfilter/xt_TPROXY.h: include linux/netfilter.h
Date: Sat, 30 May 2015 17:39:04 +0200
Message-ID: <1433000370-19509-73-git-send-email-mikko.rapeli@iki.fi>
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

error: field =E2=80=98laddr=E2=80=99 has incomplete type
  union nf_inet_addr laddr;

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/netfilter/xt_TPROXY.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netfilter/xt_TPROXY.h b/include/uapi/li=
nux/netfilter/xt_TPROXY.h
index 902043c..8d693ee 100644
--- a/include/uapi/linux/netfilter/xt_TPROXY.h
+++ b/include/uapi/linux/netfilter/xt_TPROXY.h
@@ -2,6 +2,7 @@
 #define _XT_TPROXY_H
=20
 #include <linux/types.h>
+#include <linux/netfilter.h>
=20
 /* TPROXY target is capable of marking the packet to perform
  * redirection. We can get rid of that whenever we get support for
--=20
2.1.4
