From: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v1 09/10] ARM: dts: introduce MPS2 AN385/AN386
Date: Wed, 23 Dec 2015 09:33:46 +0000
Message-ID: <567A6A7A.7080400@arm.com>
References: <1449048790-25859-1-git-send-email-vladimir.murzin@arm.com> <1449048790-25859-10-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449048790-25859-10-git-send-email-vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: arnd-r2nGTMty4D4@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, afaerber-l3A5Bk7waGM@public.gmane.org, mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Mark.Rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pawel.Moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

I'd very appreciate some feedback on this (and following) patch from DT
camp, so I could incorporate them in the next attempt after merge window
closed.

Merry Christmas!
Vladimir

On 02/12/15 09:33, Vladimir Murzin wrote:
> Application Notes 385 and 386 shares the same memory map and features
> except the CPU is used. AN385 is supplied with Cortex-M3 CPU and AN386
> is supplied with Cortex-M4.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
> ---
>  arch/arm/boot/dts/Makefile       |    1 +
>  arch/arm/boot/dts/mps2-an385.dts |   90 +++++++++++++++
>  arch/arm/boot/dts/mps2.dtsi      |  227 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 318 insertions(+)
>  create mode 100644 arch/arm/boot/dts/mps2-an385.dts
>  create mode 100644 arch/arm/boot/dts/mps2.dtsi
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 30bbc37..4ef3720 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -237,6 +237,7 @@ dtb-$(CONFIG_ARCH_MMP) += \
>  dtb-$(CONFIG_MACH_MESON8B) += \
>  	meson8b-mxq.dtb \
>  	meson8b-odroidc1.dtb
> +dtb-$(CONFIG_ARCH_MPS2) += mps2-an385.dtb
>  dtb-$(CONFIG_ARCH_MOXART) += \
>  	moxart-uc7112lx.dtb
>  dtb-$(CONFIG_SOC_IMX1) += \
> diff --git a/arch/arm/boot/dts/mps2-an385.dts b/arch/arm/boot/dts/mps2-an385.dts
> new file mode 100644
> index 0000000..ddb03d3
> --- /dev/null
> +++ b/arch/arm/boot/dts/mps2-an385.dts
> @@ -0,0 +1,90 @@
> +/*
> + * Copyright (C) 2015 ARM Limited
> + *
> + * Author: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
> + *
> + * This file is dual-licensed: you can use it either under the terms
> + * of the GPL or the X11 license, at your option. Note that this dual
> + * licensing only applies to this file, and not this project as a
> + * whole.
> + *
> + *  a) This file is free software; you can redistribute it and/or
> + *     modify it under the terms of the GNU General Public License as
> + *     published by the Free Software Foundation; either version 2 of the
> + *     License, or (at your option) any later version.
> + *
> + *     This file is distributed in the hope that it will be useful,
> + *     but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *     GNU General Public License for more details.
> + *
> + * Or, alternatively,
> + *
> + *  b) Permission is hereby granted, free of charge, to any person
> + *     obtaining a copy of this software and associated documentation
> + *     files (the "Software"), to deal in the Software without
> + *     restriction, including without limitation the rights to use,
> + *     copy, modify, merge, publish, distribute, sublicense, and/or
> + *     sell copies of the Software, and to permit persons to whom the
> + *     Software is furnished to do so, subject to the following
> + *     conditions:
> + *
> + *     The above copyright notice and this permission notice shall be
> + *     included in all copies or substantial portions of the Software.
> + *
> + *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
> + *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
> + *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
> + *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> + *     OTHER DEALINGS IN THE SOFTWARE.
> + */
> +
> +/dts-v1/;
> +
> +#include "mps2.dtsi"
> +
> +/ {
> +	model = "ARM MPS2 Application Note 385/386";
> +	compatible = "arm,mps2";
> +
> +	aliases {
> +		serial0 = &uart0;
> +	};
> +
> +	chosen {
> +		bootargs = "init=/sbin/init earlycon";
> +		stdout-path = "serial0:9600n8";
> +	};
> +
> +	memory {
> +		device_type = "memory";
> +		reg = <0x21000000 0x1000000>;
> +	};
> +
> +	ethernet@40200000 {
> +		compatible = "smsc,lan9220", "smsc,lan9115";
> +		reg = <0x40200000 0x10000>;
> +		interrupts = <13>;
> +		interrupt-parent = <&nvic>;
> +		smsc,irq-active-high;
> +	};
> +};
> +
> +&uart0 {
> +	status = "okay";
> +};
> +
> +&timer0 {
> +	status = "okay";
> +};
> +
> +&timer1 {
> +	status = "okay";
> +};
> +
> +&wdt {
> +	status = "okay";
> +};
> diff --git a/arch/arm/boot/dts/mps2.dtsi b/arch/arm/boot/dts/mps2.dtsi
> new file mode 100644
> index 0000000..5d2c539
> --- /dev/null
> +++ b/arch/arm/boot/dts/mps2.dtsi
> @@ -0,0 +1,227 @@
> +/*
> + * Copyright (C) 2015 ARM Limited
> + *
> + * Author: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
> + *
> + * This file is dual-licensed: you can use it either under the terms
> + * of the GPL or the X11 license, at your option. Note that this dual
> + * licensing only applies to this file, and not this project as a
> + * whole.
> + *
> + *  a) This file is free software; you can redistribute it and/or
> + *     modify it under the terms of the GNU General Public License as
> + *     published by the Free Software Foundation; either version 2 of the
> + *     License, or (at your option) any later version.
> + *
> + *     This file is distributed in the hope that it will be useful,
> + *     but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *     GNU General Public License for more details.
> + *
> + * Or, alternatively,
> + *
> + *  b) Permission is hereby granted, free of charge, to any person
> + *     obtaining a copy of this software and associated documentation
> + *     files (the "Software"), to deal in the Software without
> + *     restriction, including without limitation the rights to use,
> + *     copy, modify, merge, publish, distribute, sublicense, and/or
> + *     sell copies of the Software, and to permit persons to whom the
> + *     Software is furnished to do so, subject to the following
> + *     conditions:
> + *
> + *     The above copyright notice and this permission notice shall be
> + *     included in all copies or substantial portions of the Software.
> + *
> + *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
> + *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
> + *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
> + *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> + *     OTHER DEALINGS IN THE SOFTWARE.
> + */
> +
> +#include "armv7-m.dtsi"
> +
> +/ {
> +	oscclk0: clk-osc0 {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <50000000>;
> +	};
> +
> +	oscclk1: clk-osc1 {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <24576000>;
> +	};
> +
> +	oscclk2: clk-osc2 {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <25000000>;
> +	};
> +
> +	cfgclk: clk-cfg {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <5000000>;
> +	};
> +
> +	spicfgclk: clk-spicfg {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <75000000>;
> +	};
> +
> +	sysclk: clk-sys {
> +		compatible = "fixed-factor-clock";
> +		clocks = <&oscclk0>;
> +		#clock-cells = <0>;
> +		clock-div = <2>;
> +		clock-mult = <1>;
> +	};
> +
> +	audmclk: clk-audm {
> +		compatible = "fixed-factor-clock";
> +		clocks = <&oscclk1>;
> +		#clock-cells = <0>;
> +		clock-div = <2>;
> +		clock-mult = <1>;
> +	};
> +
> +	audsclk: clk-auds {
> +		compatible = "fixed-factor-clock";
> +		clocks = <&oscclk1>;
> +		#clock-cells = <0>;
> +		clock-div = <8>;
> +		clock-mult = <1>;
> +	};
> +
> +	spiclcd: clk-cpiclcd {
> +		compatible = "fixed-factor-clock";
> +		clocks = <&oscclk0>;
> +		#clock-cells = <0>;
> +		clock-div = <2>;
> +		clock-mult = <1>;
> +	};
> +
> +	spicon: clk-spicon {
> +		compatible = "fixed-factor-clock";
> +		clocks = <&oscclk0>;
> +		#clock-cells = <0>;
> +		clock-div = <2>;
> +		clock-mult = <1>;
> +	};
> +
> +	i2cclcd: clk-i2cclcd {
> +		compatible = "fixed-factor-clock";
> +		clocks = <&oscclk0>;
> +		#clock-cells = <0>;
> +		clock-div = <2>;
> +		clock-mult = <1>;
> +	};
> +
> +	i2caud: clk-i2caud {
> +		compatible = "fixed-factor-clock";
> +		clocks = <&oscclk0>;
> +		#clock-cells = <0>;
> +		clock-div = <2>;
> +		clock-mult = <1>;
> +	};
> +
> +	soc {
> +		compatible = "simple-bus";
> +		ranges;
> +
> +		apb {
> +			compatible = "simple-bus";
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			ranges = <0 0x40000000 0x10000>;
> +
> +			timer0: mps2-timer0@0 {
> +				compatible = "arm,mps2-timer";
> +				reg = <0x0 0x1000>;
> +				interrupts = <8>;
> +				clocks = <&sysclk>;
> +				status = "disabled";
> +			};
> +
> +			timer1: mps2-timer1@1000 {
> +				compatible = "arm,mps2-timer";
> +				reg = <0x1000 0x1000>;
> +				interrupts = <9>;
> +				clocks = <&sysclk>;
> +				status = "disabled";
> +			};
> +
> +			timer2: dual-timer@2000 {
> +				compatible = "arm,sp804";
> +				reg = <0x2000 0x1000>;
> +				clocks = <&sysclk>;
> +				interrupts = <10>;
> +				status = "disabled";
> +			};
> +
> +
> +			uart0: serial@4000 {
> +				compatible = "arm,mps2-uart";
> +				reg = <0x4000 0x1000>;
> +				interrupts = <0 1 12>;
> +				clocks = <&sysclk>;
> +				status = "disabled";
> +			};
> +
> +			uart1: serial@5000 {
> +				compatible = "arm,mps2-uart";
> +				reg = <0x5000 0x1000>;
> +				interrupts = <2 3 12>;
> +				clocks = <&sysclk>;
> +				status = "disabled";
> +			};
> +
> +			uart2: serial@6000 {
> +				compatible = "arm,mps2-uart";
> +				reg = <0x6000 0x1000>;
> +				interrupts = <4 5 12>;
> +				clocks = <&sysclk>;
> +				status = "disabled";
> +			};
> +
> +			wdt: watchdog@8000 {
> +				compatible = "arm,sp805", "arm,primecell";
> +				arm,primecell-periphid = <0x00141805>;
> +				reg = <0x8000 0x1000>;
> +				interrupts = <0>;
> +				clocks = <&sysclk>;
> +				clock-names = "apb_pclk";
> +				status = "disabled";
> +			};
> +		};
> +
> +		fpgaio {
> +			compatible = "syscon", "simple-mfd";
> +			reg = <0x40028000 0x10>;
> +
> +			led@0 {
> +				compatible = "register-bit-led";
> +				offset = <0x0>;
> +				mask = <0x01>;
> +				label = "userled:0";
> +				linux,default-trigger = "heartbeat";
> +				default-state = "on";
> +			};
> +
> +			led@1 {
> +				compatible = "register-bit-led";
> +				offset = <0x0>;
> +				mask = <0x02>;
> +				label = "userled:1";
> +				linux,default-trigger = "usr";
> +				default-state = "off";
> +			};
> +		};
> +	};
> +};
> 

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
