From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v5 44/50] mtd: nand: sunxi: switch to mtd_ooblayout_ops
Date: Wed, 30 Mar 2016 18:14:59 +0200
Message-ID: <1459354505-32551-45-git-send-email-boris.brezillon@free-electrons.com>
References: <1459354505-32551-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBB2PX563QKGQEA54J4MI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <1459354505-32551-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Haojian Zhuang <haojian.zhuang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Robert Jarzmik <robert.jarzmik-GANU6spQydw@public.gmane.org>, Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, Nicolas Ferre <nicolas.ferre-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Wenyou Yang <wenyou.yang-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Josh Wu <rainyfeeling-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>, Ezequiel Garcia <ezequiel.garcia-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

Implementing the mtd_ooblayout_ops interface is the new way of exposing
ECC/OOB layout to MTD users.

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
---
 drivers/mtd/nand/sunxi_nand.c | 114 +++++++++++++++++++-----------------------
 1 file changed, 52 insertions(+), 62 deletions(-)

diff --git a/drivers/mtd/nand/sunxi_nand.c b/drivers/mtd/nand/sunxi_nand.c
index 1c03eee..4b9d984 100644
--- a/drivers/mtd/nand/sunxi_nand.c
+++ b/drivers/mtd/nand/sunxi_nand.c
@@ -212,12 +212,9 @@ struct sunxi_nand_chip_sel {
  * sunxi HW ECC infos: stores information related to HW ECC support
  *
  * @mode:	the sunxi ECC mode field deduced from ECC requirements
- * @layout:	the OOB layout depending on the ECC requirements and the
- *		selected ECC mode
  */
 struct sunxi_nand_hw_ecc {
 	int mode;
-	struct nand_ecclayout layout;
 };
 
 /*
@@ -1257,6 +1254,57 @@ static int sunxi_nand_chip_init_timings(struct sunxi_nand_chip *chip,
 	return sunxi_nand_chip_set_timings(chip, timings);
 }
 
+static int sunxi_nand_ooblayout_ecc(struct mtd_info *mtd, int section,
+				    struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *nand = mtd_to_nand(mtd);
+	struct nand_ecc_ctrl *ecc = &nand->ecc;
+
+	if (section >= ecc->steps)
+		return -ERANGE;
+
+	oobregion->offset = section * (ecc->bytes + 4) + 4;
+	oobregion->length = ecc->bytes;
+
+	return 0;
+}
+
+static int sunxi_nand_ooblayout_free(struct mtd_info *mtd, int section,
+				     struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *nand = mtd_to_nand(mtd);
+	struct nand_ecc_ctrl *ecc = &nand->ecc;
+
+	if (section > ecc->steps)
+		return -ERANGE;
+
+	/*
+	 * The first 2 bytes are used for BB markers, hence we
+	 * only have 2 bytes available in the first user data
+	 * section.
+	 */
+	if (!section && ecc->mode == NAND_ECC_HW) {
+		oobregion->offset = 2;
+		oobregion->length = 2;
+
+		return 0;
+	}
+
+	oobregion->offset = section * (ecc->bytes + 4);
+
+	if (section < ecc->steps)
+		oobregion->length = 4;
+	else
+		oobregion->offset = mtd->oobsize - oobregion->offset;
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops sunxi_nand_ooblayout_ops = {
+	.ecc = sunxi_nand_ooblayout_ecc,
+	.free = sunxi_nand_ooblayout_free,
+};
+
 static int sunxi_nand_hw_common_ecc_ctrl_init(struct mtd_info *mtd,
 					      struct nand_ecc_ctrl *ecc,
 					      struct device_node *np)
@@ -1266,7 +1314,6 @@ static int sunxi_nand_hw_common_ecc_ctrl_init(struct mtd_info *mtd,
 	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(nand);
 	struct sunxi_nfc *nfc = to_sunxi_nfc(sunxi_nand->nand.controller);
 	struct sunxi_nand_hw_ecc *data;
-	struct nand_ecclayout *layout;
 	int nsectors;
 	int ret;
 	int i;
@@ -1295,7 +1342,6 @@ static int sunxi_nand_hw_common_ecc_ctrl_init(struct mtd_info *mtd,
 	/* HW ECC always work with even numbers of ECC bytes */
 	ecc->bytes = ALIGN(ecc->bytes, 2);
 
-	layout = &data->layout;
 	nsectors = mtd->writesize / ecc->size;
 
 	if (mtd->oobsize < ((ecc->bytes + 4) * nsectors)) {
@@ -1303,9 +1349,7 @@ static int sunxi_nand_hw_common_ecc_ctrl_init(struct mtd_info *mtd,
 		goto err;
 	}
 
-	layout->eccbytes = (ecc->bytes * nsectors);
-
-	ecc->layout = layout;
+	mtd_set_ooblayout(mtd, &sunxi_nand_ooblayout_ops);
 	ecc->priv = data;
 
 	return 0;
@@ -1325,9 +1369,6 @@ static int sunxi_nand_hw_ecc_ctrl_init(struct mtd_info *mtd,
 				       struct nand_ecc_ctrl *ecc,
 				       struct device_node *np)
 {
-	struct nand_ecclayout *layout;
-	int nsectors;
-	int i, j;
 	int ret;
 
 	ret = sunxi_nand_hw_common_ecc_ctrl_init(mtd, ecc, np);
@@ -1336,40 +1377,6 @@ static int sunxi_nand_hw_ecc_ctrl_init(struct mtd_info *mtd,
 
 	ecc->read_page = sunxi_nfc_hw_ecc_read_page;
 	ecc->write_page = sunxi_nfc_hw_ecc_write_page;
-	layout = ecc->layout;
-	nsectors = mtd->writesize / ecc->size;
-
-	for (i = 0; i < nsectors; i++) {
-		if (i) {
-			layout->oobfree[i].offset =
-				layout->oobfree[i - 1].offset +
-				layout->oobfree[i - 1].length +
-				ecc->bytes;
-			layout->oobfree[i].length = 4;
-		} else {
-			/*
-			 * The first 2 bytes are used for BB markers, hence we
-			 * only have 2 bytes available in the first user data
-			 * section.
-			 */
-			layout->oobfree[i].length = 2;
-			layout->oobfree[i].offset = 2;
-		}
-
-		for (j = 0; j < ecc->bytes; j++)
-			layout->eccpos[(ecc->bytes * i) + j] =
-					layout->oobfree[i].offset +
-					layout->oobfree[i].length + j;
-	}
-
-	if (mtd->oobsize > (ecc->bytes + 4) * nsectors) {
-		layout->oobfree[nsectors].offset =
-				layout->oobfree[nsectors - 1].offset +
-				layout->oobfree[nsectors - 1].length +
-				ecc->bytes;
-		layout->oobfree[nsectors].length = mtd->oobsize -
-				((ecc->bytes + 4) * nsectors);
-	}
 
 	return 0;
 }
@@ -1378,9 +1385,6 @@ static int sunxi_nand_hw_syndrome_ecc_ctrl_init(struct mtd_info *mtd,
 						struct nand_ecc_ctrl *ecc,
 						struct device_node *np)
 {
-	struct nand_ecclayout *layout;
-	int nsectors;
-	int i;
 	int ret;
 
 	ret = sunxi_nand_hw_common_ecc_ctrl_init(mtd, ecc, np);
@@ -1391,15 +1395,6 @@ static int sunxi_nand_hw_syndrome_ecc_ctrl_init(struct mtd_info *mtd,
 	ecc->read_page = sunxi_nfc_hw_syndrome_ecc_read_page;
 	ecc->write_page = sunxi_nfc_hw_syndrome_ecc_write_page;
 
-	layout = ecc->layout;
-	nsectors = mtd->writesize / ecc->size;
-
-	for (i = 0; i < (ecc->bytes * nsectors); i++)
-		layout->eccpos[i] = i;
-
-	layout->oobfree[0].length = mtd->oobsize - i;
-	layout->oobfree[0].offset = i;
-
 	return 0;
 }
 
@@ -1411,7 +1406,6 @@ static void sunxi_nand_ecc_cleanup(struct nand_ecc_ctrl *ecc)
 		sunxi_nand_hw_common_ecc_ctrl_cleanup(ecc);
 		break;
 	case NAND_ECC_NONE:
-		kfree(ecc->layout);
 	default:
 		break;
 	}
@@ -1445,10 +1439,6 @@ static int sunxi_nand_ecc_init(struct mtd_info *mtd, struct nand_ecc_ctrl *ecc,
 			return ret;
 		break;
 	case NAND_ECC_NONE:
-		ecc->layout = kzalloc(sizeof(*ecc->layout), GFP_KERNEL);
-		if (!ecc->layout)
-			return -ENOMEM;
-		ecc->layout->oobfree[0].length = mtd->oobsize;
 	case NAND_ECC_SOFT:
 		break;
 	default:
-- 
2.5.0
