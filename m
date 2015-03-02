From: Sebastian Reichel <sre@kernel.org>
Subject: Re: [PATCH 0/9] N900 Modem Speech Support
Date: Mon, 2 Mar 2015 21:51:48 +0100
Message-ID: <20150302205148.GA24744@earth>
References: <1425271139-24715-1-git-send-email-sre@kernel.org>
 <201503022005.31729@pali>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201503022005.31729@pali>
Sender: linux-kernel-owner@vger.kernel.org
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Mar 02, 2015 at 08:05:31PM +0100, Pali Roh=E1r wrote:
> On Monday 02 March 2015 05:38:50 Sebastian Reichel wrote:
> > This patchset contains the missing speech data support for the
> > Nokia N900 modem.
> > [...]
>=20
> Hello, do you have also DT patches? Or no DT changes are needed?

No DT changes are needed. The DT already contains the n900-modem endpoint
(look for compatible =3D "nokia,n900-modem"), which is handled by
drivers/hsi/clients/nokia-modem.c.

The nokia-modem driver currently takes care of gpios, irqs, pinctrl
and loads ssi-protocol. After this patchset it also loads
cmt-speech.

> Is this cmt_speech version one from linux-n900 git tree? or it is=20
> new or modified?

The first 3 patches are from linux-n900 git tree, the other patches
are cleanups and fixups for mainline. Some of those are partly
available in the linux-n900 git tree.

-- Sebastian

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJU9M1hAAoJENju1/PIO/qadRUP/0Bfnv7cj/YM9Mb55hRkb5OM
d9IVZo5QM20uG2Dsk72yyng06ESTom5tw7ks75Z/g7VDzNuBMIPkXRxvpmdEYLsd
ECRg+PtZoZJS3STFnI+8rhTw257p/FaD23OQMAfAJ1Ey2YvncfoHCUV/11kjuLK2
c2Oaki715t9Lg8mpgjiqgIVe/HcawUY53nlLgqWkQ2chNHPS75QLz9yQrWzt61Pf
dfNFyfWb7ewYWwYmWU1F1V8C0+SnGRgI1BlzuvEl0+pgpT3+HERYcK8TFXXdlzD7
d+VMhFRnZT3LzpD3KvJvEUIf35HeW8qD3Yf8YNi9V3GN5PgFHHln9GGAl7DSiBjE
CDdZP3dgpp4qAM6Pob6YIBb18oDni0zVPf/5r2erI5JPe93dSYspzpVKD4kyF7vi
e4cWTHbpA8rF81b6zGFh8PfWaWbO/Z/wwb3j8s1NT1YHMTlsxOxRkBr1gqJnd5Xb
OUEEr7kS9sus/1aqxoTs3QlkpbN2uTi2pr6/8IgUqd0d4Lr6uxDTfOIAV6+dqCX1
7ygj4riYPZ5UO+18kPVzr6QAmQ3/aOwWJgVPJFMBfVRHceicbeiuf3dhfvtalVdu
gjlbfx7KkuZreB7Xn6tlGArAaboQSilRJPV1KlH4is+t18cMhNzgHMsf5JjC56ZQ
MU8rGGphmY23u6imjvv5
=phwu
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
