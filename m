From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 04/52] mtd: nand: simplify nand_bch_init() usage
Date: Mon,  7 Mar 2016 10:46:54 +0100
Message-ID: <1457344062-11633-5-git-send-email-boris.brezillon@free-electrons.com>
References: <1457344062-11633-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBSE46W3AKGQEIQYGCPA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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

nand_bch_init() requires several arguments which could directly be deduced
from the mtd device. Get rid of those useless parameters.

nand_bch_init() is also requiring the caller to provide a proper eccbytes
value, while this value could be deduced from the ecc.size and
ecc.strength value. Fallback to eccbytes calculation when it is set to 0.

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
---
 drivers/mtd/nand/nand_base.c |  6 ++----
 drivers/mtd/nand/nand_bch.c  | 27 +++++++++++++++++----------
 drivers/mtd/nand/omap2.c     | 28 ++++++++++++----------------
 include/linux/mtd/nand_bch.h |  8 ++------
 4 files changed, 33 insertions(+), 36 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index ee89195..91672bf 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -4279,10 +4279,8 @@ int nand_scan_tail(struct mtd_info *mtd)
 		}
 
 		/* See nand_bch_init() for details. */
-		ecc->bytes = DIV_ROUND_UP(
-				ecc->strength * fls(8 * ecc->size), 8);
-		ecc->priv = nand_bch_init(mtd, ecc->size, ecc->bytes,
-					       &ecc->layout);
+		ecc->bytes = 0;
+		ecc->priv = nand_bch_init(mtd);
 		if (!ecc->priv) {
 			pr_warn("BCH ECC initialization failed!\n");
 			BUG();
diff --git a/drivers/mtd/nand/nand_bch.c b/drivers/mtd/nand/nand_bch.c
index a87c1b6..b585bae 100644
--- a/drivers/mtd/nand/nand_bch.c
+++ b/drivers/mtd/nand/nand_bch.c
@@ -107,9 +107,6 @@ EXPORT_SYMBOL(nand_bch_correct_data);
 /**
  * nand_bch_init - [NAND Interface] Initialize NAND BCH error correction
  * @mtd:	MTD block structure
- * @eccsize:	ecc block size in bytes
- * @eccbytes:	ecc length in bytes
- * @ecclayout:	output default layout
  *
  * Returns:
  *  a pointer to a new NAND BCH control structure, or NULL upon failure
@@ -123,14 +120,21 @@ EXPORT_SYMBOL(nand_bch_correct_data);
  * @eccsize = 512  (thus, m=13 is the smallest integer such that 2^m-1 > 512*8)
  * @eccbytes = 7   (7 bytes are required to store m*t = 13*4 = 52 bits)
  */
-struct nand_bch_control *
-nand_bch_init(struct mtd_info *mtd, unsigned int eccsize, unsigned int eccbytes,
-	      struct nand_ecclayout **ecclayout)
+struct nand_bch_control *nand_bch_init(struct mtd_info *mtd)
 {
+	struct nand_chip *nand = mtd_to_nand(mtd);
 	unsigned int m, t, eccsteps, i;
-	struct nand_ecclayout *layout;
+	struct nand_ecclayout *layout = nand->ecc.layout;
 	struct nand_bch_control *nbc = NULL;
 	unsigned char *erased_page;
+	unsigned int eccsize = nand->ecc.size;
+	unsigned int eccbytes = nand->ecc.bytes;
+	unsigned int eccstrength = nand->ecc.strength;
+
+	if (!eccbytes && eccstrength) {
+		eccbytes = DIV_ROUND_UP(eccstrength * fls(8 * eccsize), 8);
+		nand->ecc.bytes = eccbytes;
+	}
 
 	if (!eccsize || !eccbytes) {
 		printk(KERN_WARNING "ecc parameters not supplied\n");
@@ -158,7 +162,7 @@ nand_bch_init(struct mtd_info *mtd, unsigned int eccsize, unsigned int eccbytes,
 	eccsteps = mtd->writesize/eccsize;
 
 	/* if no ecc placement scheme was provided, build one */
-	if (!*ecclayout) {
+	if (!layout) {
 
 		/* handle large page devices only */
 		if (mtd->oobsize < 64) {
@@ -184,7 +188,7 @@ nand_bch_init(struct mtd_info *mtd, unsigned int eccsize, unsigned int eccbytes,
 		layout->oobfree[0].offset = 2;
 		layout->oobfree[0].length = mtd->oobsize-2-layout->eccbytes;
 
-		*ecclayout = layout;
+		nand->ecc.layout = layout;
 	}
 
 	/* sanity checks */
@@ -192,7 +196,7 @@ nand_bch_init(struct mtd_info *mtd, unsigned int eccsize, unsigned int eccbytes,
 		printk(KERN_WARNING "eccsize %u is too large\n", eccsize);
 		goto fail;
 	}
-	if ((*ecclayout)->eccbytes != (eccsteps*eccbytes)) {
+	if (layout->eccbytes != (eccsteps*eccbytes)) {
 		printk(KERN_WARNING "invalid ecc layout\n");
 		goto fail;
 	}
@@ -216,6 +220,9 @@ nand_bch_init(struct mtd_info *mtd, unsigned int eccsize, unsigned int eccbytes,
 	for (i = 0; i < eccbytes; i++)
 		nbc->eccmask[i] ^= 0xff;
 
+	if (!eccstrength)
+		nand->ecc.strength = (eccbytes * 8) / fls(8 * eccsize);
+
 	return nbc;
 fail:
 	nand_bch_free(nbc);
diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index c553f78..0749ca1 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1807,13 +1807,19 @@ static int omap_nand_probe(struct platform_device *pdev)
 		goto return_error;
 	}
 
+	/*
+	 * Bail out earlier to let NAND_ECC_SOFT code create its own
+	 * ecclayout instead of using ours.
+	 */
+	if (info->ecc_opt == OMAP_ECC_HAM1_CODE_SW) {
+		nand_chip->ecc.mode = NAND_ECC_SOFT;
+		goto scan_tail;
+	}
+
 	/* populate MTD interface based on ECC scheme */
 	ecclayout		= &info->oobinfo;
+	nand_chip->ecc.layout	= ecclayout;
 	switch (info->ecc_opt) {
-	case OMAP_ECC_HAM1_CODE_SW:
-		nand_chip->ecc.mode = NAND_ECC_SOFT;
-		break;
-
 	case OMAP_ECC_HAM1_CODE_HW:
 		pr_info("nand: using OMAP_ECC_HAM1_CODE_HW\n");
 		nand_chip->ecc.mode             = NAND_ECC_HW;
@@ -1861,10 +1867,7 @@ static int omap_nand_probe(struct platform_device *pdev)
 		ecclayout->oobfree->offset	= 1 +
 				ecclayout->eccpos[ecclayout->eccbytes - 1] + 1;
 		/* software bch library is used for locating errors */
-		nand_chip->ecc.priv		= nand_bch_init(mtd,
-							nand_chip->ecc.size,
-							nand_chip->ecc.bytes,
-							&ecclayout);
+		nand_chip->ecc.priv		= nand_bch_init(mtd);
 		if (!nand_chip->ecc.priv) {
 			dev_err(&info->pdev->dev, "unable to use BCH library\n");
 			err = -EINVAL;
@@ -1925,10 +1928,7 @@ static int omap_nand_probe(struct platform_device *pdev)
 		ecclayout->oobfree->offset	= 1 +
 				ecclayout->eccpos[ecclayout->eccbytes - 1] + 1;
 		/* software bch library is used for locating errors */
-		nand_chip->ecc.priv		= nand_bch_init(mtd,
-							nand_chip->ecc.size,
-							nand_chip->ecc.bytes,
-							&ecclayout);
+		nand_chip->ecc.priv		= nand_bch_init(mtd);
 		if (!nand_chip->ecc.priv) {
 			dev_err(&info->pdev->dev, "unable to use BCH library\n");
 			err = -EINVAL;
@@ -2002,9 +2002,6 @@ static int omap_nand_probe(struct platform_device *pdev)
 		goto return_error;
 	}
 
-	if (info->ecc_opt == OMAP_ECC_HAM1_CODE_SW)
-		goto scan_tail;
-
 	/* all OOB bytes from oobfree->offset till end off OOB are free */
 	ecclayout->oobfree->length = mtd->oobsize - ecclayout->oobfree->offset;
 	/* check if NAND device's OOB is enough to store ECC signatures */
@@ -2015,7 +2012,6 @@ static int omap_nand_probe(struct platform_device *pdev)
 		err = -EINVAL;
 		goto return_error;
 	}
-	nand_chip->ecc.layout = ecclayout;
 
 scan_tail:
 	/* second phase scan */
diff --git a/include/linux/mtd/nand_bch.h b/include/linux/mtd/nand_bch.h
index fb0bc34..98f20ef 100644
--- a/include/linux/mtd/nand_bch.h
+++ b/include/linux/mtd/nand_bch.h
@@ -32,9 +32,7 @@ int nand_bch_correct_data(struct mtd_info *mtd, u_char *dat, u_char *read_ecc,
 /*
  * Initialize BCH encoder/decoder
  */
-struct nand_bch_control *
-nand_bch_init(struct mtd_info *mtd, unsigned int eccsize,
-	      unsigned int eccbytes, struct nand_ecclayout **ecclayout);
+struct nand_bch_control *nand_bch_init(struct mtd_info *mtd);
 /*
  * Release BCH encoder/decoder resources
  */
@@ -58,9 +56,7 @@ nand_bch_correct_data(struct mtd_info *mtd, unsigned char *buf,
 	return -ENOTSUPP;
 }
 
-static inline struct nand_bch_control *
-nand_bch_init(struct mtd_info *mtd, unsigned int eccsize,
-	      unsigned int eccbytes, struct nand_ecclayout **ecclayout)
+static inline struct nand_bch_control *nand_bch_init(struct mtd_info *mtd)
 {
 	return NULL;
 }
-- 
2.1.4
