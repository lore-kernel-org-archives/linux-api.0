From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v2 02/18] ARM: ARMv7M: Enlarge vector table to 256 entries
Date: Thu, 26 Feb 2015 11:29:52 +0100
Message-ID: <CALszF6B6A=de_TK0e-iJHuW4MfD9xbd-yHZHaD-JmZXwZ9CW2A@mail.gmail.com>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1424455277-29983-3-git-send-email-mcoquelin.stm32@gmail.com>
	<20150220194756.GS19388@pengutronix.de>
	<CALszF6CB9YU7ashQ-y_zx58Mkf=sbrBfa2dAOdQm7FkmcuE7PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CALszF6CB9YU7ashQ-y_zx58Mkf=sbrBfa2dAOdQm7FkmcuE7PA@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm>
List-Id: linux-api@vger.kernel.org

2015-02-23 11:33 GMT+01:00 Maxime Coquelin <mcoquelin.stm32@gmail.com>:
> 2015-02-20 20:47 GMT+01:00 Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pen=
gutronix.de>:
>> On Fri, Feb 20, 2015 at 07:01:01PM +0100, Maxime Coquelin wrote:
>>> From Cortex-M reference manuals, the nvic supports up to 240 interr=
upts.
>>> So the number of entries in vectors table is up to 256.
>>>
>>> This patch adds a new config flag to specify the number of external=
 interrupts.
>>> Some ifdeferies are added in order to respect the natural alignment=
 without
>>> wasting too much space on smaller systems.
>>>
>>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>>> ---
>>>  arch/arm/kernel/entry-v7m.S | 13 +++++++++----
>>>  arch/arm/mm/Kconfig         | 15 +++++++++++++++
>>>  2 files changed, 24 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/arm/kernel/entry-v7m.S b/arch/arm/kernel/entry-v7=
m.S
>>> index 8944f49..68cde36 100644
>>> --- a/arch/arm/kernel/entry-v7m.S
>>> +++ b/arch/arm/kernel/entry-v7m.S
>>> @@ -117,9 +117,14 @@ ENTRY(__switch_to)
>>>  ENDPROC(__switch_to)
>>>
>>>       .data
>>> -     .align  8
>>> +#if CONFIG_CPUV7M_NUM_IRQ <=3D 112
>> I would have called this CONFIG_CPU_V7M_NUM_IRQ to match the already
>> existing CPU_V7M symbol.
>
> That's better indeed.
> It will be changed in v3.
>
>>
>>> +     .align  9
>>> +#else
>>> +     .align  10
>>> +#endif
>>> +
>>
>> Other than that:
>> Acked-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
>>
>> Who do you target to apply this series?
>
> I guess it should go through Russell's Patch Tracking System?

Sorry, I answered your question too quickly.
I meant this patch should go through Russell's Patch Tracking System.

=46or the other patches, I think it should be picked by their respectiv=
e
maintainers.
Or I can create an immutable tag (on github or kernel.org?) that will
be merged by the different sub-systems?
What would you advise?

Thanks,
Maxime

>
> Thanks,
> Maxime
>>
>> Best regards
>> Uwe
>>
>> --
>> Pengutronix e.K.                           | Uwe Kleine-K=C3=B6nig  =
          |
>> Industrial Linux Solutions                 | http://www.pengutronix.=
de/  |
