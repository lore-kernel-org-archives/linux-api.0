From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 07/24] hibernate: Disable when the kernel is locked down
Date: Fri, 13 Apr 2018 22:22:34 +0200
Message-ID: <20180413202234.GA4484@amd>
References: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
 <152346392521.4030.5108539377959227838.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <152346392521.4030.5108539377959227838.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2018-04-11 17:25:25, David Howells wrote:
> From: Josh Boyer <jwboyer@fedoraproject.org>
>=20
> There is currently no way to verify the resume image when returning
> from hibernate.  This might compromise the signed modules trust model,
> so until we can work with signed hibernate images we disable it when the
> kernel is locked down.

I'd rather see hibernation fixed than disabled like this.

I believe Jiri Kosina may have some patches for that?
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlrREYoACgkQMOfwapXb+vIowwCfUxzs3aUSVyQ2xrc9jllsTOiW
MWsAnicxnBuk7FXujrLwnUpctw0Ry4WG
=FD71
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
