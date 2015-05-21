From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v8 07/16] drivers: reset: Add STM32 reset driver
Date: Thu, 21 May 2015 21:57:56 +0200
Message-ID: <CALszF6Bhc1MkDaqM3oJ93Rrxxbsss7=FA8WUpbtwmDERUdD0KA@mail.gmail.com>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1431158038-3813-8-git-send-email-mcoquelin.stm32@gmail.com>
	<555D1C7D.1060205@suse.de>
	<CALszF6CrouFF3oS_Qz6+qQRqa4a5PurdYNdvHnZRDb4zwOJ6mQ@mail.gmail.com>
	<555E1CC4.9090605@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <555E1CC4.9090605@suse.de>
Sender: linux-gpio-owner@vger.kernel.org
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Kamil Lulko <rev13@wp.pl>, Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>, Stefan Agner <stefan@agner.ch>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Peter Meerwald <pmeerw@pmeerw.net>, Lee Jones <lee.jones@linaro.org>, Linux-Arch <linux-arch@vger.kernel.org>, Daniel Thompson <daniel.thompson@linaro.org>, Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>, Jonathan Corbet <corbet@lwn.net>, Jiri Slaby <jslaby@suse.cz>, Daniel Lezcano <daniel.lezcano@linaro.org>, Chanwoo Choi <cw00.choi@samsung.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Antti Palosaari <crope@iki.fi>, Geert Uytterhoeven <geert@linux-m68k.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
List-Id: linux-api@vger.kernel.org

2015-05-21 19:58 GMT+02:00 Andreas F=C3=A4rber <afaerber@suse.de>:
> Am 21.05.2015 um 09:46 schrieb Maxime Coquelin:
>> 2015-05-21 1:45 GMT+02:00 Andreas F=C3=A4rber <afaerber@suse.de>:
>>> Am 09.05.2015 um 09:53 schrieb Maxime Coquelin:
>>>> +static const struct of_device_id stm32_reset_dt_ids[] =3D {
>>>> +      { .compatible =3D "st,stm32-rcc", },
>>>> +      { /* sentinel */ },
>>>> +};
>>>> +MODULE_DEVICE_TABLE(of, sstm32_reset_dt_ids);
>>>
>>> Typo.
>>
>> Indeed, thanks for pointing this out.
>>
>>>
>>> IIUC the timer depends on the reset controller, so it must be built=
 in
>>> anyway, and that's what's enforced in the Makefile above. Drop the =
line?
>>>
>>
>> Agree it must be built-in.
>> I will fix that in next version.
>
> Actually, I've updated a timer implementation of mine to invoke a res=
et
> controller similar to how you do in the STM32 clocksource patch, but =
no
> reset controller is getting returned.
>
> It seems to me, you are working around that by simply ignoring the er=
ror
> in the timer code and not doing a reset then, so the STM32 timer does=
 in
> fact _not_ depend on the reset controller? What happened to your effo=
rts
> of making the reset controller usable for the timer? In my case, my
> timer is originally in reset state and needs to be deasserted, so I
> can't just ignore it.

Indeed, I made the reset optionnal in the clocksource patch since v3.
Rob and Arnd said a lot of platform relies on such things are done by
the bootloader [0].
I decided to deassert timers reset at bootloader stage, and make it
optionnal in clocksource driver.
I made it optionnal in case we decide one day to move reset
initialization before timer are initialized.

Note that for now, I still use your bootloader.
I have done the changes to reset the timers in the afboot-stm32.
That's the reason why I asked you under which licence it is delivered
few months ago.
I can share you the patch if you want, even if I understand it is more
about the concept that you are reluctant.

On my side, I plan to move to U-Boot soon, as Kamil Lulko added STM32
support in mainline [1].
In case of U-Boot, the timer reset should be de-asserted when jumping
into the Kernel, as Rob mentionned [0].

Kind regards,
Maxime

[0]: https://lkml.org/lkml/2015/3/10/737
[1]: http://u-boot.10912.n7.nabble.com/PATCH-v2-stm32f4-fix-serial-outp=
ut-td212812.html
--
To unsubscribe from this list: send the line "unsubscribe linux-gpio" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
