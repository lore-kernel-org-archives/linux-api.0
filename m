From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 10/79] via_drm.h: move struct via_file_private definition to drivers/gpu/drm/via/via_drv.h
Date: Thu, 15 Oct 2015 07:55:48 +0200
Message-ID: <1444888618-4506-11-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fixes userspace compile error since list_head is not exported to userspace
headers.

Suggested by Emil Velikov <emil.l.velikov@gmail.com> at
https://lkml.org/lkml/2015/6/3/792

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 drivers/gpu/drm/via/via_drv.h | 4 ++++
 include/uapi/drm/via_drm.h    | 4 ----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/via/via_drv.h b/drivers/gpu/drm/via/via_drv.h
index ef8c500..875e65a 100644
--- a/drivers/gpu/drm/via/via_drv.h
+++ b/drivers/gpu/drm/via/via_drv.h
@@ -102,6 +102,10 @@ typedef struct drm_via_private {
 	uint32_t dma_diff;
 } drm_via_private_t;
 
+struct via_file_private {
+	struct list_head obj_list;
+};
+
 enum via_family {
   VIA_OTHER = 0,     /* Baseline */
   VIA_PRO_GROUP_A,   /* Another video engine and DMA commands */
diff --git a/include/uapi/drm/via_drm.h b/include/uapi/drm/via_drm.h
index d19c0e2..c8c053a 100644
--- a/include/uapi/drm/via_drm.h
+++ b/include/uapi/drm/via_drm.h
@@ -271,8 +271,4 @@ typedef struct drm_via_dmablit {
 	drm_via_blitsync_t sync;
 } drm_via_dmablit_t;
 
-struct via_file_private {
-	struct list_head obj_list;
-};
-
 #endif				/* _VIA_DRM_H_ */
-- 
2.5.0
