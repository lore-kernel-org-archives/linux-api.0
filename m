From: Oded Gabbay <oded.gabbay@gmail.com>
Subject: [PATCH 55/83] hsa/radeon: Add IOCTL for update queue
Date: Fri, 11 Jul 2014 00:54:11 +0300
Message-ID: <1405029279-6894-27-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>, Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>, Andrew Lewycky <Andrew.Lewycky@amd.com>, Joerg Roedel <joro@8bytes.org>, Ben Goz <ben.goz@amd.com>, Oded Gabbay <oded.gabbay@amd.com>, Evgeny Pinchuk <evgeny.pinchuk@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

This patch adds a new IOCTL that enables the user to perform update to an HSA
queue.

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/cik_mqds.h                  |  1 -
 drivers/gpu/hsa/radeon/kfd_chardev.c               | 29 ++++++++++++++++++++++
 drivers/gpu/hsa/radeon/kfd_device_queue_manager.c  |  1 -
 drivers/gpu/hsa/radeon/kfd_device_queue_manager.h  |  1 -
 drivers/gpu/hsa/radeon/kfd_hw_pointer_store.c      |  1 -
 drivers/gpu/hsa/radeon/kfd_hw_pointer_store.h      |  1 -
 drivers/gpu/hsa/radeon/kfd_kernel_queue.c          |  1 -
 drivers/gpu/hsa/radeon/kfd_kernel_queue.h          |  1 -
 drivers/gpu/hsa/radeon/kfd_mqd_manager.c           |  1 -
 drivers/gpu/hsa/radeon/kfd_mqd_manager.h           |  1 -
 drivers/gpu/hsa/radeon/kfd_packet_manager.c        | 23 ++++++++++++++---
 drivers/gpu/hsa/radeon/kfd_process_queue_manager.c |  1 -
 drivers/gpu/hsa/radeon/kfd_queue.c                 |  1 -
 include/uapi/linux/kfd_ioctl.h                     |  9 +++++++
 14 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/cik_mqds.h b/drivers/gpu/hsa/radeon/cik_mqds.h
index 58945c8..35a35b4 100644
--- a/drivers/gpu/hsa/radeon/cik_mqds.h
+++ b/drivers/gpu/hsa/radeon/cik_mqds.h
@@ -19,7 +19,6 @@
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  * OTHER DEALINGS IN THE SOFTWARE.
  *
- * Author: Ben Goz
  */
 
 #ifndef CIK_MQDS_H_
diff --git a/drivers/gpu/hsa/radeon/kfd_chardev.c b/drivers/gpu/hsa/radeon/kfd_chardev.c
index bb2ef02..9a77332 100644
--- a/drivers/gpu/hsa/radeon/kfd_chardev.c
+++ b/drivers/gpu/hsa/radeon/kfd_chardev.c
@@ -230,6 +230,31 @@ kfd_ioctl_destroy_queue(struct file *filp, struct kfd_process *p, void __user *a
 	return retval;
 }
 
+static int
+kfd_ioctl_update_queue(struct file *filp, struct kfd_process *p, void __user *arg)
+{
+	int retval;
+	struct kfd_ioctl_update_queue_args args;
+	struct queue_properties properties;
+
+	if (copy_from_user(&args, arg, sizeof(args)))
+		return -EFAULT;
+
+	properties.queue_address = args.ring_base_address;
+	properties.queue_size = args.ring_size;
+	properties.queue_percent = args.queue_percentage;
+	properties.priority = args.queue_priority;
+
+	pr_debug("kfd: updating queue id %d for PASID %d\n", args.queue_id, p->pasid);
+
+	mutex_lock(&p->mutex);
+
+	retval = pqm_update_queue(&p->pqm, args.queue_id, &properties);
+
+	mutex_unlock(&p->mutex);
+
+	return retval;
+}
 
 static long
 kfd_ioctl_set_memory_policy(struct file *filep, struct kfd_process *p, void __user *arg)
