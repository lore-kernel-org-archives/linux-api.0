From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 03/14] clocksource: Add ARM System timer driver
Date: Mon, 16 Feb 2015 13:21:01 +0100
Message-ID: <CALszF6DySx-j8hrXoSRC7uo7BcFQXgOu0SJD1q3NHKoD-NxhKQ@mail.gmail.com>
References: <1423763164-5606-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1423763164-5606-4-git-send-email-mcoquelin.stm32@gmail.com>
	<54E12F39.6030509@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54E12F39.6030509-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>
Cc: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Nikolay Borisov <Nikolay.Borisov-5wv7dgnIgG8@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Kees
List-Id: linux-api@vger.kernel.org

2015-02-16 0:43 GMT+01:00 Andreas F=C3=A4rber <afaerber-l3A5Bk7waGM@public.gmane.org>:
> Am 12.02.2015 um 18:45 schrieb Maxime Coquelin:
>> This patch adds clocksource support for ARMv7-M's System timer,
>> also known as SysTick.
>>
>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  .../devicetree/bindings/arm/system_timer.txt       | 15 +++++
>>  drivers/clocksource/Kconfig                        |  7 ++
>>  drivers/clocksource/Makefile                       |  1 +
>>  drivers/clocksource/arm_system_timer.c             | 74 +++++++++++=
+++++++++++
>>  4 files changed, 97 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/arm/system_tim=
er.txt
>>  create mode 100644 drivers/clocksource/arm_system_timer.c
>>
>> diff --git a/Documentation/devicetree/bindings/arm/system_timer.txt =
b/Documentation/devicetree/bindings/arm/system_timer.txt
>> new file mode 100644
>> index 0000000..35268b7
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/system_timer.txt
>> @@ -0,0 +1,15 @@
>> +* ARM System Timer
>> +
>> +ARMv7-M includes a system timer, known as SysTick. Current driver o=
nly
>> +implements the clocksource feature.
>> +
>> +Required properties:
>> +- compatible : Should be "arm,armv7m-systick"
>> +- reg             : The address range of the timer
>> +- clocks     : The input clock of the timer
>> +
>> +systick: system-timer {
>> +     compatible =3D "arm,armv7m-systick";
>> +     reg =3D <0xe000e010 0x10>;
>> +     clocks =3D <&clk_systick>;
>> +};
>
> Binding documentation is supposed to go into its own patch:
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree=
/Documentation/devicetree/bindings/submitting-patches.txt
Ok, will change this in the v2.

>
=2E..
>
> I've used a SysTick based implementation on my stm32 branch myself, b=
ut
> looking at efm32 I got the impression that it would be better to use =
one
> of the 32-bit TIM2/TIM5 as clocksource and the other as clockevents?
>
> Still this implementation will be handy to have, also for other targe=
ts.

My view is that we should use as much generic parts of the Cortex-M as =
possible.
Moreover, doing, that, we can keep one more IP instance under reset
with associated clock gated,
and so maybe reduce the power consumption a little (I haven't done any
measurements)

Do you see a case where it could be better to use the STM32 timers?


Thanks,
Maxime
>
> Regards,
> Andreas
>
> --
> SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Jennifer Guild, Dilip Upma=
nyu,
> Graham Norton; HRB 21284 (AG N=C3=BCrnberg)
