From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 1/7] eeprom: Add a simple EEPROM framework for eeprom
 providers
Date: Tue, 24 Mar 2015 13:55:41 -0700
Message-ID: <20150324205541.GC17265@sirena.org.uk>
References: <1426240157-2383-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1426240214-2434-1-git-send-email-srinivas.kandagatla@linaro.org>
 <20150323210918.GS14954@sirena.org.uk>
 <55108E2B.7050305@linaro.org>
 <55112BD6.2070600@linaro.org>
 <20150324172346.GW17265@sirena.org.uk>
 <5511AE38.3000108@linaro.org>
 <20150324190226.GB17265@sirena.org.uk>
 <5511BA75.3020305@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mjeOt6n4R71vn6wN"
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5511BA75.3020305@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Kumar Gala <galak@codeaurora.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-arm-msm@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--mjeOt6n4R71vn6wN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 24, 2015 at 07:26:45PM +0000, Srinivas Kandagatla wrote:
> On 24/03/15 19:02, Mark Brown wrote:
> >On Tue, Mar 24, 2015 at 06:34:32PM +0000, Srinivas Kandagatla wrote:
> >>>On 24/03/15 17:23, Mark Brown wrote:

> >>>>> >>regmap_get_size(regmap)

> >>>> >This is already there.

> >>>Sorry, I can't see any such api atleast in v4.0-rc5 and linux-next? Are you
> >>>referring to another api which does the same job?

> >regmap_get_val_bytes()

> This would return value bytes, but I wanted is the regmap->max_register
> value which would be used for sanity checks in eeprom-core.

Then you *really* want to pick a better name then, I'd never have
inferred that meaning from "size" (consider sparse register maps for
example).  Like I said, send patches (preferrably showing the users as
well).

--mjeOt6n4R71vn6wN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVEc9FAAoJECTWi3JdVIfQMvgH/0FxHeCACWt0iw0MmGE4zaTx
sZA0bIAUEhDlOxU8EvjuWLLG0eB4rioQPFf0bBrWoRbLvQqSrKK3S7TCt9mQrSUv
+2sFs3Wk6C0n2m+PPSmaeR0264fJ02GnRGV7PtII2VOFBxhknGLP2Fa0ZucqNhXV
OePO4v9Qsqfmakp5gx65w7ZyUeRYzBw4sOJATwRqBAYxAwMHea8GieB9EF5NHe2u
atjeHjwpuFXlt8T7ewZRW6Q3Nlwi6ChtsESBMu2N6YCvMqJjxsU/cujW1dWm53JN
pZdvKlwQk1Z2783oqh1sv0G4XqeNZd1LM6fwt3eCpy/DuOdR7/WgBmTHe3r9zxg=
=LY5g
-----END PGP SIGNATURE-----

--mjeOt6n4R71vn6wN--
