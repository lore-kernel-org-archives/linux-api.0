From: Sebastian Reichel <sre@kernel.org>
Subject: Re: [PATCH v2 4/5] power: max77693: Add charger driver for Maxim
 77693
Date: Mon, 27 Oct 2014 19:56:57 +0100
Message-ID: <20141027185656.GB18965@earth.universe>
References: <1413808489-3524-1-git-send-email-k.kozlowski@samsung.com>
 <1413808489-3524-5-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="A6N2fC+uXW/VQSAv"
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1413808489-3524-5-git-send-email-k.kozlowski@samsung.com>
Sender: linux-pm-owner@vger.kernel.org
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>, linux-api@vger.kernel.org, devicetree@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
List-Id: linux-api@vger.kernel.org


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 20, 2014 at 02:34:48PM +0200, Krzysztof Kozlowski wrote:
> Add new driver for Maxim 77693 switch-mode charger (part of max77693
> MFD driver) providing power supply class information to userspace.
>=20
> The charger has +20V tolerant input. Current input can be set from 0 to
> 2.58 A. The charger can deliver up to 2.1 A to the battery or 3.5 A to
> the system (when supplying additional current from battery to system).
>=20
> The driver is configured through DTS (battery and system related
> settings) and sysfs entries (timers and top-off charging threshold).
>=20
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

I guess it makes sense to queue this together with the mfd parts.

Acked-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--A6N2fC+uXW/VQSAv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUTpV4AAoJENju1/PIO/qary4P/iWSe9y80CmfQzeVxEYgipwf
GFdNMLnSaWeL7lLeDFS823GL+3HWVzoweXmXmmXwgTKS/yTlOYnOllj3gmloyVoL
pMs7x9tT9lfUg58VyEjBbtuSmvoJevzpCMp7opdEaFdt8WicItcFJU3kvqEOliAs
ZjLBqzhpnDkWeUfDlVG8pSNFqJY39VSH6ctBoGoGFaaYXP/m6c/DvrlHPv8+bgXP
Jv5sChSjfOfEtMyA1lOVFLl6ihUgApLicwWyXWx/bRwnFPRK/rO7pVObOLZRFHj0
y8KrcB8QWWVmkI/a/IayRWN1jaRAXrkcbFcqKQhNWnB36cMeq7DEyGpOqeUnO5z/
rU8oPVKXfhHKlN3/HfTRx1+xPCq8eNGPzbMG/v5jOOeUYp3DF27Cxpl64Nx85MHz
sNpTWDpyp3kNk3Mymkm0Rnu5i1eQFnBaeD0ZLlgNBA7/LAlrzgUmMwf3XCilHRv1
KtVVUR9llOHjjN8MHgKdHApG+DSzEWpYjyPL2K1hBHSLAjjD+XDDeV7XDGAM90m0
Yqx2DGba505jw0aqv6ueOz/HktPTgn3rH+HRrKpeg5G7gJGq4o7YlQ5ON0+yX+Jq
3pL3qh+BGbVb7cAgexEM+iDfNv6vgAwv6E1fJWFULNohOMYXHXS+jRfZKMcRdAq/
mqJSGoYw4q8w4ibO/2wp
=t70r
-----END PGP SIGNATURE-----

--A6N2fC+uXW/VQSAv--
