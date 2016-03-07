From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 21/52] mtd: nand: implement the default mtd_ooblayout_ops
Date: Mon,  7 Mar 2016 10:47:11 +0100
Message-ID: <1457344062-11633-22-git-send-email-boris.brezillon@free-electrons.com>
References: <1457344062-11633-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1457344062-11633-1-git-send-email-boris.brezillon@free-electrons.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, linux-mtd@lists.infradead.org
Cc: linux-mips@linux-mips.org, Krzysztof Kozlowski <k.kozlowski@samsung.com>, Harvey Hunt <harvey.hunt@imgtec.com>, Nicolas Ferre <nicolas.ferre@atmel.com>, Stefan Agner <stefan@agner.ch>, linux-sunxi@googlegroups.com, Alexandre Belloni <alexandre.belloni@free-electrons.com>, punnaiah choudary kalluri <punnaia@xilinx.com>, Robert Jarzmik <robert.jarzmik@free.fr>, devel@driverdev.osuosl.org, Boris Brezillon <boris.brezillon@free-electrons.com>, linux-samsung-soc@vger.kernel.org, Kamal Dasu <kdasu.kdev@gmail.com>, Josh Wu <rainyfeeling@outlook.com>, Chen-Yu Tsai <wens@csie.org>, Kukjin Kim <kgene@kernel.org>, bcm-kernel-feedback-list@broadcom.com, Ezequiel Garcia <ezequiel.garcia@free-electrons.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Haojian Zhuang <haojian.zhuang@gmail.com>, linux-arm-kernel@lists.infradead.org, Priit Laes <plaes@plaes.org>, Greg
List-Id: linux-api@vger.kernel.org

Replace the default nand_ecclayout definitions for large and small page
devices with the equivalent mtd_ooblayout_ops.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/mtd/nand/nand_base.c | 148 ++++++++++++++++++++++++++++---------------
 include/linux/mtd/nand.h     |   3 +
 2 files changed, 99 insertions(+), 52 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 1e36a02..779a385 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -48,50 +48,6 @@
 #include <linux/mtd/partitions.h>
 #include <linux/of_mtd.h>
 
-/* Define default oob placement schemes for large and small page devices */
-static struct nand_ecclayout nand_oob_8 = {
-	.eccbytes = 3,
-	.eccpos = {0, 1, 2},
-	.oobfree = {
-		{.offset = 3,
-		 .length = 2},
-		{.offset = 6,
-		 .length = 2} }
-};
-
-static struct nand_ecclayout nand_oob_16 = {
-	.eccbytes = 6,
-	.eccpos = {0, 1, 2, 3, 6, 7},
-	.oobfree = {
-		{.offset = 8,
-		 . length = 8} }
-};
-
-static struct nand_ecclayout nand_oob_64 = {
-	.eccbytes = 24,
-	.eccpos = {
-		   40, 41, 42, 43, 44, 45, 46, 47,
-		   48, 49, 50, 51, 52, 53, 54, 55,
-		   56, 57, 58, 59, 60, 61, 62, 63},
-	.oobfree = {
-		{.offset = 2,
-		 .length = 38} }
-};
-
-static struct nand_ecclayout nand_oob_128 = {
-	.eccbytes = 48,
-	.eccpos = {
-		   80, 81, 82, 83, 84, 85, 86, 87,
-		   88, 89, 90, 91, 92, 93, 94, 95,
-		   96, 97, 98, 99, 100, 101, 102, 103,
-		   104, 105, 106, 107, 108, 109, 110, 111,
-		   112, 113, 114, 115, 116, 117, 118, 119,
-		   120, 121, 122, 123, 124, 125, 126, 127},
-	.oobfree = {
-		{.offset = 2,
-		 .length = 78} }
-};
-
 static int nand_get_device(struct mtd_info *mtd, int new_state);
 
 static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
@@ -103,6 +59,92 @@ static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
  */
 DEFINE_LED_TRIGGER(nand_led_trigger);
 
