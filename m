From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [RESEND PATCH v3 3/6] charger: max14577: Configure
 battery-dependent settings from DTS and sysfs
Date: Wed, 27 Aug 2014 15:55:25 +0200
Message-ID: <1409147725.25748.1.camel@AMDC1943>
References: <1409146282-25075-1-git-send-email-k.kozlowski@samsung.com>
 <1409146282-25075-4-git-send-email-k.kozlowski@samsung.com>
 <20140827135027.GF6364@lee--X1>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pm-owner@vger.kernel.org>
In-reply-to: <20140827135027.GF6364@lee--X1>
Sender: linux-pm-owner@vger.kernel.org
To: Lee Jones <lee.jones@linaro.org>
Cc: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-pm@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Kyungmin Park <kyungmin.park@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Jenny Tc <jenny.tc@intel.com>
List-Id: linux-api@vger.kernel.org

On =C5=9Bro, 2014-08-27 at 14:50 +0100, Lee Jones wrote:
> On Wed, 27 Aug 2014, Krzysztof Kozlowski wrote:
>=20
> > Remove hard-coded values for:
> >  - Fast Charge current,
> >  - End Of Charge current,
> >  - Fast Charge timer,
> >  - Overvoltage Protection Threshold,
> >  - Battery Constant Voltage,
> > and use DTS or sysfs to configure them. This allows using the max14=
577 charger
> > driver with different batteries.
> >=20
> > Now the charger driver requires valid configuration data from DTS. =
In
> > case of wrong configuration data it fails during probe. Patch adds
> > of_compatible to the charger mfd cell in MFD driver core.
> >=20
> > The fast charge timer is configured through sysfs entry.
> >=20
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> > Cc: David Woodhouse <dwmw2@infradead.org>
> > Cc: Jenny Tc <jenny.tc@intel.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/mfd/max14577.c               |   5 +-
>=20
> Hmm... not sure why I Acked this.  The code looks okay, but can you
> break out the MFD changed into a separate patch please?  You can add
> my Ack to the broken out patch though.

Sure, I'll split it however the compatible here in mfd_cell makes sense
only with this patch.

Best regards,
Krzysztof


