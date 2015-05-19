From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v8 09/16] clockevents/drivers: Add STM32 Timer driver
Date: Tue, 19 May 2015 14:56:43 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1505191455540.4225@nanos>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com> <1431158038-3813-10-git-send-email-mcoquelin.stm32@gmail.com> <5559E4B0.70506@linaro.org> <CALszF6CK7axU0qrWNf38aqrt2R2126ZACn7wx5jNY_1KE+4H+g@mail.gmail.com> <555AF143.2060807@linaro.org>
 <CALszF6CwGuKqgbX6gVrya1-_YOgvtrgC7pVqKTNjCRif_o532A@mail.gmail.com> <555AFD18.2070009@linaro.org> <CALszF6Asfke0-cMQJcEQ8ya+rbPPPhUc6aXTZXQvQ8QF66cwYQ@mail.gmail.com> <555B098A.8030202@linaro.org>
 <CALszF6AJ3Zf598wYeUx=iNWHHKT24xUyfagB=+4GocwZ-Fd-0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <CALszF6AJ3Zf598wYeUx=iNWHHKT24xUyfagB=+4GocwZ-Fd-0g@mail.gmail.com>
Sender: linux-gpio-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Lee Jones <lee.jones@linaro.org>, Daniel Thompson <daniel.thompson@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.r>
List-Id: linux-api@vger.kernel.org

On Tue, 19 May 2015, Maxime Coquelin wrote:
> 2015-05-19 11:59 GMT+02:00 Daniel Lezcano <daniel.lezcano@linaro.org>:
> >> Is the below Kconfig entry fine for you?
> >>
> >> config CLKSRC_STM32
> >>      def_bool y if ARCH_STM32
> >>      select CLKSRC_MMIO
> >
> >
> > config CLKSRC_STM32
> >         bool
> >         select CLKSRC_MMIO
> >
> > and in the arch/arm/mach-stm32/Kconfig add select CLKSRC_STM32
> 
> Ok, I will send a patch for arch/arm/Kconfig, as Arnd already applied
> the one intruducing ARCH_STM32.

Folks, can you please trim your replies. It's a PITA to scroll down
through several pages to find a single line of content.

Thanks,

	tglx
