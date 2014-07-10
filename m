From: Oded Gabbay <oded.gabbay@gmail.com>
Subject: [PATCH 54/83] hsa/radeon: Switch to new queue scheduler
Date: Fri, 11 Jul 2014 00:54:10 +0300
Message-ID: <1405029279-6894-26-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>, Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>, Andrew Lewycky <Andrew.Lewycky@amd.com>, Joerg Roedel <joro@8bytes.org>, Ben Goz <ben.goz@amd.com>, Oded Gabbay <oded.gabbay@amd.com>, Evgeny Pinchuk <evgeny.pinchuk@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Ben Goz <ben.goz@amd.com>

This patch makes the switch between the old KFD queue scheduler to the new KFD
queue scheduler. The new scheduler supports H/W CP scheduling, over-subscription
of queues and pre-emption of queues.

Signed-off-by: Ben Goz <ben.goz@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_aperture.c  |   1 -
 drivers/gpu/hsa/radeon/kfd_chardev.c   | 107 +++++++++++++++------------------
 drivers/gpu/hsa/radeon/kfd_device.c    |  31 ++++++----
 drivers/gpu/hsa/radeon/kfd_interrupt.c |   4 +-
 drivers/gpu/hsa/radeon/kfd_priv.h      |   2 +
 drivers/gpu/hsa/radeon/kfd_process.c   |  56 ++++-------------
 include/uapi/linux/kfd_ioctl.h         |   4 +-
 7 files changed, 88 insertions(+), 117 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_aperture.c b/drivers/gpu/hsa/radeon/kfd_aperture.c
index 9e2d6da..2c72b21 100644
--- a/drivers/gpu/hsa/radeon/kfd_aperture.c
+++ b/drivers/gpu/hsa/radeon/kfd_aperture.c
@@ -32,7 +32,6 @@
 #include <uapi/linux/kfd_ioctl.h>
 #include <linux/time.h>
 #include "kfd_priv.h"
-#include "kfd_scheduler.h"
 #include <linux/mm.h>
 #include <uapi/asm-generic/mman-common.h>
 #include <asm/processor.h>
diff --git a/drivers/gpu/hsa/radeon/kfd_chardev.c b/drivers/gpu/hsa/radeon/kfd_chardev.c
index 07cac88..bb2ef02 100644
--- a/drivers/gpu/hsa/radeon/kfd_chardev.c
+++ b/drivers/gpu/hsa/radeon/kfd_chardev.c
@@ -31,10 +31,11 @@
 #include <uapi/linux/kfd_ioctl.h>
 #include <linux/time.h>
 #include "kfd_priv.h"
-#include "kfd_scheduler.h"
 #include <linux/mm.h>
 #include <uapi/asm-generic/mman-common.h>
 #include <asm/processor.h>
+#include "kfd_hw_pointer_store.h"
+#include "kfd_device_queue_manager.h"
 
 static long kfd_ioctl(struct file *, unsigned int, unsigned long);
 static int kfd_open(struct inode *, struct file *);
@@ -128,24 +129,36 @@ kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p, void __user *a
 	struct kfd_dev *dev;
 	int err = 0;
 	unsigned int queue_id;
-	struct kfd_queue *queue;
 	struct kfd_process_device *pdd;
+	struct queue_properties q_properties;
+
+	memset(&q_properties, 0, sizeof(struct queue_properties));
 
 	if (copy_from_user(&args, arg, sizeof(args)))
 		return -EFAULT;
 
-	dev = radeon_kfd_device_by_id(args.gpu_id);
-	if (dev == NULL)
-		return -EINVAL;
+	/* need to validate parameters */
+
+	q_properties.is_interop = false;
+	q_properties.queue_percent = args.queue_percentage;
+	q_properties.priority = args.queue_priority;
+	q_properties.queue_address = args.ring_base_address;
+	q_properties.queue_size = args.ring_size;
 
-	queue = kzalloc(
-		offsetof(struct kfd_queue, scheduler_queue) + dev->device_info->scheduler_class->queue_size,
-		GFP_KERNEL);
 
-	if (!queue)
-		return -ENOMEM;
+	pr_debug("%s Arguments: Queue Percentage (%d, %d)\n"
+			"Queue Priority (%d, %d)\n"
+			"Queue Address (0x%llX, 0x%llX)\n"
+			"Queue Size (%u64, %ll)\n",
+			__func__,
+			q_properties.queue_percent, args.queue_percentage,
+			q_properties.priority, args.queue_priority,
+			q_properties.queue_address, args.ring_base_address,
+			q_properties.queue_size, args.ring_size);
 
