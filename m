From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v5 01/11] regmap: Introduce regmap_get_max_register.
Date: Fri, 22 May 2015 12:18:08 +0100
Message-ID: <20150522111808.GC21391@sirena.org.uk>
References: <1432226535-8640-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1432226563-8689-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="OBd5C1Lgu00Gd/Tn"
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432226563-8689-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, s.hauer@pengutronix.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org, pantelis.antoniou@konsulko.com, mporter@konsulko.com
List-Id: linux-api@vger.kernel.org


--OBd5C1Lgu00Gd/Tn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 21, 2015 at 05:42:43PM +0100, Srinivas Kandagatla wrote:
> This patch introduces regmap_get_max_register() function which would be
> used by the infrastructures like nvmem framework built on top of
> regmap.

Applied, thanks.  If the rest of the framework is ready to get merged
somewhere before it reaches Linus' tree let me know and we can handle it
then.

--OBd5C1Lgu00Gd/Tn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVXxBvAAoJECTWi3JdVIfQRn0H/2wyd8X6RayGvMml6XyfHmL0
s64SMhFu5BPN8hE7b1tRWlLINLhYUMib2OleQy+sxwlsX7K2QftAEztEHY1w3wPm
sYZ319CA2h8Xmj4P2FXlrEuBYTy5LxfPbNjxj5ho3Ur6Ts5f+N7JUparboGicFtH
EuxpgJT+QcmPIxKLwokoyFt4lmi7ZohMRvDxNVW10j+K1EwBIIWZsa4t/K5NUoux
gv1LL+AU7uthYo2pARABmKTgBlSnHVaC2xW4RaWipDPRmJg0V7FpPZ0y2Y58ZCpk
vvJAvbQKHatzikOYn5GCFK+xA9mGaKfu/HrOXTAzjYjm308ny54+aw+tdzONjJ4=
=XDR0
-----END PGP SIGNATURE-----

--OBd5C1Lgu00Gd/Tn--
