From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 24/52] mtd: nand: jz4740: switch to mtd_ooblayout_ops
Date: Fri, 26 Feb 2016 01:57:32 +0100
Message-ID: <1456448280-27788-25-git-send-email-boris.brezillon@free-electrons.com>
References: <1456448280-27788-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBV6IX23AKGQEKWXZIYI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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
 arch/mips/include/asm/mach-jz4740/jz4740_nand.h |  2 +-
 arch/mips/jz4740/board-qi_lb60.c                | 87 +++++++++++++++----------
 drivers/mtd/nand/jz4740_nand.c                  |  2 +-
 3 files changed, 53 insertions(+), 38 deletions(-)

diff --git a/arch/mips/include/asm/mach-jz4740/jz4740_nand.h b/arch/mips/include/asm/mach-jz4740/jz4740_nand.h
index 398733e..7f7b0fc 100644
--- a/arch/mips/include/asm/mach-jz4740/jz4740_nand.h
+++ b/arch/mips/include/asm/mach-jz4740/jz4740_nand.h
@@ -27,7 +27,7 @@ struct jz_nand_platform_data {
 
 	unsigned char banks[JZ_NAND_NUM_BANKS];
 
-	void (*ident_callback)(struct platform_device *, struct nand_chip *,
+	void (*ident_callback)(struct platform_device *, struct mtd_info *,
 				struct mtd_partition **, int *num_partitions);
 };
 
diff --git a/arch/mips/jz4740/board-qi_lb60.c b/arch/mips/jz4740/board-qi_lb60.c
index 934b15b..a1c1afb 100644
--- a/arch/mips/jz4740/board-qi_lb60.c
+++ b/arch/mips/jz4740/board-qi_lb60.c
@@ -50,20 +50,6 @@ static bool is_avt2;
 #define QI_LB60_GPIO_KEYIN8		JZ_GPIO_PORTD(26)
 
 /* NAND */
-static struct nand_ecclayout qi_lb60_ecclayout_1gb = {
-	.eccbytes = 36,
-	.eccpos = {
-		6,  7,	8,  9,	10, 11, 12, 13,
-		14, 15, 16, 17, 18, 19, 20, 21,
-		22, 23, 24, 25, 26, 27, 28, 29,
-		30, 31, 32, 33, 34, 35, 36, 37,
-		38, 39, 40, 41
-	},
-	.oobfree = {
-		{ .offset = 2, .length = 4 },
-		{ .offset = 42, .length = 22 }
-	},
-};
 
 /* Early prototypes of the QI LB60 had only 1GB of NAND.
  * In order to support these devices as well the partition and ecc layout is
@@ -86,25 +72,6 @@ static struct mtd_partition qi_lb60_partitions_1gb[] = {
 	},
 };
 
-static struct nand_ecclayout qi_lb60_ecclayout_2gb = {
-	.eccbytes = 72,
-	.eccpos = {
-		12, 13, 14, 15, 16, 17, 18, 19,
-		20, 21, 22, 23, 24, 25, 26, 27,
-		28, 29, 30, 31, 32, 33, 34, 35,
-		36, 37, 38, 39, 40, 41, 42, 43,
-		44, 45, 46, 47, 48, 49, 50, 51,
-		52, 53, 54, 55, 56, 57, 58, 59,
-		60, 61, 62, 63, 64, 65, 66, 67,
-		68, 69, 70, 71, 72, 73, 74, 75,
-		76, 77, 78, 79, 80, 81, 82, 83
-	},
-	.oobfree = {
-		{ .offset = 2, .length = 10 },
-		{ .offset = 84, .length = 44 },
-	},
-};
-
 static struct mtd_partition qi_lb60_partitions_2gb[] = {
 	{
 		.name = "NAND BOOT partition",
@@ -123,19 +90,67 @@ static struct mtd_partition qi_lb60_partitions_2gb[] = {
 	},
 };
 
+static int qi_lb60_ooblayout_ecc(struct mtd_info *mtd, int section,
+				 struct mtd_oob_region *oobregion)
+{
+	if (section)
+		return -ERANGE;
+
+	oobregion->length = 36;
+	oobregion->offset = 6;
+
+	if (mtd->oobsize == 128) {
+		oobregion->length *= 2;
+		oobregion->offset *= 2;
+	}
+
+	return 0;
+}
+
+static int qi_lb60_ooblayout_free(struct mtd_info *mtd, int section,
+				  struct mtd_oob_region *oobregion)
+{
+	int eccbytes = 36, eccoff = 6;
+
+	if (section > 1)
+		return -ERANGE;
+
+	if (mtd->oobsize == 128) {
+		eccbytes *= 2;
+		eccoff *= 2;
+	}
+
+	if (!section) {
+		oobregion->offset = 2;
+		oobregion->length = eccoff - 2;
+	} else {
+		oobregion->offset = eccoff + eccbytes;
+		oobregion->length = mtd->oobsize - oobregion->offset;
+	}
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops qi_lb60_ooblayout_ops = {
+	.ecc = qi_lb60_ooblayout_ecc,
+	.free = qi_lb60_ooblayout_free,
+};
+
 static void qi_lb60_nand_ident(struct platform_device *pdev,
-		struct nand_chip *chip, struct mtd_partition **partitions,
+		struct mtd_info *mtd, struct mtd_partition **partitions,
 		int *num_partitions)
 {
+	struct nand_chip *chip = mtd_to_nand(mtd);
+
 	if (chip->page_shift == 12) {
-		chip->ecc.layout = &qi_lb60_ecclayout_2gb;
 		*partitions = qi_lb60_partitions_2gb;
 		*num_partitions = ARRAY_SIZE(qi_lb60_partitions_2gb);
 	} else {
-		chip->ecc.layout = &qi_lb60_ecclayout_1gb;
 		*partitions = qi_lb60_partitions_1gb;
 		*num_partitions = ARRAY_SIZE(qi_lb60_partitions_1gb);
 	}
+
+	mtd_set_ooblayout(mtd, &qi_lb60_ooblayout_ops);
 }
 
 static struct jz_nand_platform_data qi_lb60_nand_pdata = {
diff --git a/drivers/mtd/nand/jz4740_nand.c b/drivers/mtd/nand/jz4740_nand.c
index 673ceb2..df74408 100644
--- a/drivers/mtd/nand/jz4740_nand.c
+++ b/drivers/mtd/nand/jz4740_nand.c
@@ -476,7 +476,7 @@ static int jz_nand_probe(struct platform_device *pdev)
 	}
 
 	if (pdata && pdata->ident_callback) {
-		pdata->ident_callback(pdev, chip, &pdata->partitions,
+		pdata->ident_callback(pdev, mtd, &pdata->partitions,
 					&pdata->num_partitions);
 	}
 
-- 
2.1.4
