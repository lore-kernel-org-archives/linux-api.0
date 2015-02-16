From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 13/45] savage_drm.h: include <drm/drm.h>
Date: Tue, 17 Feb 2015 00:05:16 +0100
Message-ID: <1424127948-22484-14-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fixes compiler error:

drm/savage_drm.h:50:24: error: array type has incomplete element type
  struct drm_tex_region texList[SAVAGE_NR_TEX_HEAPS][SAVAGE_NR_TEX_REGIONS +

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
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
2.1.4
