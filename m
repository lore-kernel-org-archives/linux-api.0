From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 16/45] hsi_char.h: include stdint.h in userspace
Date: Tue, 17 Feb 2015 00:05:19 +0100
Message-ID: <1424127948-22484-17-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Sebastian Reichel <sre@kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes compiler error:

linux/hsi/hsi_char.h:51:2: error: unknown type name =E2=80=98uint32_t=E2=
=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/hsi/hsi_char.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/hsi/hsi_char.h b/include/uapi/linux/hsi=
/hsi_char.h
index 76160b4..9fa8f91 100644
--- a/include/uapi/linux/hsi/hsi_char.h
+++ b/include/uapi/linux/hsi/hsi_char.h
@@ -20,10 +20,15 @@
  * 02110-1301 USA
  */
=20
-
 #ifndef __HSI_CHAR_H
 #define __HSI_CHAR_H
=20
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
+
 #define HSI_CHAR_MAGIC		'k'
 #define HSC_IOW(num, dtype)	_IOW(HSI_CHAR_MAGIC, num, dtype)
 #define HSC_IOR(num, dtype)	_IOR(HSI_CHAR_MAGIC, num, dtype)
--=20
2.1.4
