From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 9/9] include/uapi/drm/omap_drm.h: use __u{32,64} types instead of uint{32,64}_t
Date: Thu, 12 Nov 2015 19:14:11 +0100
Message-ID: <1447352051-22022-10-git-send-email-gabriel@lse.epita.fr>
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
 include/uapi/drm/omap_drm.h | 39 ++++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/include/uapi/drm/omap_drm.h b/include/uapi/drm/omap_drm.h
index 1d0b117..926e42a 100644
--- a/include/uapi/drm/omap_drm.h
+++ b/include/uapi/drm/omap_drm.h
@@ -21,6 +21,7 @@
 #define __OMAP_DRM_H__
 
 #include <drm/drm.h>
+#include <linux/types.h>
 
 /* Please note that modifications to all structs defined here are
  * subject to backwards-compatibility constraints.
@@ -29,8 +30,8 @@
 #define OMAP_PARAM_CHIPSET_ID	1	/* ie. 0x3430, 0x4430, etc */
 
 struct drm_omap_param {
-	uint64_t param;			/* in */
-	uint64_t value;			/* in (set_param), out (get_param) */
+	__u64 param;			/* in */
+	__u64 value;			/* in (set_param), out (get_param) */
 };
 
 #define OMAP_BO_SCANOUT		0x00000001	/* scanout capable (phys contiguous) */
@@ -49,18 +50,18 @@ struct drm_omap_param {
 #define OMAP_BO_TILED		(OMAP_BO_TILED_8 | OMAP_BO_TILED_16 | OMAP_BO_TILED_32)
 
 union omap_gem_size {
-	uint32_t bytes;		/* (for non-tiled formats) */
+	__u32 bytes;		/* (for non-tiled formats) */
 	struct {
-		uint16_t width;
-		uint16_t height;
+		__u16 width;
+		__u16 height;
 	} tiled;		/* (for tiled formats) */
 };
 
 struct drm_omap_gem_new {
 	union omap_gem_size size;	/* in */
-	uint32_t flags;			/* in */
-	uint32_t handle;		/* out */
-	uint32_t __pad;
+	__u32 flags;			/* in */
+	__u32 handle;		/* out */
+	__u32 __pad;
 };
 
 /* mask of operations: */
@@ -70,33 +71,33 @@ enum omap_gem_op {
 };
 
 struct drm_omap_gem_cpu_prep {
-	uint32_t handle;		/* buffer handle (in) */
-	uint32_t op;			/* mask of omap_gem_op (in) */
+	__u32 handle;		/* buffer handle (in) */
+	__u32 op;			/* mask of omap_gem_op (in) */
 };
 
 struct drm_omap_gem_cpu_fini {
-	uint32_t handle;		/* buffer handle (in) */
-	uint32_t op;			/* mask of omap_gem_op (in) */
+	__u32 handle;		/* buffer handle (in) */
+	__u32 op;			/* mask of omap_gem_op (in) */
 	/* TODO maybe here we pass down info about what regions are touched
 	 * by sw so we can be clever about cache ops?  For now a placeholder,
 	 * set to zero and we just do full buffer flush..
 	 */
-	uint32_t nregions;
-	uint32_t __pad;
+	__u32 nregions;
+	__u32 __pad;
 };
 
 struct drm_omap_gem_info {
-	uint32_t handle;		/* buffer handle (in) */
-	uint32_t pad;
-	uint64_t offset;		/* mmap offset (out) */
+	__u32 handle;		/* buffer handle (in) */
+	__u32 pad;
+	__u64 offset;		/* mmap offset (out) */
 	/* note: in case of tiled buffers, the user virtual size can be
 	 * different from the physical size (ie. how many pages are needed
 	 * to back the object) which is returned in DRM_IOCTL_GEM_OPEN..
 	 * This size here is the one that should be used if you want to
 	 * mmap() the buffer:
 	 */
-	uint32_t size;			/* virtual size for mmap'ing (out) */
-	uint32_t __pad;
+	__u32 size;			/* virtual size for mmap'ing (out) */
+	__u32 __pad;
 };
 
 #define DRM_OMAP_GET_PARAM		0x00
-- 
2.6.2
