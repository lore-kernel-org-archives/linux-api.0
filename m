From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v8 09/16] clockevents/drivers: Add STM32 Timer driver
Date: Tue, 19 May 2015 10:55:56 +0200
Message-ID: <CALszF6CwGuKqgbX6gVrya1-_YOgvtrgC7pVqKTNjCRif_o532A@mail.gmail.com>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1431158038-3813-10-git-send-email-mcoquelin.stm32@gmail.com>
	<5559E4B0.70506@linaro.org>
	<CALszF6CK7axU0qrWNf38aqrt2R2126ZACn7wx5jNY_1KE+4H+g@mail.gmail.com>
	<555AF143.2060807@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <555AF143.2060807@linaro.org>
Sender: linux-arch-owner@vger.kernel.org
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Lee Jones <lee.jones@linaro.org>, Daniel Thompson <daniel.thompson@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@he>
List-Id: linux-api@vger.kernel.org

2015-05-19 10:16 GMT+02:00 Daniel Lezcano <daniel.lezcano@linaro.org>:
> On 05/18/2015 04:03 PM, Maxime Coquelin wrote:
>>
>> 2015-05-18 15:10 GMT+02:00 Daniel Lezcano <daniel.lezcano@linaro.org=
>:
>>>
>>> On 05/09/2015 09:53 AM, Maxime Coquelin wrote:
>>>>
>>>>
>>>> STM32 MCUs feature 16 and 32 bits general purpose timers with
>>>> prescalers.
>>>> The drivers detects whether the time is 16 or 32 bits, and applies=
 a
>>>> 1024 prescaler value if it is 16 bits.
>>>>
>>>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>>>> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>>>> ---
>>>>    drivers/clocksource/Kconfig       |   8 ++
>>>>    drivers/clocksource/Makefile      |   1 +
>>>>    drivers/clocksource/timer-stm32.c | 184
>>>> ++++++++++++++++++++++++++++++++++++++
>>>>    3 files changed, 193 insertions(+)
>>>>    create mode 100644 drivers/clocksource/timer-stm32.c
>>>>
>>>> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kco=
nfig
>>>> index bf9364c..2443520 100644
>>>> --- a/drivers/clocksource/Kconfig
>>>> +++ b/drivers/clocksource/Kconfig
>>>> @@ -106,6 +106,14 @@ config CLKSRC_EFM32
>>>>            Support to use the timers of EFM32 SoCs as clock source=
 and
>>>> clock
>>>>            event device.
>>>>
>>>> +config CLKSRC_STM32
>>>> +       bool "Clocksource for STM32 SoCs" if !ARCH_STM32
>>>> +       depends on OF && ARM && (ARCH_STM32 || COMPILE_TEST)
>>>
>>>
>>>
>>> Are the interactive bool and the 'COMPILE_TEST' necessary ?
>>>
>>
>> The interactive bool is necessary if we want to be able to
>> select/deselect it in COMPILE_TEST configuration.
>> And personnaly, I think COMPILE_TEST use makes sense.
>>
>> Note that other timer drivers are doing the same thing today
>> (CLKSRC_EFM32, SH_TIMER_CMT, EM_TIMER_STI...).
>>
>> Do you have a specific concern regarding COMPILE_TEST?
>
>
> Actually, we try to keep the timer selection non-interactive and let =
the
> platform's Kconfig to select the timer.

Ok.

>
> I like when the code is consistent. The COMPILE_TEST was introduced a=
nd
> created a precedence. I would like to get rid of the interactive time=
r
> selection but I did not have time to go through this yet.

Indeed, consistency is important.
On my side, I don't have a strong opinion regarding the COMPILE_TEST th=
ing.
IMHO, it is more a subsystem's maintainer choice.

So, if as a maintainer you don't use it and prefer not supporting it,
I'm fine to provide you a new version without COMPILE_TEST.
Doing that, the interactive selection will disappear too.

I can provide you a new version this evenning.

Best regards,
Maxime

>
>
>
> --
>  <http://www.linaro.org/> Linaro.org =E2=94=82 Open source software f=
or ARM SoCs
>
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
>
