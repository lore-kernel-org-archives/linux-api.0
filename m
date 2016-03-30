From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v5 04/50] mtd: nand: atmel: use
 mtd_ooblayout_xxx() helpers where appropriate
Date: Wed, 30 Mar 2016 18:14:19 +0200
Message-ID: <1459354505-32551-5-git-send-email-boris.brezillon@free-electrons.com>
References: <1459354505-32551-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBGPX563QKGQEGVC3H5Y-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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

The mtd_ooblayout_xxx() helper functions have been added to avoid direct
accesses to the ecclayout field, and thus ease for future reworks.
Use these helpers in all places where the oobfree[] and eccpos[] arrays
where directly accessed.

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
---
 drivers/mtd/nand/atmel_nand.c | 48 ++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 0b5da72..321d331 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -836,13 +836,16 @@ static void pmecc_correct_data(struct mtd_info *mtd, uint8_t *buf, uint8_t *ecc,
 			dev_dbg(host->dev, "Bit flip in data area, byte_pos: %d, bit_pos: %d, 0x%02x -> 0x%02x\n",
 				pos, bit_pos, err_byte, *(buf + byte_pos));
 		} else {
+			struct mtd_oob_region oobregion;
+
 			/* Bit flip in OOB area */
 			tmp = sector_num * nand_chip->ecc.bytes
 					+ (byte_pos - sector_size);
 			err_byte = ecc[tmp];
 			ecc[tmp] ^= (1 << bit_pos);
 
-			pos = tmp + nand_chip->ecc.layout->eccpos[0];
+			mtd_ooblayout_ecc(mtd, 0, &oobregion);
+			pos = tmp + oobregion.offset;
 			dev_dbg(host->dev, "Bit flip in OOB, oob_byte_pos: %d, bit_pos: %d, 0x%02x -> 0x%02x\n",
 				pos, bit_pos, err_byte, ecc[tmp]);
 		}
