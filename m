From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 07/45] exynos_drm.h: include stdint.h in userspace
Date: Tue, 17 Feb 2015 00:05:10 +0100
Message-ID: <1424127948-22484-8-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Inki Dae <inki.dae@samsung.com>, Joonyoung Shim <jy0922.shim@samsung.com>, Seung-Woo Kim <sw0312.kim@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>, David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes compilation errors like:

drm/exynos_drm.h:30:2: error: unknown type name =E2=80=98uint64_t=E2=80=
=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/exynos_drm.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/drm/exynos_drm.h b/include/uapi/drm/exynos_dr=
m.h
index 5575ed1..03d094d 100644
--- a/include/uapi/drm/exynos_drm.h
+++ b/include/uapi/drm/exynos_drm.h
@@ -15,6 +15,11 @@
 #ifndef _UAPI_EXYNOS_DRM_H_
 #define _UAPI_EXYNOS_DRM_H_
=20
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
 #include <drm/drm.h>
=20
 /**
--=20
2.1.4
