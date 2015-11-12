From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 7/9] include/uapi/drm/drm_mode.h: use __u{32,64} types instead of uint{32,64}_t
Date: Thu, 12 Nov 2015 19:14:09 +0100
Message-ID: <1447352051-22022-8-git-send-email-gabriel@lse.epita.fr>
References: <1447352051-22022-1-git-send-email-gabriel@lse.epita.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447352051-22022-1-git-send-email-gabriel@lse.epita.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: DRI devel <dri-devel@lists.freedesktop.org>
Cc: Gabriel Laskar <gabriel@lse.epita.fr>, David Airlie <airlied@linux.ie>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Kernel headers should use linux/types.h

Signed-off-by: Gabriel Laskar <gabriel@lse.epita.fr>
---
 include/uapi/drm/drm_mode.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.h
index 6c11ca4..44ad794 100644
--- a/include/uapi/drm/drm_mode.h
+++ b/include/uapi/drm/drm_mode.h
@@ -526,14 +526,14 @@ struct drm_mode_crtc_page_flip {
 
 /* create a dumb scanout buffer */
 struct drm_mode_create_dumb {
-	uint32_t height;
-	uint32_t width;
-	uint32_t bpp;
-	uint32_t flags;
+	__u32 height;
+	__u32 width;
+	__u32 bpp;
+	__u32 flags;
 	/* handle, pitch, size will be returned */
-	uint32_t handle;
-	uint32_t pitch;
-	uint64_t size;
+	__u32 handle;
+	__u32 pitch;
+	__u64 size;
 };
 
 /* set up for mmap of a dumb scanout buffer */
@@ -550,7 +550,7 @@ struct drm_mode_map_dumb {
 };
 
 struct drm_mode_destroy_dumb {
-	uint32_t handle;
+	__u32 handle;
 };
 
 /* page-flip flags are valid, plus: */
-- 
2.6.2
