From: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 09/15] power: bq24257: Add SW-based approach for Power
 Good determination
Date: Sun, 27 Sep 2015 22:20:26 +0200
Message-ID: <20150927202025.GA2051@earth>
References: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
 <1443196460-26156-10-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443196460-26156-10-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 25, 2015 at 10:54:14AM -0500, Andreas Dannenberg wrote:
> @@ -651,15 +670,18 @@ static int bq24257_power_supply_init(struct bq24257=
_device *bq)
>  	return PTR_ERR_OR_ZERO(bq->charger);
>  }
> =20
> -static int bq24257_pg_gpio_probe(struct bq24257_device *bq)
> +static void bq24257_pg_gpio_probe(struct bq24257_device *bq)
>  {
> -	bq->pg =3D devm_gpiod_get_index(bq->dev, BQ24257_PG_GPIO, 0, GPIOD_IN);
> +	bq->pg =3D devm_gpiod_get_optional(bq->dev, BQ24257_PG_GPIO, GPIOD_IN);
> +
>  	if (IS_ERR(bq->pg)) {
> -		dev_err(bq->dev, "could not probe PG pin\n");
> -		return PTR_ERR(bq->pg);
> +		dev_err(bq->dev, "error probing PG pin\n");
> +		bq->pg =3D NULL;
> +		return;
>  	}

You should handle -EPROBE_DEFER here.

-- Sebastian

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJWCE+DAAoJENju1/PIO/qaZUEP/2S1lAhgHf+/+XynwRX9d3o/
AnhltiMB0xv78O+KHGaTufRT5mMfu8T40WMndJXsOJXfUUsY/xq1IAORGN3kfGzo
grW5aTWme1IAnw3nxPce0F2mII7/rlKQKVZyMh1vJqw9I2o3v8OGI9kXR6OjQ6Fl
GEwehFkdMc5ZSn2V6J84R5/mkgAl8xKvIjMVDPfoNH1AjPGijd7SE4olXrEeq5yI
4wYgOcXt2ZCNQ5wP+ju18BOWaUmVDe3fTaIAw6V/r++CSg97qum5fw15o1bdtDTB
vjTtguzh4VZGJnAzI+V6lhZWEg611UfOfFWMUfOxFRdAmXXG7atY+NlEiJgfK3P+
o1Ozq84dOVjKgt850KVSaYwcXtAUCwlBQF1N74rKiT7xgwhqIiPozkoZ0IAT5OAl
jSiVB2kqLE3VNu/GQ9SabVg/tdFvhJhAWPngRf4pzVRlWr25PBOgvtlJCN8CL2ZY
X8bi/abwK4dDK4Untbzla8jNS6KhGJE09c4eWlzq1GPYBUV1hDQLOFHz+0XGWaFh
4DCu3lEB2FUEQnXHq2vInMVwnns3s5mXXy6ledggDItMkc5hmgX20HgoAyxYR0mj
SRUdpwIJLL+7oCRisqkMzCNXiPx+55W0BijPeeNz9kxF+84V42cDOHao481Uz+pk
1fioLsoUslesQbyQbA5P
=pyhu
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
