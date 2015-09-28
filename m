From: Andreas Dannenberg <dannenberg@ti.com>
Subject: Re: [PATCH v7 09/15] power: bq24257: Add SW-based approach for Power
 Good determination
Date: Mon, 28 Sep 2015 07:04:12 -0500
Message-ID: <20150928120412.GA12676@borg>
References: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
 <1443196460-26156-10-git-send-email-dannenberg@ti.com>
 <20150927202025.GA2051@earth>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150927202025.GA2051@earth>
Sender: linux-pm-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Laurentiu Palcu <laurentiu.palcu@intel.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>, Ramakrishna Pallala <ramakrishna.pallala@intel.com>, linux-pm@vger.kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, Sep 27, 2015 at 10:20:26PM +0200, Sebastian Reichel wrote:
> Hi,
> 
> On Fri, Sep 25, 2015 at 10:54:14AM -0500, Andreas Dannenberg wrote:
> > @@ -651,15 +670,18 @@ static int bq24257_power_supply_init(struct bq24257_device *bq)
> >  	return PTR_ERR_OR_ZERO(bq->charger);
> >  }
> >  
> > -static int bq24257_pg_gpio_probe(struct bq24257_device *bq)
> > +static void bq24257_pg_gpio_probe(struct bq24257_device *bq)
> >  {
> > -	bq->pg = devm_gpiod_get_index(bq->dev, BQ24257_PG_GPIO, 0, GPIOD_IN);
> > +	bq->pg = devm_gpiod_get_optional(bq->dev, BQ24257_PG_GPIO, GPIOD_IN);
> > +
> >  	if (IS_ERR(bq->pg)) {
> > -		dev_err(bq->dev, "could not probe PG pin\n");
> > -		return PTR_ERR(bq->pg);
> > +		dev_err(bq->dev, "error probing PG pin\n");
> > +		bq->pg = NULL;
> > +		return;
> >  	}
> 
> You should handle -EPROBE_DEFER here.

Hi Sebastian. From having a quick look at the Kernel tree it seems like
this error shouldn't get exposed to the user (which it doesn't since it
would get zeroe'd out) and the error itself suggests that I should
"retry" which none of the things I looked at in the Kernel through "git
grep" seemed to do. So before making any assumptions I wanted to see if
I'm missing something or you could give me any pointers how to proceed.

Thanks,

--
Andreas Dannenberg
Texas Instruments Inc
