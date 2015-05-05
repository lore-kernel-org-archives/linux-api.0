From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: Re: [PATCH v7 05/15] dt-bindings: Document the STM32 reset bindings
Date: Tue, 05 May 2015 17:07:29 +0100
Message-ID: <5548EAC1.7010002@linaro.org>
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
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1430840557.3035.60.camel@pengutronix.de>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Philipp Zabel <p.zabel@pengutronix.de>, Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>, Stefan Agner <stefan@agner.ch>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Peter Meerwald <pmeerw@pmeerw.net>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux-Arch <linux-arch@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>, Jonathan Corbet <corbet@lwn.net>, Lee Jones <lee.jones@linaro.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, Chanwoo Choi <cw00.choi@samsung.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Antti Palosaari <crope@iki.fi>, Geert Uytterhoeven <geert@linux-m68k.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, =?UTF-8?B?VXdlIEtsZ
List-Id: linux-api@vger.kernel.org

On 05/05/15 16:42, Philipp Zabel wrote:
> Am Dienstag, den 05.05.2015, 17:19 +0200 schrieb Maxime Coquelin:
>>>> For example, includes/dt-bindings/mfd/stm32f4-rcc.h would look like:
>>>>
>>>> #define GPIOA 0
>>>> #define GPIOB 1
>>>> ...
>>>> #define LTDC 186
>
> That looks a bit fragile.
> At least the defines for the indices should be properly namespaced,
> check out include/dt-bindings/gpio/tegra-gpio.h for a similar case.

Good point.

>>>> #define STM32F4_RESET(x) (x + 128)
>>>> #define STM32F4_CLOCK(x) (x + 384)

Thinking more about this point, if we are going to follow hardware if 
might be better to have:

#define STM32F4_RCC_AHB1_GPIOA 0
#define STM32F4_RCC_AHB1_GPIOA 1
...
#define STM32F4_RCC_APB2_LTDC 26


#define STM32F4_AHB1_RESET(x) (STM32F4_RCC_AHB1_##x##_BIT + (0x10 * 8))
#define STM32F4_AHB2_RESET(x) (STM32F4_RCC_AHB2_##x##_BIT + (0x14 * 8))
...
#define STM32F4_APB2_RESET(x) (STM32F4_RCC_APB2_##x##_BIT + (0x24 * 8))

Its more typing (or copy 'n pasting) by at least every number now maps 
directly to the datasheet.


>>>>
>>>> Then, in DT, a reset would be described like this:
>>>>
>>>> timer2 {
>>>>       resets = <&rcc STM32F4_RESET(TIM2)>;
>>>> };
>>>>
>>>> Phillip, Daniel, does that look acceptable to you?
>>>
>>>
>>> Doesn't look unreasonable.
>>>
>>> I am a little uneasy simply because there are very few similar header files
>>> in that directory but I haven't thought of a better idea.
>>
>> Since this file will be shared by both clock and reset drivers, I
>> don't see better option.
>> I will implement it in v8 if Philipp agrees.
>
> Are the device tree maintainers happy with this idiom spreading?
> Except for the point above, I think this is acceptable.
>
> regards
> Philipp
>
