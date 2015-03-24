From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 2/9] regmap: Introduce regmap_get_reg_stride.
Date: Tue, 24 Mar 2015 15:37:45 -0700
Message-ID: <20150324223745.GC28997@sirena.org.uk>
References: <1427236116-18531-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1427236200-18625-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="bKyqfOwhbdpXa4YI"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427236200-18625-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org
List-Id: linux-api@vger.kernel.org


--bKyqfOwhbdpXa4YI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 24, 2015 at 10:30:00PM +0000, Srinivas Kandagatla wrote:

> + /* regmap_get_reg_stride(): Report the register address stride
> + *
> + * Report the register address stride, mainly intended to for use by
> + * generic infrastructure built on top of regmap.
> + */
> +int regmap_get_reg_stride(struct regmap *map)

Please fix the indentation for the comment block and add kerneldoc for
the argument.  This is an exported function so it should also be /** not
/*

--bKyqfOwhbdpXa4YI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVEec4AAoJECTWi3JdVIfQk2EH+gMp/An+PZhn3+0bIfG4npmq
kr5ej2DYhy5APaTbjTNDXiEDUaMV3q/jmcPTDsxzue/MVoL6JHpirEiKZikhRhIx
4ZgicUk3WQxiSpLBX/WfyNlOwDq1Am4Rpa6F/cRo6p3Jl5S3MesH4C5FkAGze4A9
W8UZjmNm+K3vSAdbWlludBo41j2edWG3Owd6MdvLk9dG4N0e9K2mhZFp/3w2aOzF
1VR6q78aAJTfk4+AU5ap7P0busIyuwY1mnsa6Vwwu1dB2mL8cpACZPrYaKREwTPk
QdBLFq0OQCbWJgpDIMPQnB4X2JXCt7cD/Cyt7Y2L5ot0mcgrquY2DwnVZezCst4=
=/6Tr
-----END PGP SIGNATURE-----

--bKyqfOwhbdpXa4YI--
