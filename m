From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 07/18] drivers: reset: Add STM32 reset driver
Date: Fri, 20 Feb 2015 19:01:06 +0100
Message-ID: <1424455277-29983-8-git-send-email-mcoquelin.stm32__16522.4763718017$1424455618$gmane$org@gmail.com>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424455277-29983-1-git-send-email-mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, afaerber-l3A5Bk7waGM@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will
List-Id: linux-api@vger.kernel.org

The STM32 MCUs family IP can be reset by accessing some shared registers.

The specificity is that some reset lines are used by the timers.
At timer initialization time, the timer has to be reset, that's why
we cannot use a regular driver.

Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/reset/Makefile                   |   1 +
 drivers/reset/reset-stm32.c              | 124 +++++++++++++++++++++++++++++++
 include/dt-bindings/reset/st,stm32f429.h |  85 +++++++++++++++++++++
 3 files changed, 210 insertions(+)
 create mode 100644 drivers/reset/reset-stm32.c
 create mode 100644 include/dt-bindings/reset/st,stm32f429.h

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
index 0000000..7a96677
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
+static void stm32_reset_init(struct device_node *np)
+{
+	struct stm32_reset_data *data;
+	struct resource res;
+	resource_size_t size;
+	int err;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return;
+
+	err = of_address_to_resource(np, 0, &res);
+	if (err)
+		goto err_alloc;
+
+	size = resource_size(&res);
+	if (!request_mem_region(res.start, size, np->name)) {
+		err = -EINVAL;
+		goto err_alloc;
+	}
+
+	data->membase = ioremap(res.start, size);
+	if (!data->membase) {
+		err = -ENOMEM;
+		goto err_alloc;
+	}
+
+	spin_lock_init(&data->lock);
+
+	data->rcdev.owner = THIS_MODULE;
+	data->rcdev.nr_resets = size * 8;
+	data->rcdev.ops = &stm32_reset_ops;
+	data->rcdev.of_node = np;
+
+	err = reset_controller_register(&data->rcdev);
+	if (err)
+		goto err_iomap;
+
+	pr_info("%s: %d reset lines registered\n", np->full_name,
+			data->rcdev.nr_resets);
+	return;
+
+err_iomap:
+	iounmap(data->membase);
+err_alloc:
+	kfree(data);
+	pr_err("%s: Reset ctrl registration failed (%d).\n",
+			np->full_name, err);
+}
+
+RESET_CONTROLLER_OF_DECLARE(stm32, "st,stm32-reset", stm32_reset_init);
+
diff --git a/include/dt-bindings/reset/st,stm32f429.h b/include/dt-bindings/reset/st,stm32f429.h
new file mode 100644
index 0000000..04f2ba8
--- /dev/null
+++ b/include/dt-bindings/reset/st,stm32f429.h
@@ -0,0 +1,85 @@
+/*
+ * Copyright (C) Maxime Coquelin 2015
+ * Author:  Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _DT_BINDINGS_RESET_STM32F429_H
+#define _DT_BINDINGS_RESET_STM32F429_H
+
+/* AHB1 */
+#define GPIOA_RESET	0
+#define GPIOB_RESET	1
+#define GPIOC_RESET	2
+#define GPIOD_RESET	3
+#define GPIOE_RESET	4
+#define GPIOF_RESET	5
+#define GPIOG_RESET	6
+#define GPIOH_RESET	7
+#define GPIOI_RESET	8
+#define GPIOJ_RESET	9
+#define GPIOK_RESET	10
+#define CRC_RESET	12
+#define DMA1_RESET	21
+#define DMA2_RESET	22
+#define DMA2D_RESET	23
+#define ETHMAC_RESET	25
+#define OTGHS_RESET	29
+
+/* AHB2 */
+#define DCMI_RESET	32
+#define CRYP_RESET	36
+#define HASH_RESET	37
+#define RNG_RESET	38
+#define OTGFS_RESET	39
+
+/* AHB3 */
+#define FMC_RESET	64
+
+/* APB1 */
+#define TIM2_RESET	128
+#define TIM3_RESET	129
+#define TIM4_RESET	130
+#define TIM5_RESET	131
+#define TIM6_RESET	132
+#define TIM7_RESET	133
+#define TIM12_RESET	134
+#define TIM13_RESET	135
+#define TIM14_RESET	136
+#define WWDG_RESET	139
+#define SPI2_RESET	142
+#define SPI3_RESET	143
+#define UART2_RESET	145
+#define UART3_RESET	146
+#define UART4_RESET	147
+#define UART5_RESET	148
+#define I2C1_RESET	149
+#define I2C2_RESET	150
+#define I2C3_RESET	151
+#define CAN1_RESET	153
+#define CAN2_RESET	154
+#define PWR_RESET	156
+#define DAC_RESET	157
+#define UART7_RESET	158
+#define UART8_RESET	159
+
+/* APB2 */
+#define TIM1_RESET	160
+#define TIM8_RESET	161
+#define USART1_RESET	164
+#define USART6_RESET	165
+#define ADC_RESET	168
+#define SDIO_RESET	171
+#define SPI1_RESET	172
+#define SPI4_RESET	173
+#define SYSCFG_RESET	174
+#define TIM9_RESET	176
+#define TIM10_RESET	177
+#define TIM11_RESET	178
+#define SPI5_RESET	180
+#define SPI6_RESET	181
+#define SAI1_RESET	182
+#define LTDC_RESET	186
+
+#endif /* _DT_BINDINGS_RESET_STM32F429_H */
+
-- 
1.9.1
