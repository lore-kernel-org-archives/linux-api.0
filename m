From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 32/45] drm/i810_drm.h: include drm/drm.h
Date: Tue, 17 Feb 2015 00:05:35 +0100
Message-ID: <1424127948-22484-33-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fixes userspace compilation error:

error: array type has incomplete element type
struct drm_clip_rect boxes[I810_NR_SAREA_CLIPRECTS];

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
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
