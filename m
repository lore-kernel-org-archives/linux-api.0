From: Sebastian Reichel <sre@kernel.org>
Subject: Re: [PATCH v8 00/14] power: bq24257: Add support for bq24250/bq24251
Date: Thu, 1 Oct 2015 04:58:47 +0200
Message-ID: <20151001025847.GA12283@earth>
References: <1443479642-23712-1-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443479642-23712-1-git-send-email-dannenberg@ti.com>
Sender: linux-pm-owner@vger.kernel.org
To: Andreas Dannenberg <dannenberg@ti.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Laurentiu Palcu <laurentiu.palcu@intel.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>, Ramakrishna Pallala <ramakrishna.pallala@intel.com>, linux-pm@vger.kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 28, 2015 at 05:33:48PM -0500, Andreas Dannenberg wrote:
> This patch series extends the driver to also support bq24250/bq24251.
>=20
> The bq24250/251/257 devices have a very similar feature set and are
> virtually identical from a control register point of view so it made
> sense to extend the existing driver rather than submitting a new driver.
> In addition to the new device support the driver is also extended to
> allow access to some device features previously hidden. Basic and
> potentially dangerous charger config parameters affecting the actual
> charging of the Li-Ion battery are only configurable through firmware
> rather than sysfs properties. However some newly introduced properties
> are exposed through sysfs properties as access to them may be desired
> from userspace. For example, it is now possible to manually configure
> the maximum current drawn from the input source to accommodate different
> chargers (0.5A, 1.5A, 2.0A and so on) based on system knowledge a
> userspace application may have rather than rely on the auto-detection
> mechanism that may not work in all possible scenarios.

Thanks, I queued all remaining patches except for

>   power: bq24257: Add platform data based initialization

I'm still not convinced, that it should be added without any
consumer in the mainline kernel.

-- Sebastian

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJWDKFiAAoJENju1/PIO/qa1OwQAKeoqrNeMzia0AD5gnT/3dKt
EvNnOS9E1DfxLx3j3etfO5fpoN2d6TaJsOCEXJNlhcd5gM2vMIO/N7lx2U33cGUr
rdaokmm4nR0PUwNv2S5vToBwcH2KGrNPk9uikUBalgtkeJSlWYeLbGzp05XSZt5d
PKdBYWdC5SUCJwj+K/kuX2ZDm+oURt5Zlku8WcgEZcAHexxxWYqlHMxOrXqW8GZT
JzbqCSrbQWOkLx885XNbiNU6OWwS7E0R5X/v6AtXiqgIm6q1v/y9TrRPPgz0l6O9
XuttDdK/sUCNt/yscu/Ci/zMmnHk7wiqjwov2vhANWlHILjZLH8QROV9c2WAWor8
sjeI9wteZFHUrPbvaitKuEeoQ4G7iIR3khxqlYq+h4NYy0dQm4oUZJ8cdaWbgtsU
IubVnUE48YQeBJ8O1sjzge6adowvVwnkRKLrREUIrTK3Cu1X2sZG5KNvAoKlBT3Z
/AhWpPIbTr0scEjnSleuK/pc5/Ukdw1It0VxuqJ0EDApFS5l5++fTE3vLucfOZik
sEtbIXQ15sQ4GOKM7Sp5A1mP4mMyQ83uKyLNHTLi2Y+UO4L9fKX7mrhyuICcTY8W
vgcvjR2BPBFjlyiTTzC8/BAiik5bGpelXrZGrMzp2EwHW/7cDsYQ1+Lky4U1z8x0
IL2omdObbxL3deNNgb7Z
=04yO
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
