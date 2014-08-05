From: Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 2/3] tty: serial: 8250: Add Mediatek UART driver
Date: Tue,  5 Aug 2014 12:54:12 +0200
Message-ID: <1407236054-30994-3-git-send-email-matthias.bgg@gmail.com>
References: <1407236054-30994-1-git-send-email-matthias.bgg@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1407236054-30994-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rdunlap@infradead.org, gregkh@linuxfoundation.org, jslaby@suse.cz, grant.likely@linaro.org, matthias.bgg@gmail.com, heikki.krogerus@linux.intel.com, alan@linux.intel.com, paul.gortmaker@windriver.com, asierra@xes-inc.com, mwelling@ieee.org, dianders@chromium.org, m-karicheri2@ti.com, jschultz@xes-inc.com, mingo@elte.hu, balbi@ti.com, heiko@sntech.de, devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patch adds support for the UART block found on Mediatek SoCs.
The driver uses the highspeed capability of the 8250_core to set the
highspeed register and calculate the divisor for it.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 drivers/tty/serial/8250/8250_mtk.c |  211 ++++++++++++++++++++++++++++++++++++
 drivers/tty/serial/8250/Kconfig    |    7 ++
 drivers/tty/serial/8250/Makefile   |    1 +
 3 files changed, 219 insertions(+)
 create mode 100644 drivers/tty/serial/8250/8250_mtk.c

diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
new file mode 100644
index 0000000..96c72b4
--- /dev/null
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -0,0 +1,211 @@
+/*
+ * Mediatek 8250 driver.
+ *
+ * Copyright (c) 2014 MundoReader S.L.
+ * Author: Matthias Brugger <matthias.bgg@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/serial_8250.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/pm_runtime.h>
+#include "8250.h"
+
+#define MTK_UART_RATE_FIX 0x0D /* UART Rate Fix Register */
+
+struct mtk8250_data {
+	int			line;
+	struct clk		*clk;
+};
+
+static void
+mtk8250_do_pm(struct uart_port *port, unsigned int state, unsigned int old)
+{
+	if (!state)
+		pm_runtime_get_sync(port->dev);
+
+	serial8250_do_pm(port, state, old);
+
+	if (state)
+		pm_runtime_put_sync_suspend(port->dev);
+}
+
+static int mtk8250_probe_of(struct uart_port *p,
+			   struct mtk8250_data *data)
+{
+	int err;
+	struct device_node	*np = p->dev->of_node;
+
+	data->clk = of_clk_get(np, 0);
+	if (IS_ERR(data->clk)) {
+		pr_warn("Can't get timer clock");
+		return PTR_ERR(data->clk);
+	}
+
+	err = clk_prepare_enable(data->clk);
+	if (err) {
+		pr_warn("Can't prepare clock");
+		clk_put(data->clk);
+		return err;
+	}
+	p->uartclk = clk_get_rate(data->clk);
+
+	return 0;
+}
+
+static int mtk8250_probe(struct platform_device *pdev)
+{
+	struct uart_8250_port uart = {};
+	struct resource *regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	struct resource *irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	struct mtk8250_data *data;
+	int err;
+
+	if (!regs || !irq) {
+		dev_err(&pdev->dev, "no registers/irq defined\n");
+		return -EINVAL;
+	}
+
+	spin_lock_init(&uart.port.lock);
+	uart.port.mapbase = regs->start;
+	uart.port.irq = irq->start;
+	uart.port.pm = mtk8250_do_pm;
+	uart.port.type = PORT_16550;
+	uart.port.flags = UPF_BOOT_AUTOCONF | UPF_FIXED_PORT | UART_CAP_HIGHS;
+	uart.port.dev = &pdev->dev;
+
+	uart.port.membase = devm_ioremap(&pdev->dev, regs->start,
+					 resource_size(regs));
+	if (!uart.port.membase)
+		return -ENOMEM;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	uart.port.iotype = UPIO_MEM32;
+	uart.port.regshift = 2;
+	uart.port.private_data = data;
+
+	if (pdev->dev.of_node) {
+		err = mtk8250_probe_of(&uart.port, data);
+		if (err)
+			return err;
+	} else
+		return -ENODEV;
+
+	/* Disable Rate Fix function */
+	writel(0x0, uart.port.membase +
+			(MTK_UART_RATE_FIX << uart.port.regshift));
+
+	data->line = serial8250_register_8250_port(&uart);
+	if (data->line < 0)
+		return data->line;
+
+	platform_set_drvdata(pdev, data);
+
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
+	return 0;
+}
+
+static int mtk8250_remove(struct platform_device *pdev)
+{
+	struct mtk8250_data *data = platform_get_drvdata(pdev);
+
+	pm_runtime_get_sync(&pdev->dev);
+
+	serial8250_unregister_port(data->line);
+	if (!IS_ERR(data->clk)) {
+		clk_disable_unprepare(data->clk);
+		clk_put(data->clk);
+	}
+
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int mtk8250_suspend(struct device *dev)
+{
+	struct mtk8250_data *data = dev_get_drvdata(dev);
+
+	serial8250_suspend_port(data->line);
+
+	return 0;
+}
+
+static int mtk8250_resume(struct device *dev)
+{
+	struct mtk8250_data *data = dev_get_drvdata(dev);
+
+	serial8250_resume_port(data->line);
+
+	return 0;
+}
+#endif /* CONFIG_PM_SLEEP */
+
+#ifdef CONFIG_PM_RUNTIME
+static int mtk8250_runtime_suspend(struct device *dev)
+{
+	struct mtk8250_data *data = dev_get_drvdata(dev);
+
+	if (!IS_ERR(data->clk))
+		clk_disable_unprepare(data->clk);
+
+	return 0;
+}
+
+static int mtk8250_runtime_resume(struct device *dev)
+{
+	struct mtk8250_data *data = dev_get_drvdata(dev);
+
+	if (!IS_ERR(data->clk))
+		clk_prepare_enable(data->clk);
+
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops mtk8250_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(mtk8250_suspend, mtk8250_resume)
+	SET_RUNTIME_PM_OPS(mtk8250_runtime_suspend, mtk8250_runtime_resume,
+				NULL)
+};
+
+static const struct of_device_id mtk8250_of_match[] = {
+	{ .compatible = "mediatek,mt6577-uart" },
+	{ /* Sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, mtk8250_of_match);
+
+static struct platform_driver mtk8250_platform_driver = {
+	.driver = {
+		.name		= "mt6577-uart",
+		.owner		= THIS_MODULE,
+		.pm		= &mtk8250_pm_ops,
+		.of_match_table	= mtk8250_of_match,
+	},
+	.probe			= mtk8250_probe,
+	.remove			= mtk8250_remove,
+};
+module_platform_driver(mtk8250_platform_driver);
+
+MODULE_AUTHOR("Matthias Brugger");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Mediatek 8250 serial port driver");
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index 349ee59..fac34aa 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -298,3 +298,10 @@ config SERIAL_8250_RT288X
 	  If you have a Ralink RT288x/RT305x SoC based board and want to use the
 	  serial port, say Y to this option. The driver can handle up to 2 serial
 	  ports. If unsure, say N.
+
+config SERIAL_8250_MT6577
+	bool "Mediatek serial port support"
+	depends on SERIAL_8250 && ARCH_MEDIATEK
+	help
+	  If you have a Mediatek based board and want to use the
+	  serial port, say Y to this option. If unsure, say N.
diff --git a/drivers/tty/serial/8250/Makefile b/drivers/tty/serial/8250/Makefile
index 36d68d0..6dcb46b 100644
--- a/drivers/tty/serial/8250/Makefile
+++ b/drivers/tty/serial/8250/Makefile
@@ -20,3 +20,4 @@ obj-$(CONFIG_SERIAL_8250_HUB6)		+= 8250_hub6.o
 obj-$(CONFIG_SERIAL_8250_FSL)		+= 8250_fsl.o
 obj-$(CONFIG_SERIAL_8250_DW)		+= 8250_dw.o
 obj-$(CONFIG_SERIAL_8250_EM)		+= 8250_em.o
+obj-$(CONFIG_SERIAL_8250_MT6577)	+= 8250_mtk.o
-- 
1.7.9.5
