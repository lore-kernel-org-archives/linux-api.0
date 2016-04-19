From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v5 39/50] mtd: nand: omap2: switch to mtd_ooblayout_ops
Date: Tue, 19 Apr 2016 13:22:06 +0200
Message-ID: <20160419132206.5d909f7e@bbrezillon>
References: <1459354505-32551-1-git-send-email-boris.brezillon@free-electrons.com>
	<1459354505-32551-40-git-send-email-boris.brezillon@free-electrons.com>
	<5714F011.5080409@ti.com>
	<20160418170518.363f732d@bbrezillon>
	<57160862.90603@ti.com>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBYNJ3C4AKGQEUQCS4JQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <57160862.90603-l0cyMroinI0@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
To: Roger Quadros <rogerq-l0cyMroinI0@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Harvey Hunt <harvey.hunt-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Nicolas Ferre <nicolas.ferre-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, punnaiah choudary kalluri <punnaia-gjFFaj9aHVfQT0dZR+AlfA@public.gmane.org>, Robert Jarzmik <robert.jarzmik-GANU6spQydw@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Archit Taneja <architt-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Dasu <kdasu.kdev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Josh Wu <rainyfeeling-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>, Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, Ezequiel Garcia <ezequiel.garcia-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Huang Shijie <shijie.huang@arm>
List-Id: linux-api@vger.kernel.org

Hi Roger,

On Tue, 19 Apr 2016 13:28:50 +0300
Roger Quadros <rogerq-l0cyMroinI0@public.gmane.org> wrote:

> > @@ -1921,6 +1927,9 @@ static int omap_nand_probe(struct platform_device *pdev)
> >  		nand_chip->ecc.correct          = omap_correct_data;
> >  		mtd_set_ooblayout(mtd, &omap_ooblayout_ops);
> >  		oobbytes_per_step		= nand_chip->ecc.bytes;
> > +
> > +		if (nand_chip->options & NAND_BUSWIDTH_16)
> > +			min_oobbytes		= 1;
> 
> Shouldn't this have been
> 		if (!(nand_chip->options & NAND_BUSWIDTH_16)
> 			min_oobbytes		= 1;
> ?

Yep.

> 
> >  		break;
> >  
> >  	case OMAP_ECC_BCH4_CODE_HW_DETECTION_SW:
> > @@ -2038,10 +2047,8 @@ static int omap_nand_probe(struct platform_device *pdev)
> >  	}
> >  
> >  	/* check if NAND device's OOB is enough to store ECC signatures */
> > -	min_oobbytes = (oobbytes_per_step *
> > -			(mtd->writesize / nand_chip->ecc.size)) +
> > -		       (nand_chip->options & NAND_BUSWIDTH_16 ?
> > -			BADBLOCK_MARKER_LENGTH : 1);
> > +	min_oobbytes += (oobbytes_per_step *
> > +			 (mtd->writesize / nand_chip->ecc.size));
> >  	if (mtd->oobsize < min_oobbytes) {
> >  		dev_err(&info->pdev->dev,
> >  			"not enough OOB bytes required = %d, available=%d\n",
> > 
> 
> After the above changes BCH with HW ECC worked fine but BCH with SW ECC still failed.
> I had to fix it up with the below patch. This is mainly because chip->ecc.steps wasn't
> yet initialized before calling nand_bch_init().
> 
> After the below patch it worked fine with bch4 (hw & sw), bch8 (hw & sw) and ham1.
> I couldn't yet verify bch16 though.

Thanks for the fix, but I'd prefer fixing the bug for all soft BCH
users.

Could you try this patch?

--->8---

diff --git a/drivers/mtd/nand/nand_bch.c b/drivers/mtd/nand/nand_bch.c
index ca9b2a4..3ca3d39 100644
--- a/drivers/mtd/nand/nand_bch.c
+++ b/drivers/mtd/nand/nand_bch.c
@@ -177,6 +177,16 @@ struct nand_bch_control *nand_bch_init(struct mtd_info *mtd)
 		goto fail;
 	}
 
+	/*
+	 * ecc->steps and ecc->total might be used by mtd->ooblayout->ecc(),
+	 * which is called by mtd_ooblayout_count_eccbytes().
+	 * Make sure they are properly initialized before calling
+	 * mtd_ooblayout_count_eccbytes().
+	 * FIXME: we should probaly rework the sequencing in nand_scan_tail()
+	 * to avoid setting those fields twice.
+	 */
+	nand->ecc.steps = eccsteps;
+	nand->ecc.total = eccsteps * eccbytes;
 	if (mtd_ooblayout_count_eccbytes(mtd) != (eccsteps*eccbytes)) {
 		printk(KERN_WARNING "invalid ecc layout\n");
 		goto fail;
