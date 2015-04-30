From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v7 06/15] drivers: reset: Add STM32 reset driver
Date: Thu, 30 Apr 2015 18:20:35 +0200
Message-ID: <1430410844-16062-7-git-send-email-mcoquelin.stm32@gmail.com>
References: <1430410844-16062-1-git-send-email-mcoquelin.stm32@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430410844-16062-1-git-send-email-mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, afaerber-l3A5Bk7waGM@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, stefan-XLVq0VzYD2Y@public.gmane.org, pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org, pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org, peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, Vladimir Zapolskiy <vladimir_zapolskiy-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Nikolay Borisov <Nikolay.Borisov-5wv7dgnIgG8@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TZNg+MwTxZMZA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The STM32 MCUs family IPs can be reset by accessing some registers
from the RCC block.

The list of available reset lines is documented in the DT bindings.

Tested-by: Chanwoo Choi <cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Acked-by: Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
+ * Author:  Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
+MODULE_AUTHOR("Maxime Coquelin <maxime.coquelin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>");
+MODULE_DESCRIPTION("STM32 MCUs Reset Controller Driver");
+MODULE_LICENSE("GPL");
-- 
1.9.1