-	queue->dev = dev;
+	dev = radeon_kfd_device_by_id(args.gpu_id);
+	if (dev == NULL)
+		return -EINVAL;
 
 	mutex_lock(&p->mutex);
 
@@ -159,23 +172,14 @@ kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p, void __user *a
 			p->pasid,
 			dev->id);
 
-	if (!radeon_kfd_allocate_queue_id(p, &queue_id))
-		goto err_allocate_queue_id;
-
-	err = dev->device_info->scheduler_class->create_queue(dev->scheduler, pdd->scheduler_process,
-							      &queue->scheduler_queue,
-							      (void __user *)args.ring_base_address,
-							      args.ring_size,
-							      (void __user *)args.read_pointer_address,
-							      (void __user *)args.write_pointer_address,
-							      radeon_kfd_queue_id_to_doorbell(dev, p, queue_id));
-	if (err)
+	err = pqm_create_queue(&p->pqm, dev, filep, &q_properties, 0, KFD_QUEUE_TYPE_COMPUTE, &queue_id);
+	if (err != 0)
 		goto err_create_queue;
 
-	radeon_kfd_install_queue(p, queue_id, queue);
-
 	args.queue_id = queue_id;
-	args.doorbell_address = (uint64_t)(uintptr_t)radeon_kfd_get_doorbell(filep, p, dev, queue_id);
+	args.read_pointer_address = (uint64_t)q_properties.read_ptr;
+	args.write_pointer_address = (uint64_t)q_properties.write_ptr;
+	args.doorbell_address = (uint64_t)q_properties.doorbell_ptr;
 
 	if (copy_to_user(arg, &args, sizeof(args))) {
 		err = -EFAULT;
@@ -198,12 +202,9 @@ kfd_ioctl_create_queue(struct file *filep, struct kfd_process *p, void __user *a
 	return 0;
 
 err_copy_args_out:
-	dev->device_info->scheduler_class->destroy_queue(dev->scheduler, &queue->scheduler_queue);
+	pqm_destroy_queue(&p->pqm, queue_id);
 err_create_queue:
-	radeon_kfd_remove_queue(p, queue_id);
-err_allocate_queue_id:
 err_bind_process:
-	kfree(queue);
 	mutex_unlock(&p->mutex);
 	return err;
 }
@@ -211,36 +212,25 @@ err_bind_process:
 static int
 kfd_ioctl_destroy_queue(struct file *filp, struct kfd_process *p, void __user *arg)
 {
+	int retval;
 	struct kfd_ioctl_destroy_queue_args args;
-	struct kfd_queue *queue;
-	struct kfd_dev *dev;
 
 	if (copy_from_user(&args, arg, sizeof(args)))
 		return -EFAULT;
 
-	mutex_lock(&p->mutex);
-
-	queue = radeon_kfd_get_queue(p, args.queue_id);
-	if (!queue) {
-		mutex_unlock(&p->mutex);
-		return -EINVAL;
-	}
-
-	dev = queue->dev;
-
 	pr_debug("kfd: destroying queue id %d for PASID %d\n",
-			args.queue_id,
-			p->pasid);
+				args.queue_id,
+				p->pasid);
 
-	radeon_kfd_remove_queue(p, args.queue_id);
-	dev->device_info->scheduler_class->destroy_queue(dev->scheduler, &queue->scheduler_queue);
+	mutex_lock(&p->mutex);
 
-	kfree(queue);
+	retval = pqm_destroy_queue(&p->pqm, args.queue_id);
 
 	mutex_unlock(&p->mutex);
-	return 0;
+	return retval;
 }
 
