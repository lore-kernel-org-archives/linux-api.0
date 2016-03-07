From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 33/52] mtd: nand: fsl_elbc: switch to mtd_ooblayout_ops
Date: Mon,  7 Mar 2016 10:47:23 +0100
Message-ID: <1457344062-11633-34-git-send-email-boris.brezillon@free-electrons.com>
References: <1457344062-11633-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBB7446W3AKGQEAIUAB3Q-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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
 drivers/mtd/nand/fsl_elbc_nand.c | 83 +++++++++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 36 deletions(-)

diff --git a/drivers/mtd/nand/fsl_elbc_nand.c b/drivers/mtd/nand/fsl_elbc_nand.c
index 059d5f7..487eae0 100644
--- a/drivers/mtd/nand/fsl_elbc_nand.c
+++ b/drivers/mtd/nand/fsl_elbc_nand.c
@@ -79,32 +79,53 @@ struct fsl_elbc_fcm_ctrl {
 
 /* These map to the positions used by the FCM hardware ECC generator */
 
-/* Small Page FLASH with FMR[ECCM] = 0 */
-static struct nand_ecclayout fsl_elbc_oob_sp_eccm0 = {
-	.eccbytes = 3,
-	.eccpos = {6, 7, 8},
-	.oobfree = { {0, 5}, {9, 7} },
-};
+static int fsl_elbc_ooblayout_ecc(struct mtd_info *mtd, int section,
+				  struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *chip = mtd_to_nand(mtd);
+	struct fsl_elbc_mtd *priv = nand_get_controller_data(chip);
 
-/* Small Page FLASH with FMR[ECCM] = 1 */
-static struct nand_ecclayout fsl_elbc_oob_sp_eccm1 = {
-	.eccbytes = 3,
-	.eccpos = {8, 9, 10},
-	.oobfree = { {0, 5}, {6, 2}, {11, 5} },
-};
+	if (section >= chip->ecc.steps)
+		return -ERANGE;
 
-/* Large Page FLASH with FMR[ECCM] = 0 */
-static struct nand_ecclayout fsl_elbc_oob_lp_eccm0 = {
-	.eccbytes = 12,
-	.eccpos = {6, 7, 8, 22, 23, 24, 38, 39, 40, 54, 55, 56},
-	.oobfree = { {1, 5}, {9, 13}, {25, 13}, {41, 13}, {57, 7} },
-};
+	oobregion->offset = (16 * section) + 6;
+	if (priv->fmr & FMR_ECCM)
+		oobregion->offset += 2;
 
-/* Large Page FLASH with FMR[ECCM] = 1 */
-static struct nand_ecclayout fsl_elbc_oob_lp_eccm1 = {
-	.eccbytes = 12,
-	.eccpos = {8, 9, 10, 24, 25, 26, 40, 41, 42, 56, 57, 58},
-	.oobfree = { {1, 7}, {11, 13}, {27, 13}, {43, 13}, {59, 5} },
+	oobregion->length = chip->ecc.bytes;
+
+	return 0;
+}
+
+static int fsl_elbc_ooblayout_free(struct mtd_info *mtd, int section,
+				   struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *chip = mtd_to_nand(mtd);
+	struct fsl_elbc_mtd *priv = nand_get_controller_data(chip);
+
+	if (section > chip->ecc.steps)
+		return -ERANGE;
+
+	if (!section) {
+		oobregion->offset = 0;
+		if (mtd->writesize > 512)
+			oobregion->offset++;
+		oobregion->length = (priv->fmr & FMR_ECCM) ? 7 : 5;
+	} else {
+		oobregion->offset = (16 * section) -
+				    ((priv->fmr & FMR_ECCM) ? 5 : 7);
+		if (section < chip->ecc.steps)
+			oobregion->length = 13;
+		else
+			oobregion->length = mtd->oobsize - oobregion->offset;
+	}
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops fsl_elbc_ooblayout_ops = {
+	.ecc = fsl_elbc_ooblayout_ecc,
+	.free = fsl_elbc_ooblayout_free,
 };
 
 /*
@@ -657,8 +678,8 @@ static int fsl_elbc_chip_init_tail(struct mtd_info *mtd)
 	        chip->ecc.bytes);
 	dev_dbg(priv->dev, "fsl_elbc_init: nand->ecc.total = %d\n",
 	        chip->ecc.total);
-	dev_dbg(priv->dev, "fsl_elbc_init: nand->ecc.layout = %p\n",
-	        chip->ecc.layout);
+	dev_dbg(priv->dev, "fsl_elbc_init: mtd->ooblayout = %p\n",
+		mtd->ooblayout);
 	dev_dbg(priv->dev, "fsl_elbc_init: mtd->flags = %08x\n", mtd->flags);
 	dev_dbg(priv->dev, "fsl_elbc_init: mtd->size = %lld\n", mtd->size);
 	dev_dbg(priv->dev, "fsl_elbc_init: mtd->erasesize = %d\n",
@@ -675,14 +696,6 @@ static int fsl_elbc_chip_init_tail(struct mtd_info *mtd)
 	} else if (mtd->writesize == 2048) {
 		priv->page_size = 1;
 		setbits32(&lbc->bank[priv->bank].or, OR_FCM_PGS);
-		/* adjust ecc setup if needed */
-		if ((in_be32(&lbc->bank[priv->bank].br) & BR_DECC) ==
-		    BR_DECC_CHK_GEN) {
-			chip->ecc.size = 512;
-			chip->ecc.layout = (priv->fmr & FMR_ECCM) ?
-			                   &fsl_elbc_oob_lp_eccm1 :
-			                   &fsl_elbc_oob_lp_eccm0;
-		}
 	} else {
 		dev_err(priv->dev,
 		        "fsl_elbc_init: page size %d is not supported\n",
@@ -780,9 +793,7 @@ static int fsl_elbc_chip_init(struct fsl_elbc_mtd *priv)
 	if ((in_be32(&lbc->bank[priv->bank].br) & BR_DECC) ==
 	    BR_DECC_CHK_GEN) {
 		chip->ecc.mode = NAND_ECC_HW;
-		/* put in small page settings and adjust later if needed */
-		chip->ecc.layout = (priv->fmr & FMR_ECCM) ?
-				&fsl_elbc_oob_sp_eccm1 : &fsl_elbc_oob_sp_eccm0;
+		mtd_set_ooblayout(mtd, &fsl_elbc_ooblayout_ops);
 		chip->ecc.size = 512;
 		chip->ecc.bytes = 3;
 		chip->ecc.strength = 1;
-- 
2.1.4
