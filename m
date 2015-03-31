From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: [PATCH v4 04/15] clocksource/drivers: Add ARM System timer driver
Date: Tue, 31 Mar 2015 18:24:45 +0200
Message-ID: <1427819096-31109-5-git-send-email-mcoquelin.stm32@gmail.com>
References: <1427819096-31109-1-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1427819096-31109-1-git-send-email-mcoquelin.stm32@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: u.kleine-koenig@pengutronix.de, afaerber@suse.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, stefan@agner.ch, pmeerw@pmeerw.net, pebolle@tiscali.nl, peter@hurleysoftware.com, andy.shevchenko@gmail.com, cw00.choi@samsung.com, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-doc@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, linux-api@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>, linux-arch@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Antti Palosaari <crope@iki.fi>, linux-serial@vger.kernel.org, devicetree@vger.kernel.org, Kees Cook <keescook@chromium.org>, Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Rusty Russell <rusty@rustcorp.com.au>, Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, Michal Marek <mmarek@suse.cz>, linux-gpio@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, mcoquelin.stm32@gmail.com, Kumar Gala <galak@codeaurora.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

This patch adds clocksource support for ARMv7-M's System timer,
also known as SysTick.

Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
---
 drivers/clocksource/Kconfig          |  7 ++++
 drivers/clocksource/Makefile         |  1 +
 drivers/clocksource/armv7m_systick.c | 79 ++++++++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+)
 create mode 100644 drivers/clocksource/armv7m_systick.c

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 1c2506f..b82e58b 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -134,6 +134,13 @@ config CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
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
index 752d5c7..1c9a643 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_MTK_TIMER)		+= mtk_timer.o
 
 obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
 obj-$(CONFIG_ARM_GLOBAL_TIMER)		+= arm_global_timer.o
+obj-$(CONFIG_ARMV7M_SYSTICK)		+= armv7m_systick.o
 obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
 obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)	+= dummy_timer.o
 obj-$(CONFIG_ARCH_KEYSTONE)		+= timer-keystone.o
diff --git a/drivers/clocksource/armv7m_systick.c b/drivers/clocksource/armv7m_systick.c
new file mode 100644
index 0000000..addfd2c
--- /dev/null
+++ b/drivers/clocksource/armv7m_systick.c
@@ -0,0 +1,79 @@
+/*
+ * Copyright (C) Maxime Coquelin 2015
+ * Author:  Maxime Coquelin <mcoquelin.stm32@gmail.com>
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
+	struct clk *clk = NULL;
+	void __iomem *base;
+	u32 rate;
+	int ret;
+
+	base = of_iomap(np, 0);
+	if (!base) {
+		pr_warn("system-timer: invalid base address\n");
+		return;
+	}
+
+	ret = of_property_read_u32(np, "clock-frequency", &rate);
+	if (ret) {
+		clk = of_clk_get(np, 0);
+		if (IS_ERR(clk))
+			goto out_unmap;
+
+		ret = clk_prepare_enable(clk);
+		if (ret)
+			goto out_clk_put;
+
+		rate = clk_get_rate(clk);
+		if (!rate)
+			goto out_clk_disable;
+	}
+
+	writel_relaxed(SYSTICK_LOAD_RELOAD_MASK, base + SYST_RVR);
+	writel_relaxed(SYST_CSR_ENABLE, base + SYST_CSR);
+
+	ret = clocksource_mmio_init(base + SYST_CVR, "arm_system_timer", rate,
+			200, 24, clocksource_mmio_readl_down);
+	if (ret) {
+		pr_err("failed to init clocksource (%d)\n", ret);
+		if (clk)
+			goto out_clk_disable;
+		else
+			goto out_unmap;
+	}
+
+	pr_info("ARM System timer initialized as clocksource\n");
+
+	return;
+
+out_clk_disable:
+	clk_disable_unprepare(clk);
+out_clk_put:
+	clk_put(clk);
+out_unmap:
+	iounmap(base);
+	pr_warn("ARM System timer register failed (%d)\n", ret);
+}
+
+CLOCKSOURCE_OF_DECLARE(arm_systick, "arm,armv7m-systick",
+			system_timer_of_register);
-- 
1.9.1
