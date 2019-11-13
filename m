From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v15 4/9] namei: LOOKUP_BENEATH: O_BENEATH-like scoped
 resolution
Date: Wed, 13 Nov 2019 18:47:57 +1100
Message-ID: <20191113074757.5b4u5vlyx2u6pbn6@yavin.dot.cyphar.com>
References: <20191105090553.6350-1-cyphar@cyphar.com>
 <20191105090553.6350-5-cyphar@cyphar.com>
 <20191113015534.GA26530@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="odomi6wtik4yoblv"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191113015534.GA26530@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Christian Brauner <christian.brauner@ubuntu.com>, David Drysdale <drysdale@google.com>, Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Ras
List-Id: linux-api@vger.kernel.org


--odomi6wtik4yoblv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-11-13, Al Viro <viro@zeniv.linux.org.uk> wrote:
> Minor nit here - I'd split "move the conditional call of set_root()
> into nd_jump_root()" into a separate patch before that one.  Makes
> for fewer distractions in this one.  I'd probably fold "and be
> ready for errors other than -ECHILD" into the same preliminary
> patch.

Will do.

> > +			/* Not currently safe for scoped-lookups. */
> > +			if (unlikely(nd->flags & LOOKUP_IS_SCOPED))
> > +				return ERR_PTR(-EXDEV);
>=20
> Also a candidate for doing in nd_jump_link()...
>=20
> > @@ -1373,8 +1403,11 @@ static int follow_dotdot_rcu(struct nameidata *n=
d)
> >  	struct inode *inode =3D nd->inode;
> > =20
> >  	while (1) {
> > -		if (path_equal(&nd->path, &nd->root))
> > +		if (path_equal(&nd->path, &nd->root)) {
> > +			if (unlikely(nd->flags & LOOKUP_BENEATH))
> > +				return -EXDEV;
>=20
> Umm...  Are you sure it's not -ECHILD?

It wouldn't hurt to be -ECHILD -- though it's not clear to me how likely
a success would be in REF-walk if the parent components didn't already
trigger an unlazy_walk() in RCU-walk.

I guess that also means LOOKUP_NO_XDEV should trigger -ECHILD in
follow_dotdot_rcu()?

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--odomi6wtik4yoblv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXcu1KgAKCRCdlLljIbnQ
EpYSAQDaNIB4LkhLlbFgkuRPiavU6vZ03HuSIHKseqaD6uMARwD+OcGzTDahyjJ6
YeuKal+s33ETzSjupl7K2mKfYQpA2Q0=
=nyQ8
-----END PGP SIGNATURE-----

--odomi6wtik4yoblv--
