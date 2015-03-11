From: Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH v2 07/18] drivers: reset: Add STM32 reset driver
Date: Wed, 11 Mar 2015 14:08:28 +0100
Message-ID: <1426079308.3101.57.camel@pengutronix.de>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
	 <2383270.cAJPOxrkvo@wuerfel>
	 <CALszF6D3XMkjkMTdS-1xnVMFzgAW53NNOKOsfztsCboTdsBaaw@mail.gmail.com>
	 <2455342.zT71E5iyaL@wuerfel>
	 <CALszF6DENRS2L8mHD_iPsPwbAZndbHoB10oHaJ8-E4ajhog=8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CALszF6DENRS2L8mHD_iPsPwbAZndbHoB10oHaJ8-E4ajhog=8w@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, Andreas =?ISO-8859-1?Q?F=E4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel>
List-Id: linux-api@vger.kernel.org

Am Dienstag, den 10.03.2015, 22:20 +0100 schrieb Maxime Coquelin:
> 2015-03-10 21:21 GMT+01:00 Arnd Bergmann <arnd@arndb.de>:
> > On Tuesday 10 March 2015 16:44:24 Maxime Coquelin wrote:
> >> 2015-03-10 16:02 GMT+01:00 Arnd Bergmann <arnd@arndb.de>:
> >> > On Friday 20 February 2015 19:01:06 Maxime Coquelin wrote:
> >> >> +/* AHB1 */
> >> >> +#define GPIOA_RESET    0
> >> >> +#define GPIOB_RESET    1
> >> >> +#define GPIOC_RESET    2
> >> >> +#define GPIOD_RESET    3
> >> >> +#define GPIOE_RESET    4
> >> >> +#define GPIOF_RESET    5
> >> >> +#define GPIOG_RESET    6
> >> >> +#define GPIOH_RESET    7
> >> >> +#define GPIOI_RESET    8
> >> >> +#define GPIOJ_RESET    9
> >> >> +#define GPIOK_RESET    10
> >> >>
> >> >
> >> > As these are just the hardware numbers, it's better to not make =
them
> >> > part of the binding at all. Instead, just document in the bindin=
g that
> >> > one is supposed to pass the hardware number as the argument.
> >>
> >> The reset controller is part of the RCC (Reset & Clock Controller)=
 IP.
> >> In this version, I only provided the reset registers to the reset
> >> controller driver, but as per Andreas F=C3=A4rber remark, I should=
 avec a
> >> single DT node for both the resets and clocks.
> >>
> >> In the next version I am preparing, the defines doesn't look as
> >> trivial as in this version, GPIOA_RESET being 128 for instance.
> >>
> >> Is it fine for you if I keep the defines part of the binding?
> >>
> >>
> >
> > It's always better to avoid these files entirely, as they are
> > a frequent source of merge dependencies, and they make it less
> > obvious what's going on than having binary values in the dtb
> > that make sense.
>=20
> I agree it is always painful to have to have to manage these merge de=
pendencies.
> What I will do, if Philipp agrees, is to list all the values in the
> binding documentation.
>=20
> Doing that, the user of a reset won't have to do the calculation, and
> no more merge dependencies.

I'd prefer to have #defines for the reset bits if they are named in the
documentation and use the names in the dts. But if you want to referenc=
e
reset bits by number in the device tree instead, I won't insist.

Consider using two cells in the phandle for register and bit offset
instead of a single number that arbitrarily starts at 128.

regards
Philipp

