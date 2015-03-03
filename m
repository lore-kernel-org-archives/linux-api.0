From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 0/9] N900 Modem Speech Support
Date: Tue, 3 Mar 2015 18:46:38 +0100
Message-ID: <201503031846.38960@pali>
References: <1425271139-24715-1-git-send-email-sre@kernel.org> <201503022005.31729@pali> <20150302205148.GA24744@earth>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1459924.ZjKQ1y4gqB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150302205148.GA24744@earth>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

--nextPart1459924.ZjKQ1y4gqB
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 02 March 2015 21:51:48 Sebastian Reichel wrote:
> Hi,
>=20
> On Mon, Mar 02, 2015 at 08:05:31PM +0100, Pali Roh=C3=A1r wrote:
> > On Monday 02 March 2015 05:38:50 Sebastian Reichel wrote:
> > > This patchset contains the missing speech data support for
> > > the Nokia N900 modem.
> > > [...]
> >=20
> > Hello, do you have also DT patches? Or no DT changes are
> > needed?
>=20
> No DT changes are needed. The DT already contains the
> n900-modem endpoint (look for compatible =3D
> "nokia,n900-modem"), which is handled by
> drivers/hsi/clients/nokia-modem.c.
>=20
> The nokia-modem driver currently takes care of gpios, irqs,
> pinctrl and loads ssi-protocol. After this patchset it also
> loads cmt-speech.
>=20
> > Is this cmt_speech version one from linux-n900 git tree? or
> > it is new or modified?
>=20
> The first 3 patches are from linux-n900 git tree, the other
> patches are cleanups and fixups for mainline. Some of those
> are partly available in the linux-n900 git tree.
>=20
> -- Sebastian

Maybe in this case you can add my Tested-By as I tested code from=20
linux-n900 git tree more times also with (modified) Maemo system.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1459924.ZjKQ1y4gqB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlT1834ACgkQi/DJPQPkQ1JkdwCgjNQM7k3Jcl+lbterV8T+aSEK
fDsAoJo4Fh/pPKF0Ij7aebpch0YEFVLw
=GPbm
-----END PGP SIGNATURE-----

--nextPart1459924.ZjKQ1y4gqB--
