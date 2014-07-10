From: Oded Gabbay <oded.gabbay@gmail.com>
Subject: [PATCH 13/83] hsa/radeon: Add 2 new IOCTL to kfd, CREATE_QUEUE and DESTROY_QUEUE
Date: Fri, 11 Jul 2014 00:50:13 +0300
Message-ID: <1405029027-6085-12-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>, Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>, Andrew Lewycky <Andrew.Lewycky@amd.com>, Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>, Ben Goz <ben.goz@amd.com>, Evgeny Pinchuk <evgeny.pinchuk@amd.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patch adds 2 new IOCTL to kfd driver.

The first IOCTL is KFD_IOC_CREATE_QUEUE that is used by the user-mode
application to create a compute queue on the GPU.

The second IOCTL is KFD_IOC_DESTROY_QUEUE that is used by the
user-mode application to destroy an existing compute queue on the GPU.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_chardev.c  | 155 ++++++++++++++++++++++++++++++++++
 drivers/gpu/hsa/radeon/kfd_doorbell.c |  11 +++
 include/uapi/linux/kfd_ioctl.h        |  69 +++++++++++++++
 3 files changed, 235 insertions(+)
 create mode 100644 include/uapi/linux/kfd_ioctl.h

diff --git a/drivers/gpu/hsa/radeon/kfd_chardev.c b/drivers/gpu/hsa/radeon/kfd_chardev.c
index 0b5bc74..4e7d5d0 100644
--- a/drivers/gpu/hsa/radeon/kfd_chardev.c
+++ b/drivers/gpu/hsa/radeon/kfd_chardev.c
@@ -27,11 +27,13 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <uapi/linux/kfd_ioctl.h>
 #include "kfd_priv.h"
 #include "kfd_scheduler.h"
 
 static long kfd_ioctl(struct file *, unsigned int, unsigned long);
 static int kfd_open(struct inode *, struct file *);
+static int kfd_mmap(struct file *, struct vm_area_struct *);
 
 static const char kfd_dev_name[] = "kfd";
 
@@ -108,17 +110,170 @@ kfd_open(struct inode *inode, struct file *filep)
 	return 0;
 }
 
+static long
+kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p, void __user *arg)
+{
+	struct kfd_ioctl_create_queue_args args;
+	struct kfd_dev *dev;
+	int err = 0;
+	unsigned int queue_id;
+	struct kfd_queue *queue;
+	struct kfd_process_device *pdd;
+
+	if (copy_from_user(&args, arg, sizeof(args)))
+		return -EFAULT;
+
+	dev = radeon_kfd_device_by_id(args.gpu_id);
+	if (dev == NULL)
+		return -EINVAL;
+
+	queue = kzalloc(
+		offsetof(struct kfd_queue, scheduler_queue) + dev->device_info->scheduler_class->queue_size,
+		GFP_KERNEL);
+
+	if (!queue)
+		return -ENOMEM;
+
+	queue->dev = dev;
+
+	mutex_lock(&p->mutex);
+
+	pdd = radeon_kfd_bind_process_to_device(dev, p);
+	if (IS_ERR(pdd) < 0) {
+		err = PTR_ERR(pdd);
+		goto err_bind_pasid;
+	}
+
+	pr_debug("kfd: creating queue number %d for PASID %d on GPU 0x%x\n",
+			pdd->queue_count,
+			p->pasid,
+			dev->id);
+
+	if (pdd->queue_count++ == 0) {
+		err = dev->device_info->scheduler_class->register_process(dev->scheduler, p, &pdd->scheduler_process);
+		if (err < 0)
+			goto err_register_process;
+	}
+
+	if (!radeon_kfd_allocate_queue_id(p, &queue_id))
+		goto err_allocate_queue_id;
+
+	err = dev->device_info->scheduler_class->create_queue(dev->scheduler, pdd->scheduler_process,
+							      &queue->scheduler_queue,
+							      (void __user *)args.ring_base_address,
+							      args.ring_size,
+							      (void __user *)args.read_pointer_address,
+							      (void __user *)args.write_pointer_address,
+							      radeon_kfd_queue_id_to_doorbell(dev, p, queue_id));
+	if (err)
+		goto err_create_queue;
+
+	radeon_kfd_install_queue(p, queue_id, queue);
+
+	args.queue_id = queue_id;
+	args.doorbell_address = (uint64_t)(uintptr_t)radeon_kfd_get_doorbell(filep, p, dev, queue_id);
+
+	if (copy_to_user(arg, &args, sizeof(args))) {
+		err = -EFAULT;
+		goto err_copy_args_out;
+	}
+
+	mutex_unlock(&p->mutex);
+
+	pr_debug("kfd: queue id %d was created successfully.\n"
+		 "     ring buffer address == 0x%016llX\n"
+		 "     read ptr address    == 0x%016llX\n"
+		 "     write ptr address   == 0x%016llX\n"
+		 "     doorbell address    == 0x%016llX\n",
+			args.queue_id,
+			args.ring_base_address,
+			args.read_pointer_address,
+			args.write_pointer_address,
+			args.doorbell_address);
+
+	return 0;
+
+err_copy_args_out:
+	dev->device_info->scheduler_class->destroy_queue(dev->scheduler, &queue->scheduler_queue);
+err_create_queue:
+	radeon_kfd_remove_queue(p, queue_id);
+err_allocate_queue_id:
+	if (--pdd->queue_count == 0) {
+		dev->device_info->scheduler_class->deregister_process(dev->scheduler, pdd->scheduler_process);
+		pdd->scheduler_process = NULL;
+	}
+err_register_process:
+err_bind_pasid:
+	kfree(queue);
+	mutex_unlock(&p->mutex);
+	return err;
+}
+
+static int
+kfd_ioctl_destroy_queue(struct file *filp, struct kfd_process *p, void __user *arg)
+{
+	struct kfd_ioctl_destroy_queue_args args;
+	struct kfd_queue *queue;
+	struct kfd_dev *dev;
+	struct kfd_process_device *pdd;
+
+	if (copy_from_user(&args, arg, sizeof(args)))
+		return -EFAULT;
+
+	mutex_lock(&p->mutex);
+
+	queue = radeon_kfd_get_queue(p, args.queue_id);
+	if (!queue) {
+		mutex_unlock(&p->mutex);
+		return -EINVAL;
+	}
+
+	dev = queue->dev;
+
+	pr_debug("kfd: destroying queue id %d for PASID %d\n",
+			args.queue_id,
+			p->pasid);
+
+	radeon_kfd_remove_queue(p, args.queue_id);
+	dev->device_info->scheduler_class->destroy_queue(dev->scheduler, &queue->scheduler_queue);
+
+	kfree(queue);
+
+	pdd = radeon_kfd_get_process_device_data(dev, p);
+	BUG_ON(pdd == NULL); /* Because a queue exists. */
+
+	if (--pdd->queue_count == 0) {
+		dev->device_info->scheduler_class->deregister_process(dev->scheduler, pdd->scheduler_process);
+		pdd->scheduler_process = NULL;
+	}
+
+	mutex_unlock(&p->mutex);
+	return 0;
+}
 
 static long
 kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
