From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH v3 1/3] namei: implement O_BENEATH-style AT_* flags
Date: Sat, 13 Oct 2018 19:09:08 +1100
Message-ID: <20181013080907.yqpuy3zbbfe46gm4@ryuk>
References: <20181009070230.12884-1-cyphar@cyphar.com>
 <20181009070230.12884-2-cyphar@cyphar.com>
 <20181013073319.GS32577@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dst6zextluqynn7a"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181013073319.GS32577@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric Biederman <ebiederm@xmission.com>, Christian Brauner <christian@brauner.io>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--dst6zextluqynn7a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2018-10-13, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> First of all, dirfd_path_init() part should be in a separate commit.  And=
 I'm
> really not happy with the logics in there.  dirfd_path_init() itself is
> kinda-sorta reasonable.

Sure, I can do that.

> It is equivalent to setting the starting point for
> relative pathnames + setting ->root for LOOKUP_BENEATH, right?

Right.

> But the part in path_init() is too bloody convoluted for its own good.  L=
et me
> try to translate:
>=20
> > +	if (unlikely(flags & LOOKUP_XDEV)) {
> > +		error =3D dirfd_path_init(nd);
> > +		if (unlikely(error))
> > +			return ERR_PTR(error);
> > +	}
>=20
> * if LOOKUP_XDEV is set, set the starting point as if it was a relative
>   pathname.  If LOOKUP_BENEATH was set as well, set ->root to the same
>   point.

Right. This is for two reasons (though if you disagree with these
semantics we can change this as well):

1. It's not clear to me whether openat(somefd->"/", "/tmp", O_XDEV)
   should return an -EXDEV or completely ignore the starting point. Same
   argument with AT_FDCWD. I opted to make it so that the starting point
   has to be on the same mountpoint, but I totally understand if you
   feel this is insane -- and I'd be happy to change it. The real
   problem comes from (2).

2. AT_THIS_ROOT chroot-scope absolute paths, and so in the second patch
   LOOKUP_CHROOT also triggers this codepath. The main argument for this
   semantic is somewhat elaborated in the cover letter -- but
   the short version is because AT_THIS_ROOT has to chroot-scope
   absolute symlinks it would be somewhat strange if it didn't scope
   absolute paths you give it -- otherwise it could either be a footgun
   or would require always returning -EXDEV here.

   Though, as above, if you feel that the current semantics (absolute
   paths override whatever dirfd you give), then -EXDEV is the
   alternative I would pitch.

