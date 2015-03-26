From: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v3  04/15] clocksource: Add ARM System timer driver
Date: Thu, 26 Mar 2015 10:50:02 +0100
Message-ID: <5513D64A.7060702@linaro.org>
References: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com> <1426197361-19290-5-git-send-email-maxime.coquelin@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <1426197361-19290-5-git-send-email-maxime.coquelin@st.com>
Sender: linux-gpio-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>, u.kleine-koenig@pengutronix.de, afaerber@suse.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, stefan@agner.ch, pmeerw@pmeerw.net, pebolle@tiscali.nl
Cc: Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>, Michal Marek <mmarek@suse.cz>, linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-gpi
List-Id: linux-api@vger.kernel.org

On 03/12/2015 10:55 PM, Maxime Coquelin wrote:
> From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>
> This patch adds clocksource support for ARMv7-M's System timer,
> also known as SysTick.
>
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>

Hi Maxime,

the driver looks good. Three comments below.

   -- Daniel

> ---
>   drivers/clocksource/Kconfig          |  7 ++++
>   drivers/clocksource/Makefile         |  1 +
>   drivers/clocksource/armv7m_systick.c | 78 +++++++++++++++++++++++++=
+++++++++++
>   3 files changed, 86 insertions(+)
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
> index 0000000..23d8249
> --- /dev/null
> +++ b/drivers/clocksource/armv7m_systick.c
> @@ -0,0 +1,78 @@
> +/*
> + * Copyright (C) Maxime Coquelin 2015
> + * Author:  Maxime Coquelin <mcoquelin.stm32@gmail.com>
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
> +	u32 rate =3D 0;
> +	int ret;
> +
> +	base =3D of_iomap(np, 0);
> +	if (!base) {
> +		pr_warn("system-timer: invalid base address\n");
> +		return;
> +	}
> +
> +	clk =3D of_clk_get(np, 0);
> +	if (!IS_ERR(clk)) {
> +		ret =3D clk_prepare_enable(clk);
> +		if (ret) {
> +			clk_put(clk);
> +			goto out_unmap;
> +		}
> +
> +		rate =3D clk_get_rate(clk);
> +	}
> +
> +	/* If no clock found, try to get clock-frequency property */
> +	if (!rate) {
> +		ret =3D of_property_read_u32(np, "clock-frequency", &rate);
> +		if (ret)
> +			goto out_unmap;

Shouldn't be 'goto out_clk_disable' ?

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
> +		goto out_clk_disable;
> +	}
> +
> +	pr_info("ARM System timer initialized as clocksource\n");
> +
> +	return;
> +
> +out_clk_disable:
> +	if (!IS_ERR(clk))

Why do you need this check ?

It isn't missing a clk_put ?

> +		clk_disable_unprepare(clk);
> +out_unmap:
> +	iounmap(base);
> +	WARN(ret, "ARM System timer register failed (%d)\n", ret);
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

--
To unsubscribe from this list: send the line "unsubscribe linux-gpio" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
