From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 03/14] clocksource: Add ARM System timer driver
Date: Mon, 16 Feb 2015 00:43:53 +0100
Message-ID: <54E12F39.6030509@suse.de>
References: <1423763164-5606-1-git-send-email-mcoquelin.stm32@gmail.com> <1423763164-5606-4-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423763164-5606-4-git-send-email-mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Nikolay Borisov <Nikolay.Borisov-5wv7dgnIgG8@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Micha
List-Id: linux-api@vger.kernel.org

Am 12.02.2015 um 18:45 schrieb Maxime Coquelin:
> This patch adds clocksource support for ARMv7-M's System timer,
> also known as SysTick.
>=20
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  .../devicetree/bindings/arm/system_timer.txt       | 15 +++++
>  drivers/clocksource/Kconfig                        |  7 ++
>  drivers/clocksource/Makefile                       |  1 +
>  drivers/clocksource/arm_system_timer.c             | 74 ++++++++++++=
++++++++++
>  4 files changed, 97 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/system_time=
r.txt
>  create mode 100644 drivers/clocksource/arm_system_timer.c
>=20
> diff --git a/Documentation/devicetree/bindings/arm/system_timer.txt b=
/Documentation/devicetree/bindings/arm/system_timer.txt
> new file mode 100644
> index 0000000..35268b7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/system_timer.txt
> @@ -0,0 +1,15 @@
> +* ARM System Timer
> +
> +ARMv7-M includes a system timer, known as SysTick. Current driver on=
ly
> +implements the clocksource feature.
> +
> +Required properties:
> +- compatible : Should be "arm,armv7m-systick"
> +- reg	     : The address range of the timer
> +- clocks     : The input clock of the timer
> +
> +systick: system-timer {
> +	compatible =3D "arm,armv7m-systick";
> +	reg =3D <0xe000e010 0x10>;
> +	clocks =3D <&clk_systick>;
> +};

Binding documentation is supposed to go into its own patch:
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/D=
ocumentation/devicetree/bindings/submitting-patches.txt

> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfi=
g
> index fc01ec2..f9fe4ac 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -124,6 +124,13 @@ config CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
>  	help
>  	 Use ARM global timer clock source as sched_clock
> =20
> +config ARM_SYSTEM_TIMER
> +	bool
> +	select CLKSRC_OF if OF
> +	select CLKSRC_MMIO
> +	help
> +	  This options enables support for the ARM system timer unit
> +
>  config ATMEL_PIT
>  	select CLKSRC_OF if OF
>  	def_bool SOC_AT91SAM9 || SOC_SAMA5
> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makef=
ile
> index 94d90b2..194400b 100644
> --- a/drivers/clocksource/Makefile
> +++ b/drivers/clocksource/Makefile
> @@ -42,6 +42,7 @@ obj-$(CONFIG_MTK_TIMER)		+=3D mtk_timer.o
> =20
>  obj-$(CONFIG_ARM_ARCH_TIMER)		+=3D arm_arch_timer.o
>  obj-$(CONFIG_ARM_GLOBAL_TIMER)		+=3D arm_global_timer.o
> +obj-$(CONFIG_ARM_SYSTEM_TIMER)		+=3D arm_system_timer.o
>  obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+=3D metag_generic.o
>  obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)	+=3D dummy_timer.o
>  obj-$(CONFIG_ARCH_KEYSTONE)		+=3D timer-keystone.o
> diff --git a/drivers/clocksource/arm_system_timer.c b/drivers/clockso=
urce/arm_system_timer.c
> new file mode 100644
> index 0000000..69e6ef9
> --- /dev/null
> +++ b/drivers/clocksource/arm_system_timer.c
> @@ -0,0 +1,74 @@
> +/*
> + * Copyright (C) Maxime Coquelin 2015
> + * Author:  Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> + * License terms:  GNU General Public License (GPL), version 2
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/clocksource.h>
> +#include <linux/clockchips.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/clk.h>
> +#include <linux/bitops.h>
> +
> +#define SYST_CSR	0x00
> +#define SYST_RVR	0x04
> +#define SYST_CVR	0x08
> +#define SYST_CALIB	0x0c
> +
> +#define SYST_CSR_ENABLE BIT(0)
> +
> +#define SYSTICK_LOAD_RELOAD_MASK 0x00FFFFFF
> +
> +static void __init system_timer_of_register(struct device_node *np)
> +{
> +	struct clk *clk;
> +	void __iomem *base;
> +	unsigned long rate;
> +	int ret;
> +
> +	base =3D of_iomap(np, 0);
> +	if (!base) {
> +		pr_warn("system-timer: invalid base address\n");
> +		return;
> +	}
> +
> +	clk =3D of_clk_get(np, 0);
> +	if (IS_ERR(clk)) {
> +		pr_warn("system-timer: clk not found\n");
> +		ret =3D PTR_ERR(clk);
> +		goto out_unmap;
> +	}
> +
> +	ret =3D clk_prepare_enable(clk);
> +	if (ret)
> +		goto out_clk_put;
> +
> +	rate =3D clk_get_rate(clk);
> +
> +	writel_relaxed(SYSTICK_LOAD_RELOAD_MASK, base + SYST_RVR);
> +	writel_relaxed(SYST_CSR_ENABLE, base + SYST_CSR);
> +
> +	ret =3D clocksource_mmio_init(base + SYST_CVR, "arm_system_timer", =
rate,
> +			200, 24, clocksource_mmio_readl_down);
> +	if (ret) {
> +		pr_err("failed to init clocksource (%d)\n", ret);
> +		goto out_clk_disable;
> +	}
> +
> +	pr_info("ARM System timer initialized as clocksource\n");
> +
> +	return;
> +
> +out_clk_disable:
> +	clk_disable_unprepare(clk);
> +out_clk_put:
> +	clk_put(clk);
> +out_unmap:
> +	iounmap(base);
> +	WARN(ret, "ARM System timer register failed (%d)\n", ret);
> +}
> +
> +CLOCKSOURCE_OF_DECLARE(arm_systick, "arm,armv7m-systick",
> +			system_timer_of_register);

I've used a SysTick based implementation on my stm32 branch myself, but
looking at efm32 I got the impression that it would be better to use on=
e
of the 32-bit TIM2/TIM5 as clocksource and the other as clockevents?

Still this implementation will be handy to have, also for other targets=
=2E

Regards,
Andreas

--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Felix Imend=F6rffer, Jane Smithard, Jennifer Guild, Dilip Upmanyu,
Graham Norton; HRB 21284 (AG N=FCrnberg)
