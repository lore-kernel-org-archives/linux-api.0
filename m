From: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 2/5] mfd: max77693: Map charger device to its own of_node
Date: Tue, 21 Oct 2014 12:20:45 +0200
Message-ID: <1413886845.26980.18.camel@AMDC1943>
References: <1413808489-3524-1-git-send-email-k.kozlowski@samsung.com>
 <1413808489-3524-3-git-send-email-k.kozlowski@samsung.com>
 <20141020150630.GB26784@x1> <1413817781.11298.0.camel@AMDC1943>
 <20141021101705.GF26842@x1>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20141021101705.GF26842@x1>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On wto, 2014-10-21 at 11:17 +0100, Lee Jones wrote:
> On Mon, 20 Oct 2014, Krzysztof Kozlowski wrote:
> 
> > On pon, 2014-10-20 at 16:06 +0100, Lee Jones wrote:
> > > On Mon, 20 Oct 2014, Krzysztof Kozlowski wrote:
> > > 
> > > > Add a "maxim,max77693-charger" of_compatible to the mfd_cell so the MFD
> > > > child device (the charger) will have its own of_node set. This will be
> > > > used by the max77693 charger driver in next patches to obtain battery
> > > > configuration from DTS.
> > > > 
> > > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> > > > ---
> > > >  drivers/mfd/max77693.c | 5 ++++-
> > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> > > > index cf008f45968c..2277a11b6629 100644
> > > > --- a/drivers/mfd/max77693.c
> > > > +++ b/drivers/mfd/max77693.c
> > > > @@ -43,7 +43,10 @@
> > > >  
> > > >  static const struct mfd_cell max77693_devs[] = {
> > > >  	{ .name = "max77693-pmic", },
> > > > -	{ .name = "max77693-charger", },
> > > > +	{
> > > > +		.name = "max77693-charger",
> > > > +		.of_compatible = "maxim,max77693-charger",
> > > > +	},
> > > >  	{ .name = "max77693-muic", },
> > > >  	{ .name = "max77693-haptic", },
> > > >  	{
> > > 
> > > I'm guessing this can be applied separately?
> > 
> > Yes. Patch 3/5 also (it adds necessary defines and symbols for
> > chargers).
> 
> I'll take this patch, but I think 3/5 is required by some of the other
> patches in the set, no?

Yes, it is required by 4/5 (charger driver).

Best regards,
Krzysztof