+
 static long
 kfd_ioctl_set_memory_policy(struct file *filep, struct kfd_process *p, void __user *arg)
 {
@@ -281,12 +271,12 @@ kfd_ioctl_set_memory_policy(struct file *filep, struct kfd_process *p, void __us
 	alternate_policy = (args.alternate_policy == KFD_IOC_CACHE_POLICY_COHERENT)
 			   ? cache_policy_coherent : cache_policy_noncoherent;
 
-	if (!dev->device_info->scheduler_class->set_cache_policy(dev->scheduler,
-								 pdd->scheduler_process,
-								 default_policy,
-								 alternate_policy,
-								 (void __user *)args.alternate_aperture_base,
-								 args.alternate_aperture_size))
+	if (!dev->dqm->set_cache_memory_policy(dev->dqm,
+					 &pdd->qpd,
+					 default_policy,
+					 alternate_policy,
+					 (void __user *)args.alternate_aperture_base,
+					 args.alternate_aperture_size))
 		err = -EINVAL;
 
 out:
@@ -432,11 +422,14 @@ kfd_mmap(struct file *filp, struct vm_area_struct *vma)
 	if (IS_ERR(process))
 		return PTR_ERR(process);
 
-	if (pgoff < KFD_MMAP_DOORBELL_START)
-		return -EINVAL;
-
-	if (pgoff < KFD_MMAP_DOORBELL_END)
+	if (pgoff >= KFD_MMAP_DOORBELL_START && pgoff < KFD_MMAP_DOORBELL_END)
 		return radeon_kfd_doorbell_mmap(process, vma);
 
+	if (pgoff >= KFD_MMAP_RPTR_START && pgoff < KFD_MMAP_RPTR_END)
+		return radeon_kfd_hw_pointer_store_mmap(&process->read_ptr, vma);
+
+	if (pgoff >= KFD_MMAP_WPTR_START && pgoff < KFD_MMAP_WPTR_END)
+		return radeon_kfd_hw_pointer_store_mmap(&process->write_ptr, vma);
+
 	return -EINVAL;
 }
diff --git a/drivers/gpu/hsa/radeon/kfd_device.c b/drivers/gpu/hsa/radeon/kfd_device.c
index 82febf4..c602e16 100644
--- a/drivers/gpu/hsa/radeon/kfd_device.c
+++ b/drivers/gpu/hsa/radeon/kfd_device.c
@@ -25,10 +25,9 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include "kfd_priv.h"
-#include "kfd_scheduler.h"
+#include "kfd_device_queue_manager.h"
 
 static const struct kfd_device_info kaveri_device_info = {
-	.scheduler_class = &radeon_kfd_cik_static_scheduler_class,
 	.max_pasid_bits = 16,
 	.ih_ring_entry_size = 4 * sizeof(uint32_t)
 };
@@ -121,7 +120,11 @@ device_iommu_pasid_init(struct kfd_dev *kfd)
 	}
 
 	pasid_limit = min_t(pasid_t, (pasid_t)1 << kfd->device_info->max_pasid_bits, iommu_info.max_pasids);
-	pasid_limit = min_t(pasid_t, pasid_limit, kfd->doorbell_process_limit);
+	/*
+	 * last pasid is used for kernel queues doorbells
+	 * in the future the last pasid might be used for a kernel thread.
+	 */
+	pasid_limit = min_t(pasid_t, pasid_limit, kfd->doorbell_process_limit - 1);
 
 	err = amd_iommu_init_device(kfd->pdev, pasid_limit);
 	if (err < 0) {
@@ -168,17 +171,26 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 
 	amd_iommu_set_invalidate_ctx_cb(kfd->pdev, iommu_pasid_shutdown_callback);
 
-	if (kfd->device_info->scheduler_class->create(kfd, &kfd->scheduler)) {
+	kfd->dqm = device_queue_manager_init(kfd);
+	if (!kfd->dqm) {
+		kfd_topology_remove_device(kfd);
 		amd_iommu_free_device(kfd->pdev);
 		return false;
 	}
 
-	kfd->device_info->scheduler_class->start(kfd->scheduler);
+	if (kfd->dqm->start(kfd->dqm) != 0) {
+		device_queue_manager_uninit(kfd->dqm);
+		kfd_topology_remove_device(kfd);
+		amd_iommu_free_device(kfd->pdev);
+		return false;
+	}
 
 	kfd->init_complete = true;
 	dev_info(kfd_device, "added device (%x:%x)\n", kfd->pdev->vendor,
 		 kfd->pdev->device);
 
+	pr_debug("kfd: Starting kfd with the following scheduling policy %d\n", sched_policy);
+
 	return true;
 }
 
@@ -188,13 +200,10 @@ void kgd2kfd_device_exit(struct kfd_dev *kfd)
 
 	BUG_ON(err != 0);
 
-	if (kfd->init_complete)
-		kfd->device_info->scheduler_class->stop(kfd->scheduler);
-
 	radeon_kfd_interrupt_exit(kfd);
 
 	if (kfd->init_complete) {
-		kfd->device_info->scheduler_class->destroy(kfd->scheduler);
+		device_queue_manager_uninit(kfd->dqm);
 		amd_iommu_free_device(kfd->pdev);
 	}
 
@@ -206,7 +215,7 @@ void kgd2kfd_suspend(struct kfd_dev *kfd)
 	BUG_ON(kfd == NULL);
 
 	if (kfd->init_complete) {
-		kfd->device_info->scheduler_class->stop(kfd->scheduler);
+		kfd->dqm->stop(kfd->dqm);
 		amd_iommu_free_device(kfd->pdev);
 	}
 }
