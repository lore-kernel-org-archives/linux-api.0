From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [RFC PATCH 02/10] clockevents/drivers: add MPS2 Timer driver
Date: Wed, 25 Nov 2015 10:33:33 +0000
Message-ID: <1448447621-17900-3-git-send-email-vladimir.murzin@arm.com>
References: <1448447621-17900-1-git-send-email-vladimir.murzin@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448447621-17900-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de, afaerber@suse.de, mcoquelin.stm32@gmail.com
Cc: Mark.Rutland@arm.com, Pawel.Moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

MPS2 platform has simple 32 bits general purpose countdown timers.

The driver uses the first detected timer as a clocksource and the rest
of the timers as a clockevent

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 drivers/clocksource/Kconfig      |    5 +
 drivers/clocksource/Makefile     |    1 +
 drivers/clocksource/mps2-timer.c |  280 ++++++++++++++++++++++++++++++++++=
++++
 3 files changed, 286 insertions(+)
 create mode 100644 drivers/clocksource/mps2-timer.c

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 71cfdf7..552ab54 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -136,6 +136,11 @@ config CLKSRC_STM32
 =09depends on OF && ARM && (ARCH_STM32 || COMPILE_TEST)
 =09select CLKSRC_MMIO
=20
+config CLKSRC_MPS2
+=09bool "Clocksource for MPS2 SoCs"
+=09depends on OF && (ARM || COMPILE_TEST)
+=09select CLKSRC_MMIO
+
 config ARM_ARCH_TIMER
 =09bool
 =09select CLKSRC_OF if OF
diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index 56bd16e..7033b9c 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_CLKSRC_EFM32)=09+=3D time-efm32.o
 obj-$(CONFIG_CLKSRC_STM32)=09+=3D timer-stm32.o
 obj-$(CONFIG_CLKSRC_EXYNOS_MCT)=09+=3D exynos_mct.o
 obj-$(CONFIG_CLKSRC_LPC32XX)=09+=3D time-lpc32xx.o
+obj-$(CONFIG_CLKSRC_MPS2)=09+=3D mps2-timer.o
 obj-$(CONFIG_CLKSRC_SAMSUNG_PWM)=09+=3D samsung_pwm_timer.o
 obj-$(CONFIG_FSL_FTM_TIMER)=09+=3D fsl_ftm_timer.o
 obj-$(CONFIG_VF_PIT_TIMER)=09+=3D vf_pit_timer.o
