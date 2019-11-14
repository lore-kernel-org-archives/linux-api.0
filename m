From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v15 4/9] namei: LOOKUP_BENEATH: O_BENEATH-like scoped
 resolution
Date: Thu, 14 Nov 2019 15:57:44 +1100
Message-ID: <20191114045744.d3e7mp3zrupfe2wr@yavin.dot.cyphar.com>
References: <20191105090553.6350-1-cyphar@cyphar.com>
 <20191105090553.6350-5-cyphar@cyphar.com>
 <20191113015534.GA26530@ZenIV.linux.org.uk>
 <20191113074757.5b4u5vlyx2u6pbn6@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6gz2i7fpwlz4mefu"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191113074757.5b4u5vlyx2u6pbn6@yavin.dot.cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-kselftest@vger.kernel.org, sparclinux@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>, Shuah Khan <shuah@kernel.org>, linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, linux-xtensa@linux-xtensa.org, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, linuxppc-dev@lists.ozlabs.org, linux-m68k@lists.linux-m68k.org, Andy
List-Id: linux-api@vger.kernel.org


--6gz2i7fpwlz4mefu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-11-13, Aleksa Sarai <cyphar@cyphar.com> wrote:
> On 2019-11-13, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > Minor nit here - I'd split "move the conditional call of set_root()
> > into nd_jump_root()" into a separate patch before that one.  Makes
> > for fewer distractions in this one.  I'd probably fold "and be
> > ready for errors other than -ECHILD" into the same preliminary
> > patch.
>=20
> Will do.
>=20
> > > +			/* Not currently safe for scoped-lookups. */
> > > +			if (unlikely(nd->flags & LOOKUP_IS_SCOPED))
> > > +				return ERR_PTR(-EXDEV);
> >=20
> > Also a candidate for doing in nd_jump_link()...
> >=20
> > > @@ -1373,8 +1403,11 @@ static int follow_dotdot_rcu(struct nameidata =
*nd)
> > >  	struct inode *inode =3D nd->inode;
> > > =20
> > >  	while (1) {
> > > -		if (path_equal(&nd->path, &nd->root))
> > > +		if (path_equal(&nd->path, &nd->root)) {
> > > +			if (unlikely(nd->flags & LOOKUP_BENEATH))
> > > +				return -EXDEV;
> >=20
> > Umm...  Are you sure it's not -ECHILD?
>=20
> It wouldn't hurt to be -ECHILD -- though it's not clear to me how likely
> a success would be in REF-walk if the parent components didn't already
> trigger an unlazy_walk() in RCU-walk.
>=20
> I guess that also means LOOKUP_NO_XDEV should trigger -ECHILD in
> follow_dotdot_rcu()?

Scratch the last question -- AFAICS we don't need to do that for
LOOKUP_NO_XDEV because we check against mount_lock so it's very unlikely
that -ECHILD will have any benefit.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--6gz2i7fpwlz4mefu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXczexQAKCRCdlLljIbnQ
Em3mAQDOIg6+v9zFmJZ9+uYnLQ8tGd3ay8OeAsu6/xVlfCimMwD/cMP8o+o1KTbo
+rDSfA6D7b6Zhy7K3Vlf0k0OTebeSwI=
=kHIA
-----END PGP SIGNATURE-----

--6gz2i7fpwlz4mefu--
