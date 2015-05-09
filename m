From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: [PATCH v8 07/16] drivers: reset: Add STM32 reset driver
Date: Sat,  9 May 2015 09:53:49 +0200
Message-ID: <1431158038-3813-8-git-send-email-mcoquelin.stm32@gmail.com>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-gpio-owner@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, afaerber@suse.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, stefan@agner.ch, pmeerw@pmeerw.net, pebolle@tiscali.nl, peter@hurleysoftware.com, andy.shevchenko@gmail.com, cw00.choi@samsung.com, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, joe@perches.com, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, lee.jones@linaro.org, Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>, Michal Marek <mmarek@suse.cz>, linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-gpio@vger.kernel.org, linux-serial@vger.kernel.org, linux-arch@vger.kerne
List-Id: linux-api@vger.kernel.org

The STM32 MCUs family IPs can be reset by accessing some registers
from the RCC block.

The list of available reset lines is documented in the DT bindings.

Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
---
 drivers/reset/Makefile      |   1 +
 drivers/reset/reset-stm32.c | 124 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 125 insertions(+)
 create mode 100644 drivers/reset/reset-stm32.c

diff --git a/drivers/reset/Makefile b/drivers/reset/Makefile
index 157d421..aed12d1 100644
--- a/drivers/reset/Makefile
+++ b/drivers/reset/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_RESET_CONTROLLER) += core.o
 obj-$(CONFIG_ARCH_SOCFPGA) += reset-socfpga.o
 obj-$(CONFIG_ARCH_BERLIN) += reset-berlin.o
+obj-$(CONFIG_ARCH_STM32) += reset-stm32.o
 obj-$(CONFIG_ARCH_SUNXI) += reset-sunxi.o
 obj-$(CONFIG_ARCH_STI) += sti/
diff --git a/drivers/reset/reset-stm32.c b/drivers/reset/reset-stm32.c
new file mode 100644
index 0000000..2c41858
--- /dev/null
+++ b/drivers/reset/reset-stm32.c
@@ -0,0 +1,124 @@
+/*
+ * Copyright (C) Maxime Coquelin 2015
+ * Author:  Maxime Coquelin <mcoquelin.stm32@gmail.com>
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Heavily based on sunxi driver from Maxime Ripard.
+ */
+
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/reset-controller.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+struct stm32_reset_data {
+	spinlock_t			lock;
+	void __iomem			*membase;
+	struct reset_controller_dev	rcdev;
+};
+
+static int stm32_reset_assert(struct reset_controller_dev *rcdev,
+			      unsigned long id)
+{
+	struct stm32_reset_data *data = container_of(rcdev,
+						     struct stm32_reset_data,
+						     rcdev);
+	int bank = id / BITS_PER_LONG;
+	int offset = id % BITS_PER_LONG;
+	unsigned long flags;
+	u32 reg;
+
+	spin_lock_irqsave(&data->lock, flags);
+
+	reg = readl_relaxed(data->membase + (bank * 4));
+	writel_relaxed(reg | BIT(offset), data->membase + (bank * 4));
+
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	return 0;
+}
+
+static int stm32_reset_deassert(struct reset_controller_dev *rcdev,
+				unsigned long id)
+{
+	struct stm32_reset_data *data = container_of(rcdev,
+						     struct stm32_reset_data,
+						     rcdev);
+	int bank = id / BITS_PER_LONG;
+	int offset = id % BITS_PER_LONG;
+	unsigned long flags;
+	u32 reg;
+
+	spin_lock_irqsave(&data->lock, flags);
+
+	reg = readl_relaxed(data->membase + (bank * 4));
+	writel_relaxed(reg & ~BIT(offset), data->membase + (bank * 4));
+
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	return 0;
+}
+
+static struct reset_control_ops stm32_reset_ops = {
+	.assert		= stm32_reset_assert,
+	.deassert	= stm32_reset_deassert,
+};
+
+static const struct of_device_id stm32_reset_dt_ids[] = {
+	 { .compatible = "st,stm32-rcc", },
+	 { /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, sstm32_reset_dt_ids);
+
+static int stm32_reset_probe(struct platform_device *pdev)
+{
+	struct stm32_reset_data *data;
+	struct resource *res;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	data->membase = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(data->membase))
+		return PTR_ERR(data->membase);
+
+	spin_lock_init(&data->lock);
+
+	data->rcdev.owner = THIS_MODULE;
+	data->rcdev.nr_resets = resource_size(res) * 8;
+	data->rcdev.ops = &stm32_reset_ops;
+	data->rcdev.of_node = pdev->dev.of_node;
+
+	return reset_controller_register(&data->rcdev);
+}
+
+static int stm32_reset_remove(struct platform_device *pdev)
+{
+	struct stm32_reset_data *data = platform_get_drvdata(pdev);
+
+	reset_controller_unregister(&data->rcdev);
+
+	return 0;
+}
+
+static struct platform_driver stm32_reset_driver = {
+	.probe	= stm32_reset_probe,
+	.remove	= stm32_reset_remove,
+	.driver = {
+		.name		= "stm32-rcc-reset",
+		.of_match_table	= stm32_reset_dt_ids,
+	},
+};
+module_platform_driver(stm32_reset_driver);
+
+MODULE_AUTHOR("Maxime Coquelin <maxime.coquelin@gmail.com>");
+MODULE_DESCRIPTION("STM32 MCUs Reset Controller Driver");
+MODULE_LICENSE("GPL");
-- 
1.9.1

