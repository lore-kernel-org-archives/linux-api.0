From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] ASoC: pcm512x: Allow independently overclocking PLL,
 DAC and DSP
Date: Mon, 23 Feb 2015 23:31:32 +0900
Message-ID: <20150223143132.GD6236@finisterre.sirena.org.uk>
References: <1424120568-24648-1-git-send-email-peda@lysator.liu.se>
 <1424120568-24648-4-git-send-email-peda@lysator.liu.se>
 <20150221093328.GF6236@finisterre.sirena.org.uk>
 <88616b158f38499fa5a466f31d25aa80@EMAIL.axentia.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4AmJdx/+JAF2YHMk"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <88616b158f38499fa5a466f31d25aa80-RtsSNOqGLlYRm0/ZmH0nkw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Rosin <peda-koto5C5qi+TLoDKTGw+V6w@public.gmane.org>
Cc: Peter Rosin <peda-SamgB31n2u5IcsJQ0EH25Q@public.gmane.org>, "alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org" <alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org>, Liam Girdwood <lgirdwood-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--4AmJdx/+JAF2YHMk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 22, 2015 at 12:24:12AM +0000, Peter Rosin wrote:

> ...but I'm not sure everybody agrees that overclocking games should
> be allowed by any and all users?

I don't see why not, ASoC controls are already way beyond end user a lot
of the time.

> If you still want me to convert to ALSA controls, what control do you
> suggest? SOC_SINGLE_EXT? Or should I use an enumeration, because
> mixers tend to present volume controls as a percentage of max, which
> will be confusing: You are now at "volume" 75% (of max 40), when the
> value is 30. Eeek. But enumerations from 0% to 40% sounds tedious.

I'd just use a single value, it's a UI problem with the mixer and if the
control isn't called "Volume" that shouldn cause the UI to not present
it as a volume.  He said hopefully.

Or possibly a binary control I guess which would have the nice side
effect of hiding from most non-specialist UIs.

> And how would you suggest that I name the controls?
> "Max Overclock DAC", "Max Overclock DSP" and "Max Overclock PLL"?

Those sound reasonable.

> BTW, the only troubles I've had with overclocking "too much" is that it
> has stopped working. I have not managed to fry any chip. But that is no
> guarantee, of course.

It's vanishingly unlikely that you'll cause physical damage with this
sort of thing, you're much more likely to hit performance and filter
problems than anything else.

--4AmJdx/+JAF2YHMk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJU6znDAAoJECTWi3JdVIfQl+gH/AnpHP5W6OZpwDEs3Y4GLMYp
O5icFdKA0V9hKDbxbp2IvmQ01ipwFkaofGIoaCavexkBLvXMODibqPNHvfoB9eJU
R81uaJ1KjJ8ro6hUQgukE1LPbY9uu6Vxls0f2amWaYAfVj97C6RfDsBYAOM1cfoe
KTnkxZ/+R7G6z5HwJbXgABHEHh342SpDv0z0LJKbBXyV5Ljow/iec0t0RCWIg8MS
9nbGAdGxZ2NocPNKlpjtWeeEUEJ/io5iRVJjMD00YKKqu9l6b8VoAq+YRnmoufzz
4jiQQjpSYIhXipRPovmENQtK+blxLolChoG2R4gR9hd9S95/SStnsPyHpDENo8c=
=lGW/
-----END PGP SIGNATURE-----

--4AmJdx/+JAF2YHMk--
