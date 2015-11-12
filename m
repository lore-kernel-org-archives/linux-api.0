From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 4/9] include/uapi/drm/nouveau_drm.h: use __u{32,64} types instead of uint{32,64}_t
Date: Thu, 12 Nov 2015 19:14:06 +0100
Message-ID: <1447352051-22022-5-git-send-email-gabriel@lse.epita.fr>
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
 include/uapi/drm/nouveau_drm.h | 84 +++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 42 deletions(-)

diff --git a/include/uapi/drm/nouveau_drm.h b/include/uapi/drm/nouveau_drm.h
index fd594cc..722b6a6 100644
--- a/include/uapi/drm/nouveau_drm.h
+++ b/include/uapi/drm/nouveau_drm.h
@@ -41,34 +41,34 @@
 #define NOUVEAU_GEM_TILE_NONCONTIG   0x00000008
 
 struct drm_nouveau_gem_info {
-	uint32_t handle;
-	uint32_t domain;
-	uint64_t size;
-	uint64_t offset;
-	uint64_t map_handle;
-	uint32_t tile_mode;
-	uint32_t tile_flags;
+	__u32 handle;
+	__u32 domain;
+	__u64 size;
+	__u64 offset;
+	__u64 map_handle;
+	__u32 tile_mode;
+	__u32 tile_flags;
 };
 
 struct drm_nouveau_gem_new {
 	struct drm_nouveau_gem_info info;
-	uint32_t channel_hint;
-	uint32_t align;
+	__u32 channel_hint;
+	__u32 align;
 };
 
 #define NOUVEAU_GEM_MAX_BUFFERS 1024
 struct drm_nouveau_gem_pushbuf_bo_presumed {
-	uint32_t valid;
-	uint32_t domain;
-	uint64_t offset;
+	__u32 valid;
+	__u32 domain;
+	__u64 offset;
 };
 
 struct drm_nouveau_gem_pushbuf_bo {
-	uint64_t user_priv;
-	uint32_t handle;
-	uint32_t read_domains;
-	uint32_t write_domains;
-	uint32_t valid_domains;
+	__u64 user_priv;
+	__u32 handle;
+	__u32 read_domains;
+	__u32 write_domains;
+	__u32 valid_domains;
 	struct drm_nouveau_gem_pushbuf_bo_presumed presumed;
 };
 
@@ -77,46 +77,46 @@ struct drm_nouveau_gem_pushbuf_bo {
 #define NOUVEAU_GEM_RELOC_OR   (1 << 2)
 #define NOUVEAU_GEM_MAX_RELOCS 1024
 struct drm_nouveau_gem_pushbuf_reloc {
-	uint32_t reloc_bo_index;
-	uint32_t reloc_bo_offset;
-	uint32_t bo_index;
-	uint32_t flags;
-	uint32_t data;
-	uint32_t vor;
-	uint32_t tor;
+	__u32 reloc_bo_index;
+	__u32 reloc_bo_offset;
+	__u32 bo_index;
+	__u32 flags;
+	__u32 data;
+	__u32 vor;
+	__u32 tor;
 };
 
 #define NOUVEAU_GEM_MAX_PUSH 512
 struct drm_nouveau_gem_pushbuf_push {
-	uint32_t bo_index;
-	uint32_t pad;
-	uint64_t offset;
-	uint64_t length;
+	__u32 bo_index;
+	__u32 pad;
+	__u64 offset;
+	__u64 length;
 };
 
 struct drm_nouveau_gem_pushbuf {
-	uint32_t channel;
-	uint32_t nr_buffers;
-	uint64_t buffers;
-	uint32_t nr_relocs;
-	uint32_t nr_push;
-	uint64_t relocs;
-	uint64_t push;
-	uint32_t suffix0;
-	uint32_t suffix1;
-	uint64_t vram_available;
-	uint64_t gart_available;
+	__u32 channel;
+	__u32 nr_buffers;
+	__u64 buffers;
+	__u32 nr_relocs;
+	__u32 nr_push;
+	__u64 relocs;
+	__u64 push;
+	__u32 suffix0;
+	__u32 suffix1;
+	__u64 vram_available;
+	__u64 gart_available;
 };
 
 #define NOUVEAU_GEM_CPU_PREP_NOWAIT                                  0x00000001
 #define NOUVEAU_GEM_CPU_PREP_WRITE                                   0x00000004
 struct drm_nouveau_gem_cpu_prep {
-	uint32_t handle;
-	uint32_t flags;
+	__u32 handle;
+	__u32 flags;
 };
 
 struct drm_nouveau_gem_cpu_fini {
-	uint32_t handle;
+	__u32 handle;
 };
 
 #define DRM_NOUVEAU_GETPARAM           0x00 /* deprecated */
-- 
2.6.2
