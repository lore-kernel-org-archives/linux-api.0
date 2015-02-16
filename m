From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 12/45] via_drm.h: hide struct via_file_private in userspace
Date: Tue, 17 Feb 2015 00:05:15 +0100
Message-ID: <1424127948-22484-13-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fixes compiler error since list_head is not exported to userspace headers.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/via_drm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/drm/via_drm.h b/include/uapi/drm/via_drm.h
index 791531e..34ce658 100644
--- a/include/uapi/drm/via_drm.h
+++ b/include/uapi/drm/via_drm.h
@@ -272,8 +272,10 @@ typedef struct drm_via_dmablit {
 	drm_via_blitsync_t sync;
 } drm_via_dmablit_t;
 
+#ifdef __KERNEL__
 struct via_file_private {
 	struct list_head obj_list;
 };
+#endif
 
 #endif				/* _VIA_DRM_H_ */
-- 
2.1.4
