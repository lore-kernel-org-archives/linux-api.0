From: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v06 13/36] x86 uapi asm/sembuf.h: include linux/types.h
 and linux/ipc.h
Date: Wed, 9 Aug 2017 01:54:17 +0300
Message-ID: <20170808225417.GE10552@altlinux.org>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
 <20170806164428.2273-14-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UnaWdueM1EBWVRzC"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170806164428.2273-14-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org


--UnaWdueM1EBWVRzC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 06, 2017 at 06:44:04PM +0200, Mikko Rapeli wrote:
> Fixes userspace compile errors like:
>=20
> error: field =E2=80=98sem_perm=E2=80=99 has incomplete type
>   struct ipc64_perm sem_perm; /* permissions .. see ipc.h */
> error: unknown type name =E2=80=98__kernel_time_t=E2=80=99
>   __kernel_time_t sem_otime; /* last semop time */
>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/include/uapi/asm/sembuf.h | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/arch/x86/include/uapi/asm/sembuf.h b/arch/x86/include/uapi/a=
sm/sembuf.h
> index cc2d6a3aeae7..f11ed5282eec 100644
> --- a/arch/x86/include/uapi/asm/sembuf.h
> +++ b/arch/x86/include/uapi/asm/sembuf.h
> @@ -1,6 +1,9 @@
>  #ifndef _ASM_X86_SEMBUF_H
>  #define _ASM_X86_SEMBUF_H
> =20
> +#include <linux/types.h>
> +#include <linux/ipc.h>

I'd recommend to include <asm/ipcbuf.h> instead like I did some time ago,
see http://lkml.kernel.org/r/20170302002228.GB27132-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org


--=20
ldv

--UnaWdueM1EBWVRzC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIbBAEBCAAGBQJZikEZAAoJEAVFT+BVnCUIY2AP92WWRzsITOt2ZOx1qVwANAE1
xGZ7vJjYGxT+pyF5fsze2IXGDYL+VzlGn5PgnkAZIu1/Ux83OF8N4uqEvhck6oPD
1Tovnn1JBtkSAyw4tfxw6k4dhEXM7bYBv7fo7V96gKdOGFpR/SDLshHbrdS5xYHW
rZJ05IEt3v8jPvVFcfSiDRDPVgOlYgGzV8Bcym5WA/i1RrNrfqK7Ssz+qhbBtKfX
OrLhHQkF2EeUr4HYudeTwuwzC4Jgt87ho5oiJjtC/ejFulEb8zXSPs0MuQUcaoxa
0DwfjRwLo02qFCvF3zXXa86F0uEPeTdtMskFbSbt1cn89q8WNpBAeZmdX/+563CB
Z4KDo0xO/66a96amECdxT1tTdMl+YYfVNyEiLjVXpOVXq2pyKdhusXKmECLk4I3o
4XpIpc4T+1JK81TULghiwYeMOzfKHgFGX87jXpYnRmci6rxhom4x+HcZyF0uD+ku
mbw54aYma7vmm3AAqYIqZN+3NS+FVLWoGlMjAQvAQ3bLWtK3dkcF2gHNKR71QPvw
bT7NEDZvNOzvKVHn0BbmxQEqt0IGBAbnZtT9QnuUMGvRUiS59apJgc31KRcBLYPt
0Y167mLs2OHhx3HmjCqBApa0Ay34jl4oDE1tGbivnXO3Yx1RK2NLkeFlt/XVxnLX
p6Va2Na8L5Zh31O1Jss=
=DUo8
-----END PGP SIGNATURE-----

--UnaWdueM1EBWVRzC--
