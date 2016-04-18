From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v5 39/50] mtd: nand: omap2: switch to mtd_ooblayout_ops
Date: Mon, 18 Apr 2016 17:05:18 +0200
Message-ID: <20160418170518.363f732d@bbrezillon>
References: <1459354505-32551-1-git-send-email-boris.brezillon@free-electrons.com>
	<1459354505-32551-40-git-send-email-boris.brezillon@free-electrons.com>
	<5714F011.5080409@ti.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBMHP2O4AKGQERMGPOGY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <5714F011.5080409-l0cyMroinI0@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
To: Roger Quadros <rogerq-l0cyMroinI0@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Harvey Hunt <harvey.hunt-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Nicolas Ferre <nicolas.ferre-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, punnaiah choudary kalluri <punnaia-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>, Robert Jarzmik <robert.jarzmik-GANU6spQydw@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Archit Taneja <architt-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Dasu <kdasu.kdev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Wu <rainyfeeling-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>, Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Ezequiel Garcia <ezequiel.garcia-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Huang Shijie <shijie.huang@arm>
List-Id: linux-api@vger.kernel.org

On Mon, 18 Apr 2016 17:32:49 +0300
Roger Quadros <rogerq-l0cyMroinI0@public.gmane.org> wrote:

> Boris,
> 
> On 30/03/16 19:14, Boris Brezillon wrote:
> > Implementing the mtd_ooblayout_ops interface is the new way of exposing
> > ECC/OOB layout to MTD users.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
> > ---
> >  drivers/mtd/nand/omap2.c | 194 +++++++++++++++++++++++++++--------------------
> >  1 file changed, 113 insertions(+), 81 deletions(-)
> > 
> > diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
> > index 4ebf16b..bca154a 100644
> > --- a/drivers/mtd/nand/omap2.c
> > +++ b/drivers/mtd/nand/omap2.c
> > @@ -169,8 +169,6 @@ struct omap_nand_info {
> >  	u_char				*buf;
> >  	int					buf_len;
> >  	struct gpmc_nand_regs		reg;
> > -	/* generated at runtime depending on ECC algorithm and layout selected */
> > -	struct nand_ecclayout		oobinfo;
> >  	/* fields specific for BCHx_HW ECC scheme */
> >  	struct device			*elm_dev;
> >  	struct device_node		*of_node;
> > @@ -1639,19 +1637,108 @@ static bool omap2_nand_ecc_check(struct omap_nand_info *info,
> >  	return true;
> >  }
> >  
> > +static int omap_ooblayout_ecc(struct mtd_info *mtd, int section,
> > +			      struct mtd_oob_region *oobregion)
> > +{
> > +	struct nand_chip *chip = mtd_to_nand(mtd);
> > +	int off = chip->options & NAND_BUSWIDTH_16 ?
> > +		  BADBLOCK_MARKER_LENGTH : 1;
> 
> IMO "off = 1" is valid only for OMAP_ECC_HAM1_CODE_HW and 8-bit NAND.
> For all other layouts it is always set to BADBLOCK_MARKER_LENGTH.

Indeed.

[...]

> > -	/* all OOB bytes from oobfree->offset till end off OOB are free */
> > -	ecclayout->oobfree->length = mtd->oobsize - ecclayout->oobfree->offset;
> >  	/* check if NAND device's OOB is enough to store ECC signatures */
> > -	if (mtd->oobsize < (ecclayout->eccbytes + BADBLOCK_MARKER_LENGTH)) {
> > +	min_oobbytes = (oobbytes_per_step *
> > +			(mtd->writesize / nand_chip->ecc.size)) +
> > +		       (nand_chip->options & NAND_BUSWIDTH_16 ?
> > +			BADBLOCK_MARKER_LENGTH : 1);
> 
> would it affect this as well?

And here as well.

I've generated a patch (see below) fixing those problems.

> 
> > +	if (mtd->oobsize < min_oobbytes) {
> >  		dev_err(&info->pdev->dev,
> >  			"not enough OOB bytes required = %d, available=%d\n",
> > -			ecclayout->eccbytes, mtd->oobsize);
> > +			min_oobbytes, mtd->oobsize);
> >  		err = -EINVAL;
> >  		goto return_error;
> >  	}
> > 
> 
> I will need to test this change with all possible configurations.
> The number of configurations on OMAP is a bit overwhelming :(.

Sorry about that, but at least now I have someone who can test it :).

Thanks,

Boris

--->8---

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 9b96f56..07d4039 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1640,9 +1640,13 @@ static bool omap2_nand_ecc_check(struct omap_nand_info *info,
 static int omap_ooblayout_ecc(struct mtd_info *mtd, int section,
 			      struct mtd_oob_region *oobregion)
 {
-	struct nand_chip *chip = mtd_to_nand(mtd);
-	int off = chip->options & NAND_BUSWIDTH_16 ?
-		  BADBLOCK_MARKER_LENGTH : 1;
+	struct omap_nand_info *info = mtd_to_omap(mtd);
+	struct nand_chip *chip = &info->nand;
+	int off = BADBLOCK_MARKER_LENGTH;
+
+	if (info->ecc_opt == OMAP_ECC_HAM1_CODE_HW &&
+	    !(chip->options & NAND_BUSWIDTH_16))
+		off = 1;
 
 	if (section)
 		return -ERANGE;
@@ -1656,9 +1660,13 @@ static int omap_ooblayout_ecc(struct mtd_info *mtd, int section,
 static int omap_ooblayout_free(struct mtd_info *mtd, int section,
 			       struct mtd_oob_region *oobregion)
 {
-	struct nand_chip *chip = mtd_to_nand(mtd);
-	int off = chip->options & NAND_BUSWIDTH_16 ?
-		  BADBLOCK_MARKER_LENGTH : 1;
+	struct omap_nand_info *info = mtd_to_omap(mtd);
+	struct nand_chip *chip = &info->nand;
+	int off = BADBLOCK_MARKER_LENGTH;
+
+	if (info->ecc_opt == OMAP_ECC_HAM1_CODE_HW &&
+	    !(chip->options & NAND_BUSWIDTH_16))
+		off = 1;
 
 	if (section)
 		return -ERANGE;
@@ -1682,8 +1690,7 @@ static int omap_sw_ooblayout_ecc(struct mtd_info *mtd, int section,
 				 struct mtd_oob_region *oobregion)
 {
 	struct nand_chip *chip = mtd_to_nand(mtd);
-	int off = chip->options & NAND_BUSWIDTH_16 ?
-		  BADBLOCK_MARKER_LENGTH : 1;
+	int off = BADBLOCK_MARKER_LENGTH;
 
 	if (section >= chip->ecc.steps)
 		return -ERANGE;
@@ -1702,8 +1709,7 @@ static int omap_sw_ooblayout_free(struct mtd_info *mtd, int section,
 				  struct mtd_oob_region *oobregion)
 {
 	struct nand_chip *chip = mtd_to_nand(mtd);
-	int off = chip->options & NAND_BUSWIDTH_16 ?
-		  BADBLOCK_MARKER_LENGTH : 1;
+	int off = BADBLOCK_MARKER_LENGTH;
 
 	if (section)
 		return -ERANGE;
@@ -1737,7 +1743,7 @@ static int omap_nand_probe(struct platform_device *pdev)
 	dma_cap_mask_t			mask;
 	unsigned			sig;
 	struct resource			*res;
-	int				min_oobbytes;
+	int				min_oobbytes = BADBLOCK_MARKER_LENGTH;
 	int				oobbytes_per_step;
 
 	pdata = dev_get_platdata(&pdev->dev);
@@ -1921,6 +1927,9 @@ static int omap_nand_probe(struct platform_device *pdev)
 		nand_chip->ecc.correct          = omap_correct_data;
 		mtd_set_ooblayout(mtd, &omap_ooblayout_ops);
 		oobbytes_per_step		= nand_chip->ecc.bytes;
+
+		if (nand_chip->options & NAND_BUSWIDTH_16)
+			min_oobbytes		= 1;
 		break;
 
 	case OMAP_ECC_BCH4_CODE_HW_DETECTION_SW:
@@ -2038,10 +2047,8 @@ static int omap_nand_probe(struct platform_device *pdev)
 	}
 
 	/* check if NAND device's OOB is enough to store ECC signatures */
-	min_oobbytes = (oobbytes_per_step *
-			(mtd->writesize / nand_chip->ecc.size)) +
-		       (nand_chip->options & NAND_BUSWIDTH_16 ?
-			BADBLOCK_MARKER_LENGTH : 1);
+	min_oobbytes += (oobbytes_per_step *
+			 (mtd->writesize / nand_chip->ecc.size));
 	if (mtd->oobsize < min_oobbytes) {
 		dev_err(&info->pdev->dev,
 			"not enough OOB bytes required = %d, available=%d\n",
