From: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] eeprom: Add a simple EEPROM framework
Date: Sun, 22 Feb 2015 15:34:05 +0100
Message-ID: <20150222143405.GY25269@lukather>
References: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1424365708-26681-1-git-send-email-srinivas.kandagatla@linaro.org>
 <CAL_Jsq+SeuoojgTpv1y_aPJ_jzDr3HqZhYEBQ3_vYGBHvcccug@mail.gmail.com>
 <54E78A31.9020306@linaro.org>
 <CAL_Jsq+mvpRjYfL_8OseTDCB-6aBhwhNKLBQXXJeVQLDwWm8Nw@mail.gmail.com>
 <54E86CA5.2080907@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HSHpc5A+GJc9BHcd"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54E86CA5.2080907-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--HSHpc5A+GJc9BHcd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 21, 2015 at 11:31:49AM +0000, Srinivas Kandagatla wrote:
> >I would do something more simple that is just a list of keys and their
> >location like this:
> >
> >device-serial-number =3D <start size>;
> >key1 =3D <start size>;
> >key2 =3D <start size>;
> >
> There are pros and cons doing it as list of keys.
>=20
> One reason for doing it as fixed properties("eeproms", "eemprom-names") is
> "consistency and familiarity" like interrupts, regs, dmas, clocks, pinctr=
l,
> reset, pwm have fixed property names, trying to get most subsystems to do=
 it
> the same way makes it easier for people to write dts files.

And eeprom-names was something that was asked for last time we
discussed it (I don't really remember who though, maybe Arnd?)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--HSHpc5A+GJc9BHcd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJU6ejdAAoJEBx+YmzsjxAg+EoQAKYte/SRe29klKRirGbmTnMT
Uc/BXt9W3/deGFsw/Ap3lFPLJ9wPU6jf6RipWhAKHSTf72kHLAEEyDBarULA7r65
OfRNXdSGXtkf3ZETkgXJOKV1WXvfg4OlyoumFicGbDCr3i9Jsp967SWEBJtjwZqm
imNF92NkplwefgxX8u/UzMKDKuLLo8q/skilRdl2Y4IzxZ1tTVrAwbm33j0+S1XJ
ApjnRmYzJF+R67DjwG2NgjiomF14lZXSe9Zv3VXg0fApo9Nwdo8490S4OFq9fQwS
EoaoX9VUc7sCAZtErT2qXrsTXivuBIiSb8GEVq0ctKKbvlHT8+k/xd1AezjBh+nq
dOIrCUPN02x2VqkVsWOpBya5VN8WuEfVf9QvLv8K2p5tpe9gY/Si9wjLXbTM1p5V
klABGuD6BUj+posvI+jikz39q2g+iLHOsAm2zCVbX7Dk4QWWeYgnAcYnr/omfm5R
glI37Cf6CRxA0KqSCuVW7SjqhsmR1ReYQTUMc5VnrJzDTQcbmw25D6WzkLlNm9cc
jQQDxrqURrr4aXBQcwtP94r0VVsJXV6pSsJ04fATM0pV+fLFhdBoBE9UGLI+Q531
j+YkujncVZmvTqEYkGsuufaGZjRr/dIXGFj8GPv+iuYshngpR+G00KSLH44fIPfP
x3x/KowtlvCtxKZIw5+L
=Wcno
-----END PGP SIGNATURE-----

--HSHpc5A+GJc9BHcd--
