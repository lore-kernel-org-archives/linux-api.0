From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 05/98] exynos_drm.h: use __u64 from linux/types.h
Date: Sat, 30 May 2015 17:37:57 +0200
Message-ID: <1433000370-19509-6-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Inki Dae <inki.dae-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Joonyoung Shim <jy0922.shim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Seung-Woo Kim <sw0312.kim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation error:

drm/exynos_drm.h:30:2: error: unknown type name =E2=80=98uint64_t=E2=80=
=99

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/drm/exynos_drm.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/uapi/drm/exynos_drm.h b/include/uapi/drm/exynos_dr=
m.h
index 5575ed1..c4468f9 100644
--- a/include/uapi/drm/exynos_drm.h
+++ b/include/uapi/drm/exynos_drm.h
@@ -15,6 +15,7 @@
 #ifndef _UAPI_EXYNOS_DRM_H_
 #define _UAPI_EXYNOS_DRM_H_
=20
+#include <linux/types.h>
 #include <drm/drm.h>
=20
 /**
@@ -27,7 +28,7 @@
  *	- this handle will be set by gem module of kernel side.
  */
 struct drm_exynos_gem_create {
-	uint64_t size;
+	__u64 size;
 	unsigned int flags;
 	unsigned int handle;
 };
@@ -44,7 +45,7 @@ struct drm_exynos_gem_create {
 struct drm_exynos_gem_info {
 	unsigned int handle;
 	unsigned int flags;
-	uint64_t size;
+	__u64 size;
 };
=20
 /**
@@ -58,7 +59,7 @@ struct drm_exynos_gem_info {
 struct drm_exynos_vidi_connection {
 	unsigned int connection;
 	unsigned int extensions;
-	uint64_t edid;
+	__u64 edid;
 };
=20
 /* memory type definitions. */
--=20
2.1.4
