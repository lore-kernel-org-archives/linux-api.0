From: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 1/8] mfd: max14577: Add defines for MAX77836 charger
Date: Thu, 28 Aug 2014 12:50:14 +0100
Message-ID: <20140828115014.GO24579@lee--X1>
References: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
 <1409152814-17302-2-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1409152814-17302-2-git-send-email-k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liam Girdwood <lgirdwood-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 27 Aug 2014, Krzysztof Kozlowski wrote:

> Prepare for adding support for MAX77836 charger to the max14577 charg=
er
> driver by adding necessary new defines and prefixes to existing ones.
>=20
> The MAX77836 uses slightly different values for ChgTyp field of STATU=
S2
> register. On the MAX14577 value of 0x6 is reserved and 0x7 dead batte=
ry.
> On the MAX77836 the opposite:
>  - 0x6 means special charger,
>  - 0x7 is reserved.
> Regardless of these differences use one common enum
> max14577_muic_charger_type.
>=20
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Cc: Kyungmin Park <kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> ---
>  include/linux/mfd/max14577-private.h | 54 ++++++++++++++++++++++++++=
----------
>  1 file changed, 40 insertions(+), 14 deletions(-)

Acked-by: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

> diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd=
/max14577-private.h
> index 499253604026..d6f321699b89 100644
> --- a/include/linux/mfd/max14577-private.h
> +++ b/include/linux/mfd/max14577-private.h
> @@ -72,15 +72,33 @@ enum max14577_muic_reg {
>  	MAX14577_MUIC_REG_END,
>  };
> =20
> +/*
> + * Combined charger types for max14577 and max77836.
> + *
> + * On max14577 three lower bits map to STATUS2/CHGTYP field.
> + * However the max77836 has different two last values of STATUS2/CHG=
TYP.
> + * To indicate the difference enum has two additional values for max=
77836.
> + * These values are just a register value bitwise OR with 0x8.
> + */
>  enum max14577_muic_charger_type {
> -	MAX14577_CHARGER_TYPE_NONE =3D 0,
> -	MAX14577_CHARGER_TYPE_USB,
> -	MAX14577_CHARGER_TYPE_DOWNSTREAM_PORT,
> -	MAX14577_CHARGER_TYPE_DEDICATED_CHG,
> -	MAX14577_CHARGER_TYPE_SPECIAL_500MA,
> -	MAX14577_CHARGER_TYPE_SPECIAL_1A,
> -	MAX14577_CHARGER_TYPE_RESERVED,
> -	MAX14577_CHARGER_TYPE_DEAD_BATTERY =3D 7,
> +	MAX14577_CHARGER_TYPE_NONE		=3D 0x0,
> +	MAX14577_CHARGER_TYPE_USB		=3D 0x1,
> +	MAX14577_CHARGER_TYPE_DOWNSTREAM_PORT	=3D 0x2,
> +	MAX14577_CHARGER_TYPE_DEDICATED_CHG	=3D 0x3,
> +	MAX14577_CHARGER_TYPE_SPECIAL_500MA	=3D 0x4,
> +	/* Special 1A or 2A charger */
> +	MAX14577_CHARGER_TYPE_SPECIAL_1A	=3D 0x5,
> +	/* max14577: reserved, used on max77836 */
> +	MAX14577_CHARGER_TYPE_RESERVED		=3D 0x6,
> +	/* max14577: dead-battery charing with maximum current 100mA */
> +	MAX14577_CHARGER_TYPE_DEAD_BATTERY	=3D 0x7,
> +	/*
> +	 * max77836: special charger (bias on D+/D-),
> +	 * matches register value of 0x6
> +	 */
> +	MAX77836_CHARGER_TYPE_SPECIAL_BIAS	=3D 0xe,
> +	/* max77836: reserved, register value 0x7 */
> +	MAX77836_CHARGER_TYPE_RESERVED		=3D 0xf,
>  };
> =20
>  /* MAX14577 interrupts */
> @@ -121,13 +139,15 @@ enum max14577_muic_charger_type {
>  #define STATUS2_CHGTYP_SHIFT		0
>  #define STATUS2_CHGDETRUN_SHIFT		3
>  #define STATUS2_DCDTMR_SHIFT		4
> -#define STATUS2_DBCHG_SHIFT		5
> +#define MAX14577_STATUS2_DBCHG_SHIFT	5
> +#define MAX77836_STATUS2_DXOVP_SHIFT	5
>  #define STATUS2_VBVOLT_SHIFT		6
>  #define MAX77836_STATUS2_VIDRM_SHIFT	7
>  #define STATUS2_CHGTYP_MASK		(0x7 << STATUS2_CHGTYP_SHIFT)
>  #define STATUS2_CHGDETRUN_MASK		BIT(STATUS2_CHGDETRUN_SHIFT)
>  #define STATUS2_DCDTMR_MASK		BIT(STATUS2_DCDTMR_SHIFT)
> -#define STATUS2_DBCHG_MASK		BIT(STATUS2_DBCHG_SHIFT)
> +#define MAX14577_STATUS2_DBCHG_MASK	BIT(MAX14577_STATUS2_DBCHG_SHIFT=
)
> +#define MAX77836_STATUS2_DXOVP_MASK	BIT(MAX77836_STATUS2_DXOVP_SHIFT=
)
>  #define STATUS2_VBVOLT_MASK		BIT(STATUS2_VBVOLT_SHIFT)
>  #define MAX77836_STATUS2_VIDRM_MASK	BIT(MAX77836_STATUS2_VIDRM_SHIFT=
)
> =20
> @@ -177,9 +197,11 @@ enum max14577_muic_charger_type {
>  #define CTRL3_JIGSET_SHIFT		0
>  #define CTRL3_BOOTSET_SHIFT		2
>  #define CTRL3_ADCDBSET_SHIFT		4
> +#define CTRL3_WBTH_SHIFT		6
>  #define CTRL3_JIGSET_MASK		(0x3 << CTRL3_JIGSET_SHIFT)
>  #define CTRL3_BOOTSET_MASK		(0x3 << CTRL3_BOOTSET_SHIFT)
>  #define CTRL3_ADCDBSET_MASK		(0x3 << CTRL3_ADCDBSET_SHIFT)
> +#define CTRL3_WBTH_MASK			(0x3 << CTRL3_WBTH_SHIFT)
> =20
>  /* Slave addr =3D 0x4A: Charger */
>  enum max14577_charger_reg {
> @@ -210,16 +232,20 @@ enum max14577_charger_reg {
>  #define CDETCTRL1_CHGTYPMAN_SHIFT	1
>  #define CDETCTRL1_DCDEN_SHIFT		2
>  #define CDETCTRL1_DCD2SCT_SHIFT		3
> -#define CDETCTRL1_DCHKTM_SHIFT		4
> -#define CDETCTRL1_DBEXIT_SHIFT		5
> +#define MAX14577_CDETCTRL1_DCHKTM_SHIFT	4
> +#define MAX77836_CDETCTRL1_CDLY_SHIFT	4
> +#define MAX14577_CDETCTRL1_DBEXIT_SHIFT	5
> +#define MAX77836_CDETCTRL1_DCDCPL_SHIFT	5
>  #define CDETCTRL1_DBIDLE_SHIFT		6
>  #define CDETCTRL1_CDPDET_SHIFT		7
>  #define CDETCTRL1_CHGDETEN_MASK		BIT(CDETCTRL1_CHGDETEN_SHIFT)
>  #define CDETCTRL1_CHGTYPMAN_MASK	BIT(CDETCTRL1_CHGTYPMAN_SHIFT)
>  #define CDETCTRL1_DCDEN_MASK		BIT(CDETCTRL1_DCDEN_SHIFT)
>  #define CDETCTRL1_DCD2SCT_MASK		BIT(CDETCTRL1_DCD2SCT_SHIFT)
> -#define CDETCTRL1_DCHKTM_MASK		BIT(CDETCTRL1_DCHKTM_SHIFT)
> -#define CDETCTRL1_DBEXIT_MASK		BIT(CDETCTRL1_DBEXIT_SHIFT)
> +#define MAX14577_CDETCTRL1_DCHKTM_MASK	BIT(MAX14577_CDETCTRL1_DCHKTM=
_SHIFT)
> +#define MAX77836_CDETCTRL1_CDDLY_MASK	BIT(MAX77836_CDETCTRL1_CDDLY_S=
HIFT)
> +#define MAX14577_CDETCTRL1_DBEXIT_MASK	BIT(MAX14577_CDETCTRL1_DBEXIT=
_SHIFT)
> +#define MAX77836_CDETCTRL1_DCDCPL_MASK	BIT(MAX77836_CDETCTRL1_DCDCPL=
_SHIFT)
>  #define CDETCTRL1_DBIDLE_MASK		BIT(CDETCTRL1_DBIDLE_SHIFT)
>  #define CDETCTRL1_CDPDET_MASK		BIT(CDETCTRL1_CDPDET_SHIFT)
> =20

--=20
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
