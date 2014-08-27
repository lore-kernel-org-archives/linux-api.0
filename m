From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [RESEND PATCH v3 3/6] charger: max14577: Configure
 battery-dependent settings from DTS and sysfs
Date: Wed, 27 Aug 2014 18:05:03 +0100
Message-ID: <20140827170503.GD24579@lee--X1>
References: <1409146282-25075-1-git-send-email-k.kozlowski@samsung.com>
 <1409146282-25075-4-git-send-email-k.kozlowski@samsung.com>
 <20140827135027.GF6364@lee--X1>
 <1409147725.25748.1.camel@AMDC1943>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1409147725.25748.1.camel@AMDC1943>
Sender: linux-pm-owner@vger.kernel.org
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-pm@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Kyungmin Park <kyungmin.park@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Jenny Tc <jenny.tc@intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, 27 Aug 2014, Krzysztof Kozlowski wrote:

> On =C5=9Bro, 2014-08-27 at 14:50 +0100, Lee Jones wrote:
> > On Wed, 27 Aug 2014, Krzysztof Kozlowski wrote:
> >=20
> > > Remove hard-coded values for:
> > >  - Fast Charge current,
> > >  - End Of Charge current,
> > >  - Fast Charge timer,
> > >  - Overvoltage Protection Threshold,
> > >  - Battery Constant Voltage,
> > > and use DTS or sysfs to configure them. This allows using the max=
14577 charger
> > > driver with different batteries.
> > >=20
> > > Now the charger driver requires valid configuration data from DTS=
=2E In
> > > case of wrong configuration data it fails during probe. Patch add=
s
> > > of_compatible to the charger mfd cell in MFD driver core.
> > >=20
> > > The fast charge timer is configured through sysfs entry.
> > >=20
> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > > Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> > > Cc: David Woodhouse <dwmw2@infradead.org>
> > > Cc: Jenny Tc <jenny.tc@intel.com>
> > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > Acked-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/mfd/max14577.c               |   5 +-
> >=20
> > Hmm... not sure why I Acked this.  The code looks okay, but can you
> > break out the MFD changed into a separate patch please?  You can ad=
d
> > my Ack to the broken out patch though.
>=20
> Sure, I'll split it however the compatible here in mfd_cell makes sen=
se
> only with this patch.

That's completely fine.

--=20
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
