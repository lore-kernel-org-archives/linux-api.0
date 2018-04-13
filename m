From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 24/24] debugfs: Restrict debugfs when the kernel is
 locked down
Date: Fri, 13 Apr 2018 22:22:41 +0200
Message-ID: <20180413202241.GB4484@amd>
References: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
 <152346403637.4030.15247096217928429102.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <152346403637.4030.15247096217928429102.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2018-04-11 17:27:16, David Howells wrote:
> Disallow opening of debugfs files that might be used to muck around when
> the kernel is locked down as various drivers give raw access to hardware
> through debugfs.  Given the effort of auditing all 2000 or so files and
> manually fixing each one as necessary, I've chosen to apply a heuristic
> instead.  The following changes are made:
>=20
>  (1) chmod and chown are disallowed on debugfs objects (though the root d=
ir
>      can be modified by mount and remount, but I'm not worried about that=
).

This has nothing to do with the lockdown goals, right? I find chown of
such files quite nice, to allow debugging without doing sudo all the time.

>  (2) When the kernel is locked down, only files with the following criter=
ia
>      are permitted to be opened:
>=20
> 	- The file must have mode 00444
> 	- The file must not have ioctl methods
> 	- The file must not have mmap

Dunno. Would not it be nicer to go through the debugfs files and split
them into safe/unsafe varieties?

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlrREZEACgkQMOfwapXb+vJzCACfSnkCF/54N13G7pz0zGeDo6ze
e6sAn1h0VTYzTyRfA28tZ4D7RyjjUYJU
=ESt0
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