> * if it's an absolute pathname,=20
> >  	if (*s =3D=3D '/') {
> ... and we hadn't come here with LOOKUP_XDEV + LOOKUP_BENEATH, set ->root.
> > +		if (likely(!nd->root.mnt))
> > +			set_root(nd);
> * if it's an absolute pathname, set the starting point to ->root.  Note t=
hat
> if we came here with LOOKUP_XDEV, we'll discard the starting point we'd
> calculated.

We wouldn't discard it -- nd_jump_root() will check whether a mount
crossing was implied here (otherwise an absolute symlink could cause you
to cross a mountpoint).

But as above, if you'd prefer that absolute paths disable all dirfd
handling (as is the case now), I can remove this semantic.

> > +		error =3D nd_jump_root(nd);
> > +		if (unlikely(error))
> > +			s =3D ERR_PTR(error);
> >  		return s;
> >  	}
> > +	if (likely(!nd->path.mnt)) {
> * if we didn't have LOOKUP_XDEV, set the starting point as if it was a re=
lative
> pathname (which it is) and, if LOOKUP_BENEATH is also there, set ->root t=
here
> as well.
> > +		error =3D dirfd_path_init(nd);
> > +		if (unlikely(error))
> > +			return ERR_PTR(error);
> > +	}
> > +	return s;
> >  }
>=20
> Pardon me, but... huh?  The reason for your two calls of dirfd_path_init(=
) is,
> AFAICS, the combination of absolute pathname with both LOOKUP_XDEV and
> LOOKUP_BENEATH at the same time.  That combination is treated as if the p=
athname
> had been relative.  Note that LOOKUP_BENEATH alone is ignored for absolut=
e ones
> (and with a good reason - it's a no-op on path_init() level in that case).
>=20
> What the hell?  It complicates your code and doesn't seem to provide any =
benefits
> whatsoever

The reasoning for this is because of how AT_THIS_ROOT uses both of these
codepaths (it causes dirfd_path_init() to be called before the absolute
check, and also causes ->root to be set).

I wrote the features in parallel and then split out the code for
AT_THIS_ROOT so it could be discussed separately (and so removing it if
it was rejected would be simpler). But unfortunately this does result in
the dirfd_path_init() code looking completely superfluous without seeing
the second patch.

> -- you could bloody well have passed the relative pathname to start with.

(I think you mean always doing dirfd_path_init() first here?)

Right, but I didn't want to discard nd->path unnecessarily -- if we do
all of the code to grab AT_FDCWD and then it is completely unused (not
even in the AT_XDEV sense of "unused") it seems like a waste.

Did I misunderstand your suggestion? Were you referring to userspace
just being able to "[pass] the relative pathname to start with"?

> IDGI...  Without that kludge it becomes simply "do as we currently do for=
 absolute
> pathnames, call dirfd_path_init() for relative ones".  And I would argue =
that
> taking LOOKUP_BENEATH handling out of dirfd_path_init() into path_init() =
(relative)
> case would be a good idea.

Right, I could definitely do that -- though for AT_THIS_ROOT we'd
duplicate the ->root setting in both places.

> As it is, the logics is very hard to follow.

Sorry about that. Would you prefer if the two patches (AT_BENEATH family
and AT_THIS_ROOT) were sent as a single patch -- with the
dirfd_path_init() code split out? Or that the second patch do all of the
structural changes to refactor dirfd_path_init() usage?

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--dst6zextluqynn7a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEXzbGxhtUYBJKdfWmnhiqJn3bjbQFAlvBqCEACgkQnhiqJn3b
jbQxqg/+Kh8EJI8aqy0Yr1G79viNi3O0TUKOL0miieS39gPO12GEjHX/UJ43G6Yx
40vteAcFl08N1v6UIFmNfrw3N2h6Nz+Ss+1vCPF8GjQZyiGrRfSn0dTFgPDd9rOp
oJg+1fDjrPOPBwC8f1gsme6slLm9xlk+LRXZCi4yltttiDc8nydWpG5/Zn61thTL
/dw0ZjwZSIERA401EYpgtnsrdxcyAKh0OwPm2OGHvcaHfn950rYgvIRwptY2Xgzf
6kIJDX1bc/m3hWyQ1PLvZWdws63+7duT9b8ojtZqRrko9+M1tBn+skp1KpqfL6+q
Gdb+O2hJELJPBH2fgXfi5jDxGNuamJeNEkiabBEGGviGESGLOnloEtsU4v63gRC9
Md0V8F6Y8n0o5XzzgXh/dRAAvZ2cdd9JD4sJzo4NIW934ukkzJAI28zYuWdA36sy
qGA52jro88jukSsef5g/F+4f5OzT8U+bVhtwnAZGBHxaLIImn3j5595+mfR7nVmD
RrlVn2/OZ66Z9rboXGfeWm7SGCSagobQCUD6JY973Zx4XHOr/kwAkokFMJotbmnq
CNLzVsU9Idy/Z9O+qCTDrQgjQgMWI0YUubvJbGe9Gh9jOphDH71wskUsC8BahIqK
QPzRQPs+RCZ841+KCg+vhyQ+9SECubA8gQ87UNOEsSN3ZIgIcDE=
=SNGq
-----END PGP SIGNATURE-----

--dst6zextluqynn7a--
