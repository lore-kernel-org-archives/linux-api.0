From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH v2 14/18] ARM: Add STM32 family machine
Date: Fri, 20 Feb 2015 21:00:19 +0100
Message-ID: <20150220200019.GU19388@pengutronix.de>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
 <1424455277-29983-15-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1424455277-29983-15-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: afaerber@suse.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rust
List-Id: linux-api@vger.kernel.org

Hello,

On Fri, Feb 20, 2015 at 07:01:13PM +0100, Maxime Coquelin wrote:
> STMicrolectronics's STM32 series is a family of Cortex-M
> microcontrollers. It is used in various applications, and
> proposes a wide range of peripherals.
>=20
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> ---
>  Documentation/arm/stm32/overview.txt           | 32 ++++++++++++++++=
++++++++++
>  Documentation/arm/stm32/stm32f429-overview.txt | 22 ++++++++++++++++=
++
>  arch/arm/Kconfig                               | 22 ++++++++++++++++=
++
>  arch/arm/Makefile                              |  1 +
>  arch/arm/mach-stm32/Makefile                   |  1 +
>  arch/arm/mach-stm32/Makefile.boot              |  0
>  arch/arm/mach-stm32/board-dt.c                 | 31 ++++++++++++++++=
+++++++++
>  7 files changed, 109 insertions(+)
>  create mode 100644 Documentation/arm/stm32/overview.txt
>  create mode 100644 Documentation/arm/stm32/stm32f429-overview.txt
>  create mode 100644 arch/arm/mach-stm32/Makefile
>  create mode 100644 arch/arm/mach-stm32/Makefile.boot
>  create mode 100644 arch/arm/mach-stm32/board-dt.c
>=20
> diff --git a/Documentation/arm/stm32/overview.txt b/Documentation/arm=
/stm32/overview.txt
> new file mode 100644
> index 0000000..d8bf6bb
> --- /dev/null
> +++ b/Documentation/arm/stm32/overview.txt
> @@ -0,0 +1,32 @@
> +			STM32 ARM Linux Overview
> +			=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> +
> +Introduction
> +------------
> +
> +  The STMicroelectronics family of Cortex-M based MCUs are supported=
 by the
> +  'STM32' platform of ARM Linux. Currently only the STM32F429 is sup=
ported.
> +
> +
> +Configuration
> +-------------
> +
> +  A generic configuration is provided for STM32 family, and can be u=
sed as the
> +  default by
> +	make stm32_defconfig
> +
> +Layout
> +------
> +
> +  All the files for multiple machine families are located in the pla=
tform code
> +  contained in arch/arm/mach-stm32
> +
> +  There is a generic board board-dt.c in the mach folder which suppo=
rt
> +  Flattened Device Tree, which means, It works with any compatible b=
oard with
> +  Device Trees.
> +
> +
> +Document Author
> +---------------
> +
> +  Maxime Coquelin <mcoquelin.stm32@gmail.com>
> diff --git a/Documentation/arm/stm32/stm32f429-overview.txt b/Documen=
tation/arm/stm32/stm32f429-overview.txt
> new file mode 100644
> index 0000000..5206822
> --- /dev/null
> +++ b/Documentation/arm/stm32/stm32f429-overview.txt
> @@ -0,0 +1,22 @@
> +			STM32F429 Overview
> +			=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +  Introduction
> +  ------------
> +	The STM32F429 is a Cortex-M4 MCU aimed at various applications.
> +	It features:
> +	- ARM Cortex-M4 up to 180MHz with FPU
> +	- 2MB internal Flash Memory
> +	- External memory support through FMC controller (PSRAM, SDRAM, NOR=
, NAND)
> +	- I2C, SPI, SAI, CAN, USB OTG, Ethernet controllers
> +	- LCD controller & Camera interface
> +	- Cryptographic processor
> +
> +  Resources
> +  ---------
> +	Datasheet and reference manual are publicly available on ST website=
:
> +	- http://www.st.com/web/en/catalog/mmc/FM141/SC1169/SS1577/LN1806?e=
cmp=3Dstm32f429-439_pron_pr-ces2014_nov2013
> +
> +  Document Author
> +  ---------------
> +	Maxime Coquelin <mcoquelin.stm32@gmail.com>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 97d07ed..cfd9532 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -774,6 +774,28 @@ config ARCH_OMAP1
>  	help
>  	  Support for older TI OMAP1 (omap7xx, omap15xx or omap16xx)
> =20
> +config ARCH_STM32
> +	bool "STMicrolectronics STM32"
> +	depends on !MMU
> +	select ARCH_REQUIRE_GPIOLIB
> +	select ARM_NVIC
> +	select AUTO_ZRELADDR
> +	select ARCH_HAS_RESET_CONTROLLER
> +	select RESET_CONTROLLER
> +	select PINCTRL
> +	select PINCTRL_STM32
> +	select CLKSRC_OF
> +	select ARMV7M_SYSTICK
> +	select COMMON_CLK
> +	select CPU_V7M
> +	select GENERIC_CLOCKEVENTS
> +	select NO_DMA
> +	select NO_IOPORT_MAP
> +	select SPARSE_IRQ
> +	select USE_OF
Please sort this list alphabetically.

