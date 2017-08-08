From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH v06 09/36] uapi asm-generic/sembuf.h: include
 asm/posix_types.h and asm/ipcbuf.h
Date: Wed, 9 Aug 2017 01:45:55 +0300
Message-ID: <20170808224555.GC10552@altlinux.org>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
 <20170806164428.2273-10-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GZVR6ND4mMseVXL/"
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170806164428.2273-10-mikko.rapeli@iki.fi>
Sender: linux-arch-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "H . J . Lu" <hjl.tools@gmail.com>, "H . Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--GZVR6ND4mMseVXL/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 06, 2017 at 06:44:00PM +0200, Mikko Rapeli wrote:
> Fixes userspace compilation errors like:
>=20
> error: field =E2=80=98msg_perm=E2=80=99 has incomplete type
> struct ipc64_perm msg_perm;
> error: unknown type name =E2=80=98__kernel_ulong_t=E2=80=99
>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Cc: H.J. Lu <hjl.tools@gmail.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  include/uapi/asm-generic/sembuf.h | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/include/uapi/asm-generic/sembuf.h b/include/uapi/asm-generic=
/sembuf.h
> index 4cb2c13e5090..17d523f86923 100644
> --- a/include/uapi/asm-generic/sembuf.h
> +++ b/include/uapi/asm-generic/sembuf.h
> @@ -2,6 +2,8 @@
>  #define __ASM_GENERIC_SEMBUF_H
> =20
>  #include <asm/bitsperlong.h>
> +#include <asm/posix_types.h>
> +#include <asm/ipcbuf.h>

I don't think you need to include <asm/posix_types.h> here,
<asm/ipcbuf.h> is necessary and enough, see
http://lkml.kernel.org/r/20170302002228.GB27132@altlinux.org


--=20
ldv

--GZVR6ND4mMseVXL/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJZij8jAAoJEAVFT+BVnCUIFFAP/278VCfuECcLy8sZp3l/nkWo
xrON1Bh2ohV4tP5Xnkejuh8u+LyZ+wvnkl/dsem4bkMQIJ0hiLlel2i4bJnX6/NC
dVG2kFYWP21ZD5kmzdjXdTaF+01ZypokTqmSMWGFDwSvXrX+vLVpMa06QaQOQ8B0
MV3FIcpF4MVbQnxwSyeUa+8oKwexv368JvCSI2/gDmGlvcD4liY1p01eE+bpqPKG
PFEf7tMnhu03zJdCkhWjUodqd36QA59wfSNsupJYdjEfep/hX1NECibVShn915Eb
7CmPKXY0U6V//gI5hgUe5IeedQY62jCIYON6d65UhzUj4KvOglSP+msWX2igsfBO
eU661qqKrCF3lf3aTp2we7FZ0x96vR+HWPN11P5oYjiDj8rotFlQZaC3lzzVI28C
N7icQwDOEvbYrQOIqo4n9N2bHl1ybzJmwz0Z5GlfoMUgQdPdQe+w1GpKWZ4eSgg8
paR/9M14YMmzeZB4NacElnAoP4v5UMA6pqpmbzhSbHuLqiH+GsFL9LpxcT9ws1gQ
OaZO9zY/KyolGn2SnDIALL2UwYrMsCwY2CcX6oZdcv4ZzqFCnC3QgaKbltiqA6d1
e1CaUcvU+b4bO29FDfrSDL7kcteiHp2jqbeGi+FqLm0hIixfFNrEI2upcPhbcc8f
aUImpsGQDLb6A25E2xzH
=Kx1o
-----END PGP SIGNATURE-----

--GZVR6ND4mMseVXL/--
