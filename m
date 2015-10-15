From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 38/79] include/uapi/linux/rds.h: include linux/socket.h and linux/types.h
Date: Thu, 15 Oct 2015 07:56:16 +0200
Message-ID: <1444888618-4506-39-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, "David S. Miller" <davem@davemloft.net>, Sowmini Varadhan <sowmini.varadhan@oracle.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors like:

error: unknown type name =E2=80=98__be32=E2=80=99
error: field =E2=80=98dest_addr=E2=80=99 has incomplete type
   struct sockaddr_storage dest_addr;

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/rds.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
index 539f9f8..3bf329f 100644
--- a/include/uapi/linux/rds.h
+++ b/include/uapi/linux/rds.h
@@ -35,6 +35,7 @@
 #define _LINUX_RDS_H
=20
 #include <linux/types.h>
+#include <linux/socket.h>
=20
 #define RDS_IB_ABI_VERSION		0x301
=20
--=20
2.5.0
