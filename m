From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v8 14/16] ARM: dts: Introduce STM32F429 MCU
Date: Wed, 13 May 2015 13:45:36 +0200
Message-ID: <CALszF6CS8Q9DWX+ERtu=k=Bzr1-25N3oZQyWyxDZBF3an4nFKQ@mail.gmail.com>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1431158038-3813-15-git-send-email-mcoquelin.stm32@gmail.com>
	<2789447.8FUTAOJOHR@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <2789447.8FUTAOJOHR@wuerfel>
Sender: linux-doc-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Daniel Thompson <daniel.thompson@linaro.org>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Joe Perches <joe@perches.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Lee Jones <lee.jones@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak>
List-Id: linux-api@vger.kernel.org

2015-05-12 23:21 GMT+02:00 Arnd Bergmann <arnd@arndb.de>:
> On Saturday 09 May 2015 09:53:56 Maxime Coquelin wrote:
>> +#include  <dt-bindings/mfd/stm32f4-rcc.h>
>> +
>>
>
> Can you find a way to avoid this dependency?
>
> Maybe you can change the bindings so that the numbers you pass as
> arguments to the reset and clock specifiers reflect the numbers that
> the hardware use?

If I understand correctly, you prefer the way I did in v7 [0]?

I don't have a strong opinion on this. Either way is fine to me.

I changed the bindings in the v8 after discussions with Daniel
Thompson, who is implementing the clock driver part of the RCC IP.

He proposed we used common defines, because each peripheral has a
reset line and a clock gate.
Both reset and clock are represented as a single bit, with only the
base offset differing between clock and reset.
You can have a look at chapter 6 of the reference manual [1] if you
find some time.

Having common defines between clocks and reset make sense to me, but I
also understand your point of avoiding dependencies.

Maybe I can revert back to v7 bindings for now, and then we can
reconsider using common defines when Daniel will send the clock
patches.
Note that doing that won't break the DT binary compatibility, as the
raw reset values, or the ones from defines are the same.

Daniel, could you share an example of the bindings you would use for the clocks?

Kind regards,
Maxime

>
>         Arnd

[0]: http://lkml.iu.edu/hypermail/linux/kernel/1504.3/04523.html
[1]: http://www.st.com/web/en/resource/technical/document/reference_manual/DM00031020.pdf
