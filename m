From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v8 09/16] clockevents/drivers: Add STM32 Timer driver
Date: Tue, 19 May 2015 16:41:58 +0200
Message-ID: <CALszF6A-De6dvcRNoa9ruL+y6Wt_rc7bi-O-VxHWkFF9NSt5_g@mail.gmail.com>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
	<555B098A.8030202@linaro.org>
	<CALszF6AJ3Zf598wYeUx=iNWHHKT24xUyfagB=+4GocwZ-Fd-0g@mail.gmail.com>
	<6177628.0ZDPLeVyah@wuerfel>
	<CALszF6BZKD-CPTZ6Hc85wv2Z3Y7JmUv-cMkBtbk2Ga6WeeWU=A@mail.gmail.com>
	<555B3F80.8070605@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <555B3F80.8070605@linaro.org>
Sender: linux-gpio-owner@vger.kernel.org
To: Daniel Lezcano <daniel.lezcano@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Lee Jones <lee.jones@linaro.org>, Daniel Thompson <daniel.thompson@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <gal>
List-Id: linux-api@vger.kernel.org

2015-05-19 15:49 GMT+02:00 Daniel Lezcano <daniel.lezcano@linaro.org>:
>
>
> It is not exactly as the initial patch.
>
> I think Arnd is proposing:
>
> config CLKSRC_STM32
>         bool "Clocksource for STM32 SoCs" if COMPILE_TEST
>         select CLKSRC_MMIO
>

Isn't "depends on OF" missing for COMPILE_TEST case?

Other than that, I'm fine with the proposal.
Daniel, is it the case for you too?

Regards,
Maxime
