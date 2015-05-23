From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v8 14/16] ARM: dts: Introduce STM32F429 MCU
Date: Sat, 23 May 2015 10:18:47 +0200
Message-ID: <20150523081847.GJ8557@lukather>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
 <2282066.NWoIT9ZyLc@wuerfel>
 <CALszF6CaO_yuNiSDuDV+4d2NRe_+32j=zcSE1HPhB1UH59cW9w@mail.gmail.com>
 <13641152.Yt4ZI3oT6L@wuerfel>
 <CALszF6CK5ezrO6D=4zr6zEPC7VanzbQjnZJwKOZekEZ5L4D-Dg@mail.gmail.com>
 <1432285588.3929.28.camel@pengutronix.de>
 <20150522091822.GF8557@lukather>
 <1432289231.3929.60.camel@pengutronix.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4285934497855337019=="
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1432289231.3929.60.camel@pengutronix.de>
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


--===============4285934497855337019==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gmhhrsDozM2n+uz5"
Content-Disposition: inline


--gmhhrsDozM2n+uz5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Philipp,

On Fri, May 22, 2015 at 12:07:11PM +0200, Philipp Zabel wrote:
> Am Freitag, den 22.05.2015, 11:18 +0200 schrieb Maxime Ripard:
> > On Fri, May 22, 2015 at 11:06:28AM +0200, Philipp Zabel wrote:
> > > > In the probe function, it would check the number of reg resources.
> > > > If a single resource is passed, it would take it, else it would look
> > > > the one named "reset".
> > > > The driver and bindings would be the same for the two families, and
> > > > the bindings would be backward compatible with sunxi ones.
> > > >=20
> > > > Philip, Arnd, what do you think?
> > >=20
> > > I'm not a fan of describing the register layout in the device tree as
> > > detailed as the sunxi bindings do. I'd prefer the reg property to
> > > describe the device's register address space with one entry per
> > > contiguous block of registers.
> >=20
> > That's exactly what we do.
>=20
> Sorry, what I mean is 'as detailed as reusing the sunxi bindings for
> stm32xx here would do'. I don't know enough about the Allwinner register
> layouts to form an opinion.
>=20
> The STM32F427xx/STM32F429xx manual, Table 13. "STM32F427xx and
> STM32F429xx register boundary addresses" contains this entry:
>     Bus    Boundary address       Peripheral
>     AHB1   0x40023800-0x400238bf  RCC
>=20
> And that's how I'd expect it to be described by the device tree:
>=20
>     rcc: rcc@40023800 {
>         compatible =3D "st,stm32-rcc";
>         reg =3D <0x40023800 0xc0>;
>     };

It's pretty much what we do already. The thing is that our reset
controllers are intertwined with our clock ones, so our reset
controllers are usually taking only a few registers, and we can't use
more than that since we have clocks in the registers around.

> Instead of "reg =3D <0x40023810 0x20>" for the resets. Where in the
> address range the reset, clock gate and clock configuration registers
> reside could be derived from the compatible value.

I agree on that, and if a generic solution was to be made like this,
we could definitely use it.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--gmhhrsDozM2n+uz5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVYDfnAAoJEBx+YmzsjxAgNi0P/jSOTQ3vHIrcKoIWxtBtGLGd
6mvkQpyaIFt9E8AQZbD0XDaFoHI01r2ZoVQjAZKXFjbvlNeU2q1HQjzIV4cKURbt
8ZOdee82KVHY3ZfmBMyVmvYu2Q6p/qJi03hoLqZ3/VrnwSavNq02lQRevcWg+kva
RKlgphWNUElei6bon9rzeAkUR46Xz53k/cku/Jjd6ufwl8c6hBrLCVnEowJh2jzG
x2H51EXcl6ACh3yXd9GB28cMnghzSb1jwXb9AK4rLQGD1y66yrKl8gElr1OHTWUS
0a26Ao3y+epFySC7t+kuC7xLOWpnim7DxgR60/kkwlJ8KHRInzcm/4kqmGY3d3mY
U0O1sbMqu44tL4xNkcjEGLunGE/Ji+lS499k3UsAeG+T7nDSsiflApYALm9QIxG6
TJ2eYva89d3KJJg2vzy5oyrBrjanfaSgwDfX0t0c9Ff6wAuZFoRw1QLT+A2fWhYa
RDcIp3b58jQ52RL7Tl4aRRlo7bDdNA+dviqqkonpjKS5SlUv6unGuU1HkIQuj/N0
teIZH90VM7QoVKiRqhB9VgvvoZQrztHvHii6meErIzG8VKdZ7byu6ZTZCLXiwubV
LCc1HfWCgvAACoYhguHFZhTg7Jht8niRERwX56A8J44I6c4yRs2gERwq8cLz2hH5
ugYDmZTVzeQ+xwPBC+TA
=ec/B
-----END PGP SIGNATURE-----

--gmhhrsDozM2n+uz5--


--===============4285934497855337019==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--===============4285934497855337019==--
