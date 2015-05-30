From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 08/98] r128_drm.h: include drm/drm.h
Date: Sat, 30 May 2015 17:38:00 +0200
Message-ID: <1433000370-19509-9-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fixes compile error:

drm/r128_drm.h:156:23: error: array type has incomplete element type
  struct drm_clip_rect boxes[R128_NR_SAREA_CLIPRECTS];

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/r128_drm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/drm/r128_drm.h b/include/uapi/drm/r128_drm.h
index 8d8878b..76b0aa3 100644
--- a/include/uapi/drm/r128_drm.h
+++ b/include/uapi/drm/r128_drm.h
@@ -33,6 +33,8 @@
 #ifndef __R128_DRM_H__
 #define __R128_DRM_H__
 
+#include <drm/drm.h>
+
 /* WARNING: If you change any of these defines, make sure to change the
  * defines in the X server file (r128_sarea.h)
  */
-- 
2.1.4
