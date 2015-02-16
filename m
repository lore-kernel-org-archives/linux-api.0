From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 05/45] drm.h: include stdlib.h in userspace
Date: Tue, 17 Feb 2015 00:05:08 +0100
Message-ID: <1424127948-22484-6-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes <drm/drm.h> compilation error:

drm/drm.h:132:2: error: unknown type name =E2=80=98size_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/drm.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/drm/drm.h b/include/uapi/drm/drm.h
index b0b8556..8f4488f 100644
--- a/include/uapi/drm/drm.h
+++ b/include/uapi/drm/drm.h
@@ -42,6 +42,10 @@
 #include <asm/ioctl.h>
 typedef unsigned int drm_handle_t;
=20
+#ifndef __KERNEL__
+#include <stdlib.h>
+#endif
+
 #else /* One of the BSDs */
=20
 #include <sys/ioccom.h>
--=20
2.1.4
