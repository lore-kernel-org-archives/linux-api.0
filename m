From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 02/52] mtd: create an mtd_oobavail() helper
 and make use of it
Date: Mon,  7 Mar 2016 10:46:52 +0100
Message-ID: <1457344062-11633-3-git-send-email-boris.brezillon@free-electrons.com>
References: <1457344062-11633-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBRU46W3AKGQERERIMGA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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

Currently, all MTD drivers/sublayers exposing an OOB area are
doing the same kind of test to extract the available OOB size
based on the mtd_info and mtd_oob_ops structures.
Move this common logic into an inline function and make use of it.

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Suggested-by: Priit Laes <plaes-q/aMd4JkU83YtjvyW6yDsg@public.gmane.org>
---
 drivers/mtd/mtdpart.c              |  5 +----
 drivers/mtd/nand/nand_base.c       | 16 ++++------------
 drivers/mtd/onenand/onenand_base.c | 19 +++----------------
 include/linux/mtd/mtd.h            |  5 +++++
 4 files changed, 13 insertions(+), 32 deletions(-)

diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 10bf304..08de4b2 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -126,10 +126,7 @@ static int part_read_oob(struct mtd_info *mtd, loff_t from,
 	if (ops->oobbuf) {
 		size_t len, pages;
 
-		if (ops->mode == MTD_OPS_AUTO_OOB)
-			len = mtd->oobavail;
-		else
-			len = mtd->oobsize;
+		len = mtd_oobavail(mtd, ops);
 		pages = mtd_div_by_ws(mtd->size, mtd);
 		pages -= mtd_div_by_ws(from, mtd);
 		if (ops->ooboffs + ops->ooblen > pages * len)
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 9f49d3e..ee89195 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -1723,8 +1723,7 @@ static int nand_do_read_ops(struct mtd_info *mtd, loff_t from,
 	int ret = 0;
 	uint32_t readlen = ops->len;
 	uint32_t oobreadlen = ops->ooblen;
-	uint32_t max_oobsize = ops->mode == MTD_OPS_AUTO_OOB ?
-		mtd->oobavail : mtd->oobsize;
+	uint32_t max_oobsize = mtd_oobavail(mtd, ops);
 
 	uint8_t *bufpoi, *oob, *buf;
 	int use_bufpoi;
@@ -2075,10 +2074,7 @@ static int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
 
 	stats = mtd->ecc_stats;
 
-	if (ops->mode == MTD_OPS_AUTO_OOB)
-		len = mtd->oobavail;
-	else
-		len = mtd->oobsize;
+	len = mtd_oobavail(mtd, ops);
 
 	if (unlikely(ops->ooboffs >= len)) {
 		pr_debug("%s: attempt to start read outside oob\n",
@@ -2575,8 +2571,7 @@ static int nand_do_write_ops(struct mtd_info *mtd, loff_t to,
 	uint32_t writelen = ops->len;
 
 	uint32_t oobwritelen = ops->ooblen;
-	uint32_t oobmaxlen = ops->mode == MTD_OPS_AUTO_OOB ?
-				mtd->oobavail : mtd->oobsize;
+	uint32_t oobmaxlen = mtd_oobavail(mtd, ops);
 
 	uint8_t *oob = ops->oobbuf;
 	uint8_t *buf = ops->datbuf;
@@ -2766,10 +2761,7 @@ static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
 	pr_debug("%s: to = 0x%08x, len = %i\n",
 			 __func__, (unsigned int)to, (int)ops->ooblen);
 
-	if (ops->mode == MTD_OPS_AUTO_OOB)
-		len = mtd->oobavail;
-	else
-		len = mtd->oobsize;
+	len = mtd_oobavail(mtd, ops);
 
 	/* Do not allow write past end of page */
 	if ((ops->ooboffs + ops->ooblen) > len) {
diff --git a/drivers/mtd/onenand/onenand_base.c b/drivers/mtd/onenand/onenand_base.c
index df47537..af28bb3 100644
--- a/drivers/mtd/onenand/onenand_base.c
+++ b/drivers/mtd/onenand/onenand_base.c
@@ -1124,11 +1124,7 @@ static int onenand_mlc_read_ops_nolock(struct mtd_info *mtd, loff_t from,
 	pr_debug("%s: from = 0x%08x, len = %i\n", __func__, (unsigned int)from,
 			(int)len);
 
-	if (ops->mode == MTD_OPS_AUTO_OOB)
-		oobsize = mtd->oobavail;
-	else
-		oobsize = mtd->oobsize;
-
+	oobsize = mtd_oobavail(mtd, ops);
 	oobcolumn = from & (mtd->oobsize - 1);
 
 	/* Do not allow reads past end of device */
@@ -1229,11 +1225,7 @@ static int onenand_read_ops_nolock(struct mtd_info *mtd, loff_t from,
 	pr_debug("%s: from = 0x%08x, len = %i\n", __func__, (unsigned int)from,
 			(int)len);
 
-	if (ops->mode == MTD_OPS_AUTO_OOB)
-		oobsize = mtd->oobavail;
-	else
-		oobsize = mtd->oobsize;
-
+	oobsize = mtd_oobavail(mtd, ops);
 	oobcolumn = from & (mtd->oobsize - 1);
 
 	/* Do not allow reads past end of device */
@@ -1885,12 +1877,7 @@ static int onenand_write_ops_nolock(struct mtd_info *mtd, loff_t to,
 	/* Check zero length */
 	if (!len)
 		return 0;
-
-	if (ops->mode == MTD_OPS_AUTO_OOB)
-		oobsize = mtd->oobavail;
-	else
-		oobsize = mtd->oobsize;
-
+	oobsize = mtd_oobavail(mtd, ops);
 	oobcolumn = to & (mtd->oobsize - 1);
 
 	column = to & (mtd->writesize - 1);
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 9cf13c4..7712721 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -264,6 +264,11 @@ static inline struct device_node *mtd_get_of_node(struct mtd_info *mtd)
 	return mtd->dev.of_node;
 }
 
+static inline int mtd_oobavail(struct mtd_info *mtd, struct mtd_oob_ops *ops)
+{
+	return ops->mode == MTD_OPS_AUTO_OOB ? mtd->oobavail : mtd->oobsize;
+}
+
 int mtd_erase(struct mtd_info *mtd, struct erase_info *instr);
 int mtd_point(struct mtd_info *mtd, loff_t from, size_t len, size_t *retlen,
 	      void **virt, resource_size_t *phys);
-- 
2.1.4