> +	help
> +	  Support for STMicorelectronics STM32 processors.
> +
>  endchoice
> =20
>  menu "Multiple platform selection"
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index c1785ee..7d00659 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -196,6 +196,7 @@ machine-$(CONFIG_ARCH_SHMOBILE) 	+=3D shmobile
>  machine-$(CONFIG_ARCH_SIRF)		+=3D prima2
>  machine-$(CONFIG_ARCH_SOCFPGA)		+=3D socfpga
>  machine-$(CONFIG_ARCH_STI)		+=3D sti
> +machine-$(CONFIG_ARCH_STM32)		+=3D stm32
>  machine-$(CONFIG_ARCH_SUNXI)		+=3D sunxi
>  machine-$(CONFIG_ARCH_TEGRA)		+=3D tegra
>  machine-$(CONFIG_ARCH_U300)		+=3D u300
> diff --git a/arch/arm/mach-stm32/Makefile b/arch/arm/mach-stm32/Makef=
ile
> new file mode 100644
> index 0000000..bd0b7b5
> --- /dev/null
> +++ b/arch/arm/mach-stm32/Makefile
> @@ -0,0 +1 @@
> +obj-y +=3D board-dt.o
> diff --git a/arch/arm/mach-stm32/Makefile.boot b/arch/arm/mach-stm32/=
Makefile.boot
> new file mode 100644
> index 0000000..e69de29
Maybe note there why this file exists and can be empty. Feel free to
copy the content of efm32's Makefile.boot.

> diff --git a/arch/arm/mach-stm32/board-dt.c b/arch/arm/mach-stm32/boa=
rd-dt.c
> new file mode 100644
> index 0000000..1d681b3
> --- /dev/null
> +++ b/arch/arm/mach-stm32/board-dt.c
> @@ -0,0 +1,31 @@
> +/*
> + * Copyright (C) Maxime Coquelin 2015
> + * Author:  Maxime Coquelin <mcoquelin.stm32@gmail.com>
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/clk-provider.h>
> +#include <linux/clocksource.h>
> +#include <linux/reset-controller.h>
> +#include <asm/v7m.h>
> +#include <asm/mach/arch.h>
> +
> +static const char *const stm32_compat[] __initconst =3D {
> +	"st,stm32f429",
> +	NULL
> +};
> +
> +static void __init stm32_timer_init(void)
> +{
> +	of_clk_init(NULL);
> +	reset_controller_of_init();
> +	clocksource_of_init();
Hmm, if reset_controller_of_init was called automatically you wouldn't
need that, right? Maybe arange for that instead?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig        =
    |
Industrial Linux Solutions                 | http://www.pengutronix.de/=
  |
