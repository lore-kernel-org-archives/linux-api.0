From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v2 16/18] ARM: dts: Introduce STM32F429 MCU
Date: Mon, 02 Mar 2015 18:42:15 +0100
Message-ID: <54F4A0F7.80606__48763.9526524164$1425318199$gmane$org@suse.de>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com> <1424455277-29983-17-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="mi8hoEd27jhdOe10ob0B0cATLdeHAKMsU"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424455277-29983-17-git-send-email-mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mi8hoEd27jhdOe10ob0B0cATLdeHAKMsU
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi Maxime,

Please don't put the whole world in To, that makes replying to you much
harder. You can put maintainers in CC instead.

Am 20.02.2015 um 19:01 schrieb Maxime Coquelin:
> The STMicrolectornics's STM32F419 MCU has the following main features:
>  - Cortex-M4 core running up to @180MHz
>  - 2MB internal flash, 256KBytes internal RAM
>  - FMC controller to connect SDRAM, NOR and NAND memories
>  - SD/MMC/SDIO support
>  - Ethernet controller
>  - USB OTFG FS & HS controllers
>  - I2C, SPI, CAN busses support
>  - Several 16 & 32 bits general purpose timers
>  - Serial Audio interface
>  - LCD controller
>=20
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  arch/arm/boot/dts/Makefile            |   1 +
>  arch/arm/boot/dts/stm32f429-disco.dts |  41 ++++
>  arch/arm/boot/dts/stm32f429.dtsi      | 396 ++++++++++++++++++++++++++=
++++++++
>  3 files changed, 438 insertions(+)
>  create mode 100644 arch/arm/boot/dts/stm32f429-disco.dts
>  create mode 100644 arch/arm/boot/dts/stm32f429.dtsi
>=20
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 91bd5bd..d7da0ef 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -442,6 +442,7 @@ dtb-$(CONFIG_ARCH_STI)+=3D stih407-b2120.dtb \
>  	stih416-b2000.dtb \
>  	stih416-b2020.dtb \
>  	stih416-b2020e.dtb
> +dtb-$(CONFIG_ARCH_STM32)+=3D stm32f429-disco.dtb
>  dtb-$(CONFIG_MACH_SUN4I) +=3D \
>  	sun4i-a10-a1000.dtb \
>  	sun4i-a10-ba10-tvbox.dtb \
> diff --git a/arch/arm/boot/dts/stm32f429-disco.dts b/arch/arm/boot/dts/=
stm32f429-disco.dts
> new file mode 100644
> index 0000000..0e79cc1
> --- /dev/null
> +++ b/arch/arm/boot/dts/stm32f429-disco.dts
> @@ -0,0 +1,41 @@

Add a suitable license header here? There had been attempts to
dual-license as GPL and MIT/X11.

