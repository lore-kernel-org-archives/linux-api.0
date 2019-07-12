From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v9 04/10] namei: split out nd->dfd handling to
 dirfd_path_init
Date: Fri, 12 Jul 2019 22:07:43 +1000
Message-ID: <20190712120743.mka3vl5t4zndc5wj@yavin>
References: <20190706145737.5299-1-cyphar@cyphar.com>
 <20190706145737.5299-5-cyphar@cyphar.com>
 <20190712042050.GH17978@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="d4v7lkh6hn3fnrr5"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190712042050.GH17978@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Christian Brauner <christian@brauner.io>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-alpha@vger.ker
List-Id: linux-api@vger.kernel.org


--d4v7lkh6hn3fnrr5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-07-12, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Jul 07, 2019 at 12:57:31AM +1000, Aleksa Sarai wrote:
> > Previously, path_init's handling of *at(dfd, ...) was only done once,
> > but with LOOKUP_BENEATH (and LOOKUP_IN_ROOT) we have to parse the
> > initial nd->path at different times (before or after absolute path
> > handling) depending on whether we have been asked to scope resolution
> > within a root.
>=20
> >  	if (*s =3D=3D '/') {
> > -		set_root(nd);
> > -		if (likely(!nd_jump_root(nd)))
> > -			return s;
> > -		return ERR_PTR(-ECHILD);
>=20
> > +		if (likely(!nd->root.mnt))
> > +			set_root(nd);
>=20
> How can we get there with non-NULL nd->root.mnt, when LOOKUP_ROOT case
> has been already handled by that point?

Yup, you're completely right. I will remove the
  if (!nd->root.mnt)
in the next version.


--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--d4v7lkh6hn3fnrr5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXSh4CgAKCRCdlLljIbnQ
EmXbAP9tX+q7bWxunLL4KxbGY/ld+vFqPXrdHyJAsnYXD1QLXwEAosmgLN7YU35t
LUn9+NWS+cu0VbO4qtSioBcFwh5cpwA=
=zvz5
-----END PGP SIGNATURE-----

--d4v7lkh6hn3fnrr5--
