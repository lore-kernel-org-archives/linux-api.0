From: Oded Gabbay <oded.gabbay@gmail.com>
Subject: [PATCH 44/83] hsa/radeon: HSA64/HSA32 modes support
Date: Fri, 11 Jul 2014 00:54:00 +0300
Message-ID: <1405029279-6894-16-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>, Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>, Andrew Lewycky <Andrew.Lewycky@amd.com>, Joerg Roedel <joro@8bytes.org>, Alexey Skidanov <Alexey.Skidanov@amd.com>, Oded Gabbay <oded.gabbay@amd.com>, Evgeny Pinchuk <evgeny.pinchuk@amd.com>, Ben Goz <ben.goz@amd.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Alexey Skidanov <Alexey.Skidanov@amd.com>

Added apertures initialization and appropriate ioctl

Signed-off-by: Alexey Skidanov <Alexey.Skidanov@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/Makefile               |   2 +-
 drivers/gpu/hsa/radeon/kfd_aperture.c         | 124 ++++++++++++++++++++++++++
 drivers/gpu/hsa/radeon/kfd_chardev.c          |  58 +++++++++++-
 drivers/gpu/hsa/radeon/kfd_priv.h             |  18 ++++
 drivers/gpu/hsa/radeon/kfd_process.c          |  17 ++++
 drivers/gpu/hsa/radeon/kfd_sched_cik_static.c |   3 +-
 drivers/gpu/hsa/radeon/kfd_topology.c         |  27 ++++++
 include/uapi/linux/kfd_ioctl.h                |  18 ++++
 8 files changed, 264 insertions(+), 3 deletions(-)
 create mode 100644 drivers/gpu/hsa/radeon/kfd_aperture.c

diff --git a/drivers/gpu/hsa/radeon/Makefile b/drivers/gpu/hsa/radeon/Makefile
index 5422e6a..813b31f 100644
--- a/drivers/gpu/hsa/radeon/Makefile
+++ b/drivers/gpu/hsa/radeon/Makefile
@@ -5,6 +5,6 @@
 radeon_kfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o \
 		kfd_pasid.o kfd_topology.o kfd_process.o \
 		kfd_doorbell.o kfd_sched_cik_static.o kfd_registers.o \
-		kfd_vidmem.o kfd_interrupt.o
+		kfd_vidmem.o kfd_interrupt.o kfd_aperture.o
 
 obj-$(CONFIG_HSA_RADEON)	+= radeon_kfd.o
