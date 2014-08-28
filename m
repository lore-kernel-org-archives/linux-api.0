From: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v4 6/8] power: max17040: Add ID for MAX77836 Fuel Gauge
 block
Date: Thu, 28 Aug 2014 14:28:14 +0200
Message-ID: <1409228894.25322.15.camel@AMDC1943>
References: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
 <1409152814-17302-7-git-send-email-k.kozlowski@samsung.com>
 <20140828115219.GQ24579@lee--X1>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20140828115219.GQ24579@lee--X1>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liam Girdwood <lgirdwood-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On czw, 2014-08-28 at 12:52 +0100, Lee Jones wrote:
> On Wed, 27 Aug 2014, Krzysztof Kozlowski wrote:
> 
> > MAX77836 has the same Fuel Gauge as MAX17040/17048. The max17040 driver
> > can be safely re-used. The patch adds MAX77836 ID to array of
> > i2c_device_id.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> > Cc: Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> > ---
> >  drivers/power/max17040_battery.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
> > index 0fbac861080d..165ffe381803 100644
> > --- a/drivers/power/max17040_battery.c
> > +++ b/drivers/power/max17040_battery.c
> > @@ -278,6 +278,7 @@ static SIMPLE_DEV_PM_OPS(max17040_pm_ops, max17040_suspend, max17040_resume);
> >  
> >  static const struct i2c_device_id max17040_id[] = {
> >  	{ "max17040", 0 },
> > +	{ "max77836-battery", 0 },
> 
> Are you sure you want the IDs to be the same?
> 
> If they are not used, just drop them entirely.

They are not used but you're right that the ID should be different. I'll
add an local enum for the ID.

Thanks for feedback!
Krzysztof

> 
> >  	{ }
> >  };
> >  MODULE_DEVICE_TABLE(i2c, max17040_id);
> 
