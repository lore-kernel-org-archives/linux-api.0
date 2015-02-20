From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 04/18] clocksource: Add ARM System timer driver
Date: Fri, 20 Feb 2015 19:01:03 +0100
Message-ID: <1424455277-29983-5-git-send-email-mcoquelin.stm32__27425.9400474422$1424455665$gmane$org@gmail.com>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424455277-29983-1-git-send-email-mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, afaerber-l3A5Bk7waGM@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will
List-Id: linux-api@vger.kernel.org

This patch adds clocksource support for ARMv7-M's System timer,
also known as SysTick.

Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/clocksource/Kconfig          |  7 ++++
 drivers/clocksource/Makefile         |  1 +
 drivers/clocksource/armv7m_systick.c | 78 ++++++++++++++++++++++++++++++++++++
 3 files changed, 86 insertions(+)
 create mode 100644 drivers/clocksource/armv7m_systick.c

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index fc01ec2..fb6011e 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -124,6 +124,13 @@ config CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
 	help
 	 Use ARM global timer clock source as sched_clock
 
+config ARMV7M_SYSTICK
+	bool
+	select CLKSRC_OF if OF
+	select CLKSRC_MMIO
+	help
+	  This options enables support for the ARMv7M system timer unit
+
 config ATMEL_PIT
 	select CLKSRC_OF if OF
 	def_bool SOC_AT91SAM9 || SOC_SAMA5
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 94d90b2..eeea736 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_MTK_TIMER)		+= mtk_timer.o
 
 obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
 obj-$(CONFIG_ARM_GLOBAL_TIMER)		+= arm_global_timer.o
+obj-$(CONFIG_ARMV7M_SYSTICK)		+= armv7m_systick.o
 obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
 obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)	+= dummy_timer.o
 obj-$(CONFIG_ARCH_KEYSTONE)		+= timer-keystone.o
diff --git a/drivers/clocksource/armv7m_systick.c b/drivers/clocksource/armv7m_systick.c
new file mode 100644
index 0000000..23d8249
--- /dev/null
+++ b/drivers/clocksource/armv7m_systick.c
@@ -0,0 +1,78 @@
+/*
+ * Copyright (C) Maxime Coquelin 2015
+ * Author:  Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/kernel.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/clk.h>
+#include <linux/bitops.h>
+
+#define SYST_CSR	0x00
+#define SYST_RVR	0x04
+#define SYST_CVR	0x08
+#define SYST_CALIB	0x0c
+
+#define SYST_CSR_ENABLE BIT(0)
+
+#define SYSTICK_LOAD_RELOAD_MASK 0x00FFFFFF
+
+static void __init system_timer_of_register(struct device_node *np)
+{
+	struct clk *clk;
+	void __iomem *base;
+	u32 rate = 0;
+	int ret;
+
+	base = of_iomap(np, 0);
+	if (!base) {
+		pr_warn("system-timer: invalid base address\n");
+		return;
+	}
+
+	clk = of_clk_get(np, 0);
+	if (!IS_ERR(clk)) {
+		ret = clk_prepare_enable(clk);
+		if (ret) {
+			clk_put(clk);
+			goto out_unmap;
+		}
+
+		rate = clk_get_rate(clk);
+	}
+
+	/* If no clock found, try to get clock-frequency property */
+	if (!rate) {
+		ret = of_property_read_u32(np, "clock-frequency", &rate);
+		if (ret)
+			goto out_unmap;
+	}
+
+	writel_relaxed(SYSTICK_LOAD_RELOAD_MASK, base + SYST_RVR);
+	writel_relaxed(SYST_CSR_ENABLE, base + SYST_CSR);
+
+	ret = clocksource_mmio_init(base + SYST_CVR, "arm_system_timer", rate,
+			200, 24, clocksource_mmio_readl_down);
+	if (ret) {
+		pr_err("failed to init clocksource (%d)\n", ret);
+		goto out_clk_disable;
+	}
+
+	pr_info("ARM System timer initialized as clocksource\n");
+
+	return;
+
+out_clk_disable:
+	if (!IS_ERR(clk))
+		clk_disable_unprepare(clk);
+out_unmap:
+	iounmap(base);
+	WARN(ret, "ARM System timer register failed (%d)\n", ret);
+}
+
+CLOCKSOURCE_OF_DECLARE(arm_systick, "arm,armv7m-systick",
+			system_timer_of_register);
-- 
1.9.1
