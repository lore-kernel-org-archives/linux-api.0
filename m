From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH v06 14/36] arm uapi asm/signal.h: include <stddef.h> for
 size_t in userspace
Date: Wed, 9 Aug 2017 01:57:39 +0300
Message-ID: <20170808225739.GF10552@altlinux.org>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
 <20170806164428.2273-15-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4f28nU6agdXSinmL"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170806164428.2273-15-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org


--4f28nU6agdXSinmL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 06, 2017 at 06:44:05PM +0200, Mikko Rapeli wrote:
> Arnd Bergmann <arnd@arndb.de> doubts that __kernel_size_t could be used h=
ere
> so trying to fall back to gcc's <stddef.h>.

The only architecture where you cannot do this safely is x86 family
because of x32 exception.  If there is no chance that the change will
affect x32, feel free to replace size_t with __kernel_size_t like I did
some time ago, see
http://lkml.kernel.org/r/20170302002022.GB27097@altlinux.org


--=20
ldv

--4f28nU6agdXSinmL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJZikHjAAoJEAVFT+BVnCUIEQ8QANf+GntVd3KbUiLN31RcmNvW
UQcLEnuW7qZJjJUZS8cOoFHN8i/1jILvI0bvp3uaoubyjqaTm2WePOrHzlbtMA7w
xD3COefFlFhcIu5EKHzeau8vUuPMQC2WLDfk74A5g4tG2wK1Ibtv5uFDOQP7yfFi
xc5t8cjyw4K7tujx05gOHUxvLxTvMSVLZs+6xso8ujUm+yLIRYizwBNjXvGjcgsH
a/ocfn5D3AdZsCkL5jtaXYCOccznzIDMEB70Vv0HKc/R0Yo3QRRNJQIoAJdlFHrK
0CbbZdJp9Gkv5MXu5h+XX5fd9el9lRSv0yA2jqKhi2jGKTCglvi6SEV8VyCUKSqS
a9SjtGLnzJwgcyrGBoOTM4vKy2fW1OdO/axwMAqfV9RllEerPLH5nuWlIs9Nkg8M
uuEhtvQ7ruF5gMWwel0JrAaz6OqLWjArqSq6pEwWz8PDxr9Ev9+KsTTWIKG1yDY6
6VdATPNlmyW9tpscv9KFLpXwsBD1zYDdzYcwZtLaLqw+pOfSf7FWfad179bSbAYZ
RfPDunHZ6lJKr8UpObaA5Vzah1rqQEg5JImDpKrYZMvHDr8yOEgdEUd/e5OlGo6t
G1yY96j3xGOsxAhVhX9LqKFeB4oGjrLRzZCjszrCBBcbMl1rODKiZ+tFBLm8GkgJ
wV0/MGpLRAQ6CGck9a2p
=Eebs
-----END PGP SIGNATURE-----

--4f28nU6agdXSinmL--
