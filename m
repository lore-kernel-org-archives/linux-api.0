From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 38/45] include/uapi/linux/agpgart.h: include stdlib.h in userspace
Date: Tue, 17 Feb 2015 00:05:41 +0100
Message-ID: <1424127948-22484-39-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, David Airlie <airlied@linux.ie>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compiler error:
error: unknown type name =E2=80=98size_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/agpgart.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/agpgart.h b/include/uapi/linux/agpgart.=
h
index 4e828cf..f525104 100644
--- a/include/uapi/linux/agpgart.h
+++ b/include/uapi/linux/agpgart.h
@@ -52,6 +52,7 @@
=20
 #ifndef __KERNEL__
 #include <linux/types.h>
+#include <stdlib.h>
=20
 struct agp_version {
 	__u16 major;
--=20
2.1.4
