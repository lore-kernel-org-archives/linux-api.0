From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 43/52] mtd: nand: pxa3xx: switch to mtd_ooblayout_ops
Date: Mon,  7 Mar 2016 10:47:33 +0100
Message-ID: <1457344062-11633-44-git-send-email-boris.brezillon@free-electrons.com>
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

Implementing the mtd_ooblayout_ops interface is the new way of exposing
ECC/OOB layout to MTD users.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/mtd/nand/pxa3xx_nand.c | 104 +++++++++++++++++++++++++----------------
 1 file changed, 64 insertions(+), 40 deletions(-)

diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index f100c4d..a26590f 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -325,6 +325,62 @@ static struct pxa3xx_nand_flash builtin_flash_types[] = {
 	{ 0xba20, 16, 16, &timing[3] },
 };
 
+static int pxa3xx_ooblayout_ecc(struct mtd_info *mtd, int section,
+				struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *chip = mtd_to_nand(mtd);
+	struct pxa3xx_nand_host *host = nand_get_controller_data(chip);
+	struct pxa3xx_nand_info *info = host->info_data;
+	int nchunks = mtd->writesize / info->chunk_size;
+
+	if (section >= nchunks)
+		return -ERANGE;
+
+	oobregion->offset = ((info->ecc_size + info->spare_size) * section) +
+			    info->spare_size;
+	oobregion->length = info->ecc_size;
+
+	return 0;
+}
+
+static int pxa3xx_ooblayout_free(struct mtd_info *mtd, int section,
+				 struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *chip = mtd_to_nand(mtd);
+	struct pxa3xx_nand_host *host = nand_get_controller_data(chip);
+	struct pxa3xx_nand_info *info = host->info_data;
+	int nchunks = mtd->writesize / info->chunk_size;
+
+	if (section >= nchunks)
+		return -ERANGE;
+
+	if (!info->spare_size)
+		return 0;
+
+	oobregion->offset = section * (info->ecc_size + info->spare_size);
+	oobregion->length = info->spare_size;
+	if (!section) {
+		/*
+		 * Bootrom looks in bytes 0 & 5 for bad blocks for the
+		 * 4KB page / 4bit BCH combination.
+		 */
+		if (mtd->writesize == 4096 && info->chunk_size == 2048) {
+			oobregion->offset += 6;
+			oobregion->length -= 6;
+		} else {
+			oobregion->offset += 2;
+			oobregion->length -= 2;
+		}
+	}
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops pxa3xx_ooblayout_ops = {
+	.ecc = pxa3xx_ooblayout_ecc,
+	.free = pxa3xx_ooblayout_free,
+};
+
 static u8 bbt_pattern[] = {'M', 'V', 'B', 'b', 't', '0' };
 static u8 bbt_mirror_pattern[] = {'1', 't', 'b', 'B', 'V', 'M' };
 
@@ -348,41 +404,6 @@ static struct nand_bbt_descr bbt_mirror_descr = {
 	.pattern = bbt_mirror_pattern
 };
 
-static struct nand_ecclayout ecc_layout_2KB_bch4bit = {
-	.eccbytes = 32,
-	.eccpos = {
-		32, 33, 34, 35, 36, 37, 38, 39,
-		40, 41, 42, 43, 44, 45, 46, 47,
-		48, 49, 50, 51, 52, 53, 54, 55,
-		56, 57, 58, 59, 60, 61, 62, 63},
-	.oobfree = { {2, 30} }
-};
-
-static struct nand_ecclayout ecc_layout_4KB_bch4bit = {
-	.eccbytes = 64,
-	.eccpos = {
-		32,  33,  34,  35,  36,  37,  38,  39,
-		40,  41,  42,  43,  44,  45,  46,  47,
-		48,  49,  50,  51,  52,  53,  54,  55,
-		56,  57,  58,  59,  60,  61,  62,  63,
-		96,  97,  98,  99,  100, 101, 102, 103,
-		104, 105, 106, 107, 108, 109, 110, 111,
-		112, 113, 114, 115, 116, 117, 118, 119,
-		120, 121, 122, 123, 124, 125, 126, 127},
-	/* Bootrom looks in bytes 0 & 5 for bad blocks */
-	.oobfree = { {6, 26}, { 64, 32} }
-};
-
-static struct nand_ecclayout ecc_layout_4KB_bch8bit = {
-	.eccbytes = 128,
-	.eccpos = {
-		32,  33,  34,  35,  36,  37,  38,  39,
-		40,  41,  42,  43,  44,  45,  46,  47,
-		48,  49,  50,  51,  52,  53,  54,  55,
-		56,  57,  58,  59,  60,  61,  62,  63},
-	.oobfree = { }
-};
-
 #define NDTR0_tCH(c)	(min((c), 7) << 19)
 #define NDTR0_tCS(c)	(min((c), 7) << 16)
 #define NDTR0_tWH(c)	(min((c), 7) << 11)
@@ -1547,9 +1568,12 @@ static void pxa3xx_nand_free_buff(struct pxa3xx_nand_info *info)
 }
 
 static int pxa_ecc_init(struct pxa3xx_nand_info *info,
-			struct nand_ecc_ctrl *ecc,
+			struct mtd_info *mtd,
 			int strength, int ecc_stepsize, int page_size)
 {
+	struct nand_chip *chip = mtd_to_nand(mtd);
+	struct nand_ecc_ctrl *ecc = &chip->ecc;
+
 	if (strength == 1 && ecc_stepsize == 512 && page_size == 2048) {
 		info->nfullchunks = 1;
 		info->ntotalchunks = 1;
@@ -1583,7 +1607,7 @@ static int pxa_ecc_init(struct pxa3xx_nand_info *info,
 		info->ecc_size = 32;
 		ecc->mode = NAND_ECC_HW;
 		ecc->size = info->chunk_size;
-		ecc->layout = &ecc_layout_2KB_bch4bit;
+		mtd_set_ooblayout(mtd, &pxa3xx_ooblayout_ops);
 		ecc->strength = 16;
 
 	} else if (strength == 4 && ecc_stepsize == 512 && page_size == 4096) {
@@ -1595,7 +1619,7 @@ static int pxa_ecc_init(struct pxa3xx_nand_info *info,
 		info->ecc_size = 32;
 		ecc->mode = NAND_ECC_HW;
 		ecc->size = info->chunk_size;
-		ecc->layout = &ecc_layout_4KB_bch4bit;
+		mtd_set_ooblayout(mtd, &pxa3xx_ooblayout_ops);
 		ecc->strength = 16;
 
 	/*
@@ -1613,7 +1637,7 @@ static int pxa_ecc_init(struct pxa3xx_nand_info *info,
 		info->ecc_size = 32;
 		ecc->mode = NAND_ECC_HW;
 		ecc->size = info->chunk_size;
-		ecc->layout = &ecc_layout_4KB_bch8bit;
+		mtd_set_ooblayout(mtd, &pxa3xx_ooblayout_ops);
 		ecc->strength = 16;
 	} else {
 		dev_err(&info->pdev->dev,
@@ -1704,7 +1728,7 @@ static int pxa3xx_nand_scan(struct mtd_info *mtd)
 		ecc_step = 512;
 	}
 
-	ret = pxa_ecc_init(info, &chip->ecc, ecc_strength,
+	ret = pxa_ecc_init(info, mtd, ecc_strength,
 			   ecc_step, mtd->writesize);
 	if (ret)
 		return ret;
-- 
2.1.4
