From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH v06 36/36] uapi linux/kfd_ioctl.h: use __u32 and __u64 instead of uint32_t and uint64_t
Date: Sun,  6 Aug 2017 18:44:27 +0200
Message-ID: <20170806164428.2273-37-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Yair Shachar <yair.shachar-5C7GfCeVMHo@public.gmane.org>, Oded Gabbay <oded.gabbay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Lewycky <Andrew.Lewycky-5C7GfCeVMHo@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
List-Id: linux-api@vger.kernel.org

Include <drm/drm.h> instead of <linux/types.h> which on Linux includes
<linux/types.h> and on non-Linux platforms defines __u32 etc types.

Fixes user space compilation errors like:

linux/kfd_ioctl.h:33:2: error: unknown type name ‘uint32_t’
  uint32_t major_version; /* from KFD */
  ^~~~~~~~

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: Yair Shachar <yair.shachar-5C7GfCeVMHo@public.gmane.org>
Cc: Oded Gabbay <oded.gabbay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Lewycky <Andrew.Lewycky-5C7GfCeVMHo@public.gmane.org>
---
 include/uapi/linux/kfd_ioctl.h | 172 ++++++++++++++++++++---------------------
 1 file changed, 86 insertions(+), 86 deletions(-)

diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
index d6833426fdef..189ebfc2e193 100644
--- a/include/uapi/linux/kfd_ioctl.h
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -23,15 +23,15 @@
 #ifndef KFD_IOCTL_H_INCLUDED
 #define KFD_IOCTL_H_INCLUDED
 
-#include <linux/types.h>
+#include <drm/drm.h>
 #include <linux/ioctl.h>
 
 #define KFD_IOCTL_MAJOR_VERSION 1
 #define KFD_IOCTL_MINOR_VERSION 1
 
 struct kfd_ioctl_get_version_args {
-	uint32_t major_version;	/* from KFD */
-	uint32_t minor_version;	/* from KFD */
+	__u32 major_version;	/* from KFD */
+	__u32 minor_version;	/* from KFD */
 };
 
 /* For kfd_ioctl_create_queue_args.queue_type. */
