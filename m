From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/5] block: add an API for Persistent Reservations
Date: Wed, 12 Aug 2015 08:23:21 +0200
Message-ID: <1439360604-16192-3-git-send-email-hch@lst.de>
References: <1439360604-16192-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439360604-16192-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This commits adds a driver API and ioctls for controlling Persistent
Reservations s/genericly/generically/ at the block layer.  Persistent
Reservations are supported by SCSI and NVMe and allow controlling who gets
access to a device in a shared storage setup.

Note that we add a pr_ops structure to struct block_device_operations
instead of adding the members directly to avoid bloating all instances
of devices that will never support Persistent Reservations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/block/pr.txt | 107 +++++++++++++++++++++++++++++++++++++++++++++
 block/ioctl.c              |  85 +++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h     |   2 +
 include/linux/pr.h         |  18 ++++++++
 include/uapi/linux/pr.h    |  45 +++++++++++++++++++
 5 files changed, 257 insertions(+)
 create mode 100644 Documentation/block/pr.txt
 create mode 100644 include/linux/pr.h
 create mode 100644 include/uapi/linux/pr.h

diff --git a/Documentation/block/pr.txt b/Documentation/block/pr.txt
new file mode 100644
index 0000000..ccd11c4
--- /dev/null
+++ b/Documentation/block/pr.txt
@@ -0,0 +1,107 @@
+
+Block layer support for Persistent Reservations
+===============================================
+
+The Linux kernel supports a user space interface for simplified
+Persistent Reservations which map to block devices that support
+these (like SCSI). Persistent Reservations allow restricting
+access to block devices to specific initiators in a shared storage
+setup.
+
+This document gives a general overview of the support ioctl commands.
+For a more detailed reference please refer the the SCSI Primary
+Commands standard, specifically the section on Reservations and the
+"PERSISTENT RESERVE IN" and "PERSISTENT RESERVE OUT" commands.
+
+All implementations are expected to ensure the reservations survive
+a power loss and cover all connections in a multi path environment.
+These behaviors are optional in SPC but will be automatically applied
+by Linux.
+
+The following types of reservations are supported:
+
+ - PR_WRITE_EXCLUSIVE
+
+	Only the initiator that owns the reservation can write to the
+	device.  Any initiator can read from the device.
+
+ - PR_EXCLUSIVE_ACCESS
+
+	Only the initiator that owns the reservation can access the
+	device.
+
+ - PR_WRITE_EXCLUSIVE_REG_ONLY
+
+	Only initiators with a registered key can write to the device,
+	Any initiator can read from the device.
+
+ - PR_EXCLUSIVE_ACCESS_REG_ONLY
+
+	Only initiators with a registered key can access the device.
+
+ - PR_WRITE_EXCLUSIVE_ALL_REGS
+
+	Only initiators with a registered key can write to the device,
+	Any initiator can read from the device.
+	All initiators with a registered key are considered reservation
+	holders.
+	Please reference the SPC spec on the meaning of a reservation
+	holder if you want to use this type. 
+
+ - PR_EXCLUSIVE_ACCESS_ALL_REGS
+
+	Only initiators with a registered key can access the device.
+	All initiators with a registered key are considered reservation
+	holders.
+	Please reference the SPC spec on the meaning of a reservation
+	holder if you want to use this type. 
+
+
+1. IOC_PR_REGISTER
+
+This ioctl command registers a new reservation if the new_key argument
+is non-null.  If no existing reservation exists old_key must be zero,
+if an existing reservation should be replaced old_key must contain
+the old reservation key.
+
+If the new_key argument is 0 it unregisters the existing reservation passed
+in old_key.
+
+
+2. IOC_PR_REGISTER_IGNORE
+
+This ioctl command registers a new reservations with the key passed in
+new_key, ignoring and replacing any existing previous reservation.  The
+old_key argument is ignored.
+
+
+3. IOC_PR_RESERVE
+
+This ioctl command reserves the device and thus restricts access for other
+devices based on the type argument.  The key argument must be the existing
+reservation key for the device as acquired by the IOC_PR_REGISTER,
+IOC_PR_REGISTER_IGNORE, IOC_PR_PREEMPT or IOC_PR_PREEMPT_ABORT commands.
+
+
+4. IOC_PR_RELEASE
+
+This ioctl command releases the reservation specified by key and flags
+and thus removes any access restriction implied by it.
+
+
+5. IOC_PR_PREEMPT
+
+This ioctl command releases the existing reservation referred to by
+old_key and replaces it with a a new reservation of type for the
+reservation key new_key.
+
+
+6. IOC_PR_PREEMPT_ABORT
+
+This ioctl command works like IOC_PR_PREEMPT except that it also aborts
+any outstanding command sent over a connection identified by old_key.
+
+7. IOC_PR_CLEAR
+
+This ioctl command unregisters both key and any other reservation key
+registered with the device and drops any existing reservation.
diff --git a/block/ioctl.c b/block/ioctl.c
index df62b47..34d8c77 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -7,6 +7,7 @@
 #include <linux/backing-dev.h>
 #include <linux/fs.h>
 #include <linux/blktrace_api.h>
