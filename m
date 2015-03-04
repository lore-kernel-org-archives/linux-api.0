From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v2 04/18] clocksource: Add ARM System timer driver
Date: Wed, 4 Mar 2015 13:08:02 +0100
Message-ID: <CALszF6AEThPrRe7c7nJ6q7yb2fhLMFuHJUV10sf=w0TMcqVVaw@mail.gmail.com>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1424455277-29983-5-git-send-email-mcoquelin.stm32@gmail.com>
	<20150220195437.GT19388@pengutronix.de>
	<1424468908.24292.10.camel@x220>
	<CALszF6Bm_Y4ZLednjpmP-hMix3gA23FwLm5hViEjr1QojUY+Mg@mail.gmail.com>
	<1425411786.2606.24.camel@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <1425411786.2606.24.camel@tiscali.nl>
Sender: linux-gpio-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti
List-Id: linux-api@vger.kernel.org

2015-03-03 20:43 GMT+01:00 Paul Bolle <pebolle@tiscali.nl>:
> Maxime Coquelin schreef op ma 02-03-2015 om 17:53 [+0100]:
>> Do you agree if I define it like this:
>>
>> config ARMV7M_SYSTICK
>>     bool "Clocksource driver for ARMv7-M System timer"
>>     depends on OF && (CPU_V7M || COMPILE_TEST)
>>     select CLKSRC_OF
>>     select CLKSRC_MMIO
>>     help
>>       This options enables clocksource support for the ARMv7-M system
>>       timer unit.
>
> I don't really have strong feelings on whatever way you choose to fix
> the, well, minor problem I pointed out.
>
> Having said that, if a Kconfig entry without a prompt (and therefor,
> without help) actually does what you want it to do, why bother adding a
> prompt and a one line help text?

This is because I added also support for COMPILE_TEST coverage as per
Uwe advice,
and thought it was necessary to have an entry for this.
Maybe I'm just wrong?

Thanks,
Maxime

>
>
> Paul Bolle
>