@@ -43,36 +43,36 @@ struct kfd_ioctl_get_version_args {
 #define KFD_MAX_QUEUE_PRIORITY		15
 
 struct kfd_ioctl_create_queue_args {
-	uint64_t ring_base_address;	/* to KFD */
-	uint64_t write_pointer_address;	/* from KFD */
-	uint64_t read_pointer_address;	/* from KFD */
-	uint64_t doorbell_offset;	/* from KFD */
-
-	uint32_t ring_size;		/* to KFD */
-	uint32_t gpu_id;		/* to KFD */
-	uint32_t queue_type;		/* to KFD */
-	uint32_t queue_percentage;	/* to KFD */
-	uint32_t queue_priority;	/* to KFD */
-	uint32_t queue_id;		/* from KFD */
-
-	uint64_t eop_buffer_address;	/* to KFD */
-	uint64_t eop_buffer_size;	/* to KFD */
-	uint64_t ctx_save_restore_address; /* to KFD */
-	uint64_t ctx_save_restore_size;	/* to KFD */
+	__u64 ring_base_address;	/* to KFD */
+	__u64 write_pointer_address;	/* from KFD */
+	__u64 read_pointer_address;	/* from KFD */
+	__u64 doorbell_offset;	/* from KFD */
+
+	__u32 ring_size;		/* to KFD */
+	__u32 gpu_id;		/* to KFD */
+	__u32 queue_type;		/* to KFD */
+	__u32 queue_percentage;	/* to KFD */
+	__u32 queue_priority;	/* to KFD */
+	__u32 queue_id;		/* from KFD */
+
+	__u64 eop_buffer_address;	/* to KFD */
+	__u64 eop_buffer_size;	/* to KFD */
+	__u64 ctx_save_restore_address; /* to KFD */
+	__u64 ctx_save_restore_size;	/* to KFD */
 };
 
 struct kfd_ioctl_destroy_queue_args {
-	uint32_t queue_id;		/* to KFD */
-	uint32_t pad;
+	__u32 queue_id;		/* to KFD */
+	__u32 pad;
 };
 
 struct kfd_ioctl_update_queue_args {
-	uint64_t ring_base_address;	/* to KFD */
+	__u64 ring_base_address;	/* to KFD */
 
-	uint32_t queue_id;		/* to KFD */
-	uint32_t ring_size;		/* to KFD */
-	uint32_t queue_percentage;	/* to KFD */
-	uint32_t queue_priority;	/* to KFD */
+	__u32 queue_id;		/* to KFD */
+	__u32 ring_size;		/* to KFD */
+	__u32 queue_percentage;	/* to KFD */
+	__u32 queue_priority;	/* to KFD */
 };
 
 /* For kfd_ioctl_set_memory_policy_args.default_policy and alternate_policy */
@@ -80,13 +80,13 @@ struct kfd_ioctl_update_queue_args {
 #define KFD_IOC_CACHE_POLICY_NONCOHERENT 1
 
 struct kfd_ioctl_set_memory_policy_args {
-	uint64_t alternate_aperture_base;	/* to KFD */
-	uint64_t alternate_aperture_size;	/* to KFD */
+	__u64 alternate_aperture_base;	/* to KFD */
+	__u64 alternate_aperture_size;	/* to KFD */
 
-	uint32_t gpu_id;			/* to KFD */
-	uint32_t default_policy;		/* to KFD */
-	uint32_t alternate_policy;		/* to KFD */
-	uint32_t pad;
+	__u32 gpu_id;			/* to KFD */
+	__u32 default_policy;		/* to KFD */
+	__u32 alternate_policy;		/* to KFD */
+	__u32 pad;
 };
 
 /*
@@ -97,26 +97,26 @@ struct kfd_ioctl_set_memory_policy_args {
  */
 
 struct kfd_ioctl_get_clock_counters_args {
-	uint64_t gpu_clock_counter;	/* from KFD */
-	uint64_t cpu_clock_counter;	/* from KFD */
-	uint64_t system_clock_counter;	/* from KFD */
-	uint64_t system_clock_freq;	/* from KFD */
+	__u64 gpu_clock_counter;	/* from KFD */
+	__u64 cpu_clock_counter;	/* from KFD */
+	__u64 system_clock_counter;	/* from KFD */
+	__u64 system_clock_freq;	/* from KFD */
 
-	uint32_t gpu_id;		/* to KFD */
-	uint32_t pad;
+	__u32 gpu_id;		/* to KFD */
+	__u32 pad;
 };
 
 #define NUM_OF_SUPPORTED_GPUS 7
 
 struct kfd_process_device_apertures {
-	uint64_t lds_base;		/* from KFD */
-	uint64_t lds_limit;		/* from KFD */
-	uint64_t scratch_base;		/* from KFD */
-	uint64_t scratch_limit;		/* from KFD */
-	uint64_t gpuvm_base;		/* from KFD */
-	uint64_t gpuvm_limit;		/* from KFD */
-	uint32_t gpu_id;		/* from KFD */
-	uint32_t pad;
+	__u64 lds_base;		/* from KFD */
+	__u64 lds_limit;		/* from KFD */
+	__u64 scratch_base;		/* from KFD */
+	__u64 scratch_limit;		/* from KFD */
+	__u64 gpuvm_base;		/* from KFD */
+	__u64 gpuvm_limit;		/* from KFD */
+	__u32 gpu_id;		/* from KFD */
+	__u32 pad;
 };
 
 struct kfd_ioctl_get_process_apertures_args {
@@ -124,8 +124,8 @@ struct kfd_ioctl_get_process_apertures_args {
 			process_apertures[NUM_OF_SUPPORTED_GPUS];/* from KFD */
 
 	/* from KFD, should be in the range [1 - NUM_OF_SUPPORTED_GPUS] */
-	uint32_t num_of_nodes;
-	uint32_t pad;
+	__u32 num_of_nodes;
+	__u32 pad;
 };
 
 #define MAX_ALLOWED_NUM_POINTS    100
@@ -133,25 +133,25 @@ struct kfd_ioctl_get_process_apertures_args {
 #define MAX_ALLOWED_WAC_BUFF_SIZE  128
 
 struct kfd_ioctl_dbg_register_args {
-	uint32_t gpu_id;		/* to KFD */
-	uint32_t pad;
+	__u32 gpu_id;		/* to KFD */
+	__u32 pad;
 };
 
 struct kfd_ioctl_dbg_unregister_args {
-	uint32_t gpu_id;		/* to KFD */
-	uint32_t pad;
+	__u32 gpu_id;		/* to KFD */
+	__u32 pad;
 };
 
 struct kfd_ioctl_dbg_address_watch_args {
-	uint64_t content_ptr;		/* a pointer to the actual content */
-	uint32_t gpu_id;		/* to KFD */
-	uint32_t buf_size_in_bytes;	/*including gpu_id and buf_size */
+	__u64 content_ptr;		/* a pointer to the actual content */
+	__u32 gpu_id;		/* to KFD */
+	__u32 buf_size_in_bytes;	/*including gpu_id and buf_size */
 };
 
 struct kfd_ioctl_dbg_wave_control_args {
-	uint64_t content_ptr;		/* a pointer to the actual content */
-	uint32_t gpu_id;		/* to KFD */
-	uint32_t buf_size_in_bytes;	/*including gpu_id and buf_size */
+	__u64 content_ptr;		/* a pointer to the actual content */
+	__u32 gpu_id;		/* to KFD */
+	__u32 buf_size_in_bytes;	/*including gpu_id and buf_size */
 };
 
 /* Matching HSA_EVENTTYPE */
@@ -172,44 +172,44 @@ struct kfd_ioctl_dbg_wave_control_args {
 #define KFD_SIGNAL_EVENT_LIMIT			256
 
 struct kfd_ioctl_create_event_args {
-	uint64_t event_page_offset;	/* from KFD */
-	uint32_t event_trigger_data;	/* from KFD - signal events only */
-	uint32_t event_type;		/* to KFD */
-	uint32_t auto_reset;		/* to KFD */
-	uint32_t node_id;		/* to KFD - only valid for certain
+	__u64 event_page_offset;	/* from KFD */
+	__u32 event_trigger_data;	/* from KFD - signal events only */
+	__u32 event_type;		/* to KFD */
+	__u32 auto_reset;		/* to KFD */
+	__u32 node_id;		/* to KFD - only valid for certain
 							event types */
-	uint32_t event_id;		/* from KFD */
-	uint32_t event_slot_index;	/* from KFD */
+	__u32 event_id;		/* from KFD */
+	__u32 event_slot_index;	/* from KFD */
 };
 
 struct kfd_ioctl_destroy_event_args {
-	uint32_t event_id;		/* to KFD */
-	uint32_t pad;
+	__u32 event_id;		/* to KFD */
+	__u32 pad;
 };
 
 struct kfd_ioctl_set_event_args {
-	uint32_t event_id;		/* to KFD */
-	uint32_t pad;
+	__u32 event_id;		/* to KFD */
+	__u32 pad;
 };
 
 struct kfd_ioctl_reset_event_args {
-	uint32_t event_id;		/* to KFD */
-	uint32_t pad;
+	__u32 event_id;		/* to KFD */
+	__u32 pad;
 };
 
 struct kfd_memory_exception_failure {
-	uint32_t NotPresent;	/* Page not present or supervisor privilege */
-	uint32_t ReadOnly;	/* Write access to a read-only page */
-	uint32_t NoExecute;	/* Execute access to a page marked NX */
-	uint32_t pad;
+	__u32 NotPresent;	/* Page not present or supervisor privilege */
+	__u32 ReadOnly;	/* Write access to a read-only page */
+	__u32 NoExecute;	/* Execute access to a page marked NX */
+	__u32 pad;
 };
 
 /* memory exception data*/
 struct kfd_hsa_memory_exception_data {
 	struct kfd_memory_exception_failure failure;
-	uint64_t va;
-	uint32_t gpu_id;
-	uint32_t pad;
+	__u64 va;
+	__u32 gpu_id;
+	__u32 pad;
 };
 
 /* Event data*/
@@ -217,19 +217,19 @@ struct kfd_event_data {
 	union {
 		struct kfd_hsa_memory_exception_data memory_exception_data;
 	};				/* From KFD */
-	uint64_t kfd_event_data_ext;	/* pointer to an extension structure
+	__u64 kfd_event_data_ext;	/* pointer to an extension structure
 					   for future exception types */
-	uint32_t event_id;		/* to KFD */
-	uint32_t pad;
+	__u32 event_id;		/* to KFD */
+	__u32 pad;
 };
 
 struct kfd_ioctl_wait_events_args {
-	uint64_t events_ptr;		/* pointed to struct
+	__u64 events_ptr;		/* pointed to struct
 					   kfd_event_data array, to KFD */
-	uint32_t num_events;		/* to KFD */
-	uint32_t wait_for_all;		/* to KFD */
-	uint32_t timeout;		/* to KFD */
-	uint32_t wait_result;		/* from KFD */
+	__u32 num_events;		/* to KFD */
+	__u32 wait_for_all;		/* to KFD */
+	__u32 timeout;		/* to KFD */
+	__u32 wait_result;		/* from KFD */
 };
 
 #define AMDKFD_IOCTL_BASE 'K'
-- 
2.13.3
