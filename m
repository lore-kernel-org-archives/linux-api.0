From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 07/98] radeon_drm.h: use __u32 and __u64 from linux/types.h
Date: Sat, 30 May 2015 17:37:59 +0200
Message-ID: <1433000370-19509-8-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Alex Deucher <alexander.deucher@amd.com>, =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compiler error:

drm/radeon_drm.h:794:2: error: unknown type name =E2=80=98uint64_t=E2=80=
=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/radeon_drm.h | 129 +++++++++++++++++++++-------------=
--------
 1 file changed, 65 insertions(+), 64 deletions(-)

diff --git a/include/uapi/drm/radeon_drm.h b/include/uapi/drm/radeon_dr=
m.h
index 871e73f..5127092 100644
--- a/include/uapi/drm/radeon_drm.h
+++ b/include/uapi/drm/radeon_drm.h
@@ -33,6 +33,7 @@
 #ifndef __RADEON_DRM_H__
 #define __RADEON_DRM_H__
=20
+#include <linux/types.h>
 #include <drm/drm.h>
=20
 /* WARNING: If you change any of these defines, make sure to change th=
e
@@ -793,9 +794,9 @@ typedef struct drm_radeon_surface_free {
 #define RADEON_GEM_DOMAIN_VRAM		0x4
=20
 struct drm_radeon_gem_info {
-	uint64_t	gart_size;
-	uint64_t	vram_size;
-	uint64_t	vram_visible;
+	__u64	gart_size;
+	__u64	vram_size;
+	__u64	vram_visible;
 };
=20
 #define RADEON_GEM_NO_BACKING_STORE	(1 << 0)
@@ -807,11 +808,11 @@ struct drm_radeon_gem_info {
 #define RADEON_GEM_NO_CPU_ACCESS	(1 << 4)
=20
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
=20
 /*
@@ -825,10 +826,10 @@ struct drm_radeon_gem_create {
 #define RADEON_GEM_USERPTR_REGISTER	(1 << 3)
=20
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
=20
 #define RADEON_TILING_MACRO				0x1
@@ -850,72 +851,72 @@ struct drm_radeon_gem_userptr {
 #define RADEON_TILING_EG_STENCIL_TILE_SPLIT_MASK	0xf
=20
 struct drm_radeon_gem_set_tiling {
-	uint32_t	handle;
-	uint32_t	tiling_flags;
-	uint32_t	pitch;
+	__u32	handle;
+	__u32	tiling_flags;
+	__u32	pitch;
 };
=20
 struct drm_radeon_gem_get_tiling {
-	uint32_t	handle;
-	uint32_t	tiling_flags;
-	uint32_t	pitch;
+	__u32	handle;
+	__u32	tiling_flags;
+	__u32	pitch;
 };
=20
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
=20
 struct drm_radeon_gem_set_domain {
-	uint32_t	handle;
-	uint32_t	read_domains;
-	uint32_t	write_domain;
+	__u32	handle;
+	__u32	read_domains;
+	__u32	write_domain;
 };
=20
 struct drm_radeon_gem_wait_idle {
-	uint32_t	handle;
-	uint32_t	pad;
+	__u32	handle;
+	__u32	pad;
 };
=20
 struct drm_radeon_gem_busy {
-	uint32_t	handle;
-	uint32_t        domain;
+	__u32	handle;
+	__u32        domain;
 };
=20
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
=20
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
=20
 /* Sets or returns a value associated with a buffer. */
 struct drm_radeon_gem_op {
-	uint32_t	handle; /* buffer */
-	uint32_t	op;     /* RADEON_GEM_OP_* */
-	uint64_t	value;  /* input or return value */
+	__u32	handle; /* buffer */
+	__u32	op;     /* RADEON_GEM_OP_* */
+	__u64	value;  /* input or return value */
 };
=20
 #define RADEON_GEM_OP_GET_INITIAL_DOMAIN	0
@@ -935,11 +936,11 @@ struct drm_radeon_gem_op {
 #define RADEON_VM_PAGE_SNOOPED		(1 << 4)
=20
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
=20
 #define RADEON_CHUNK_ID_RELOCS	0x01
@@ -961,29 +962,29 @@ struct drm_radeon_gem_va {
 /* 0 =3D normal, + =3D higher priority, - =3D lower priority */
=20
 struct drm_radeon_cs_chunk {
-	uint32_t		chunk_id;
-	uint32_t		length_dw;
-	uint64_t		chunk_data;
+	__u32		chunk_id;
+	__u32		length_dw;
+	__u64		chunk_data;
 };
=20
 /* drm_radeon_cs_reloc.flags */
 #define RADEON_RELOC_PRIO_MASK		(0xf << 0)
=20
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
=20
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
=20
 #define RADEON_INFO_DEVICE_ID		0x00
@@ -1040,9 +1041,9 @@ struct drm_radeon_cs {
 #define RADEON_INFO_READ_REG		0x24
=20
 struct drm_radeon_info {
-	uint32_t		request;
-	uint32_t		pad;
-	uint64_t		value;
+	__u32		request;
+	__u32		pad;
+	__u64		value;
 };
=20
 /* Those correspond to the tile index to use, this is to explicitly st=
ate
--=20
2.1.4
