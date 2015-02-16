From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 25/45] gntalloc.h: include stdint.h in userspace
Date: Tue, 17 Feb 2015 00:05:28 +0100
Message-ID: <1424127948-22484-26-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes compilation error:

xen/gntalloc.h:22:2: error: unknown type name =E2=80=98uint16_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/xen/gntalloc.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/xen/gntalloc.h b/include/uapi/xen/gntalloc.h
index 76bd580..184df7e 100644
--- a/include/uapi/xen/gntalloc.h
+++ b/include/uapi/xen/gntalloc.h
@@ -11,6 +11,12 @@
 #ifndef __LINUX_PUBLIC_GNTALLOC_H__
 #define __LINUX_PUBLIC_GNTALLOC_H__
=20
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
+
 /*
  * Allocates a new page and creates a new grant reference.
  */
--=20
2.1.4
