From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 09/79] via_drm.h: don't include non-existing via_drmclient.h
Date: Thu, 15 Oct 2015 07:55:47 +0200
Message-ID: <1444888618-4506-10-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fixes compiler error:

drm/via_drm.h:36:27: fatal error: via_drmclient.h: No such file or directory

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/via_drm.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/uapi/drm/via_drm.h b/include/uapi/drm/via_drm.h
index 8b0533c..d19c0e2 100644
--- a/include/uapi/drm/via_drm.h
+++ b/include/uapi/drm/via_drm.h
@@ -33,9 +33,6 @@
 #ifndef _VIA_DEFINES_
 #define _VIA_DEFINES_
 
-#ifndef __KERNEL__
-#include "via_drmclient.h"
-#endif
 
 #define VIA_NR_SAREA_CLIPRECTS		8
 #define VIA_NR_XVMC_PORTS               10
-- 
2.5.0
