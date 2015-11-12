From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 6/9] include/uapi/drm/armada_drm.h: use __u{32,64} types instead of uint{32,64}_t
Date: Thu, 12 Nov 2015 19:14:08 +0100
Message-ID: <1447352051-22022-7-git-send-email-gabriel@lse.epita.fr>
References: <1447352051-22022-1-git-send-email-gabriel@lse.epita.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447352051-22022-1-git-send-email-gabriel@lse.epita.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: DRI devel <dri-devel@lists.freedesktop.org>
Cc: Gabriel Laskar <gabriel@lse.epita.fr>, Alex Deucher <alexander.deucher@amd.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, David Airlie <airlied@linux.ie>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Kernel headers should use linux/types.h

Signed-off-by: Gabriel Laskar <gabriel@lse.epita.fr>
---
 include/uapi/drm/radeon_drm.h | 130 +++++++++++++++++++++---------------------
 1 file changed, 66 insertions(+), 64 deletions(-)

diff --git a/include/uapi/drm/radeon_drm.h b/include/uapi/drm/radeon_drm.h
index 01aa2a8..84a32ce 100644
--- a/include/uapi/drm/radeon_drm.h
+++ b/include/uapi/drm/radeon_drm.h
@@ -35,6 +35,8 @@
 
 #include "drm.h"
 
+#include <linux/types.h>
+
 /* WARNING: If you change any of these defines, make sure to change the
  * defines in the X server file (radeon_sarea.h)
  */
