From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH v06 08/36] uapi asm-generic/shmbuf.h: include fixes
Date: Wed, 9 Aug 2017 01:42:53 +0300
Message-ID: <20170808224253.GB10552@altlinux.org>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
 <20170806164428.2273-9-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="uZ3hkaAS1mZxFaxD"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170806164428.2273-9-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "H . J . Lu" <hjl.tools@gmail.com>, "H . Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 06, 2017 at 06:43:59PM +0200, Mikko Rapeli wrote:
> Include linux/types.h and asm/msgbuf.h and use __kernel_size_t instead
> of size_t.
>=20
> Fixes userspace compilation errors like:
>=20
> error: field =E2=80=98shm_perm=E2=80=99 has incomplete type
> struct ipc64_perm shm_perm; /* operation perms */
> error: unknown type name =E2=80=98size_t=E2=80=99
> error: unknown type name =E2=80=98__kernel_time_t=E2=80=99
>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Cc: H.J. Lu <hjl.tools@gmail.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  include/uapi/asm-generic/shmbuf.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/uapi/asm-generic/shmbuf.h b/include/uapi/asm-generic=
/shmbuf.h
> index 7e9fb2f0853b..ae867ad1e5e4 100644
> --- a/include/uapi/asm-generic/shmbuf.h
> +++ b/include/uapi/asm-generic/shmbuf.h
> @@ -1,7 +1,9 @@
>  #ifndef __ASM_GENERIC_SHMBUF_H
>  #define __ASM_GENERIC_SHMBUF_H
> =20
> +#include <linux/types.h>
>  #include <asm/bitsperlong.h>
> +#include <asm/msgbuf.h>
> =20
>  /*
>   * The shmid64_ds structure for x86 architecture.
> @@ -24,7 +26,7 @@
> =20
>  struct shmid64_ds {
>  	struct ipc64_perm	shm_perm;	/* operation perms */
> -	size_t			shm_segsz;	/* size of segment (bytes) */
> +	__kernel_size_t		shm_segsz;	/* size of segment (bytes) */
>  	__kernel_time_t		shm_atime;	/* last attach time */
>  #if __BITS_PER_LONG !=3D 64
>  	unsigned long		__unused1;

Surprisingly enough, this replacement of size_t with __kernel_size_t
is not just correct, it's a fix for a more subtle bug on x32, see
http://lkml.kernel.org/r/20170302004607.GE27132@altlinux.org

I recommend splitting the change into "include" fix and "size_t" fix
like I did some time ago, see
http://lkml.kernel.org/r/20170302002253.GC27132@altlinux.org


--=20
ldv

--uZ3hkaAS1mZxFaxD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJZij5tAAoJEAVFT+BVnCUIweMQAKZrlENzLYUCtXydISn5o2Ee
stLaTJi4J+Lylb2x1QiBhg5UIdpHzpObYM9f2OltD03w/BmpVQPdeMxHjzylGQYB
1ZkeWhm532LcxYQe8hM328nAB5k7CHlK3NcIp4+UPpdgnBXelc1YU/VJMvuwGM+U
ERAoUtVh5hUOlvv+OQpU1utwZQPJwHWl62j9hwhbn40dFv4nWsSl6VVhtgksaXvR
FjrQC/qIOEiP9441VXLIlJ/jOW2glELD72XG1+eT4h7Cn39wy/GCY+74JKq8iO6E
fyxrbMTE0tbpOmQe6Qkq7iQmIzQS5oubD8/tq8rMkqcWSjPEZ1Xp1uhURP0EREK8
MoOAqGXONdayyE3XSbvfYyK8aMtgHrQv82RmLpA4HX3GS+pblenHoG9rkvzt/8Re
vh4XT9K+FHnmjbtlwbUDCimQ6v3LqUkC4AhT3XPz1SbofvH19pxqubTItRqTfqlD
80TugJSR+aSF0f13zacVw74mDH0V54bColkfYoPUDB20L/uj6PNDJhRHgEe852eu
zDAc3xY0aVndwy6kDJRKnwXL3lwGsFLbn5ahgIPhTpe3S4ImiKB7XfBuW/mGCvMQ
t2OQVlDGiam4StcZL2gJZomvJrYxdAUYhkObIl+1f0NO8U9YzFDqKUaIdje2X8vy
Qm64i9YgcJT0ZuWU89LH
=+vYo
-----END PGP SIGNATURE-----

--uZ3hkaAS1mZxFaxD--
