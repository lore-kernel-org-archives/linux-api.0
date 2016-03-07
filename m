From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v4 07/52] mtd: nand: core: use
 mtd_ooblayout_xxx() helpers where appropriate
Date: Mon,  7 Mar 2016 10:46:57 +0100
Message-ID: <1457344062-11633-8-git-send-email-boris.brezillon@free-electrons.com>
References: <1457344062-11633-1-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBVE46W3AKGQE3YWWYHI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
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

The mtd_ooblayout_xxx() helper functions have been added to avoid direct
accesses to the ecclayout field, and thus ease for future reworks.
Use these helpers in all places where the oobfree[] and eccpos[] arrays
where directly accessed.

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
---
 drivers/mtd/nand/nand_base.c | 201 +++++++++++++++++++------------------------
 drivers/mtd/nand/nand_bch.c  |   3 +-
 2 files changed, 91 insertions(+), 113 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 91672bf..39696f7 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -1309,13 +1309,12 @@ static int nand_read_page_raw_syndrome(struct mtd_info *mtd,
 static int nand_read_page_swecc(struct mtd_info *mtd, struct nand_chip *chip,
 				uint8_t *buf, int oob_required, int page)
 {
-	int i, eccsize = chip->ecc.size;
+	int i, eccsize = chip->ecc.size, ret;
 	int eccbytes = chip->ecc.bytes;
 	int eccsteps = chip->ecc.steps;
 	uint8_t *p = buf;
 	uint8_t *ecc_calc = chip->buffers->ecccalc;
 	uint8_t *ecc_code = chip->buffers->ecccode;
-	uint32_t *eccpos = chip->ecc.layout->eccpos;
 	unsigned int max_bitflips = 0;
 
 	chip->ecc.read_page_raw(mtd, chip, buf, 1, page);
@@ -1323,8 +1322,10 @@ static int nand_read_page_swecc(struct mtd_info *mtd, struct nand_chip *chip,
 	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize)
 		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
 
-	for (i = 0; i < chip->ecc.total; i++)
-		ecc_code[i] = chip->oob_poi[eccpos[i]];
+	ret = mtd_ooblayout_get_eccbytes(mtd, ecc_code, chip->oob_poi, 0,
+					 chip->ecc.total);
+	if (ret)
+		return ret;
 
 	eccsteps = chip->ecc.steps;
 	p = buf;
@@ -1356,14 +1357,14 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip,
 			uint32_t data_offs, uint32_t readlen, uint8_t *bufpoi,
 			int page)
 {
-	int start_step, end_step, num_steps;
-	uint32_t *eccpos = chip->ecc.layout->eccpos;
+	int start_step, end_step, num_steps, ret;
 	uint8_t *p;
 	int data_col_addr, i, gaps = 0;
 	int datafrag_len, eccfrag_len, aligned_len, aligned_pos;
 	int busw = (chip->options & NAND_BUSWIDTH_16) ? 2 : 1;
-	int index;
+	int index, section = 0;
 	unsigned int max_bitflips = 0;
+	struct mtd_oob_region oobregion = { };
 
 	/* Column address within the page aligned to ECC size (256bytes) */
 	start_step = data_offs / chip->ecc.size;
@@ -1391,12 +1392,13 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip,
 	 * The performance is faster if we position offsets according to
 	 * ecc.pos. Let's make sure that there are no gaps in ECC positions.
 	 */
-	for (i = 0; i < eccfrag_len - 1; i++) {
-		if (eccpos[i + index] + 1 != eccpos[i + index + 1]) {
-			gaps = 1;
-			break;
-		}
-	}
+	ret = mtd_ooblayout_find_eccregion(mtd, index, &section, &oobregion);
+	if (ret)
+		return ret;
+
+	if (oobregion.length < eccfrag_len)
+		gaps = 1;
+
 	if (gaps) {
 		chip->cmdfunc(mtd, NAND_CMD_RNDOUT, mtd->writesize, -1);
 		chip->read_buf(mtd, chip->oob_poi, mtd->oobsize);
@@ -1405,20 +1407,23 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip,
 		 * Send the command to read the particular ECC bytes take care
 		 * about buswidth alignment in read_buf.
 		 */
-		aligned_pos = eccpos[index] & ~(busw - 1);
+		aligned_pos = oobregion.offset & ~(busw - 1);
 		aligned_len = eccfrag_len;
-		if (eccpos[index] & (busw - 1))
+		if (oobregion.offset & (busw - 1))
 			aligned_len++;
-		if (eccpos[index + (num_steps * chip->ecc.bytes)] & (busw - 1))
+		if ((oobregion.offset + (num_steps * chip->ecc.bytes)) &
+		    (busw - 1))
 			aligned_len++;
 
 		chip->cmdfunc(mtd, NAND_CMD_RNDOUT,
-					mtd->writesize + aligned_pos, -1);
+			      mtd->writesize + aligned_pos, -1);
 		chip->read_buf(mtd, &chip->oob_poi[aligned_pos], aligned_len);
 	}
 
-	for (i = 0; i < eccfrag_len; i++)
-		chip->buffers->ecccode[i] = chip->oob_poi[eccpos[i + index]];
+	ret = mtd_ooblayout_get_eccbytes(mtd, chip->buffers->ecccode,
+					 chip->oob_poi, index, eccfrag_len);
+	if (ret)
+		return ret;
 
 	p = bufpoi + data_col_addr;
 	for (i = 0; i < eccfrag_len ; i += chip->ecc.bytes, p += chip->ecc.size) {
@@ -1459,13 +1464,12 @@ static int nand_read_subpage(struct mtd_info *mtd, struct nand_chip *chip,
 static int nand_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
 				uint8_t *buf, int oob_required, int page)
 {
-	int i, eccsize = chip->ecc.size;
+	int i, eccsize = chip->ecc.size, ret;
 	int eccbytes = chip->ecc.bytes;
 	int eccsteps = chip->ecc.steps;
 	uint8_t *p = buf;
 	uint8_t *ecc_calc = chip->buffers->ecccalc;
 	uint8_t *ecc_code = chip->buffers->ecccode;
-	uint32_t *eccpos = chip->ecc.layout->eccpos;
 	unsigned int max_bitflips = 0;
 
 	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
@@ -1475,8 +1479,10 @@ static int nand_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
 	}
 	chip->read_buf(mtd, chip->oob_poi, mtd->oobsize);
 
-	for (i = 0; i < chip->ecc.total; i++)
-		ecc_code[i] = chip->oob_poi[eccpos[i]];
+	ret = mtd_ooblayout_get_eccbytes(mtd, ecc_code, chip->oob_poi, 0,
+					 chip->ecc.total);
+	if (ret)
+		return ret;
 
 	eccsteps = chip->ecc.steps;
 	p = buf;
@@ -1521,12 +1527,11 @@ static int nand_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
 static int nand_read_page_hwecc_oob_first(struct mtd_info *mtd,
 	struct nand_chip *chip, uint8_t *buf, int oob_required, int page)
 {
-	int i, eccsize = chip->ecc.size;
+	int i, eccsize = chip->ecc.size, ret;
 	int eccbytes = chip->ecc.bytes;
 	int eccsteps = chip->ecc.steps;
 	uint8_t *p = buf;
 	uint8_t *ecc_code = chip->buffers->ecccode;
-	uint32_t *eccpos = chip->ecc.layout->eccpos;
 	uint8_t *ecc_calc = chip->buffers->ecccalc;
 	unsigned int max_bitflips = 0;
 
@@ -1535,8 +1540,10 @@ static int nand_read_page_hwecc_oob_first(struct mtd_info *mtd,
 	chip->read_buf(mtd, chip->oob_poi, mtd->oobsize);
 	chip->cmdfunc(mtd, NAND_CMD_READ0, 0, page);
 
-	for (i = 0; i < chip->ecc.total; i++)
-		ecc_code[i] = chip->oob_poi[eccpos[i]];
+	ret = mtd_ooblayout_get_eccbytes(mtd, ecc_code, chip->oob_poi, 0,
+					 chip->ecc.total);
+	if (ret)
+		return ret;
 
 	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
 		int stat;
@@ -1637,14 +1644,17 @@ static int nand_read_page_syndrome(struct mtd_info *mtd, struct nand_chip *chip,
 
 /**
  * nand_transfer_oob - [INTERN] Transfer oob to client buffer
- * @chip: nand chip structure
+ * @mtd: mtd info structure
  * @oob: oob destination address
  * @ops: oob ops structure
  * @len: size of oob to transfer
  */
-static uint8_t *nand_transfer_oob(struct nand_chip *chip, uint8_t *oob,
+static uint8_t *nand_transfer_oob(struct mtd_info *mtd, uint8_t *oob,
 				  struct mtd_oob_ops *ops, size_t len)
 {
+	struct nand_chip *chip = mtd_to_nand(mtd);
+	int ret;
+
 	switch (ops->mode) {
 
 	case MTD_OPS_PLACE_OOB:
@@ -1652,31 +1662,12 @@ static uint8_t *nand_transfer_oob(struct nand_chip *chip, uint8_t *oob,
 		memcpy(oob, chip->oob_poi + ops->ooboffs, len);
 		return oob + len;
 
-	case MTD_OPS_AUTO_OOB: {
-		struct nand_oobfree *free = chip->ecc.layout->oobfree;
-		uint32_t boffs = 0, roffs = ops->ooboffs;
-		size_t bytes = 0;
-
-		for (; free->length && len; free++, len -= bytes) {
-			/* Read request not from offset 0? */
-			if (unlikely(roffs)) {
-				if (roffs >= free->length) {
-					roffs -= free->length;
-					continue;
-				}
-				boffs = free->offset + roffs;
-				bytes = min_t(size_t, len,
-					      (free->length - roffs));
-				roffs = 0;
-			} else {
-				bytes = min_t(size_t, len, free->length);
-				boffs = free->offset;
-			}
-			memcpy(oob, chip->oob_poi + boffs, bytes);
-			oob += bytes;
-		}
-		return oob;
-	}
+	case MTD_OPS_AUTO_OOB:
+		ret = mtd_ooblayout_get_databytes(mtd, oob, chip->oob_poi,
+						  ops->ooboffs, len);
+		BUG_ON(ret);
+		return oob + len;
+
 	default:
 		BUG();
 	}
@@ -1810,7 +1801,7 @@ read_retry:
 				int toread = min(oobreadlen, max_oobsize);
 
 				if (toread) {
-					oob = nand_transfer_oob(chip,
+					oob = nand_transfer_oob(mtd,
 						oob, ops, toread);
 					oobreadlen -= toread;
 				}
@@ -2108,7 +2099,7 @@ static int nand_do_read_oob(struct mtd_info *mtd, loff_t from,
 			break;
 
 		len = min(len, readlen);
-		buf = nand_transfer_oob(chip, buf, ops, len);
+		buf = nand_transfer_oob(mtd, buf, ops, len);
 
 		if (chip->options & NAND_NEED_READRDY) {
 			/* Apply delay or wait for ready/busy pin */
@@ -2267,19 +2258,20 @@ static int nand_write_page_swecc(struct mtd_info *mtd, struct nand_chip *chip,
 				 const uint8_t *buf, int oob_required,
 				 int page)
 {
-	int i, eccsize = chip->ecc.size;
+	int i, eccsize = chip->ecc.size, ret;
 	int eccbytes = chip->ecc.bytes;
 	int eccsteps = chip->ecc.steps;
 	uint8_t *ecc_calc = chip->buffers->ecccalc;
 	const uint8_t *p = buf;
-	uint32_t *eccpos = chip->ecc.layout->eccpos;
 
 	/* Software ECC calculation */
 	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize)
 		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
 
-	for (i = 0; i < chip->ecc.total; i++)
-		chip->oob_poi[eccpos[i]] = ecc_calc[i];
+	ret = mtd_ooblayout_set_eccbytes(mtd, ecc_calc, chip->oob_poi, 0,
+					 chip->ecc.total);
+	if (ret)
+		return ret;
 
 	return chip->ecc.write_page_raw(mtd, chip, buf, 1, page);
 }
@@ -2296,12 +2288,11 @@ static int nand_write_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
 				  const uint8_t *buf, int oob_required,
 				  int page)
 {
-	int i, eccsize = chip->ecc.size;
+	int i, eccsize = chip->ecc.size, ret;
 	int eccbytes = chip->ecc.bytes;
 	int eccsteps = chip->ecc.steps;
 	uint8_t *ecc_calc = chip->buffers->ecccalc;
 	const uint8_t *p = buf;
-	uint32_t *eccpos = chip->ecc.layout->eccpos;
 
 	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
 		chip->ecc.hwctl(mtd, NAND_ECC_WRITE);
@@ -2309,8 +2300,10 @@ static int nand_write_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
 		chip->ecc.calculate(mtd, p, &ecc_calc[i]);
 	}
 
-	for (i = 0; i < chip->ecc.total; i++)
-		chip->oob_poi[eccpos[i]] = ecc_calc[i];
+	ret = mtd_ooblayout_set_eccbytes(mtd, ecc_calc, chip->oob_poi, 0,
+					 chip->ecc.total);
+	if (ret)
+		return ret;
 
 	chip->write_buf(mtd, chip->oob_poi, mtd->oobsize);
 
@@ -2338,11 +2331,10 @@ static int nand_write_subpage_hwecc(struct mtd_info *mtd,
 	int ecc_size      = chip->ecc.size;
 	int ecc_bytes     = chip->ecc.bytes;
 	int ecc_steps     = chip->ecc.steps;
-	uint32_t *eccpos  = chip->ecc.layout->eccpos;
 	uint32_t start_step = offset / ecc_size;
 	uint32_t end_step   = (offset + data_len - 1) / ecc_size;
 	int oob_bytes       = mtd->oobsize / ecc_steps;
-	int step, i;
+	int step, ret;
 
 	for (step = 0; step < ecc_steps; step++) {
 		/* configure controller for WRITE access */
@@ -2370,8 +2362,10 @@ static int nand_write_subpage_hwecc(struct mtd_info *mtd,
 	/* copy calculated ECC for whole page to chip->buffer->oob */
 	/* this include masked-value(0xFF) for unwritten subpages */
 	ecc_calc = chip->buffers->ecccalc;
-	for (i = 0; i < chip->ecc.total; i++)
-		chip->oob_poi[eccpos[i]] = ecc_calc[i];
+	ret = mtd_ooblayout_set_eccbytes(mtd, ecc_calc, chip->oob_poi, 0,
+					 chip->ecc.total);
+	if (ret)
+		return ret;
 
 	/* write OOB buffer to NAND device */
 	chip->write_buf(mtd, chip->oob_poi, mtd->oobsize);
@@ -2508,6 +2502,7 @@ static uint8_t *nand_fill_oob(struct mtd_info *mtd, uint8_t *oob, size_t len,
 			      struct mtd_oob_ops *ops)
 {
 	struct nand_chip *chip = mtd_to_nand(mtd);
+	int ret;
 
 	/*
 	 * Initialise to all 0xFF, to avoid the possibility of left over OOB
@@ -2522,31 +2517,12 @@ static uint8_t *nand_fill_oob(struct mtd_info *mtd, uint8_t *oob, size_t len,
 		memcpy(chip->oob_poi + ops->ooboffs, oob, len);
 		return oob + len;
 
-	case MTD_OPS_AUTO_OOB: {
-		struct nand_oobfree *free = chip->ecc.layout->oobfree;
-		uint32_t boffs = 0, woffs = ops->ooboffs;
-		size_t bytes = 0;
-
-		for (; free->length && len; free++, len -= bytes) {
-			/* Write request not from offset 0? */
-			if (unlikely(woffs)) {
-				if (woffs >= free->length) {
-					woffs -= free->length;
-					continue;
-				}
-				boffs = free->offset + woffs;
-				bytes = min_t(size_t, len,
-					      (free->length - woffs));
-				woffs = 0;
-			} else {
-				bytes = min_t(size_t, len, free->length);
-				boffs = free->offset;
-			}
-			memcpy(chip->oob_poi + boffs, oob, bytes);
-			oob += bytes;
-		}
-		return oob;
-	}
+	case MTD_OPS_AUTO_OOB:
+		ret = mtd_ooblayout_set_databytes(mtd, oob, chip->oob_poi,
+						  ops->ooboffs, len);
+		BUG_ON(ret);
+		return oob + len;
+
 	default:
 		BUG();
 	}
@@ -4116,10 +4092,10 @@ static bool nand_ecc_strength_good(struct mtd_info *mtd)
  */
 int nand_scan_tail(struct mtd_info *mtd)
 {
-	int i;
 	struct nand_chip *chip = mtd_to_nand(mtd);
 	struct nand_ecc_ctrl *ecc = &chip->ecc;
 	struct nand_buffers *nbuf;
+	int ret;
 
 	/* New bad blocks should be marked in OOB, flash-based BBT, or both */
 	BUG_ON((chip->bbt_options & NAND_BBT_NO_OOB_BBM) &&
@@ -4311,20 +4287,10 @@ int nand_scan_tail(struct mtd_info *mtd)
 	if (!ecc->write_oob_raw)
 		ecc->write_oob_raw = ecc->write_oob;
 
-	/*
-	 * The number of bytes available for a client to place data into
-	 * the out of band area.
-	 */
-	mtd->oobavail = 0;
-	if (ecc->layout) {
-		for (i = 0; ecc->layout->oobfree[i].length; i++)
-			mtd->oobavail += ecc->layout->oobfree[i].length;
-	}
-
-	/* ECC sanity check: warn if it's too weak */
-	if (!nand_ecc_strength_good(mtd))
-		pr_warn("WARNING: %s: the ECC used on your system is too weak compared to the one required by the NAND chip\n",
-			mtd->name);
+	/* propagate ecc info to mtd_info */
+	mtd->ecclayout = ecc->layout;
+	mtd->ecc_strength = ecc->strength;
+	mtd->ecc_step_size = ecc->size;
 
 	/*
 	 * Set the number of read / write steps for one page depending on ECC
@@ -4337,6 +4303,21 @@ int nand_scan_tail(struct mtd_info *mtd)
 	}
 	ecc->total = ecc->steps * ecc->bytes;
 
+	/*
+	 * The number of bytes available for a client to place data into
+	 * the out of band area.
+	 */
+	ret = mtd_ooblayout_count_freebytes(mtd);
+	if (ret < 0)
+		ret = 0;
+
+	mtd->oobavail = ret;
+
+	/* ECC sanity check: warn if it's too weak */
+	if (!nand_ecc_strength_good(mtd))
+		pr_warn("WARNING: %s: the ECC used on your system is too weak compared to the one required by the NAND chip\n",
+			mtd->name);
+
 	/* Allow subpage writes up to ecc.steps. Not possible for MLC flash */
 	if (!(chip->options & NAND_NO_SUBPAGE_WRITE) && nand_is_slc(chip)) {
 		switch (ecc->steps) {
@@ -4393,10 +4374,6 @@ int nand_scan_tail(struct mtd_info *mtd)
 	mtd->_block_markbad = nand_block_markbad;
 	mtd->writebufsize = mtd->writesize;
 
-	/* propagate ecc info to mtd_info */
-	mtd->ecclayout = ecc->layout;
-	mtd->ecc_strength = ecc->strength;
-	mtd->ecc_step_size = ecc->size;
 	/*
 	 * Initialize bitflip_threshold to its default prior scan_bbt() call.
 	 * scan_bbt() might invoke mtd_read(), thus bitflip_threshold must be
diff --git a/drivers/mtd/nand/nand_bch.c b/drivers/mtd/nand/nand_bch.c
index b585bae..b3039de 100644
--- a/drivers/mtd/nand/nand_bch.c
+++ b/drivers/mtd/nand/nand_bch.c
@@ -196,7 +196,8 @@ struct nand_bch_control *nand_bch_init(struct mtd_info *mtd)
 		printk(KERN_WARNING "eccsize %u is too large\n", eccsize);
 		goto fail;
 	}
-	if (layout->eccbytes != (eccsteps*eccbytes)) {
+
+	if (mtd_ooblayout_count_eccbytes(mtd) != (eccsteps*eccbytes)) {
 		printk(KERN_WARNING "invalid ecc layout\n");
 		goto fail;
 	}
-- 
2.1.4
