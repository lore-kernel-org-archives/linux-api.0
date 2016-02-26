From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 41/52] mtd: nand: mxc: switch to mtd_ooblayout_ops
Date: Fri, 26 Feb 2016 01:57:49 +0100
Message-ID: <1456448280-27788-42-git-send-email-boris.brezillon@free-electrons.com>
References: <1456448280-27788-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBB6GKX23AKGQE7URSXMI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1456448280-27788-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
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
 drivers/mtd/nand/mxc_nand.c | 212 ++++++++++++++++++++++----------------------
 1 file changed, 105 insertions(+), 107 deletions(-)

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 854c832..628f834 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -149,7 +149,7 @@ struct mxc_nand_devtype_data {
 	int (*check_int)(struct mxc_nand_host *);
 	void (*irq_control)(struct mxc_nand_host *, int);
 	u32 (*get_ecc_status)(struct mxc_nand_host *);
-	struct nand_ecclayout *ecclayout_512, *ecclayout_2k, *ecclayout_4k;
+	const struct mtd_ooblayout_ops *ooblayout;
 	void (*select_chip)(struct mtd_info *mtd, int chip);
 	int (*correct_data)(struct mtd_info *mtd, u_char *dat,
 			u_char *read_ecc, u_char *calc_ecc);
@@ -200,73 +200,6 @@ struct mxc_nand_host {
 	struct mxc_nand_platform_data pdata;
 };
 
-/* OOB placement block for use with hardware ecc generation */
-static struct nand_ecclayout nandv1_hw_eccoob_smallpage = {
-	.eccbytes = 5,
-	.eccpos = {6, 7, 8, 9, 10},
-	.oobfree = {{0, 5}, {12, 4}, }
-};
-
-static struct nand_ecclayout nandv1_hw_eccoob_largepage = {
-	.eccbytes = 20,
-	.eccpos = {6, 7, 8, 9, 10, 22, 23, 24, 25, 26,
-		   38, 39, 40, 41, 42, 54, 55, 56, 57, 58},
-	.oobfree = {{2, 4}, {11, 10}, {27, 10}, {43, 10}, {59, 5}, }
-};
-
-/* OOB description for 512 byte pages with 16 byte OOB */
-static struct nand_ecclayout nandv2_hw_eccoob_smallpage = {
-	.eccbytes = 1 * 9,
-	.eccpos = {
-		 7,  8,  9, 10, 11, 12, 13, 14, 15
-	},
-	.oobfree = {
-		{.offset = 0, .length = 5}
-	}
-};
-
-/* OOB description for 2048 byte pages with 64 byte OOB */
-static struct nand_ecclayout nandv2_hw_eccoob_largepage = {
-	.eccbytes = 4 * 9,
-	.eccpos = {
-		 7,  8,  9, 10, 11, 12, 13, 14, 15,
-		23, 24, 25, 26, 27, 28, 29, 30, 31,
-		39, 40, 41, 42, 43, 44, 45, 46, 47,
-		55, 56, 57, 58, 59, 60, 61, 62, 63
-	},
-	.oobfree = {
-		{.offset = 2, .length = 4},
-		{.offset = 16, .length = 7},
-		{.offset = 32, .length = 7},
-		{.offset = 48, .length = 7}
-	}
-};
-
-/* OOB description for 4096 byte pages with 128 byte OOB */
-static struct nand_ecclayout nandv2_hw_eccoob_4k = {
-	.eccbytes = 8 * 9,
-	.eccpos = {
-		7,  8,  9, 10, 11, 12, 13, 14, 15,
-		23, 24, 25, 26, 27, 28, 29, 30, 31,
-		39, 40, 41, 42, 43, 44, 45, 46, 47,
-		55, 56, 57, 58, 59, 60, 61, 62, 63,
-		71, 72, 73, 74, 75, 76, 77, 78, 79,
-		87, 88, 89, 90, 91, 92, 93, 94, 95,
-		103, 104, 105, 106, 107, 108, 109, 110, 111,
-		119, 120, 121, 122, 123, 124, 125, 126, 127,
-	},
-	.oobfree = {
-		{.offset = 2, .length = 4},
-		{.offset = 16, .length = 7},
-		{.offset = 32, .length = 7},
-		{.offset = 48, .length = 7},
-		{.offset = 64, .length = 7},
-		{.offset = 80, .length = 7},
-		{.offset = 96, .length = 7},
-		{.offset = 112, .length = 7},
-	}
-};
-
 static const char * const part_probes[] = {
 	"cmdlinepart", "RedBoot", "ofpart", NULL };
 
@@ -942,6 +875,99 @@ static void mxc_do_addr_cycle(struct mtd_info *mtd, int column, int page_addr)
 	}
 }
 
