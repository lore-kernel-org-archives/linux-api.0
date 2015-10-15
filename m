From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/6] sd: implement the Persistent Reservation API
Date: Thu, 15 Oct 2015 14:10:49 +0200
Message-ID: <1444911052-9423-4-git-send-email-hch@lst.de>
References: <1444911052-9423-1-git-send-email-hch@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444911052-9423-1-git-send-email-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@fb.com
Cc: linux-scsi@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, keith.busch@intel.com, dm-devel@redhat.com
List-Id: linux-api@vger.kernel.org

This is a mostly trivial mapping to the PERSISTENT RESERVE IN/OUT
commands.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3f37022..a1eeb20 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -51,6 +51,7 @@
 #include <linux/async.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/pr.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 
@@ -1535,6 +1536,100 @@ static int sd_compat_ioctl(struct block_device *bdev, fmode_t mode,
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
+	if (flags & ~PR_FL_IGNORE_KEY)
+		return -EOPNOTSUPP;
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
@@ -1547,6 +1642,7 @@ static const struct block_device_operations sd_fops = {
 	.check_events		= sd_check_events,
 	.revalidate_disk	= sd_revalidate_disk,
 	.unlock_native_capacity	= sd_unlock_native_capacity,
+	.pr_ops			= &sd_pr_ops,
 };
 
 /**
-- 
1.9.1