@@ -934,7 +937,6 @@ static int atmel_nand_pmecc_read_page(struct mtd_info *mtd,
 	struct atmel_nand_host *host = nand_get_controller_data(chip);
 	int eccsize = chip->ecc.size * chip->ecc.steps;
 	uint8_t *oob = chip->oob_poi;
-	uint32_t *eccpos = chip->ecc.layout->eccpos;
 	uint32_t stat;
 	unsigned long end_time;
 	int bitflips = 0;
@@ -956,7 +958,11 @@ static int atmel_nand_pmecc_read_page(struct mtd_info *mtd,
 
 	stat = pmecc_readl_relaxed(host->ecc, ISR);
 	if (stat != 0) {
-		bitflips = pmecc_correction(mtd, stat, buf, &oob[eccpos[0]]);
+		struct mtd_oob_region oobregion;
+
+		mtd_ooblayout_ecc(mtd, 0, &oobregion);
+		bitflips = pmecc_correction(mtd, stat, buf,
+					    &oob[oobregion.offset]);
 		if (bitflips < 0)
 			/* uncorrectable errors */
 			return 0;
@@ -970,8 +976,8 @@ static int atmel_nand_pmecc_write_page(struct mtd_info *mtd,
 		int page)
 {
 	struct atmel_nand_host *host = nand_get_controller_data(chip);
-	uint32_t *eccpos = chip->ecc.layout->eccpos;
-	int i, j;
+	struct mtd_oob_region oobregion = { };
+	int i, j, section = 0;
 	unsigned long end_time;
 
 	if (!host->nfc || !host->nfc->write_by_sram) {
@@ -990,11 +996,12 @@ static int atmel_nand_pmecc_write_page(struct mtd_info *mtd,
 
 	for (i = 0; i < chip->ecc.steps; i++) {
 		for (j = 0; j < chip->ecc.bytes; j++) {
-			int pos;
+			if (!oobregion.length)
+				mtd_ooblayout_ecc(mtd, section++, &oobregion);
 
-			pos = i * chip->ecc.bytes + j;
-			chip->oob_poi[eccpos[pos]] =
+			chip->oob_poi[oobregion.offset++] =
 				pmecc_readb_ecc_relaxed(host->ecc, i, j);
+			oobregion.length--;
 		}
 	}
 	chip->write_buf(mtd, chip->oob_poi, mtd->oobsize);
@@ -1008,6 +1015,7 @@ static void atmel_pmecc_core_init(struct mtd_info *mtd)
 	struct atmel_nand_host *host = nand_get_controller_data(nand_chip);
 	uint32_t val = 0;
 	struct nand_ecclayout *ecc_layout;
+	struct mtd_oob_region oobregion;
 
 	pmecc_writel(host->ecc, CTRL, PMECC_CTRL_RST);
 	pmecc_writel(host->ecc, CTRL, PMECC_CTRL_DISABLE);
@@ -1059,9 +1067,10 @@ static void atmel_pmecc_core_init(struct mtd_info *mtd)
 
 	ecc_layout = nand_chip->ecc.layout;
 	pmecc_writel(host->ecc, SAREA, mtd->oobsize - 1);
-	pmecc_writel(host->ecc, SADDR, ecc_layout->eccpos[0]);
+	mtd_ooblayout_ecc(mtd, 0, &oobregion);
+	pmecc_writel(host->ecc, SADDR, oobregion.offset);
 	pmecc_writel(host->ecc, EADDR,
-			ecc_layout->eccpos[ecc_layout->eccbytes - 1]);
+		     oobregion.offset + ecc_layout->eccbytes - 1);
 	/* See datasheet about PMECC Clock Control Register */
 	pmecc_writel(host->ecc, CLK, 2);
 	pmecc_writel(host->ecc, IDR, 0xff);
@@ -1362,12 +1371,12 @@ static int atmel_nand_read_page(struct mtd_info *mtd, struct nand_chip *chip,
 {
 	int eccsize = chip->ecc.size;
 	int eccbytes = chip->ecc.bytes;
-	uint32_t *eccpos = chip->ecc.layout->eccpos;
 	uint8_t *p = buf;
 	uint8_t *oob = chip->oob_poi;
 	uint8_t *ecc_pos;
 	int stat;
 	unsigned int max_bitflips = 0;
+	struct mtd_oob_region oobregion = {};
 
 	/*
 	 * Errata: ALE is incorrectly wired up to the ECC controller
@@ -1385,19 +1394,20 @@ static int atmel_nand_read_page(struct mtd_info *mtd, struct nand_chip *chip,
 	chip->read_buf(mtd, p, eccsize);
 
 	/* move to ECC position if needed */
-	if (eccpos[0] != 0) {
-		/* This only works on large pages
-		 * because the ECC controller waits for
-		 * NAND_CMD_RNDOUTSTART after the
-		 * NAND_CMD_RNDOUT.
-		 * anyway, for small pages, the eccpos[0] == 0
+	mtd_ooblayout_ecc(mtd, 0, &oobregion);
+	if (oobregion.offset != 0) {
+		/*
+		 * This only works on large pages because the ECC controller
+		 * waits for NAND_CMD_RNDOUTSTART after the NAND_CMD_RNDOUT.
+		 * Anyway, for small pages, the first ECC byte is at offset
+		 * 0 in the OOB area.
 		 */
 		chip->cmdfunc(mtd, NAND_CMD_RNDOUT,
-				mtd->writesize + eccpos[0], -1);
+			      mtd->writesize + oobregion.offset, -1);
 	}
 
 	/* the ECC controller needs to read the ECC just after the data */
-	ecc_pos = oob + eccpos[0];
+	ecc_pos = oob + oobregion.offset;
 	chip->read_buf(mtd, ecc_pos, eccbytes);
 
 	/* check if there's an error */
-- 
2.5.0
