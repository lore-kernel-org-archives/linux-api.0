From: Oded Gabbay <oded.gabbay@gmail.com>
Subject: [PATCH 59/83] hsa/radeon: Exclusive access for perf. counters
Date: Fri, 11 Jul 2014 00:54:15 +0300
Message-ID: <1405029279-6894-31-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>, Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>, Andrew Lewycky <Andrew.Lewycky@amd.com>, Joerg Roedel <joro@8bytes.org>, Evgeny Pinchuk <evgeny.pinchuk@amd.com>, Oded Gabbay <oded.gabbay@amd.com>, Ben Goz <ben.goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Evgeny Pinchuk <evgeny.pinchuk@amd.com>

Introducing IOCTL implementation for controlling exclusive access to performace counters.
The exclusive access is per GPU device.

Signed-off-by: Evgeny Pinchuk <evgeny.pinchuk@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_chardev.c | 61 ++++++++++++++++++++++++++++++++++++
 drivers/gpu/hsa/radeon/kfd_device.c  |  2 ++
 drivers/gpu/hsa/radeon/kfd_priv.h    |  5 +++
 drivers/gpu/hsa/radeon/kfd_process.c |  8 +++--
 include/uapi/linux/kfd_ioctl.h       | 12 +++++++
 5 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_chardev.c b/drivers/gpu/hsa/radeon/kfd_chardev.c
index 80b702e..b39df68 100644
--- a/drivers/gpu/hsa/radeon/kfd_chardev.c
+++ b/drivers/gpu/hsa/radeon/kfd_chardev.c
@@ -387,6 +387,59 @@ static int kfd_ioctl_get_process_apertures(struct file *filp, struct kfd_process
 	return 0;
 }
 
+static long
+kfd_ioctl_pmc_acquire_access(struct file *filp, struct kfd_process *p, void __user *arg)
+{
+	struct kfd_ioctl_pmc_acquire_access_args args;
+	struct kfd_dev *dev;
+	int err = -EBUSY;
+
+	if (copy_from_user(&args, arg, sizeof(args)))
+		return -EFAULT;
+
+	dev = radeon_kfd_device_by_id(args.gpu_id);
+	if (dev == NULL)
+		return -EINVAL;
+
+	spin_lock(&dev->pmc_access_lock);
+	if (dev->pmc_locking_process == NULL) {
+		dev->pmc_locking_process = p;
+		dev->pmc_locking_trace = args.trace_id;
+		err = 0;
+	} else if (dev->pmc_locking_process == p && dev->pmc_locking_trace == args.trace_id) {
+		/* Same trace already has an access. Returning success */
+		err = 0;
+	}
+
+	spin_unlock(&dev->pmc_access_lock);
+
+	return err;
+}
+
+static long
+kfd_ioctl_pmc_release_access(struct file *filp, struct kfd_process *p, void __user *arg)
+{
+	struct kfd_ioctl_pmc_release_access_args args;
+	struct kfd_dev *dev;
+	int err = -EINVAL;
+
+	if (copy_from_user(&args, arg, sizeof(args)))
+		return -EFAULT;
+
+	dev = radeon_kfd_device_by_id(args.gpu_id);
+	if (dev == NULL)
+		return -EINVAL;
+
+	spin_lock(&dev->pmc_access_lock);
+	if (dev->pmc_locking_process == p && dev->pmc_locking_trace == args.trace_id) {
+		dev->pmc_locking_process = NULL;
+		dev->pmc_locking_trace = 0;
+		err = 0;
+	}
+	spin_unlock(&dev->pmc_access_lock);
+
+	return err;
+}
 
 static long
 kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
@@ -427,6 +480,14 @@ kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		err = kfd_ioctl_update_queue(filep, process, (void __user *)arg);
 		break;
 
+	case KFD_IOC_PMC_ACQUIRE_ACCESS:
+		err = kfd_ioctl_pmc_acquire_access(filep, process, (void __user *) arg);
+		break;
+
+	case KFD_IOC_PMC_RELEASE_ACCESS:
+		err = kfd_ioctl_pmc_release_access(filep, process, (void __user *) arg);
+		break;
+
 	default:
 		dev_err(kfd_device,
 			"unknown ioctl cmd 0x%x, arg 0x%lx)\n",
diff --git a/drivers/gpu/hsa/radeon/kfd_device.c b/drivers/gpu/hsa/radeon/kfd_device.c
index c602e16..9af812b 100644
--- a/drivers/gpu/hsa/radeon/kfd_device.c
+++ b/drivers/gpu/hsa/radeon/kfd_device.c
@@ -185,6 +185,8 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 		return false;
 	}
 