@@ -398,6 +423,10 @@ kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		err = kfd_ioctl_get_process_apertures(filep, process, (void __user *)arg);
 		break;
 
+	case KFD_IOC_UPDATE_QUEUE:
+		err = kfd_ioctl_update_queue(filep, process, (void __user *)arg);
+		break;
+
 	default:
 		dev_err(kfd_device,
 			"unknown ioctl cmd 0x%x, arg 0x%lx)\n",
diff --git a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
index 9e21074..c2d91c9 100644
--- a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.c
@@ -19,7 +19,6 @@
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  * OTHER DEALINGS IN THE SOFTWARE.
  *
- * Author: Ben Goz
  */
 
 #include <linux/slab.h>
diff --git a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.h b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.h
index 0529a96..fe9ef10 100644
--- a/drivers/gpu/hsa/radeon/kfd_device_queue_manager.h
+++ b/drivers/gpu/hsa/radeon/kfd_device_queue_manager.h
@@ -19,7 +19,6 @@
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  * OTHER DEALINGS IN THE SOFTWARE.
  *
- * Author: Ben Goz
  */
 
 #ifndef DEVICE_QUEUE_MANAGER_H_
diff --git a/drivers/gpu/hsa/radeon/kfd_hw_pointer_store.c b/drivers/gpu/hsa/radeon/kfd_hw_pointer_store.c
index 1372fb2..4e71f7d 100644
--- a/drivers/gpu/hsa/radeon/kfd_hw_pointer_store.c
+++ b/drivers/gpu/hsa/radeon/kfd_hw_pointer_store.c
@@ -19,7 +19,6 @@
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  * OTHER DEALINGS IN THE SOFTWARE.
  *
- * Author: Ben Goz
  */
 
 #include <linux/types.h>
diff --git a/drivers/gpu/hsa/radeon/kfd_hw_pointer_store.h b/drivers/gpu/hsa/radeon/kfd_hw_pointer_store.h
index be1d6cb..f384b7f 100644
--- a/drivers/gpu/hsa/radeon/kfd_hw_pointer_store.h
+++ b/drivers/gpu/hsa/radeon/kfd_hw_pointer_store.h
@@ -19,7 +19,6 @@
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  * OTHER DEALINGS IN THE SOFTWARE.
  *
- * Author: Ben Goz
  */
 
 #ifndef HW_POINTER_STORE_H_
diff --git a/drivers/gpu/hsa/radeon/kfd_kernel_queue.c b/drivers/gpu/hsa/radeon/kfd_kernel_queue.c
index 61f420f..aa64693e 100644
--- a/drivers/gpu/hsa/radeon/kfd_kernel_queue.c
+++ b/drivers/gpu/hsa/radeon/kfd_kernel_queue.c
@@ -19,7 +19,6 @@
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  * OTHER DEALINGS IN THE SOFTWARE.
  *
- * Author: Ben Goz
  */
 
 #include <linux/types.h>
diff --git a/drivers/gpu/hsa/radeon/kfd_kernel_queue.h b/drivers/gpu/hsa/radeon/kfd_kernel_queue.h
index 339376c..963e861 100644
--- a/drivers/gpu/hsa/radeon/kfd_kernel_queue.h
+++ b/drivers/gpu/hsa/radeon/kfd_kernel_queue.h
@@ -19,7 +19,6 @@
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  * OTHER DEALINGS IN THE SOFTWARE.
  *
- * Author: Ben Goz
  */
 
 #ifndef KERNEL_QUEUE_H_
diff --git a/drivers/gpu/hsa/radeon/kfd_mqd_manager.c b/drivers/gpu/hsa/radeon/kfd_mqd_manager.c
index 14b248f..a3e9f7c 100644
--- a/drivers/gpu/hsa/radeon/kfd_mqd_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_mqd_manager.c
@@ -19,7 +19,6 @@
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  * OTHER DEALINGS IN THE SOFTWARE.
  *
- * Author: Ben Goz
  */
 
 #include <linux/printk.h>
diff --git a/drivers/gpu/hsa/radeon/kfd_mqd_manager.h b/drivers/gpu/hsa/radeon/kfd_mqd_manager.h
index e7b39ee..8e7a5fd 100644
--- a/drivers/gpu/hsa/radeon/kfd_mqd_manager.h
+++ b/drivers/gpu/hsa/radeon/kfd_mqd_manager.h
@@ -19,7 +19,6 @@
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  * OTHER DEALINGS IN THE SOFTWARE.
  *
- * Author: Ben Goz
  */
 
 #ifndef MQD_MANAGER_H_
diff --git a/drivers/gpu/hsa/radeon/kfd_packet_manager.c b/drivers/gpu/hsa/radeon/kfd_packet_manager.c
index 4967b7c..3fc8c34 100644
--- a/drivers/gpu/hsa/radeon/kfd_packet_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_packet_manager.c
@@ -1,9 +1,26 @@
 /*
- * packet_manager.c
+ * Copyright 2014 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
  *
- *  Created on: Mar 16, 2014
- *      Author: ben
  */
+
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include "kfd_device_queue_manager.h"
diff --git a/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c b/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c
index 6e38ca4..fe74dd7 100644
--- a/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c
+++ b/drivers/gpu/hsa/radeon/kfd_process_queue_manager.c
@@ -19,7 +19,6 @@
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  * OTHER DEALINGS IN THE SOFTWARE.
  *
- * Author: Ben Goz
  */
 
 #include <linux/slab.h>
diff --git a/drivers/gpu/hsa/radeon/kfd_queue.c b/drivers/gpu/hsa/radeon/kfd_queue.c
index 78fe180..2d22cc1 100644
--- a/drivers/gpu/hsa/radeon/kfd_queue.c
+++ b/drivers/gpu/hsa/radeon/kfd_queue.c
@@ -19,7 +19,6 @@
  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  * OTHER DEALINGS IN THE SOFTWARE.
  *
- * Author: Ben Goz
  */
 
 #include <linux/slab.h>
diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
index 5134880..d58231d 100644
--- a/include/uapi/linux/kfd_ioctl.h
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -58,6 +58,14 @@ struct kfd_ioctl_destroy_queue_args {
 	uint32_t queue_id;		/* to KFD */
 };
 
+struct kfd_ioctl_update_queue_args {
+	uint32_t queue_id;		/* to KFD */
+	uint64_t ring_base_address;	/* to KFD */
+	uint32_t ring_size;		/* to KFD */
+	uint32_t queue_percentage;	/* to KFD */
+	uint32_t queue_priority;	/* to KFD */
+};
+
 /* For kfd_ioctl_set_memory_policy_args.default_policy and alternate_policy */
 #define KFD_IOC_CACHE_POLICY_COHERENT 0
 #define KFD_IOC_CACHE_POLICY_NONCOHERENT 1
@@ -103,6 +111,7 @@ struct kfd_ioctl_get_process_apertures_args {
 #define KFD_IOC_SET_MEMORY_POLICY	_IOW(KFD_IOC_MAGIC, 4, struct kfd_ioctl_set_memory_policy_args)
 #define KFD_IOC_GET_CLOCK_COUNTERS	_IOWR(KFD_IOC_MAGIC, 5, struct kfd_ioctl_get_clock_counters_args)
 #define KFD_IOC_GET_PROCESS_APERTURES _IOR(KFD_IOC_MAGIC, 6, struct kfd_ioctl_get_process_apertures_args)
+#define KFD_IOC_UPDATE_QUEUE	_IOW(KFD_IOC_MAGIC, 7, struct kfd_ioctl_update_queue_args)
 
 #pragma pack(pop)
 
-- 
1.9.1
