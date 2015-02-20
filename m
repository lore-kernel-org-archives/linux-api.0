From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 09/18] clockevent: Add STM32 Timer driver
Date: Fri, 20 Feb 2015 19:01:08 +0100
Message-ID: <1424455277-29983-10-git-send-email-mcoquelin.stm32__10732.0411051207$1424455593$gmane$org@gmail.com>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424455277-29983-1-git-send-email-mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, afaerber-l3A5Bk7waGM@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will
List-Id: linux-api@vger.kernel.org

STM32 MCUs feature 16 and 32 bits general purpose timers with prescalers.
The drivers detects whether the time is 16 or 32 bits, and applies a
1024 prescaler value if it is 16 bits.

Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/clocksource/Kconfig       |   9 ++
 drivers/clocksource/Makefile      |   1 +
 drivers/clocksource/timer-stm32.c | 187 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 197 insertions(+)
 create mode 100644 drivers/clocksource/timer-stm32.c

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index fb6011e..f372329 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -91,6 +91,15 @@ config CLKSRC_EFM32
 	  Support to use the timers of EFM32 SoCs as clock source and clock
 	  event device.
 
+config CLKSRC_STM32
+	bool "Clocksource for STM32 SoCs" if !ARCH_STM32
+	depends on OF && ARM && (ARCH_STM32 || COMPILE_TEST)
+	select CLKSRC_MMIO
+	default ARCH_STM32
+	help
+	  Support to use the timers of STM32 SoCs as clock source and clock
+	  event device.
+
 config ARM_ARCH_TIMER
 	bool
 	select CLKSRC_OF if OF
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index eeea736..8078178 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_ARCH_NSPIRE)	+= zevio-timer.o
 obj-$(CONFIG_ARCH_BCM_MOBILE)	+= bcm_kona_timer.o
 obj-$(CONFIG_CADENCE_TTC_TIMER)	+= cadence_ttc_timer.o
 obj-$(CONFIG_CLKSRC_EFM32)	+= time-efm32.o
+obj-$(CONFIG_CLKSRC_STM32)	+= timer-stm32.o
 obj-$(CONFIG_CLKSRC_EXYNOS_MCT)	+= exynos_mct.o
 obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)	+= samsung_pwm_timer.o
 obj-$(CONFIG_FSL_FTM_TIMER)	+= fsl_ftm_timer.o