@@ -793,9 +795,9 @@ typedef struct drm_radeon_surface_free {
 #define RADEON_GEM_DOMAIN_VRAM		0x4
 
 struct drm_radeon_gem_info {
-	uint64_t	gart_size;
-	uint64_t	vram_size;
-	uint64_t	vram_visible;
+	__u64	gart_size;
+	__u64	vram_size;
+	__u64	vram_visible;
 };
 
 #define RADEON_GEM_NO_BACKING_STORE	(1 << 0)
@@ -807,11 +809,11 @@ struct drm_radeon_gem_info {
 #define RADEON_GEM_NO_CPU_ACCESS	(1 << 4)
 
 struct drm_radeon_gem_create {
-	uint64_t	size;
-	uint64_t	alignment;
-	uint32_t	handle;
-	uint32_t	initial_domain;
-	uint32_t	flags;
+	__u64	size;
+	__u64	alignment;
+	__u32	handle;
+	__u32	initial_domain;
+	__u32	flags;
 };
 
 /*
@@ -825,10 +827,10 @@ struct drm_radeon_gem_create {
 #define RADEON_GEM_USERPTR_REGISTER	(1 << 3)
 
 struct drm_radeon_gem_userptr {
-	uint64_t		addr;
-	uint64_t		size;
-	uint32_t		flags;
-	uint32_t		handle;
+	__u64		addr;
+	__u64		size;
+	__u32		flags;
+	__u32		handle;
 };
 
 #define RADEON_TILING_MACRO				0x1
@@ -850,72 +852,72 @@ struct drm_radeon_gem_userptr {
 #define RADEON_TILING_EG_STENCIL_TILE_SPLIT_MASK	0xf
 
 struct drm_radeon_gem_set_tiling {
-	uint32_t	handle;
-	uint32_t	tiling_flags;
-	uint32_t	pitch;
+	__u32	handle;
+	__u32	tiling_flags;
+	__u32	pitch;
 };
 
 struct drm_radeon_gem_get_tiling {
-	uint32_t	handle;
-	uint32_t	tiling_flags;
-	uint32_t	pitch;
+	__u32	handle;
+	__u32	tiling_flags;
+	__u32	pitch;
 };
 
 struct drm_radeon_gem_mmap {
-	uint32_t	handle;
-	uint32_t	pad;
-	uint64_t	offset;
-	uint64_t	size;
-	uint64_t	addr_ptr;
+	__u32	handle;
+	__u32	pad;
+	__u64	offset;
+	__u64	size;
+	__u64	addr_ptr;
 };
 
 struct drm_radeon_gem_set_domain {
-	uint32_t	handle;
-	uint32_t	read_domains;
-	uint32_t	write_domain;
+	__u32	handle;
+	__u32	read_domains;
+	__u32	write_domain;
 };
 
 struct drm_radeon_gem_wait_idle {
-	uint32_t	handle;
-	uint32_t	pad;
+	__u32	handle;
+	__u32	pad;
 };
 
 struct drm_radeon_gem_busy {
-	uint32_t	handle;
-	uint32_t        domain;
+	__u32	handle;
+	__u32        domain;
 };
 
 struct drm_radeon_gem_pread {
 	/** Handle for the object being read. */
-	uint32_t handle;
-	uint32_t pad;
+	__u32 handle;
+	__u32 pad;
 	/** Offset into the object to read from */
-	uint64_t offset;
+	__u64 offset;
 	/** Length of data to read */
-	uint64_t size;
+	__u64 size;
 	/** Pointer to write the data into. */
 	/* void *, but pointers are not 32/64 compatible */
-	uint64_t data_ptr;
+	__u64 data_ptr;
 };
 
 struct drm_radeon_gem_pwrite {
 	/** Handle for the object being written to. */
-	uint32_t handle;
-	uint32_t pad;
+	__u32 handle;
+	__u32 pad;
 	/** Offset into the object to write to */
-	uint64_t offset;
+	__u64 offset;
 	/** Length of data to write */
-	uint64_t size;
+	__u64 size;
 	/** Pointer to read the data from. */
 	/* void *, but pointers are not 32/64 compatible */
-	uint64_t data_ptr;
+	__u64 data_ptr;
 };
 
 /* Sets or returns a value associated with a buffer. */
 struct drm_radeon_gem_op {
-	uint32_t	handle; /* buffer */
-	uint32_t	op;     /* RADEON_GEM_OP_* */
-	uint64_t	value;  /* input or return value */
+	__u32	handle; /* buffer */
+	__u32	op;     /* RADEON_GEM_OP_* */
+	__u64	value;  /* input or return value */
 };
 
 #define RADEON_GEM_OP_GET_INITIAL_DOMAIN	0
@@ -935,11 +937,11 @@ struct drm_radeon_gem_op {
 #define RADEON_VM_PAGE_SNOOPED		(1 << 4)
 
 struct drm_radeon_gem_va {
-	uint32_t		handle;
-	uint32_t		operation;
-	uint32_t		vm_id;
-	uint32_t		flags;
-	uint64_t		offset;
+	__u32		handle;
+	__u32		operation;
+	__u32		vm_id;
+	__u32		flags;
+	__u64		offset;
 };
 
 #define RADEON_CHUNK_ID_RELOCS	0x01
@@ -961,29 +963,29 @@ struct drm_radeon_gem_va {
 /* 0 = normal, + = higher priority, - = lower priority */
 
 struct drm_radeon_cs_chunk {
-	uint32_t		chunk_id;
-	uint32_t		length_dw;
-	uint64_t		chunk_data;
+	__u32		chunk_id;
+	__u32		length_dw;
+	__u64		chunk_data;
 };
 
 /* drm_radeon_cs_reloc.flags */
 #define RADEON_RELOC_PRIO_MASK		(0xf << 0)
 
 struct drm_radeon_cs_reloc {
-	uint32_t		handle;
-	uint32_t		read_domains;
-	uint32_t		write_domain;
-	uint32_t		flags;
+	__u32		handle;
+	__u32		read_domains;
+	__u32		write_domain;
+	__u32		flags;
 };
 
 struct drm_radeon_cs {
-	uint32_t		num_chunks;
-	uint32_t		cs_id;
-	/* this points to uint64_t * which point to cs chunks */
-	uint64_t		chunks;
+	__u32		num_chunks;
+	__u32		cs_id;
+	/* this points to __u64 * which point to cs chunks */
+	__u64		chunks;
 	/* updates to the limits after this CS ioctl */
-	uint64_t		gart_limit;
-	uint64_t		vram_limit;
+	__u64		gart_limit;
+	__u64		vram_limit;
 };
 
 #define RADEON_INFO_DEVICE_ID		0x00
@@ -1042,9 +1044,9 @@ struct drm_radeon_cs {
 #define RADEON_INFO_GPU_RESET_COUNTER	0x26
 
 struct drm_radeon_info {
-	uint32_t		request;
-	uint32_t		pad;
-	uint64_t		value;
+	__u32		request;
+	__u32		pad;
+	__u64		value;
 };
 
 /* Those correspond to the tile index to use, this is to explicitly state
-- 
2.6.2
