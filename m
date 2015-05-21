From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v8 14/16] ARM: dts: Introduce STM32F429 MCU
Date: Thu, 21 May 2015 20:51:22 +0200
Message-ID: <20150521185122.GD8557@lukather>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
 <2282066.NWoIT9ZyLc@wuerfel>
 <CALszF6CaO_yuNiSDuDV+4d2NRe_+32j=zcSE1HPhB1UH59cW9w@mail.gmail.com>
 <13641152.Yt4ZI3oT6L@wuerfel>
 <CALszF6CK5ezrO6D=4zr6zEPC7VanzbQjnZJwKOZekEZ5L4D-Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7502969954117588039=="
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CALszF6CK5ezrO6D=4zr6zEPC7VanzbQjnZJwKOZekEZ5L4D-Dg@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>, Stefan Agner <stefan@agner.ch>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Peter Meerwald <pmeerw@pmeerw.net>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux-Arch <linux-arch@vger.kernel.org>, Daniel Thompson <daniel.thompson@linaro.org>, Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>, Jonathan Corbet <corbet@lwn.net>, Jiri Slaby <jslaby@suse.cz>, Daniel Lezcano <daniel.lezcano@linaro.org>, Chanwoo Choi <cw00.choi@samsung.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Antti Palosaari <crope@iki.fi>, Geert Uytterhoeven <geert@linux-m68k.org>"linux-serial@vger.kernel.org" <li>
List-Id: linux-api@vger.kernel.org


--===============7502969954117588039==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="df+09Je9rNq3P+GE"
Content-Disposition: inline


--df+09Je9rNq3P+GE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2015 at 06:17:34PM +0200, Maxime Coquelin wrote:
> Hi Arnd, Philipp,
>=20
> 2015-05-13 21:11 GMT+02:00 Arnd Bergmann <arnd@arndb.de>:
> > Ideally the binding should follow closely what is documented
> > in the data sheet.
> >
>=20
> Daniel and myself would like your opinion about this binding:
>=20
> rcc: rcc@40023800 {
>     #reset-cells =3D <1>;
>     #clock-cells =3D <2>;
>     compatible =3D "st,stm32-rcc";
>     reg =3D <0x40023800 0x10>, <0x40023810 0x20>, <0x40023830 0x20>;
>     reg-names =3D "clock-cfg", "reset", "clock-gates";
> };
>=20
> It would solve a problem Daniel is facing due to conflicting mem
> region when clock and reset drivers are enabled, as both would reserve
> the same region.
>=20
> Also, it would make the reset driver very generic.
> Doing that, we could even create a generic-reset.c driver that would
> be used by STM32 and Sunxi (at least).
> In the probe function, it would check the number of reg resources.
> If a single resource is passed, it would take it, else it would look
> the one named "reset".
> The driver and bindings would be the same for the two families, and
> the bindings would be backward compatible with sunxi ones.
>=20
> Philip, Arnd, what do you think?

I lack a bit of context here, but I'd be very happy to use a generic
driver. As a matter of fact, the sunxi reset driver is already pretty
much there (not that it's very difficult to do).

The only thing we did that stands out a bit is that we actually need
the reset driver much earlier than the default probe, since some of
our timers are maintained in reset. We have some code to do just that
already, we just need have something similar to be on board.

Maxime (the other one)

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--df+09Je9rNq3P+GE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVXikqAAoJEBx+YmzsjxAgFNoP/igC4QqIbJZuHJzhLI99m/PM
oJ6ypHB7U4WVCK6Tmp3ybghgroSklKIIoDl/URRek9VatoscZMXO/VcSHKRojKAT
WQS16bjLcV50NcxoSbj7LNY4EDYWcm6d7rV1VS8cMTQ7OPVTGg1Bkfze4z6HnyRF
7/IFYjLT3XivRAMvWvY63BzSQ+gxJT7EGJmg2Sfmr6eDK595YAijQETtYZl3LE+I
hi3jRAnQ3QFsZY717wcoTN66heFH7VwI1hj9dKMEEQtFpTd+C4EJSY7k/uWemzuu
wGXTS3eecp6o98V9xQJXe7m+kKGvUsroNHONok4q1RpvhB4wiuEbTNkMvHhMlCdZ
tI3n2N+aRn4lA8lTmH1KNj1dMfpnB2F56DZUUoR/93NyJUThGQM4Juh7x3p/sxid
ih3um7LPmVe+ogcKaKPMhoBw82A61usKbJPtPAWBMRXdEs/udOREdYus7lyJ7KXY
krp7W5ERK14DgGlxe/NM/k4dWijabziJwwxqca6S6dErr8pZWCLBJ5guBEmomE/u
D+jUojB/khkSD2WE0FxTMMxacxOzg+2DPMF27zvozw9RSiqWqXbbxpz5IE7jRxp9
8utbZT4zFRxNZzSnIUzG0REMdNgqMzTJI/Zl0OvyJLd+2NPY7a3x7DVq0wPgNqCM
DOrlI7seBydrFVz4Uhgg
=xiOd
-----END PGP SIGNATURE-----

--df+09Je9rNq3P+GE--


--===============7502969954117588039==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-arm-kernel mailing list
linux-arm-kernel@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

--===============7502969954117588039==--
