From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH v06 12/36] x86 uapi asm/signal.h: use __kernel_size_t
 instead of size_t
Date: Wed, 9 Aug 2017 01:50:26 +0300
Message-ID: <20170808225026.GD10552@altlinux.org>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
 <20170806164428.2273-13-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="F8dlzb82+Fcn6AgP"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170806164428.2273-13-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org
List-Id: linux-api@vger.kernel.org


--F8dlzb82+Fcn6AgP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 06, 2017 at 06:44:03PM +0200, Mikko Rapeli wrote:
> Fixes userspace compilation error:
>=20
> error: unknown type name =E2=80=98size_t=E2=80=99
>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/x86/include/uapi/asm/signal.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/include/uapi/asm/signal.h b/arch/x86/include/uapi/a=
sm/signal.h
> index 8264f47cf53e..74346db30758 100644
> --- a/arch/x86/include/uapi/asm/signal.h
> +++ b/arch/x86/include/uapi/asm/signal.h
> @@ -127,7 +127,7 @@ struct sigaction {
>  typedef struct sigaltstack {
>  	void __user *ss_sp;
>  	int ss_flags;
> -	size_t ss_size;
> +	__kernel_size_t ss_size;
>  } stack_t;
> =20
>  #endif /* __ASSEMBLY__ */

This is definitely wrong because sizeof(size_t) < sizeof(__kernel_size_t) o=
n x32.
I submitted a different fix some time ago, see
http://lkml.kernel.org/r/20170303005930.GA10283@altlinux.org
and
http://lkml.kernel.org/r/20170303005950.GB10283@altlinux.org


--=20
ldv

--F8dlzb82+Fcn6AgP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJZikAyAAoJEAVFT+BVnCUIX9YP/1XT6GZhD/GOe+6/GkdMh3Wf
e9xan3FLtkJlMfktV97P4BTwGcE+M0WgUbxwcziEWJnX9qMepkQ73PkH4ChiEyEs
Xvdas5uShOSYCKb3cg0nQLF0z7aVXEVzK7/jFM/xbCMQjyXIBf463vDsxNIY02Bc
IkEvYZwgJge3sturfKnjgXwRStwrpl6+/MljfvxrHjwAPGkDAjnQZzf54TtMzwmp
8Dqsu5W7MkZ2VHV1LzYo2mzjC7dXm74HaUUYHL6DmBLqMJ37BDt+fvqbdmNq3xtz
pP6iPe3m6ZPV/37xNwa+cVShIqq5Nlkby8awCYojCZyzjcSrRoLO39fXHlB92qQG
LQ6hME7nc0tvc7aTiAFs6FZjRQ5v5xyL2o6cLQCC0i8daLg1JvdYUKP+2oYXlewi
yvruwgcmKVbEP9ToaUMxpfAFfm3nY3LOsmroAHvHLAVgx73WkYoGbvtXoemiYUgi
txKVICxBa+kLat3U/dleXkl0wSXgUix7mM64U4SdYHI9L4/90/2BZkN+fjfyF32m
9rknnzOS8N73Va+y/YhD9dZzmPRN1DbjA1zmJL9LPiOhBF+P308r7s/A4MTNWXXH
ow/nVyRnrqCeAXIM67wqfR8u2T0WgEC2vHqWyIRS7hbQ7sDKDvmlqB6c4+vUe7II
ZEY+wKWd5j0tZFqGi4b2
=0chd
-----END PGP SIGNATURE-----

--F8dlzb82+Fcn6AgP--
