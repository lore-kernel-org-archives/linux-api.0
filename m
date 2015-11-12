From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 1/9] include/uapi/drm/armada_drm.h: use __u{32,64} types instead of uint{32,64}_t
Date: Thu, 12 Nov 2015 19:14:03 +0100
Message-ID: <1447352051-22022-2-git-send-email-gabriel@lse.epita.fr>
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
 include/uapi/drm/armada_drm.h | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/uapi/drm/armada_drm.h b/include/uapi/drm/armada_drm.h
index 8dec3fd..77184b7 100644
--- a/include/uapi/drm/armada_drm.h
+++ b/include/uapi/drm/armada_drm.h
@@ -9,6 +9,8 @@
 #ifndef DRM_ARMADA_IOCTL_H
 #define DRM_ARMADA_IOCTL_H
 
+#include <linux/types.h>
+
 #define DRM_ARMADA_GEM_CREATE		0x00
 #define DRM_ARMADA_GEM_MMAP		0x02
 #define DRM_ARMADA_GEM_PWRITE		0x03
@@ -17,27 +19,27 @@
 	DRM_##dir(DRM_COMMAND_BASE + DRM_ARMADA_##name, struct drm_armada_##str)
 
 struct drm_armada_gem_create {
-	uint32_t handle;
-	uint32_t size;
+	__u32 handle;
+	__u32 size;
 };
 #define DRM_IOCTL_ARMADA_GEM_CREATE \
 	ARMADA_IOCTL(IOWR, GEM_CREATE, gem_create)
 
 struct drm_armada_gem_mmap {
-	uint32_t handle;
-	uint32_t pad;
-	uint64_t offset;
-	uint64_t size;
-	uint64_t addr;
+	__u32 handle;
+	__u32 pad;
+	__u64 offset;
+	__u64 size;
+	__u64 addr;
 };
 #define DRM_IOCTL_ARMADA_GEM_MMAP \
 	ARMADA_IOCTL(IOWR, GEM_MMAP, gem_mmap)
 
 struct drm_armada_gem_pwrite {
-	uint64_t ptr;
-	uint32_t handle;
-	uint32_t offset;
-	uint32_t size;
+	__u64 ptr;
+	__u32 handle;
+	__u32 offset;
+	__u32 size;
 };
 #define DRM_IOCTL_ARMADA_GEM_PWRITE \
 	ARMADA_IOCTL(IOW, GEM_PWRITE, gem_pwrite)
-- 
2.6.2
