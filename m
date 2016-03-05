From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v3 16/52] mtd: nand: use mtd_set_ecclayout()
 where appropriate
Date: Sat, 5 Mar 2016 10:01:07 +0100
Message-ID: <20160305100107.5d582bee@bbrezillon>
References: <1456448280-27788-1-git-send-email-boris.brezillon@free-electrons.com>
	<1456448280-27788-17-git-send-email-boris.brezillon@free-electrons.com>
	<20160305022621.GN55664@google.com>
	<20160305095337.4a9e50fe@bbrezillon>
Reply-To: boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-sunxi+bncBCIPJ6FA2QLBBVWA5K3AKGQEGHPZ5SI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <20160305095337.4a9e50fe@bbrezillon>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
To: Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Haojian Zhuang <haojian.zhuang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Robert Jarzmik <robert.jarzmik-GANU6spQydw@public.gmane.org>, Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, Nicolas Ferre <nicolas.ferre-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Jean-Christophe Plagniol-Villard <plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Wenyou Yang <wenyou.yang-AIFe0yeh4nAAvxtiuMwx3w@public.gmane.org>, Josh Wu <rainyfeeling-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>, Ezequiel Garcia <ezequiel.garcia-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Greg
List-Id: linux-api@vger.kernel.org

On Sat, 5 Mar 2016 09:53:37 +0100
Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org> wrote:

> Hi Brian,
> 
> On Fri, 4 Mar 2016 18:26:21 -0800
> Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > On Fri, Feb 26, 2016 at 01:57:24AM +0100, Boris Brezillon wrote:
> > > Use the mtd_set_ecclayout() helper instead of directly assigning the
> > > mtd->ecclayout field.
> > > 
> > > Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
> > > ---
> > >  drivers/mtd/nand/nand_base.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> > > index 17504f2..5093a3c 100644
> > > --- a/drivers/mtd/nand/nand_base.c
> > > +++ b/drivers/mtd/nand/nand_base.c
> > > @@ -4288,7 +4288,7 @@ int nand_scan_tail(struct mtd_info *mtd)
> > >  		ecc->write_oob_raw = ecc->write_oob;
> > >  
> > >  	/* propagate ecc info to mtd_info */
> > > -	mtd->ecclayout = ecc->layout;
> > > +	mtd_set_ecclayout(mtd, ecc->layout);
> > 
> > I'm having trouble applying this one. For the life of me, I can't figure
> > out where you got this context from. This block only appears much later
> > in nand_scan_tail()...
> > 
> 
> Patch 7 has moved this section upper in the function to avoid problems
> when calculating the number of available/free OOB bytes.
> 
> > Do you think you could post a git tree with your intended changes? I may
> > just try to pull something in like that instead.
> 
> Yep, it's there [1].

Forgot to paste the link.

> Note that this branch contains the two fixes I
> talked about with Harvey and Stephan. I also made a few changes to use
> ecc->total instead of calculating (ecc->steps * ecc->bytes).

I'll probably also send a v4 with the fixes squashed in patch 5 and 7,
just for the record.

> 
> > 
> > BTW, I'm not sure the OMAP refactorings are going to come in time, but I
> > was planning to pull those directly from the TI folks (i.e., they won't
> > be rebased on l2-mtd.git), since there's some intermingling of platform
> > changes there. I think I can fix the conflicts fine, but FYI.
> 
> Okay, then I'll let you deal with those conflicts. I can check your
> conflict resolution if you're unsure.
> 
> Thanks,
> 
> Boris
> 
> 

[1]https://github.com/bbrezillon/linux-0day/tree/nand/ecclayout


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
