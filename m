From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 51/79] include/uapi/linux/ip6_tunnel.h: include linux/if.h and linux/in6.h
Date: Thu, 15 Oct 2015 07:56:29 +0200
Message-ID: <1444888618-4506-52-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compile errors like:

error: =E2=80=98IFNAMSIZ=E2=80=99 undeclared here (not in a function)
error: field =E2=80=98laddr=E2=80=99 has incomplete type
  struct in6_addr laddr; /* local tunnel end-point address */

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/ip6_tunnel.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/ip6_tunnel.h b/include/uapi/linux/ip6_t=
unnel.h
index 48af63c..21cfd62 100644
--- a/include/uapi/linux/ip6_tunnel.h
+++ b/include/uapi/linux/ip6_tunnel.h
@@ -2,6 +2,8 @@
 #define _IP6_TUNNEL_H
=20
 #include <linux/types.h>
+#include <linux/if.h>
+#include <linux/in6.h>
=20
 #define IPV6_TLV_TNL_ENCAP_LIMIT 4
 #define IPV6_DEFAULT_TNL_ENCAP_LIMIT 4
--=20
2.5.0
