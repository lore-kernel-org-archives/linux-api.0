From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 29/52] mtd: nand: davinci: switch to mtd_ooblayout_ops
Date: Mon,  7 Mar 2016 10:47:19 +0100
Message-ID: <1457344062-11633-30-git-send-email-boris.brezillon@free-electrons.com>
References: <1457344062-11633-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBB7E46W3AKGQEBXIODKI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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
 drivers/mtd/nand/davinci_nand.c | 118 +++++++++++++++-------------------------
 1 file changed, 44 insertions(+), 74 deletions(-)

diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
index 8cb821b..fe3fd29 100644
--- a/drivers/mtd/nand/davinci_nand.c
+++ b/drivers/mtd/nand/davinci_nand.c
@@ -54,7 +54,6 @@
  */
 struct davinci_nand_info {
 	struct nand_chip	chip;
-	struct nand_ecclayout	ecclayout;
 
 	struct device		*dev;
 	struct clk		*clk;
@@ -480,63 +479,46 @@ static int nand_davinci_dev_ready(struct mtd_info *mtd)
  * ten ECC bytes plus the manufacturer's bad block marker byte, and
  * and not overlapping the default BBT markers.
  */
-static struct nand_ecclayout hwecc4_small = {
-	.eccbytes = 10,
-	.eccpos = { 0, 1, 2, 3, 4,
-		/* offset 5 holds the badblock marker */
-		6, 7,
-		13, 14, 15, },
-	.oobfree = {
-		{.offset = 8, .length = 5, },
-		{.offset = 16, },
-	},
-};
+static int hwecc4_ooblayout_small_ecc(struct mtd_info *mtd, int section,
+				      struct mtd_oob_region *oobregion)
+{
+	if (section > 2)
+		return -ERANGE;
+
+	if (!section) {
+		oobregion->offset = 0;
+		oobregion->length = 5;
+	} else if (section == 1) {
+		oobregion->offset = 6;
+		oobregion->length = 2;
+	} else {
+		oobregion->offset = 13;
+		oobregion->length = 3;
+	}
 
-/* An ECC layout for using 4-bit ECC with large-page (2048bytes) flash,
- * storing ten ECC bytes plus the manufacturer's bad block marker byte,
- * and not overlapping the default BBT markers.
- */
-static struct nand_ecclayout hwecc4_2048 = {
-	.eccbytes = 40,
-	.eccpos = {
-		/* at the end of spare sector */
-		24, 25, 26, 27, 28, 29,	30, 31, 32, 33,
-		34, 35, 36, 37, 38, 39,	40, 41, 42, 43,
-		44, 45, 46, 47, 48, 49, 50, 51, 52, 53,
-		54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
-		},
-	.oobfree = {
-		/* 2 bytes at offset 0 hold manufacturer badblock markers */
-		{.offset = 2, .length = 22, },
-		/* 5 bytes at offset 8 hold BBT markers */
-		/* 8 bytes at offset 16 hold JFFS2 clean markers */
-	},
-};
+	return 0;
+}
 
-/*
- * An ECC layout for using 4-bit ECC with large-page (4096bytes) flash,
- * storing ten ECC bytes plus the manufacturer's bad block marker byte,
- * and not overlapping the default BBT markers.
- */
-static struct nand_ecclayout hwecc4_4096 = {
-	.eccbytes = 80,
-	.eccpos = {
-		/* at the end of spare sector */
-		48, 49, 50, 51, 52, 53, 54, 55, 56, 57,
-		58, 59, 60, 61, 62, 63, 64, 65, 66, 67,
-		68, 69, 70, 71, 72, 73, 74, 75, 76, 77,
-		78, 79, 80, 81, 82, 83, 84, 85, 86, 87,
-		88, 89, 90, 91, 92, 93, 94, 95, 96, 97,
-		98, 99, 100, 101, 102, 103, 104, 105, 106, 107,
-		108, 109, 110, 111, 112, 113, 114, 115, 116, 117,
-		118, 119, 120, 121, 122, 123, 124, 125, 126, 127,
-	},
-	.oobfree = {
-		/* 2 bytes at offset 0 hold manufacturer badblock markers */
-		{.offset = 2, .length = 46, },
-		/* 5 bytes at offset 8 hold BBT markers */
-		/* 8 bytes at offset 16 hold JFFS2 clean markers */
-	},
+static int hwecc4_ooblayout_small_free(struct mtd_info *mtd, int section,
+				       struct mtd_oob_region *oobregion)
+{
+	if (section > 1)
+		return -ERANGE;
+
+	if (!section) {
+		oobregion->offset = 8;
+		oobregion->length = 5;
+	} else {
+		oobregion->offset = 16;
+		oobregion->length = mtd->oobsize - 16;
+	}
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops hwecc4_small_ooblayout_ops = {
+	.ecc = hwecc4_ooblayout_small_ecc,
+	.free = hwecc4_ooblayout_small_free,
 };
 
 #if defined(CONFIG_OF)
@@ -805,26 +787,14 @@ static int nand_davinci_probe(struct platform_device *pdev)
 		 * table marker fits in the free bytes.
 		 */
 		if (chunks == 1) {
-			info->ecclayout = hwecc4_small;
-			info->ecclayout.oobfree[1].length = mtd->oobsize - 16;
-			goto syndrome_done;
-		}
-		if (chunks == 4) {
-			info->ecclayout = hwecc4_2048;
+			mtd_set_ooblayout(mtd, &hwecc4_small_ooblayout_ops);
+		} else if (chunks == 4 || chunks == 8) {
+			mtd_set_ooblayout(mtd, &nand_ooblayout_lp_ops);
 			info->chip.ecc.mode = NAND_ECC_HW_OOB_FIRST;
-			goto syndrome_done;
-		}
-		if (chunks == 8) {
-			info->ecclayout = hwecc4_4096;
-			info->chip.ecc.mode = NAND_ECC_HW_OOB_FIRST;
-			goto syndrome_done;
+		} else {
+			ret = -EIO;
+			goto err;
 		}
-
-		ret = -EIO;
-		goto err;
-
-syndrome_done:
-		info->chip.ecc.layout = &info->ecclayout;
 	}
 
 	ret = nand_scan_tail(mtd);
-- 
2.1.4
