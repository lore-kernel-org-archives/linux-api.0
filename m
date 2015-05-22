From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v5 02/11] regmap: Introduce regmap_get_reg_stride.
Date: Fri, 22 May 2015 12:19:05 +0100
Message-ID: <20150522111905.GD21391@sirena.org.uk>
References: <1432226535-8640-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1432226574-8733-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NklN7DEeGtkPCoo3"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432226574-8733-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, s.hauer@pengutronix.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org, pantelis.antoniou@konsulko.com, mporter@konsulko.com
List-Id: linux-api@vger.kernel.org


--NklN7DEeGtkPCoo3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 21, 2015 at 05:42:54PM +0100, Srinivas Kandagatla wrote:
> This patch introduces regmap_get_reg_stride() function which would
> be used by the infrastructures like nvmem framework built on top of
> regmap. Mostly this function would be used for sanity checks on inputs
> within such infrastructure.

Applied, thanks.

--NklN7DEeGtkPCoo3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVXxCoAAoJECTWi3JdVIfQB6gH/RC8RBhaiGRnyRS3h/KIzU3u
N/KdCCA3danrkP9eSK/CbEmW57ZA9T0wMEipa5VM601sHd46mtTpj+6EI+ZUFdXR
5+ICUGwHs+pWEewrBqCT+V4IdgUrZ+eDx94uW/RgdcZLSCyCYEhIaNcC8Wc9SDVi
ielsSbd0Y0CMt4wBd2+SvVlJT23imMIB7nvR/vBTc/yf9j1dNMwsAWFQ52tutjrB
4A3re3to6zSI3JJlWIcGxOjJ35w818/4SFwy2BXb83T8QIlG5Nf1IpZqBEEgj3QS
XZQH5IRpLDlqTsMlNDQmZoLlEjKh/MXP7y2BWBSQf0CnQ6eS96jC4xIAAIB7tdc=
=a6Fo
-----END PGP SIGNATURE-----

--NklN7DEeGtkPCoo3--
