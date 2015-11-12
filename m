From: Gabriel Laskar <gabriel@lse.epita.fr>
Subject: [PATCH 5/9] include/uapi/drm/amdgpu_drm.h: use __u{32,64} types instead of uint{32,64}_t
Date: Thu, 12 Nov 2015 19:14:07 +0100
Message-ID: <1447352051-22022-6-git-send-email-gabriel@lse.epita.fr>
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
 include/uapi/drm/amdgpu_drm.h | 292 +++++++++++++++++++++---------------------
 1 file changed, 147 insertions(+), 145 deletions(-)

diff --git a/include/uapi/drm/amdgpu_drm.h b/include/uapi/drm/amdgpu_drm.h
index e52933a..7f169c3 100644
--- a/include/uapi/drm/amdgpu_drm.h
+++ b/include/uapi/drm/amdgpu_drm.h
@@ -34,6 +34,8 @@
 
 #include "drm.h"
 
+#include <linux/types.h>
+
 #define DRM_AMDGPU_GEM_CREATE		0x00
 #define DRM_AMDGPU_GEM_MMAP		0x01
 #define DRM_AMDGPU_CTX			0x02
@@ -76,19 +78,19 @@
 
 struct drm_amdgpu_gem_create_in  {
 	/** the requested memory size */
-	uint64_t bo_size;
+	__u64 bo_size;
 	/** physical start_addr alignment in bytes for some HW requirements */
-	uint64_t alignment;
+	__u64 alignment;
 	/** the requested memory domains */
-	uint64_t domains;
+	__u64 domains;
 	/** allocation flags */
-	uint64_t domain_flags;
+	__u64 domain_flags;
 };
 
 struct drm_amdgpu_gem_create_out  {
 	/** returned GEM object handle */
-	uint32_t handle;
-	uint32_t _pad;
+	__u32 handle;
+	__u32 _pad;
 };
 
 union drm_amdgpu_gem_create {
@@ -105,28 +107,28 @@ union drm_amdgpu_gem_create {
 
 struct drm_amdgpu_bo_list_in {
 	/** Type of operation */
-	uint32_t operation;
+	__u32 operation;
 	/** Handle of list or 0 if we want to create one */
-	uint32_t list_handle;
+	__u32 list_handle;
 	/** Number of BOs in list  */
-	uint32_t bo_number;
+	__u32 bo_number;
 	/** Size of each element describing BO */
-	uint32_t bo_info_size;
+	__u32 bo_info_size;
 	/** Pointer to array describing BOs */
-	uint64_t bo_info_ptr;
+	__u64 bo_info_ptr;
 };
 
 struct drm_amdgpu_bo_list_entry {
 	/** Handle of BO */
-	uint32_t bo_handle;
+	__u32 bo_handle;
 	/** New (if specified) BO priority to be used during migration */
-	uint32_t bo_priority;
+	__u32 bo_priority;
 };
 
 struct drm_amdgpu_bo_list_out {
 	/** Handle of resource list  */
-	uint32_t list_handle;
-	uint32_t _pad;
+	__u32 list_handle;
+	__u32 _pad;
 };
 
 union drm_amdgpu_bo_list {
@@ -150,26 +152,26 @@ union drm_amdgpu_bo_list {
 
 struct drm_amdgpu_ctx_in {
 	/** AMDGPU_CTX_OP_* */
-	uint32_t	op;
+	__u32	op;
 	/** For future use, no flags defined so far */
-	uint32_t	flags;
-	uint32_t	ctx_id;
-	uint32_t	_pad;
+	__u32	flags;
+	__u32	ctx_id;
+	__u32	_pad;
 };
 
 union drm_amdgpu_ctx_out {
 		struct {
-			uint32_t	ctx_id;
-			uint32_t	_pad;
+			__u32	ctx_id;
+			__u32	_pad;
 		} alloc;
 
 		struct {
 			/** For future use, no flags defined so far */
-			uint64_t	flags;
+			__u64	flags;
 			/** Number of resets caused by this context so far. */
-			uint32_t	hangs;
+			__u32	hangs;
 			/** Reset status since the last call of the ioctl. */
-			uint32_t	reset_status;
+			__u32	reset_status;
 		} state;
 };
 
@@ -189,12 +191,12 @@ union drm_amdgpu_ctx {
 #define AMDGPU_GEM_USERPTR_REGISTER	(1 << 3)
 
 struct drm_amdgpu_gem_userptr {
-	uint64_t		addr;
-	uint64_t		size;
+	__u64		addr;
+	__u64		size;
 	/* AMDGPU_GEM_USERPTR_* */
-	uint32_t		flags;
+	__u32		flags;
 	/* Resulting GEM handle */
-	uint32_t		handle;
+	__u32		handle;
 };
 
 /* same meaning as the GB_TILE_MODE and GL_MACRO_TILE_MODE fields */
@@ -226,28 +228,28 @@ struct drm_amdgpu_gem_userptr {
 /** The same structure is shared for input/output */
 struct drm_amdgpu_gem_metadata {
 	/** GEM Object handle */
-	uint32_t	handle;
+	__u32	handle;
 	/** Do we want get or set metadata */
-	uint32_t	op;
+	__u32	op;
 	struct {
 		/** For future use, no flags defined so far */
-		uint64_t	flags;
+		__u64	flags;
 		/** family specific tiling info */
-		uint64_t	tiling_info;
-		uint32_t	data_size_bytes;
-		uint32_t	data[64];
+		__u64	tiling_info;
+		__u32	data_size_bytes;
+		__u32	data[64];
 	} data;
 };
 
 struct drm_amdgpu_gem_mmap_in {
 	/** the GEM object handle */
-	uint32_t handle;
-	uint32_t _pad;
+	__u32 handle;
+	__u32 _pad;
 };
 
 struct drm_amdgpu_gem_mmap_out {
 	/** mmap offset from the vma offset manager */
-	uint64_t addr_ptr;
+	__u64 addr_ptr;
 };
 
 union drm_amdgpu_gem_mmap {
@@ -257,18 +259,18 @@ union drm_amdgpu_gem_mmap {
 
 struct drm_amdgpu_gem_wait_idle_in {
 	/** GEM object handle */
-	uint32_t handle;
+	__u32 handle;
 	/** For future use, no flags defined so far */
-	uint32_t flags;
+	__u32 flags;
 	/** Absolute timeout to wait */
-	uint64_t timeout;
+	__u64 timeout;
 };
 
 struct drm_amdgpu_gem_wait_idle_out {
 	/** BO status:  0 - BO is idle, 1 - BO is busy */
-	uint32_t status;
+	__u32 status;
 	/** Returned current memory domain */
-	uint32_t domain;
+	__u32 domain;
 };
 
 union drm_amdgpu_gem_wait_idle {
@@ -278,18 +280,18 @@ union drm_amdgpu_gem_wait_idle {
 
 struct drm_amdgpu_wait_cs_in {
 	/** Command submission handle */
-	uint64_t handle;
+	__u64 handle;
 	/** Absolute timeout to wait */
-	uint64_t timeout;
-	uint32_t ip_type;
-	uint32_t ip_instance;
-	uint32_t ring;
-	uint32_t ctx_id;
+	__u64 timeout;
+	__u32 ip_type;
+	__u32 ip_instance;
+	__u32 ring;
+	__u32 ctx_id;
 };
 
 struct drm_amdgpu_wait_cs_out {
 	/** CS status:  0 - CS completed, 1 - CS still busy */
-	uint64_t status;
+	__u64 status;
 };
 
 union drm_amdgpu_wait_cs {
@@ -303,11 +305,11 @@ union drm_amdgpu_wait_cs {
 /* Sets or returns a value associated with a buffer. */
 struct drm_amdgpu_gem_op {
 	/** GEM object handle */
-	uint32_t	handle;
+	__u32	handle;
 	/** AMDGPU_GEM_OP_* */
-	uint32_t	op;
+	__u32	op;
 	/** Input or return value */
-	uint64_t	value;
+	__u64	value;
 };
 
 #define AMDGPU_VA_OP_MAP			1
@@ -326,18 +328,18 @@ struct drm_amdgpu_gem_op {
 
 struct drm_amdgpu_gem_va {
 	/** GEM object handle */
-	uint32_t handle;
-	uint32_t _pad;
+	__u32 handle;
+	__u32 _pad;
 	/** AMDGPU_VA_OP_* */
-	uint32_t operation;
+	__u32 operation;
 	/** AMDGPU_VM_PAGE_* */
-	uint32_t flags;
+	__u32 flags;
 	/** va address to assign . Must be correctly aligned.*/
-	uint64_t va_address;
+	__u64 va_address;
 	/** Specify offset inside of BO to assign. Must be correctly aligned.*/
-	uint64_t offset_in_bo;
+	__u64 offset_in_bo;
 	/** Specify mapping size. Must be correctly aligned. */
-	uint64_t map_size;
+	__u64 map_size;
 };
 
 #define AMDGPU_HW_IP_GFX          0
@@ -354,24 +356,24 @@ struct drm_amdgpu_gem_va {
 #define AMDGPU_CHUNK_ID_DEPENDENCIES	0x03
 
 struct drm_amdgpu_cs_chunk {
-	uint32_t		chunk_id;
-	uint32_t		length_dw;
-	uint64_t		chunk_data;
+	__u32		chunk_id;
+	__u32		length_dw;
+	__u64		chunk_data;
 };
 
 struct drm_amdgpu_cs_in {
 	/** Rendering context id */
-	uint32_t		ctx_id;
+	__u32		ctx_id;
 	/**  Handle of resource list associated with CS */
-	uint32_t		bo_list_handle;
-	uint32_t		num_chunks;
-	uint32_t		_pad;
-	/** this points to uint64_t * which point to cs chunks */
-	uint64_t		chunks;
+	__u32		bo_list_handle;
+	__u32		num_chunks;
+	__u32		_pad;
+	/** this points to __u64 * which point to cs chunks */
+	__u64		chunks;
 };
 
 struct drm_amdgpu_cs_out {
-	uint64_t handle;
+	__u64 handle;
 };
 
 union drm_amdgpu_cs {
@@ -388,32 +390,32 @@ union drm_amdgpu_cs {
 #define AMDGPU_IB_FLAG_PREAMBLE (1<<1)
 
 struct drm_amdgpu_cs_chunk_ib {
-	uint32_t _pad;
+	__u32 _pad;
 	/** AMDGPU_IB_FLAG_* */
-	uint32_t flags;
+	__u32 flags;
 	/** Virtual address to begin IB execution */
-	uint64_t va_start;
+	__u64 va_start;
 	/** Size of submission */
-	uint32_t ib_bytes;
+	__u32 ib_bytes;
 	/** HW IP to submit to */
-	uint32_t ip_type;
+	__u32 ip_type;
 	/** HW IP index of the same type to submit to  */
-	uint32_t ip_instance;
+	__u32 ip_instance;
 	/** Ring index to submit to */
-	uint32_t ring;
+	__u32 ring;
 };
 
 struct drm_amdgpu_cs_chunk_dep {
-	uint32_t ip_type;
-	uint32_t ip_instance;
-	uint32_t ring;
-	uint32_t ctx_id;
-	uint64_t handle;
+	__u32 ip_type;
+	__u32 ip_instance;
+	__u32 ring;
+	__u32 ctx_id;
+	__u64 handle;
 };
 
 struct drm_amdgpu_cs_chunk_fence {
-	uint32_t handle;
-	uint32_t offset;
+	__u32 handle;
+	__u32 offset;
 };
 
 struct drm_amdgpu_cs_chunk_data {
@@ -486,83 +488,83 @@ struct drm_amdgpu_cs_chunk_data {
 /* Input structure for the INFO ioctl */
 struct drm_amdgpu_info {
 	/* Where the return value will be stored */
-	uint64_t return_pointer;
+	__u64 return_pointer;
 	/* The size of the return value. Just like "size" in "snprintf",
 	 * it limits how many bytes the kernel can write. */
-	uint32_t return_size;
+	__u32 return_size;
 	/* The query request id. */
-	uint32_t query;
+	__u32 query;
 
 	union {
 		struct {
-			uint32_t id;
-			uint32_t _pad;
+			__u32 id;
+			__u32 _pad;
 		} mode_crtc;
 
 		struct {
 			/** AMDGPU_HW_IP_* */
-			uint32_t type;
+			__u32 type;
 			/**
 			 * Index of the IP if there are more IPs of the same
 			 * type. Ignored by AMDGPU_INFO_HW_IP_COUNT.
 			 */
-			uint32_t ip_instance;
+			__u32 ip_instance;
 		} query_hw_ip;
 
 		struct {
-			uint32_t dword_offset;
+			__u32 dword_offset;
 			/** number of registers to read */
-			uint32_t count;
-			uint32_t instance;
+			__u32 count;
+			__u32 instance;
 			/** For future use, no flags defined so far */
-			uint32_t flags;
+			__u32 flags;
 		} read_mmr_reg;
 
 		struct {
 			/** AMDGPU_INFO_FW_* */
-			uint32_t fw_type;
+			__u32 fw_type;
 			/**
 			 * Index of the IP if there are more IPs of
 			 * the same type.
 			 */
-			uint32_t ip_instance;
+			__u32 ip_instance;
 			/**
 			 * Index of the engine. Whether this is used depends
 			 * on the firmware type. (e.g. MEC, SDMA)
 			 */
-			uint32_t index;
-			uint32_t _pad;
+			__u32 index;
+			__u32 _pad;
 		} query_fw;
 	};
 };
 
 struct drm_amdgpu_info_gds {
 	/** GDS GFX partition size */
-	uint32_t gds_gfx_partition_size;
+	__u32 gds_gfx_partition_size;
 	/** GDS compute partition size */
-	uint32_t compute_partition_size;
+	__u32 compute_partition_size;
 	/** total GDS memory size */
-	uint32_t gds_total_size;
+	__u32 gds_total_size;
 	/** GWS size per GFX partition */
-	uint32_t gws_per_gfx_partition;
+	__u32 gws_per_gfx_partition;
 	/** GSW size per compute partition */
-	uint32_t gws_per_compute_partition;
+	__u32 gws_per_compute_partition;
 	/** OA size per GFX partition */
-	uint32_t oa_per_gfx_partition;
+	__u32 oa_per_gfx_partition;
 	/** OA size per compute partition */
-	uint32_t oa_per_compute_partition;
-	uint32_t _pad;
+	__u32 oa_per_compute_partition;
+	__u32 _pad;
 };
 
 struct drm_amdgpu_info_vram_gtt {
-	uint64_t vram_size;
-	uint64_t vram_cpu_accessible_size;
-	uint64_t gtt_size;
+	__u64 vram_size;
+	__u64 vram_cpu_accessible_size;
+	__u64 gtt_size;
 };
 
 struct drm_amdgpu_info_firmware {
-	uint32_t ver;
-	uint32_t feature;
+	__u32 ver;
+	__u32 feature;
 };
 
 #define AMDGPU_VRAM_TYPE_UNKNOWN 0
@@ -576,61 +578,61 @@ struct drm_amdgpu_info_firmware {
 
 struct drm_amdgpu_info_device {
 	/** PCI Device ID */
-	uint32_t device_id;
+	__u32 device_id;
 	/** Internal chip revision: A0, A1, etc.) */
-	uint32_t chip_rev;
-	uint32_t external_rev;
+	__u32 chip_rev;
+	__u32 external_rev;
 	/** Revision id in PCI Config space */
-	uint32_t pci_rev;
-	uint32_t family;
-	uint32_t num_shader_engines;
-	uint32_t num_shader_arrays_per_engine;
+	__u32 pci_rev;
+	__u32 family;
+	__u32 num_shader_engines;
+	__u32 num_shader_arrays_per_engine;
 	/* in KHz */
-	uint32_t gpu_counter_freq;
-	uint64_t max_engine_clock;
-	uint64_t max_memory_clock;
+	__u32 gpu_counter_freq;
+	__u64 max_engine_clock;
+	__u64 max_memory_clock;
 	/* cu information */
-	uint32_t cu_active_number;
-	uint32_t cu_ao_mask;
-	uint32_t cu_bitmap[4][4];
+	__u32 cu_active_number;
+	__u32 cu_ao_mask;
+	__u32 cu_bitmap[4][4];
 	/** Render backend pipe mask. One render backend is CB+DB. */
-	uint32_t enabled_rb_pipes_mask;
-	uint32_t num_rb_pipes;
-	uint32_t num_hw_gfx_contexts;
-	uint32_t _pad;
-	uint64_t ids_flags;
+	__u32 enabled_rb_pipes_mask;
+	__u32 num_rb_pipes;
+	__u32 num_hw_gfx_contexts;
+	__u32 _pad;
+	__u64 ids_flags;
 	/** Starting virtual address for UMDs. */
-	uint64_t virtual_address_offset;
+	__u64 virtual_address_offset;
 	/** The maximum virtual address */
-	uint64_t virtual_address_max;
+	__u64 virtual_address_max;
 	/** Required alignment of virtual addresses. */
-	uint32_t virtual_address_alignment;
+	__u32 virtual_address_alignment;
 	/** Page table entry - fragment size */
-	uint32_t pte_fragment_size;
-	uint32_t gart_page_size;
+	__u32 pte_fragment_size;
+	__u32 gart_page_size;
 	/** constant engine ram size*/
-	uint32_t ce_ram_size;
+	__u32 ce_ram_size;
 	/** video memory type info*/
-	uint32_t vram_type;
+	__u32 vram_type;
 	/** video memory bit width*/
-	uint32_t vram_bit_width;
+	__u32 vram_bit_width;
 	/* vce harvesting instance */
-	uint32_t vce_harvest_config;
+	__u32 vce_harvest_config;
 };
 
 struct drm_amdgpu_info_hw_ip {
 	/** Version of h/w IP */
-	uint32_t  hw_ip_version_major;
-	uint32_t  hw_ip_version_minor;
+	__u32  hw_ip_version_major;
+	__u32  hw_ip_version_minor;
 	/** Capabilities */
-	uint64_t  capabilities_flags;
+	__u64  capabilities_flags;
 	/** command buffer address start alignment*/
-	uint32_t  ib_start_alignment;
+	__u32  ib_start_alignment;
 	/** command buffer size alignment*/
-	uint32_t  ib_size_alignment;
+	__u32  ib_size_alignment;
 	/** Bitmask of available rings. Bit 0 means ring 0, etc. */
-	uint32_t  available_rings;
-	uint32_t  _pad;
+	__u32  available_rings;
+	__u32  _pad;
 };
 
 /*
-- 
2.6.2
