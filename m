From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/7] eeprom: Add a simple EEPROM framework for eeprom
 providers
Date: Mon, 23 Mar 2015 14:09:18 -0700
Message-ID: <20150323210918.GS14954@sirena.org.uk>
References: <1426240157-2383-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1426240214-2434-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/U0GMd1Pus0mbMSS"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1426240214-2434-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--/U0GMd1Pus0mbMSS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 13, 2015 at 09:50:14AM +0000, Srinivas Kandagatla wrote:

A couple of *very* minor points below, otherwise this looks OK to me.

> +struct eeprom_device *eeprom_register(struct eeprom_config *config)
> +{
> +	struct eeprom_device *eeprom;
> +	int rval;
> +
> +	if (!config->regmap || !config->size) {
> +		dev_err(config->dev, "Regmap not found\n");
> +		return ERR_PTR(-EINVAL);
> +	}

You have a struct device in the config and the regmap API has
dev_get_regmap() which for most devices that don't have multiple regmaps
will give the right regmap.  It would be nice to support this as a
convenience for users.

> +	eeprom = kzalloc(sizeof(*eeprom), GFP_KERNEL);
> +	if (!eeprom)
> +		return ERR_PTR(-ENOMEM);

...

> +	rval = device_add(&eeprom->dev);
> +	if (rval)
> +		return ERR_PTR(rval);

Don't you need a kfree() if device_add() fails?

--/U0GMd1Pus0mbMSS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVEID9AAoJECTWi3JdVIfQvB8H/1zBEih+njT4mazG0vnHjs1O
9JA5+YzKJxnxQrZhFCr6H3I2ydR5RrUiyCCNq/8jkdBwbT092LfR7zuXRmE+2DaX
gTb/nsON/d/bR6kQSm34L6k41caDpzgIm2cACLBHvv0VeBtbY1xSjY8d/v/pEYd3
L2wsrREOvCyHLqV6dRmo7tBhxpBdCRWtpLhe0/dZJo7fMf8uzXZAv63sG/i876sd
AJMKd/jp8pN52CFyICB+IsA0mAubunAbqKOpjgeFtgKSvJxSmV/larZA9OJwiBqn
oEm/1Vu1tGs3101mSwo2kovoMHeVeX0vyxqIARHPnkJenH7zuzkFAdKneUpJI1k=
=dDHx
-----END PGP SIGNATURE-----

--/U0GMd1Pus0mbMSS--