diff --git a/drivers/gpu/hsa/radeon/kfd_aperture.c b/drivers/gpu/hsa/radeon/kfd_aperture.c
new file mode 100644
index 0000000..9e2d6da
--- /dev/null
+++ b/drivers/gpu/hsa/radeon/kfd_aperture.c
@@ -0,0 +1,124 @@
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
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/compat.h>
+#include <uapi/linux/kfd_ioctl.h>
+#include <linux/time.h>
+#include "kfd_priv.h"
+#include "kfd_scheduler.h"
+#include <linux/mm.h>
+#include <uapi/asm-generic/mman-common.h>
+#include <asm/processor.h>
+
+
+#define MAKE_GPUVM_APP_BASE(gpu_num) (((uint64_t)(gpu_num) << 61) + 0x1000000000000)
+#define MAKE_GPUVM_APP_LIMIT(base) (((uint64_t)(base) & 0xFFFFFF0000000000) | 0xFFFFFFFFFF)
+#define MAKE_SCRATCH_APP_BASE(gpu_num) (((uint64_t)(gpu_num) << 61) + 0x100000000)
+#define MAKE_SCRATCH_APP_LIMIT(base) (((uint64_t)base & 0xFFFFFFFF00000000) | 0xFFFFFFFF)
+#define MAKE_LDS_APP_BASE(gpu_num) (((uint64_t)(gpu_num) << 61) + 0x0)
+#define MAKE_LDS_APP_LIMIT(base) (((uint64_t)(base) & 0xFFFFFFFF00000000) | 0xFFFFFFFF)
+
+#define HSA_32BIT_LDS_APP_SIZE 0x10000
+#define HSA_32BIT_LDS_APP_ALIGNMENT 0x10000
+
+static unsigned long kfd_reserve_aperture(struct kfd_process *process, unsigned long len, unsigned long alignment)
+{
+
+	unsigned long addr = 0;
+	unsigned long start_address;
+
+	/*
+	 * Go bottom up and find the first available aligned address.
+	 * We may narrow space to scan by getting mmap range limits.
+	 */
+	for (start_address =  alignment; start_address < (TASK_SIZE - alignment); start_address += alignment) {
+		addr = vm_mmap(NULL, start_address, len, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, 0);
+		if (!IS_ERR_VALUE(addr)) {
+			if (addr == start_address)
+				return addr;
+			vm_munmap(addr, len);
+		}
+	}
+	return 0;
+
+}
+
+int kfd_init_apertures(struct kfd_process *process)
+{
+	uint8_t id  = 0;
+	struct kfd_dev *dev;
+	struct kfd_process_device *pdd;
+
+	mutex_lock(&process->mutex);
+
+	/*Iterating over all devices*/
+	while ((dev = kfd_topology_enum_kfd_devices(id)) != NULL && id < NUM_OF_SUPPORTED_GPUS) {
+
+		pdd = radeon_kfd_get_process_device_data(dev, process);
+
+		/*for 64 bit process aperture will be statically reserved in the non canonical process address space
+		 *for 32 bit process the aperture will be reserved in the process address space
+		 */
+		if (process->is_32bit_user_mode) {
+			/*try to reserve aperture. continue on failure, just put the aperture size to be 0*/
+			pdd->lds_base = kfd_reserve_aperture(
+						process,
+						HSA_32BIT_LDS_APP_SIZE,
+						HSA_32BIT_LDS_APP_ALIGNMENT);
+
+			if (pdd->lds_base)
+				pdd->lds_limit = pdd->lds_base + HSA_32BIT_LDS_APP_SIZE - 1;
+			else
+				pdd->lds_limit = 0;
+
+			/*GPUVM and Scratch apertures are not supported*/
+			pdd->gpuvm_base = pdd->gpuvm_limit = pdd->scratch_base = pdd->scratch_limit = 0;
+		} else {
+			/*node id couldn't be 0 - the three MSB bits of aperture shoudn't be 0*/
+			pdd->lds_base = MAKE_LDS_APP_BASE(id + 1);
+			pdd->lds_limit = MAKE_LDS_APP_LIMIT(pdd->lds_base);
+			pdd->gpuvm_base = MAKE_GPUVM_APP_BASE(id + 1);
+			pdd->gpuvm_limit = MAKE_GPUVM_APP_LIMIT(pdd->gpuvm_base);
+			pdd->scratch_base = MAKE_SCRATCH_APP_BASE(id + 1);
+			pdd->scratch_limit = MAKE_SCRATCH_APP_LIMIT(pdd->scratch_base);
+		}
+
+		dev_dbg(kfd_device, "node id %u, gpu id %u, lds_base %llX lds_limit %llX gpuvm_base %llX gpuvm_limit %llX scratch_base %llX scratch_limit %llX",
+				id, pdd->dev->id, pdd->lds_base, pdd->lds_limit, pdd->gpuvm_base, pdd->gpuvm_limit, pdd->scratch_base, pdd->scratch_limit);
+
+		id++;
+	}
+
+	mutex_unlock(&process->mutex);
+
+	return 0;
+}
+
+
diff --git a/drivers/gpu/hsa/radeon/kfd_chardev.c b/drivers/gpu/hsa/radeon/kfd_chardev.c
index e95d597..07cac88 100644
--- a/drivers/gpu/hsa/radeon/kfd_chardev.c
+++ b/drivers/gpu/hsa/radeon/kfd_chardev.c
@@ -32,6 +32,9 @@
 #include <linux/time.h>
 #include "kfd_priv.h"
 #include "kfd_scheduler.h"
