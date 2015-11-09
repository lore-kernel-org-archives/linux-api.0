From: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] selftests/mlock2: Add missing #define _GNU_SOURCE
Date: Mon, 9 Nov 2015 10:50:13 -0500
Message-ID: <20151109155013.GB28486@akamai.com>
References: <1447064069-21469-1-git-send-email-geert@linux-m68k.org>
 <1447064069-21469-2-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447064069-21469-2-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 09 Nov 2015, Geert Uytterhoeven wrote:

> On glibc 2.3.6:
>=20
>     mlock2-tests.c: In function 'seek_to_smaps_entry':
>     mlock2-tests.c:158: warning: implicit declaration of function 'getlin=
e'
>=20
> According to the manpage of getline(), it needs _GNU_SOURCE before glibc
> 2.10.
>=20
> Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>

Acked-by: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>

> ---
>  tools/testing/selftests/vm/mlock2-tests.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/tools/testing/selftests/vm/mlock2-tests.c b/tools/testing/se=
lftests/vm/mlock2-tests.c
> index 4431994aade2ef6f..cb247219f1f72889 100644
> --- a/tools/testing/selftests/vm/mlock2-tests.c
> +++ b/tools/testing/selftests/vm/mlock2-tests.c
> @@ -1,3 +1,4 @@
> +#define _GNU_SOURCE
>  #include <sys/mman.h>
>  #include <stdint.h>
>  #include <stdio.h>
> --=20
> 1.9.1
>=20

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWQMC1AAoJELbVsDOpoOa9uXkP/3uW+yjR5261IFUO67qvtzp+
BaO41gzVnUXhMt/qOsVoF/NtgUJPGnd/4THRwlIXX+PzcYeGEgIOS5W96sQeUwdJ
B/VTaz2LyCxQd2AWOEPWMppj41fJaeBdMqFd6Qs2P+6o0JeJ4g9wsGuR5qJ7iWVD
Woqjh5pVLxscuLEQHD7UaJlWY+n5O4ENh4YMNcOZcSNqDWQhFtIxNynRrUjyeqhs
rxPR16clAt4UjlqGVspW3cdKbZHV5d+YcrkfGljfCxJt4OkuUfT8Mb6VQ4B7K1wP
f3y8sgtIGys6bFtCIoVeQOKCDbbdILEVMRbedq2cRIM9IESOcp/CMNVjDmtszrxQ
nHeta9Oy2Wk0NX/8UNxDRPSDuUcuHHVldA4sm6TYyxAiSNQftCDimAKOGBhF66OM
E9NtGcVVwWuO8MIHpnsujH0YUjY+R7KpVFBfzvWi0+ylykxxdLbAVxY6lGuu+vUO
j5p7j5YutBcFiL/J5WAAIhK8r7hpxwi0lnCDCXIiycqZ7J61JMEVDWg5TKBxUvV2
2eKEeawXCwT4CxQ5iRH7hrBwtqrZpysUbREODom1AYAk1Ixx5/5XwtNBQqvTd6CP
IYZINMffw8ZS9+tNfg5x22FzE1ZAEGqbZ5fgyHAZ7YllSCUenijHa5OBGoiU7qrp
szr0snjEEv3ehdopPWTf
=Kaqv
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
