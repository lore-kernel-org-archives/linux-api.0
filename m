From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v5 10/15] serial: stm32-usart: Add STM32 USART Driver
Date: Tue, 7 Apr 2015 09:56:42 +0200
Message-ID: <CALszF6CFBm5jJUF95K=6_gRHijSk3Addpw13_q3Li-i8fqP6tA@mail.gmail.com>
References: <1428080481-18591-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1428080481-18591-11-git-send-email-mcoquelin.stm32@gmail.com>
	<1428083006.13180.35.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <1428083006.13180.35.camel@perches.com>
Sender: linux-gpio-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linu>
List-Id: linux-api@vger.kernel.org

2015-04-03 19:43 GMT+02:00 Joe Perches <joe@perches.com>:
> On Fri, 2015-04-03 at 19:01 +0200, Maxime Coquelin wrote:
>> This drivers adds support to the STM32 USART controller, which is a
>> standard serial driver.
>
> trivia:
>
>> diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
> []
>> +static struct uart_ops stm32_uart_ops = {
>
> could be const

i would even say, should be const.

>
> and it could be updated in a separate patch later too.
>

Nope, I will send another version anyway, so it will be part of the v6.

Thanks for the review,
Maxime