diff --git a/drivers/clocksource/mps2-timer.c b/drivers/clocksource/mps2-ti=
mer.c
new file mode 100644
index 0000000..77befe2
--- /dev/null
+++ b/drivers/clocksource/mps2-timer.c
@@ -0,0 +1,280 @@
+/*
+ * Copyright (C) 2015 ARM Limited
+ *
+ * Author: Vladimir Murzin <vladimir.murzin@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#define pr_fmt(fmt)=09KBUILD_MODNAME ": " fmt
+
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/clocksource.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/of_address.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/sched_clock.h>
+#include <linux/slab.h>
+
+#define TIMER_CTRL=09=090x0
+#define TIMER_CTRL_ENABLE=09BIT(0)
+#define TIMER_CTRL_IE=09=09BIT(3)
+
+#define TIMER_VALUE=09=090x4
+#define TIMER_RELOAD=09=090x8
+#define TIMER_INT=09=090xc
+
+struct clockevent_mps2 {
+=09void __iomem *reg;
+=09u32 clock_count_per_tick;
+=09struct clock_event_device clkevt;
+};
+
+static void __iomem *sched_clock_base;
+
+static u64 notrace mps2_sched_read(void)
+{
+        return ~readl_relaxed(sched_clock_base + TIMER_VALUE);
+}
+
+
+static inline struct clockevent_mps2 *to_mps2_clkevt(struct clock_event_de=
vice *c)
+{
+=09return container_of(c, struct clockevent_mps2, clkevt);
+}
+
+static void clockevent_mps2_writel(u32 val, struct clock_event_device *c, =
u32 offset)
+{
+=09writel(val, to_mps2_clkevt(c)->reg + offset);
+}
+
+static int mps2_timer_shutdown(struct clock_event_device *ce)
+{
+=09clockevent_mps2_writel(0, ce, TIMER_RELOAD);
+=09clockevent_mps2_writel(0, ce, TIMER_CTRL);
+
+=09return 0;
+}
+
+static int mps2_timer_set_next_event(unsigned long next, struct clock_even=
t_device *ce)
+{
+=09clockevent_mps2_writel(next, ce, TIMER_VALUE);
+=09clockevent_mps2_writel(TIMER_CTRL_IE | TIMER_CTRL_ENABLE, ce, TIMER_CTR=
L);
+
+=09return 0;
+}
+
+static int mps2_timer_set_periodic(struct clock_event_device *ce)
+{
+=09u32 clock_count_per_tick =3D to_mps2_clkevt(ce)->clock_count_per_tick;
+
+=09clockevent_mps2_writel(clock_count_per_tick, ce, TIMER_RELOAD);
+=09clockevent_mps2_writel(clock_count_per_tick, ce, TIMER_VALUE);
+=09clockevent_mps2_writel(TIMER_CTRL_IE | TIMER_CTRL_ENABLE, ce, TIMER_CTR=
L);
+
+=09return 0;
+}
+
+static irqreturn_t mps2_timer_interrupt(int irq, void *dev_id)
+{
+=09struct clockevent_mps2 *ce =3D dev_id;
+=09u32 status =3D readl(ce->reg + TIMER_INT);
+
+=09if (!status)
+=09=09return IRQ_NONE;
+
+=09writel(1, ce->reg + TIMER_INT);
+
+=09ce->clkevt.event_handler(&ce->clkevt);
+
+=09return IRQ_HANDLED;
+}
+
+static int __init mps2_clockevents_init(struct device_node *np)
+{
+=09void __iomem *base;
+=09struct clk *clk;
+=09struct irqaction *ia;
+=09struct clockevent_mps2 *ce;
+=09u32 rate;
+=09int irq, ret;
+=09const char *name =3D "mps2-clkevt";
+
+=09ret =3D of_property_read_u32(np, "clock-frequency", &rate);
+
+=09if (ret) {
+=09=09clk =3D of_clk_get(np, 0);
+=09=09if (IS_ERR(clk)) {
+=09=09=09ret =3D PTR_ERR(clk);
+=09=09=09pr_err("failed to get clock for clockevent: %d\n", ret);
+=09=09=09goto err_clk_get;
+=09=09}
+
+=09=09ret =3D clk_prepare_enable(clk);
+=09=09if (ret) {
+=09=09=09pr_err("failed to enable clock for clockevent: %d\n", ret);
+=09=09=09clk_put(clk);
+=09=09=09goto err_clk_enable;
+=09=09}
+
+=09=09rate =3D clk_get_rate(clk);
+=09}
+
+=09base =3D of_iomap(np, 0);
+=09if (!base) {
+=09=09ret =3D -EADDRNOTAVAIL;
+=09=09pr_err("failed to map register for clockevent: %d\n", ret);
+=09=09goto err_iomap;
+=09}
+
+=09irq =3D irq_of_parse_and_map(np, 0);
+=09if (!irq) {
+=09=09ret =3D -ENOENT;
+=09=09pr_err("failed to get irq for clockevent: %d\n", ret);
+=09=09goto err_get_irq;
+=09}
+
+=09ce =3D kzalloc(sizeof(struct clockevent_mps2), GFP_KERNEL);
+=09if (!ce) {
+=09=09ret =3D -ENOMEM;
+=09=09pr_err("failed to allocate clockevent: %d\n", ret);
+=09=09goto err_ce_alloc;
+=09}
+
+=09ce->reg =3D base;
+=09ce->clock_count_per_tick =3D DIV_ROUND_CLOSEST(rate, HZ);
+=09ce->clkevt.irq =3D irq;
+=09ce->clkevt.name =3D name;
+=09ce->clkevt.rating =3D 200;
+=09ce->clkevt.features =3D CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHO=
T;
+=09ce->clkevt.cpumask =3D cpu_possible_mask;
+=09ce->clkevt.set_state_shutdown=09=3D mps2_timer_shutdown,
+=09ce->clkevt.set_state_periodic=09=3D mps2_timer_set_periodic,
+=09ce->clkevt.set_state_oneshot=09=3D mps2_timer_shutdown,
+=09ce->clkevt.set_next_event=09=3D mps2_timer_set_next_event;
+
+=09ia =3D kzalloc(sizeof(struct irqaction), GFP_KERNEL);
+=09if (!ia) {
+=09=09ret =3D -ENOMEM;
+=09=09pr_err("failed to allocate irqaction: %d\n", ret);
+=09=09goto err_ia_alloc;
+=09}
+
+=09ia->name =3D name;
+=09ia->flags =3D IRQF_TIMER;
+=09ia->handler =3D mps2_timer_interrupt;
+=09ia->dev_id =3D ce;
+
+=09writel(0, base + TIMER_CTRL);
+
+=09ret =3D setup_irq(irq, ia);
+
+=09if (ret) {
+=09=09pr_err("failed to setup irq: %d\n", ret);
+=09=09goto err_setup_irq;
+=09}
+
+=09clockevents_config_and_register(&ce->clkevt, rate, 0xf, 0xffffffff);
+
+=09return 0;
+
+err_setup_irq:
+=09kfree(ia);
+err_ia_alloc:
+=09kfree(ce);
+err_ce_alloc:
+err_get_irq:
+=09iounmap(base);
+err_iomap:
+=09clk_disable_unprepare(clk);
+err_clk_enable:
+=09clk_put(clk);
+err_clk_get:
+=09return ret;
+}
+
+static int mps2_clocksource_init(struct device_node *np)
+{
+=09void __iomem *base;
+=09struct clk *clk;
+=09u32 rate;
+=09int ret;
+=09const char *name =3D "mps2-clksrc";
+
+=09ret =3D of_property_read_u32(np, "clock-frequency", &rate);
+
+=09if (ret) {
+=09=09clk =3D of_clk_get(np, 0);
+=09=09if (IS_ERR(clk)) {
+=09=09=09ret =3D PTR_ERR(clk);
+=09=09=09pr_err("failed to get clock for clocksource: %d\n", ret);
+=09=09=09goto err_clk_get;
+=09=09}
+
+=09=09ret =3D clk_prepare_enable(clk);
+=09=09if (ret) {
+=09=09=09pr_err("failed to enable clock for clocksource: %d\n", ret);
+=09=09=09clk_put(clk);
+=09=09=09goto err_clk_enable;
+=09=09}
+
+=09=09rate =3D clk_get_rate(clk);
+=09}
+
+=09base =3D of_iomap(np, 0);
+=09if (!base) {
+=09=09ret =3D -EADDRNOTAVAIL;
+=09=09pr_err("failed to map register for clocksource: %d\n", ret);
+=09=09goto err_iomap;
+=09}
+
+=09writel(0, base + TIMER_CTRL);
+
+=09writel(0xffffffff, base + TIMER_VALUE);
+=09writel(0xffffffff, base + TIMER_RELOAD);
+
+=09writel(TIMER_CTRL_ENABLE, base + TIMER_CTRL);
+
+=09ret =3D clocksource_mmio_init(base + TIMER_VALUE, name,
+=09=09=09=09    rate, 200, 32,
+=09=09=09=09    clocksource_mmio_readl_down);
+=09if (ret) {
+=09=09pr_err("failed to init clocksource: %d\n", ret);
+=09=09goto err_clocksource_init;
+=09}
+
+=09sched_clock_base =3D base;
+=09sched_clock_register(mps2_sched_read, 32, rate);
+
+=09return 0;
+
+err_clocksource_init:
+=09iounmap(base);
+err_iomap:
+=09clk_disable_unprepare(clk);
+err_clk_enable:
+=09clk_put(clk);
+err_clk_get:
+=09return ret;
+
+}
+
+static void __init mps2_timer_init(struct device_node *np)
+{
+=09static int clksrc;
+
+=09if (!clksrc && !mps2_clocksource_init(np))
+=09=09clksrc =3D 1;
+=09else
+=09=09mps2_clockevents_init(np);
+}
+
+CLOCKSOURCE_OF_DECLARE(mps2_timer, "arm,mps2-timer", mps2_timer_init);
--=20
1.7.9.5