+static int mxc_v1_ooblayout_ecc(struct mtd_info *mtd, int section,
+				struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *nand_chip = mtd_to_nand(mtd);
+
+	if (section >= nand_chip->ecc.steps)
+		return -ERANGE;
+
+	oobregion->offset = (section * 16) + 6;
+	oobregion->length = nand_chip->ecc.bytes;
+
+	return 0;
+}
+
+static int mxc_v1_ooblayout_free(struct mtd_info *mtd, int section,
+				 struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *nand_chip = mtd_to_nand(mtd);
+
+	if (section > nand_chip->ecc.steps)
+		return -ERANGE;
+
+	if (!section) {
+		if (mtd->writesize <= 512) {
+			oobregion->offset = 0;
+			oobregion->length = 5;
+		} else {
+			oobregion->offset = 2;
+			oobregion->length = 4;
+		}
+	} else {
+		oobregion->offset = ((section - 1) * 16) +
+				    nand_chip->ecc.bytes + 6;
+		if (section < nand_chip->ecc.steps)
+			oobregion->length = (section * 16) + 6 -
+					    oobregion->offset;
+		else
+			oobregion->length = mtd->oobsize - oobregion->offset;
+	}
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops mxc_v1_ooblayout_ops = {
+	.ecc = mxc_v1_ooblayout_ecc,
+	.free = mxc_v1_ooblayout_free,
+};
+
+static int mxc_v2_ooblayout_ecc(struct mtd_info *mtd, int section,
+				struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *nand_chip = mtd_to_nand(mtd);
+	int stepsize = nand_chip->ecc.bytes == 9 ? 16 : 26;
+
+	if (section >= nand_chip->ecc.steps)
+		return -ERANGE;
+
+	oobregion->offset = (section * stepsize) + 7;
+	oobregion->length = nand_chip->ecc.bytes;
+
+	return 0;
+}
+
+static int mxc_v2_ooblayout_free(struct mtd_info *mtd, int section,
+				 struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *nand_chip = mtd_to_nand(mtd);
+	int stepsize = nand_chip->ecc.bytes == 9 ? 16 : 26;
+
+	if (section > nand_chip->ecc.steps)
+		return -ERANGE;
+
+	if (!section) {
+		if (mtd->writesize <= 512) {
+			oobregion->offset = 0;
+			oobregion->length = 5;
+		} else {
+			oobregion->offset = 2;
+			oobregion->length = 4;
+		}
+	} else {
+		oobregion->offset = section * stepsize;
+		oobregion->length = 7;
+	}
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops mxc_v2_ooblayout_ops = {
+	.ecc = mxc_v2_ooblayout_ecc,
+	.free = mxc_v2_ooblayout_free,
+};
+
 /*
  * v2 and v3 type controllers can do 4bit or 8bit ecc depending
  * on how much oob the nand chip has. For 8bit ecc we need at least
@@ -959,23 +985,6 @@ static int get_eccsize(struct mtd_info *mtd)
 		return 8;
 }
 
-static void ecc_8bit_layout_4k(struct nand_ecclayout *layout)
-{
-	int i, j;
-
-	layout->eccbytes = 8*18;
-	for (i = 0; i < 8; i++)
-		for (j = 0; j < 18; j++)
-			layout->eccpos[i*18 + j] = i*26 + j + 7;
-
-	layout->oobfree[0].offset = 2;
-	layout->oobfree[0].length = 4;
-	for (i = 1; i < 8; i++) {
-		layout->oobfree[i].offset = i*26;
-		layout->oobfree[i].length = 7;
-	}
-}
-
 static void preset_v1(struct mtd_info *mtd)
 {
 	struct nand_chip *nand_chip = mtd_to_nand(mtd);
@@ -1269,9 +1278,7 @@ static const struct mxc_nand_devtype_data imx21_nand_devtype_data = {
 	.check_int = check_int_v1_v2,
 	.irq_control = irq_control_v1_v2,
 	.get_ecc_status = get_ecc_status_v1,
-	.ecclayout_512 = &nandv1_hw_eccoob_smallpage,
-	.ecclayout_2k = &nandv1_hw_eccoob_largepage,
-	.ecclayout_4k = &nandv1_hw_eccoob_smallpage, /* XXX: needs fix */
+	.ooblayout = &mxc_v1_ooblayout_ops,
 	.select_chip = mxc_nand_select_chip_v1_v3,
 	.correct_data = mxc_nand_correct_data_v1,
 	.irqpending_quirk = 1,
@@ -1294,9 +1301,7 @@ static const struct mxc_nand_devtype_data imx27_nand_devtype_data = {
 	.check_int = check_int_v1_v2,
 	.irq_control = irq_control_v1_v2,
 	.get_ecc_status = get_ecc_status_v1,
-	.ecclayout_512 = &nandv1_hw_eccoob_smallpage,
-	.ecclayout_2k = &nandv1_hw_eccoob_largepage,
-	.ecclayout_4k = &nandv1_hw_eccoob_smallpage, /* XXX: needs fix */
+	.ooblayout = &mxc_v1_ooblayout_ops,
 	.select_chip = mxc_nand_select_chip_v1_v3,
 	.correct_data = mxc_nand_correct_data_v1,
 	.irqpending_quirk = 0,
@@ -1320,9 +1325,7 @@ static const struct mxc_nand_devtype_data imx25_nand_devtype_data = {
 	.check_int = check_int_v1_v2,
 	.irq_control = irq_control_v1_v2,
 	.get_ecc_status = get_ecc_status_v2,
-	.ecclayout_512 = &nandv2_hw_eccoob_smallpage,
-	.ecclayout_2k = &nandv2_hw_eccoob_largepage,
-	.ecclayout_4k = &nandv2_hw_eccoob_4k,
+	.ooblayout = &mxc_v2_ooblayout_ops,
 	.select_chip = mxc_nand_select_chip_v2,
 	.correct_data = mxc_nand_correct_data_v2_v3,
 	.irqpending_quirk = 0,
@@ -1346,9 +1349,7 @@ static const struct mxc_nand_devtype_data imx51_nand_devtype_data = {
 	.check_int = check_int_v3,
 	.irq_control = irq_control_v3,
 	.get_ecc_status = get_ecc_status_v3,
-	.ecclayout_512 = &nandv2_hw_eccoob_smallpage,
-	.ecclayout_2k = &nandv2_hw_eccoob_largepage,
-	.ecclayout_4k = &nandv2_hw_eccoob_smallpage, /* XXX: needs fix */
+	.ooblayout = &mxc_v2_ooblayout_ops,
 	.select_chip = mxc_nand_select_chip_v1_v3,
 	.correct_data = mxc_nand_correct_data_v2_v3,
 	.irqpending_quirk = 0,
@@ -1373,9 +1374,7 @@ static const struct mxc_nand_devtype_data imx53_nand_devtype_data = {
 	.check_int = check_int_v3,
 	.irq_control = irq_control_v3,
 	.get_ecc_status = get_ecc_status_v3,
-	.ecclayout_512 = &nandv2_hw_eccoob_smallpage,
-	.ecclayout_2k = &nandv2_hw_eccoob_largepage,
-	.ecclayout_4k = &nandv2_hw_eccoob_smallpage, /* XXX: needs fix */
+	.ooblayout = &mxc_v2_ooblayout_ops,
 	.select_chip = mxc_nand_select_chip_v1_v3,
 	.correct_data = mxc_nand_correct_data_v2_v3,
 	.irqpending_quirk = 0,
@@ -1576,7 +1575,7 @@ static int mxcnd_probe(struct platform_device *pdev)
 
 	this->select_chip = host->devtype_data->select_chip;
 	this->ecc.size = 512;
-	this->ecc.layout = host->devtype_data->ecclayout_512;
+	mtd_set_ooblayout(mtd, host->devtype_data->ooblayout);
 
 	if (host->pdata.hw_ecc) {
 		this->ecc.calculate = mxc_nand_calculate_ecc;
@@ -1649,12 +1648,11 @@ static int mxcnd_probe(struct platform_device *pdev)
 	/* Call preset again, with correct writesize this time */
 	host->devtype_data->preset(mtd);
 
-	if (mtd->writesize == 2048)
-		this->ecc.layout = host->devtype_data->ecclayout_2k;
-	else if (mtd->writesize == 4096) {
-		this->ecc.layout = host->devtype_data->ecclayout_4k;
-		if (get_eccsize(mtd) == 8)
-			ecc_8bit_layout_4k(this->ecc.layout);
+	if (!this->ecc.bytes) {
+		if (host->eccsize == 8)
+			this->ecc.bytes = 18;
+		else if (host->eccsize == 4)
+			this->ecc.bytes = 9;
 	}
 
 	/*
-- 
2.1.4
