From: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 04/15] power: bq24257: Use managed power supply
 register
Date: Mon, 28 Sep 2015 19:22:25 +0200
Message-ID: <20150928172222.GF3660@earth>
References: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
 <1443196460-26156-5-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oPmsXEqKQNHCSXW7"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443196460-26156-5-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--oPmsXEqKQNHCSXW7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 25, 2015 at 10:54:09AM -0500, Andreas Dannenberg wrote:
> Use the devm_* managed version of the function to register the power
> supply and remove the associated unregister function.
>=20
> Signed-off-by: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
> ---
>  drivers/power/bq24257_charger.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/power/bq24257_charger.c b/drivers/power/bq24257_char=
ger.c
> index d2d077c..6757b41 100644
> --- a/drivers/power/bq24257_charger.c
> +++ b/drivers/power/bq24257_charger.c
> @@ -590,8 +590,10 @@ static int bq24257_power_supply_init(struct bq24257_=
device *bq)
>  	psy_cfg.supplied_to =3D bq24257_charger_supplied_to;
>  	psy_cfg.num_supplicants =3D ARRAY_SIZE(bq24257_charger_supplied_to);
> =20
> -	bq->charger =3D power_supply_register(bq->dev, &bq24257_power_supply_de=
sc,
> -					    &psy_cfg);
> +	bq->charger =3D devm_power_supply_register(bq->dev,
> +						 &bq24257_power_supply_desc,
> +						 &psy_cfg);
> +
>  	if (IS_ERR(bq->charger))
>  		return PTR_ERR(bq->charger);
> =20
> @@ -742,8 +744,6 @@ static int bq24257_remove(struct i2c_client *client)
> =20
>  	cancel_delayed_work_sync(&bq->iilimit_setup_work);
> =20
> -	power_supply_unregister(bq->charger);
> -
>  	bq24257_field_write(bq, F_RESET, 1); /* reset to defaults */


This effectively reordering bq24257_field_write() before
power_supply_unregister(), so you may want to loose a few words in
the patch description, that this is a known/unproblematic
side-effect.

-- Sebastian

--oPmsXEqKQNHCSXW7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJWCXdLAAoJENju1/PIO/qaTZMP/2ZO6ptxsioCUYb/lYJDZGOr
6KnmXt2NoWvpI2IUYQ2zbdQ7OI5NIWDbEM4BgMqXQNL9hVDtxJLQa4YYGgPQ4o5G
sLDfiMQeeo4JyeT/C5cec/14NRm3K/n1GYSctuhWiyvV2q7YW37dFTYi/Art9uJ9
KcUfkQye6jmiynME5PTEbbA3HIDs5qE6LPTFOD3tqigBL9xlVrg1ovzWyxRTzF4A
Xd27vhk9eI5rU3or+LpUjt6tVw7sot+3btf8DtnP5R8VCrF8rWCd2tr/ypBjqtbb
sEoJZGWP4KA4P6G9M3zaESSI8xVVGRFKSGKZk7hqXTGAT48j1tF1SeWdrq4B1Ntk
7jB5SZ/MXflWYHIytDeDXjgQk2+6+uZinjZPkiaXNw7htqbPGzk5IT9aIvl8xGnl
v0/9VHfAOphzMv+QrEsyETb/aeN90F2d6JwTaWASoWNIZ01Ik3/IFgNpaerFpTmp
bXY06rUGyOEC4C9/3F1Q5datfQbpMT4diyk7rahK2vL5kofy67i1o7h35QktBkMo
NPzPr5XJJpmbmU2AIMVuEJWLCGjWZcj9seiZYWpvximeq8aC7BcdMt848kZjqOkY
I6JOUQW2EdFwZ/2BHE7xPDbxb3xwDRP16zrJOEP+kKAi4d0LPX4MuI6A0F3zwFtk
UZaDlg7H5+0c+vklfWNd
=Sf3L
-----END PGP SIGNATURE-----

--oPmsXEqKQNHCSXW7--
