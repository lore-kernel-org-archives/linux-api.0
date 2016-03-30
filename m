From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v5 32/50] mtd: nand: fsmc: switch to mtd_ooblayout_ops
Date: Wed, 30 Mar 2016 18:14:47 +0200
Message-ID: <1459354505-32551-33-git-send-email-boris.brezillon@free-electrons.com>
References: <1459354505-32551-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBVHX563QKGQEIJGGJLI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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
 drivers/mtd/nand/fsmc_nand.c | 298 ++++++++++++-------------------------------
 1 file changed, 82 insertions(+), 216 deletions(-)

diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index 1bdcd4f..275a98c 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -39,212 +39,6 @@
 #include <linux/amba/bus.h>
 #include <mtd/mtd-abi.h>
 
-static struct nand_ecclayout fsmc_ecc1_128_layout = {
-	.eccbytes = 24,
-	.eccpos = {2, 3, 4, 18, 19, 20, 34, 35, 36, 50, 51, 52,
-		66, 67, 68, 82, 83, 84, 98, 99, 100, 114, 115, 116},
-	.oobfree = {
-		{.offset = 8, .length = 8},
-		{.offset = 24, .length = 8},
-		{.offset = 40, .length = 8},
-		{.offset = 56, .length = 8},
-		{.offset = 72, .length = 8},
-		{.offset = 88, .length = 8},
-		{.offset = 104, .length = 8},
-		{.offset = 120, .length = 8}
-	}
-};
-
-static struct nand_ecclayout fsmc_ecc1_64_layout = {
-	.eccbytes = 12,
-	.eccpos = {2, 3, 4, 18, 19, 20, 34, 35, 36, 50, 51, 52},
-	.oobfree = {
-		{.offset = 8, .length = 8},
-		{.offset = 24, .length = 8},
-		{.offset = 40, .length = 8},
-		{.offset = 56, .length = 8},
-	}
-};
-
-static struct nand_ecclayout fsmc_ecc1_16_layout = {
-	.eccbytes = 3,
-	.eccpos = {2, 3, 4},
-	.oobfree = {
-		{.offset = 8, .length = 8},
-	}
-};
-
-/*
- * ECC4 layout for NAND of pagesize 8192 bytes & OOBsize 256 bytes. 13*16 bytes
- * of OB size is reserved for ECC, Byte no. 0 & 1 reserved for bad block and 46
- * bytes are free for use.
- */
-static struct nand_ecclayout fsmc_ecc4_256_layout = {
-	.eccbytes = 208,
-	.eccpos = {  2,   3,   4,   5,   6,   7,   8,
-		9,  10,  11,  12,  13,  14,
-		18,  19,  20,  21,  22,  23,  24,
-		25,  26,  27,  28,  29,  30,
-		34,  35,  36,  37,  38,  39,  40,
-		41,  42,  43,  44,  45,  46,
-		50,  51,  52,  53,  54,  55,  56,
-		57,  58,  59,  60,  61,  62,
-		66,  67,  68,  69,  70,  71,  72,
-		73,  74,  75,  76,  77,  78,
-		82,  83,  84,  85,  86,  87,  88,
-		89,  90,  91,  92,  93,  94,
-		98,  99, 100, 101, 102, 103, 104,
-		105, 106, 107, 108, 109, 110,
-		114, 115, 116, 117, 118, 119, 120,
-		121, 122, 123, 124, 125, 126,
-		130, 131, 132, 133, 134, 135, 136,
-		137, 138, 139, 140, 141, 142,
-		146, 147, 148, 149, 150, 151, 152,
-		153, 154, 155, 156, 157, 158,
-		162, 163, 164, 165, 166, 167, 168,
-		169, 170, 171, 172, 173, 174,
-		178, 179, 180, 181, 182, 183, 184,
-		185, 186, 187, 188, 189, 190,
-		194, 195, 196, 197, 198, 199, 200,
-		201, 202, 203, 204, 205, 206,
-		210, 211, 212, 213, 214, 215, 216,
-		217, 218, 219, 220, 221, 222,
-		226, 227, 228, 229, 230, 231, 232,
-		233, 234, 235, 236, 237, 238,
-		242, 243, 244, 245, 246, 247, 248,
-		249, 250, 251, 252, 253, 254
-	},
-	.oobfree = {
-		{.offset = 15, .length = 3},
-		{.offset = 31, .length = 3},
-		{.offset = 47, .length = 3},
-		{.offset = 63, .length = 3},
-		{.offset = 79, .length = 3},
-		{.offset = 95, .length = 3},
-		{.offset = 111, .length = 3},
-		{.offset = 127, .length = 3},
-		{.offset = 143, .length = 3},
-		{.offset = 159, .length = 3},
-		{.offset = 175, .length = 3},
-		{.offset = 191, .length = 3},
-		{.offset = 207, .length = 3},
-		{.offset = 223, .length = 3},
-		{.offset = 239, .length = 3},
-		{.offset = 255, .length = 1}
-	}
-};
-
-/*
- * ECC4 layout for NAND of pagesize 4096 bytes & OOBsize 224 bytes. 13*8 bytes
- * of OOB size is reserved for ECC, Byte no. 0 & 1 reserved for bad block & 118
- * bytes are free for use.
- */
-static struct nand_ecclayout fsmc_ecc4_224_layout = {
-	.eccbytes = 104,
-	.eccpos = {  2,   3,   4,   5,   6,   7,   8,
-		9,  10,  11,  12,  13,  14,
-		18,  19,  20,  21,  22,  23,  24,
-		25,  26,  27,  28,  29,  30,
-		34,  35,  36,  37,  38,  39,  40,
-		41,  42,  43,  44,  45,  46,
-		50,  51,  52,  53,  54,  55,  56,
-		57,  58,  59,  60,  61,  62,
-		66,  67,  68,  69,  70,  71,  72,
-		73,  74,  75,  76,  77,  78,
-		82,  83,  84,  85,  86,  87,  88,
-		89,  90,  91,  92,  93,  94,
-		98,  99, 100, 101, 102, 103, 104,
-		105, 106, 107, 108, 109, 110,
-		114, 115, 116, 117, 118, 119, 120,
-		121, 122, 123, 124, 125, 126
-	},
-	.oobfree = {
-		{.offset = 15, .length = 3},
-		{.offset = 31, .length = 3},
-		{.offset = 47, .length = 3},
-		{.offset = 63, .length = 3},
-		{.offset = 79, .length = 3},
-		{.offset = 95, .length = 3},
-		{.offset = 111, .length = 3},
-		{.offset = 127, .length = 97}
-	}
-};
-
-/*
- * ECC4 layout for NAND of pagesize 4096 bytes & OOBsize 128 bytes. 13*8 bytes
- * of OOB size is reserved for ECC, Byte no. 0 & 1 reserved for bad block & 22
- * bytes are free for use.
- */
-static struct nand_ecclayout fsmc_ecc4_128_layout = {
-	.eccbytes = 104,
-	.eccpos = {  2,   3,   4,   5,   6,   7,   8,
-		9,  10,  11,  12,  13,  14,
-		18,  19,  20,  21,  22,  23,  24,
-		25,  26,  27,  28,  29,  30,
-		34,  35,  36,  37,  38,  39,  40,
-		41,  42,  43,  44,  45,  46,
-		50,  51,  52,  53,  54,  55,  56,
-		57,  58,  59,  60,  61,  62,
-		66,  67,  68,  69,  70,  71,  72,
-		73,  74,  75,  76,  77,  78,
-		82,  83,  84,  85,  86,  87,  88,
-		89,  90,  91,  92,  93,  94,
-		98,  99, 100, 101, 102, 103, 104,
-		105, 106, 107, 108, 109, 110,
-		114, 115, 116, 117, 118, 119, 120,
-		121, 122, 123, 124, 125, 126
-	},
-	.oobfree = {
-		{.offset = 15, .length = 3},
-		{.offset = 31, .length = 3},
-		{.offset = 47, .length = 3},
-		{.offset = 63, .length = 3},
-		{.offset = 79, .length = 3},
-		{.offset = 95, .length = 3},
-		{.offset = 111, .length = 3},
-		{.offset = 127, .length = 1}
-	}
-};
-
-/*
- * ECC4 layout for NAND of pagesize 2048 bytes & OOBsize 64 bytes. 13*4 bytes of
- * OOB size is reserved for ECC, Byte no. 0 & 1 reserved for bad block and 10
- * bytes are free for use.
- */
-static struct nand_ecclayout fsmc_ecc4_64_layout = {
-	.eccbytes = 52,
-	.eccpos = {  2,   3,   4,   5,   6,   7,   8,
-		9,  10,  11,  12,  13,  14,
-		18,  19,  20,  21,  22,  23,  24,
-		25,  26,  27,  28,  29,  30,
-		34,  35,  36,  37,  38,  39,  40,
-		41,  42,  43,  44,  45,  46,
-		50,  51,  52,  53,  54,  55,  56,
-		57,  58,  59,  60,  61,  62,
-	},
-	.oobfree = {
-		{.offset = 15, .length = 3},
-		{.offset = 31, .length = 3},
-		{.offset = 47, .length = 3},
-		{.offset = 63, .length = 1},
-	}
-};
-
-/*
- * ECC4 layout for NAND of pagesize 512 bytes & OOBsize 16 bytes. 13 bytes of
- * OOB size is reserved for ECC, Byte no. 4 & 5 reserved for bad block and One
- * byte is free for use.
- */
-static struct nand_ecclayout fsmc_ecc4_16_layout = {
-	.eccbytes = 13,
-	.eccpos = { 0,  1,  2,  3,  6,  7, 8,
-		9, 10, 11, 12, 13, 14
-	},
-	.oobfree = {
-		{.offset = 15, .length = 1},
-	}
-};
-
 /*
  * ECC placement definitions in oobfree type format.
  * There are 13 bytes of ecc for every 512 byte block and it has to be read
@@ -274,6 +68,84 @@ static struct fsmc_eccplace fsmc_ecc4_sp_place = {
 	}
 };
 
+static int fsmc_ecc1_ooblayout_ecc(struct mtd_info *mtd, int section,
+				   struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *chip = mtd_to_nand(mtd);
+
+	if (section >= chip->ecc.steps)
+		return -ERANGE;
+
+	oobregion->offset = (section * 16) + 2;
+	oobregion->length = 3;
+
+	return 0;
+}
+
+static int fsmc_ecc1_ooblayout_free(struct mtd_info *mtd, int section,
+				    struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *chip = mtd_to_nand(mtd);
+
+	if (section >= chip->ecc.steps)
+		return -ERANGE;
+
+	oobregion->offset = (section * 16) + 8;
+
+	if (section < chip->ecc.steps - 1)
+		oobregion->length = 8;
+	else
+		oobregion->length = mtd->oobsize - oobregion->offset;
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops fsmc_ecc1_ooblayout_ops = {
+	.ecc = fsmc_ecc1_ooblayout_ecc,
+	.free = fsmc_ecc1_ooblayout_free,
+};
+
+static int fsmc_ecc4_ooblayout_ecc(struct mtd_info *mtd, int section,
+				   struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *chip = mtd_to_nand(mtd);
+
+	if (section >= chip->ecc.steps)
+		return -ERANGE;
+
+	oobregion->length = chip->ecc.bytes;
+
+	if (!section && mtd->writesize <= 512)
+		oobregion->offset = 0;
+	else
+		oobregion->offset = (section * 16) + 2;
+
+	return 0;
+}
+
+static int fsmc_ecc4_ooblayout_free(struct mtd_info *mtd, int section,
+				    struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *chip = mtd_to_nand(mtd);
+
+	if (section >= chip->ecc.steps)
+		return -ERANGE;
+
+	oobregion->offset = (section * 16) + 15;
+
+	if (section < chip->ecc.steps - 1)
+		oobregion->length = 3;
+	else
+		oobregion->length = mtd->oobsize - oobregion->offset;
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops fsmc_ecc4_ooblayout_ops = {
+	.ecc = fsmc_ecc4_ooblayout_ecc,
+	.free = fsmc_ecc4_ooblayout_free,
+};
+
 /**
  * struct fsmc_nand_data - structure for FSMC NAND device state
  *
@@ -1084,23 +956,18 @@ static int __init fsmc_nand_probe(struct platform_device *pdev)
 	if (AMBA_REV_BITS(host->pid) >= 8) {
 		switch (mtd->oobsize) {
 		case 16:
-			nand->ecc.layout = &fsmc_ecc4_16_layout;
 			host->ecc_place = &fsmc_ecc4_sp_place;
 			break;
 		case 64:
-			nand->ecc.layout = &fsmc_ecc4_64_layout;
 			host->ecc_place = &fsmc_ecc4_lp_place;
 			break;
 		case 128:
-			nand->ecc.layout = &fsmc_ecc4_128_layout;
 			host->ecc_place = &fsmc_ecc4_lp_place;
 			break;
 		case 224:
-			nand->ecc.layout = &fsmc_ecc4_224_layout;
 			host->ecc_place = &fsmc_ecc4_lp_place;
 			break;
 		case 256:
-			nand->ecc.layout = &fsmc_ecc4_256_layout;
 			host->ecc_place = &fsmc_ecc4_lp_place;
 			break;
 		default:
@@ -1109,6 +976,8 @@ static int __init fsmc_nand_probe(struct platform_device *pdev)
 			ret = -EINVAL;
 			goto err_probe;
 		}
+
+		mtd_set_ooblayout(mtd, &fsmc_ecc4_ooblayout_ops);
 	} else {
 		switch (nand->ecc.mode) {
 		case NAND_ECC_HW:
@@ -1135,13 +1004,10 @@ static int __init fsmc_nand_probe(struct platform_device *pdev)
 		if (nand->ecc.mode != NAND_ECC_SOFT_BCH) {
 			switch (mtd->oobsize) {
 			case 16:
-				nand->ecc.layout = &fsmc_ecc1_16_layout;
-				break;
 			case 64:
-				nand->ecc.layout = &fsmc_ecc1_64_layout;
-				break;
 			case 128:
-				nand->ecc.layout = &fsmc_ecc1_128_layout;
+				mtd_set_ooblayout(mtd,
+						  &fsmc_ecc1_ooblayout_ops);
 				break;
 			default:
 				dev_warn(&pdev->dev,
-- 
2.5.0
