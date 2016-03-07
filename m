From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 46/52] mtd: nand: sm_common: switch to mtd_ooblayout_ops
Date: Mon,  7 Mar 2016 10:47:36 +0100
Message-ID: <1457344062-11633-47-git-send-email-boris.brezillon@free-electrons.com>
References: <1457344062-11633-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBBM66W3AKGQEKNPGMGQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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
 drivers/mtd/nand/sm_common.c | 93 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 77 insertions(+), 16 deletions(-)

diff --git a/drivers/mtd/nand/sm_common.c b/drivers/mtd/nand/sm_common.c
index c514740..5939dff 100644
--- a/drivers/mtd/nand/sm_common.c
+++ b/drivers/mtd/nand/sm_common.c
@@ -12,14 +12,47 @@
 #include <linux/sizes.h>
 #include "sm_common.h"
 
-static struct nand_ecclayout nand_oob_sm = {
-	.eccbytes = 6,
-	.eccpos = {8, 9, 10, 13, 14, 15},
-	.oobfree = {
-		{.offset = 0 , .length = 4}, /* reserved */
-		{.offset = 6 , .length = 2}, /* LBA1 */
-		{.offset = 11, .length = 2}  /* LBA2 */
+static int oob_sm_ooblayout_ecc(struct mtd_info *mtd, int section,
+				struct mtd_oob_region *oobregion)
+{
+	if (section > 1)
+		return -ERANGE;
+
+	oobregion->length = 3;
+	oobregion->offset = ((section + 1) * 8) - 3;
+
+	return 0;
+}
+
+static int oob_sm_ooblayout_free(struct mtd_info *mtd, int section,
+				 struct mtd_oob_region *oobregion)
+{
+	switch (section) {
+	case 0:
+		/* reserved */
+		oobregion->offset = 0;
+		oobregion->length = 4;
+		break;
+	case 1:
+		/* LBA1 */
+		oobregion->offset = 6;
+		oobregion->length = 2;
+		break;
+	case 2:
+		/* LBA2 */
+		oobregion->offset = 11;
+		oobregion->length = 2;
+		break;
+	default:
+		return -ERANGE;
 	}
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops oob_sm_ops = {
+	.ecc = oob_sm_ooblayout_ecc,
+	.free = oob_sm_ooblayout_free,
 };
 
 /* NOTE: This layout is is not compatabable with SmartMedia, */
@@ -28,15 +61,43 @@ static struct nand_ecclayout nand_oob_sm = {
 /* If you use smftl, it will bypass this and work correctly */
 /* If you not, then you break SmartMedia compliance anyway */
 
-static struct nand_ecclayout nand_oob_sm_small = {
-	.eccbytes = 3,
-	.eccpos = {0, 1, 2},
-	.oobfree = {
-		{.offset = 3 , .length = 2}, /* reserved */
-		{.offset = 6 , .length = 2}, /* LBA1 */
+static int oob_sm_small_ooblayout_ecc(struct mtd_info *mtd, int section,
+				      struct mtd_oob_region *oobregion)
+{
+	if (section)
+		return -ERANGE;
+
+	oobregion->length = 3;
+	oobregion->offset = 0;
+
+	return 0;
+}
+
+static int oob_sm_small_ooblayout_free(struct mtd_info *mtd, int section,
+				       struct mtd_oob_region *oobregion)
+{
+	switch (section) {
+	case 0:
+		/* reserved */
+		oobregion->offset = 3;
+		oobregion->length = 2;
+		break;
+	case 1:
+		/* LBA1 */
+		oobregion->offset = 6;
+		oobregion->length = 2;
+		break;
+	default:
+		return -ERANGE;
 	}
-};
 
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops oob_sm_small_ops = {
+	.ecc = oob_sm_small_ooblayout_ecc,
+	.free = oob_sm_small_ooblayout_free,
+};
 
 static int sm_block_markbad(struct mtd_info *mtd, loff_t ofs)
 {
@@ -121,9 +182,9 @@ int sm_register_device(struct mtd_info *mtd, int smartmedia)
 
 	/* ECC layout */
 	if (mtd->writesize == SM_SECTOR_SIZE)
-		chip->ecc.layout = &nand_oob_sm;
+		mtd_set_ooblayout(mtd, &oob_sm_ops);
 	else if (mtd->writesize == SM_SMALL_PAGE)
-		chip->ecc.layout = &nand_oob_sm_small;
+		mtd_set_ooblayout(mtd, &oob_sm_small_ops);
 	else
 		return -ENODEV;
 
-- 
2.1.4
