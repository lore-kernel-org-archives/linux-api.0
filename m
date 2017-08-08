From: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v06 05/36] uapi linux/sysctl.h: use __kernel_size_t
 instead of size_t
Date: Wed, 9 Aug 2017 01:34:20 +0300
Message-ID: <20170808223420.GA10552@altlinux.org>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
 <20170806164428.2273-6-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170806164428.2273-6-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Matthew Whitehead <tedheadster-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Joel Scherpelz <jscherpelz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lorenzo Colitti <lorenzo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 06, 2017 at 06:43:56PM +0200, Mikko Rapeli wrote:
> Fixes userspace compilation error:
>=20
> error: unknown type name =E2=80=98size_t=E2=80=99
>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> Cc: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
> ---
>  include/uapi/linux/sysctl.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
> index e13d48058b8d..35a4b8b417fe 100644
> --- a/include/uapi/linux/sysctl.h
> +++ b/include/uapi/linux/sysctl.h
> @@ -35,9 +35,9 @@ struct __sysctl_args {
>  	int __user *name;
>  	int nlen;
>  	void __user *oldval;
> -	size_t __user *oldlenp;
> +	__kernel_size_t __user *oldlenp;
>  	void __user *newval;
> -	size_t newlen;
> +	__kernel_size_t newlen;
>  	unsigned long __unused[4];
>  };

You should be extremely careful when replacing size_t with __kernel_size_t
because e.g. on x32 you have sizeof(size_t) < sizeof(__kernel_size_t).

In case of sysctl.h this replacement would be wrong.

I submitted an alternative fix for this bug some time ago, see
http://lkml.kernel.org/r/20170222230652.GA14373-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org


--=20
ldv

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJZijxsAAoJEAVFT+BVnCUIMh8P/A7NpBMaFCjbVD6i+Bn+U32p
SunDv07EVG46eKjQFpAfUFpakL77mzCeC6dUbdPj1+eAL8Cb8hht/wFRgvegTBCJ
QCNn++UcKTw2I1o0X8Pycu+PVqp9O0q/IZ1X8nqy5HsSAWxLc+qGNYWv/QP8Iq1U
7SzFkZE3Qxt2oSZpaymNJCmjaCkHd+ea45HDYRoakiwBNbIXMxqzWco2jwDEa+gi
hnIfrbFZ/8sFaTT2Oae0HmUhg/BGMxbL92+Rh894lxqvn3hVwZBLjws8Hj8aSYCm
uowl2a/dyup+rYPbwwpbOGkB4WJYTk9v+8Ef9eA9cNvK8aO5bck1bozhbjHhTH7K
wSYVeRYvlTekS0fxX5aHM9DA+r7kHPVWkOqvHX2Qu9RFZw0e0zsiSGwgiX7tt+kc
f3hCM5prJ4K5llkTYBW3XUf6tTDO3BZK7/vbb5ApHY66QxSkuzIkQHw+lakpScjP
gxuFwMsgtZViAgOPnQVUUfFS5LQwoZKBd0xT3aCcax3K44PAHc/3bRI/zkn6S/4J
ANuHUXJVA5Iha2I0vPOGzv619EWtLpQ96llfJSmtuoaRt565mWBIPffVnSK9Eux7
npRZCnTXPbuHLoUEvXQ/Y4Hp7xnK341Pf4TisOCW6hWreUqwIU82PSS5ZRQEcGuf
Yh2KzaUHpNw1AlVO8Cjr
=QWFs
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
