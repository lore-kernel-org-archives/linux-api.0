From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v4 2/8] mfd: max14577: Map charger device to its own
 of_node
Date: Thu, 28 Aug 2014 12:50:41 +0100
Message-ID: <20140828115041.GP24579@lee--X1>
References: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
 <1409152814-17302-3-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1409152814-17302-3-git-send-email-k.kozlowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-pm@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Kyungmin Park <kyungmin.park@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
List-Id: linux-api@vger.kernel.org

On Wed, 27 Aug 2014, Krzysztof Kozlowski wrote:

> Add a "maxim,max14577-charger" of_compatible to the mfd_cell so the
> MFD child device (the charger) will have its own of_node set. This wi=
ll
> be used by the max14577 charger driver in next patches to obtain batt=
ery
> configuration from DTS.
>=20
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/mfd/max14577.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> index 4a5e885383f8..6599407b5624 100644
> --- a/drivers/mfd/max14577.c
> +++ b/drivers/mfd/max14577.c
> @@ -35,7 +35,10 @@ static const struct mfd_cell max14577_devs[] =3D {
>  		.name =3D "max14577-regulator",
>  		.of_compatible =3D "maxim,max14577-regulator",
>  	},
> -	{ .name =3D "max14577-charger", },
> +	{
> +		.name =3D "max14577-charger",
> +		.of_compatible =3D "maxim,max14577-charger",
> +	},
>  };
> =20
>  static const struct mfd_cell max77836_devs[] =3D {

--=20
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
