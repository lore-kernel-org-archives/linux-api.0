From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v3 10/15] serial: stm32-usart: Add STM32 USART Driver
Date: Tue, 17 Mar 2015 18:39:33 +0100
Message-ID: <CALszF6BdgwDQgK_mefCJm9zaDGAfhjh1GYCtJp4awgVb0Es4fA@mail.gmail.com>
References: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>
	<1426197361-19290-11-git-send-email-maxime.coquelin@st.com>
	<1426239683.5304.59.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <1426239683.5304.59.camel@x220>
Sender: linux-gpio-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mch>
List-Id: linux-api@vger.kernel.org

2015-03-13 10:41 GMT+01:00 Paul Bolle <pebolle@tiscali.nl>:
> Just a license nit, I'm afraid.
Not a problem, it is not the last round anyway.

>
> On Thu, 2015-03-12 at 22:55 +0100, Maxime Coquelin wrote:
>> --- /dev/null
>> +++ b/drivers/tty/serial/stm32-usart.c
>> @@ -0,0 +1,695 @@
>> +/*
>> + * Copyright (C) Maxime Coquelin 2015
>> + * Author:  Maxime Coquelin <mcoquelin.stm32@gmail.com>
>> + * License terms:  GNU General Public License (GPL), version 2
>> + *
>> + * Inspired by st-asc.c from STMicroelectronics (c)
>> + */
>
> This states the license is GPL v2.
>
>> +MODULE_LICENSE("GPL");
>
> And
>     MODULE_LICENSE("GPL v2");
>
> would match that statement.

Right, it will be fixed in the v4.

Thanks,
Maxime
>
>
> Paul Bolle
>
