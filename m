From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 07/24] arm64: ilp32: add documentation on the ILP32 ABI
 for ARM64
Date: Wed, 23 May 2018 16:06:20 +0200
Message-ID: <20180523140620.GA27215@amd>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
 <20180516081910.10067-8-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180516081910.10067-8-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <jame>
List-Id: linux-api@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2018-05-16 11:18:52, Yury Norov wrote:
> Based on Andrew Pinski's patch-series.
>=20
> Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>

So Andrew's signoff should be here?

> ---
>  Documentation/arm64/ilp32.txt | 45 +++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/arm64/ilp32.txt
>=20
> diff --git a/Documentation/arm64/ilp32.txt b/Documentation/arm64/ilp32.txt
> new file mode 100644
> index 000000000000..d0fd5109c4b2
> --- /dev/null
> +++ b/Documentation/arm64/ilp32.txt
> @@ -0,0 +1,45 @@
> +ILP32 AARCH64 SYSCALL ABI
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> +
> +This document describes the ILP32 syscall ABI and where it differs
> +from the generic compat linux syscall interface.

I was hoping to learn what ILP32 is / what is it good for, but no,
this does not tell me... it would be good to do a short explanation
here, and maybe reference it from cover letter of the series...
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlsFdVwACgkQMOfwapXb+vIqwQCfYjjsUAivfLJZGZGD+OxZQomb
x7kAoKfYf3WV9YCXwGsSlCM1C9pUE3kr
=dVu7
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
