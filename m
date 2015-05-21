From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Subject: Re: [PATCH v8 07/16] drivers: reset: Add STM32 reset driver
Date: Thu, 21 May 2015 19:58:28 +0200
Message-ID: <555E1CC4.9090605@suse.de>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com> <1431158038-3813-8-git-send-email-mcoquelin.stm32@gmail.com> <555D1C7D.1060205@suse.de> <CALszF6CrouFF3oS_Qz6+qQRqa4a5PurdYNdvHnZRDb4zwOJ6mQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CALszF6CrouFF3oS_Qz6+qQRqa4a5PurdYNdvHnZRDb4zwOJ6mQ@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>, Stefan Agner <stefan@agner.ch>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Peter Meerwald <pmeerw@pmeerw.net>, Lee Jones <lee.jones@linaro.org>, Linux-Arch <linux-arch@vger.kernel.org>, Daniel Thompson <daniel.thompson@linaro.org>, Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>, Jonathan Corbet <corbet@lwn.net>, Jiri Slaby <jslaby@suse.cz>, Daniel Lezcano <daniel.lezcano@linaro.org>, Chanwoo Choi <cw00.choi@samsung.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Antti Palosaari <crope@iki.fi>, Geert Uytterhoeven <geert@linux-m68k.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
List-Id: linux-api@vger.kernel.org

Am 21.05.2015 um 09:46 schrieb Maxime Coquelin:
> 2015-05-21 1:45 GMT+02:00 Andreas F=E4rber <afaerber@suse.de>:
>> Am 09.05.2015 um 09:53 schrieb Maxime Coquelin:
>>> +static const struct of_device_id stm32_reset_dt_ids[] =3D {
>>> +      { .compatible =3D "st,stm32-rcc", },
>>> +      { /* sentinel */ },
>>> +};
>>> +MODULE_DEVICE_TABLE(of, sstm32_reset_dt_ids);
>>
>> Typo.
>=20
> Indeed, thanks for pointing this out.
>=20
>>
>> IIUC the timer depends on the reset controller, so it must be built =
in
>> anyway, and that's what's enforced in the Makefile above. Drop the l=
ine?
>>
>=20
> Agree it must be built-in.
> I will fix that in next version.

Actually, I've updated a timer implementation of mine to invoke a reset
controller similar to how you do in the STM32 clocksource patch, but no
reset controller is getting returned.

It seems to me, you are working around that by simply ignoring the erro=
r
in the timer code and not doing a reset then, so the STM32 timer does i=
n
fact _not_ depend on the reset controller? What happened to your effort=
s
of making the reset controller usable for the timer? In my case, my
timer is originally in reset state and needs to be deasserted, so I
can't just ignore it.

Regards,
Andreas

--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Felix Imend=F6rffer, Jane Smithard, Dilip Upmanyu, Graham Norton; H=
RB
21284 (AG N=FCrnberg)
