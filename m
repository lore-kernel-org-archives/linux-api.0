From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH 0/9] N900 Modem Speech Support
Date: Mon, 2 Mar 2015 20:05:31 +0100
Message-ID: <201503022005.31729@pali>
References: <1425271139-24715-1-git-send-email-sre@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2018451.B1vUd1Vyav";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425271139-24715-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

--nextPart2018451.B1vUd1Vyav
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 02 March 2015 05:38:50 Sebastian Reichel wrote:
> Hi,
>=20
> This patchset contains the missing speech data support for the
> Nokia N900 modem.
>=20
> Userland access goes via /dev/cmt_speech. The API is
> implemented in libcmtspeechdata, which is used by ofono and
> the freesmartphone.org project. Apart from that the device is
> also used by the phone binaries distributed with Maemo. So
> while this is a new userland ABI for the mainline kernel it
> has been tested in the wild for some years.
>=20
> Simple Testing of the API can be done by checking out
> libcmtspeechdata [0], building the test tool and executing
> it. The tool will loop back audio data received from the
> caller.
>=20
> I have prepared a kernel branch, which includes these changes
> at [1].
>=20
> [0] https://lkml.org/lkml/2015/2/11/526
> [1]
> git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-hsi.g
> it branch/cmt-speech
>=20
> -- Sebastian
>=20
> Kai Vehmanen (3):
>   HSI: cmt_speech: Add cmt-speech driver
>   HSI: cmt_speech: Avoid GFP_ATOMIC in cs_char_open
>   HSI: cmt_speech: Return error if HSI port not configured
>=20
> Sebastian Reichel (6):
>   HSI: cmt_speech: Fix build for 4.0 kernel
>   HSI: cmt_speech: Cleanup initialisation
>   HSI: cmt_speech: Rename driver to cmt-speech
>   HSI: cmt_speech: Move cs-protocol.h to
> include/uapi/linux/hsi HSI: cmt_speech: Remove hardcoded
> channel numbers
>   HSI: nokia-modem: Add cmt_speech support
>=20
>  drivers/hsi/clients/Kconfig          |   11 +-
>  drivers/hsi/clients/Makefile         |    1 +
>  drivers/hsi/clients/cmt_speech.c     | 1451
> ++++++++++++++++++++++++++++++++++
> drivers/hsi/clients/nokia-modem.c    |   31 +-
>  include/uapi/linux/hsi/Kbuild        |    2 +-
>  include/uapi/linux/hsi/cs-protocol.h |  113 +++
>  6 files changed, 1606 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/hsi/clients/cmt_speech.c
>  create mode 100644 include/uapi/linux/hsi/cs-protocol.h

Hello, do you have also DT patches? Or no DT changes are needed?

Is this cmt_speech version one from linux-n900 git tree? or it is=20
new or modified?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2018451.B1vUd1Vyav
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlT0tHsACgkQi/DJPQPkQ1KoswCeId01KEN2jOQVoyaaetjcFOVb
ZrMAn3kuKPow0Y4KpK88y1HI8AKc5qlz
=qG+E
-----END PGP SIGNATURE-----

--nextPart2018451.B1vUd1Vyav--
