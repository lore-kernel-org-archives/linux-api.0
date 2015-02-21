From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 0/2] ASoC: pcm512x: Add knobs to allow and control
 overclocking
Date: Sat, 21 Feb 2015 18:34:49 +0900
Message-ID: <20150221093449.GH6236@finisterre.sirena.org.uk>
References: <1424120568-24648-1-git-send-email-peda@lysator.liu.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="l06SQqiZYCi8rTKz"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1424120568-24648-1-git-send-email-peda@lysator.liu.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Rosin <peda@lysator.liu.se>
Cc: alsa-devel@alsa-project.org, Peter Rosin <peda@axentia.se>, Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


--l06SQqiZYCi8rTKz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 16, 2015 at 10:02:45PM +0100, Peter Rosin wrote:

> Another "feature" that one might want, is that attempts to change the
> overclocking should fail with EBUSY when the device is already in use.
> But I haven't invested enough time to find out how I should determine
> when to fail, so for this version the driver accepts the change but
> doesn't enforce the new limit until the clock rates are recalculated.

You should be able to to check for the bias level being set to ON.

--l06SQqiZYCi8rTKz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJU6FE5AAoJECTWi3JdVIfQTNIH/R6zx8ei5qBC6eNPDzB/9zq9
Bioux1bxNd9cGNbMjes5s0ovbQsxzaQVO15LOCiOt1nTkhNcZxTxESuc5zqnY4wz
AsP0uGmbXWr3So8b24C0L1O/BOQQOJxUBithwmysHZJ7eqCgRSUxTjtck8nwan2v
as1/S+yDcE1Qsx97qct0jQ6MV66gYplKUFRAs87o6mCsw4gY0OlyYWtHLGubg9pk
rReSLgNyvOcoSnD0UtIdqhe1k6blFBo7kgV85XbqAm194FtAkGqUgLf6N5y2ig3E
OK9xx+8GAM+CJOAAVecpdMk3hEntzQ2ZadxGWECRWn4FTn92Icz+qoh0KPBmsws=
=S//o
-----END PGP SIGNATURE-----

--l06SQqiZYCi8rTKz--
