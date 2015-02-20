From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v2 14/18] ARM: Add STM32 family machine
Date: Fri, 20 Feb 2015 22:37:20 +0100
Message-ID: <1424468240.24292.5.camel@x220>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
	 <1424455277-29983-15-git-send-email-mcoquelin.stm32@gmail.com>
	 <20150220200019.GU19388@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20150220200019.GU19388@pengutronix.de>
Sender: linux-arch-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, afaerber@suse.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will
List-Id: linux-api@vger.kernel.org

On Fri, 2015-02-20 at 21:00 +0100, Uwe Kleine-K=C3=B6nig wrote:
> On Fri, Feb 20, 2015 at 07:01:13PM +0100, Maxime Coquelin wrote:
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index 97d07ed..cfd9532 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -774,6 +774,28 @@ config ARCH_OMAP1
> >  	help
> >  	  Support for older TI OMAP1 (omap7xx, omap15xx or omap16xx)
> > =20
> > +config ARCH_STM32
> > +	bool "STMicrolectronics STM32"
> > +	depends on !MMU
> > +	select ARCH_REQUIRE_GPIOLIB
> > +	select ARM_NVIC
> > +	select AUTO_ZRELADDR
> > +	select ARCH_HAS_RESET_CONTROLLER
> > +	select RESET_CONTROLLER
> > +	select PINCTRL
> > +	select PINCTRL_STM32
> > +	select CLKSRC_OF
> > +	select ARMV7M_SYSTICK
> > +	select COMMON_CLK
> > +	select CPU_V7M
> > +	select GENERIC_CLOCKEVENTS
> > +	select NO_DMA
> > +	select NO_IOPORT_MAP
> > +	select SPARSE_IRQ
> > +	select USE_OF
> Please sort this list alphabetically.

And drop
    select NO_DMA

You copied that from ARCH_EFM32, but it's pointless on arm (as arch/arm=
/
doesn't provide a NO_DMA Kconfig symbol).

I submitted a patch last year to drop it from ARCH_EFM32, which Uwe
Acked, but then nothing happened. I'm to blame, as I should have sent a
reminder.

> > +	help
> > +	  Support for STMicorelectronics STM32 processors.
> > +
> >  endchoice
> > =20
> >  menu "Multiple platform selection"


Paul Bolle
