From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 11/52] mtd: nand: lpc32xx: use
 mtd_ooblayout_xxx() helpers where appropriate
Date: Fri, 26 Feb 2016 01:57:19 +0100
Message-ID: <1456448280-27788-12-git-send-email-boris.brezillon@free-electrons.com>
References: <1456448280-27788-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBA6HX23AKGQEQSHEY4Q-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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

The mtd_ooblayout_xxx() helper functions have been added to avoid direct
accesses to the ecclayout field, and thus ease for future reworks.
Use these helpers in all places where the oobfree[] and eccpos[] arrays
where directly accessed.

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
---
 drivers/mtd/nand/lpc32xx_slc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/lpc32xx_slc.c b/drivers/mtd/nand/lpc32xx_slc.c
index 3b8f373..10cf8e62 100644
--- a/drivers/mtd/nand/lpc32xx_slc.c
+++ b/drivers/mtd/nand/lpc32xx_slc.c
@@ -604,7 +604,8 @@ static int lpc32xx_nand_read_page_syndrome(struct mtd_info *mtd,
 					   int oob_required, int page)
 {
 	struct lpc32xx_nand_host *host = nand_get_controller_data(chip);
-	int stat, i, status;
+	struct mtd_oob_region oobregion = { };
+	int stat, i, status, error;
 	uint8_t *oobecc, tmpecc[LPC32XX_ECC_SAVE_SIZE];
 
 	/* Issue read command */
@@ -620,7 +621,11 @@ static int lpc32xx_nand_read_page_syndrome(struct mtd_info *mtd,
 	lpc32xx_slc_ecc_copy(tmpecc, (uint32_t *) host->ecc_buf, chip->ecc.steps);
 
 	/* Pointer to ECC data retrieved from NAND spare area */
-	oobecc = chip->oob_poi + chip->ecc.layout->eccpos[0];
+	error = mtd_ooblayout_ecc(mtd, 0, &oobregion);
+	if (error)
+		return error;
+
+	oobecc = chip->oob_poi + oobregion.offset;
 
 	for (i = 0; i < chip->ecc.steps; i++) {
 		stat = chip->ecc.correct(mtd, buf, oobecc,
@@ -666,7 +671,8 @@ static int lpc32xx_nand_write_page_syndrome(struct mtd_info *mtd,
 					    int oob_required, int page)
 {
 	struct lpc32xx_nand_host *host = nand_get_controller_data(chip);
-	uint8_t *pb = chip->oob_poi + chip->ecc.layout->eccpos[0];
+	struct mtd_oob_region oobregion = { };
+	uint8_t *pb;
 	int error;
 
 	/* Write data, calculate ECC on outbound data */
@@ -678,6 +684,11 @@ static int lpc32xx_nand_write_page_syndrome(struct mtd_info *mtd,
 	 * The calculated ECC needs some manual work done to it before
 	 * committing it to NAND. Process the calculated ECC and place
 	 * the resultant values directly into the OOB buffer. */
+	error = mtd_ooblayout_ecc(mtd, 0, &oobregion);
+	if (error)
+		return error;
+
+	pb = chip->oob_poi + oobregion.offset;
 	lpc32xx_slc_ecc_copy(pb, (uint32_t *)host->ecc_buf, chip->ecc.steps);
 
 	/* Write ECC data to device */
-- 
2.1.4
