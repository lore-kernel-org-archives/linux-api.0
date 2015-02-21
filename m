From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] ASoC: pcm512x: Allow independently overclocking PLL,
 DAC and DSP
Date: Sat, 21 Feb 2015 18:33:28 +0900
Message-ID: <20150221093328.GF6236@finisterre.sirena.org.uk>
References: <1424120568-24648-1-git-send-email-peda@lysator.liu.se>
 <1424120568-24648-4-git-send-email-peda@lysator.liu.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="juZjCTNxrMaZdGZC"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1424120568-24648-4-git-send-email-peda-SamgB31n2u5IcsJQ0EH25Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Rosin <peda-SamgB31n2u5IcsJQ0EH25Q@public.gmane.org>
Cc: alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org, Peter Rosin <peda-koto5C5qi+TLoDKTGw+V6w@public.gmane.org>, Liam Girdwood <lgirdwood-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--juZjCTNxrMaZdGZC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 16, 2015 at 10:02:48PM +0100, Peter Rosin wrote:
> From: Peter Rosin <peda-koto5C5qi+TLoDKTGw+V6w@public.gmane.org>
>=20
> When using non-standard rates, a relatively small amount of overclocking
> can make a big difference to a number of cases.

This is all basically fine but I'm wondering why this is being
configured via sysfs and not via ALSA controls?  It's going to be more
fiddly for people to have to work with both control methods when they
need to configure these things.

--juZjCTNxrMaZdGZC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJU6FDnAAoJECTWi3JdVIfQ1F8H/3deIFZ0axaEoe1fasvuBSr8
cWrp3RCJXgczy9dNXOWJ0XfP2NMDGuBxLg08waDvomqjUVH+xgWWWNk6aFSt7FTU
etPmOYJHi20Cl2px0jduYF02Hv+tX0WUzCpc+QPK+bAMYumHokyeNXPtsu9JdMSI
vzyKir7jgnmoV06/eZJErCX/de0sQe+2YCLJ+2aoWgtRBDAxG2nml5aco5GNKw2J
R7qXtw+1vKSCsGRD0YCtKDPQeJL2aji99f7jNbrz4QhEUAoVjt3Vy2nO0d0TClVx
iLyusHJgetN2dHrpfVwo4YaL5s/bEq9ibDfynzjhVfP0DI13/NyuhqRUQGNexnE=
=CC6A
-----END PGP SIGNATURE-----

--juZjCTNxrMaZdGZC--
