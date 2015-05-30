From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 58/98] include/uapi/linux/netfilter_ipv4/ip_tables.h: include linux/if.h
Date: Sat, 30 May 2015 17:38:50 +0200
Message-ID: <1433000370-19509-59-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation error:

error: =E2=80=98IFNAMSIZ=E2=80=99 undeclared here (not in a function)

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/netfilter_ipv4/ip_tables.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netfilter_ipv4/ip_tables.h b/include/ua=
pi/linux/netfilter_ipv4/ip_tables.h
index f1e6ef2..d0da53d 100644
--- a/include/uapi/linux/netfilter_ipv4/ip_tables.h
+++ b/include/uapi/linux/netfilter_ipv4/ip_tables.h
@@ -17,6 +17,7 @@
=20
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/if.h>
 #include <linux/netfilter_ipv4.h>
=20
 #include <linux/netfilter/x_tables.h>
--=20
2.1.4
