From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 46/79] include/uapi/linux/packet_diag.h: include linux/netdevice.h
Date: Thu, 15 Oct 2015 07:56:24 +0200
Message-ID: <1444888618-4506-47-git-send-email-mikko.rapeli@iki.fi>
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

=46ixes userspace compilation error:

error: =E2=80=98MAX_ADDR_LEN=E2=80=99 undeclared here (not in a functio=
n)

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/packet_diag.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/packet_diag.h b/include/uapi/linux/pack=
et_diag.h
index d08c63f..2a75e97 100644
--- a/include/uapi/linux/packet_diag.h
+++ b/include/uapi/linux/packet_diag.h
@@ -2,6 +2,7 @@
 #define __PACKET_DIAG_H__
=20
 #include <linux/types.h>
+#include <linux/netdevice.h>
=20
 struct packet_diag_req {
 	__u8	sdiag_family;
--=20
2.5.0
