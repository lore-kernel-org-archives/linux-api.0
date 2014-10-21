From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v2 2/5] mfd: max77693: Map charger device to its own
 of_node
Date: Tue, 21 Oct 2014 11:17:59 +0100
Message-ID: <20141021101759.GG26842@x1>
References: <1413808489-3524-1-git-send-email-k.kozlowski@samsung.com>
 <1413808489-3524-3-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1413808489-3524-3-git-send-email-k.kozlowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>, linux-api@vger.kernel.org, devicetree@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
List-Id: linux-api@vger.kernel.org

On Mon, 20 Oct 2014, Krzysztof Kozlowski wrote:

> Add a "maxim,max77693-charger" of_compatible to the mfd_cell so the M=
=46D
> child device (the charger) will have its own of_node set. This will b=
e
> used by the max77693 charger driver in next patches to obtain battery
> configuration from DTS.
>=20
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/max77693.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Applied, thanks.

> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> index cf008f45968c..2277a11b6629 100644
> --- a/drivers/mfd/max77693.c
> +++ b/drivers/mfd/max77693.c
> @@ -43,7 +43,10 @@
> =20
>  static const struct mfd_cell max77693_devs[] =3D {
>  	{ .name =3D "max77693-pmic", },
> -	{ .name =3D "max77693-charger", },
> +	{
> +		.name =3D "max77693-charger",
> +		.of_compatible =3D "maxim,max77693-charger",
> +	},
>  	{ .name =3D "max77693-muic", },
>  	{ .name =3D "max77693-haptic", },
>  	{

--=20
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
