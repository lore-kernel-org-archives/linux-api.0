From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 49/79] include/uapi/linux/mroute.h: include linux/in.h
Date: Thu, 15 Oct 2015 07:56:27 +0200
Message-ID: <1444888618-4506-50-git-send-email-mikko.rapeli@iki.fi>
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

error: field =E2=80=98vifc_lcl_addr=E2=80=99 has incomplete type
 struct in_addr vifc_lcl_addr;     /* Local interface address */

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/mroute.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/mroute.h b/include/uapi/linux/mroute.h
index a382d2c..b1f9428 100644
--- a/include/uapi/linux/mroute.h
+++ b/include/uapi/linux/mroute.h
@@ -3,6 +3,7 @@
=20
 #include <linux/sockios.h>
 #include <linux/types.h>
+#include <linux/in.h>
=20
 /*
  *	Based on the MROUTING 3.5 defines primarily to keep
--=20
2.5.0
