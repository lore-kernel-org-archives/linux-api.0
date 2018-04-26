From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 07/24] hibernate: Disable when the kernel is locked down
Date: Thu, 26 Apr 2018 09:26:46 +0200
Message-ID: <20180426072646.GA31822@amd>
References: <20180413202234.GA4484@amd>
 <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
 <152346392521.4030.5108539377959227838.stgit@warthog.procyon.org.uk>
 <27926.1524148733@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <27926.1524148733@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, jikos@suse.cz
Cc: torvalds@linux-foundation.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2018-04-19 15:38:53, David Howells wrote:
> Pavel Machek <pavel@ucw.cz> wrote:
>=20
> > > There is currently no way to verify the resume image when returning
> > > from hibernate.  This might compromise the signed modules trust model,
> > > so until we can work with signed hibernate images we disable it when =
the
> > > kernel is locked down.
> >=20
> > I'd rather see hibernation fixed than disabled like this.
>=20
> The problem is that you have to store the hibernated kernel image encrypt=
ed,
> but you can't store the decryption key on disk unencrypted or you've just
> wasted the effort.

That's not how the crypto needs to work. Talk to Jiri Kosina, ok?

Firmware gives you a key, you keep it secret, use it to sign the
hibernation image on suspend, and verify the signature on resume. Or
something like that.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlrhfzYACgkQMOfwapXb+vKUbACffzbN2YGUihEbD3PcpM1b3kG9
rwAAoMO4Nkw+49H7bkdJebvsBuJXZDeP
=wRwy
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
