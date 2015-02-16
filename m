From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 18/45] cld.h: include stdint.h in userspace
Date: Tue, 17 Feb 2015 00:05:21 +0100
Message-ID: <1424127948-22484-19-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes compilation error:

linux/nfsd/cld.h:40:2: error: unknown type name =E2=80=98uint16_t=E2=80=
=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/nfsd/cld.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/nfsd/cld.h b/include/uapi/linux/nfsd/cl=
d.h
index f14a9ab..9f60f9c 100644
--- a/include/uapi/linux/nfsd/cld.h
+++ b/include/uapi/linux/nfsd/cld.h
@@ -22,6 +22,12 @@
 #ifndef _NFSD_CLD_H
 #define _NFSD_CLD_H
=20
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
+
 /* latest upcall version available */
 #define CLD_UPCALL_VERSION 1
=20
--=20
2.1.4
