From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 03/14] clocksource: Add ARM System timer driver
Date: Mon, 16 Feb 2015 13:08:35 +0100
Message-ID: <CALszF6Ado887mceaYV1y0054qKGPHrJ+fiC82bx+SQVUV_eybw@mail.gmail.com>
References: <1423763164-5606-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1423763164-5606-4-git-send-email-mcoquelin.stm32@gmail.com>
	<CAL_JsqKoT_rWzt6ZCQXwg-NxM_Mnuqy6UwmPKBRodBCf0i7zyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_JsqKoT_rWzt6ZCQXwg-NxM_Mnuqy6UwmPKBRodBCf0i7zyg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Nikolay Borisov <Nikolay.Borisov-5wv7dgnIgG8@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Kees
List-Id: linux-api@vger.kernel.org

2015-02-15 23:31 GMT+01:00 Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Thu, Feb 12, 2015 at 11:45 AM, Maxime Coquelin
> <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> This patch adds clocksource support for ARMv7-M's System timer,
>> also known as SysTick.
>>
>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  .../devicetree/bindings/arm/system_timer.txt       | 15 +++++
>
> Please include v7M in the name. System timer sounds very generic. This
> is the only timer architecturally defined IIRC, so perhaps just
> "armv7m_systick".

Ok, let's go for "armv7m_systick".

>
>>  drivers/clocksource/Kconfig                        |  7 ++
>>  drivers/clocksource/Makefile                       |  1 +
>>  drivers/clocksource/arm_system_timer.c             | 74 ++++++++++++++++++++++
>
> Same here.

Agree, will be in the v2.

>
>
>>  4 files changed, 97 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/arm/system_timer.txt
>>  create mode 100644 drivers/clocksource/arm_system_timer.c
>>
>> diff --git a/Documentation/devicetree/bindings/arm/system_timer.txt b/Documentation/devicetree/bindings/arm/system_timer.txt
>> new file mode 100644
>> index 0000000..35268b7
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/system_timer.txt
>> @@ -0,0 +1,15 @@
>> +* ARM System Timer
>> +
>> +ARMv7-M includes a system timer, known as SysTick. Current driver only
>> +implements the clocksource feature.
>> +
>> +Required properties:
>> +- compatible : Should be "arm,armv7m-systick"
>> +- reg       : The address range of the timer
>> +- clocks     : The input clock of the timer
>
> You may want to consider supporting "clock-frequency" here too. In
> more simple chips you may just have fixed clocks and may want to run a
> kernel with COMMON_CLK disabled for size savings.

Ok, I will add this option in the v2.

>
>> +
>> +systick: system-timer {
>
> This should be "systick: timer@e000e010".
>
> Same for your dts file.

Right, it will be fixed in the v2.

Thanks for the review,
Maxime
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
