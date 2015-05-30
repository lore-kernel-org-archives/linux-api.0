From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 20/98] hsi_char.h: use __u32 from linux/types.h
Date: Sat, 30 May 2015 17:38:12 +0200
Message-ID: <1433000370-19509-21-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compiler errors like:

linux/hsi/hsi_char.h:51:2: error: unknown type name =E2=80=98uint32_t=E2=
=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
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
2.1.4
