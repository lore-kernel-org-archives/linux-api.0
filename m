From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 36/52] mtd: nand: fsmc: get rid of the
 fsmc_nand_eccplace struct
Date: Mon,  7 Mar 2016 10:47:26 +0100
Message-ID: <1457344062-11633-37-git-send-email-boris.brezillon@free-electrons.com>
References: <1457344062-11633-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBI456W3AKGQEUWFMUQA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1457344062-11633-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Haojian Zhuang <haojian.zhuang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Robert Jarzmik <robert.jarzmik-GANU6spQydw@public.gmane.org>, Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, Nicolas Ferre <nicolas.ferre-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Wenyou Yang <wenyou.yang-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Josh Wu <rainyfeeling-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>, Ezequiel Garcia <ezequiel.garcia-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

Now that mtd_ooblayout_ecc() returns the ECC byte position using the
OOB free method, we can get rid of the fsmc_nand_eccplace struct.

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
---
 drivers/mtd/nand/fsmc_nand.c | 60 +++++++++++---------------------------------
 include/linux/mtd/fsmc.h     | 18 -------------
 2 files changed, 15 insertions(+), 63 deletions(-)

diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index 275a98c..1372040 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -39,35 +39,6 @@
 #include <linux/amba/bus.h>
 #include <mtd/mtd-abi.h>
 
-/*
- * ECC placement definitions in oobfree type format.
- * There are 13 bytes of ecc for every 512 byte block and it has to be read
- * consecutively and immediately after the 512 byte data block for hardware to
- * generate the error bit offsets in 512 byte data.
- * Managing the ecc bytes in the following way makes it easier for software to
- * read ecc bytes consecutive to data bytes. This way is similar to
- * oobfree structure maintained already in generic nand driver
- */
-static struct fsmc_eccplace fsmc_ecc4_lp_place = {
-	.eccplace = {
-		{.offset = 2, .length = 13},
-		{.offset = 18, .length = 13},
-		{.offset = 34, .length = 13},
-		{.offset = 50, .length = 13},
-		{.offset = 66, .length = 13},
-		{.offset = 82, .length = 13},
-		{.offset = 98, .length = 13},
-		{.offset = 114, .length = 13}
-	}
-};
-
-static struct fsmc_eccplace fsmc_ecc4_sp_place = {
-	.eccplace = {
-		{.offset = 0, .length = 4},
-		{.offset = 6, .length = 9}
-	}
-};
-
 static int fsmc_ecc1_ooblayout_ecc(struct mtd_info *mtd, int section,
 				   struct mtd_oob_region *oobregion)
 {
@@ -105,6 +76,12 @@ static const struct mtd_ooblayout_ops fsmc_ecc1_ooblayout_ops = {
 	.free = fsmc_ecc1_ooblayout_free,
 };
 
+/*
+ * ECC placement definitions in oobfree type format.
+ * There are 13 bytes of ecc for every 512 byte block and it has to be read
+ * consecutively and immediately after the 512 byte data block for hardware to
+ * generate the error bit offsets in 512 byte data.
+ */
 static int fsmc_ecc4_ooblayout_ecc(struct mtd_info *mtd, int section,
 				   struct mtd_oob_region *oobregion)
 {
@@ -155,7 +132,6 @@ static const struct mtd_ooblayout_ops fsmc_ecc4_ooblayout_ops = {
  * @partitions:		Partition info for a NAND Flash.
  * @nr_partitions:	Total number of partition of a NAND flash.
  *
- * @ecc_place:		ECC placing locations in oobfree type format.
  * @bank:		Bank number for probed device.
  * @clk:		Clock structure for FSMC.
  *
@@ -175,7 +151,6 @@ struct fsmc_nand_data {
 	struct mtd_partition	*partitions;
 	unsigned int		nr_partitions;
 
-	struct fsmc_eccplace	*ecc_place;
 	unsigned int		bank;
 	struct device		*dev;
 	enum access_mode	mode;
@@ -582,8 +557,6 @@ static void fsmc_write_buf_dma(struct mtd_info *mtd, const uint8_t *buf,
 static int fsmc_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
 				 uint8_t *buf, int oob_required, int page)
 {
-	struct fsmc_nand_data *host = mtd_to_fsmc(mtd);
-	struct fsmc_eccplace *ecc_place = host->ecc_place;
 	int i, j, s, stat, eccsize = chip->ecc.size;
 	int eccbytes = chip->ecc.bytes;
 	int eccsteps = chip->ecc.steps;
@@ -606,9 +579,15 @@ static int fsmc_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
 		chip->read_buf(mtd, p, eccsize);
 
 		for (j = 0; j < eccbytes;) {
-			off = ecc_place->eccplace[group].offset;
-			len = ecc_place->eccplace[group].length;
-			group++;
+			struct mtd_oob_region oobregion;
+			int ret;
+
+			ret = mtd_ooblayout_ecc(mtd, group++, &oobregion);
+			if (ret)
+				return ret;
+
+			off = oobregion.offset;
+			len = oobregion.length;
 
 			/*
 			 * length is intentionally kept a higher multiple of 2
@@ -956,19 +935,10 @@ static int __init fsmc_nand_probe(struct platform_device *pdev)
 	if (AMBA_REV_BITS(host->pid) >= 8) {
 		switch (mtd->oobsize) {
 		case 16:
-			host->ecc_place = &fsmc_ecc4_sp_place;
-			break;
 		case 64:
-			host->ecc_place = &fsmc_ecc4_lp_place;
-			break;
 		case 128:
-			host->ecc_place = &fsmc_ecc4_lp_place;
-			break;
 		case 224:
-			host->ecc_place = &fsmc_ecc4_lp_place;
-			break;
 		case 256:
-			host->ecc_place = &fsmc_ecc4_lp_place;
 			break;
 		default:
 			dev_warn(&pdev->dev, "No oob scheme defined for oobsize %d\n",
diff --git a/include/linux/mtd/fsmc.h b/include/linux/mtd/fsmc.h
index c8be32e..ad3c348 100644
--- a/include/linux/mtd/fsmc.h
+++ b/include/linux/mtd/fsmc.h
@@ -103,24 +103,6 @@
 
 #define FSMC_BUSY_WAIT_TIMEOUT	(1 * HZ)
 
-/*
- * There are 13 bytes of ecc for every 512 byte block in FSMC version 8
- * and it has to be read consecutively and immediately after the 512
- * byte data block for hardware to generate the error bit offsets
- * Managing the ecc bytes in the following way is easier. This way is
- * similar to oobfree structure maintained already in u-boot nand driver
- */
-#define MAX_ECCPLACE_ENTRIES	32
-
-struct fsmc_nand_eccplace {
-	uint8_t offset;
-	uint8_t length;
-};
-
-struct fsmc_eccplace {
-	struct fsmc_nand_eccplace eccplace[MAX_ECCPLACE_ENTRIES];
-};
-
 struct fsmc_nand_timings {
 	uint8_t tclr;
 	uint8_t tar;
-- 
2.1.4
