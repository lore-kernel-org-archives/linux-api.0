From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v5 28/50] mtd: nand: diskonchip: switch to mtd_ooblayout_ops
Date: Wed, 30 Mar 2016 18:14:43 +0200
Message-ID: <1459354505-32551-29-git-send-email-boris.brezillon@free-electrons.com>
References: <1459354505-32551-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBPXX563QKGQE6UPAEII-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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
 drivers/mtd/nand/diskonchip.c | 60 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 15 deletions(-)

diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index 547c100..a023ab9 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -950,20 +950,50 @@ static int doc200x_correct_data(struct mtd_info *mtd, u_char *dat,
 
 //u_char mydatabuf[528];
 
-/* The strange out-of-order .oobfree list below is a (possibly unneeded)
- * attempt to retain compatibility.  It used to read:
- * 	.oobfree = { {8, 8} }
- * Since that leaves two bytes unusable, it was changed.  But the following
- * scheme might affect existing jffs2 installs by moving the cleanmarker:
- * 	.oobfree = { {6, 10} }
- * jffs2 seems to handle the above gracefully, but the current scheme seems
- * safer.  The only problem with it is that any code that parses oobfree must
- * be able to handle out-of-order segments.
- */
-static struct nand_ecclayout doc200x_oobinfo = {
-	.eccbytes = 6,
-	.eccpos = {0, 1, 2, 3, 4, 5},
-	.oobfree = {{8, 8}, {6, 2}}
+static int doc200x_ooblayout_ecc(struct mtd_info *mtd, int section,
+				 struct mtd_oob_region *oobregion)
+{
+	if (section)
+		return -ERANGE;
+
+	oobregion->offset = 0;
+	oobregion->length = 6;
+
+	return 0;
+}
+
+static int doc200x_ooblayout_free(struct mtd_info *mtd, int section,
+				  struct mtd_oob_region *oobregion)
+{
+	if (section > 1)
+		return -ERANGE;
+
+	/*
+	 * The strange out-of-order free bytes definition is a (possibly
+	 * unneeded) attempt to retain compatibility.  It used to read:
+	 *	.oobfree = { {8, 8} }
+	 * Since that leaves two bytes unusable, it was changed.  But the
+	 * following scheme might affect existing jffs2 installs by moving the
+	 * cleanmarker:
+	 *	.oobfree = { {6, 10} }
+	 * jffs2 seems to handle the above gracefully, but the current scheme
+	 * seems safer. The only problem with it is that any code retrieving
+	 * free bytes position must be able to handle out-of-order segments.
+	 */
+	if (!section) {
+		oobregion->offset = 8;
+		oobregion->length = 8;
+	} else {
+		oobregion->offset = 6;
+		oobregion->length = 2;
+	}
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops doc200x_ooblayout_ops = {
+	.ecc = doc200x_ooblayout_ecc,
+	.free = doc200x_ooblayout_free,
 };
 
 /* Find the (I)NFTL Media Header, and optionally also the mirror media header.
@@ -1537,6 +1567,7 @@ static int __init doc_probe(unsigned long physadr)
 	nand->bbt_md		= nand->bbt_td + 1;
 
 	mtd->owner		= THIS_MODULE;
+	mtd_set_ooblayout(mtd, &doc200x_ooblayout_ops);
 
 	nand_set_controller_data(nand, doc);
 	nand->select_chip	= doc200x_select_chip;
@@ -1548,7 +1579,6 @@ static int __init doc_probe(unsigned long physadr)
 	nand->ecc.calculate	= doc200x_calculate_ecc;
 	nand->ecc.correct	= doc200x_correct_data;
 
-	nand->ecc.layout	= &doc200x_oobinfo;
 	nand->ecc.mode		= NAND_ECC_HW_SYNDROME;
 	nand->ecc.size		= 512;
 	nand->ecc.bytes		= 6;
-- 
2.5.0
