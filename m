From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 09/98] via_drm.h: include linux/types.h instead of non-existing via_drmclient.h
Date: Sat, 30 May 2015 17:38:01 +0200
Message-ID: <1433000370-19509-10-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Fixes compiler error:

drm/via_drm.h:36:27: fatal error: via_drmclient.h: No such file or directory

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
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