+	struct kfd_process *process;
 	long err = -EINVAL;
 
 	dev_info(kfd_device,
 		 "ioctl cmd 0x%x (#%d), arg 0x%lx\n",
 		 cmd, _IOC_NR(cmd), arg);
 
+	process = radeon_kfd_get_process(current);
+	if (IS_ERR(process))
+		return PTR_ERR(process);
+
 	switch (cmd) {
+	case KFD_IOC_CREATE_QUEUE:
+		err = kfd_ioctl_create_queue(filep, process, (void __user *)arg);
+		break;
+
+	case KFD_IOC_DESTROY_QUEUE:
+		err = kfd_ioctl_destroy_queue(filep, process, (void __user *)arg);
+		break;
+
 	default:
 		dev_err(kfd_device,
 			"unknown ioctl cmd 0x%x, arg 0x%lx)\n",
diff --git a/drivers/gpu/hsa/radeon/kfd_doorbell.c b/drivers/gpu/hsa/radeon/kfd_doorbell.c
index e1d8506..3de8a02 100644
--- a/drivers/gpu/hsa/radeon/kfd_doorbell.c
+++ b/drivers/gpu/hsa/radeon/kfd_doorbell.c
@@ -155,3 +155,14 @@ doorbell_t __user *radeon_kfd_get_doorbell(struct file *devkfd, struct kfd_proce
 	return &pdd->doorbell_mapping[doorbell_index];
 }
 
+/*
+ * queue_ids are in the range [0,MAX_PROCESS_QUEUES) and are mapped 1:1
+ * to doorbells with the process's doorbell page
+ */
+unsigned int radeon_kfd_queue_id_to_doorbell(struct kfd_dev *kfd, struct kfd_process *process, unsigned int queue_id)
+{
+	/* doorbell_id_offset accounts for doorbells taken by KGD.
+	 * pasid * doorbell_process_allocation/sizeof(doorbell_t) adjusts to the process's doorbells */
+	return kfd->doorbell_id_offset + process->pasid * (doorbell_process_allocation()/sizeof(doorbell_t)) + queue_id;
+}
+
diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
new file mode 100644
index 0000000..dcc5fe0
--- /dev/null
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -0,0 +1,69 @@
+/*
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
+ */
+
+#ifndef KFD_IOCTL_H_INCLUDED
+#define KFD_IOCTL_H_INCLUDED
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define KFD_IOCTL_CURRENT_VERSION 1
+
+/* The 64-bit ABI is the authoritative version. */
+#pragma pack(push, 8)
+
+struct kfd_ioctl_get_version_args {
+	uint32_t min_supported_version;	/* from KFD */
+	uint32_t max_supported_version;	/* from KFD */
+};
+
+/* For kfd_ioctl_create_queue_args.queue_type. */
+#define KFD_IOC_QUEUE_TYPE_COMPUTE   0
+#define KFD_IOC_QUEUE_TYPE_SDMA      1
+
+struct kfd_ioctl_create_queue_args {
+	uint64_t ring_base_address;	/* to KFD */
+	uint32_t ring_size;		/* to KFD */
+	uint32_t gpu_id;		/* to KFD */
+	uint32_t queue_type;		/* to KFD */
+	uint32_t queue_percentage;	/* to KFD */
+	uint32_t queue_priority;	/* to KFD */
+	uint64_t write_pointer_address;	/* to KFD */
+	uint64_t read_pointer_address;	/* to KFD */
+
+	uint64_t doorbell_address;	/* from KFD */
+	uint32_t queue_id;		/* from KFD */
+};
+
+struct kfd_ioctl_destroy_queue_args {
+	uint32_t queue_id;		/* to KFD */
+};
+
+#define KFD_IOC_MAGIC 'K'
+
+#define KFD_IOC_GET_VERSION	_IOR(KFD_IOC_MAGIC, 1, struct kfd_ioctl_get_version_args)
+#define KFD_IOC_CREATE_QUEUE	_IOWR(KFD_IOC_MAGIC, 2, struct kfd_ioctl_create_queue_args)
+#define KFD_IOC_DESTROY_QUEUE	_IOWR(KFD_IOC_MAGIC, 3, struct kfd_ioctl_destroy_queue_args)
+
+#pragma pack(pop)
+
+#endif
-- 
1.9.1
