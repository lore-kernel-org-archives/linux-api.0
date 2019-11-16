From: Aleksa Sarai <asarai@suse.de>
Subject: Re: [PATCH v16 02/12] namei: allow nd_jump_link() to produce errors
Date: Sun, 17 Nov 2019 05:09:34 +1100
Message-ID: <20191116180934.fajrkc4jqcewiuqd@yavin.dot.cyphar.com>
References: <20191116002802.6663-1-cyphar@cyphar.com>
 <20191116002802.6663-3-cyphar@cyphar.com>
 <20191116003702.GX26530@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ushqsy2n2ywnjdre"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191116003702.GX26530@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>David
List-Id: linux-api@vger.kernel.org


--ushqsy2n2ywnjdre
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-11-16, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sat, Nov 16, 2019 at 11:27:52AM +1100, Aleksa Sarai wrote:
> > +	error =3D nd_jump_link(&path);
> > +	if (error)
> > +		path_put(&path);
>=20
> > +	error =3D nd_jump_link(&ns_path);
> > +	if (error)
> > +		path_put(&ns_path);
>=20
> > +	error =3D nd_jump_link(&path);
> > +	if (error)
> > +		path_put(&path);
>=20
> 3 calls.  Exact same boilerplate in each to handle a failure case.
> Which spells "wrong calling conventions"; it's absolutely clear
> that we want that path_put() inside nd_jump_link().
>=20
> The rule should be this: reference that used to be held in
> *path is consumed in any case.  On success it goes into
> nd->path, on error it's just dropped, but in any case, the
> caller has the same refcounting environment to deal with.
>=20
> If you need the same boilerplate cleanup on failure again and again,
> the calling conventions are wrong and need to be fixed.

Will do.

> And I'm not sure that int is the right return type here, to be honest.
> void * might be better - return ERR_PTR() or NULL, so that the value
> could be used as return value of ->get_link() that calls that thing.

I don't agree, given that the few callers of ns_get_path() are
inconsistent with regards to whether they should use IS_ERR() or check
for NULL, not to mention that "void *error" reads to me as being very
odd given how common "int error" is throughout the kernel. There's also
the "error =3D=3D ERR_PTR(-EAGAIN)" checks which also read as being quite
odd too.

But the main motivating factor for changing it was that the one use
where "void *" is useful (proc_ns_get_link) becomes needlessly ugly
because of the "nd_jump_link() can return errors" change:

	error =3D ERR_PTR(nd_jump_link(&ns_path));

Or probably (if you don't want to rely on ERR_PTR(0) =3D=3D NULL):

	int err =3D nd_jump_link(&ns_path);
	if (err)
		error =3D ERR_PTR(err);

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--ushqsy2n2ywnjdre
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXdA7WwAKCRCdlLljIbnQ
EkhIAQCTW+ppymqPGqw4uOB2Z70GQdn52zl46zQ6xxp5L3kEHQD9FZ2+HHtYsZC+
LGfFupqoyojLXID+lx72AXf4CJ7KLw4=
=aGSY
-----END PGP SIGNATURE-----

--ushqsy2n2ywnjdre--
