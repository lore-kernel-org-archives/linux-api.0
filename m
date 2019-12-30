From: Aleksa Sarai <cyphar@cyphar.com>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Date: Mon, 30 Dec 2019 16:49:13 +1100
Message-ID: <20191230054913.c5avdjqbygtur2l7@yavin.dot.cyphar.com>
References: <20191230052036.8765-1-cyphar@cyphar.com>
 <20191230054413.GX4203@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vstjrid4bmeb3iov"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191230054413.GX4203@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>, Serge Hallyn <serge@hallyn.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--vstjrid4bmeb3iov
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-12-30, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Dec 30, 2019 at 04:20:35PM +1100, Aleksa Sarai wrote:
>=20
> > A reasonably detailed explanation of the issues is provided in the patch
> > itself, but the full traces produced by both the oopses and deadlocks is
> > included below (it makes little sense to include them in the commit sin=
ce we
> > are disabling this feature, not directly fixing the bugs themselves).
> >=20
> > I've posted this as an RFC on whether this feature should be allowed at
> > all (and if anyone knows of legitimate uses for it), or if we should
> > work on fixing these other kernel bugs that it exposes.
>=20
> Umm...  Are all of those traces
> 	a) reproducible on mainline and

This was on viro/for-next, I'll retry it on v5.5-rc4.

> 	b) reproducible as the first oopsen?

The NULL and garbage pointer derefs are reproducible as the first oops.
Looking at my logs, it looks like the deadlocks were always triggered
after the oops, but that might just have been a mistake on my part while
testing things.

> As it is, quite a few might be secondary results of earlier memory
> corruption...

Yeah, I thought that might be the case but decided to include them
anyway (the /proc/self/stack RCU stall is definitely the result of other
corruption and stalls).

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
<https://www.cyphar.com/>

--vstjrid4bmeb3iov
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSxZm6dtfE8gxLLfYqdlLljIbnQEgUCXgmP1gAKCRCdlLljIbnQ
En8yAP4heusqckPwVD1E6oISJdz6Un9hh96337R1CzO+HkhhwgEAwXuurrT9WDJY
vzW4vyGjAMtEZpNg3y1cdnODYnBG6Qs=
=FWL9
-----END PGP SIGNATURE-----

--vstjrid4bmeb3iov--
