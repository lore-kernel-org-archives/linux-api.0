From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 2/9] include/uapi/drm/virtgpu_drm.h: use __u{32,64} types instead of uint{32,64}_t
Date: Thu, 12 Nov 2015 19:14:04 +0100
Message-ID: <1447352051-22022-3-git-send-email-gabriel@lse.epita.fr>
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
 include/uapi/drm/virtgpu_drm.h | 99 +++++++++++++++++++++---------------------
 1 file changed, 50 insertions(+), 49 deletions(-)

diff --git a/include/uapi/drm/virtgpu_drm.h b/include/uapi/drm/virtgpu_drm.h
index fc9e2d6..60b11e7 100644
--- a/include/uapi/drm/virtgpu_drm.h
+++ b/include/uapi/drm/virtgpu_drm.h
@@ -25,12 +25,13 @@
 #define VIRTGPU_DRM_H
 
 #include <stddef.h>
+#include <linux/types.h>
 #include "drm/drm.h"
 
 /* Please note that modifications to all structs defined here are
  * subject to backwards-compatibility constraints.
  *
- * Do not use pointers, use uint64_t instead for 32 bit / 64 bit user/kernel
+ * Do not use pointers, use __u64 instead for 32 bit / 64 bit user/kernel
  * compatibility Keep fields aligned to their size
  */
 
@@ -45,88 +46,88 @@
 #define DRM_VIRTGPU_GET_CAPS  0x09
 
 struct drm_virtgpu_map {
-	uint64_t offset; /* use for mmap system call */
-	uint32_t handle;
-	uint32_t pad;
+	__u64 offset; /* use for mmap system call */
+	__u32 handle;
+	__u32 pad;
 };
 
 struct drm_virtgpu_execbuffer {
-	uint32_t		flags;		/* for future use */
-	uint32_t size;
-	uint64_t command; /* void* */
-	uint64_t bo_handles;
-	uint32_t num_bo_handles;
-	uint32_t pad;
+	__u32		flags;		/* for future use */
+	__u32 size;
+	__u64 command; /* void* */
+	__u64 bo_handles;
+	__u32 num_bo_handles;
+	__u32 pad;
 };
 
 #define VIRTGPU_PARAM_3D_FEATURES 1 /* do we have 3D features in the hw */
 
 struct drm_virtgpu_getparam {
-	uint64_t param;
-	uint64_t value;
+	__u64 param;
+	__u64 value;
 };
 
 /* NO_BO flags? NO resource flag? */
 /* resource flag for y_0_top */
 struct drm_virtgpu_resource_create {
-	uint32_t target;
-	uint32_t format;
-	uint32_t bind;
-	uint32_t width;
-	uint32_t height;
-	uint32_t depth;
-	uint32_t array_size;
-	uint32_t last_level;
-	uint32_t nr_samples;
-	uint32_t flags;
-	uint32_t bo_handle; /* if this is set - recreate a new resource attached to this bo ? */
-	uint32_t res_handle;  /* returned by kernel */
-	uint32_t size;        /* validate transfer in the host */
-	uint32_t stride;      /* validate transfer in the host */
+	__u32 target;
+	__u32 format;
+	__u32 bind;
+	__u32 width;
+	__u32 height;
+	__u32 depth;
+	__u32 array_size;
+	__u32 last_level;
+	__u32 nr_samples;
+	__u32 flags;
+	__u32 bo_handle; /* if this is set - recreate a new resource attached to this bo ? */
+	__u32 res_handle;  /* returned by kernel */
+	__u32 size;        /* validate transfer in the host */
+	__u32 stride;      /* validate transfer in the host */
 };
 
 struct drm_virtgpu_resource_info {
-	uint32_t bo_handle;
-	uint32_t res_handle;
-	uint32_t size;
-	uint32_t stride;
+	__u32 bo_handle;
+	__u32 res_handle;
+	__u32 size;
+	__u32 stride;
 };
 
 struct drm_virtgpu_3d_box {
-	uint32_t x;
-	uint32_t y;
-	uint32_t z;
-	uint32_t w;
-	uint32_t h;
-	uint32_t d;
+	__u32 x;
+	__u32 y;
+	__u32 z;
+	__u32 w;
+	__u32 h;
+	__u32 d;
 };
 
 struct drm_virtgpu_3d_transfer_to_host {
-	uint32_t bo_handle;
+	__u32 bo_handle;
 	struct drm_virtgpu_3d_box box;
-	uint32_t level;
-	uint32_t offset;
+	__u32 level;
+	__u32 offset;
 };
 
 struct drm_virtgpu_3d_transfer_from_host {
-	uint32_t bo_handle;
+	__u32 bo_handle;
 	struct drm_virtgpu_3d_box box;
-	uint32_t level;
-	uint32_t offset;
+	__u32 level;
+	__u32 offset;
 };
 
 #define VIRTGPU_WAIT_NOWAIT 1 /* like it */
 struct drm_virtgpu_3d_wait {
-	uint32_t handle; /* 0 is an invalid handle */
-	uint32_t flags;
+	__u32 handle; /* 0 is an invalid handle */
+	__u32 flags;
 };
 
 struct drm_virtgpu_get_caps {
-	uint32_t cap_set_id;
-	uint32_t cap_set_ver;
-	uint64_t addr;
-	uint32_t size;
-	uint32_t pad;
+	__u32 cap_set_id;
+	__u32 cap_set_ver;
+	__u64 addr;
+	__u32 size;
+	__u32 pad;
 };
 
 #define DRM_IOCTL_VIRTGPU_MAP \
-- 
2.6.2
