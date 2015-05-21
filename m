From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v8 07/16] drivers: reset: Add STM32 reset driver
Date: Thu, 21 May 2015 09:46:34 +0200
Message-ID: <CALszF6CrouFF3oS_Qz6+qQRqa4a5PurdYNdvHnZRDb4zwOJ6mQ@mail.gmail.com>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1431158038-3813-8-git-send-email-mcoquelin.stm32@gmail.com>
	<555D1C7D.1060205@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <555D1C7D.1060205@suse.de>
Sender: linux-gpio-owner@vger.kernel.org
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Joe Perches <joe@perches.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Lee Jones <lee.jones@linaro.org>, Daniel Thompson <daniel.thompson@linaro.org>, Mark Rutland <mark.rutland@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay
List-Id: linux-api@vger.kernel.org

2015-05-21 1:45 GMT+02:00 Andreas F=C3=A4rber <afaerber@suse.de>:
> Am 09.05.2015 um 09:53 schrieb Maxime Coquelin:
>> +static const struct of_device_id stm32_reset_dt_ids[] =3D {
>> +      { .compatible =3D "st,stm32-rcc", },
>> +      { /* sentinel */ },
>> +};
>> +MODULE_DEVICE_TABLE(of, sstm32_reset_dt_ids);
>
> Typo.

Indeed, thanks for pointing this out.

>
> IIUC the timer depends on the reset controller, so it must be built i=
n
> anyway, and that's what's enforced in the Makefile above. Drop the li=
ne?
>

Agree it must be built-in.
I will fix that in next version.

Thanks for the review,
Maxime
--
To unsubscribe from this list: send the line "unsubscribe linux-gpio" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
