From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v2 07/18] drivers: reset: Add STM32 reset driver
Date: Tue, 10 Mar 2015 16:44:24 +0100
Message-ID: <CALszF6D3XMkjkMTdS-1xnVMFzgAW53NNOKOsfztsCboTdsBaaw@mail.gmail.com>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1424455277-29983-8-git-send-email-mcoquelin.stm32@gmail.com>
	<2383270.cAJPOxrkvo@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <2383270.cAJPOxrkvo@wuerfel>
Sender: linux-doc-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj>
List-Id: linux-api@vger.kernel.org

2015-03-10 16:02 GMT+01:00 Arnd Bergmann <arnd@arndb.de>:
> On Friday 20 February 2015 19:01:06 Maxime Coquelin wrote:
>> +/* AHB1 */
>> +#define GPIOA_RESET    0
>> +#define GPIOB_RESET    1
>> +#define GPIOC_RESET    2
>> +#define GPIOD_RESET    3
>> +#define GPIOE_RESET    4
>> +#define GPIOF_RESET    5
>> +#define GPIOG_RESET    6
>> +#define GPIOH_RESET    7
>> +#define GPIOI_RESET    8
>> +#define GPIOJ_RESET    9
>> +#define GPIOK_RESET    10
>>
>
> As these are just the hardware numbers, it's better to not make them
> part of the binding at all. Instead, just document in the binding tha=
t
> one is supposed to pass the hardware number as the argument.

The reset controller is part of the RCC (Reset & Clock Controller) IP.
In this version, I only provided the reset registers to the reset
controller driver, but as per Andreas F=C3=A4rber remark, I should avec=
 a
single DT node for both the resets and clocks.

In the next version I am preparing, the defines doesn't look as
trivial as in this version, GPIOA_RESET being 128 for instance.

Is it fine for you if I keep the defines part of the binding?

Br,
Maxime
>
>         Arnd
