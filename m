From: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] selftests/mlock2: Add ULL prefix to 64-bit constants
Date: Mon, 9 Nov 2015 10:50:41 -0500
Message-ID: <20151109155041.GC28486@akamai.com>
References: <1447064069-21469-1-git-send-email-geert@linux-m68k.org>
 <1447064069-21469-3-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447064069-21469-3-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 09 Nov 2015, Geert Uytterhoeven wrote:

> On 32-bit (e.g. m68k):
>=20
> mlock2-tests.c: In function 'lock_check':
> mlock2-tests.c:293: warning: integer constant is too large for 'long' type
> mlock2-tests.c:294: warning: integer constant is too large for 'long' type
> mlock2-tests.c:299: warning: integer constant is too large for 'long' type
> mlock2-tests.c:300: warning: integer constant is too large for 'long' type
> mlock2-tests.c: In function 'unlock_lock_check':
> mlock2-tests.c:329: warning: integer constant is too large for 'long' type
> mlock2-tests.c:330: warning: integer constant is too large for 'long' type
> mlock2-tests.c: In function 'onfault_check':
> mlock2-tests.c:398: warning: integer constant is too large for 'long' type
> mlock2-tests.c:398: warning: integer constant is too large for 'long' type
> mlock2-tests.c:408: warning: integer constant is too large for 'long' type
> mlock2-tests.c:411: warning: integer constant is too large for 'long' type
> mlock2-tests.c:416: warning: integer constant is too large for 'long' type
> mlock2-tests.c: In function 'unlock_onfault_check':
> mlock2-tests.c:443: warning: integer constant is too large for 'long' type
> mlock2-tests.c: In function 'test_lock_onfault_of_present':
> mlock2-tests.c:528: warning: integer constant is too large for 'long' type
> mlock2-tests.c:529: warning: integer constant is too large for 'long' type
>=20
> Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>

Acked-by: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>

> ---
>  tools/testing/selftests/vm/mlock2-tests.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/tools/testing/selftests/vm/mlock2-tests.c b/tools/testing/se=
lftests/vm/mlock2-tests.c
> index cb247219f1f72889..02ca5e0177c539c7 100644
> --- a/tools/testing/selftests/vm/mlock2-tests.c
> +++ b/tools/testing/selftests/vm/mlock2-tests.c
> @@ -277,8 +277,8 @@ out:
>  	return ret;
>  }
> =20
> -#define PRESENT_BIT     0x8000000000000000
> -#define PFN_MASK        0x007FFFFFFFFFFFFF
> +#define PRESENT_BIT     0x8000000000000000ULL
> +#define PFN_MASK        0x007FFFFFFFFFFFFFULL
>  #define UNEVICTABLE_BIT (1UL << 18)
> =20
>  static int lock_check(char *map)
> --=20
> 1.9.1
>=20

--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWQMDRAAoJELbVsDOpoOa9cl0QAMwq5WW3KIHFaaEEI2bQRrOg
H1r4rJlTGGlvgyK8+qdhEuh2LoQruwz6BNyDtnaEZ9KoRocBCGc9WYhBNL4t5y3K
QCHQLP5XSvFTSbXxOMx7RRYytDyFCt2aEbMHlp+iSuV9W/CjT1TiGp5M0Ek0Xua7
pFC8Az9k4PEYpRT3qIQIQVDL1RV4+1rRyGZq0guSqAVvJ16WUj83Jyki1Hd6t7w4
2WDPJoAJNBZ2trPy9AUIXLs9mX7L8AVuAkw6lSwfcEssAsH6pdqvAtXLglJcVgOD
bno2U9EdBOSB7JvAw0JC69sQQva+/0N6ds+NHhmjsS7IR5Zp6jWWm8ob8WwGbn6T
AgxBc61p+NRqqtaDt6IlMSBUXqNGIeY3YYnJSOoo7qGJyYFjMpk1jeRTBVp2PCUT
EOJuBASsaejMI8/Shj9yVRbDDqSrIDIgc7eXu1GZ98x8QRB0tcswSSOTpLmSgmsW
eXMHOrAAMbruMvF9BHwl9IGERgRNSTIo9gbPLB8qs/MQBPHo0pzLXQW+0GyxYbY2
S+IpvApCgwZtTVgqp8MbKm0gX+KgNaiNzeCco0AdiAVd/Dwo1dcrAjAIME4l1fJn
R0Hr4ptY6ZVTqROfRB3h8IGq6N9/yyQ9kcuGJqhU8OwbPXWcFnaRXRHpoeIeM3Qs
uxZKlp7mm5x9nvEWy2+7
=Zjbn
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--
