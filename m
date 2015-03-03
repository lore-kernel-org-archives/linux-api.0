From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 16/18] ARM: dts: Introduce STM32F429 MCU
Date: Tue, 3 Mar 2015 18:59:10 +0100
Message-ID: <CALszF6Bn7z+COs84BV622BXnpRSruLn-9y+vo51mQxrHkDdQyQ@mail.gmail.com>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1424455277-29983-17-git-send-email-mcoquelin.stm32@gmail.com>
	<54F4A0F7.80606@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54F4A0F7.80606-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will
List-Id: linux-api@vger.kernel.org

Hi Andreas,

Thanks for this detailed review.

2015-03-02 18:42 GMT+01:00 Andreas F=C3=A4rber <afaerber-l3A5Bk7waGM@public.gmane.org>:
> Hi Maxime,
>
> Please don't put the whole world in To, that makes replying to you mu=
ch
> harder. You can put maintainers in CC instead.
Ok.
>
> Am 20.02.2015 um 19:01 schrieb Maxime Coquelin:
>> The STMicrolectornics's STM32F419 MCU has the following main feature=
s:
>>  - Cortex-M4 core running up to @180MHz
>>  - 2MB internal flash, 256KBytes internal RAM
>>  - FMC controller to connect SDRAM, NOR and NAND memories
>>  - SD/MMC/SDIO support
>>  - Ethernet controller
>>  - USB OTFG FS & HS controllers
>>  - I2C, SPI, CAN busses support
>>  - Several 16 & 32 bits general purpose timers
>>  - Serial Audio interface
>>  - LCD controller
>>
>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  arch/arm/boot/dts/Makefile            |   1 +
>>  arch/arm/boot/dts/stm32f429-disco.dts |  41 ++++
>>  arch/arm/boot/dts/stm32f429.dtsi      | 396 +++++++++++++++++++++++=
+++++++++++
>>  3 files changed, 438 insertions(+)
>>  create mode 100644 arch/arm/boot/dts/stm32f429-disco.dts
>>  create mode 100644 arch/arm/boot/dts/stm32f429.dtsi
>>
>> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
>> index 91bd5bd..d7da0ef 100644
>> --- a/arch/arm/boot/dts/Makefile
>> +++ b/arch/arm/boot/dts/Makefile
>> @@ -442,6 +442,7 @@ dtb-$(CONFIG_ARCH_STI)+=3D stih407-b2120.dtb \
>>       stih416-b2000.dtb \
>>       stih416-b2020.dtb \
>>       stih416-b2020e.dtb
>> +dtb-$(CONFIG_ARCH_STM32)+=3D stm32f429-disco.dtb
>>  dtb-$(CONFIG_MACH_SUN4I) +=3D \
>>       sun4i-a10-a1000.dtb \
>>       sun4i-a10-ba10-tvbox.dtb \
>> diff --git a/arch/arm/boot/dts/stm32f429-disco.dts b/arch/arm/boot/d=
ts/stm32f429-disco.dts
>> new file mode 100644
>> index 0000000..0e79cc1
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/stm32f429-disco.dts
>> @@ -0,0 +1,41 @@
>
> Add a suitable license header here? There had been attempts to
> dual-license as GPL and MIT/X11.

I agree to add the dual GPL and MIT/X11 licence.

