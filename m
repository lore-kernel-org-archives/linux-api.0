From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 1/7] eeprom: Add a simple EEPROM framework for eeprom
 providers
Date: Tue, 24 Mar 2015 10:23:46 -0700
Message-ID: <20150324172346.GW17265@sirena.org.uk>
References: <1426240157-2383-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1426240214-2434-1-git-send-email-srinivas.kandagatla@linaro.org>
 <20150323210918.GS14954@sirena.org.uk>
 <55108E2B.7050305@linaro.org>
 <55112BD6.2070600@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="oNLI4EWr1RPQuPCf"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55112BD6.2070600@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Kumar Gala <galak@codeaurora.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--oNLI4EWr1RPQuPCf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 24, 2015 at 09:18:14AM +0000, Srinivas Kandagatla wrote:

> I did try your suggestion, by which I could remove the regmap from config.
> One thing I did not like was eeprom-core getting size/stride info directly
> from providers and regmap from regmap apis. I was wondering if we could take
> a step further and introduce new regmap helpers like

> regmap_get_size(regmap)

This is already there.

> regmap_get_stride(regmap)

> Which would be give eeprom-core the size and stride info, doing this way
> would cut down regmap related things from eeprom_config structure to minimal
> and also the source of information would come from just regmap apis.

Documentation/SubmittingPatches...

--oNLI4EWr1RPQuPCf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVEZ2hAAoJECTWi3JdVIfQ80EH/2BOc+yTnqkp0l/jbAggXbi0
vrr0TP4o/37AHzkGBQfqLn+NB3gp7iekx1PmtNkXOXurR2odcyb8pCZ+qv20db7G
H0QsmLr7T2RqnhoO1DBFmeltpPu20TuPfpYIjb+jdIgrhMOoVnFZHrUvtnq5W2Ch
3a5Whx0/t6m6oe0LX+0bB/mZghcmeLh1TxUVSri6OMRYOE7GQvieZEooBFji5Hk5
O/BJvSQqsZJOgZcjUYuElKc495ocmwlqFqRYkXsqhHRJN5JeS9YfbQXTz9tQkISu
50n6vQ9lwLfs+mGDzoTNR9l95t5mOZ2dyjST/FXfGQfRMnYWv1HFL2i7xXzh6YE=
=WEWy
-----END PGP SIGNATURE-----

--oNLI4EWr1RPQuPCf--
