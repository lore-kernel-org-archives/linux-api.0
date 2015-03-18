From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2 11/18] pinctrl: Add pinctrl driver for STM32 MCUs
Date: Wed, 18 Mar 2015 02:08:13 +0100
Message-ID: <CACRpkdZA4OMB+gqh6XKfYWR8RSLZGpYjj-cgrC_KcSfcon4QVg@mail.gmail.com>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1424455277-29983-12-git-send-email-mcoquelin.stm32@gmail.com>
	<2464742.YZIRrHto62@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <2464742.YZIRrHto62@wuerfel>
Sender: linux-doc-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 10, 2015 at 4:08 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 20 February 2015 19:01:10 Maxime Coquelin wrote:

>> +/* Pull-Up/Down */
>> +#define NO_PULL                0
>> +#define PULL_UP                1
>> +#define PULL_DOWN      2
>> +
>> +/* Type */
>> +#define PUSH_PULL      (0 << 2)
>> +#define OPEN_DRAIN     (1 << 2)
>> +
>
> These should probably not be stm32 specific at all, they sound
> rather generic, so maybe put the definitions into a common file.

It's part of what GENERIC_PINCONF does and it has bindings
in Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt

Yours,
Linus Walleij