+#include <linux/pr.h>
 #include <asm/uaccess.h>
 
 static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user *arg)
@@ -295,6 +296,76 @@ int __blkdev_driver_ioctl(struct block_device *bdev, fmode_t mode,
  */
 EXPORT_SYMBOL_GPL(__blkdev_driver_ioctl);
 
+static int blkdev_pr_register(struct block_device *bdev,
+		struct pr_registration __user *arg, bool ignore)
+{
+	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
+	struct pr_registration reg;
+
+	if (!ops || !ops->pr_register)
+		return -EOPNOTSUPP;
+	if (copy_from_user(&reg, arg, sizeof(reg)))
+		return -EFAULT;
+
+	return ops->pr_register(bdev, reg.old_key, reg.new_key, ignore);
+}
+
+static int blkdev_pr_reserve(struct block_device *bdev,
+		struct pr_reservation __user *arg)
+{
+	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
+	struct pr_reservation rsv;
+
+	if (!ops || !ops->pr_reserve)
+		return -EOPNOTSUPP;
+	if (copy_from_user(&rsv, arg, sizeof(rsv)))
+		return -EFAULT;
+
+	return ops->pr_reserve(bdev, rsv.key, rsv.type);
+}
+
+static int blkdev_pr_release(struct block_device *bdev,
+		struct pr_reservation __user *arg)
+{
+	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
+	struct pr_reservation rsv;
+
+	if (!ops || !ops->pr_release)
+		return -EOPNOTSUPP;
+	if (copy_from_user(&rsv, arg, sizeof(rsv)))
+		return -EFAULT;
+
+	return ops->pr_release(bdev, rsv.key, rsv.type);
+}
+
+static int blkdev_pr_preempt(struct block_device *bdev,
+		struct pr_preempt __user *arg, bool abort)
+{
+	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
+	struct pr_preempt p;
+
+	if (!ops || !ops->pr_preempt)
+		return -EOPNOTSUPP;
+	if (copy_from_user(&p, arg, sizeof(p)))
+		return -EFAULT;
+
+	return ops->pr_preempt(bdev, p.old_key, p.new_key, p.type, abort);
+}
+
+static int blkdev_pr_clear(struct block_device *bdev,
+		struct pr_clear __user *arg)
+{
+	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
+	struct pr_clear c;
+
+	if (!ops || !ops->pr_clear)
+		return -EOPNOTSUPP;
+	if (copy_from_user(&c, arg, sizeof(c)))
+		return -EFAULT;
+
+	return ops->pr_clear(bdev, c.key);
+}
+
 /*
  * Is it an unrecognized ioctl? The correct returns are either
  * ENOTTY (final) or ENOIOCTLCMD ("I don't know this one, try a
@@ -477,6 +548,20 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case BLKTRACESETUP:
 	case BLKTRACETEARDOWN:
 		return blk_trace_ioctl(bdev, cmd, argp);
+	case IOC_PR_REGISTER:
+		return blkdev_pr_register(bdev, argp, false);
+	case IOC_PR_REGISTER_IGNORE:
+		return blkdev_pr_register(bdev, argp, true);
+	case IOC_PR_RESERVE:
+		return blkdev_pr_reserve(bdev, argp);
+	case IOC_PR_RELEASE:
+		return blkdev_pr_release(bdev, argp);
+	case IOC_PR_PREEMPT:
+		return blkdev_pr_preempt(bdev, argp, false);
+	case IOC_PR_PREEMPT_ABORT:
+		return blkdev_pr_preempt(bdev, argp, true);
+	case IOC_PR_CLEAR:
+		return blkdev_pr_clear(bdev, argp);
 	default:
 		return __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 	}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 243f29e..a07eec93 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -35,6 +35,7 @@ struct sg_io_hdr;
 struct bsg_job;
 struct blkcg_gq;
 struct blk_flush_queue;
+struct pr_ops;
 
 #define BLKDEV_MIN_RQ	4
 #define BLKDEV_MAX_RQ	128	/* Default maximum */
@@ -1568,6 +1569,7 @@ struct block_device_operations {
 	/* this callback is with swap_lock and sometimes page table lock held */
 	void (*swap_slot_free_notify) (struct block_device *, unsigned long);
 	struct module *owner;
+	const struct pr_ops *pr_ops;
 };
 
 extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,
diff --git a/include/linux/pr.h b/include/linux/pr.h
new file mode 100644
index 0000000..a6f0496
--- /dev/null
+++ b/include/linux/pr.h
@@ -0,0 +1,18 @@
+#ifndef LINUX_PR_H
+#define LINUX_PR_H
+
+#include <uapi/linux/pr.h>
+
+struct pr_ops {
+	int (*pr_register)(struct block_device *bdev, u64 old_key, u64 new_key,
+			bool ignore);
+	int (*pr_reserve)(struct block_device *bdev, u64 key,
+			enum pr_type type);
+	int (*pr_release)(struct block_device *bdev, u64 key,
+			enum pr_type type);
+	int (*pr_preempt)(struct block_device *bdev, u64 old_key, u64 new_key,
+			enum pr_type type, bool abort);
+	int (*pr_clear)(struct block_device *bdev, u64 key);
+};
+
+#endif /* LINUX_PR_H */
diff --git a/include/uapi/linux/pr.h b/include/uapi/linux/pr.h
new file mode 100644
index 0000000..6014d14
--- /dev/null
+++ b/include/uapi/linux/pr.h
@@ -0,0 +1,45 @@
+#ifndef _UAPI_PR_H
+#define _UAPI_PR_H
+
+enum pr_type {
+	PR_WRITE_EXCLUSIVE		= 1,
+	PR_EXCLUSIVE_ACCESS		= 2,
+	PR_WRITE_EXCLUSIVE_REG_ONLY	= 3,
+	PR_EXCLUSIVE_ACCESS_REG_ONLY	= 4,
+	PR_WRITE_EXCLUSIVE_ALL_REGS	= 5,
+	PR_EXCLUSIVE_ACCESS_ALL_REGS	= 6,
+};
+
+struct pr_reservation {
+	__u64	key;
+	__u32	type;
+	__u32	__pad;
+};
+
+struct pr_registration {
+	__u64	old_key;
+	__u64	new_key;
+};
+
+struct pr_preempt {
+	__u64	old_key;
+	__u64	new_key;
+	__u32	type;
+	__u32	__pad;
+};
+
+struct pr_clear {
+	__u64	key;
+};
+
+#define IOC_PR_REGISTER		_IOW('p', 200, struct pr_registration)
+#define IOC_PR_REGISTER_IGNORE	_IOW('p', 201, struct pr_registration)
+
+#define IOC_PR_RESERVE		_IOW('p', 202, struct pr_reservation)
+#define IOC_PR_RELEASE		_IOW('p', 203, struct pr_reservation)
+
+#define IOC_PR_PREEMPT		_IOW('p', 204, struct pr_preempt)
+#define IOC_PR_PREEMPT_ABORT	_IOW('p', 205, struct pr_preempt)
+#define IOC_PR_CLEAR		_IOW('p', 206, struct pr_clear)
+
+#endif /* _UAPI_PR_H */
-- 
1.9.1
