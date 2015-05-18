From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v8 04/16] clocksource/drivers: Add ARM System timer driver
Date: Mon, 18 May 2015 14:57:08 +0200
Message-ID: <CALszF6A5Z0wDpBOFveVjL19sMPAuqfnQJ+CwSgfXygmx46s7tQ@mail.gmail.com>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1431158038-3813-5-git-send-email-mcoquelin.stm32@gmail.com>
	<CALszF6BiKwDKejfpVgs6ojTxC4LSRfLSEaszXTGVy7xfbHLHZg@mail.gmail.com>
	<5559DFD6.3050603@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <5559DFD6.3050603@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Lee Jones <lee.jones@linaro.org>, Daniel Thompson <daniel.thompson@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@he>
List-Id: linux-api@vger.kernel.org

2015-05-18 14:49 GMT+02:00 Daniel Lezcano <daniel.lezcano@linaro.org>:
> On 05/18/2015 01:55 PM, Maxime Coquelin wrote:
>>
>> Hi Daniel,
>>
>> 2015-05-09 9:53 GMT+02:00 Maxime Coquelin <mcoquelin.stm32@gmail.com=
>:
>>>
>>> This patch adds clocksource support for ARMv7-M's System timer,
>>> also known as SysTick.
>>>
>>> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>>> ---
>>>   drivers/clocksource/Kconfig          |  7 ++++
>>>   drivers/clocksource/Makefile         |  1 +
>>>   drivers/clocksource/armv7m_systick.c | 79
>>> ++++++++++++++++++++++++++++++++++++
>>>   3 files changed, 87 insertions(+)
>>>   create mode 100644 drivers/clocksource/armv7m_systick.c
>>>
>>
>> Could you consider applying this patch and its dt-bindings
>> documentation (patch 3/16) on your tree for v4.2?
>
>
> Patches applied for 4.2.

Thanks Daniel!

>
> Thanks
>
>   -- Daniel
>
> --
>  <http://www.linaro.org/> Linaro.org =E2=94=82 Open source software f=
or ARM SoCs
>
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
>