> +/dts-v1/;
> +#include "stm32f429.dtsi"
> +
> +/ {
> +	model =3D "STMicroelectronics's STM32F429i-DISCO board";

"'s" seems uncommon here and "s's" looks wrong. Just use
"STMicroelectronics STM32F429I-DISCO board"?

> +	compatible =3D "st,stm32f429i-disco", "st,stm32f429";
> +
> +	chosen {
> +		bootargs =3D "console=3DttyS0,115200 root=3D/dev/ram rdinit=3D/linux=
rc";
> +		linux,stdout-path =3D &usart1;

I have actually been using USART3, following a guide I found on GitHub.
Which pins do you use for USART1, and is one better than the other?

> +	};
> +
> +	memory {
> +		reg =3D <0xd0000000 0x800000>;

I have it at 0x90000000!

> +	};
> +
> +	aliases {
> +		ttyS0 =3D &usart1;

Why ttyS0 here? Shouldn't that be serial0 by convention?

> +	};
> +
> +	soc {
> +		usart1: usart@40011000 {
> +			status =3D "okay";
> +		};

This is a new target, so please use the new-style &usart1 {...};
reference rather than replicating the hierarchy.

> +
> +		leds {

These LEDs are definitely not on the SoC, they're on the board. Please
move one level up.

> +			compatible =3D "gpio-leds";

In this file you're being parsimonious with newline, yet in the .dtsi
you unnecessarily add newlines before the trailing status property.

> +			red {
> +				#gpio-cells =3D <2>;

This looks weird. Drop it?

> +				label =3D "Front Panel LED";

"Front Panel"? Both LEDs are on the front, and several other
architectures avoid spaces in the label for accessing it from /sys.

> +				gpios =3D <&gpiog 14 0>;

GPIO_ACTIVE_HIGH

> +				linux,default-trigger =3D "heartbeat";

Suggest to leave both off by default.

> +			};
> +			green {
> +				#gpio-cells =3D <2>;

Ditto.

> +				gpios =3D <&gpiog 13 0>;

Ditto.

> +				default-state =3D "off";
> +			};
> +		};
> +	};
> +};
> diff --git a/arch/arm/boot/dts/stm32f429.dtsi b/arch/arm/boot/dts/stm32=
f429.dtsi
> new file mode 100644
> index 0000000..5b3442a
> --- /dev/null
> +++ b/arch/arm/boot/dts/stm32f429.dtsi
> @@ -0,0 +1,396 @@
> +/*
> + * Device tree for STM32F429

License?

> + */
> +#include "armv7-m.dtsi"
> +#include <dt-bindings/pinctrl/pinctrl-stm32.h>
> +#include <dt-bindings/reset/st,stm32f429.h>
> +
> +/ {
> +
> +	aliases {
> +		gpio0 =3D &gpioa;
> +		gpio1 =3D &gpiob;
> +		gpio2 =3D &gpioc;
> +		gpio3 =3D &gpiod;
> +		gpio4 =3D &gpioe;
> +		gpio5 =3D &gpiof;
> +		gpio6 =3D &gpiog;
> +		gpio7 =3D &gpioh;
> +		gpio8 =3D &gpioi;
> +		gpio9 =3D &gpioj;
> +		gpio10 =3D &gpiok;
> +	};
> +
> +	clocks {
> +		clk_sysclk: clk-sysclk {
> +			#clock-cells =3D <0>;
> +			compatible =3D "fixed-clock";
> +			clock-frequency =3D <180000000>;
> +		};
> +
> +		clk_hclk: clk-hclk {
> +			#clock-cells =3D <0>;
> +			compatible =3D "fixed-clock";
> +			clock-frequency =3D <180000000>;
> +		};
> +
> +		clk_pclk1: clk-pclk1 {
> +			#clock-cells =3D <0>;
> +			compatible =3D "fixed-clock";
> +			clock-frequency =3D <45000000>;
> +		};
> +
> +		clk_pclk2: clk-pclk2 {
> +			#clock-cells =3D <0>;
> +			compatible =3D "fixed-clock";
> +			clock-frequency =3D <90000000>;
> +		};
> +
> +		clk_pmtr1: clk-pmtr1 {
> +			#clock-cells =3D <0>;
> +			compatible =3D "fixed-clock";
> +			clock-frequency =3D <90000000>;
> +		};
> +
> +		clk_pmtr2: clk-pmtr2 {
> +			#clock-cells =3D <0>;
> +			compatible =3D "fixed-clock";
> +			clock-frequency =3D <180000000>;
> +		};
> +
> +		clk_systick: clk-systick {
> +			compatible =3D "fixed-factor-clock";
> +			clocks =3D <&clk_hclk>;
> +			#clock-cells =3D <0>;
> +			clock-div =3D <8>;
> +			clock-mult =3D <1>;
> +		};

Most of these should be replaceable with my clk driver.

> +	};
> +
> +	systick: timer@e000e010 {
> +		clocks =3D <&clk_systick>;
> +
> +		status =3D "okay";
> +	};

&systick {...};

> +
> +	soc {
> +		reset: reset@40023810 {
> +			#reset-cells =3D <1>;
> +			compatible =3D "st,stm32-reset";
> +			reg =3D <0x40023810 0x18>;
> +		};

Still, this feels wrong, given that it's an RCC IP block...

> +
> +		pin-controller {
> +			#address-cells =3D <1>;
> +			#size-cells =3D <1>;
> +			compatible =3D "st,stm32-pinctrl";
> +			ranges =3D <0 0x40020000 0x3000>;
> +
> +			gpioa: gpio@40020000 {
> +				gpio-controller;
> +				#gpio-cells =3D <2>;
> +				reg =3D <0x0 0x400>;
> +				resets =3D <&reset GPIOA_RESET>;
> +				st,bank-name =3D "GPIOA";
> +			};
> +
> +			gpiob: gpio@40020400 {
> +				gpio-controller;
> +				#gpio-cells =3D <2>;
> +				reg =3D <0x400 0x400>;
> +				resets =3D <&reset GPIOB_RESET>;
> +				st,bank-name =3D "GPIOB";
> +			};
> +
> +			gpioc: gpio@40020800 {
> +				gpio-controller;
> +				#gpio-cells =3D <2>;
> +				reg =3D <0x800 0x400>;
> +				resets =3D <&reset GPIOC_RESET>;
> +				st,bank-name =3D "GPIOC";
> +			};
> +
> +			gpiod: gpio@40020c00 {
> +				gpio-controller;
> +				#gpio-cells =3D <2>;
> +				reg =3D <0xc00 0x400>;
> +				resets =3D <&reset GPIOD_RESET>;
> +				st,bank-name =3D "GPIOD";
> +			};
> +
> +			gpioe: gpio@40021000 {
> +				gpio-controller;
> +				#gpio-cells =3D <2>;
> +				reg =3D <0x1000 0x400>;
> +				resets =3D <&reset GPIOE_RESET>;
> +				st,bank-name =3D "GPIOE";
> +			};
> +
> +			gpiof: gpio@40021400 {
> +				gpio-controller;
> +				#gpio-cells =3D <2>;
> +				reg =3D <0x1400 0x400>;
> +				resets =3D <&reset GPIOF_RESET>;
> +				st,bank-name =3D "GPIOF";
> +			};
> +
> +			gpiog: gpio@40021800 {
> +				gpio-controller;
> +				#gpio-cells =3D <2>;
> +				reg =3D <0x1800 0x400>;
> +				resets =3D <&reset GPIOG_RESET>;
> +				st,bank-name =3D "GPIOG";
> +			};
> +
> +			gpioh: gpio@40021c00 {
> +				gpio-controller;
> +				#gpio-cells =3D <2>;
> +				reg =3D <0x1c00 0x400>;
> +				resets =3D <&reset GPIOH_RESET>;
> +				st,bank-name =3D "GPIOH";
> +			};
> +
> +			gpioi: gpio@40022000 {
> +				gpio-controller;
> +				#gpio-cells =3D <2>;
> +				reg =3D <0x2000 0x400>;
> +				resets =3D <&reset GPIOI_RESET>;
> +				st,bank-name =3D "GPIOI";
> +			};
> +
> +			gpioj: gpio@40022400 {
> +				gpio-controller;
> +				#gpio-cells =3D <2>;
> +				reg =3D <0x2400 0x400>;
> +				resets =3D <&reset GPIOJ_RESET>;
> +				st,bank-name =3D "GPIOJ";
> +			};
> +
> +			gpiok: gpio@40022800 {
> +				gpio-controller;
> +				#gpio-cells =3D <2>;
> +				reg =3D <0x2800 0x400>;
> +				resets =3D <&reset GPIOK_RESET>;
> +				st,bank-name =3D "GPIOK";
> +			};
> +
> +			usart1 {
> +				pinctrl_usart1: usart1-0 {
> +					st,pins {
> +						tx =3D <&gpioa 9 ALT7 NO_PULL PUSH_PULL LOW_SPEED>;
> +						rx =3D <&gpioa 10 ALT7 NO_PULL>;
> +					};
> +				};
> +			};
> +
> +			usart2 {
> +				pinctrl_usart2: usart2-0 {
> +					st,pins {
> +						tx =3D <&gpioa 2 ALT7 NO_PULL PUSH_PULL LOW_SPEED>;
> +						rx =3D <&gpioa 3 ALT7 NO_PULL>;
> +					};
> +				};
> +			};
> +
> +			usart3 {
> +				pinctrl_usart3: usart3-0 {
> +					st,pins {
> +						tx =3D <&gpiob 10 ALT7 NO_PULL PUSH_PULL LOW_SPEED>;
> +						rx =3D <&gpiob 11 ALT7 NO_PULL>;
> +					};
> +				};
> +			};
> +
> +			usart4 {
> +				pinctrl_usart4: usart4-0 {
> +					st,pins {
> +						tx =3D <&gpioa 0 ALT8 NO_PULL PUSH_PULL LOW_SPEED>;
> +						rx =3D <&gpioa 1 ALT8 NO_PULL>;
> +					};
> +				};
> +			};
> +
> +			usart5 {
> +				pinctrl_usart5: usart5-0 {
> +					st,pins {
> +						tx =3D <&gpioc 12 ALT8 NO_PULL PUSH_PULL LOW_SPEED>;
> +						rx =3D <&gpiod 2 ALT8 NO_PULL>;
> +					};
> +				};
> +			};
> +
> +			usart6 {
> +				pinctrl_usart6: usart6-0 {
> +					st,pins {
> +						tx =3D <&gpioc 6 ALT8 NO_PULL PUSH_PULL LOW_SPEED>;
> +						rx =3D <&gpioc 7 ALT8 NO_PULL>;
> +					};
> +				};
> +			};
> +
> +			usart7 {
> +				pinctrl_usart7: usart7-0 {
> +					st,pins {
> +						tx =3D <&gpioe 8 ALT8 NO_PULL PUSH_PULL LOW_SPEED>;
> +						rx =3D <&gpioe 7 ALT8 NO_PULL>;
> +					};
> +				};
> +			};
> +
> +			usart8 {
> +				pinctrl_usart8: usart8-0 {
> +					st,pins {
> +						tx =3D <&gpioe 1 ALT8 NO_PULL PUSH_PULL LOW_SPEED>;
> +						rx =3D <&gpioe 0 ALT8 NO_PULL>;
> +					};
> +				};
> +			};

Can't the outer level be avoided here to save space and indentation?

> +		};
> +
> +		timer2: timer@40000000 {
> +			compatible =3D "st,stm32-timer";
> +			reg =3D <0x40000000 0x400>;
> +			interrupts =3D <28>;
> +			resets =3D <&reset TIM2_RESET>;
> +			clocks =3D <&clk_pmtr1>;
> +
> +			status =3D "disabled";
> +		};
> +
> +		timer3: timer@40000400 {
> +			compatible =3D "st,stm32-timer";
> +			reg =3D <0x40000400 0x400>;
> +			interrupts =3D <29>;
> +			resets =3D <&reset TIM3_RESET>;
> +			clocks =3D <&clk_pmtr1>;
> +
> +			status =3D "disabled";
> +		};
> +
> +		timer4: timer@40000800 {
> +			compatible =3D "st,stm32-timer";
> +			reg =3D <0x40000800 0x400>;
> +			interrupts =3D <30>;
> +			resets =3D <&reset TIM4_RESET>;
> +			clocks =3D <&clk_pmtr1>;
> +
> +			status =3D "disabled";
> +		};
> +
> +		timer5: timer@40000c00 {
> +			compatible =3D "st,stm32-timer";
> +			reg =3D <0x40000c00 0x400>;
> +			interrupts =3D <50>;
> +			resets =3D <&reset TIM5_RESET>;
> +			clocks =3D <&clk_pmtr1>;
> +		};
> +
> +		timer6: timer@40001000 {
> +			compatible =3D "st,stm32-timer";
> +			reg =3D <0x40001000 0x400>;
> +			interrupts =3D <54>;
> +			resets =3D <&reset TIM6_RESET>;
> +			clocks =3D <&clk_pmtr1>;
> +
> +			status =3D "disabled";
> +		};
> +
> +		timer7: timer@40001400 {
> +			compatible =3D "st,stm32-timer";
> +			reg =3D <0x40001400 0x400>;
> +			interrupts =3D <55>;
> +			resets =3D <&reset TIM7_RESET>;
> +			clocks =3D <&clk_pmtr1>;
> +
> +			status =3D "disabled";
> +		};
> +
> +		usart1: usart@40011000 {
> +			compatible =3D "st,stm32-usart";
> +			reg =3D <0x40011000 0x400>;
> +			interrupts =3D <37>;
> +			clocks =3D <&clk_pclk2>;
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&pinctrl_usart1>;
> +
> +			status =3D "disabled";
> +		};
> +
> +		usart2: usart@40004400 {
> +			compatible =3D "st,stm32-usart";
> +			reg =3D <0x40004400 0x400>;
> +			interrupts =3D <38>;
> +			clocks =3D <&clk_pclk1>;
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&pinctrl_usart1>;

Copy&paste, also below. Is this really .dtsi material?

> +
> +			status =3D "disabled";
> +		};
> +
> +		usart3: usart@40004800 {
> +			compatible =3D "st,stm32-usart";
> +			reg =3D <0x40004800 0x400>;
> +			interrupts =3D <39>;
> +			clocks =3D <&clk_pclk1>;
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&pinctrl_usart1>;
> +
> +			status =3D "disabled";
> +		};
> +
> +		usart4: usart@40004c00 {
> +			compatible =3D "st,stm32-usart";
> +			reg =3D <0x40004c00 0x400>;
> +			interrupts =3D <52>;
> +			clocks =3D <&clk_pclk1>;
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&pinctrl_usart1>;
> +
> +			status =3D "disabled";
> +		};
> +
> +		usart5: usart@40005000 {
> +			compatible =3D "st,stm32-usart";
> +			reg =3D <0x40005000 0x400>;
> +			interrupts =3D <53>;
> +			clocks =3D <&clk_pclk1>;
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&pinctrl_usart1>;
> +
> +			status =3D "disabled";
> +		};
> +
> +		usart6: usart@40011400 {
> +			compatible =3D "st,stm32-usart";
> +			reg =3D <0x40011400 0x400>;
> +			interrupts =3D <71>;
> +			clocks =3D <&clk_pclk2>;
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&pinctrl_usart1>;
> +
> +			status =3D "disabled";
> +		};
> +
> +		usart7: usart@40007800 {

Please order all nodes by unit address, not by label.

> +			compatible =3D "st,stm32-usart";
> +			reg =3D <0x40007800 0x400>;
> +			interrupts =3D <82>;
> +			clocks =3D <&clk_pclk1>;
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&pinctrl_usart1>;
> +
> +			status =3D "disabled";
> +		};
> +
> +		usart8: usart@40007c00 {
> +			compatible =3D "st,stm32-usart";
> +			reg =3D <0x40007c00 0x400>;
> +			interrupts =3D <83>;
> +			clocks =3D <&clk_pclk1>;
> +			pinctrl-names =3D "default";
> +			pinctrl-0 =3D <&pinctrl_usart1>;
> +
> +			status =3D "disabled";
> +		};

I remember two of them not being USART but UART? Similarly, two of them
support flow control (or two don't?), for which we would either need a
property or two different compatible strings.

> +	};
> +};

Regards,
Andreas

--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Felix Imend=F6rffer, Jane Smithard, Jennifer Guild, Dilip Upmanyu,
Graham Norton; HRB 21284 (AG N=FCrnberg)


--mi8hoEd27jhdOe10ob0B0cATLdeHAKMsU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJU9KD7AAoJEPou0S0+fgE/FyQQAIUmP//9eYhqDpCpetaeDO9i
vLLB65r+vFyqBgeR2F7GNESaFSU/kih5AYuT2OIMziPpqf6xoqUiUCFvwzqpotJ+
U/mNym/5PG7gn5+5jxUVkgfSdjl32p2MHEDfGrtm5DxJdoEOeDJPEeA44Xn5T/Gi
oKq5vtRqc4GxTuJaduv2BtSStA/oLuI6EC9PXIwdPJDQPhjH8sazWoWaDZV2fSzi
/Rydaz5y6s//fvmgdlBes53CmOHUCRwL4svdMVwY6zDHURJtogMgtJXByG53/4p0
1rxlSdcj+VhutjwzB00q/JMrtPtBkvwkOOfO8pQ2jRpXgetaQE8dz/uZYT95MJdI
rTouo71DB2t5cgZK9DWOZN7yM746BmeIo/YK+rRHfcFJR9qOyvQdk0D8gbNEsx+K
zKwf13L8O8K/PnNahLxpF62y4ZhDwyINex81HXV2Vs2W7ug4uOgzBA9XuVIyiN1P
oCF5gIifeY64P2AVeSJaQ0JRHJnEPgXp8had9Z5SQNG31rosDK3fy9c7YApQESFM
kzoFLhwdI6I01j/zbr45M2P3D/oXJmSiBvO3e8OG+GvySnEuGt31b1asvProVqFM
b8Rcrn+GgHRcq8eK+APKlteYu3ADkl3fTwx/8KXCeb+87HYsGEC6gAw3/FboThs7
49QooO16zfYTMVYr2vF6
=qSD/
-----END PGP SIGNATURE-----

--mi8hoEd27jhdOe10ob0B0cATLdeHAKMsU--
