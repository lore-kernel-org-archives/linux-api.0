From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH 08/14] pinctrl: Add pinctrl driver for STM32 MCUs
Date: Fri, 13 Feb 2015 09:43:43 +0100
Message-ID: <CALszF6D1LzvMqO_LibeWAZmdT=OiiWAvHurNQHCSv3d-Lo+qtA@mail.gmail.com>
References: <1423763164-5606-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1423763164-5606-9-git-send-email-mcoquelin.stm32@gmail.com>
	<CAMuHMdXfAENN5EB6nFJdf3bJPJ+=41Po22NKrQWdwkyf5nFXpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdXfAENN5EB6nFJdf3bJPJ+=41Po22NKrQWdwkyf5nFXpw@mail.gmail.com>
Sender: linux-gpio-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Philipp Zabel <p.zabel@pengutronix.de>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees
List-Id: linux-api@vger.kernel.org

2015-02-12 21:37 GMT+01:00 Geert Uytterhoeven <geert@linux-m68k.org>:
> On Thu, Feb 12, 2015 at 6:45 PM, Maxime Coquelin
> <mcoquelin.stm32@gmail.com> wrote:
>> --- a/drivers/pinctrl/Kconfig
>> +++ b/drivers/pinctrl/Kconfig
>> @@ -125,6 +125,15 @@ config PINCTRL_ST
>>         select PINCONF
>>         select GPIOLIB_IRQCHIP
>>
>> +config PINCTRL_STM32
>> +       bool "STMicroelectronics STM32 pinctrl driver"
>> +       depends on OF
>
> depends on ARCH_STM32 || COMPILE_TEST

Ok, I agree.

It will be part of the v2.

Thanks,
Maxime
