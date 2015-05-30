From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 10/98] via_drm.h: hide struct via_file_private in userspace
Date: Sat, 30 May 2015 17:38:02 +0200
Message-ID: <1433000370-19509-11-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Fixes compiler error since list_head is not exported to userspace headers.

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
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
