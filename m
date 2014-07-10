From: Oded Gabbay <oded.gabbay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 32/83] hsa/radeon: implementing IOCTL for clock counters
Date: Fri, 11 Jul 2014 00:53:48 +0300
Message-ID: <1405029279-6894-4-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay-5C7GfCeVMHo@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, John Bridgman <John.Bridgman-5C7GfCeVMHo@public.gmane.org>, Andrew Lewycky <Andrew.Lewycky-5C7GfCeVMHo@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Evgeny Pinchuk <evgeny.pinchuk-5C7GfCeVMHo@public.gmane.org>, Oded Gabbay <oded.gabbay-5C7GfCeVMHo@public.gmane.org>, Ben Goz <ben.goz-5C7GfCeVMHo@public.gmane.org>, Alexey Skidanov <Alexey.Skidanov-5C7GfCeVMHo@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Evgeny Pinchuk <evgeny.pinchuk-5C7GfCeVMHo@public.gmane.org>

Implemented new IOCTL to query the CPU and GPU clock counters.

Signed-off-by: Evgeny Pinchuk <evgeny.pinchuk-5C7GfCeVMHo@public.gmane.org>
Signed-off-by: Oded Gabbay <oded.gabbay-5C7GfCeVMHo@public.gmane.org>
---
 drivers/gpu/hsa/radeon/kfd_chardev.c | 37 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kfd_ioctl.h       |  9 +++++++++
 2 files changed, 46 insertions(+)

diff --git a/drivers/gpu/hsa/radeon/kfd_chardev.c b/drivers/gpu/hsa/radeon/kfd_chardev.c
index ddaf357..d6fa980 100644
--- a/drivers/gpu/hsa/radeon/kfd_chardev.c
+++ b/drivers/gpu/hsa/radeon/kfd_chardev.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <uapi/linux/kfd_ioctl.h>
+#include <linux/time.h>
 #include "kfd_priv.h"
 #include "kfd_scheduler.h"
 
@@ -284,6 +285,38 @@ out:
 	return err;
 }
 
+static long
+kfd_ioctl_get_clock_counters(struct file *filep, struct kfd_process *p, void __user *arg)
+{
+	struct kfd_ioctl_get_clock_counters_args args;
+	struct kfd_dev *dev;
+	struct timespec time;
+
+	if (copy_from_user(&args, arg, sizeof(args)))
+		return -EFAULT;
+
+	dev = radeon_kfd_device_by_id(args.gpu_id);
+	if (dev == NULL)
+		return -EINVAL;
+
+	/* Reading GPU clock counter from KGD */
+	args.gpu_clock_counter = kfd2kgd->get_gpu_clock_counter(dev->kgd);
+
+	/* No access to rdtsc. Using raw monotonic time */
+	getrawmonotonic(&time);
+	args.cpu_clock_counter = time.tv_nsec;
+
+	get_monotonic_boottime(&time);
+	args.system_clock_counter = time.tv_nsec;
+
+	/* Since the counter is in nano-seconds we use 1GHz frequency */
+	args.system_clock_freq = 1000000000;
+
+	if (copy_to_user(arg, &args, sizeof(args)))
+		return -EFAULT;
+
+	return 0;
+}
 
 static long
 kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
@@ -312,6 +345,10 @@ kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		err = kfd_ioctl_set_memory_policy(filep, process, (void __user *)arg);
 		break;
 
+	case KFD_IOC_GET_CLOCK_COUNTERS:
+		err = kfd_ioctl_get_clock_counters(filep, process, (void __user *)arg);
+		break;
+
 	default:
 		dev_err(kfd_device,
 			"unknown ioctl cmd 0x%x, arg 0x%lx)\n",
diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
index 928e628..5b9517e 100644
--- a/include/uapi/linux/kfd_ioctl.h
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -70,12 +70,21 @@ struct kfd_ioctl_set_memory_policy_args {
 	uint64_t alternate_aperture_size;	/* to KFD */
 };
 
+struct kfd_ioctl_get_clock_counters_args {
+	uint32_t gpu_id;		/* to KFD */
+	uint64_t gpu_clock_counter;	/* from KFD */
+	uint64_t cpu_clock_counter;	/* from KFD */
+	uint64_t system_clock_counter;	/* from KFD */
+	uint64_t system_clock_freq;	/* from KFD */
+};
+
 #define KFD_IOC_MAGIC 'K'
 
 #define KFD_IOC_GET_VERSION	_IOR(KFD_IOC_MAGIC, 1, struct kfd_ioctl_get_version_args)
 #define KFD_IOC_CREATE_QUEUE	_IOWR(KFD_IOC_MAGIC, 2, struct kfd_ioctl_create_queue_args)
 #define KFD_IOC_DESTROY_QUEUE	_IOWR(KFD_IOC_MAGIC, 3, struct kfd_ioctl_destroy_queue_args)
 #define KFD_IOC_SET_MEMORY_POLICY	_IOW(KFD_IOC_MAGIC, 4, struct kfd_ioctl_set_memory_policy_args)
+#define KFD_IOC_GET_CLOCK_COUNTERS	_IOWR(KFD_IOC_MAGIC, 5, struct kfd_ioctl_get_clock_counters_args)
 
 #pragma pack(pop)
 
-- 
1.9.1
