From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 26/45] gntdev.h: include stdint.h in userspace
Date: Tue, 17 Feb 2015 00:05:29 +0100
Message-ID: <1424127948-22484-27-git-send-email-mikko.rapeli@iki.fi>
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

xen/gntdev.h:38:2: error: unknown type name =E2=80=98uint32_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/xen/gntdev.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/xen/gntdev.h b/include/uapi/xen/gntdev.h
index 5304bd3..f724f75 100644
--- a/include/uapi/xen/gntdev.h
+++ b/include/uapi/xen/gntdev.h
@@ -33,6 +33,12 @@
 #ifndef __LINUX_PUBLIC_GNTDEV_H__
 #define __LINUX_PUBLIC_GNTDEV_H__
=20
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
+
 struct ioctl_gntdev_grant_ref {
 	/* The domain ID of the grant to be mapped. */
 	uint32_t domid;
--=20
2.1.4
