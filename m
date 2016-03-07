From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 25/52] mtd: nand: atmel: switch to mtd_ooblayout_ops
Date: Mon,  7 Mar 2016 10:47:15 +0100
Message-ID: <1457344062-11633-26-git-send-email-boris.brezillon@free-electrons.com>
References: <1457344062-11633-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBB4E46W3AKGQECQRWHBI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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

Implementing the mtd_ooblayout_ops interface is the new way of exposing
ECC/OOB layout to MTD users.

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
---
 drivers/mtd/nand/atmel_nand.c | 84 ++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 46 deletions(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index ac3dd3f..a922193 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -72,30 +72,44 @@ struct atmel_nand_nfc_caps {
 	uint32_t rb_mask;
 };
 
-/* oob layout for large page size
+/*
+ * oob layout for large page size
  * bad block info is on bytes 0 and 1
  * the bytes have to be consecutives to avoid
  * several NAND_CMD_RNDOUT during read
- */
-static struct nand_ecclayout atmel_oobinfo_large = {
-	.eccbytes = 4,
-	.eccpos = {60, 61, 62, 63},
-	.oobfree = {
-		{2, 58}
-	},
-};
-
-/* oob layout for small page size
+ *
+ * oob layout for small page size
  * bad block info is on bytes 4 and 5
  * the bytes have to be consecutives to avoid
  * several NAND_CMD_RNDOUT during read
  */
-static struct nand_ecclayout atmel_oobinfo_small = {
-	.eccbytes = 4,
-	.eccpos = {0, 1, 2, 3},
-	.oobfree = {
-		{6, 10}
-	},
+static int atmel_ooblayout_ecc_sp(struct mtd_info *mtd, int section,
+				  struct mtd_oob_region *oobregion)
+{
+	if (section)
+		return -ERANGE;
+
+	oobregion->length = 4;
+	oobregion->offset = 0;
+
+	return 0;
+}
+
+static int atmel_ooblayout_free_sp(struct mtd_info *mtd, int section,
+				   struct mtd_oob_region *oobregion)
+{
+	if (section)
+		return -ERANGE;
+
+	oobregion->offset = 6;
+	oobregion->length = mtd->oobsize - oobregion->offset;
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops atmel_ooblayout_sp_ops = {
+	.ecc = atmel_ooblayout_ecc_sp,
+	.free = atmel_ooblayout_free_sp,
 };
 
 struct atmel_nfc {
@@ -163,8 +177,6 @@ struct atmel_nand_host {
 	int			*pmecc_delta;
 };
 
-static struct nand_ecclayout atmel_pmecc_oobinfo;
-
 /*
  * Enable NAND.
  */
@@ -483,22 +495,6 @@ static int pmecc_get_ecc_bytes(int cap, int sector_size)
 	return (m * cap + 7) / 8;
 }
 
-static void pmecc_config_ecc_layout(struct nand_ecclayout *layout,
-				    int oobsize, int ecc_len)
-{
-	int i;
-
-	layout->eccbytes = ecc_len;
-
-	/* ECC will occupy the last ecc_len bytes continuously */
-	for (i = 0; i < ecc_len; i++)
-		layout->eccpos[i] = oobsize - ecc_len + i;
-
-	layout->oobfree[0].offset = PMECC_OOB_RESERVED_BYTES;
-	layout->oobfree[0].length =
-		oobsize - ecc_len - layout->oobfree[0].offset;
-}
-
 static void __iomem *pmecc_get_alpha_to(struct atmel_nand_host *host)
 {
 	int table_size;
@@ -1010,8 +1006,8 @@ static void atmel_pmecc_core_init(struct mtd_info *mtd)
 {
 	struct nand_chip *nand_chip = mtd_to_nand(mtd);
 	struct atmel_nand_host *host = nand_get_controller_data(nand_chip);
+	int eccbytes = mtd_ooblayout_count_eccbytes(mtd);
 	uint32_t val = 0;
-	struct nand_ecclayout *ecc_layout;
 	struct mtd_oob_region oobregion;
 
 	pmecc_writel(host->ecc, CTRL, PMECC_CTRL_RST);
@@ -1062,12 +1058,11 @@ static void atmel_pmecc_core_init(struct mtd_info *mtd)
 		| PMECC_CFG_AUTO_DISABLE);
 	pmecc_writel(host->ecc, CFG, val);
 
-	ecc_layout = nand_chip->ecc.layout;
 	pmecc_writel(host->ecc, SAREA, mtd->oobsize - 1);
 	mtd_ooblayout_ecc(mtd, 0, &oobregion);
 	pmecc_writel(host->ecc, SADDR, oobregion.offset);
 	pmecc_writel(host->ecc, EADDR,
-		     oobregion.offset + ecc_layout->eccbytes - 1);
+		     oobregion.offset + eccbytes - 1);
 	/* See datasheet about PMECC Clock Control Register */
 	pmecc_writel(host->ecc, CLK, 2);
 	pmecc_writel(host->ecc, IDR, 0xff);
@@ -1289,11 +1284,8 @@ static int atmel_pmecc_nand_init_params(struct platform_device *pdev,
 			err_no = -EINVAL;
 			goto err;
 		}
-		pmecc_config_ecc_layout(&atmel_pmecc_oobinfo,
-					mtd->oobsize,
-					nand_chip->ecc.total);
 
-		nand_chip->ecc.layout = &atmel_pmecc_oobinfo;
+		mtd_set_ooblayout(mtd, &nand_ooblayout_lp_ops);
 		break;
 	default:
 		dev_warn(host->dev,
@@ -1641,19 +1633,19 @@ static int atmel_hw_nand_init_params(struct platform_device *pdev,
 	/* set ECC page size and oob layout */
 	switch (mtd->writesize) {
 	case 512:
-		nand_chip->ecc.layout = &atmel_oobinfo_small;
+		mtd_set_ooblayout(mtd, &atmel_ooblayout_sp_ops);
 		ecc_writel(host->ecc, MR, ATMEL_ECC_PAGESIZE_528);
 		break;
 	case 1024:
-		nand_chip->ecc.layout = &atmel_oobinfo_large;
+		mtd_set_ooblayout(mtd, &nand_ooblayout_lp_ops);
 		ecc_writel(host->ecc, MR, ATMEL_ECC_PAGESIZE_1056);
 		break;
 	case 2048:
-		nand_chip->ecc.layout = &atmel_oobinfo_large;
+		mtd_set_ooblayout(mtd, &nand_ooblayout_lp_ops);
 		ecc_writel(host->ecc, MR, ATMEL_ECC_PAGESIZE_2112);
 		break;
 	case 4096:
-		nand_chip->ecc.layout = &atmel_oobinfo_large;
+		mtd_set_ooblayout(mtd, &nand_ooblayout_lp_ops);
 		ecc_writel(host->ecc, MR, ATMEL_ECC_PAGESIZE_4224);
 		break;
 	default:
-- 
2.1.4
