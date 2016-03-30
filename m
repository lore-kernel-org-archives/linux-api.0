From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v5 37/50] mtd: nand: lpc32xx: switch to mtd_ooblayout_ops
Date: Wed, 30 Mar 2016 18:14:52 +0200
Message-ID: <1459354505-32551-38-git-send-email-boris.brezillon@free-electrons.com>
References: <1459354505-32551-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBXXX563QKGQEFSVQ3DI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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
 drivers/mtd/nand/lpc32xx_mlc.c | 50 ++++++++++++++++++++++++++++--------------
 drivers/mtd/nand/lpc32xx_slc.c | 41 +++++++++++++++++++++++++++-------
 2 files changed, 66 insertions(+), 25 deletions(-)

diff --git a/drivers/mtd/nand/lpc32xx_mlc.c b/drivers/mtd/nand/lpc32xx_mlc.c
index d8c3e7a..f668282 100644
--- a/drivers/mtd/nand/lpc32xx_mlc.c
+++ b/drivers/mtd/nand/lpc32xx_mlc.c
@@ -139,22 +139,37 @@ struct lpc32xx_nand_cfg_mlc {
 	unsigned num_parts;
 };
 
-static struct nand_ecclayout lpc32xx_nand_oob = {
-	.eccbytes = 40,
-	.eccpos = { 6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
-		   22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
-		   38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
-		   54, 55, 56, 57, 58, 59, 60, 61, 62, 63 },
-	.oobfree = {
-		{ .offset = 0,
-		  .length = 6, },
-		{ .offset = 16,
-		  .length = 6, },
-		{ .offset = 32,
-		  .length = 6, },
-		{ .offset = 48,
-		  .length = 6, },
-		},
+static int lpc32xx_ooblayout_ecc(struct mtd_info *mtd, int section,
+				 struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *nand_chip = mtd_to_nand(mtd);
+
+	if (section >= nand_chip->ecc.steps)
+		return -ERANGE;
+
+	oobregion->offset = ((section + 1) * 16) - nand_chip->ecc.bytes;
+	oobregion->length = nand_chip->ecc.bytes;
+
+	return 0;
+}
+
+static int lpc32xx_ooblayout_free(struct mtd_info *mtd, int section,
+				  struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *nand_chip = mtd_to_nand(mtd);
+
+	if (section >= nand_chip->ecc.steps)
+		return -ERANGE;
+
+	oobregion->offset = 16 * section;
+	oobregion->length = 16 - nand_chip->ecc.bytes;
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops lpc32xx_ooblayout_ops = {
+	.ecc = lpc32xx_ooblayout_ecc,
+	.free = lpc32xx_ooblayout_free,
 };
 
 static struct nand_bbt_descr lpc32xx_nand_bbt = {
@@ -713,6 +728,7 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 	nand_chip->ecc.write_oob = lpc32xx_write_oob;
 	nand_chip->ecc.read_oob = lpc32xx_read_oob;
 	nand_chip->ecc.strength = 4;
+	nand_chip->ecc.bytes = 10;
 	nand_chip->waitfunc = lpc32xx_waitfunc;
 
 	nand_chip->options = NAND_NO_SUBPAGE_WRITE;
@@ -751,7 +767,7 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 
 	nand_chip->ecc.mode = NAND_ECC_HW;
 	nand_chip->ecc.size = 512;
-	nand_chip->ecc.layout = &lpc32xx_nand_oob;
+	mtd_set_ooblayout(mtd, &lpc32xx_ooblayout_ops);
 	host->mlcsubpages = mtd->writesize / 512;
 
 	/* initially clear interrupt status */
diff --git a/drivers/mtd/nand/lpc32xx_slc.c b/drivers/mtd/nand/lpc32xx_slc.c
index 10cf8e62..219dd67 100644
--- a/drivers/mtd/nand/lpc32xx_slc.c
+++ b/drivers/mtd/nand/lpc32xx_slc.c
@@ -146,13 +146,38 @@
  * NAND ECC Layout for small page NAND devices
  * Note: For large and huge page devices, the default layouts are used
  */
-static struct nand_ecclayout lpc32xx_nand_oob_16 = {
-	.eccbytes = 6,
-	.eccpos = {10, 11, 12, 13, 14, 15},
-	.oobfree = {
-		{ .offset = 0, .length = 4 },
-		{ .offset = 6, .length = 4 },
-	},
+static int lpc32xx_ooblayout_ecc(struct mtd_info *mtd, int section,
+				 struct mtd_oob_region *oobregion)
+{
+	if (section)
+		return -ERANGE;
+
+	oobregion->length = 6;
+	oobregion->offset = 10;
+
+	return 0;
+}
+
+static int lpc32xx_ooblayout_free(struct mtd_info *mtd, int section,
+				  struct mtd_oob_region *oobregion)
+{
+	if (section > 1)
+		return -ERANGE;
+
+	if (!section) {
+		oobregion->offset = 0;
+		oobregion->length = 4;
+	} else {
+		oobregion->offset = 6;
+		oobregion->length = 4;
+	}
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops lpc32xx_ooblayout_ops = {
+	.ecc = lpc32xx_ooblayout_ecc,
+	.free = lpc32xx_ooblayout_free,
 };
 
 static u8 bbt_pattern[] = {'B', 'b', 't', '0' };
@@ -886,7 +911,7 @@ static int lpc32xx_nand_probe(struct platform_device *pdev)
 	 * custom BBT marker layout.
 	 */
 	if (mtd->writesize <= 512)
-		chip->ecc.layout = &lpc32xx_nand_oob_16;
+		mtd_set_ooblayout(mtd, &lpc32xx_ooblayout_ops);
 
 	/* These sizes remain the same regardless of page size */
 	chip->ecc.size = 256;
-- 
2.5.0
