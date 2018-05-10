From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 24/24] debugfs: Restrict debugfs when the kernel is
 locked down
Date: Thu, 10 May 2018 13:01:13 +0200
Message-ID: <20180510110113.GA6977@amd>
References: <20180413202241.GB4484@amd>
 <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
 <152346403637.4030.15247096217928429102.stgit@warthog.procyon.org.uk>
 <27818.1524148547@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <27818.1524148547@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2018-04-19 15:35:47, David Howells wrote:
> Pavel Machek <pavel@ucw.cz> wrote:
>=20
> > >  (1) chmod and chown are disallowed on debugfs objects (though the ro=
ot dir
> > >      can be modified by mount and remount, but I'm not worried about =
that).
> >=20
> > This has nothing to do with the lockdown goals, right? I find chown of
> > such files quite nice, to allow debugging without doing sudo all the ti=
me.
>=20
> It allows someone to give everyone access to files that should perhaps on=
ly be
> accessible by root.  Besides, if you disable lockdown then you can do thi=
s if
> you want.

As I said this has nothing to do with lockdown, so does not belong in
this series. (And besides, it is bad idea.)

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlr0JnkACgkQMOfwapXb+vKsZwCfVdFRRD0vggdq5dy87grncAKq
zooAn1UP9zxiDCMEYTDHNkNjszBUVend
=+dt4
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
