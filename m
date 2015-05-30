From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 60/98] include/uapi/linux/netfilter/xt_osf.h: include linux/ip.h and linux/tcp.h
Date: Sat, 30 May 2015 17:38:52 +0200
Message-ID: <1433000370-19509-61-git-send-email-mikko.rapeli@iki.fi>
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

error: =E2=80=98MAX_IPOPTLEN=E2=80=99 undeclared here (not in a functio=
n)
error: field =E2=80=98ip=E2=80=99 has incomplete type
error: field =E2=80=98tcp=E2=80=99 has incomplete type

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/netfilter/xt_osf.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/netfilter/xt_osf.h b/include/uapi/linux=
/netfilter/xt_osf.h
index 5d66cae..e615995 100644
--- a/include/uapi/linux/netfilter/xt_osf.h
+++ b/include/uapi/linux/netfilter/xt_osf.h
@@ -20,6 +20,8 @@
 #define _XT_OSF_H
=20
 #include <linux/types.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
=20
 #define MAXGENRELEN		32
=20
--=20
2.1.4