+	spin_lock_init(&kfd->pmc_access_lock);
+
 	kfd->init_complete = true;
 	dev_info(kfd_device, "added device (%x:%x)\n", kfd->pdev->vendor,
 		 kfd->pdev->device);
diff --git a/drivers/gpu/hsa/radeon/kfd_priv.h b/drivers/gpu/hsa/radeon/kfd_priv.h
index 049671b..e6d4993 100644
--- a/drivers/gpu/hsa/radeon/kfd_priv.h
+++ b/drivers/gpu/hsa/radeon/kfd_priv.h
@@ -135,6 +135,11 @@ struct kfd_dev {
 
 	/* QCM Device instance */
 	struct device_queue_manager *dqm;
+
+	/* Performance counters exclusivity lock */
+	spinlock_t pmc_access_lock;
+	struct kfd_process *pmc_locking_process;
+	uint64_t pmc_locking_trace;
 };
 
 /* KGD2KFD callbacks */
diff --git a/drivers/gpu/hsa/radeon/kfd_process.c b/drivers/gpu/hsa/radeon/kfd_process.c
index f967c15..9bb5cab 100644
--- a/drivers/gpu/hsa/radeon/kfd_process.c
+++ b/drivers/gpu/hsa/radeon/kfd_process.c
@@ -96,9 +96,13 @@ static void free_process(struct kfd_process *p)
 
 	BUG_ON(p == NULL);
 
-	/* doorbell mappings: automatic */
-
 	list_for_each_entry_safe(pdd, temp, &p->per_device_data, per_device_list) {
+		spin_lock(&pdd->dev->pmc_access_lock);
+		if (pdd->dev->pmc_locking_process == p) {
+			pdd->dev->pmc_locking_process = NULL;
+			pdd->dev->pmc_locking_trace = 0;
+		}
+		spin_unlock(&pdd->dev->pmc_access_lock);
 		amd_iommu_unbind_pasid(pdd->dev->pdev, p->pasid);
 		list_del(&pdd->per_device_list);
 		kfree(pdd);
diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
index d58231d..509c4a0 100644
--- a/include/uapi/linux/kfd_ioctl.h
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -103,6 +103,16 @@ struct kfd_ioctl_get_process_apertures_args {
 	uint8_t num_of_nodes; /* from KFD, should be in the range [1 - NUM_OF_SUPPORTED_GPUS]*/
 };
 
+struct kfd_ioctl_pmc_acquire_access_args {
+	uint32_t gpu_id;	/* to KFD */
+	uint64_t trace_id;	/* to KFD */
+};
+
+struct kfd_ioctl_pmc_release_access_args {
+	uint32_t gpu_id;	/* to KFD */
+	uint64_t trace_id;	/* to KFD */
+};
+
 #define KFD_IOC_MAGIC 'K'
 
 #define KFD_IOC_GET_VERSION	_IOR(KFD_IOC_MAGIC, 1, struct kfd_ioctl_get_version_args)
@@ -112,6 +122,8 @@ struct kfd_ioctl_get_process_apertures_args {
 #define KFD_IOC_GET_CLOCK_COUNTERS	_IOWR(KFD_IOC_MAGIC, 5, struct kfd_ioctl_get_clock_counters_args)
 #define KFD_IOC_GET_PROCESS_APERTURES _IOR(KFD_IOC_MAGIC, 6, struct kfd_ioctl_get_process_apertures_args)
 #define KFD_IOC_UPDATE_QUEUE	_IOW(KFD_IOC_MAGIC, 7, struct kfd_ioctl_update_queue_args)
+#define KFD_IOC_PMC_ACQUIRE_ACCESS	_IOW(KFD_IOC_MAGIC, 12, struct kfd_ioctl_pmc_acquire_access_args)
+#define KFD_IOC_PMC_RELEASE_ACCESS	_IOW(KFD_IOC_MAGIC, 13, struct kfd_ioctl_pmc_release_access_args)
 
 #pragma pack(pop)
 
-- 
1.9.1
