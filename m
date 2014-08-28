From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v4 6/8] power: max17040: Add ID for MAX77836 Fuel Gauge
 block
Date: Thu, 28 Aug 2014 13:42:05 +0100
Message-ID: <20140828124205.GS24579@lee--X1>
References: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
 <1409152814-17302-7-git-send-email-k.kozlowski@samsung.com>
 <20140828115219.GQ24579@lee--X1>
 <1409228894.25322.15.camel@AMDC1943>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1409228894.25322.15.camel@AMDC1943>
Sender: linux-pm-owner@vger.kernel.org
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-pm@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Kyungmin Park <kyungmin.park@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
List-Id: linux-api@vger.kernel.org

On Thu, 28 Aug 2014, Krzysztof Kozlowski wrote:

> On czw, 2014-08-28 at 12:52 +0100, Lee Jones wrote:
> > On Wed, 27 Aug 2014, Krzysztof Kozlowski wrote:
> >=20
> > > MAX77836 has the same Fuel Gauge as MAX17040/17048. The max17040 =
driver
> > > can be safely re-used. The patch adds MAX77836 ID to array of
> > > i2c_device_id.
> > >=20
> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > > ---
> > >  drivers/power/max17040_battery.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >=20
> > > diff --git a/drivers/power/max17040_battery.c b/drivers/power/max=
17040_battery.c
> > > index 0fbac861080d..165ffe381803 100644
> > > --- a/drivers/power/max17040_battery.c
> > > +++ b/drivers/power/max17040_battery.c
> > > @@ -278,6 +278,7 @@ static SIMPLE_DEV_PM_OPS(max17040_pm_ops, max=
17040_suspend, max17040_resume);
> > > =20
> > >  static const struct i2c_device_id max17040_id[] =3D {
> > >  	{ "max17040", 0 },
> > > +	{ "max77836-battery", 0 },
> >=20
> > Are you sure you want the IDs to be the same?
> >=20
> > If they are not used, just drop them entirely.
>=20
> They are not used but you're right that the ID should be different. I=
'll
> add an local enum for the ID.

If they're not used, drop them.

 { "max17040" },
 { "max77836-battery" },

> > >  	{ }
> > >  };
> > >  MODULE_DEVICE_TABLE(i2c, max17040_id);
> >=20
>=20

--=20
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
