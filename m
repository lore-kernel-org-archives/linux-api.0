From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 22/52] mtd: nand: bch: switch to mtd_ooblayout_ops
Date: Mon,  7 Mar 2016 10:47:12 +0100
Message-ID: <1457344062-11633-23-git-send-email-boris.brezillon@free-electrons.com>
References: <1457344062-11633-1-git-send-email-boris.brezillon@free-electrons.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1457344062-11633-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, linux-mtd@lists.infradead.org
Cc: Daniel Mack <daniel@zonque.org>, Haojian Zhuang <haojian.zhuang@gmail.com>, Robert Jarzmik <robert.jarzmik@free.fr>, Kukjin Kim <kgene@kernel.org>, Krzysztof Kozlowski <k.kozlowski@samsung.com>, linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org, Nicolas Ferre <nicolas.ferre@atmel.com>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, Alexandre Belloni <alexandre.belloni@free-electrons.com>, Wenyou Yang <wenyou.yang@atmel.com>, Josh Wu <rainyfeeling@outlook.com>, Ezequiel Garcia <ezequiel.garcia@free-electrons.com>, Maxime Ripard <maxime.ripard@free-electrons.com>, Chen-Yu Tsai <wens@csie.org>, linux-sunxi@googlegroups.com, Stefan Agner <stefan@agner.ch>, Kyungmin Park <kyungmin.park@samsung.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org
List-Id: linux-api@vger.kernel.org

Replace the nand_ecclayout definition by the equivalent mtd_ooblayout_ops
definition.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/mtd/nand/nand_bch.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/mtd/nand/nand_bch.c b/drivers/mtd/nand/nand_bch.c
index b3039de..e29e75f 100644
--- a/drivers/mtd/nand/nand_bch.c
+++ b/drivers/mtd/nand/nand_bch.c
@@ -32,13 +32,11 @@
 /**
  * struct nand_bch_control - private NAND BCH control structure
  * @bch:       BCH control structure
- * @ecclayout: private ecc layout for this BCH configuration
  * @errloc:    error location array
  * @eccmask:   XOR ecc mask, allows erased pages to be decoded as valid
  */
 struct nand_bch_control {
 	struct bch_control   *bch;
-	struct nand_ecclayout ecclayout;
 	unsigned int         *errloc;
 	unsigned char        *eccmask;
 };
@@ -124,7 +122,6 @@ struct nand_bch_control *nand_bch_init(struct mtd_info *mtd)
 {
 	struct nand_chip *nand = mtd_to_nand(mtd);
 	unsigned int m, t, eccsteps, i;
-	struct nand_ecclayout *layout = nand->ecc.layout;
 	struct nand_bch_control *nbc = NULL;
 	unsigned char *erased_page;
 	unsigned int eccsize = nand->ecc.size;
@@ -161,8 +158,17 @@ struct nand_bch_control *nand_bch_init(struct mtd_info *mtd)
 
 	eccsteps = mtd->writesize/eccsize;
 
+	/*
+	 * Rely on the default ecclayout to ooblayout wrapper provided by MTD
+	 * core if ecc.layout is not NULL.
+	 * FIXME: this should be removed when all callers have moved to the
+	 * mtd_ooblayout_ops approach.
+	 */
+	if (nand->ecc.layout)
+		mtd_set_ecclayout(mtd, nand->ecc.layout);
+
 	/* if no ecc placement scheme was provided, build one */
-	if (!layout) {
+	if (!mtd->ooblayout) {
 
 		/* handle large page devices only */
 		if (mtd->oobsize < 64) {
@@ -171,24 +177,7 @@ struct nand_bch_control *nand_bch_init(struct mtd_info *mtd)
 			goto fail;
 		}
 
-		layout = &nbc->ecclayout;
-		layout->eccbytes = eccsteps*eccbytes;
-
-		/* reserve 2 bytes for bad block marker */
-		if (layout->eccbytes+2 > mtd->oobsize) {
-			printk(KERN_WARNING "no suitable oob scheme available "
-			       "for oobsize %d eccbytes %u\n", mtd->oobsize,
-			       eccbytes);
-			goto fail;
-		}
-		/* put ecc bytes at oob tail */
-		for (i = 0; i < layout->eccbytes; i++)
-			layout->eccpos[i] = mtd->oobsize-layout->eccbytes+i;
-
-		layout->oobfree[0].offset = 2;
-		layout->oobfree[0].length = mtd->oobsize-2-layout->eccbytes;
-
-		nand->ecc.layout = layout;
+		mtd_set_ooblayout(mtd, &nand_ooblayout_lp_ops);
 	}
 
 	/* sanity checks */
-- 
2.1.4
