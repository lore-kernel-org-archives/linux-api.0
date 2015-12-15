From: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v1 02/10] clockevents/drivers: add MPS2 Timer driver
Date: Tue, 15 Dec 2015 13:16:11 +0000
Message-ID: <5670129B.700@arm.com>
References: <1449048790-25859-1-git-send-email-vladimir.murzin@arm.com> <1449048790-25859-3-git-send-email-vladimir.murzin@arm.com> <CAL_Jsq+MhvV5BFw+x3TWTDheSpgWHjHjO02+D4V4swr493HXrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_Jsq+MhvV5BFw+x3TWTDheSpgWHjHjO02+D4V4swr493HXrg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber-l3A5Bk7waGM@public.gmane.org>, Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, Pawel Moll <Pawel.Moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TZUIDd8j+nm9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 14/12/15 13:56, Rob Herring wrote:
> On Wed, Dec 2, 2015 at 3:33 AM, Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org> wrote:
>> MPS2 platform has simple 32 bits general purpose countdown timers.
>>
>> The driver uses the first detected timer as a clocksource and the rest
>> of the timers as a clockevent
>>
>> Signed-off-by: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
>> ---
>>  drivers/clocksource/Kconfig      |    5 +
>>  drivers/clocksource/Makefile     |    1 +
>>  drivers/clocksource/mps2-timer.c |  277 ++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 283 insertions(+)
>>  create mode 100644 drivers/clocksource/mps2-timer.c
>>
>> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
>> index 2eb5f0e..8bca09c 100644
>> --- a/drivers/clocksource/Kconfig
>> +++ b/drivers/clocksource/Kconfig
>> @@ -137,6 +137,11 @@ config CLKSRC_STM32
>>         depends on OF && ARM && (ARCH_STM32 || COMPILE_TEST)
>>         select CLKSRC_MMIO
>>
>> +config CLKSRC_MPS2
>> +       bool "Clocksource for MPS2 SoCs" if COMPILE_TEST
>> +       depends on OF && ARM
> 
> Does this really depend on both of these for COMPILE_TEST?

Not really...

> 
> You need to select CLKSRC_OF rather than CLKSRC_MMIO as well.
> 

Does it looks better?

config CLKSRC_MPS2
	bool "Clocksource for MPS2 SoCs" if COMPILE_TEST
	depends on GENERIC_SCHED_CLOCK
	select CLKSRC_MMIO
	select CLKSRC_OF


Cheers
Vladimir

> Rob
> 
> 
> 