>
>> +/dts-v1/;
>> +#include "stm32f429.dtsi"
>> +
>> +/ {
>> +     model =3D "STMicroelectronics's STM32F429i-DISCO board";
>
> "'s" seems uncommon here and "s's" looks wrong. Just use
> "STMicroelectronics STM32F429I-DISCO board"?

Ok, it will be fixed in v3.

>
>> +     compatible =3D "st,stm32f429i-disco", "st,stm32f429";
>> +
>> +     chosen {
>> +             bootargs =3D "console=3DttyS0,115200 root=3D/dev/ram r=
dinit=3D/linuxrc";
>> +             linux,stdout-path =3D &usart1;
>
> I have actually been using USART3, following a guide I found on GitHu=
b.
> Which pins do you use for USART1, and is one better than the other?

I used U-boot from Emcraft, which uses USART1, that is the only reason
I used this one.
Regarding USART3, I had a look at your boot-wrapper, and you configure
the USART3 to PC10/PC11 pins.

=46rom the schematics, I see the PC10 pin is connected to the LCD.


>
>> +     };
>> +
>> +     memory {
>> +             reg =3D <0xd0000000 0x800000>;
>
> I have it at 0x90000000!

Ok. But you use a specific setting:
https://github.com/afaerber/afboot-stm32/blob/master/foo.c#L338

By default this is the PC Card bank (Bank 4) at 0x90000000.

Maybe you could change your boot-wrapper to use also the default settin=
g?

>
>> +     };
>> +
>> +     aliases {
>> +             ttyS0 =3D &usart1;
>
> Why ttyS0 here? Shouldn't that be serial0 by convention?

I was not aware of this. Do you know whether it is documented somewhere=
?
Anyway, I will change to serial0 in next version.

>
>> +     };
>> +
>> +     soc {
>> +             usart1: usart@40011000 {
>> +                     status =3D "okay";
>> +             };
>
> This is a new target, so please use the new-style &usart1 {...};
> reference rather than replicating the hierarchy.
Ok.

>
>> +
>> +             leds {
>
> These LEDs are definitely not on the SoC, they're on the board. Pleas=
e
> move one level up.

Ok.

>
>> +                     compatible =3D "gpio-leds";
>
> In this file you're being parsimonious with newline, yet in the .dtsi
> you unnecessarily add newlines before the trailing status property.
>
>> +                     red {
>> +                             #gpio-cells =3D <2>;
>
> This looks weird. Drop it?

Yes.

>
>> +                             label =3D "Front Panel LED";
>
> "Front Panel"? Both LEDs are on the front, and several other
> architectures avoid spaces in the label for accessing it from /sys.

That's an unfortunate copy/paste. For sure it has no meaning here.

>
>> +                             gpios =3D <&gpiog 14 0>;
>
> GPIO_ACTIVE_HIGH
Ok.

>
>> +                             linux,default-trigger =3D "heartbeat";
>
> Suggest to leave both off by default.
Ok.

>
>> +                     };
>> +                     green {
>> +                             #gpio-cells =3D <2>;
>
> Ditto.
>
>> +                             gpios =3D <&gpiog 13 0>;
>
> Ditto.
>
>> +                             default-state =3D "off";
>> +                     };
>> +             };
>> +     };
>> +};
>> diff --git a/arch/arm/boot/dts/stm32f429.dtsi b/arch/arm/boot/dts/st=
m32f429.dtsi
>> new file mode 100644
>> index 0000000..5b3442a
>> --- /dev/null
>> +++ b/arch/arm/boot/dts/stm32f429.dtsi
>> @@ -0,0 +1,396 @@
>> +/*
>> + * Device tree for STM32F429
>
> License?

Yes. I will do the same as for the board file.

>
>> + */
>> +#include "armv7-m.dtsi"
>> +#include <dt-bindings/pinctrl/pinctrl-stm32.h>
>> +#include <dt-bindings/reset/st,stm32f429.h>
>> +
>> +/ {
>> +
>> +     aliases {
>> +             gpio0 =3D &gpioa;
>> +             gpio1 =3D &gpiob;
>> +             gpio2 =3D &gpioc;
>> +             gpio3 =3D &gpiod;
>> +             gpio4 =3D &gpioe;
>> +             gpio5 =3D &gpiof;
>> +             gpio6 =3D &gpiog;
>> +             gpio7 =3D &gpioh;
>> +             gpio8 =3D &gpioi;
>> +             gpio9 =3D &gpioj;
>> +             gpio10 =3D &gpiok;
>> +     };
>> +
>> +     clocks {
>> +             clk_sysclk: clk-sysclk {
>> +                     #clock-cells =3D <0>;
>> +                     compatible =3D "fixed-clock";
>> +                     clock-frequency =3D <180000000>;
>> +             };
>> +
>> +             clk_hclk: clk-hclk {
>> +                     #clock-cells =3D <0>;
>> +                     compatible =3D "fixed-clock";
>> +                     clock-frequency =3D <180000000>;
>> +             };
>> +
>> +             clk_pclk1: clk-pclk1 {
>> +                     #clock-cells =3D <0>;
>> +                     compatible =3D "fixed-clock";
>> +                     clock-frequency =3D <45000000>;
>> +             };
>> +
>> +             clk_pclk2: clk-pclk2 {
>> +                     #clock-cells =3D <0>;
>> +                     compatible =3D "fixed-clock";
>> +                     clock-frequency =3D <90000000>;
>> +             };
>> +
>> +             clk_pmtr1: clk-pmtr1 {
>> +                     #clock-cells =3D <0>;
>> +                     compatible =3D "fixed-clock";
>> +                     clock-frequency =3D <90000000>;
>> +             };
>> +
>> +             clk_pmtr2: clk-pmtr2 {
>> +                     #clock-cells =3D <0>;
>> +                     compatible =3D "fixed-clock";
>> +                     clock-frequency =3D <180000000>;
>> +             };
>> +
>> +             clk_systick: clk-systick {
>> +                     compatible =3D "fixed-factor-clock";
>> +                     clocks =3D <&clk_hclk>;
>> +                     #clock-cells =3D <0>;
>> +                     clock-div =3D <8>;
>> +                     clock-mult =3D <1>;
>> +             };
>
> Most of these should be replaceable with my clk driver.
>

I agree, but adding more drivers is likely to delay the STM32 machine
to be merged.
Once this first round accepted, it will be easier for others to contrib=
ute.
It will help to have sooner a good support of the machine.

Does that look reasonable for you?

>> +     };
>> +
>> +     systick: timer@e000e010 {
>> +             clocks =3D <&clk_systick>;
>> +
>> +             status =3D "okay";
>> +     };
>
> &systick {...};
Ok.

>
>> +
>> +     soc {
>> +             reset: reset@40023810 {
>> +                     #reset-cells =3D <1>;
>> +                     compatible =3D "st,stm32-reset";
>> +                     reg =3D <0x40023810 0x18>;
>> +             };
>
> Still, this feels wrong, given that it's an RCC IP block...
Ok, this was already pointed out by Philipp.
I will rework the driver so that the node covers the full RCC IP.


>
>> +
>> +             pin-controller {
>> +                     #address-cells =3D <1>;
>> +                     #size-cells =3D <1>;
>> +                     compatible =3D "st,stm32-pinctrl";
>> +                     ranges =3D <0 0x40020000 0x3000>;
>> +
>> +                     gpioa: gpio@40020000 {
>> +                             gpio-controller;
>> +                             #gpio-cells =3D <2>;
>> +                             reg =3D <0x0 0x400>;
>> +                             resets =3D <&reset GPIOA_RESET>;
>> +                             st,bank-name =3D "GPIOA";
>> +                     };
>> +
>> +                     gpiob: gpio@40020400 {
>> +                             gpio-controller;
>> +                             #gpio-cells =3D <2>;
>> +                             reg =3D <0x400 0x400>;
>> +                             resets =3D <&reset GPIOB_RESET>;
>> +                             st,bank-name =3D "GPIOB";
>> +                     };
>> +
>> +                     gpioc: gpio@40020800 {
>> +                             gpio-controller;
>> +                             #gpio-cells =3D <2>;
>> +                             reg =3D <0x800 0x400>;
>> +                             resets =3D <&reset GPIOC_RESET>;
>> +                             st,bank-name =3D "GPIOC";
>> +                     };
>> +
>> +                     gpiod: gpio@40020c00 {
>> +                             gpio-controller;
>> +                             #gpio-cells =3D <2>;
>> +                             reg =3D <0xc00 0x400>;
>> +                             resets =3D <&reset GPIOD_RESET>;
>> +                             st,bank-name =3D "GPIOD";
>> +                     };
>> +
>> +                     gpioe: gpio@40021000 {
>> +                             gpio-controller;
>> +                             #gpio-cells =3D <2>;
>> +                             reg =3D <0x1000 0x400>;
>> +                             resets =3D <&reset GPIOE_RESET>;
>> +                             st,bank-name =3D "GPIOE";
>> +                     };
>> +
>> +                     gpiof: gpio@40021400 {
>> +                             gpio-controller;
>> +                             #gpio-cells =3D <2>;
>> +                             reg =3D <0x1400 0x400>;
>> +                             resets =3D <&reset GPIOF_RESET>;
>> +                             st,bank-name =3D "GPIOF";
>> +                     };
>> +
>> +                     gpiog: gpio@40021800 {
>> +                             gpio-controller;
>> +                             #gpio-cells =3D <2>;
>> +                             reg =3D <0x1800 0x400>;
>> +                             resets =3D <&reset GPIOG_RESET>;
>> +                             st,bank-name =3D "GPIOG";
>> +                     };
>> +
>> +                     gpioh: gpio@40021c00 {
>> +                             gpio-controller;
>> +                             #gpio-cells =3D <2>;
>> +                             reg =3D <0x1c00 0x400>;
>> +                             resets =3D <&reset GPIOH_RESET>;
>> +                             st,bank-name =3D "GPIOH";
>> +                     };
>> +
>> +                     gpioi: gpio@40022000 {
>> +                             gpio-controller;
>> +                             #gpio-cells =3D <2>;
>> +                             reg =3D <0x2000 0x400>;
>> +                             resets =3D <&reset GPIOI_RESET>;
>> +                             st,bank-name =3D "GPIOI";
>> +                     };
>> +
>> +                     gpioj: gpio@40022400 {
>> +                             gpio-controller;
>> +                             #gpio-cells =3D <2>;
>> +                             reg =3D <0x2400 0x400>;
>> +                             resets =3D <&reset GPIOJ_RESET>;
>> +                             st,bank-name =3D "GPIOJ";
>> +                     };
>> +
>> +                     gpiok: gpio@40022800 {
>> +                             gpio-controller;
>> +                             #gpio-cells =3D <2>;
>> +                             reg =3D <0x2800 0x400>;
>> +                             resets =3D <&reset GPIOK_RESET>;
>> +                             st,bank-name =3D "GPIOK";
>> +                     };
>> +
>> +                     usart1 {
>> +                             pinctrl_usart1: usart1-0 {
>> +                                     st,pins {
>> +                                             tx =3D <&gpioa 9 ALT7 =
NO_PULL PUSH_PULL LOW_SPEED>;
>> +                                             rx =3D <&gpioa 10 ALT7=
 NO_PULL>;
>> +                                     };
>> +                             };
>> +                     };
>> +
>> +                     usart2 {
>> +                             pinctrl_usart2: usart2-0 {
>> +                                     st,pins {
>> +                                             tx =3D <&gpioa 2 ALT7 =
NO_PULL PUSH_PULL LOW_SPEED>;
>> +                                             rx =3D <&gpioa 3 ALT7 =
NO_PULL>;
>> +                                     };
>> +                             };
>> +                     };
>> +
>> +                     usart3 {
>> +                             pinctrl_usart3: usart3-0 {
>> +                                     st,pins {
>> +                                             tx =3D <&gpiob 10 ALT7=
 NO_PULL PUSH_PULL LOW_SPEED>;
>> +                                             rx =3D <&gpiob 11 ALT7=
 NO_PULL>;
>> +                                     };
>> +                             };
>> +                     };
>> +
>> +                     usart4 {
>> +                             pinctrl_usart4: usart4-0 {
>> +                                     st,pins {
>> +                                             tx =3D <&gpioa 0 ALT8 =
NO_PULL PUSH_PULL LOW_SPEED>;
>> +                                             rx =3D <&gpioa 1 ALT8 =
NO_PULL>;
>> +                                     };
>> +                             };
>> +                     };
>> +
>> +                     usart5 {
>> +                             pinctrl_usart5: usart5-0 {
>> +                                     st,pins {
>> +                                             tx =3D <&gpioc 12 ALT8=
 NO_PULL PUSH_PULL LOW_SPEED>;
>> +                                             rx =3D <&gpiod 2 ALT8 =
NO_PULL>;
>> +                                     };
>> +                             };
>> +                     };
>> +
>> +                     usart6 {
>> +                             pinctrl_usart6: usart6-0 {
>> +                                     st,pins {
>> +                                             tx =3D <&gpioc 6 ALT8 =
NO_PULL PUSH_PULL LOW_SPEED>;
>> +                                             rx =3D <&gpioc 7 ALT8 =
NO_PULL>;
>> +                                     };
>> +                             };
>> +                     };
>> +
>> +                     usart7 {
>> +                             pinctrl_usart7: usart7-0 {
>> +                                     st,pins {
>> +                                             tx =3D <&gpioe 8 ALT8 =
NO_PULL PUSH_PULL LOW_SPEED>;
>> +                                             rx =3D <&gpioe 7 ALT8 =
NO_PULL>;
>> +                                     };
>> +                             };
>> +                     };
>> +
>> +                     usart8 {
>> +                             pinctrl_usart8: usart8-0 {
>> +                                     st,pins {
>> +                                             tx =3D <&gpioe 1 ALT8 =
NO_PULL PUSH_PULL LOW_SPEED>;
>> +                                             rx =3D <&gpioe 0 ALT8 =
NO_PULL>;
>> +                                     };
>> +                             };
>> +                     };
>
> Can't the outer level be avoided here to save space and indentation?
Yes. I will rework this too.

>
>> +             };
>> +
>> +             timer2: timer@40000000 {
>> +                     compatible =3D "st,stm32-timer";
>> +                     reg =3D <0x40000000 0x400>;
>> +                     interrupts =3D <28>;
>> +                     resets =3D <&reset TIM2_RESET>;
>> +                     clocks =3D <&clk_pmtr1>;
>> +
>> +                     status =3D "disabled";
>> +             };
>> +
>> +             timer3: timer@40000400 {
>> +                     compatible =3D "st,stm32-timer";
>> +                     reg =3D <0x40000400 0x400>;
>> +                     interrupts =3D <29>;
>> +                     resets =3D <&reset TIM3_RESET>;
>> +                     clocks =3D <&clk_pmtr1>;
>> +
>> +                     status =3D "disabled";
>> +             };
>> +
>> +             timer4: timer@40000800 {
>> +                     compatible =3D "st,stm32-timer";
>> +                     reg =3D <0x40000800 0x400>;
>> +                     interrupts =3D <30>;
>> +                     resets =3D <&reset TIM4_RESET>;
>> +                     clocks =3D <&clk_pmtr1>;
>> +
>> +                     status =3D "disabled";
>> +             };
>> +
>> +             timer5: timer@40000c00 {
>> +                     compatible =3D "st,stm32-timer";
>> +                     reg =3D <0x40000c00 0x400>;
>> +                     interrupts =3D <50>;
>> +                     resets =3D <&reset TIM5_RESET>;
>> +                     clocks =3D <&clk_pmtr1>;
>> +             };
>> +
>> +             timer6: timer@40001000 {
>> +                     compatible =3D "st,stm32-timer";
>> +                     reg =3D <0x40001000 0x400>;
>> +                     interrupts =3D <54>;
>> +                     resets =3D <&reset TIM6_RESET>;
>> +                     clocks =3D <&clk_pmtr1>;
>> +
>> +                     status =3D "disabled";
>> +             };
>> +
>> +             timer7: timer@40001400 {
>> +                     compatible =3D "st,stm32-timer";
>> +                     reg =3D <0x40001400 0x400>;
>> +                     interrupts =3D <55>;
>> +                     resets =3D <&reset TIM7_RESET>;
>> +                     clocks =3D <&clk_pmtr1>;
>> +
>> +                     status =3D "disabled";
>> +             };
>> +
>> +             usart1: usart@40011000 {
>> +                     compatible =3D "st,stm32-usart";
>> +                     reg =3D <0x40011000 0x400>;
>> +                     interrupts =3D <37>;
>> +                     clocks =3D <&clk_pclk2>;
>> +                     pinctrl-names =3D "default";
>> +                     pinctrl-0 =3D <&pinctrl_usart1>;
>> +
>> +                     status =3D "disabled";
>> +             };
>> +
>> +             usart2: usart@40004400 {
>> +                     compatible =3D "st,stm32-usart";
>> +                     reg =3D <0x40004400 0x400>;
>> +                     interrupts =3D <38>;
>> +                     clocks =3D <&clk_pclk1>;
>> +                     pinctrl-names =3D "default";
>> +                     pinctrl-0 =3D <&pinctrl_usart1>;
>
> Copy&paste, also below. Is this really .dtsi material?

Sorry, I am not sure to understand what you mean.
Could you elaborate please?

>
>> +
>> +                     status =3D "disabled";
>> +             };
>> +
>> +             usart3: usart@40004800 {
>> +                     compatible =3D "st,stm32-usart";
>> +                     reg =3D <0x40004800 0x400>;
>> +                     interrupts =3D <39>;
>> +                     clocks =3D <&clk_pclk1>;
>> +                     pinctrl-names =3D "default";
>> +                     pinctrl-0 =3D <&pinctrl_usart1>;
>> +
>> +                     status =3D "disabled";
>> +             };
>> +
>> +             usart4: usart@40004c00 {
>> +                     compatible =3D "st,stm32-usart";
>> +                     reg =3D <0x40004c00 0x400>;
>> +                     interrupts =3D <52>;
>> +                     clocks =3D <&clk_pclk1>;
>> +                     pinctrl-names =3D "default";
>> +                     pinctrl-0 =3D <&pinctrl_usart1>;
>> +
>> +                     status =3D "disabled";
>> +             };
>> +
>> +             usart5: usart@40005000 {
>> +                     compatible =3D "st,stm32-usart";
>> +                     reg =3D <0x40005000 0x400>;
>> +                     interrupts =3D <53>;
>> +                     clocks =3D <&clk_pclk1>;
>> +                     pinctrl-names =3D "default";
>> +                     pinctrl-0 =3D <&pinctrl_usart1>;
>> +
>> +                     status =3D "disabled";
>> +             };
>> +
>> +             usart6: usart@40011400 {
>> +                     compatible =3D "st,stm32-usart";
>> +                     reg =3D <0x40011400 0x400>;
>> +                     interrupts =3D <71>;
>> +                     clocks =3D <&clk_pclk2>;
>> +                     pinctrl-names =3D "default";
>> +                     pinctrl-0 =3D <&pinctrl_usart1>;
>> +
>> +                     status =3D "disabled";
>> +             };
>> +
>> +             usart7: usart@40007800 {
>
> Please order all nodes by unit address, not by label.
Ok.

>
>> +                     compatible =3D "st,stm32-usart";
>> +                     reg =3D <0x40007800 0x400>;
>> +                     interrupts =3D <82>;
>> +                     clocks =3D <&clk_pclk1>;
>> +                     pinctrl-names =3D "default";
>> +                     pinctrl-0 =3D <&pinctrl_usart1>;
>> +
>> +                     status =3D "disabled";
>> +             };
>> +
>> +             usart8: usart@40007c00 {
>> +                     compatible =3D "st,stm32-usart";
>> +                     reg =3D <0x40007c00 0x400>;
>> +                     interrupts =3D <83>;
>> +                     clocks =3D <&clk_pclk1>;
>> +                     pinctrl-names =3D "default";
>> +                     pinctrl-0 =3D <&pinctrl_usart1>;
>> +
>> +                     status =3D "disabled";
>> +             };
>
> I remember two of them not being USART but UART? Similarly, two of th=
em
> support flow control (or two don't?), for which we would either need =
a
> property or two different compatible strings.

I have to check what would best fit to handle these differences.
I will come back to you later on this point.

Thanks!
Maxime

>
>> +     };
>> +};
>
> Regards,
> Andreas
>
> --
> SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Jennifer Guild, Dilip Upma=
nyu,
> Graham Norton; HRB 21284 (AG N=C3=BCrnberg)
>
