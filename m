From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [RFC PATCH] mtd: add an MTD_IS_PARTITION flag
Date: Thu, 30 Jul 2015 14:14:00 +0200
Message-ID: <1438258440-21459-1-git-send-email-boris.brezillon@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Boris Brezillon <boris.brezillon@free-electrons.com>
List-Id: linux-api@vger.kernel.org

Add an MTD_IS_PARTITION flag so that the test to check whether an
MTD device is a partition or not is faster.
This also allows user-space programs to know whether they are
manipulating a partition or a real device.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/mtd/mtdpart.c      | 14 ++------------
 include/uapi/mtd/mtd-abi.h |  1 +
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 919a936..3dc479f 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -370,6 +370,7 @@ static struct mtd_part *allocate_partition(struct mtd_info *master,
 	/* set up the MTD object for this partition */
 	slave->mtd.type = master->type;
 	slave->mtd.flags = master->flags & ~part->mask_flags;
+	slave->mtd.flags |= MTD_IS_PARTITION;
 	slave->mtd.size = part->size;
 	slave->mtd.writesize = master->writesize;
 	slave->mtd.writebufsize = master->writebufsize;
@@ -779,18 +780,7 @@ int parse_mtd_partitions(struct mtd_info *master, const char *const *types,
 
 int mtd_is_partition(const struct mtd_info *mtd)
 {
-	struct mtd_part *part;
-	int ispart = 0;
-
-	mutex_lock(&mtd_partitions_mutex);
-	list_for_each_entry(part, &mtd_partitions, list)
-		if (&part->mtd == mtd) {
-			ispart = 1;
-			break;
-		}
-	mutex_unlock(&mtd_partitions_mutex);
-
-	return ispart;
+	return mtd->flags & MTD_IS_PARTITION;
 }
 EXPORT_SYMBOL_GPL(mtd_is_partition);
 
diff --git a/include/uapi/mtd/mtd-abi.h b/include/uapi/mtd/mtd-abi.h
index 763bb69..ffc1903 100644
--- a/include/uapi/mtd/mtd-abi.h
+++ b/include/uapi/mtd/mtd-abi.h
@@ -103,6 +103,7 @@ struct mtd_write_req {
 #define MTD_BIT_WRITEABLE	0x800	/* Single bits can be flipped */
 #define MTD_NO_ERASE		0x1000	/* No erase necessary */
 #define MTD_POWERUP_LOCK	0x2000	/* Always locked after reset */
+#define MTD_IS_PARTITION	0x4000	/* Device is an MTD partition */
 
 /* Some common devices / combinations of capabilities */
 #define MTD_CAP_ROM		0
-- 
1.9.1
