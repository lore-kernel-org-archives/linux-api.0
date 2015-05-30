From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 13/98] drm/i810_drm.h: include drm/drm.h
Date: Sat, 30 May 2015 17:38:05 +0200
Message-ID: <1433000370-19509-14-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Fixes userspace compilation error:

error: array type has incomplete element type
struct drm_clip_rect boxes[I810_NR_SAREA_CLIPRECTS];

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/drm/i810_drm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/drm/i810_drm.h b/include/uapi/drm/i810_drm.h
index 7a10bb6..34736ef 100644
--- a/include/uapi/drm/i810_drm.h
+++ b/include/uapi/drm/i810_drm.h
@@ -1,6 +1,8 @@
 #ifndef _I810_DRM_H_
 #define _I810_DRM_H_
 
+#include <drm/drm.h>
+
 /* WARNING: These defines must be the same as what the Xserver uses.
  * if you change them, you must change the defines in the Xserver.
  */
-- 
2.1.4
