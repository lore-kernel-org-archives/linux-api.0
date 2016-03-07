From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 37/52] mtd: nand: gpmi: switch to mtd_ooblayout_ops
Date: Mon,  7 Mar 2016 10:47:27 +0100
Message-ID: <1457344062-11633-38-git-send-email-boris.brezillon@free-electrons.com>
References: <1457344062-11633-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBJ456W3AKGQEZAMYSII-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 52 ++++++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 12 deletions(-)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index 3a29b65..316b5ac 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -47,10 +47,44 @@ static struct nand_bbt_descr gpmi_bbt_descr = {
  * We may change the layout if we can get the ECC info from the datasheet,
  * else we will use all the (page + OOB).
  */
-static struct nand_ecclayout gpmi_hw_ecclayout = {
-	.eccbytes = 0,
-	.eccpos = { 0, },
-	.oobfree = { {.offset = 0, .length = 0} }
+static int gpmi_ooblayout_ecc(struct mtd_info *mtd, int section,
+			      struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *chip = mtd_to_nand(mtd);
+	struct gpmi_nand_data *this = nand_get_controller_data(chip);
+	struct bch_geometry *geo = &this->bch_geometry;
+
+	if (section)
+		return -ERANGE;
+
+	oobregion->offset = 0;
+	oobregion->length = geo->page_size - mtd->writesize;
+
+	return 0;
+}
+
+static int gpmi_ooblayout_free(struct mtd_info *mtd, int section,
+			       struct mtd_oob_region *oobregion)
+{
+	struct nand_chip *chip = mtd_to_nand(mtd);
+	struct gpmi_nand_data *this = nand_get_controller_data(chip);
+	struct bch_geometry *geo = &this->bch_geometry;
+
+	if (section)
+		return -ERANGE;
+
+	/* The available oob size we have. */
+	if (geo->page_size < mtd->writesize + mtd->oobsize) {
+		oobregion->offset = geo->page_size - mtd->writesize;
+		oobregion->length = mtd->oobsize - oobregion->offset;
+	}
+
+	return 0;
+}
+
+static const struct mtd_ooblayout_ops gpmi_ooblayout_ops = {
+	.ecc = gpmi_ooblayout_ecc,
+	.free = gpmi_ooblayout_free,
 };
 
 static const struct gpmi_devdata gpmi_devdata_imx23 = {
@@ -141,7 +175,6 @@ static int set_geometry_by_ecc_info(struct gpmi_nand_data *this)
 	struct bch_geometry *geo = &this->bch_geometry;
 	struct nand_chip *chip = &this->nand;
 	struct mtd_info *mtd = nand_to_mtd(chip);
-	struct nand_oobfree *of = gpmi_hw_ecclayout.oobfree;
 	unsigned int block_mark_bit_offset;
 
 	if (!(chip->ecc_strength_ds > 0 && chip->ecc_step_ds > 0))
@@ -229,12 +262,6 @@ static int set_geometry_by_ecc_info(struct gpmi_nand_data *this)
 	geo->page_size = mtd->writesize + geo->metadata_size +
 		(geo->gf_len * geo->ecc_strength * geo->ecc_chunk_count) / 8;
 
-	/* The available oob size we have. */
-	if (geo->page_size < mtd->writesize + mtd->oobsize) {
-		of->offset = geo->page_size - mtd->writesize;
-		of->length = mtd->oobsize - of->offset;
-	}
-
 	geo->payload_size = mtd->writesize;
 
 	geo->auxiliary_status_offset = ALIGN(geo->metadata_size, 4);
@@ -1841,6 +1868,7 @@ static void gpmi_nand_exit(struct gpmi_nand_data *this)
 static int gpmi_init_last(struct gpmi_nand_data *this)
 {
 	struct nand_chip *chip = &this->nand;
+	struct mtd_info *mtd = nand_to_mtd(chip);
 	struct nand_ecc_ctrl *ecc = &chip->ecc;
 	struct bch_geometry *bch_geo = &this->bch_geometry;
 	int ret;
@@ -1862,7 +1890,7 @@ static int gpmi_init_last(struct gpmi_nand_data *this)
 	ecc->mode	= NAND_ECC_HW;
 	ecc->size	= bch_geo->ecc_chunk_size;
 	ecc->strength	= bch_geo->ecc_strength;
-	ecc->layout	= &gpmi_hw_ecclayout;
+	mtd_set_ooblayout(mtd, &gpmi_ooblayout_ops);
 
 	/*
 	 * We only enable the subpage read when:
-- 
2.1.4
