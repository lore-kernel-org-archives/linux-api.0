From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 19/79] hsi_char.h: use __u32 from linux/types.h
Date: Thu, 15 Oct 2015 07:55:57 +0200
Message-ID: <1444888618-4506-20-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, Sebastian Reichel <sre@kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compiler errors like:

linux/hsi/hsi_char.h:51:2: error: unknown type name =E2=80=98uint32_t=E2=
=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/hsi/hsi_char.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/hsi/hsi_char.h b/include/uapi/linux/hsi=
/hsi_char.h
index 76160b4..c00a463 100644
--- a/include/uapi/linux/hsi/hsi_char.h
+++ b/include/uapi/linux/hsi/hsi_char.h
@@ -20,10 +20,11 @@
  * 02110-1301 USA
  */
=20
-
 #ifndef __HSI_CHAR_H
 #define __HSI_CHAR_H
=20
+#include <linux/types.h>
+
 #define HSI_CHAR_MAGIC		'k'
 #define HSC_IOW(num, dtype)	_IOW(HSI_CHAR_MAGIC, num, dtype)
 #define HSC_IOR(num, dtype)	_IOR(HSI_CHAR_MAGIC, num, dtype)
@@ -48,16 +49,16 @@
 #define HSC_ARB_PRIO		1
=20
 struct hsc_rx_config {
-	uint32_t mode;
-	uint32_t flow;
-	uint32_t channels;
+	__u32 mode;
+	__u32 flow;
+	__u32 channels;
 };
=20
 struct hsc_tx_config {
-	uint32_t mode;
-	uint32_t channels;
-	uint32_t speed;
-	uint32_t arb_mode;
+	__u32 mode;
+	__u32 channels;
+	__u32 speed;
+	__u32 arb_mode;
 };
=20
 #endif /* __HSI_CHAR_H */
--=20
2.5.0
