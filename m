From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH 06/14] drivers: reset: Add STM32 reset driver
Date: Mon, 16 Feb 2015 13:25:24 +0100
Message-ID: <CALszF6Cc8CZk-tBQzB-YSsPNDhufoewBzEFz+uRHXqCsQG4BkQ@mail.gmail.com>
References: <1423763164-5606-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1423763164-5606-7-git-send-email-mcoquelin.stm32@gmail.com>
	<54E132D6.6010608@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <54E132D6.6010608@suse.de>
Sender: linux-arch-owner@vger.kernel.org
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Philipp Zabel <p.zabel@pengutronix.de>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees
List-Id: linux-api@vger.kernel.org

2015-02-16 0:59 GMT+01:00 Andreas F=C3=A4rber <afaerber@suse.de>:
> Am 12.02.2015 um 18:45 schrieb Maxime Coquelin:
>> The STM32 MCUs family IP can be reset by accessing some shared regis=
ters.
>>
>> The specificity is that some reset lines are used by the timers.
>> At timer initialization time, the timer has to be reset, that's why
>> we cannot use a regular driver.
>>
>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>> ---
>>  .../devicetree/bindings/reset/st,stm32-reset.txt   |  19 ++++
>>  drivers/reset/Makefile                             |   1 +
>>  drivers/reset/reset-stm32.c                        | 124 ++++++++++=
+++++++++++
>>  3 files changed, 144 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/reset/st,stm32=
-reset.txt
>>  create mode 100644 drivers/reset/reset-stm32.c
>>
>> diff --git a/Documentation/devicetree/bindings/reset/st,stm32-reset.=
txt b/Documentation/devicetree/bindings/reset/st,stm32-reset.txt
>> new file mode 100644
>> index 0000000..add1298
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/reset/st,stm32-reset.txt
>> @@ -0,0 +1,19 @@
>> +STMicroelectronics STM32 Peripheral Reset Controller
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>> +
>> +Please also refer to reset.txt in this directory for common reset
>> +controller binding usage.
>> +
>> +Required properties:
>> +- compatible: Should be "st,stm32-reset"
>> +- reg: should be register base and length as documented in the
>> +  datasheet
>> +- #reset-cells: 1, see below
>> +
>> +example:
>> +
>> +reset_ahb1: reset@40023810 {
>> +     #reset-cells =3D <1>;
>> +     compatible =3D "st,stm32-reset";
>> +     reg =3D <0x40023810 0x4>;
>> +};
> [snip]
>
> RM0090 has two different chapters on the RCC IP:
> * Reset and clock control for STM32F42xxx and STM32F43xxx (RCC)
> * Reset and clock control for STM32F405xx/07xx and STM32F415xx/17xx(R=
CC)
>
> I therefore feel it is wrong to use "stm32-" here; instead I used
> "st,stm32f429-rcc" (also relates to 12/14 discussion). This may apply=
 to
> other identifiers, too.

In this first version, the reset driver was really generic, and was
compatible with the STM32 family.
The only difference would have been in the device trees.

Now, from the discussion with Philipp, I will reconsider the
implementation to add some named constants,
so maybe I will reconsider the compatible, it will depend on how I
will implement it.

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
