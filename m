From: Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v8 14/16] ARM: dts: Introduce STM32F429 MCU
Date: Wed, 13 May 2015 13:58:05 +0100
Message-ID: <55534A5D.6050904@linaro.org>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>	<1431158038-3813-15-git-send-email-mcoquelin.stm32@gmail.com>	<2789447.8FUTAOJOHR@wuerfel> <CALszF6CS8Q9DWX+ERtu=k=Bzr1-25N3oZQyWyxDZBF3an4nFKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALszF6CS8Q9DWX+ERtu=k=Bzr1-25N3oZQyWyxDZBF3an4nFKQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber-l3A5Bk7waGM@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chanwoo Choi <cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Vladimir Zapolskiy <vladimir_zapolskiy-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <gal>
List-Id: linux-api@vger.kernel.org

On 13/05/15 12:45, Maxime Coquelin wrote:
> 2015-05-12 23:21 GMT+02:00 Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>:
>> On Saturday 09 May 2015 09:53:56 Maxime Coquelin wrote:
>>> +#include  <dt-bindings/mfd/stm32f4-rcc.h>
>>> +
>>>
>>
>> Can you find a way to avoid this dependency?
>>
>> Maybe you can change the bindings so that the numbers you pass as
>> arguments to the reset and clock specifiers reflect the numbers that
>> the hardware use?
>
> If I understand correctly, you prefer the way I did in v7 [0]?
>
> I don't have a strong opinion on this. Either way is fine to me.
>
> I changed the bindings in the v8 after discussions with Daniel
> Thompson, who is implementing the clock driver part of the RCC IP.
>
> He proposed we used common defines, because each peripheral has a
> reset line and a clock gate.
> Both reset and clock are represented as a single bit, with only the
> base offset differing between clock and reset.
> You can have a look at chapter 6 of the reference manual [1] if you
> find some time.
>
> Having common defines between clocks and reset make sense to me, but I
> also understand your point of avoiding dependencies.
>
> Maybe I can revert back to v7 bindings for now, and then we can
> reconsider using common defines when Daniel will send the clock
> patches.
> Note that doing that won't break the DT binary compatibility, as the
> raw reset values, or the ones from defines are the same.
>
> Daniel, could you share an example of the bindings you would use for the clocks?

For the most cases, where there is a clock gate just before the 
peripheral it looks pretty much like the reset driver and I use the bit 
offset of the clock gating bit as the index.

However there are a couple of clocks without gating just before the 
clock reaches the peripheral:

1. A hard coded /8. I think this will have to be given a synthetic
    number.

2. Ungated dividers. For these I am using the bit offset of the LSB of
    the mux field.

So I think there is only one value that is completely unrelated to the 
hardware and will use a magic constant instead.

I had planned to macros similar to the STM32F4_AxB_RESET() family of 
macros in both clk driver and DT in order to reuse the bit layouts from 
dt-bindings/mfd/stm32f4-rcc.h .

Normal case would have looked like this:

		timer3: timer@40000000 {
			compatible = "st,stm32-timer";
			reg = <0x40000000 0x400>;
			interrupts = <28>;
			resets = <&rcc STM32F4_APB1_RESET(TIM3)>;
			clocks = <&rcc STM32F4_APB1_CLK(TIM3)>;
			status = "disabled";
		};

Without the macros it looks like this:

		timer3: timer@40000000 {
			compatible = "st,stm32-timer";
			reg = <0x40000000 0x400>;
			interrupts = <28>;
			resets = <&rcc 257>;
			clocks = <&rcc 513>;
			status = "disabled";
		};

However we could perhaps be more literate even if we don't use the macros?

		timer3: timer@40000000 {
			compatible = "st,stm32-timer";
			reg = <0x40000000 0x400>;
			interrupts = <28>;
			resets = <&rcc ((0x20*8) + 1)>;
			clocks = <&rcc ((0x40*8) + 1)>;
			status = "disabled";
		};


Daniel.


> Kind regards,
> Maxime
>
>>
>>          Arnd
>
> [0]: http://lkml.iu.edu/hypermail/linux/kernel/1504.3/04523.html
> [1]: http://www.st.com/web/en/resource/technical/document/reference_manual/DM00031020.pdf
>

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
