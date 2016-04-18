From: Roger Quadros <rogerq-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH v5 39/50] mtd: nand: omap2: switch to mtd_ooblayout_ops
Date: Mon, 18 Apr 2016 17:32:49 +0300
Message-ID: <5714F011.5080409@ti.com>
References: <1459354505-32551-1-git-send-email-boris.brezillon@free-electrons.com>
 <1459354505-32551-40-git-send-email-boris.brezillon@free-electrons.com>
Reply-To: rogerq-l0cyMroinI0@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBD45J6OZZMOBBOPA2O4AKGQEFX24MOY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <1459354505-32551-40-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
To: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Harvey Hunt <harvey.hunt-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Nicolas Ferre <nicolas.ferre-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, punnaiah choudary kalluri <punnaia-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>, Robert Jarzmik <robert.jarzmik-GANU6spQydw@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Archit Taneja <architt-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Dasu <kdasu.kdev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Wu <rainyfeeling-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>, Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Ezequiel Garcia <ezequiel.garcia-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Huang Shijie <shijie.huang-5wv7dgnIgG8@public.gmane.org>, Jean-Christophe
List-Id: linux-api@vger.kernel.org

Boris,

On 30/03/16 19:14, Boris Brezillon wrote:
> Implementing the mtd_ooblayout_ops interface is the new way of exposing
> ECC/OOB layout to MTD users.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
> ---
>  drivers/mtd/nand/omap2.c | 194 +++++++++++++++++++++++++++--------------------
>  1 file changed, 113 insertions(+), 81 deletions(-)
> 
> diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
> index 4ebf16b..bca154a 100644
> --- a/drivers/mtd/nand/omap2.c
> +++ b/drivers/mtd/nand/omap2.c
> @@ -169,8 +169,6 @@ struct omap_nand_info {
>  	u_char				*buf;
>  	int					buf_len;
>  	struct gpmc_nand_regs		reg;
> -	/* generated at runtime depending on ECC algorithm and layout selected */
> -	struct nand_ecclayout		oobinfo;
>  	/* fields specific for BCHx_HW ECC scheme */
>  	struct device			*elm_dev;
>  	struct device_node		*of_node;
> @@ -1639,19 +1637,108 @@ static bool omap2_nand_ecc_check(struct omap_nand_info *info,
>  	return true;
>  }
>  
> +static int omap_ooblayout_ecc(struct mtd_info *mtd, int section,
> +			      struct mtd_oob_region *oobregion)
> +{
> +	struct nand_chip *chip = mtd_to_nand(mtd);
> +	int off = chip->options & NAND_BUSWIDTH_16 ?
> +		  BADBLOCK_MARKER_LENGTH : 1;

IMO "off = 1" is valid only for OMAP_ECC_HAM1_CODE_HW and 8-bit NAND.
For all other layouts it is always set to BADBLOCK_MARKER_LENGTH.

> +
> +	if (section)
> +		return -ERANGE;
> +
> +	oobregion->offset = off;
> +	oobregion->length = chip->ecc.total;
> +
> +	return 0;
> +}
> +
> +static int omap_ooblayout_free(struct mtd_info *mtd, int section,
> +			       struct mtd_oob_region *oobregion)
> +{
> +	struct nand_chip *chip = mtd_to_nand(mtd);
> +	int off = chip->options & NAND_BUSWIDTH_16 ?
> +		  BADBLOCK_MARKER_LENGTH : 1;

ditto.

> +
> +	if (section)
> +		return -ERANGE;
> +
> +	off += chip->ecc.total;
> +	if (off >= mtd->oobsize)
> +		return -ERANGE;
> +
> +	oobregion->offset = off;
> +	oobregion->length = mtd->oobsize - off;
> +
> +	return 0;
> +}
> +
> +static const struct mtd_ooblayout_ops omap_ooblayout_ops = {
> +	.ecc = omap_ooblayout_ecc,
> +	.free = omap_ooblayout_free,
> +};
> +
> +static int omap_sw_ooblayout_ecc(struct mtd_info *mtd, int section,
> +				 struct mtd_oob_region *oobregion)
> +{
> +	struct nand_chip *chip = mtd_to_nand(mtd);
> +	int off = chip->options & NAND_BUSWIDTH_16 ?
> +		  BADBLOCK_MARKER_LENGTH : 1;
> +
> +	if (section >= chip->ecc.steps)
> +		return -ERANGE;
> +
> +	/*
> +	 * When SW correction is employed, one OMAP specific marker byte is
> +	 * reserved after each ECC step.
> +	 */
> +	oobregion->offset = off + (section * (chip->ecc.bytes + 1));
> +	oobregion->length = chip->ecc.bytes;
> +
> +	return 0;
> +}
> +
> +static int omap_sw_ooblayout_free(struct mtd_info *mtd, int section,
> +				  struct mtd_oob_region *oobregion)
> +{
> +	struct nand_chip *chip = mtd_to_nand(mtd);
> +	int off = chip->options & NAND_BUSWIDTH_16 ?
> +		  BADBLOCK_MARKER_LENGTH : 1;
> +
> +	if (section)
> +		return -ERANGE;
> +
> +	/*
> +	 * When SW correction is employed, one OMAP specific marker byte is
> +	 * reserved after each ECC step.
> +	 */
> +	off += ((chip->ecc.bytes + 1) * chip->ecc.steps);
> +	if (off >= mtd->oobsize)
> +		return -ERANGE;
> +
> +	oobregion->offset = off;
> +	oobregion->length = mtd->oobsize - off;
> +
> +	return 0;
> +}
> +
> +static const struct mtd_ooblayout_ops omap_sw_ooblayout_ops = {
> +	.ecc = omap_sw_ooblayout_ecc,
> +	.free = omap_sw_ooblayout_free,
> +};
> +
>  static int omap_nand_probe(struct platform_device *pdev)
>  {
>  	struct omap_nand_info		*info;
>  	struct omap_nand_platform_data	*pdata;
>  	struct mtd_info			*mtd;
>  	struct nand_chip		*nand_chip;
> -	struct nand_ecclayout		*ecclayout;
>  	int				err;
> -	int				i;
>  	dma_cap_mask_t			mask;
>  	unsigned			sig;
> -	unsigned			oob_index;
>  	struct resource			*res;
> +	int				min_oobbytes;
> +	int				oobbytes_per_step;
>  
>  	pdata = dev_get_platdata(&pdev->dev);
>  	if (pdata == NULL) {
> @@ -1810,7 +1897,7 @@ static int omap_nand_probe(struct platform_device *pdev)
>  
>  	/*
>  	 * Bail out earlier to let NAND_ECC_SOFT code create its own
> -	 * ecclayout instead of using ours.
> +	 * ooblayout instead of using ours.
>  	 */
>  	if (info->ecc_opt == OMAP_ECC_HAM1_CODE_SW) {
>  		nand_chip->ecc.mode = NAND_ECC_SOFT;
> @@ -1818,8 +1905,6 @@ static int omap_nand_probe(struct platform_device *pdev)
>  	}
>  
>  	/* populate MTD interface based on ECC scheme */
> -	ecclayout		= &info->oobinfo;
> -	nand_chip->ecc.layout	= ecclayout;
>  	switch (info->ecc_opt) {
>  	case OMAP_ECC_HAM1_CODE_HW:
>  		pr_info("nand: using OMAP_ECC_HAM1_CODE_HW\n");
> @@ -1830,19 +1915,8 @@ static int omap_nand_probe(struct platform_device *pdev)
>  		nand_chip->ecc.calculate        = omap_calculate_ecc;
>  		nand_chip->ecc.hwctl            = omap_enable_hwecc;
>  		nand_chip->ecc.correct          = omap_correct_data;
> -		/* define ECC layout */
> -		ecclayout->eccbytes		= nand_chip->ecc.bytes *
> -							(mtd->writesize /
> -							nand_chip->ecc.size);
> -		if (nand_chip->options & NAND_BUSWIDTH_16)
> -			oob_index		= BADBLOCK_MARKER_LENGTH;
> -		else
> -			oob_index		= 1;
> -		for (i = 0; i < ecclayout->eccbytes; i++, oob_index++)
> -			ecclayout->eccpos[i]	= oob_index;
> -		/* no reserved-marker in ecclayout for this ecc-scheme */
> -		ecclayout->oobfree->offset	=
> -				ecclayout->eccpos[ecclayout->eccbytes - 1] + 1;
> +		mtd_set_ooblayout(mtd, &omap_ooblayout_ops);
> +		oobbytes_per_step		= nand_chip->ecc.bytes;
>  		break;
>  
>  	case OMAP_ECC_BCH4_CODE_HW_DETECTION_SW:
> @@ -1854,19 +1928,9 @@ static int omap_nand_probe(struct platform_device *pdev)
>  		nand_chip->ecc.hwctl		= omap_enable_hwecc_bch;
>  		nand_chip->ecc.correct		= nand_bch_correct_data;
>  		nand_chip->ecc.calculate	= omap_calculate_ecc_bch;
> -		/* define ECC layout */
> -		ecclayout->eccbytes		= nand_chip->ecc.bytes *
> -							(mtd->writesize /
> -							nand_chip->ecc.size);
> -		oob_index			= BADBLOCK_MARKER_LENGTH;
> -		for (i = 0; i < ecclayout->eccbytes; i++, oob_index++) {
> -			ecclayout->eccpos[i] = oob_index;
> -			if (((i + 1) % nand_chip->ecc.bytes) == 0)
> -				oob_index++;
> -		}
> -		/* include reserved-marker in ecclayout->oobfree calculation */
> -		ecclayout->oobfree->offset	= 1 +
> -				ecclayout->eccpos[ecclayout->eccbytes - 1] + 1;
> +		mtd_set_ooblayout(mtd, &omap_sw_ooblayout_ops);
> +		/* Reserve one byte for the OMAP marker */
> +		oobbytes_per_step		= nand_chip->ecc.bytes + 1;
>  		/* software bch library is used for locating errors */
>  		nand_chip->ecc.priv		= nand_bch_init(mtd);
>  		if (!nand_chip->ecc.priv) {
> @@ -1888,16 +1952,8 @@ static int omap_nand_probe(struct platform_device *pdev)
>  		nand_chip->ecc.calculate	= omap_calculate_ecc_bch;
>  		nand_chip->ecc.read_page	= omap_read_page_bch;
>  		nand_chip->ecc.write_page	= omap_write_page_bch;
> -		/* define ECC layout */
> -		ecclayout->eccbytes		= nand_chip->ecc.bytes *
> -							(mtd->writesize /
> -							nand_chip->ecc.size);
> -		oob_index			= BADBLOCK_MARKER_LENGTH;
> -		for (i = 0; i < ecclayout->eccbytes; i++, oob_index++)
> -			ecclayout->eccpos[i]	= oob_index;
> -		/* reserved marker already included in ecclayout->eccbytes */
> -		ecclayout->oobfree->offset	=
> -				ecclayout->eccpos[ecclayout->eccbytes - 1] + 1;
> +		mtd_set_ooblayout(mtd, &omap_ooblayout_ops);
> +		oobbytes_per_step		= nand_chip->ecc.bytes;
>  
>  		err = elm_config(info->elm_dev, BCH4_ECC,
>  				 mtd->writesize / nand_chip->ecc.size,
> @@ -1915,19 +1971,9 @@ static int omap_nand_probe(struct platform_device *pdev)
>  		nand_chip->ecc.hwctl		= omap_enable_hwecc_bch;
>  		nand_chip->ecc.correct		= nand_bch_correct_data;
>  		nand_chip->ecc.calculate	= omap_calculate_ecc_bch;
> -		/* define ECC layout */
> -		ecclayout->eccbytes		= nand_chip->ecc.bytes *
> -							(mtd->writesize /
> -							nand_chip->ecc.size);
> -		oob_index			= BADBLOCK_MARKER_LENGTH;
> -		for (i = 0; i < ecclayout->eccbytes; i++, oob_index++) {
> -			ecclayout->eccpos[i] = oob_index;
> -			if (((i + 1) % nand_chip->ecc.bytes) == 0)
> -				oob_index++;
> -		}
> -		/* include reserved-marker in ecclayout->oobfree calculation */
> -		ecclayout->oobfree->offset	= 1 +
> -				ecclayout->eccpos[ecclayout->eccbytes - 1] + 1;
> +		mtd_set_ooblayout(mtd, &omap_sw_ooblayout_ops);
> +		/* Reserve one byte for the OMAP marker */
> +		oobbytes_per_step		= nand_chip->ecc.bytes + 1;
>  		/* software bch library is used for locating errors */
>  		nand_chip->ecc.priv		= nand_bch_init(mtd);
>  		if (!nand_chip->ecc.priv) {
> @@ -1949,6 +1995,8 @@ static int omap_nand_probe(struct platform_device *pdev)
>  		nand_chip->ecc.calculate	= omap_calculate_ecc_bch;
>  		nand_chip->ecc.read_page	= omap_read_page_bch;
>  		nand_chip->ecc.write_page	= omap_write_page_bch;
> +		mtd_set_ooblayout(mtd, &omap_ooblayout_ops);
> +		oobbytes_per_step		= nand_chip->ecc.bytes;
>  
>  		err = elm_config(info->elm_dev, BCH8_ECC,
>  				 mtd->writesize / nand_chip->ecc.size,
> @@ -1956,16 +2004,6 @@ static int omap_nand_probe(struct platform_device *pdev)
>  		if (err < 0)
>  			goto return_error;
>  
> -		/* define ECC layout */
> -		ecclayout->eccbytes		= nand_chip->ecc.bytes *
> -							(mtd->writesize /
> -							nand_chip->ecc.size);
> -		oob_index			= BADBLOCK_MARKER_LENGTH;
> -		for (i = 0; i < ecclayout->eccbytes; i++, oob_index++)
> -			ecclayout->eccpos[i]	= oob_index;
> -		/* reserved marker already included in ecclayout->eccbytes */
> -		ecclayout->oobfree->offset	=
> -				ecclayout->eccpos[ecclayout->eccbytes - 1] + 1;
>  		break;
>  
>  	case OMAP_ECC_BCH16_CODE_HW:
> @@ -1979,6 +2017,8 @@ static int omap_nand_probe(struct platform_device *pdev)
>  		nand_chip->ecc.calculate	= omap_calculate_ecc_bch;
>  		nand_chip->ecc.read_page	= omap_read_page_bch;
>  		nand_chip->ecc.write_page	= omap_write_page_bch;
> +		mtd_set_ooblayout(mtd, &omap_ooblayout_ops);
> +		oobbytes_per_step		= nand_chip->ecc.bytes;
>  
>  		err = elm_config(info->elm_dev, BCH16_ECC,
>  				 mtd->writesize / nand_chip->ecc.size,
> @@ -1986,16 +2026,6 @@ static int omap_nand_probe(struct platform_device *pdev)
>  		if (err < 0)
>  			goto return_error;
>  
> -		/* define ECC layout */
> -		ecclayout->eccbytes		= nand_chip->ecc.bytes *
> -							(mtd->writesize /
> -							nand_chip->ecc.size);
> -		oob_index			= BADBLOCK_MARKER_LENGTH;
> -		for (i = 0; i < ecclayout->eccbytes; i++, oob_index++)
> -			ecclayout->eccpos[i]	= oob_index;
> -		/* reserved marker already included in ecclayout->eccbytes */
> -		ecclayout->oobfree->offset	=
> -				ecclayout->eccpos[ecclayout->eccbytes - 1] + 1;
>  		break;
>  	default:
>  		dev_err(&info->pdev->dev, "invalid or unsupported ECC scheme\n");
> @@ -2003,13 +2033,15 @@ static int omap_nand_probe(struct platform_device *pdev)
>  		goto return_error;
>  	}
>  
> -	/* all OOB bytes from oobfree->offset till end off OOB are free */
> -	ecclayout->oobfree->length = mtd->oobsize - ecclayout->oobfree->offset;
>  	/* check if NAND device's OOB is enough to store ECC signatures */
> -	if (mtd->oobsize < (ecclayout->eccbytes + BADBLOCK_MARKER_LENGTH)) {
> +	min_oobbytes = (oobbytes_per_step *
> +			(mtd->writesize / nand_chip->ecc.size)) +
> +		       (nand_chip->options & NAND_BUSWIDTH_16 ?
> +			BADBLOCK_MARKER_LENGTH : 1);

would it affect this as well?

> +	if (mtd->oobsize < min_oobbytes) {
>  		dev_err(&info->pdev->dev,
>  			"not enough OOB bytes required = %d, available=%d\n",
> -			ecclayout->eccbytes, mtd->oobsize);
> +			min_oobbytes, mtd->oobsize);
>  		err = -EINVAL;
>  		goto return_error;
>  	}
> 

I will need to test this change with all possible configurations.
The number of configurations on OMAP is a bit overwhelming :(.

cheers,
-roger
