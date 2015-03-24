From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 1/9] regmap: Introduce regmap_get_max_register.
Date: Tue, 24 Mar 2015 15:36:37 -0700
Message-ID: <20150324223637.GB28997@sirena.org.uk>
References: <1427236116-18531-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1427236179-18580-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427236179-18580-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org
List-Id: linux-api@vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 24, 2015 at 10:29:39PM +0000, Srinivas Kandagatla wrote:

> This patch introduces regmap_get_max_register() function which would be
> used by the infrastructures like eeprom framework built on top of
> regmap.

In what way would it be used?

> +int regmap_get_max_register(struct regmap *map)
> +{
> +	return map->max_register ? : -EINVAL;
> +}

Please write the logic out properly, don't abuse the ternery operator.

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVEebtAAoJECTWi3JdVIfQZS8H/2nyD0jfmKnaCemhE7f9GaAd
e55V2j45ZJ1J2RUHIRzgMLKLpuiYiFpGy7fVnUXFpwYPPbrwcrikdI+R8Qmxelpm
sdf/LZ8hNZ5tVlz04j7aMptFE8Mz8zuxc7T25kSxa0+q/1GwKjEFwOtsV0E6Wro3
zytM7t01La6ngeLGxg7qLPnZtztnS3+3t9UD0tsgSVo9PviaI4YecYCXmR9y2nLy
/pdVWka5amBAPGMDbQLJIdi1yneHo3nB52mWye94Fr7jiClJuoOasOTs2/xDYI3J
OEo/y3zDezJ3MWSY+yVFkUMGvWoCRspnTMxi/InHMglg7n3ZOmkpwoR4UfNGfTA=
=IE/k
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
