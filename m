From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 01/10] regmap: Introduce regmap_get_max_register.
Date: Mon, 4 May 2015 13:05:37 +0100
Message-ID: <20150504120537.GL15510@sirena.org.uk>
References: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1427752587-17087-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="XRwESHC7KXlqFpSs"
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427752587-17087-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, s.hauer@pengutronix.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org
List-Id: linux-api@vger.kernel.org


--XRwESHC7KXlqFpSs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 30, 2015 at 10:56:27PM +0100, Srinivas Kandagatla wrote:

> +int regmap_get_max_register(struct regmap *map)
> +{
> +	return map->max_register ? : -EINVAL;
> +}

Please don't abuse the ternery operator like this, write a proper if
statement that people can read.

--XRwESHC7KXlqFpSs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVR2CQAAoJECTWi3JdVIfQsIwIAIHd1DVFF5uNGGIlC7+MaJX7
pChHWmUJwEF1sLRkiMZOJx33p5jhetH0eY9Br2pt2CzpBf6Vbux+hv3uiB6roE/E
XadjuPqmwEyhRxoBhAJlQGcMASIJbFyVVLXsj+WLJ8F28lzT6dP9b6oRZVu+/jbJ
c8uEKmt5SP2jS+S956OQEQ6T95udeDXAyb7jgjJdmlEtnFc0aVnAdsWnI3XCij5a
i5KeBZkcI9+Pl6fkoTJN8A9YV/Fnn+Sg7ArlUAaEAAIWKV887BoD5qVfFUcnt75u
RlEN0c4hPtHuFPzfVAeyPefbLuBij/zxAUs2Nh10Fw6QGMVBzgW+WLypt2cW//g=
=lLnB
-----END PGP SIGNATURE-----

--XRwESHC7KXlqFpSs--