+#include <linux/mm.h>
+#include <uapi/asm-generic/mman-common.h>
+#include <asm/processor.h>
 
 static long kfd_ioctl(struct file *, unsigned int, unsigned long);
 static int kfd_open(struct inode *, struct file *);
@@ -107,9 +110,13 @@ kfd_open(struct inode *inode, struct file *filep)
 	process = radeon_kfd_create_process(current);
 	if (IS_ERR(process))
 		return PTR_ERR(process);
+
 	process->is_32bit_user_mode = is_compat_task();
+
 	dev_info(kfd_device, "process %d opened, compat mode (32 bit) - %d\n",
-				process->pasid, process->is_32bit_user_mode);
+			process->pasid, process->is_32bit_user_mode);
+
+	kfd_init_apertures(process);
 
 	return 0;
 }
@@ -321,6 +328,51 @@ kfd_ioctl_get_clock_counters(struct file *filep, struct kfd_process *p, void __u
 	return 0;
 }
 
+
+static int kfd_ioctl_get_process_apertures(struct file *filp, struct kfd_process *p, void __user *arg)
+{
+	struct kfd_ioctl_get_process_apertures_args args;
+	struct kfd_process_device *pdd;
+
+	dev_dbg(kfd_device, "get apertures for PASID %d", p->pasid);
+
+	if (copy_from_user(&args, arg, sizeof(args)))
+		return -EFAULT;
+
+	args.num_of_nodes = 0;
+
+	mutex_lock(&p->mutex);
+
+	/*if the process-device list isn't empty*/
+	if (kfd_has_process_device_data(p)) {
+		/* Run over all pdd of the process */
+		pdd = kfd_get_first_process_device_data(p);
+		do {
+
+			args.process_apertures[args.num_of_nodes].gpu_id = pdd->dev->id;
+			args.process_apertures[args.num_of_nodes].lds_base = pdd->lds_base;
+			args.process_apertures[args.num_of_nodes].lds_limit = pdd->lds_limit;
+			args.process_apertures[args.num_of_nodes].gpuvm_base = pdd->gpuvm_base;
+			args.process_apertures[args.num_of_nodes].gpuvm_limit = pdd->gpuvm_limit;
+			args.process_apertures[args.num_of_nodes].scratch_base = pdd->scratch_base;
+			args.process_apertures[args.num_of_nodes].scratch_limit = pdd->scratch_limit;
+
+			dev_dbg(kfd_device, "node id %u, gpu id %u, lds_base %llX lds_limit %llX gpuvm_base %llX gpuvm_limit %llX scratch_base %llX scratch_limit %llX",
+					args.num_of_nodes, pdd->dev->id, pdd->lds_base, pdd->lds_limit, pdd->gpuvm_base, pdd->gpuvm_limit, pdd->scratch_base, pdd->scratch_limit);
+			args.num_of_nodes++;
+		} while ((pdd = kfd_get_next_process_device_data(p, pdd)) != NULL &&
+				(args.num_of_nodes < NUM_OF_SUPPORTED_GPUS));
+	}
+
+	mutex_unlock(&p->mutex);
+
+	if (copy_to_user(arg, &args, sizeof(args)))
+		return -EFAULT;
+
+	return 0;
+}
+
+
 static long
 kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
@@ -352,6 +404,10 @@ kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		err = kfd_ioctl_get_clock_counters(filep, process, (void __user *)arg);
 		break;
 
