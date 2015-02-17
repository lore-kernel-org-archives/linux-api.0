From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 0/2] ASoC: pcm512x: Add knobs to allow and control
 overclocking
Date: Tue, 17 Feb 2015 10:53:12 +0900
Message-ID: <20150217015312.GQ9110@finisterre.sirena.org.uk>
References: <1424120568-24648-1-git-send-email-peda@lysator.liu.se>
 <1424120568-24648-2-git-send-email-peda@lysator.liu.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="WOTjKnJ88wpJKlWH"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1424120568-24648-2-git-send-email-peda@lysator.liu.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Rosin <peda@lysator.liu.se>
Cc: alsa-devel@alsa-project.org, Peter Rosin <peda@axentia.se>, Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--WOTjKnJ88wpJKlWH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 16, 2015 at 10:02:46PM +0100, Peter Rosin wrote:

> I wasn't sure if I should add Documentation/* for these sysfs knobs
> or not? A lot of knobs do not have docs... And I'm not sure how I
> should name the doc-file since the pcm512x driver handles devices
> connected with both i2c and spi. So, this isn't perfect, suggestions
> welcome.

It's supposed to be mandatory to have documentation but not well
enforced.

--WOTjKnJ88wpJKlWH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJU4p8DAAoJECTWi3JdVIfQ1aMH/0gnN1eRqY4SIgCizCynBGek
hquEpI5h++pVQgBgEtpkrP2zCyY4JlYX5JdlVzhODiEKkWgULNzC34bt+U4JuJiD
HjiRvVQogDJpqed8+bUOWDoWblm7Vo8waNKHK6D4NyVzrLNK5OwI3NI2VNTF51UD
HaiSrv5rpwl7zAKce0LVos+OY6P8Jtmkq2YWPZchH/RvJj2W55PdIfpVicEa6nFJ
UK67GdGQ2+ZDde0ZnUTU7rRew5S71GRj0WbZDiUbMmmHWuBKnKExkaMPQUCe1jNw
QvSDCs62wVYB3icuActS7SrLBKXcoU3r6TGJNrSwTatgn3E+v7bcPAO8FmtQKAk=
=p2L0
-----END PGP SIGNATURE-----

--WOTjKnJ88wpJKlWH--
