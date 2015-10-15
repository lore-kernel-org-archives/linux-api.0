From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] NVMe: Add persistent reservation ops
Date: Thu, 15 Oct 2015 14:10:52 +0200
Message-ID: <1444911052-9423-7-git-send-email-hch@lst.de>
References: <1444911052-9423-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444911052-9423-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com
Cc: keith.busch@intel.com, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Keith Busch <keith.busch@intel.com>

Signed-off-by: Keith Busch <keith.busch@intel.com>
[hch: rebased, set PTPL=1]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/pci.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index ad58ee3..6230608 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -39,8 +39,10 @@
 #include <linux/slab.h>
 #include <linux/t10-pi.h>
 #include <linux/types.h>
+#include <linux/pr.h>
 #include <scsi/sg.h>
 #include <asm-generic/io-64-nonatomic-lo-hi.h>
+#include <asm/unaligned.h>
 
 #include <uapi/linux/nvme_ioctl.h>
 #include "nvme.h"
@@ -2058,6 +2060,98 @@ static int nvme_revalidate_disk(struct gendisk *disk)
 	return 0;
 }
 
+static char nvme_pr_type(enum pr_type type)
+{
+	switch (type) {
+	case PR_WRITE_EXCLUSIVE:
+		return 1;
+	case PR_EXCLUSIVE_ACCESS:
+		return 2;
+	case PR_WRITE_EXCLUSIVE_REG_ONLY:
+		return 3;
+	case PR_EXCLUSIVE_ACCESS_REG_ONLY:
+		return 4;
+	case PR_WRITE_EXCLUSIVE_ALL_REGS:
+		return 5;
+	case PR_EXCLUSIVE_ACCESS_ALL_REGS:
+		return 6;
+	default:
+		return 0;
+	}
+};
+
+static int nvme_pr_command(struct block_device *bdev, u32 cdw10,
+				u64 key, u64 sa_key, u8 op)
+{
+	struct nvme_ns *ns = bdev->bd_disk->private_data;
+	struct nvme_command c;
+	u8 data[16] = { 0, };
+
+	put_unaligned_le64(key, &data[0]);
+	put_unaligned_le64(sa_key, &data[8]);
+
+	memset(&c, 0, sizeof(c));
+	c.common.opcode = op;
+	c.common.nsid = ns->ns_id;
+	c.common.cdw10[0] = cdw10;
+
+	return nvme_submit_sync_cmd(ns->queue, &c, data, 16);
+}
+
+static int nvme_pr_register(struct block_device *bdev, u64 old,
+		u64 new, unsigned flags)
+{
+	u32 cdw10;
+
+	if (flags & ~PR_FL_IGNORE_KEY)
+		return -EOPNOTSUPP;
+
+	cdw10 = old ? 2 : 0;
+	cdw10 |= (flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0;
+	cdw10 |= (1 << 30) | (1 << 31); /* PTPL=1 */
+	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_register);
+}
+
+static int nvme_pr_reserve(struct block_device *bdev, u64 key,
+		enum pr_type type, unsigned flags)
+{
+	u32 cdw10;
+
+	if (flags & ~PR_FL_IGNORE_KEY)
+		return -EOPNOTSUPP;
+
+	cdw10 = nvme_pr_type(type) << 8;
+	cdw10 |= ((flags & PR_FL_IGNORE_KEY) ? 1 << 3 : 0);
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_acquire);
+}
+
+static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
+		enum pr_type type, bool abort)
+{
+	u32 cdw10 = nvme_pr_type(type) << 8 | abort ? 2 : 1;
+	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire);
+}
+
+static int nvme_pr_clear(struct block_device *bdev, u64 key)
+{
+	u32 cdw10 = 1 | key ? 1 << 3 : 0;
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_register);
+}
+
+static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
+{
+	u32 cdw10 = nvme_pr_type(type) << 8 | key ? 1 << 3 : 0;
+	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
+}
+
+static const struct pr_ops nvme_pr_ops = {
+	.pr_register	= nvme_pr_register,
+	.pr_reserve	= nvme_pr_reserve,
+	.pr_release	= nvme_pr_release,
+	.pr_preempt	= nvme_pr_preempt,
+	.pr_clear	= nvme_pr_clear,
+};
+
 static const struct block_device_operations nvme_fops = {
 	.owner		= THIS_MODULE,
 	.ioctl		= nvme_ioctl,
@@ -2066,6 +2160,7 @@ static const struct block_device_operations nvme_fops = {
 	.release	= nvme_release,
 	.getgeo		= nvme_getgeo,
 	.revalidate_disk= nvme_revalidate_disk,
+	.pr_ops		= &nvme_pr_ops,
 };
 
 static int nvme_kthread(void *data)
-- 
1.9.1