@@ -225,7 +234,7 @@ int kgd2kfd_resume(struct kfd_dev *kfd)
 		if (err < 0)
 			return -ENXIO;
 		amd_iommu_set_invalidate_ctx_cb(kfd->pdev, iommu_pasid_shutdown_callback);
-		kfd->device_info->scheduler_class->start(kfd->scheduler);
+		kfd->dqm->start(kfd->dqm);
 	}
 
 	return 0;
diff --git a/drivers/gpu/hsa/radeon/kfd_interrupt.c b/drivers/gpu/hsa/radeon/kfd_interrupt.c
index 2179780..1c9ad46 100644
--- a/drivers/gpu/hsa/radeon/kfd_interrupt.c
+++ b/drivers/gpu/hsa/radeon/kfd_interrupt.c
@@ -43,7 +43,6 @@
 #include <linux/slab.h>
 #include <linux/device.h>
 #include "kfd_priv.h"
-#include "kfd_scheduler.h"
 
 #define KFD_INTERRUPT_RING_SIZE 256
 
@@ -162,7 +161,7 @@ static void interrupt_wq(struct work_struct *work)
 	uint32_t ih_ring_entry[DIV_ROUND_UP(dev->device_info->ih_ring_entry_size, sizeof(uint32_t))];
 
 	while (dequeue_ih_ring_entry(dev, ih_ring_entry))
-		dev->device_info->scheduler_class->interrupt_wq(dev->scheduler, ih_ring_entry);
+		;
 }
 
 /* This is called directly from KGD at ISR. */
@@ -171,7 +170,6 @@ void kgd2kfd_interrupt(struct kfd_dev *kfd, const void *ih_ring_entry)
 	spin_lock(&kfd->interrupt_lock);
 
 	if (kfd->interrupts_active
-	    && kfd->device_info->scheduler_class->interrupt_isr(kfd->scheduler, ih_ring_entry)
 	    && enqueue_ih_ring_entry(kfd, ih_ring_entry))
 		schedule_work(&kfd->interrupt_work);
 
diff --git a/drivers/gpu/hsa/radeon/kfd_priv.h b/drivers/gpu/hsa/radeon/kfd_priv.h
index 0af4c71..049671b 100644
--- a/drivers/gpu/hsa/radeon/kfd_priv.h
+++ b/drivers/gpu/hsa/radeon/kfd_priv.h
@@ -441,6 +441,8 @@ void device_queue_manager_uninit(struct device_queue_manager *dqm);
 struct kernel_queue *kernel_queue_init(struct kfd_dev *dev, enum kfd_queue_type type);
 void kernel_queue_uninit(struct kernel_queue *kq);
 
+int get_vmid_from_pasid(struct kfd_dev *dev, pasid_t pasid , unsigned int *vmid);
+
 /* Process Queue Manager */
 struct process_queue_node {
 	struct queue *q;
diff --git a/drivers/gpu/hsa/radeon/kfd_process.c b/drivers/gpu/hsa/radeon/kfd_process.c
index 80136e6..f967c15 100644
--- a/drivers/gpu/hsa/radeon/kfd_process.c
+++ b/drivers/gpu/hsa/radeon/kfd_process.c
@@ -29,7 +29,6 @@
 struct mm_struct;
 
 #include "kfd_priv.h"
-#include "kfd_scheduler.h"
 
 /* Initial size for the array of queues.
  * The allocated size is doubled each time it is exceeded up to MAX_PROCESS_QUEUES. */
@@ -91,52 +90,15 @@ radeon_kfd_get_process(const struct task_struct *thread)
 	return process;
 }
 
