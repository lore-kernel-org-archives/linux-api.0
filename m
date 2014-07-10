From: Oded Gabbay <oded.gabbay@gmail.com>
Subject: [PATCH 42/83] hsa/radeon: 32-bit processes support
Date: Fri, 11 Jul 2014 00:53:58 +0300
Message-ID: <1405029279-6894-14-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>, Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>, Andrew Lewycky <Andrew.Lewycky@amd.com>, Joerg Roedel <joro@8bytes.org>, Alexey Skidanov <Alexey.Skidanov@amd.com>, Oded Gabbay <oded.gabbay@amd.com>, Ben Goz <ben.goz@amd.com>, Evgeny Pinchuk <evgeny.pinchuk@amd.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Alexey Skidanov <Alexey.Skidanov@amd.com>

Initializing compat_ioctl properly. All ioctls args are packed.

Signed-off-by: Alexey Skidanov <Alexey.Skidanov@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_chardev.c | 7 +++++--
 drivers/gpu/hsa/radeon/kfd_priv.h    | 4 ++++
 include/uapi/linux/kfd_ioctl.h       | 2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_chardev.c b/drivers/gpu/hsa/radeon/kfd_chardev.c
index 75fe11f..e95d597 100644
--- a/drivers/gpu/hsa/radeon/kfd_chardev.c
+++ b/drivers/gpu/hsa/radeon/kfd_chardev.c
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/compat.h>
 #include <uapi/linux/kfd_ioctl.h>
 #include <linux/time.h>
 #include "kfd_priv.h"
@@ -41,6 +42,7 @@ static const char kfd_dev_name[] = "kfd";
 static const struct file_operations kfd_fops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = kfd_ioctl,
+	.compat_ioctl = kfd_ioctl,
 	.open = kfd_open,
 	.mmap = kfd_mmap,
 };
@@ -105,8 +107,9 @@ kfd_open(struct inode *inode, struct file *filep)
 	process = radeon_kfd_create_process(current);
 	if (IS_ERR(process))
 		return PTR_ERR(process);
-
-	pr_debug("\nkfd: process %d opened dev/kfd", process->pasid);
+	process->is_32bit_user_mode = is_compat_task();
+	dev_info(kfd_device, "process %d opened, compat mode (32 bit) - %d\n",
+				process->pasid, process->is_32bit_user_mode);
 
 	return 0;
 }
diff --git a/drivers/gpu/hsa/radeon/kfd_priv.h b/drivers/gpu/hsa/radeon/kfd_priv.h
index 8b877ca..9d3b1fc 100644
--- a/drivers/gpu/hsa/radeon/kfd_priv.h
+++ b/drivers/gpu/hsa/radeon/kfd_priv.h
@@ -194,6 +194,10 @@ struct kfd_process {
 	size_t queue_array_size;
 	struct kfd_queue **queues;	/* Size is queue_array_size, up to MAX_PROCESS_QUEUES. */
 	unsigned long allocated_queue_bitmap[DIV_ROUND_UP(MAX_PROCESS_QUEUES, BITS_PER_LONG)];
+
+	/*Is the user space process 32 bit?*/
+	bool is_32bit_user_mode;
+
 };
 
 struct kfd_process *radeon_kfd_create_process(const struct task_struct *);
diff --git a/include/uapi/linux/kfd_ioctl.h b/include/uapi/linux/kfd_ioctl.h
index 5b9517e..a7c3abd 100644
--- a/include/uapi/linux/kfd_ioctl.h
+++ b/include/uapi/linux/kfd_ioctl.h
@@ -29,7 +29,7 @@
 #define KFD_IOCTL_CURRENT_VERSION 1
 
 /* The 64-bit ABI is the authoritative version. */
-#pragma pack(push, 8)
+#pragma pack(push, 1)
 
 struct kfd_ioctl_get_version_args {
 	uint32_t min_supported_version;	/* from KFD */
-- 
1.9.1
