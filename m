From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 04/10] eeprom: Add a simple EEPROM framework for
 eeprom consumers
Date: Wed, 6 May 2015 18:28:46 +0100
Message-ID: <20150506172846.GC22845@sirena.org.uk>
References: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1427752670-17219-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="QRZRoILo0Pq4YpTd"
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427752670-17219-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, s.hauer@pengutronix.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org
List-Id: linux-api@vger.kernel.org


--QRZRoILo0Pq4YpTd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 30, 2015 at 10:57:50PM +0100, Srinivas Kandagatla wrote:

> +
> +	for (i = 0; i < cell->nblocks; i++) {
> +		rc = regmap_raw_read(eeprom->regmap, cell->blocks[i].offset,
> +				      buf + offset, cell->blocks[i].count);

I *think* this is probably OK but please double check that the count
here is in bytes rather than words, it's a bit confusing since I'd read
a count as being in words.  Otherwise I think the regmap usage here all
looks good.

--QRZRoILo0Pq4YpTd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVSk9OAAoJECTWi3JdVIfQuNkH/RnXfz7KyQ5kGvUyl3+gaXeJ
XwnfC+bEF1j2tRN6FTe/0w39Ll50q55jrTHgWHbTa3y0P1eKg7HXznlya/dHXy6S
dgDjePF1thLsAWER3qeyW/jWNATd/sf0ZQzJuISX94KbLklkgxSVfkSDh1JdlPwl
XPzFQzfm5qccmdc+LRu0sElChMPY11c+PXSNe1qHl+hoZVb5aKAiLzJj0TQl43xk
AKJwA04mcEbj0xDKOXS6Dl4SRqMJiZrmEK9cYtwdLRW4A+r1yGwIwPxSHk8Mssxl
vQ/mqBcpx56HKXeio46C/uJVgIX7toJlxmbSmQUT2B4YO5zm70Kbb8RgxEHxKZI=
=wNz3
-----END PGP SIGNATURE-----

--QRZRoILo0Pq4YpTd--
