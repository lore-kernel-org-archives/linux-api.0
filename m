From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v8 09/16] clockevents/drivers: Add STM32 Timer driver
Date: Tue, 19 May 2015 17:34:16 +0200
Message-ID: <CALszF6CRXst-4UwMYeDLxrN_3N4Z9q1dxAR7CzFyngeM6Qeqzw@mail.gmail.com>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
	<555B098A.8030202@linaro.org>
	<CALszF6AJ3Zf598wYeUx=iNWHHKT24xUyfagB=+4GocwZ-Fd-0g@mail.gmail.com>
	<6177628.0ZDPLeVyah@wuerfel>
	<CALszF6BZKD-CPTZ6Hc85wv2Z3Y7JmUv-cMkBtbk2Ga6WeeWU=A@mail.gmail.com>
	<555B3F80.8070605@linaro.org>
	<CALszF6A-De6dvcRNoa9ruL+y6Wt_rc7bi-O-VxHWkFF9NSt5_g@mail.gmail.com>
	<20150519145006.GH2067@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20150519145006.GH2067@n2100.arm.linux.org.uk>
Sender: linux-arch-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, Arnd Bergmann <arnd@arndb.de>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Joe Perches <joe@perches.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Lee Jones <lee.jones@linaro.org>, Daniel Thompson <daniel.thompson@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicet>
List-Id: linux-api@vger.kernel.org

2015-05-19 16:50 GMT+02:00 Russell King - ARM Linux <linux@arm.linux.org.uk>:
>
> config CLKSRC_STM32
>         bool "Clocksource for STM32 SoCs" if COMPILE_TEST
>         depends on OF
>         select CLKSRC_MMIO
>
> This permits CLKSRC_STM32 to be selected by STM32 (provided OF is enabled,
> it's always going to be for that case, right?) while allowing the option
> to be visible when both OF!=n and COMPILE_TEST!=n.

Yes OF is always enabled when STM32.

So it fits our needs, as we only want the option to be visible when
both OF!=n and COMPILE_TEST!=n.

>
> Remember,
>
>         bool "string" if <condition-affects-visibility-of-string>
>         depends on <condition-affects-config-symbol-availability>
>
> The former merely hides the option from the user _if_ the condition fails.
> The latter _disables_ the option completely (except if you try and select
> it, at which point you end up with a Kconfig warning about that.)

Thanks for the reminder!
Maxime
