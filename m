From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Subject: Re: [PATCH v8 07/16] drivers: reset: Add STM32 reset driver
Date: Fri, 22 May 2015 00:01:03 +0200
Message-ID: <555E559F.8040403@suse.de>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>	<1431158038-3813-8-git-send-email-mcoquelin.stm32@gmail.com>	<555D1C7D.1060205@suse.de>	<CALszF6CrouFF3oS_Qz6+qQRqa4a5PurdYNdvHnZRDb4zwOJ6mQ@mail.gmail.com>	<555E1CC4.9090605@suse.de> <CALszF6Bhc1MkDaqM3oJ93Rrxxbsss7=FA8WUpbtwmDERUdD0KA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <CALszF6Bhc1MkDaqM3oJ93Rrxxbsss7=FA8WUpbtwmDERUdD0KA@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Kamil Lulko <rev13@wp.pl>, Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Mark Rutland <mark.rutland@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>, Stefan Agner <stefan@agner.ch>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Peter Meerwald <pmeerw@pmeerw.net>, Lee Jones <lee.jones@linaro.org>, Linux-Arch <linux-arch@vger.kernel.org>, Daniel Thompson <daniel.thompson@linaro.org>, Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>, Jonathan Corbet <corbet@lwn.net>, Jiri Slaby <jslaby@suse.cz>, Daniel Lezcano <daniel.lezcano@linaro.org>, Chanwoo Choi <cw00.choi@samsung.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Antti Palosaari <crope@iki.fi>, Geert Uytterhoeven <geert@linux-m68k.org>, "linux-serial@vger.kernel.org" <linux-serial>
List-Id: linux-api@vger.kernel.org

Am 21.05.2015 um 21:57 schrieb Maxime Coquelin:
> 2015-05-21 19:58 GMT+02:00 Andreas F=C3=A4rber <afaerber@suse.de>:
>> Actually, I've updated a timer implementation of mine to invoke a re=
set
>> controller similar to how you do in the STM32 clocksource patch, but=
 no
>> reset controller is getting returned.
>>
>> It seems to me, you are working around that by simply ignoring the e=
rror
>> in the timer code and not doing a reset then, so the STM32 timer doe=
s in
>> fact _not_ depend on the reset controller? What happened to your eff=
orts
>> of making the reset controller usable for the timer? In my case, my
>> timer is originally in reset state and needs to be deasserted, so I
>> can't just ignore it.
>=20
> Indeed, I made the reset optionnal in the clocksource patch since v3.
> Rob and Arnd said a lot of platform relies on such things are done by
> the bootloader [0].
> I decided to deassert timers reset at bootloader stage, and make it
> optionnal in clocksource driver.
> I made it optionnal in case we decide one day to move reset
> initialization before timer are initialized.
>=20
> Note that for now, I still use your bootloader.
> I have done the changes to reset the timers in the afboot-stm32.
> That's the reason why I asked you under which licence it is delivered
> few months ago.

Sorry, too many mails... The stm32 one is GPL-2.0, as parts of it were
derived from a U-Boot fork. (Personally I prefer GPL-2.0+; fm4 and
xmc4000 are MIT/X11.)

> I can share you the patch if you want, even if I understand it is mor=
e
> about the concept that you are reluctant.
>=20
> On my side, I plan to move to U-Boot soon, as Kamil Lulko added STM32
> support in mainline [1].

You're free to use any bootloader you like, but you will find it
difficult to build in USB etc. drivers given the sheer size of U-Boot.
That was my motivation for writing the tiny one. ;)

> In case of U-Boot, the timer reset should be de-asserted when jumping
> into the Kernel, as Rob mentionned [0].

Thanks, I've updated the xmc4000 one accordingly and can do the same fo=
r
stm32. But you are right that I consider that an ugly workaround,
although on the other hand my earlyprintk patches also depend on the
bootloader setting up GPIOs and UART.

Regards,
Andreas

--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Dilip Upmanyu, Graham Norton=
; HRB
21284 (AG N=C3=BCrnberg)
