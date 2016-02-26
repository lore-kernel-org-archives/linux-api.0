From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v3 52/52] mtd: kill the nand_ecclayout struct
Date: Fri, 26 Feb 2016 01:58:00 +0100
Message-ID: <1456448280-27788-53-git-send-email-boris.brezillon@free-electrons.com>
References: <1456448280-27788-1-git-send-email-boris.brezillon@free-electrons.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456448280-27788-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Haojian Zhuang <haojian.zhuang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Robert Jarzmik <robert.jarzmik-GANU6spQydw@public.gmane.org>, Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, Nicolas Ferre <nicolas.ferre-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Wenyou Yang <wenyou.yang-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Josh Wu <rainyfeeling-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>, Ezequiel Garcia <ezequiel.garcia-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

Now that all MTD drivers have moved to the mtd_ooblayout_ops model we can
safely remove the struct nand_ecclayout definition, and all the remaining
places where it was still used.

Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
---
 drivers/mtd/mtdchar.c      |  12 ++---
 drivers/mtd/mtdcore.c      | 117 ---------------------------------------------
 include/linux/mtd/mtd.h    |  20 --------
 include/uapi/mtd/mtd-abi.h |   2 +-
 4 files changed, 7 insertions(+), 144 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 3fad2c7..2a47a3f 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -465,12 +465,12 @@ static int mtdchar_readoob(struct file *file, struct mtd_info *mtd,
 }
 
 /*
- * Copies (and truncates, if necessary) data from the larger struct,
- * nand_ecclayout, to the smaller, deprecated layout struct,
- * nand_ecclayout_user. This is necessary only to support the deprecated
- * API ioctl ECCGETLAYOUT while allowing all new functionality to use
- * nand_ecclayout flexibly (i.e. the struct may change size in new
- * releases without requiring major rewrites).
+ * Copies (and truncates, if necessary) OOB layout information to the
+ * deprecated layout struct, nand_ecclayout_user. This is necessary only to
+ * support the deprecated API ioctl ECCGETLAYOUT while allowing all new
+ * functionality to use mtd_ooblayout_ops flexibly (i.e. mtd_ooblayout_ops
+ * can describe any kind of OOB layout with almost zero overhead from a
+ * memory usage point of view).
  */
 static int shrink_ecclayout(struct mtd_info *mtd,
 			    struct nand_ecclayout_user *to)
diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 3b1dc09..c921bdbe 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -1355,123 +1355,6 @@ int mtd_ooblayout_count_eccbytes(struct mtd_info *mtd)
 }
 EXPORT_SYMBOL_GPL(mtd_ooblayout_count_eccbytes);
 
