From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v8 09/16] clockevents/drivers: Add STM32 Timer driver
Date: Tue, 19 May 2015 15:50:07 +0100
Message-ID: <20150519145006.GH2067@n2100.arm.linux.org.uk>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
 <555B098A.8030202@linaro.org>
 <CALszF6AJ3Zf598wYeUx=iNWHHKT24xUyfagB=+4GocwZ-Fd-0g@mail.gmail.com>
 <6177628.0ZDPLeVyah@wuerfel>
 <CALszF6BZKD-CPTZ6Hc85wv2Z3Y7JmUv-cMkBtbk2Ga6WeeWU=A@mail.gmail.com>
 <555B3F80.8070605@linaro.org>
 <CALszF6A-De6dvcRNoa9ruL+y6Wt_rc7bi-O-VxHWkFF9NSt5_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALszF6A-De6dvcRNoa9ruL+y6Wt_rc7bi-O-VxHWkFF9NSt5_g@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Joe Perches <joe@perches.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Lee Jones <lee.jones@linaro.org>, Daniel Thompson <daniel.thompson@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devic>
List-Id: linux-api@vger.kernel.org

On Tue, May 19, 2015 at 04:41:58PM +0200, Maxime Coquelin wrote:
> 2015-05-19 15:49 GMT+02:00 Daniel Lezcano <daniel.lezcano@linaro.org>:
> >
> >
> > It is not exactly as the initial patch.
> >
> > I think Arnd is proposing:
> >
> > config CLKSRC_STM32
> >         bool "Clocksource for STM32 SoCs" if COMPILE_TEST
> >         select CLKSRC_MMIO
> >
> 
> Isn't "depends on OF" missing for COMPILE_TEST case?

config CLKSRC_STM32
	bool "Clocksource for STM32 SoCs" if COMPILE_TEST
	depends on OF
	select CLKSRC_MMIO

This permits CLKSRC_STM32 to be selected by STM32 (provided OF is enabled,
it's always going to be for that case, right?) while allowing the option
to be visible when both OF!=n and COMPILE_TEST!=n.

Remember,

	bool "string" if <condition-affects-visibility-of-string>
	depends on <condition-affects-config-symbol-availability>

The former merely hides the option from the user _if_ the condition fails.
The latter _disables_ the option completely (except if you try and select
it, at which point you end up with a Kconfig warning about that.)

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
