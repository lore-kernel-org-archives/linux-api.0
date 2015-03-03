From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v2 04/18] clocksource: Add ARM System timer driver
Date: Tue, 03 Mar 2015 20:43:06 +0100
Message-ID: <1425411786.2606.24.camel@tiscali.nl>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
	 <1424455277-29983-5-git-send-email-mcoquelin.stm32@gmail.com>
	 <20150220195437.GT19388@pengutronix.de> <1424468908.24292.10.camel@x220>
	 <CALszF6Bm_Y4ZLednjpmP-hMix3gA23FwLm5hViEjr1QojUY+Mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <CALszF6Bm_Y4ZLednjpmP-hMix3gA23FwLm5hViEjr1QojUY+Mg@mail.gmail.com>
Sender: linux-gpio-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, Andreas =?ISO-8859-1?Q?F=E4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti
List-Id: linux-api@vger.kernel.org

Maxime Coquelin schreef op ma 02-03-2015 om 17:53 [+0100]:
> Do you agree if I define it like this:
> 
> config ARMV7M_SYSTICK
>     bool "Clocksource driver for ARMv7-M System timer"
>     depends on OF && (CPU_V7M || COMPILE_TEST)
>     select CLKSRC_OF
>     select CLKSRC_MMIO
>     help
>       This options enables clocksource support for the ARMv7-M system
>       timer unit.

I don't really have strong feelings on whatever way you choose to fix
the, well, minor problem I pointed out.

Having said that, if a Kconfig entry without a prompt (and therefor,
without help) actually does what you want it to do, why bother adding a
prompt and a one line help text?


Paul Bolle

