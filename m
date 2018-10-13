From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v3 1/3] namei: implement O_BENEATH-style AT_* flags
Date: Sat, 13 Oct 2018 19:20:03 +1100
Message-ID: <20181013082003.5fvgx3g4i2vx2cdt@ryuk>
References: <20181009070230.12884-1-cyphar@cyphar.com>
 <20181009070230.12884-2-cyphar@cyphar.com>
 <20181013073319.GS32577@ZenIV.linux.org.uk>
 <20181013080511.GT32577@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zghhtdmiqqb2lfl5"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181013080511.GT32577@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric Biederman <ebiederm@xmission.com>, Christian Brauner <christian@brauner.io>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--zghhtdmiqqb2lfl5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-10-13, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > Pardon me, but... huh?  The reason for your two calls of dirfd_path_ini=
t() is,
> > AFAICS, the combination of absolute pathname with both LOOKUP_XDEV and
> > LOOKUP_BENEATH at the same time.  That combination is treated as if the=
 pathname
> > had been relative.  Note that LOOKUP_BENEATH alone is ignored for absol=
ute ones
> > (and with a good reason - it's a no-op on path_init() level in that cas=
e).
> >=20
> > What the hell?  It complicates your code and doesn't seem to provide an=
y benefits
> > whatsoever -- you could bloody well have passed the relative pathname t=
o start with.
> >=20
> > IDGI...  Without that kludge it becomes simply "do as we currently do f=
or absolute
> > pathnames, call dirfd_path_init() for relative ones".  And I would argu=
e that
> > taking LOOKUP_BENEATH handling out of dirfd_path_init() into path_init(=
) (relative)
> > case would be a good idea.
> >=20
> > As it is, the logics is very hard to follow.
>=20
> 	... and it fails on LOOKUP_BENEATH anyway.  Egads...  So that's for your
> LOOKUP_CHROOT ;-/  IMO that's awful, especially with the way you've sprea=
d those
> LOOKUP_CHROOT cases between these two.

Yeah, the ->root setting in dirfd_path_init() is ugly. :/

> 	Why not simply have O_THISROOT pick root by dirfd and call file_open_roo=
t()?

Wouldn't this require replicating the dirfd_path_init()-like code inside
all of the path_*at() callers which use path_init()? Or is there another
common place we could put it?

> And if something wants it for stat(), etc. just have them use it combined=
 with
> O_PATH and pass the result to ...at()...

This works for stat and quite a few other things (which is why I only
added openat(2) support for the moment), but I think we'd eventually
need something like this for renameat2(2) as well as a few other choice
*at(2) syscalls. Though I also think that more AT_EMPTY_PATH support
would removed the need for _most_ *at(2) implementations to use this.

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--zghhtdmiqqb2lfl5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAlvBqrMACgkQnhiqJn3b
jbR1Nw//cNe++vgwSqmvqDGh3gUr0fD2hCd5QWqwG3u0eE0cBu7GsJFA3t5IhfIL
zFh5UkBJA9qHI51z0+G3ULPv/CnOYz2cON0yx4s3o7eRybt77E0LNUZA+wPU8840
YY36BE0OD0EmlDQASdyq4zOmwqdiJzOmhDRQbcnYwgANjaP5etZfX1MBurJ9ssdT
cIe1JZQqnXEpkekNlnrxNF6pLWeVH7YtiFasZAFwh+2i9YcLrzdTQwG7RAlBd6u2
95k69Ag4cGMvl7lcxsZjJ0/vjW4CKK/NtF1kzF9cXTvbIIMazNImYTMa9CqmAZOZ
vMshesoPcEcCmljW9yf2AGkM3fmMQ6w6i5gbhmJZP6kvU48/P0fVBnUoL3PEwTC1
J+EiAjPEIoeTRBcPRbNpUaCr+JDs/HtoY7JIHWnmzcRmLuvVu2ss/2tme6B/WqSI
ljnJt5SvaMPd712fk4HEdJ27SlXfzcIpaHHVW2ZrUYFrj2JvDr3t3oP5laLPzsYa
xQ8yT5r0VHSkqLhkm8E2YZduJhZ9FKn+fsxykLcCltXv/yLD1XG6g0yAGp399ibQ
Hajh+QRAzRvghKhlemLuYb2f3MQj/2pemjAzcHjr0TKLV+kgFOPI33CXpMCnST2F
vgN/b12cFexN4OLtrp0JRjQYnIMHLuiUVCezpor0pYJIvE/wPug=
=f2Dg
-----END PGP SIGNATURE-----

--zghhtdmiqqb2lfl5--
