From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 42/79] include/uapi/linux/ipv6_route.h: include linux/in6.h
Date: Thu, 15 Oct 2015 07:56:20 +0200
Message-ID: <1444888618-4506-43-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, "David S. Miller" <davem@davemloft.net>, Martin KaFai Lau <kafai@fb.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compile errors like:

error: field =E2=80=98rtmsg_dst=E2=80=99 has incomplete type
  struct in6_addr  rtmsg_dst;

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/ipv6_route.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/ipv6_route.h b/include/uapi/linux/ipv6_=
route.h
index f6598d1..25ab362 100644
--- a/include/uapi/linux/ipv6_route.h
+++ b/include/uapi/linux/ipv6_route.h
@@ -14,6 +14,7 @@
 #define _UAPI_LINUX_IPV6_ROUTE_H
=20
 #include <linux/types.h>
+#include <linux/in6.h>
=20
 #define RTF_DEFAULT	0x00010000	/* default - learned via ND	*/
 #define RTF_ALLONLINK	0x00020000	/* (deprecated and will be removed)
--=20
2.5.0
