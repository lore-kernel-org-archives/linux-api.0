From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v7 05/15] dt-bindings: Document the STM32 reset bindings
Date: Tue, 5 May 2015 19:22:17 +0200
Message-ID: <CALszF6CiLrdhKUJNRJApqzK8WsS9H22yHKbxha+Vp06-vZ+LHQ@mail.gmail.com>
References: <1430410844-16062-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1430410844-16062-6-git-send-email-mcoquelin.stm32@gmail.com>
	<55433467.2010603@linaro.org>
	<CALszF6Bw900E9MtpaVmvkFxsrOODRkNg+RxRXz5V3WghHtsxbw@mail.gmail.com>
	<5544A069.5000808@linaro.org>
	<CALszF6BTb0Ce6jfT5gY4eEtSep6+8XqOxu1LbpUXHmPYX9PmgQ@mail.gmail.com>
	<5548CEA2.8020807@linaro.org>
	<CALszF6DyUA7Wr2qo4sASFBTRwwjhGAkFKRYnY+1UwHmf4nTj5w@mail.gmail.com>
	<1430840557.3035.60.camel@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430840557.3035.60.camel@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Philipp Zabel <p.zabel@pengutronix.de>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Joe Perches <joe@perches.com>, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Thomas
List-Id: linux-api@vger.kernel.org

2015-05-05 17:42 GMT+02:00 Philipp Zabel <p.zabel@pengutronix.de>:
> Am Dienstag, den 05.05.2015, 17:19 +0200 schrieb Maxime Coquelin:
>> >> For example, includes/dt-bindings/mfd/stm32f4-rcc.h would look like:
>> >>
>> >> #define GPIOA 0
>> >> #define GPIOB 1
>> >> ...
>> >> #define LTDC 186
>
> That looks a bit fragile.
> At least the defines for the indices should be properly namespaced,
> check out include/dt-bindings/gpio/tegra-gpio.h for a similar case.

Thanks, I will prefix them with the proper namespace, Daniel proposal
is fine to me.

>
>> >> #define STM32F4_RESET(x) (x + 128)
>> >> #define STM32F4_CLOCK(x) (x + 384)
>> >>
>> >> Then, in DT, a reset would be described like this:
>> >>
>> >> timer2 {
>> >>      resets = <&rcc STM32F4_RESET(TIM2)>;
>> >> };
>> >>
>> >> Phillip, Daniel, does that look acceptable to you?
>> >
>> >
>> > Doesn't look unreasonable.
>> >
>> > I am a little uneasy simply because there are very few similar header files
>> > in that directory but I haven't thought of a better idea.
>>
>> Since this file will be shared by both clock and reset drivers, I
>> don't see better option.
>> I will implement it in v8 if Philipp agrees.
>
> Are the device tree maintainers happy with this idiom spreading?
> Except for the point above, I think this is acceptable.
Ok good. Let's see what DT maintainers thinks about that.

Regards,
Maxime

>
> regards
> Philipp
>
