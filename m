From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 49/52] mtd: onenand: switch to mtd_ooblayout_ops
Date: Mon,  7 Mar 2016 10:47:39 +0100
Message-ID: <1457344062-11633-50-git-send-email-boris.brezillon@free-electrons.com>
References: <1457344062-11633-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBNM66W3AKGQECWDSMCQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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
ECC/OOB layout to MTD users. Modify the onenand drivers to switch to this
approach.

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
---
 drivers/mtd/onenand/onenand_base.c | 162 ++++++++++++++++++++++---------------
 include/linux/mtd/onenand.h        |   2 -
 2 files changed, 97 insertions(+), 67 deletions(-)

diff --git a/drivers/mtd/onenand/onenand_base.c b/drivers/mtd/onenand/onenand_base.c
index d0fa505..a4b029a 100644
--- a/drivers/mtd/onenand/onenand_base.c
+++ b/drivers/mtd/onenand/onenand_base.c
@@ -68,21 +68,33 @@ MODULE_PARM_DESC(otp,	"Corresponding behaviour of OneNAND in OTP"
  * flexonenand_oob_128 - oob info for Flex-Onenand with 4KB page
  * For now, we expose only 64 out of 80 ecc bytes
  */
-static struct nand_ecclayout flexonenand_oob_128 = {
-	.eccbytes	= 64,
-	.eccpos		= {
-		6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
-		22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
-		38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
-		54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
-		70, 71, 72, 73, 74, 75, 76, 77, 78, 79,
-		86, 87, 88, 89, 90, 91, 92, 93, 94, 95,
-		102, 103, 104, 105
-		},
-	.oobfree	= {
-		{2, 4}, {18, 4}, {34, 4}, {50, 4},
-		{66, 4}, {82, 4}, {98, 4}, {114, 4}
-	}
+static int flexonenand_ooblayout_ecc(struct mtd_info *mtd, int section,
+				     struct mtd_oob_region *oobregion)
+{
+	if (section > 7)
+		return -ERANGE;
+
+	oobregion->offset = (section * 16) + 6;
+	oobregion->length = 10;
+
+	return 0;
+}
+
+static int flexonenand_ooblayout_free(struct mtd_info *mtd, int section,
+				      struct mtd_oob_region *oobregion)
+{
+	if (section > 7)
+		return -ERANGE;
+
+	oobregion->offset = (section * 16) + 2;
+	oobregion->length = 4;
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops flexonenand_ooblayout_ops = {
+	.ecc = flexonenand_ooblayout_ecc,
+	.free = flexonenand_ooblayout_free,
 };
 
 /*
@@ -91,56 +103,77 @@ static struct nand_ecclayout flexonenand_oob_128 = {
  * Based on specification:
  * 4Gb M-die OneNAND Flash (KFM4G16Q4M, KFN8G16Q4M). Rev. 1.3, Apr. 2010
  *
- * For eccpos we expose only 64 bytes out of 72 (see struct nand_ecclayout)
- *
- * oobfree uses the spare area fields marked as
- * "Managed by internal ECC logic for Logical Sector Number area"
- */
-static struct nand_ecclayout onenand_oob_128 = {
-	.eccbytes	= 64,
-	.eccpos		= {
-		7, 8, 9, 10, 11, 12, 13, 14, 15,
-		23, 24, 25, 26, 27, 28, 29, 30, 31,
-		39, 40, 41, 42, 43, 44, 45, 46, 47,
-		55, 56, 57, 58, 59, 60, 61, 62, 63,
-		71, 72, 73, 74, 75, 76, 77, 78, 79,
-		87, 88, 89, 90, 91, 92, 93, 94, 95,
-		103, 104, 105, 106, 107, 108, 109, 110, 111,
-		119
-	},
-	.oobfree	= {
-		{2, 3}, {18, 3}, {34, 3}, {50, 3},
-		{66, 3}, {82, 3}, {98, 3}, {114, 3}
-	}
+ */
+static int onenand_ooblayout_128_ecc(struct mtd_info *mtd, int section,
+				     struct mtd_oob_region *oobregion)
+{
+	if (section > 7)
+		return -ERANGE;
+
+	oobregion->offset = (section * 16) + 7;
+	oobregion->length = 9;
+
+	return 0;
+}
+
+static int onenand_ooblayout_128_free(struct mtd_info *mtd, int section,
+				      struct mtd_oob_region *oobregion)
+{
+	if (section >= 8)
+		return -ERANGE;
+
+	/*
+	 * free bytes are using the spare area fields marked as
+	 * "Managed by internal ECC logic for Logical Sector Number area"
+	 */
+	oobregion->offset = (section * 16) + 2;
+	oobregion->length = 3;
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops onenand_oob_128_ooblayout_ops = {
+	.ecc = onenand_ooblayout_128_ecc,
+	.free = onenand_ooblayout_128_free,
 };
 
 /**
- * onenand_oob_64 - oob info for large (2KB) page
+ * onenand_oob_32_64 - oob info for large (2KB) page
  */
-static struct nand_ecclayout onenand_oob_64 = {
-	.eccbytes	= 20,
-	.eccpos		= {
-		8, 9, 10, 11, 12,
-		24, 25, 26, 27, 28,
-		40, 41, 42, 43, 44,
-		56, 57, 58, 59, 60,
-		},
-	.oobfree	= {
-		{2, 3}, {14, 2}, {18, 3}, {30, 2},
-		{34, 3}, {46, 2}, {50, 3}, {62, 2}
+static int onenand_ooblayout_32_64_ecc(struct mtd_info *mtd, int section,
+				       struct mtd_oob_region *oobregion)
+{
+	if (section > 3)
+		return -ERANGE;
+
+	oobregion->offset = (section * 16) + 8;
+	oobregion->length = 5;
+
+	return 0;
+}
+
+static int onenand_ooblayout_32_64_free(struct mtd_info *mtd, int section,
+					struct mtd_oob_region *oobregion)
+{
+	int sections = (mtd->oobsize / 32) * 2;
+
+	if (section >= sections)
+		return -ERANGE;
+
+	if (section & 1) {
+		oobregion->offset = ((section - 1) * 16) + 14;
+		oobregion->length = 2;
+	} else  {
+		oobregion->offset = (section * 16) + 2;
+		oobregion->length = 3;
 	}
-};
 
-/**
- * onenand_oob_32 - oob info for middle (1KB) page
- */
-static struct nand_ecclayout onenand_oob_32 = {
-	.eccbytes	= 10,
-	.eccpos		= {
-		8, 9, 10, 11, 12,
-		24, 25, 26, 27, 28,
-		},
-	.oobfree	= { {2, 3}, {14, 2}, {18, 3}, {30, 2} }
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops onenand_oob_32_64_ooblayout_ops = {
+	.ecc = onenand_ooblayout_32_64_ecc,
+	.free = onenand_ooblayout_32_64_free,
 };
 
 static const unsigned char ffchars[] = {
@@ -3957,22 +3990,22 @@ int onenand_scan(struct mtd_info *mtd, int maxchips)
 	switch (mtd->oobsize) {
 	case 128:
 		if (FLEXONENAND(this)) {
-			this->ecclayout = &flexonenand_oob_128;
+			mtd_set_ooblayout(mtd, &flexonenand_ooblayout_ops);
 			mtd->subpage_sft = 0;
 		} else {
-			this->ecclayout = &onenand_oob_128;
+			mtd_set_ooblayout(mtd, &onenand_oob_128_ooblayout_ops);
 			mtd->subpage_sft = 2;
 		}
 		if (ONENAND_IS_NOP_1(this))
 			mtd->subpage_sft = 0;
 		break;
 	case 64:
-		this->ecclayout = &onenand_oob_64;
+		mtd_set_ooblayout(mtd, &onenand_oob_32_64_ooblayout_ops);
 		mtd->subpage_sft = 2;
 		break;
 
 	case 32:
-		this->ecclayout = &onenand_oob_32;
+		mtd_set_ooblayout(mtd, &onenand_oob_32_64_ooblayout_ops);
 		mtd->subpage_sft = 1;
 		break;
 
@@ -3981,7 +4014,7 @@ int onenand_scan(struct mtd_info *mtd, int maxchips)
 			__func__, mtd->oobsize);
 		mtd->subpage_sft = 0;
 		/* To prevent kernel oops */
-		this->ecclayout = &onenand_oob_32;
+		mtd_set_ooblayout(mtd, &onenand_oob_32_64_ooblayout_ops);
 		break;
 	}
 
@@ -3997,7 +4030,6 @@ int onenand_scan(struct mtd_info *mtd, int maxchips)
 
 	mtd->oobavail = ret;
 
-	mtd_set_ecclayout(mtd, this->ecclayout);
 	mtd->ecc_strength = 1;
 
 	/* Fill in remaining MTD driver data */
diff --git a/include/linux/mtd/onenand.h b/include/linux/mtd/onenand.h
index 4596503..0aaa98b 100644
--- a/include/linux/mtd/onenand.h
+++ b/include/linux/mtd/onenand.h
@@ -80,7 +80,6 @@ struct onenand_bufferram {
  * @page_buf:		[INTERN] page main data buffer
  * @oob_buf:		[INTERN] page oob data buffer
  * @subpagesize:	[INTERN] holds the subpagesize
- * @ecclayout:		[REPLACEABLE] the default ecc placement scheme
  * @bbm:		[REPLACEABLE] pointer to Bad Block Management
  * @priv:		[OPTIONAL] pointer to private chip date
  */
@@ -134,7 +133,6 @@ struct onenand_chip {
 #endif
 
 	int			subpagesize;
-	struct nand_ecclayout	*ecclayout;
 
 	void			*bbm;
 
-- 
2.1.4
