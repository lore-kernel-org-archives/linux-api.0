From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 06/79] nouveau_drm.h: use __u32 and __u64 from linux/types.h
Date: Thu, 15 Oct 2015 07:55:44 +0200
Message-ID: <1444888618-4506-7-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors like:

drm/nouveau_drm.h:41:2: error: unknown type name =E2=80=98uint32_t=E2=80=
=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/nouveau_drm.h | 86 +++++++++++++++++++++-------------=
--------
 1 file changed, 44 insertions(+), 42 deletions(-)

diff --git a/include/uapi/drm/nouveau_drm.h b/include/uapi/drm/nouveau_=
drm.h
index 5507eea..3a0a2f1 100644
--- a/include/uapi/drm/nouveau_drm.h
+++ b/include/uapi/drm/nouveau_drm.h
@@ -35,6 +35,8 @@
 #define NOUVEAU_ABI16_DEVICE   0xdddddddd
 #define NOUVEAU_ABI16_CHAN(n) (0xcccc0000 | (n))
=20
+#include <drm/drm.h>
+
 #define NOUVEAU_GEM_DOMAIN_CPU       (1 << 0)
 #define NOUVEAU_GEM_DOMAIN_VRAM      (1 << 1)
 #define NOUVEAU_GEM_DOMAIN_GART      (1 << 2)
@@ -49,34 +51,34 @@
 #define NOUVEAU_GEM_TILE_NONCONTIG   0x00000008
=20
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
=20
 struct drm_nouveau_gem_new {
 	struct drm_nouveau_gem_info info;
-	uint32_t channel_hint;
-	uint32_t align;
+	__u32 channel_hint;
+	__u32 align;
 };
=20
 #define NOUVEAU_GEM_MAX_BUFFERS 1024
 struct drm_nouveau_gem_pushbuf_bo_presumed {
-	uint32_t valid;
-	uint32_t domain;
-	uint64_t offset;
+	__u32 valid;
+	__u32 domain;
+	__u64 offset;
 };
=20
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
=20
@@ -85,46 +87,46 @@ struct drm_nouveau_gem_pushbuf_bo {
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
=20
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
=20
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
=20
 #define NOUVEAU_GEM_CPU_PREP_NOWAIT                                  0=
x00000001
 #define NOUVEAU_GEM_CPU_PREP_WRITE                                   0=
x00000004
 struct drm_nouveau_gem_cpu_prep {
-	uint32_t handle;
-	uint32_t flags;
+	__u32 handle;
+	__u32 flags;
 };
=20
 struct drm_nouveau_gem_cpu_fini {
-	uint32_t handle;
+	__u32 handle;
 };
=20
 #define DRM_NOUVEAU_GETPARAM           0x00 /* deprecated */
--=20
2.5.0