+/* Define default oob placement schemes for large and small page devices */
+static int nand_ooblayout_ecc_sp(struct mtd_info *mtd, int section,
+				 struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *chip = mtd_to_nand(mtd);
+	struct nand_ecc_ctrl *ecc = &chip->ecc;
+
+	if (section > 1)
+		return -ERANGE;
+
+	if (!section) {
+		oobregion->offset = 0;
+		oobregion->length = 4;
+	} else {
+		oobregion->offset = 6;
+		oobregion->length = ecc->total - 4;
+	}
+
+	return 0;
+}
+
+static int nand_ooblayout_free_sp(struct mtd_info *mtd, int section,
+				  struct mtd_oob_region *oobregion)
+{
+	if (section > 1)
+		return -ERANGE;
+
+	if (mtd->oobsize == 16) {
+		if (section)
+			return -ERANGE;
+
+		oobregion->length = 8;
+		oobregion->offset = 8;
+	} else {
+		oobregion->length = 2;
+		if (!section)
+			oobregion->offset = 3;
+		else
+			oobregion->offset = 6;
+	}
+
+	return 0;
+}
+
+const struct mtd_ooblayout_ops nand_ooblayout_sp_ops = {
+	.ecc = nand_ooblayout_ecc_sp,
+	.free = nand_ooblayout_free_sp,
+};
+EXPORT_SYMBOL_GPL(nand_ooblayout_sp_ops);
+
+static int nand_ooblayout_ecc_lp(struct mtd_info *mtd, int section,
+				 struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *chip = mtd_to_nand(mtd);
+	struct nand_ecc_ctrl *ecc = &chip->ecc;
+
+	if (section)
+		return -ERANGE;
+
+	oobregion->length = ecc->total;
+	oobregion->offset = mtd->oobsize - oobregion->length;
+
+	return 0;
+}
+
+static int nand_ooblayout_free_lp(struct mtd_info *mtd, int section,
+				  struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *chip = mtd_to_nand(mtd);
+	struct nand_ecc_ctrl *ecc = &chip->ecc;
+
+	if (section)
+		return -ERANGE;
+
+	oobregion->length = mtd->oobsize - ecc->total - 2;
+	oobregion->offset = 2;
+
+	return 0;
+}
+
+const struct mtd_ooblayout_ops nand_ooblayout_lp_ops = {
+	.ecc = nand_ooblayout_ecc_lp,
+	.free = nand_ooblayout_free_lp,
+};
+EXPORT_SYMBOL_GPL(nand_ooblayout_lp_ops);
+
 static int check_offs_len(struct mtd_info *mtd,
 					loff_t ofs, uint64_t len)
 {
@@ -4120,21 +4162,24 @@ int nand_scan_tail(struct mtd_info *mtd)
 	chip->oob_poi = chip->buffers->databuf + mtd->writesize;
 
 	/*
+	 * Set the provided ECC layout. If ecc->layout is NULL, the MTD core
+	 * will just leave mtd->ooblayout to NULL, if it's not NULL, it will
+	 * set ->ooblayout to the default ecclayout wrapper.
+	 */
+	mtd_set_ecclayout(mtd, ecc->layout);
+
+	/*
 	 * If no default placement scheme is given, select an appropriate one.
 	 */
-	if (!ecc->layout && (ecc->mode != NAND_ECC_SOFT_BCH)) {
+	if (!mtd->ooblayout && (ecc->mode != NAND_ECC_SOFT_BCH)) {
 		switch (mtd->oobsize) {
 		case 8:
-			ecc->layout = &nand_oob_8;
-			break;
 		case 16:
-			ecc->layout = &nand_oob_16;
+			mtd_set_ooblayout(mtd, &nand_ooblayout_sp_ops);
 			break;
 		case 64:
-			ecc->layout = &nand_oob_64;
-			break;
 		case 128:
-			ecc->layout = &nand_oob_128;
+			mtd_set_ooblayout(mtd, &nand_ooblayout_lp_ops);
 			break;
 		default:
 			pr_warn("No oob scheme defined for oobsize %d\n",
@@ -4288,7 +4333,6 @@ int nand_scan_tail(struct mtd_info *mtd)
 		ecc->write_oob_raw = ecc->write_oob;
 
 	/* propagate ecc info to mtd_info */
-	mtd_set_ecclayout(mtd, ecc->layout);
 	mtd->ecc_strength = ecc->strength;
 	mtd->ecc_step_size = ecc->size;
 
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 7604f4b..82a005a 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -740,6 +740,9 @@ struct nand_chip {
 	void *priv;
 };
 
+extern const struct mtd_ooblayout_ops nand_ooblayout_sp_ops;
+extern const struct mtd_ooblayout_ops nand_ooblayout_lp_ops;
+
 static inline void nand_set_flash_node(struct nand_chip *chip,
 				       struct device_node *np)
 {
-- 
2.1.4
