From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 41/79] include/uapi/linux/ipv6_route.h: include linux/in6.h
Date: Thu, 15 Oct 2015 07:56:19 +0200
Message-ID: <1444888618-4506-42-git-send-email-mikko.rapeli@iki.fi>
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

error: field =E2=80=98mf6cc_origin=E2=80=99 has incomplete type
  struct sockaddr_in6 mf6cc_origin;  /* Origin of mcast */

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/mroute6.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/mroute6.h b/include/uapi/linux/mroute6.=
h
index ce91215..5e17444 100644
--- a/include/uapi/linux/mroute6.h
+++ b/include/uapi/linux/mroute6.h
@@ -3,6 +3,7 @@
=20
 #include <linux/types.h>
 #include <linux/sockios.h>
+#include <linux/in6.h>
=20
 /*
  *	Based on the MROUTING 3.5 defines primarily to keep
--=20
2.5.0
