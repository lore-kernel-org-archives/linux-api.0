From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Subject: Re: [PATCH v8 14/16] ARM: dts: Introduce STM32F429 MCU
Date: Fri, 22 May 2015 16:06:17 +0200
Message-ID: <555F37D9.3040808@suse.de>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>	<2282066.NWoIT9ZyLc@wuerfel>	<CALszF6CaO_yuNiSDuDV+4d2NRe_+32j=zcSE1HPhB1UH59cW9w@mail.gmail.com>	<13641152.Yt4ZI3oT6L@wuerfel>	<CALszF6CK5ezrO6D=4zr6zEPC7VanzbQjnZJwKOZekEZ5L4D-Dg@mail.gmail.com>	<1432285588.3929.28.camel@pengutronix.de>	<20150522091822.GF8557@lukather>	<1432289231.3929.60.camel@pengutronix.de>	<CALszF6CQ1_HQXJ8=vgytvVo2t4_ue5_nsE06HPyHMzSLrntqKg@mail.gmail.com>	<555F2A8A.5020205@suse.de> <CALszF6A=TZ_EROrfuBOAGiY3mbydC5fepWLSWrZLLt4nV9sr4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CALszF6A=TZ_EROrfuBOAGiY3mbydC5fepWLSWrZLLt4nV9sr4w@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>, Daniel Thompson <daniel.thompson@linaro.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Maxime Ripard <maxime.ripard@free-electrons.com>, Arnd Bergmann <arnd@arndb.de>, =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= <u.kleine-koenig@pengutronix.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Joe Perches <joe@perches.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Lee Jones <lee.jones@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hell>
List-Id: linux-api@vger.kernel.org

Am 22.05.2015 um 15:57 schrieb Maxime Coquelin:
> 2015-05-22 15:09 GMT+02:00 Andreas F=C3=A4rber <afaerber@suse.de>:
>> As you should know, I did have an RCC clk driver, and there is no su=
ch
>> issue. The two drivers use different mechanisms for initialization. =
And
>> I'm pretty sure that I've already remarked that on the list, too.
>=20
> Yes, you use of_iomap in your clock driver [0].

Which was inspired by the efm32 driver iirc.

> Daniel, would you accept to do the same?
> That would remove one difference between stm32/sunxi/socfpga reset dr=
ivers.
>=20
> Regards,
> Maxime
>=20
> [0]: https://github.com/afaerber/linux/blob/stm32/drivers/clk/clk-stm=
32f42xxx-rcc.c

=46or the record, that still has some internal clocks that shouldn't be
exposed.

Andreas

--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Dilip Upmanyu, Graham Norton=
; HRB
21284 (AG N=C3=BCrnberg)
