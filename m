From: Oded Gabbay <oded.gabbay@gmail.com>
Subject: [PATCH 60/83] hsa/radeon: Rearrange structures in kfd_ioctl.h
Date: Fri, 11 Jul 2014 00:54:16 +0300
Message-ID: <1405029279-6894-32-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>, Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>, Andrew Lewycky <Andrew.Lewycky@amd.com>, Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>, Ben Goz <ben.goz@amd.com>, Evgeny Pinchuk <evgeny.pinchuk@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patch rearranges the structures defined in kfd_ioctl.h so that
all the uint64_t variables are located at the start of each structure and
then all the uint32_t variables are located.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 include/uapi/linux/kfd_ioctl.h | 51 ++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
index 509c4a0..3cedd1a 100644
--- a/include/uapi/linux/kfd_ioctl.h
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -42,15 +42,15 @@ struct kfd_ioctl_get_version_args {
 
 struct kfd_ioctl_create_queue_args {
 	uint64_t ring_base_address;	/* to KFD */
+	uint64_t write_pointer_address;	/* from KFD */
+	uint64_t read_pointer_address;	/* from KFD */
+	uint64_t doorbell_address;	/* from KFD */
+
 	uint32_t ring_size;		/* to KFD */
 	uint32_t gpu_id;		/* to KFD */
 	uint32_t queue_type;		/* to KFD */
 	uint32_t queue_percentage;	/* to KFD */
 	uint32_t queue_priority;	/* to KFD */
-
-	uint64_t write_pointer_address;	/* from KFD */
-	uint64_t read_pointer_address;	/* from KFD */
-	uint64_t doorbell_address;	/* from KFD */
 	uint32_t queue_id;		/* from KFD */
 };
 
@@ -59,8 +59,9 @@ struct kfd_ioctl_destroy_queue_args {
 };
 
 struct kfd_ioctl_update_queue_args {
-	uint32_t queue_id;		/* to KFD */
 	uint64_t ring_base_address;	/* to KFD */
+
+	uint32_t queue_id;		/* to KFD */
 	uint32_t ring_size;		/* to KFD */
 	uint32_t queue_percentage;	/* to KFD */
 	uint32_t queue_priority;	/* to KFD */
@@ -71,31 +72,33 @@ struct kfd_ioctl_update_queue_args {
 #define KFD_IOC_CACHE_POLICY_NONCOHERENT 1
 
 struct kfd_ioctl_set_memory_policy_args {
+	uint64_t alternate_aperture_base;	/* to KFD */
+	uint64_t alternate_aperture_size;	/* to KFD */
+
 	uint32_t gpu_id;			/* to KFD */
 	uint32_t default_policy;		/* to KFD */
 	uint32_t alternate_policy;		/* to KFD */
-	uint64_t alternate_aperture_base;	/* to KFD */
-	uint64_t alternate_aperture_size;	/* to KFD */
 };
 
 struct kfd_ioctl_get_clock_counters_args {
-	uint32_t gpu_id;		/* to KFD */
 	uint64_t gpu_clock_counter;	/* from KFD */
 	uint64_t cpu_clock_counter;	/* from KFD */
 	uint64_t system_clock_counter;	/* from KFD */
 	uint64_t system_clock_freq;	/* from KFD */
+
+	uint32_t gpu_id;		/* to KFD */
 };
 
 #define NUM_OF_SUPPORTED_GPUS 7
 
 struct kfd_process_device_apertures {
-	uint64_t lds_base;/* from KFD */
-	uint64_t lds_limit;/* from KFD */
-	uint64_t scratch_base;/* from KFD */
-	uint64_t scratch_limit;/* from KFD */
-	uint64_t gpuvm_base;/* from KFD */
-	uint64_t gpuvm_limit;/* from KFD */
-	uint32_t gpu_id;/* from KFD */
+	uint64_t lds_base;		/* from KFD */
+	uint64_t lds_limit;		/* from KFD */
+	uint64_t scratch_base;		/* from KFD */
+	uint64_t scratch_limit;		/* from KFD */
+	uint64_t gpuvm_base;		/* from KFD */
+	uint64_t gpuvm_limit;		/* from KFD */
+	uint32_t gpu_id;		/* from KFD */
 };
 
 struct kfd_ioctl_get_process_apertures_args {
@@ -104,24 +107,24 @@ struct kfd_ioctl_get_process_apertures_args {
 };
 
 struct kfd_ioctl_pmc_acquire_access_args {
-	uint32_t gpu_id;	/* to KFD */
-	uint64_t trace_id;	/* to KFD */
+	uint64_t trace_id;		/* to KFD */
+	uint32_t gpu_id;		/* to KFD */
 };
 
 struct kfd_ioctl_pmc_release_access_args {
-	uint32_t gpu_id;	/* to KFD */
-	uint64_t trace_id;	/* to KFD */
+	uint64_t trace_id;		/* to KFD */
+	uint32_t gpu_id;		/* to KFD */
 };
 
 #define KFD_IOC_MAGIC 'K'
 
-#define KFD_IOC_GET_VERSION	_IOR(KFD_IOC_MAGIC, 1, struct kfd_ioctl_get_version_args)
-#define KFD_IOC_CREATE_QUEUE	_IOWR(KFD_IOC_MAGIC, 2, struct kfd_ioctl_create_queue_args)
-#define KFD_IOC_DESTROY_QUEUE	_IOWR(KFD_IOC_MAGIC, 3, struct kfd_ioctl_destroy_queue_args)
+#define KFD_IOC_GET_VERSION		_IOR(KFD_IOC_MAGIC, 1, struct kfd_ioctl_get_version_args)
+#define KFD_IOC_CREATE_QUEUE		_IOWR(KFD_IOC_MAGIC, 2, struct kfd_ioctl_create_queue_args)
+#define KFD_IOC_DESTROY_QUEUE		_IOWR(KFD_IOC_MAGIC, 3, struct kfd_ioctl_destroy_queue_args)
 #define KFD_IOC_SET_MEMORY_POLICY	_IOW(KFD_IOC_MAGIC, 4, struct kfd_ioctl_set_memory_policy_args)
 #define KFD_IOC_GET_CLOCK_COUNTERS	_IOWR(KFD_IOC_MAGIC, 5, struct kfd_ioctl_get_clock_counters_args)
-#define KFD_IOC_GET_PROCESS_APERTURES _IOR(KFD_IOC_MAGIC, 6, struct kfd_ioctl_get_process_apertures_args)
-#define KFD_IOC_UPDATE_QUEUE	_IOW(KFD_IOC_MAGIC, 7, struct kfd_ioctl_update_queue_args)
+#define KFD_IOC_GET_PROCESS_APERTURES	_IOR(KFD_IOC_MAGIC, 6, struct kfd_ioctl_get_process_apertures_args)
+#define KFD_IOC_UPDATE_QUEUE		_IOW(KFD_IOC_MAGIC, 7, struct kfd_ioctl_update_queue_args)
 #define KFD_IOC_PMC_ACQUIRE_ACCESS	_IOW(KFD_IOC_MAGIC, 12, struct kfd_ioctl_pmc_acquire_access_args)
 #define KFD_IOC_PMC_RELEASE_ACCESS	_IOW(KFD_IOC_MAGIC, 13, struct kfd_ioctl_pmc_release_access_args)
 
-- 
1.9.1
