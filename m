From: Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 04/15] clocksource/drivers: Add ARM System timer driver
Date: Thu, 09 Apr 2015 12:52:54 +0200
Message-ID: <55265A06.5020902@linaro.org>
References: <1428424234-28572-1-git-send-email-mcoquelin.stm32@gmail.com> <1428424234-28572-5-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428424234-28572-5-git-send-email-mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, afaerber-l3A5Bk7waGM@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, stefan-XLVq0VzYD2Y@public.gmane.org, pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org, pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org, peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Nikolay Borisov <Nikolay.Borisov-5wv7dgnIgG8@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TZNg+MwTxZMZA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 04/07/2015 06:30 PM, Maxime Coquelin wrote:
> This patch adds clocksource support for ARMv7-M's System timer,
> also known as SysTick.
>
> Tested-by: Chanwoo Choi <cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

> ---
>   drivers/clocksource/Kconfig          |  7 ++++
>   drivers/clocksource/Makefile         |  1 +
>   drivers/clocksource/armv7m_systick.c | 79 +++++++++++++++++++++++++=
+++++++++++
>   3 files changed, 87 insertions(+)
>   create mode 100644 drivers/clocksource/armv7m_systick.c
>
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfi=
g
> index 1c2506f..b82e58b 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -134,6 +134,13 @@ config CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
>   	help
>   	 Use ARM global timer clock source as sched_clock
>
> +config ARMV7M_SYSTICK
> +	bool
> +	select CLKSRC_OF if OF
> +	select CLKSRC_MMIO
> +	help
> +	  This options enables support for the ARMv7M system timer unit
> +
>   config ATMEL_PIT
>   	select CLKSRC_OF if OF
>   	def_bool SOC_AT91SAM9 || SOC_SAMA5
> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makef=
ile
> index 752d5c7..1c9a643 100644
> --- a/drivers/clocksource/Makefile
> +++ b/drivers/clocksource/Makefile
> @@ -44,6 +44,7 @@ obj-$(CONFIG_MTK_TIMER)		+=3D mtk_timer.o
>
>   obj-$(CONFIG_ARM_ARCH_TIMER)		+=3D arm_arch_timer.o
>   obj-$(CONFIG_ARM_GLOBAL_TIMER)		+=3D arm_global_timer.o
> +obj-$(CONFIG_ARMV7M_SYSTICK)		+=3D armv7m_systick.o
>   obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+=3D metag_generic.o
>   obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)	+=3D dummy_timer.o
>   obj-$(CONFIG_ARCH_KEYSTONE)		+=3D timer-keystone.o
> diff --git a/drivers/clocksource/armv7m_systick.c b/drivers/clocksour=
ce/armv7m_systick.c
> new file mode 100644
> index 0000000..addfd2c
> --- /dev/null
> +++ b/drivers/clocksource/armv7m_systick.c
> @@ -0,0 +1,79 @@
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
> +	struct clk *clk =3D NULL;
> +	void __iomem *base;
> +	u32 rate;
> +	int ret;
> +
> +	base =3D of_iomap(np, 0);
> +	if (!base) {
> +		pr_warn("system-timer: invalid base address\n");
> +		return;
> +	}
> +
> +	ret =3D of_property_read_u32(np, "clock-frequency", &rate);
> +	if (ret) {
> +		clk =3D of_clk_get(np, 0);
> +		if (IS_ERR(clk))
> +			goto out_unmap;
> +
> +		ret =3D clk_prepare_enable(clk);
> +		if (ret)
> +			goto out_clk_put;
> +
> +		rate =3D clk_get_rate(clk);
> +		if (!rate)
> +			goto out_clk_disable;
> +	}
> +
> +	writel_relaxed(SYSTICK_LOAD_RELOAD_MASK, base + SYST_RVR);
> +	writel_relaxed(SYST_CSR_ENABLE, base + SYST_CSR);
> +
> +	ret =3D clocksource_mmio_init(base + SYST_CVR, "arm_system_timer", =
rate,
> +			200, 24, clocksource_mmio_readl_down);
> +	if (ret) {
> +		pr_err("failed to init clocksource (%d)\n", ret);
> +		if (clk)
> +			goto out_clk_disable;
> +		else
> +			goto out_unmap;
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
> +	pr_warn("ARM System timer register failed (%d)\n", ret);
> +}
> +
> +CLOCKSOURCE_OF_DECLARE(arm_systick, "arm,armv7m-systick",
> +			system_timer_of_register);
>


--=20
  <http://www.linaro.org/> Linaro.org =E2=94=82 Open source software fo=
r ARM SoCs

=46ollow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