-/* Assumes that the kfd_process mutex is held.
- * (Or that it doesn't need to be held because the process is exiting.)
- *
- * dev_filter can be set to only destroy queues for one device.
- * Otherwise all queues for the process are destroyed.
- */
-static void
-destroy_queues(struct kfd_process *p, struct kfd_dev *dev_filter)
-{
-	unsigned long queue_id;
-
-	for_each_set_bit(queue_id, p->allocated_queue_bitmap, MAX_PROCESS_QUEUES) {
-
-		struct kfd_queue *queue = radeon_kfd_get_queue(p, queue_id);
-		struct kfd_dev *dev;
-
-		BUG_ON(queue == NULL);
-
-		dev = queue->dev;
-
-		if (!dev_filter || dev == dev_filter) {
-			struct kfd_process_device *pdd = radeon_kfd_get_process_device_data(dev, p);
-
-			BUG_ON(pdd == NULL); /* A queue exists so pdd must. */
-
-			radeon_kfd_remove_queue(p, queue_id);
-			dev->device_info->scheduler_class->destroy_queue(dev->scheduler, &queue->scheduler_queue);
-
-			kfree(queue);
-		}
-	}
-}
-
 static void free_process(struct kfd_process *p)
 {
 	struct kfd_process_device *pdd, *temp;
 
 	BUG_ON(p == NULL);
 
-	destroy_queues(p, NULL);
-
 	/* doorbell mappings: automatic */
 
 	list_for_each_entry_safe(pdd, temp, &p->per_device_data, per_device_list) {
-		pdd->dev->device_info->scheduler_class->deregister_process(pdd->dev->scheduler, pdd->scheduler_process);
-		pdd->scheduler_process = NULL;
 		amd_iommu_unbind_pasid(pdd->dev->pdev, p->pasid);
 		list_del(&pdd->per_device_list);
 		kfree(pdd);
@@ -202,8 +164,17 @@ static struct kfd_process *create_process(const struct task_struct *thread)
 
 	INIT_LIST_HEAD(&process->per_device_data);
 
+	process->read_ptr.page_mapping = process->write_ptr.page_mapping = NULL;
+	err = pqm_init(&process->pqm, process);
+	if (err != 0)
+		goto err_process_pqm_init;
+
 	return process;
 
+err_process_pqm_init:
+	radeon_kfd_pasid_free(process->pasid);
+	list_del(&process->processes_list);
+	thread->mm->kfd_process = NULL;
 err_alloc:
 	kfree(process->queues);
 	kfree(process);
@@ -222,6 +193,9 @@ radeon_kfd_get_process_device_data(struct kfd_dev *dev, struct kfd_process *p)
 	pdd = kzalloc(sizeof(*pdd), GFP_KERNEL);
 	if (pdd != NULL) {
 		pdd->dev = dev;
+		INIT_LIST_HEAD(&pdd->qpd.queues_list);
+		INIT_LIST_HEAD(&pdd->qpd.priv_queue_list);
+		pdd->qpd.dqm = dev->dqm;
 		list_add(&pdd->per_device_list, &p->per_device_data);
 	}
 
@@ -248,7 +222,6 @@ struct kfd_process_device *radeon_kfd_bind_process_to_device(struct kfd_dev *dev
 	if (err < 0)
 		return ERR_PTR(err);
 
-	err = dev->device_info->scheduler_class->register_process(dev->scheduler, p, &pdd->scheduler_process);
 	if (err < 0) {
 		amd_iommu_unbind_pasid(dev->pdev, p->pasid);
 		return ERR_PTR(err);
@@ -282,10 +255,7 @@ void radeon_kfd_unbind_process_from_device(struct kfd_dev *dev, pasid_t pasid)
 
 	mutex_lock(&p->mutex);
 
-	destroy_queues(p, dev);
-
-	dev->device_info->scheduler_class->deregister_process(dev->scheduler, pdd->scheduler_process);
-	pdd->scheduler_process = NULL;
+	pqm_uninit(&p->pqm);
 
 	/*
 	 * Just mark pdd as unbound, because we still need it to call
diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
index e5fcb8b..5134880 100644
--- a/include/uapi/linux/kfd_ioctl.h
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -47,9 +47,9 @@ struct kfd_ioctl_create_queue_args {
 	uint32_t queue_type;		/* to KFD */
 	uint32_t queue_percentage;	/* to KFD */
 	uint32_t queue_priority;	/* to KFD */
-	uint64_t write_pointer_address;	/* to KFD */
-	uint64_t read_pointer_address;	/* to KFD */
 
+	uint64_t write_pointer_address;	/* from KFD */
+	uint64_t read_pointer_address;	/* from KFD */
 	uint64_t doorbell_address;	/* from KFD */
 	uint32_t queue_id;		/* from KFD */
 };
-- 
1.9.1
