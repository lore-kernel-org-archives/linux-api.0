From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v2 1/4] lib: introduce copy_struct_from_user() helper
Date: Fri, 27 Sep 2019 11:07:36 +1000
Message-ID: <20190927010736.gy3vvvkjhwlybosj@yavin.dot.cyphar.com>
References: <20190925230332.18690-1-cyphar@cyphar.com>
 <20190925230332.18690-2-cyphar@cyphar.com>
 <20190925232139.45sbhj34fj7yvxer@wittgenstein>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ningxfpyii3awxw6"
Return-path: <libc-alpha-return-105436-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20190925232139.45sbhj34fj7yvxer@wittgenstein>
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Christian Brauner <christian@brauner.io>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--ningxfpyii3awxw6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-09-26, Christian Brauner <christian.brauner@ubuntu.com> wrote:
> On Thu, Sep 26, 2019 at 01:03:29AM +0200, Aleksa Sarai wrote:
> > +int is_zeroed_user(const void __user *from, size_t size)
> > +{
> > +	unsigned long val;
> > +	uintptr_t align =3D (uintptr_t) from % sizeof(unsigned long);
> > +
> > +	if (unlikely(!size))
> > +		return true;
>=20
> You're returning "true" and another implicit boolean with (val =3D=3D 0)
> down below but -EFAULT in other places. But that function is int
> is_zeroed_user() Would probably be good if you either switch to bool
> is_zeroed_user() as the name suggests or rename the function and have
> it return an int everywhere.

I just checked, and in C11 (and presumably in older specs) it is
guaranteed that "true" and "false" from <stdbool.h> have the values 1
and 0 (respectively) [=A77.18]. So this is perfectly well-defined.

Personally, I think it's more readable to have:

  if (unlikely(size =3D=3D 0))
    return true;
  /* ... */
  return (val =3D=3D 0);

compared to:

  if (unlikely(size =3D=3D 0))
    return 1;
  /* ... */
  return val ? 0 : 1;

But I will change the function name (to check_zeroed_user) to make it
clearer that it isn't returning a boolean and that you need to check for
negative returns.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--ningxfpyii3awxw6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXY1g0wAKCRCdlLljIbnQ
EmniAP96l+2UHf1KZUsjmkF+ni1i3z9S8CcAMfeKjnFvKTEOmAD+Kamb7z8aEEP6
x2hEUZydsZf2ME41Ml2G9Z9uGlezWgM=
=zhm8
-----END PGP SIGNATURE-----

--ningxfpyii3awxw6--
