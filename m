From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v8 09/16] clockevents/drivers: Add STM32 Timer driver
Date: Tue, 19 May 2015 12:02:59 +0200
Message-ID: <CALszF6AJ3Zf598wYeUx=iNWHHKT24xUyfagB=+4GocwZ-Fd-0g@mail.gmail.com>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1431158038-3813-10-git-send-email-mcoquelin.stm32@gmail.com>
	<5559E4B0.70506@linaro.org>
	<CALszF6CK7axU0qrWNf38aqrt2R2126ZACn7wx5jNY_1KE+4H+g@mail.gmail.com>
	<555AF143.2060807@linaro.org>
	<CALszF6CwGuKqgbX6gVrya1-_YOgvtrgC7pVqKTNjCRif_o532A@mail.gmail.com>
	<555AFD18.2070009@linaro.org>
	<CALszF6Asfke0-cMQJcEQ8ya+rbPPPhUc6aXTZXQvQ8QF66cwYQ@mail.gmail.com>
	<555B098A.8030202@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <555B098A.8030202-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chanwoo Choi <cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Vladimir Zapolskiy <vladimir_zapolskiy-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree@he>
List-Id: linux-api@vger.kernel.org

2015-05-19 11:59 GMT+02:00 Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>:
> On 05/19/2015 11:44 AM, Maxime Coquelin wrote:
>>
>> 2015-05-19 11:06 GMT+02:00 Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org=
>:
>>>
>>> On 05/19/2015 10:55 AM, Maxime Coquelin wrote:
>>>>
>>>>
>>>> 2015-05-19 10:16 GMT+02:00 Daniel Lezcano <daniel.lezcano@linaro.o=
rg>:
>>>>>
>>>>>
>>>>> On 05/18/2015 04:03 PM, Maxime Coquelin wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> 2015-05-18 15:10 GMT+02:00 Daniel Lezcano <daniel.lezcano@linaro=
=2Eorg>:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On 05/09/2015 09:53 AM, Maxime Coquelin wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> STM32 MCUs feature 16 and 32 bits general purpose timers with
>>>>>>>> prescalers.
>>>>>>>> The drivers detects whether the time is 16 or 32 bits, and app=
lies a
>>>>>>>> 1024 prescaler value if it is 16 bits.
>>>>>>>>
>>>>>>>> Reviewed-by: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>>>>>> Tested-by: Chanwoo Choi <cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>>>>>>>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>>>>> ---
>>>>>>>>      drivers/clocksource/Kconfig       |   8 ++
>>>>>>>>      drivers/clocksource/Makefile      |   1 +
>>>>>>>>      drivers/clocksource/timer-stm32.c | 184
>>>>>>>> ++++++++++++++++++++++++++++++++++++++
>>>>>>>>      3 files changed, 193 insertions(+)
>>>>>>>>      create mode 100644 drivers/clocksource/timer-stm32.c
>>>>>>>>
>>>>>>>> diff --git a/drivers/clocksource/Kconfig
>>>>>>>> b/drivers/clocksource/Kconfig
>>>>>>>> index bf9364c..2443520 100644
>>>>>>>> --- a/drivers/clocksource/Kconfig
>>>>>>>> +++ b/drivers/clocksource/Kconfig
>>>>>>>> @@ -106,6 +106,14 @@ config CLKSRC_EFM32
>>>>>>>>              Support to use the timers of EFM32 SoCs as clock =
source
>>>>>>>> and
>>>>>>>> clock
>>>>>>>>              event device.
>>>>>>>>
>>>>>>>> +config CLKSRC_STM32
>>>>>>>> +       bool "Clocksource for STM32 SoCs" if !ARCH_STM32
>>>>>>>> +       depends on OF && ARM && (ARCH_STM32 || COMPILE_TEST)
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Are the interactive bool and the 'COMPILE_TEST' necessary ?
>>>>>>>
>>>>>>
>>>>>> The interactive bool is necessary if we want to be able to
>>>>>> select/deselect it in COMPILE_TEST configuration.
>>>>>> And personnaly, I think COMPILE_TEST use makes sense.
>>>>>>
>>>>>> Note that other timer drivers are doing the same thing today
>>>>>> (CLKSRC_EFM32, SH_TIMER_CMT, EM_TIMER_STI...).
>>>>>>
>>>>>> Do you have a specific concern regarding COMPILE_TEST?
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> Actually, we try to keep the timer selection non-interactive and =
let
>>>>> the
>>>>> platform's Kconfig to select the timer.
>>>>
>>>>
>>>>
>>>> Ok.
>>>>
>>>>>
>>>>> I like when the code is consistent. The COMPILE_TEST was introduc=
ed and
>>>>> created a precedence. I would like to get rid of the interactive =
timer
>>>>> selection but I did not have time to go through this yet.
>>>>
>>>>
>>>>
>>>> Indeed, consistency is important.
>>>> On my side, I don't have a strong opinion regarding the COMPILE_TE=
ST
>>>> thing.
>>>> IMHO, it is more a subsystem's maintainer choice.
>>>>
>>>> So, if as a maintainer you don't use it and prefer not supporting =
it,
>>>> I'm fine to provide you a new version without COMPILE_TEST.
>>>> Doing that, the interactive selection will disappear too.
>>>>
>>>> I can provide you a new version this evenning.
>>>
>>>
>>>
>>> Ok, great.
>>
>>
>> Is the below Kconfig entry fine for you?
>>
>> config CLKSRC_STM32
>>      def_bool y if ARCH_STM32
>>      select CLKSRC_MMIO
>
>
> config CLKSRC_STM32
>         bool
>         select CLKSRC_MMIO
>
> and in the arch/arm/mach-stm32/Kconfig add select CLKSRC_STM32

Ok, I will send a patch for arch/arm/Kconfig, as Arnd already applied
the one intruducing ARCH_STM32.

Thanks,
Maxime
>
>
>> Best regards,
>> Maxime
>>
>>
>>>
>>> Thanks
>>>    -- Daniel
>>>
>>>
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>>    <http://www.linaro.org/> Linaro.org =E2=94=82 Open source soft=
ware for ARM
>>>>> SoCs
>>>>>
>>>>> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
>>>>> <http://twitter.com/#!/linaroorg> Twitter |
>>>>> <http://www.linaro.org/linaro-blog/> Blog
>>>>>
>>>
>>>
>>> --
>>>   <http://www.linaro.org/> Linaro.org =E2=94=82 Open source softwar=
e for ARM SoCs
>>>
>>> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
>>> <http://twitter.com/#!/linaroorg> Twitter |
>>> <http://www.linaro.org/linaro-blog/> Blog
>>>
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
