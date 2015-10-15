From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH v4 11/79] savage_drm.h: include <drm/drm.h>
Date: Thu, 15 Oct 2015 07:55:49 +0200
Message-ID: <1444888618-4506-12-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mikko.rapeli-X3B1VOXEql0@public.gmane.org, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Fixes compiler error:

drm/savage_drm.h:50:24: error: array type has incomplete element type
  struct drm_tex_region texList[SAVAGE_NR_TEX_HEAPS][SAVAGE_NR_TEX_REGIONS +

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/drm/savage_drm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/drm/savage_drm.h b/include/uapi/drm/savage_drm.h
index 818d49b..9dc9dc1 100644
--- a/include/uapi/drm/savage_drm.h
+++ b/include/uapi/drm/savage_drm.h
@@ -26,6 +26,8 @@
 #ifndef __SAVAGE_DRM_H__
 #define __SAVAGE_DRM_H__
 
+#include <drm/drm.h>
+
 #ifndef __SAVAGE_SAREA_DEFINES__
 #define __SAVAGE_SAREA_DEFINES__
 
-- 
2.5.0