-/**
- * mtd_ecclayout_ecc - Default ooblayout_ecc iterator implementation
- * @mtd: MTD device structure
- * @section: ECC section. Depending on the layout you may have all the ECC
- *	     bytes stored in a single contiguous section, or one section
- *	     per ECC chunk (and sometime several sections for a single ECC
- *	     ECC chunk)
- * @oobecc: OOB region struct filled with the appropriate ECC position
- *	    information
- *
- * This function is just a wrapper around the mtd->ecclayout field and is
- * here to ease the transition to the mtd_ooblayout_ops approach.
- * All it does is convert the layout->eccpos information into proper oob
- * region definitions.
- *
- * Returns zero on success, a negative error code otherwise.
- */
-static int mtd_ecclayout_ecc(struct mtd_info *mtd, int section,
-			     struct mtd_oob_region *oobecc)
-{
-	int eccbyte = 0, cursection = 0, length = 0, eccpos = 0;
-
-	if (!mtd->ecclayout)
-		return -ENOTSUPP;
-
-	/*
-	 * This logic allows us to reuse the ->ecclayout information and
-	 * expose them as ECC regions (as done for the OOB free regions).
-	 *
-	 * TODO: this should be dropped as soon as we get rid of the
-	 * ->ecclayout field.
-	 */
-	for (eccbyte = 0; eccbyte < mtd->ecclayout->eccbytes; eccbyte++) {
-		eccpos = mtd->ecclayout->eccpos[eccbyte];
-
-		if (eccbyte < mtd->ecclayout->eccbytes - 1) {
-			int neccpos = mtd->ecclayout->eccpos[eccbyte + 1];
-
-			if (eccpos + 1 == neccpos) {
-				length++;
-				continue;
-			}
-		}
-
-		if (section == cursection)
-			break;
-
-		length = 0;
-		cursection++;
-	}
-
-	if (cursection != section || eccbyte >= mtd->ecclayout->eccbytes)
-		return -ERANGE;
-
-	oobecc->length = length + 1;
-	oobecc->offset = eccpos - length;
-
-	return 0;
-}
-
-/**
- * mtd_ecclayout_ecc - Default ooblayout_free iterator implementation
- * @mtd: MTD device structure
- * @section: Free section. Depending on the layout you may have all the free
- *	     bytes stored in a single contiguous section, or one section
- *	     per ECC chunk (and sometime several sections for a single ECC
- *	     ECC chunk)
- * @oobfree: OOB region struct filled with the appropriate free position
- *	     information
- *
- * This function is just a wrapper around the mtd->ecclayout field and is
- * here to ease the transition to the mtd_ooblayout_ops approach.
- * All it does is convert the layout->oobfree information into proper oob
- * region definitions.
- *
- * Returns zero on success, a negative error code otherwise.
- */
-static int mtd_ecclayout_free(struct mtd_info *mtd, int section,
-			      struct mtd_oob_region *oobfree)
-{
-	struct nand_ecclayout *layout = mtd->ecclayout;
-
-	if (!layout)
-		return -ENOTSUPP;
-
-	if (section >= MTD_MAX_OOBFREE_ENTRIES_LARGE ||
-	    !layout->oobfree[section].length)
-		return -ERANGE;
-
-	oobfree->offset = layout->oobfree[section].offset;
-	oobfree->length = layout->oobfree[section].length;
-
-	return 0;
-}
-
-static const struct mtd_ooblayout_ops mtd_ecclayout_wrapper_ops = {
-	.ecc = mtd_ecclayout_ecc,
-	.free = mtd_ecclayout_free,
-};
-
-/**
- * mtd_set_ecclayout - Attach an ecclayout to an MTD device
- * @mtd: MTD device structure
- * @ecclayout: The ecclayout to attach to the device
- *
- * Returns zero on success, a negative error code otherwise.
- */
-void mtd_set_ecclayout(struct mtd_info *mtd, struct nand_ecclayout *ecclayout)
-{
-	if (!mtd || !ecclayout)
-		return;
-
-	mtd->ecclayout = ecclayout;
-	mtd_set_ooblayout(mtd, &mtd_ecclayout_wrapper_ops);
-}
-EXPORT_SYMBOL_GPL(mtd_set_ecclayout);
-
 /*
  * Method to access the protection register area, present in some flash
  * devices. The user data is one time programmable but the factory data is read
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index a38fe9a..df8c116 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -96,21 +96,6 @@ struct mtd_oob_ops {
 
 #define MTD_MAX_OOBFREE_ENTRIES_LARGE	32
 #define MTD_MAX_ECCPOS_ENTRIES_LARGE	640
-/*
- * Internal ECC layout control structure. For historical reasons, there is a
- * similar, smaller struct nand_ecclayout_user (in mtd-abi.h) that is retained
- * for export to user-space via the ECCGETLAYOUT ioctl.
- * nand_ecclayout should be expandable in the future simply by the above macros.
- *
- * This structure is now deprecated, you should use struct nand_ecclayout_ops
- * to describe your OOB layout.
- */
-struct nand_ecclayout {
-	__u32 eccbytes;
-	__u32 eccpos[MTD_MAX_ECCPOS_ENTRIES_LARGE];
-	struct nand_oobfree oobfree[MTD_MAX_OOBFREE_ENTRIES_LARGE];
-};
-
 /**
  * struct mtd_oob_region - oob region definition
  * @offset: region offset
@@ -200,9 +185,6 @@ struct mtd_info {
 	const char *name;
 	int index;
 
-	/* [Deprecated] ECC layout structure pointer - read only! */
-	struct nand_ecclayout *ecclayout;
-
 	/* OOB layout description */
 	const struct mtd_ooblayout_ops *ooblayout;
 
@@ -308,8 +290,6 @@ int mtd_ooblayout_set_databytes(struct mtd_info *mtd, const u8 *databuf,
 int mtd_ooblayout_count_freebytes(struct mtd_info *mtd);
 int mtd_ooblayout_count_eccbytes(struct mtd_info *mtd);
 
-void mtd_set_ecclayout(struct mtd_info *mtd, struct nand_ecclayout *ecclayout);
-
 static inline void mtd_set_ooblayout(struct mtd_info *mtd,
 				     const struct mtd_ooblayout_ops *ooblayout)
 {
diff --git a/include/uapi/mtd/mtd-abi.h b/include/uapi/mtd/mtd-abi.h
index 763bb69..0ec1da2 100644
--- a/include/uapi/mtd/mtd-abi.h
+++ b/include/uapi/mtd/mtd-abi.h
@@ -228,7 +228,7 @@ struct nand_oobfree {
  * complete set of ECC information. The ioctl truncates the larger internal
  * structure to retain binary compatibility with the static declaration of the
  * ioctl. Note that the "MTD_MAX_..._ENTRIES" macros represent the max size of
- * the user struct, not the MAX size of the internal struct nand_ecclayout.
+ * the user struct, not the MAX size of the internal OOB layout representation.
  */
 struct nand_ecclayout_user {
 	__u32 eccbytes;
-- 
2.1.4
