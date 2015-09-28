From: Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 00/15] power: bq24257: Add support for bq24250/bq24251
Date: Mon, 28 Sep 2015 20:19:01 +0200
Message-ID: <20150928181900.GI3660@earth>
References: <1443196460-26156-1-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0NB0lE7sNnW8+0qW"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443196460-26156-1-git-send-email-dannenberg-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dannenberg <dannenberg-l0cyMroinI0@public.gmane.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Laurentiu Palcu <laurentiu.palcu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Krzysztof Kozlowski <k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Ramakrishna Pallala <ramakrishna.pallala-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--0NB0lE7sNnW8+0qW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 25, 2015 at 10:54:05AM -0500, Andreas Dannenberg wrote:
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
>=20
> Note that most patches have dependencies on other patches in the series.

I reviewed all patches, those without comments look fine to me. I
did not queue them because of the mentioned dependencies on previous
patches, which got comments from me.

-- Sebastian

--0NB0lE7sNnW8+0qW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJWCYSUAAoJENju1/PIO/qaFr8QAIYBwZWy8k7crKyzO0pkCp1W
WONYDAId8qJX563M3f/UJE8Kf91tfTLI6iKkA8A7anlQQojIlilr670oedXdEN71
I/GKVZMnig9bgWGrq2boeH/0Sg6CA2W9Df5REaGGFLN93UkFgCxBQkgvvy2HgKnO
l162pvXtfvaOIgBXAna0WYqsuJMeCe6EQnQyJOmZJgn+cSv7r9rLAUogF7mdwbMD
5/l5cqossuckl/VjJei3SqAB2igjModu4bLB/1xFNwDaSNKyeulNpMa5HgPehaZh
b8Sz7hseTALPEZ59EMwlfS7AaZW+D47YftHuMgFpzO9iJxaP5H/vqTBR6hgrvfnC
O7x6n7ApElL2/IHdQGIrw14YKz8nTMusBX0DPxo68gUACXXAU0c505OFYQOkjnf2
R/iJ+LhUZIlq9I99+Tijw60RlbXsDJ1VuuxWSSNAnQxpqiSlSAat61BMLSJFfdiQ
ZCPpuOhy4Ub8ZQsNA1W/rHd8CT3/ibmmw1jbCP+0yfSXw6COX5QuJxIO5HxTrlsg
YbLlZVqOEzk7xmfL1C39u7040uqAuh87JrEAG0aLJwvjUVMfbvyUoOqndM/RRbCG
JTRfn/GBvbN84tSvgdICO981o+bSGymnV/ajqRfxGGuKUmazWfg9c5OGFuypR6ZG
J9ItvQfRSsac+ByRCDXp
=BOxz
-----END PGP SIGNATURE-----

--0NB0lE7sNnW8+0qW--
