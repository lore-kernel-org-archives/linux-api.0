From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v8 14/16] ARM: dts: Introduce STM32F429 MCU
Date: Fri, 22 May 2015 11:18:22 +0200
Message-ID: <20150522091822.GF8557@lukather>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
 <2282066.NWoIT9ZyLc@wuerfel>
 <CALszF6CaO_yuNiSDuDV+4d2NRe_+32j=zcSE1HPhB1UH59cW9w@mail.gmail.com>
 <13641152.Yt4ZI3oT6L@wuerfel>
 <CALszF6CK5ezrO6D=4zr6zEPC7VanzbQjnZJwKOZekEZ5L4D-Dg@mail.gmail.com>
 <1432285588.3929.28.camel@pengutronix.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2446001520252316360=="
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1432285588.3929.28.camel@pengutronix.de>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>, Stefan Agner <stefan@agner.ch>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Peter Meerwald <pmeerw@pmeerw.net>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux-Arch <linux-arch@vger.kernel.org>, Daniel Thompson <daniel.thompson@linaro.org>, Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>, Jonathan Corbet <corbet@lwn.net>, Jiri Slaby <jslaby@suse.cz>, Daniel Lezcano <daniel.lezcano@linaro.org>, Chanwoo Choi <cw00.choi@samsung.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Antti Palosaari <crope@iki.fi>, Geert Uytterhoeven <geert@linux-m68k.org>"linux-serial@vger.kernel.org" <li>
List-Id: linux-api@vger.kernel.org


--===============2446001520252316360==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fd5uyaI9j6xoeUBo"
Content-Disposition: inline


--fd5uyaI9j6xoeUBo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 22, 2015 at 11:06:28AM +0200, Philipp Zabel wrote:
> > In the probe function, it would check the number of reg resources.
> > If a single resource is passed, it would take it, else it would look
> > the one named "reset".
> > The driver and bindings would be the same for the two families, and
> > the bindings would be backward compatible with sunxi ones.
> >=20
> > Philip, Arnd, what do you think?
>=20
> I'm not a fan of describing the register layout in the device tree as
> detailed as the sunxi bindings do. I'd prefer the reg property to
> describe the device's register address space with one entry per
> contiguous block of registers.

That's exactly what we do.

> Unifying the mostly identical drivers is a good idea though, and reusing
> preexisting bindings is better than inventing new ones. I favor the
> socfpga binding, but I still like the sunxi bindings and this proposal
> better than encoding the register offset in the reset index.

I don't really get the difference between the socfpga and our bindings
actually. Would you mind to explain a bit further what you don't like
about it ?

Maxime
--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--fd5uyaI9j6xoeUBo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVXvReAAoJEBx+YmzsjxAg9IUQALOLEJidOKVjhMCaeHVNcKN8
jBjSk07cUB2e9qfF+Yr/IpzSF9KBtH8MUmQlIk1lEwMk4zllj41FrzkGOkReaCvQ
TKkY3rF3mliM8ORJz6GUVZ1vxFcID3EFNNPDzYD0fGvNyzBaXqTDyF76w0oQNKxT
WRSwHn3nSqn1IiM1EPw+mJVi6z1sbafZOBYCNLxu/ZjKBaLnmfcKumfoXyb4r5TW
2k5bfEBHg7PEyiLKhCqqjXAAFHLRlkSMqtRYQV0F/rvpbyQ22iJraimagDYJc25Y
LmeYJM726zs+4f9cizyyJV5BFkyWcBFJ2l32bvVuTTFU2RyZulVxlTsAgJ4WRDze
wVgCbduCfnF5Q3texbhScqqgGH8N6OTsu/w+4oluOHAxw4yw5lRcPJEGC4D2kVGn
/baHISJkwU4s0jfj1AEJ7U2zjxQ1rxC3/gpOWtXpZx4JdDSnYSMaRfaGmpSGNLqj
8cKmg5khuYN39/6Hv8faX739NhIh7NZIkbI0t+uyxDawolV/NGeeCJDf+RGWD9w4
APGrwJu+A41d9dxfpJODKAdc84hbqLt5p3uoCfLR+O4Av11XdvIZU0hKJz1I73/E
rpvnJeFGfc+Gx/hiu9ajUfHKm77qXmyhoIkovhFV1amTFbxqP1471zifdQCX2aCn
NWGerjHGvghTEjXTpTvw
=ZcXg
-----END PGP SIGNATURE-----

--fd5uyaI9j6xoeUBo--


--===============2446001520252316360==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--===============2446001520252316360==--
