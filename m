From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v4 10/15] serial: stm32-usart: Add STM32 USART Driver
Date: Wed, 1 Apr 2015 10:36:58 +0200
Message-ID: <CALszF6AKw-F1RVc5m2As7upp7ZuS7GpcJSoqixms3Dd4SNU9EQ@mail.gmail.com>
References: <1427819096-31109-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1427819096-31109-11-git-send-email-mcoquelin.stm32@gmail.com>
	<CAHp75VeUzKUEo7NCaXUYKBPpG7JYCykB+76Wu5tBKj750Bi+Qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CAHp75VeUzKUEo7NCaXUYKBPpG7JYCykB+76Wu5tBKj750Bi+Qg@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>
List-Id: linux-api@vger.kernel.org

Hello Andy,

2015-03-31 18:45 GMT+02:00 Andy Shevchenko <andy.shevchenko@gmail.com>:
> On Tue, Mar 31, 2015 at 7:24 PM, Maxime Coquelin
> <mcoquelin.stm32@gmail.com> wrote:
>> This drivers adds support to the STM32 USART controller, which is a
>> standard serial driver.
>>
>> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>
> Few minor comments below.

All your comments are valid, I will send a v5 shortly fixing this.

Thanks for the review,
Maxime

>
>> ---
>>  drivers/tty/serial/Kconfig       |  17 +
>>  drivers/tty/serial/Makefile      |   1 +
>>  drivers/tty/serial/stm32-usart.c | 743 +++++++++++++++++++++++++++++++++++++++
>>  include/uapi/linux/serial_core.h |   3 +
>>  4 files changed, 764 insertions(+)
>>  create mode 100644 drivers/tty/serial/stm32-usart.c
>>