diff --git a/drivers/clocksource/timer-stm32.c b/drivers/clocksource/timer-stm32.c
new file mode 100644
index 0000000..9839f57
--- /dev/null
+++ b/drivers/clocksource/timer-stm32.c
@@ -0,0 +1,187 @@
+/*
+ * Copyright (C) Maxime Coquelin 2015
+ * Author:  Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Inspired by time-efm32.c from Uwe Kleine-Koenig
+ */
+
+#include <linux/kernel.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/clk.h>
+#include <linux/reset.h>
+
+#define TIM_CR1		0x00
+#define TIM_DIER	0x0c
+#define TIM_SR		0x10
+#define TIM_EGR		0x14
+#define TIM_PSC		0x28
+#define TIM_ARR		0x2c
+
+#define TIM_CR1_CEN	BIT(0)
+#define TIM_CR1_OPM	BIT(3)
+#define TIM_CR1_ARPE	BIT(7)
+
+#define TIM_DIER_UIE	BIT(0)
+
+#define TIM_SR_UIF	BIT(0)
+
+#define TIM_EGR_UG	BIT(0)
+
+struct stm32_clock_event_ddata {
+	struct clock_event_device evtdev;
+	unsigned periodic_top;
+	void __iomem *base;
+};
+
+static void stm32_clock_event_set_mode(enum clock_event_mode mode,
+				       struct clock_event_device *evtdev)
+{
+	struct stm32_clock_event_ddata *data =
+		container_of(evtdev, struct stm32_clock_event_ddata, evtdev);
+	void *base = data->base;
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		writel_relaxed(data->periodic_top, base + TIM_ARR);
+		writel_relaxed(TIM_CR1_ARPE | TIM_CR1_CEN, base + TIM_CR1);
+		break;
+
+	case CLOCK_EVT_MODE_ONESHOT:
+	default:
+		writel_relaxed(0, base + TIM_CR1);
+		break;
+	}
+}
+
+static int stm32_clock_event_set_next_event(unsigned long evt,
+					    struct clock_event_device *evtdev)
+{
+	struct stm32_clock_event_ddata *data =
+		container_of(evtdev, struct stm32_clock_event_ddata, evtdev);
+
+	writel_relaxed(evt, data->base + TIM_ARR);
+	writel_relaxed(TIM_CR1_ARPE | TIM_CR1_OPM | TIM_CR1_CEN,
+		       data->base + TIM_CR1);
+
+	return 0;
+}
+
+static irqreturn_t stm32_clock_event_handler(int irq, void *dev_id)
+{
+	struct stm32_clock_event_ddata *data = dev_id;
+
+	writel_relaxed(0, data->base + TIM_SR);
+
+	data->evtdev.event_handler(&data->evtdev);
+
+	return IRQ_HANDLED;
+}
+
+static struct stm32_clock_event_ddata clock_event_ddata = {
+	.evtdev = {
+		.name = "stm32 clockevent",
+		.features = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
+		.set_mode = stm32_clock_event_set_mode,
+		.set_next_event = stm32_clock_event_set_next_event,
+		.rating = 200,
+	},
+};
+
+static void __init stm32_clockevent_init(struct device_node *np)
+{
+	struct stm32_clock_event_ddata *data = &clock_event_ddata;
+	struct clk *clk;
+	struct reset_control *rstc;
+	unsigned long rate, max_delta;
+	int irq, ret, bits, prescaler = 1;
+
+	clk = of_clk_get(np, 0);
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		pr_err("failed to get clock for clockevent (%d)\n", ret);
+		goto err_clk_get;
+	}
+
+	ret = clk_prepare_enable(clk);
+	if (ret) {
+		pr_err("failed to enable timer clock for clockevent (%d)\n",
+		       ret);
+		goto err_clk_enable;
+	}
+
+	rate = clk_get_rate(clk);
+
+	rstc = of_reset_control_get(np, NULL);
+	if (IS_ERR(rstc)) {
+		pr_err("%s: Failed to get reset\n", np->full_name);
+		return;
+	}
+
+	reset_control_assert(rstc);
+	reset_control_deassert(rstc);
+
+	data->base = of_iomap(np, 0);
+	if (!data->base) {
+		pr_err("failed to map registers for clockevent\n");
+		goto err_iomap;
+	}
+
+	irq = irq_of_parse_and_map(np, 0);
+	if (!irq) {
+		pr_err("%s: failed to get irq.\n", np->full_name);
+		goto err_get_irq;
+	}
+
+	/* Detect whether the timer is 16 or 32 bits */
+	writel_relaxed(~0UL, data->base + TIM_ARR);
+	max_delta = readl_relaxed(data->base + TIM_ARR);
+	if (max_delta == ~0UL) {
+		prescaler = 1;
+		bits = 32;
+	} else {
+		prescaler = 1024;
+		bits = 16;
+	}
+	writel_relaxed(0, data->base + TIM_ARR);
+
+	writel_relaxed(prescaler - 1, data->base + TIM_PSC);
+	writel_relaxed(TIM_EGR_UG, data->base + TIM_EGR);
+	writel_relaxed(TIM_DIER_UIE, data->base + TIM_DIER);
+	writel_relaxed(0, data->base + TIM_SR);
+
+	data->periodic_top = DIV_ROUND_CLOSEST(rate, prescaler * HZ);
+
+	clockevents_config_and_register(&data->evtdev,
+					DIV_ROUND_CLOSEST(rate, prescaler),
+					0x1, max_delta);
+
+	ret = request_irq(irq, stm32_clock_event_handler, IRQF_TIMER,
+			"stm32 clockevent", data);
+	if (ret) {
+		pr_err("%s: failed to request irq.\n", np->full_name);
+		goto err_get_irq;
+	}
+
+	pr_info("%s: STM32 clockevent driver initialized (%d bits)\n",
+			np->full_name, bits);
+
+	return;
+
+err_get_irq:
+	iounmap(data->base);
+err_iomap:
+	clk_disable_unprepare(clk);
+err_clk_enable:
+	clk_put(clk);
+err_clk_get:
+	return;
+}
+
+CLOCKSOURCE_OF_DECLARE(stm32, "st,stm32-timer", stm32_clockevent_init);
-- 
1.9.1
