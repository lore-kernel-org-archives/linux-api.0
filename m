From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 11/45] via_drm.h: include linux/types.h instead of non-existing via_drmclient.h
Date: Tue, 17 Feb 2015 00:05:14 +0100
Message-ID: <1424127948-22484-12-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fixes compiler error:

drm/via_drm.h:36:27: fatal error: via_drmclient.h: No such file or directory

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/via_drm.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/uapi/drm/via_drm.h b/include/uapi/drm/via_drm.h
index 8b0533c..791531e 100644
--- a/include/uapi/drm/via_drm.h
+++ b/include/uapi/drm/via_drm.h
@@ -24,6 +24,7 @@
 #ifndef _VIA_DRM_H_
 #define _VIA_DRM_H_
 
+#include <linux/types.h>
 #include <drm/drm.h>
 
 /* WARNING: These defines must be the same as what the Xserver uses.
@@ -33,9 +34,6 @@
 #ifndef _VIA_DEFINES_
 #define _VIA_DEFINES_
 
-#ifndef __KERNEL__
-#include "via_drmclient.h"
-#endif
 
 #define VIA_NR_SAREA_CLIPRECTS		8
 #define VIA_NR_XVMC_PORTS               10
-- 
2.1.4
