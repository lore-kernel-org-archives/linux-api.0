From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 3/5] sd: implement the Persistent Reservation API
Date: Wed, 26 Aug 2015 18:56:52 +0200
Message-ID: <1440608214-14497-4-git-send-email-hch@lst.de>
References: <1440608214-14497-1-git-send-email-hch@lst.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440608214-14497-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is a mostly trivial mapping to the PERSISTENT RESERVE IN/OUT
commands.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/scsi/sd.c | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 160e44e..df8e667 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -51,6 +51,7 @@
 #include <linux/async.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/pr.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 
@@ -1535,6 +1536,98 @@ static int sd_compat_ioctl(struct block_device *bdev, fmode_t mode,
 }
 #endif
 
+static char sd_pr_type(enum pr_type type)
+{
+	switch (type) {
+	case PR_WRITE_EXCLUSIVE:
+		return 0x01;
+	case PR_EXCLUSIVE_ACCESS:
+		return 0x03;
+	case PR_WRITE_EXCLUSIVE_REG_ONLY:
+		return 0x05;
+	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
+		return 0x06;
+	case PR_WRITE_EXCLUSIVE_ALL_REGS:
+		return 0x07;
+	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
+		return 0x08;
+	default:
+		return 0;
+	}
+};
+
+static int sd_pr_command(struct block_device *bdev, u8 sa,
+		u64 key, u64 sa_key, u8 type, u8 flags)
+{
+	struct scsi_device *sdev = scsi_disk(bdev->bd_disk)->device;
+	struct scsi_sense_hdr sshdr;
+	int result;
+	u8 cmd[16] = { 0, };
+	u8 data[24] = { 0, };
+
+	cmd[0] = PERSISTENT_RESERVE_OUT;
+	cmd[1] = sa;
+	cmd[2] = type;
+	put_unaligned_be32(sizeof(data), &cmd[5]);
+
+	put_unaligned_be64(key, &data[0]);
+	put_unaligned_be64(sa_key, &data[8]);
+	data[20] = flags;
+
+	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, &data, sizeof(data),
+			&sshdr, SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+
+	if ((driver_byte(result) & DRIVER_SENSE) &&
+	    (scsi_sense_valid(&sshdr))) {
+		sdev_printk(KERN_INFO, sdev, "PR command failed: %d\n", result);
+		scsi_print_sense_hdr(sdev, NULL, &sshdr);
+	}
+
+	return result;
+}
+
+static int sd_pr_register(struct block_device *bdev, u64 old_key, u64 new_key,
+		u32 flags)
+{
+	return sd_pr_command(bdev, (flags & PR_FL_IGNORE_KEY) ? 0x06 : 0x00,
+			old_key, new_key, 0,
+			(1 << 0) /* APTPL */ |
+			(1 << 2) /* ALL_TG_PT */);
+}
+
+static int sd_pr_reserve(struct block_device *bdev, u64 key, enum pr_type type,
+		u32 flags)
+{
+	if (flags)
+		return -EOPNOTSUPP;
+	return sd_pr_command(bdev, 0x01, key, 0, sd_pr_type(type), 0);
+}
+
+static int sd_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
+{
+	return sd_pr_command(bdev, 0x02, key, 0, sd_pr_type(type), 0);
+}
+
+static int sd_pr_preempt(struct block_device *bdev, u64 old_key, u64 new_key,
+		enum pr_type type, bool abort)
+{
+	return sd_pr_command(bdev, abort ? 0x05 : 0x04, old_key, new_key,
+			     sd_pr_type(type), 0);
+}
+
+static int sd_pr_clear(struct block_device *bdev, u64 key)
+{
+	return sd_pr_command(bdev, 0x03, key, 0, 0, 0);
+}
+
+static const struct pr_ops sd_pr_ops = {
+	.pr_register	= sd_pr_register,
+	.pr_reserve	= sd_pr_reserve,
+	.pr_release	= sd_pr_release,
+	.pr_preempt	= sd_pr_preempt,
+	.pr_clear	= sd_pr_clear,
+};
+
 static const struct block_device_operations sd_fops = {
 	.owner			= THIS_MODULE,
 	.open			= sd_open,
@@ -1547,6 +1640,7 @@ static const struct block_device_operations sd_fops = {
 	.check_events		= sd_check_events,
 	.revalidate_disk	= sd_revalidate_disk,
 	.unlock_native_capacity	= sd_unlock_native_capacity,
+	.pr_ops			= &sd_pr_ops,
 };
 
 /**
-- 
1.9.1