+	case KFD_IOC_GET_PROCESS_APERTURES:
+		err = kfd_ioctl_get_process_apertures(filep, process, (void __user *)arg);
+		break;
+
 	default:
 		dev_err(kfd_device,
 			"unknown ioctl cmd 0x%x, arg 0x%lx)\n",
diff --git a/drivers/gpu/hsa/radeon/kfd_priv.h b/drivers/gpu/hsa/radeon/kfd_priv.h
index 9d3b1fc..28155bc 100644
--- a/drivers/gpu/hsa/radeon/kfd_priv.h
+++ b/drivers/gpu/hsa/radeon/kfd_priv.h
@@ -171,6 +171,16 @@ struct kfd_process_device {
 
 	/* Is this process/pasid bound to this device? (amd_iommu_bind_pasid) */
 	bool bound;
+
+	/*Apertures*/
+	uint64_t lds_base;
+	uint64_t lds_limit;
+	uint64_t gpuvm_base;
+	uint64_t gpuvm_limit;
+	uint64_t scratch_base;
+	uint64_t scratch_limit;
+
+
 };
 
 /* Process data */
@@ -212,6 +222,10 @@ void radeon_kfd_install_queue(struct kfd_process *p, unsigned int queue_id, stru
 void radeon_kfd_remove_queue(struct kfd_process *p, unsigned int queue_id);
 struct kfd_queue *radeon_kfd_get_queue(struct kfd_process *p, unsigned int queue_id);
 
+/* Process device data iterator */
+struct kfd_process_device *kfd_get_first_process_device_data(struct kfd_process *p);
+struct kfd_process_device *kfd_get_next_process_device_data(struct kfd_process *p, struct kfd_process_device *pdd);
+bool kfd_has_process_device_data(struct kfd_process *p);
 
 /* PASIDs */
 int radeon_kfd_pasid_init(void);
@@ -237,6 +251,7 @@ int kfd_topology_add_device(struct kfd_dev *gpu);
 int kfd_topology_remove_device(struct kfd_dev *gpu);
 struct kfd_dev *radeon_kfd_device_by_id(uint32_t gpu_id);
 struct kfd_dev *radeon_kfd_device_by_pci_dev(const struct pci_dev *pdev);
+struct kfd_dev *kfd_topology_enum_kfd_devices(uint8_t idx);
 
 /* MMIO registers */
 #define WRITE_REG(dev, reg, value) radeon_kfd_write_reg((dev), (reg), (value))
@@ -253,4 +268,7 @@ void kgd2kfd_interrupt(struct kfd_dev *dev, const void *ih_ring_entry);
 void kgd2kfd_suspend(struct kfd_dev *dev);
 int kgd2kfd_resume(struct kfd_dev *dev);
 
+/*HSA apertures*/
+int kfd_init_apertures(struct kfd_process *process);
+
 #endif
diff --git a/drivers/gpu/hsa/radeon/kfd_process.c b/drivers/gpu/hsa/radeon/kfd_process.c
index f89f855..80136e6 100644
--- a/drivers/gpu/hsa/radeon/kfd_process.c
+++ b/drivers/gpu/hsa/radeon/kfd_process.c
@@ -397,3 +397,20 @@ struct kfd_queue *radeon_kfd_get_queue(struct kfd_process *p, unsigned int queue
 		test_bit(queue_id, p->allocated_queue_bitmap)) ?
 			p->queues[queue_id] : NULL;
 }
+
+struct kfd_process_device *kfd_get_first_process_device_data(struct kfd_process *p)
+{
+	return list_first_entry(&p->per_device_data, struct kfd_process_device, per_device_list);
+}
+
+struct kfd_process_device *kfd_get_next_process_device_data(struct kfd_process *p, struct kfd_process_device *pdd)
+{
+	if (list_is_last(&pdd->per_device_list, &p->per_device_data))
+		return NULL;
+	return list_next_entry(pdd, per_device_list);
+}
+
+bool kfd_has_process_device_data(struct kfd_process *p)
+{
+	return !(list_empty(&p->per_device_data));
+}
diff --git a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
index 7ee8125..30561a6 100644
--- a/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
+++ b/drivers/gpu/hsa/radeon/kfd_sched_cik_static.c
@@ -627,7 +627,8 @@ static void cik_static_deregister_process(struct kfd_scheduler *scheduler,
 	struct cik_static_private *priv = kfd_scheduler_to_private(scheduler);
 	struct cik_static_process *pp = kfd_process_to_private(scheduler_process);
 
-	if (priv && pp) {
+
+	if (priv && pp)	{
 		release_vmid(priv, pp->vmid);
 		kfree(pp);
 	}
diff --git a/drivers/gpu/hsa/radeon/kfd_topology.c b/drivers/gpu/hsa/radeon/kfd_topology.c
index 21bb66e..213ae7b 100644
--- a/drivers/gpu/hsa/radeon/kfd_topology.c
+++ b/drivers/gpu/hsa/radeon/kfd_topology.c
@@ -1201,3 +1201,30 @@ int kfd_topology_remove_device(struct kfd_dev *gpu)
 
 	return res;
 }
+
+/*
+ * When idx is out of bounds, the function will return NULL
+ */
+struct kfd_dev *kfd_topology_enum_kfd_devices(uint8_t idx)
+{
+
+	struct kfd_topology_device *top_dev;
+	struct kfd_dev *device = NULL;
+	uint8_t device_idx = 0;
+
+	down_read(&topology_lock);
+
+	list_for_each_entry(top_dev, &topology_device_list, list) {
+		if (device_idx == idx) {
+			device = top_dev->gpu;
+			break;
+		}
+
+		device_idx++;
+	}
+
+	up_read(&topology_lock);
+
+	return device;
+
+}
diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
index a7c3abd..e5fcb8b 100644
--- a/include/uapi/linux/kfd_ioctl.h
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -78,6 +78,23 @@ struct kfd_ioctl_get_clock_counters_args {
 	uint64_t system_clock_freq;	/* from KFD */
 };
 
+#define NUM_OF_SUPPORTED_GPUS 7
+
+struct kfd_process_device_apertures {
+	uint64_t lds_base;/* from KFD */
+	uint64_t lds_limit;/* from KFD */
+	uint64_t scratch_base;/* from KFD */
+	uint64_t scratch_limit;/* from KFD */
+	uint64_t gpuvm_base;/* from KFD */
+	uint64_t gpuvm_limit;/* from KFD */
+	uint32_t gpu_id;/* from KFD */
+};
+
+struct kfd_ioctl_get_process_apertures_args {
+	struct kfd_process_device_apertures process_apertures[NUM_OF_SUPPORTED_GPUS];/* from KFD */
+	uint8_t num_of_nodes; /* from KFD, should be in the range [1 - NUM_OF_SUPPORTED_GPUS]*/
+};
+
 #define KFD_IOC_MAGIC 'K'
 
 #define KFD_IOC_GET_VERSION	_IOR(KFD_IOC_MAGIC, 1, struct kfd_ioctl_get_version_args)
@@ -85,6 +102,7 @@ struct kfd_ioctl_get_clock_counters_args {
 #define KFD_IOC_DESTROY_QUEUE	_IOWR(KFD_IOC_MAGIC, 3, struct kfd_ioctl_destroy_queue_args)
 #define KFD_IOC_SET_MEMORY_POLICY	_IOW(KFD_IOC_MAGIC, 4, struct kfd_ioctl_set_memory_policy_args)
 #define KFD_IOC_GET_CLOCK_COUNTERS	_IOWR(KFD_IOC_MAGIC, 5, struct kfd_ioctl_get_clock_counters_args)
+#define KFD_IOC_GET_PROCESS_APERTURES _IOR(KFD_IOC_MAGIC, 6, struct kfd_ioctl_get_process_apertures_args)
 
 #pragma pack(pop)
 
-- 
1.9.1
