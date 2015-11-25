From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [RFC PATCH 04/10] serial: mps2-uart: add MPS2 UART driver
Date: Wed, 25 Nov 2015 10:33:35 +0000
Message-ID: <1448447621-17900-5-git-send-email-vladimir.murzin@arm.com>
References: <1448447621-17900-1-git-send-email-vladimir.murzin@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448447621-17900-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de, afaerber@suse.de, mcoquelin.stm32@gmail.com
Cc: Mark.Rutland@arm.com, Pawel.Moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This driver adds support to the UART controller found on ARM MPS2
platform.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 drivers/tty/serial/Kconfig       |   12 +
 drivers/tty/serial/Makefile      |    1 +
 drivers/tty/serial/mps2-uart.c   |  596 ++++++++++++++++++++++++++++++++++=
++++
 include/uapi/linux/serial_core.h |    3 +
 4 files changed, 612 insertions(+)
 create mode 100644 drivers/tty/serial/mps2-uart.c

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 1aec440..b47f8fc 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1473,6 +1473,18 @@ config SERIAL_EFM32_UART
 =09  This driver support the USART and UART ports on
 =09  Energy Micro's efm32 SoCs.
=20
+config SERIAL_MPS2_UART_CONSOLE
+=09bool "MPS2 UART console support"
+=09depends on SERIAL_MPS2_UART
+=09select SERIAL_CORE_CONSOLE
+
+config SERIAL_MPS2_UART
+=09tristate "MPS2 UART port"
+=09depends on ARM || COMPILE_TEST
+=09select SERIAL_CORE
+=09help
+=09  This driver support the UART ports on ARM MPS2.
+
 config SERIAL_EFM32_UART_CONSOLE
 =09bool "EFM32 UART/USART console support"
 =09depends on SERIAL_EFM32_UART=3Dy
diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
index 5ab4111..7f589f5 100644
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@ -93,6 +93,7 @@ obj-$(CONFIG_SERIAL_CONEXANT_DIGICOLOR)=09+=3D digicolor-=
usart.o
 obj-$(CONFIG_SERIAL_MEN_Z135)=09+=3D men_z135_uart.o
 obj-$(CONFIG_SERIAL_SPRD) +=3D sprd_serial.o
 obj-$(CONFIG_SERIAL_STM32)=09+=3D stm32-usart.o
+obj-$(CONFIG_SERIAL_MPS2_UART)=09+=3D mps2-uart.o
=20
 # GPIOLIB helpers for modem control lines
 obj-$(CONFIG_SERIAL_MCTRL_GPIO)=09+=3D serial_mctrl_gpio.o
diff --git a/drivers/tty/serial/mps2-uart.c b/drivers/tty/serial/mps2-uart.=
c
new file mode 100644
index 0000000..00e882e
--- /dev/null
+++ b/drivers/tty/serial/mps2-uart.c
@@ -0,0 +1,596 @@
+/*
+ * Copyright (C) 2015 ARM Limited
+ *
+ * Author: Vladimir Murzin <vladimir.murzin@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * TODO: support for SysRq
+ */
+
+#define pr_fmt(fmt)=09KBUILD_MODNAME ": " fmt
+
+#include <linux/bitops.h>
+#include <linux/clk.h>
+#include <linux/console.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/serial_core.h>
+#include <linux/tty_flip.h>
+#include <linux/types.h>
+
+#define SERIAL_NAME "ttyMPS"
+#define DRIVER_NAME "mps2-uart"
+#define MAKE_NAME(x) (DRIVER_NAME # x)
+
+#define UARTn_DATA=09=09=09=090x0
+
+#define UARTn_STATE=09=09=09=090x4
+#define UARTn_STATE_TX_FULL=09=09=09BIT(0)
+#define UARTn_STATE_RX_FULL=09=09=09BIT(1)
+#define UARTn_STATE_TX_OVERRUN=09=09=09BIT(2)
+#define UARTn_STATE_RX_OVERRUN=09=09=09BIT(3)
+
+#define UARTn_CTRL=09=09=09=090x8
+#define UARTn_CTRL_TX_ENABLE=09=09=09BIT(0)
+#define UARTn_CTRL_RX_ENABLE=09=09=09BIT(1)
+#define UARTn_CTRL_TX_INT_ENABLE=09=09BIT(2)
+#define UARTn_CTRL_RX_INT_ENABLE=09=09BIT(3)
+#define UARTn_CTRL_TX_OVERRUN_INT_ENABLE=09BIT(4)
+#define UARTn_CTRL_RX_OVERRUN_INT_ENABLE=09BIT(5)
+
+#define UARTn_INT=09=09=09=090xc
+#define UARTn_INT_TX=09=09=09=09BIT(0)
+#define UARTn_INT_RX=09=09=09=09BIT(1)
+#define UARTn_INT_TX_OVERRUN=09=09=09BIT(2)
+#define UARTn_INT_RX_OVERRUN=09=09=09BIT(3)
+
+#define UARTn_BAUDDIV=09=09=09=090x10
+#define UARTn_BAUDDIV_MASK=09=09=09GENMASK(20, 0)
+
+#define MPS2_MAX_PORTS=09=09=09=093
+
+struct mps2_uart_port {
+=09struct uart_port port;
+=09struct clk *clk;
+=09unsigned int tx_irq;
+=09unsigned int rx_irq;
+};
+
+static inline struct mps2_uart_port *to_mps2_port(struct uart_port *port)
+{
+=09return container_of(port, struct mps2_uart_port, port);
+}
+
+static void mps2_uart_write8(struct uart_port *port, u8 val, unsigned off)
+{
+=09struct mps2_uart_port *mps_port =3D to_mps2_port(port);
+
+=09writeb(val, mps_port->port.membase + off);
+}
+
+static u8 mps2_uart_read8(struct uart_port *port, unsigned off)
+{
+=09struct mps2_uart_port *mps_port =3D to_mps2_port(port);
+
+=09return readb(mps_port->port.membase + off);
+}
+
+static void mps2_uart_write32(struct uart_port *port, u32 val, unsigned of=
f)
+{
+=09struct mps2_uart_port *mps_port =3D to_mps2_port(port);
+
+=09writel_relaxed(val, mps_port->port.membase + off);
+}
+
+static unsigned int mps2_uart_tx_empty(struct uart_port *port)
+{
+=09u8 status =3D mps2_uart_read8(port, UARTn_STATE);
+
+=09return (status & UARTn_STATE_TX_FULL) ? 0 : TIOCSER_TEMT;
+}
+
+static void mps2_uart_set_mctrl(struct uart_port *port, unsigned int mctrl=
)
+{
+}
+
+static unsigned int mps2_uart_get_mctrl(struct uart_port *port)
+{
+=09return TIOCM_CAR | TIOCM_CTS | TIOCM_DSR;
+}
+
+static void mps2_uart_stop_tx(struct uart_port *port)
+{
+=09u8 control =3D mps2_uart_read8(port, UARTn_CTRL);
+
+=09control &=3D ~(UARTn_CTRL_TX_ENABLE=09=09|
+=09=09     UARTn_CTRL_TX_INT_ENABLE=09=09|
+=09=09     UARTn_CTRL_TX_OVERRUN_INT_ENABLE);
+
+=09mps2_uart_write8(port, control, UARTn_CTRL);
+}
+
+static void mps2_uart_tx_chars(struct uart_port *port)
+{
+=09struct circ_buf *xmit =3D &port->state->xmit;
+
+=09while (!(mps2_uart_read8(port, UARTn_STATE) & UARTn_STATE_TX_FULL)) {
+=09=09if (port->x_char) {
+=09=09=09mps2_uart_write8(port, port->x_char, UARTn_DATA);
+=09=09=09port->x_char =3D 0;
+=09=09=09port->icount.tx++;
+=09=09=09continue;
+=09=09}
+
+=09=09if (uart_circ_empty(xmit) || uart_tx_stopped(port))
+=09=09=09break;
+
+=09=09mps2_uart_write8(port, xmit->buf[xmit->tail], UARTn_DATA);
+=09=09xmit->tail =3D (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
+=09=09port->icount.tx++;
+=09}
+
+=09if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+=09=09uart_write_wakeup(port);
+
+=09if (uart_circ_empty(xmit))
+=09=09mps2_uart_stop_tx(port);
+}
+
+static void mps2_uart_start_tx(struct uart_port *port)
+{
+=09u8 control =3D mps2_uart_read8(port, UARTn_CTRL);
+
+=09control |=3D (UARTn_CTRL_TX_ENABLE=09=09|
+=09=09    UARTn_CTRL_TX_INT_ENABLE=09=09|
+=09=09    UARTn_CTRL_TX_OVERRUN_INT_ENABLE);
+
+=09mps2_uart_write8(port, control, UARTn_CTRL);
+=09mps2_uart_tx_chars(port);
+}
+
+static void mps2_uart_stop_rx(struct uart_port *port)
+{
+=09u8 control =3D mps2_uart_read8(port, UARTn_CTRL);
+
+=09control &=3D ~(UARTn_CTRL_RX_ENABLE=09=09|
+=09=09     UARTn_CTRL_RX_INT_ENABLE=09=09|
+=09=09     UARTn_CTRL_RX_OVERRUN_INT_ENABLE);
+
+=09mps2_uart_write8(port, control, UARTn_CTRL);
+}
+
+static void mps2_uart_enable_ms(struct uart_port *port)
+{
+}
+
+static void mps2_uart_break_ctl(struct uart_port *port, int ctl)
+{
+}
+
+static void mps2_uart_rx_chars(struct uart_port *port)
+{
+=09struct tty_port *tport =3D &port->state->port;
+
+=09while (mps2_uart_read8(port, UARTn_STATE) & UARTn_STATE_RX_FULL) {
+=09=09u8 rxdata =3D mps2_uart_read8(port, UARTn_DATA);
+
+=09=09port->icount.rx++;
+=09=09tty_insert_flip_char(&port->state->port, rxdata, TTY_NORMAL);
+=09};
+
+=09spin_unlock(&port->lock);
+=09tty_flip_buffer_push(tport);
+=09spin_lock(&port->lock);
+}
+
+static irqreturn_t mps2_uart_rxirq(int irq, void *data)
+{
+
+=09struct uart_port *port =3D data;
+=09u8 irqflag =3D mps2_uart_read8(port, UARTn_INT);
+
+=09if (unlikely(!(irqflag & UARTn_INT_RX)))
+=09=09return IRQ_NONE;
+
+=09spin_lock(&port->lock);
+
+=09mps2_uart_write8(port, UARTn_INT_RX, UARTn_INT);
+=09mps2_uart_rx_chars(port);
+
+=09spin_unlock(&port->lock);
+
+=09return IRQ_HANDLED;
+}
+
+static irqreturn_t mps2_uart_txirq(int irq, void *data)
+{
+=09struct uart_port *port =3D data;
+=09u8 irqflag =3D mps2_uart_read8(port, UARTn_INT);
+
+=09if (unlikely(!(irqflag & UARTn_INT_TX)))
+=09=09return IRQ_NONE;
+
+=09mps2_uart_write8(port, UARTn_INT_TX, UARTn_INT);
+=09mps2_uart_tx_chars(port);
+
+=09return IRQ_HANDLED;
+}
+
+static irqreturn_t mps2_uart_oerrirq(int irq, void *data)
+{
+=09irqreturn_t handled =3D IRQ_NONE;
+=09struct uart_port *port =3D data;
+=09u8 irqflag =3D mps2_uart_read8(port, UARTn_INT);
+
+=09spin_lock(&port->lock);
+
+=09if (irqflag & UARTn_INT_RX_OVERRUN) {
+=09=09struct tty_port *tport =3D &port->state->port;
+
+=09=09mps2_uart_write8(port, UARTn_INT_RX_OVERRUN, UARTn_INT);
+=09=09tty_insert_flip_char(tport, 0, TTY_OVERRUN);
+=09=09port->icount.overrun++;
+=09=09handled =3D IRQ_HANDLED;
+=09}
+
+=09/* XXX: this shouldn't happen? */
+=09if (irqflag & UARTn_INT_TX_OVERRUN) {
+=09=09mps2_uart_write8(port, UARTn_INT_TX_OVERRUN, UARTn_INT);
+=09=09handled =3D IRQ_HANDLED;
+=09}
+
+=09spin_unlock(&port->lock);
+
+=09return handled;
+}
+
+static int mps2_uart_startup(struct uart_port *port)
+{
+=09struct mps2_uart_port *mps_port =3D to_mps2_port(port);
+=09u8 control =3D mps2_uart_read8(port, UARTn_CTRL);
+=09int ret;
+
+=09control &=3D ~(UARTn_CTRL_RX_ENABLE=09=09|
+=09=09     UARTn_CTRL_TX_ENABLE=09=09|
+=09=09     UARTn_CTRL_RX_INT_ENABLE=09=09|
+=09=09     UARTn_CTRL_TX_INT_ENABLE=09=09|
+=09=09     UARTn_CTRL_RX_OVERRUN_INT_ENABLE=09|
+=09=09     UARTn_CTRL_TX_OVERRUN_INT_ENABLE);
+
+=09mps2_uart_write8(port, control, UARTn_CTRL);
+
+=09ret =3D request_irq(mps_port->rx_irq, mps2_uart_rxirq, 0,
+=09=09=09  MAKE_NAME(-rx), mps_port);
+=09if (ret) {
+=09=09pr_info("failed to register rxirq (%d)\n", ret);
+=09=09goto err_no_rxirq;
+=09}
+
+=09ret =3D request_irq(mps_port->tx_irq, mps2_uart_txirq, 0,
+=09=09=09  MAKE_NAME(-tx), mps_port);
+=09if (ret) {
+=09=09pr_info("failed to register txirq (%d)\n", ret);
+=09=09goto err_no_txirq;
+=09}
+
+=09ret =3D request_irq(port->irq, mps2_uart_oerrirq, IRQF_SHARED,
+=09=09=09  MAKE_NAME(-overrun), mps_port);
+
+=09if (ret)
+=09=09pr_info("failed to register oerrirq (%d)\n", ret);
+=09else {
+=09=09control |=3D UARTn_CTRL_RX_ENABLE=09=09=09|
+=09=09=09   UARTn_CTRL_TX_ENABLE=09=09=09|
+=09=09=09   UARTn_CTRL_RX_INT_ENABLE=09=09|
+=09=09=09   UARTn_CTRL_TX_INT_ENABLE=09=09|
+=09=09=09   UARTn_CTRL_RX_OVERRUN_INT_ENABLE=09|
+=09=09=09   UARTn_CTRL_TX_OVERRUN_INT_ENABLE;
+
+=09=09mps2_uart_write8(port, control, UARTn_CTRL);
+
+=09=09return 0;
+=09}
+
+=09free_irq(mps_port->tx_irq, mps_port);
+err_no_txirq:
+=09free_irq(mps_port->rx_irq, mps_port);
+err_no_rxirq:
+=09return ret;
+}
+
+static void mps2_uart_shutdown(struct uart_port *port)
+{
+=09struct mps2_uart_port *mps_port =3D to_mps2_port(port);
+=09u8 control =3D mps2_uart_read8(port, UARTn_CTRL);
+
+=09control &=3D ~(UARTn_CTRL_RX_ENABLE=09=09|
+=09=09     UARTn_CTRL_TX_ENABLE=09=09|
+=09=09     UARTn_CTRL_RX_INT_ENABLE=09=09|
+=09=09     UARTn_CTRL_TX_INT_ENABLE=09=09|
+=09=09     UARTn_CTRL_RX_OVERRUN_INT_ENABLE=09|
+=09=09     UARTn_CTRL_TX_OVERRUN_INT_ENABLE);
+
+=09mps2_uart_write8(port, control, UARTn_CTRL);
+
+=09free_irq(mps_port->rx_irq, mps_port);
+=09free_irq(mps_port->tx_irq, mps_port);
+=09free_irq(port->irq, mps_port);
+}
+
+static void mps2_uart_set_termios(struct uart_port *port,
+=09struct ktermios *new, struct ktermios *old)
+{
+=09unsigned long flags;
+=09unsigned int baud, bauddiv;
+
+=09new->c_cflag &=3D ~(CRTSCTS | CMSPAR);
+=09new->c_cflag &=3D ~CSIZE;
+=09new->c_cflag |=3D CS8;
+=09new->c_cflag &=3D ~PARENB;
+=09new->c_cflag &=3D ~CSTOPB;
+
+=09baud =3D uart_get_baud_rate(port, new, old,
+=09=09=09DIV_ROUND_CLOSEST(port->uartclk, UARTn_BAUDDIV_MASK),
+=09=09=09DIV_ROUND_CLOSEST(port->uartclk, 16));
+
+=09bauddiv =3D DIV_ROUND_CLOSEST(port->uartclk, baud);
+
+=09spin_lock_irqsave(&port->lock, flags);
+
+=09uart_update_timeout(port, new->c_cflag, baud);
+=09mps2_uart_write32(port, bauddiv, UARTn_BAUDDIV);
+
+=09spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static const char *mps2_uart_type(struct uart_port *port)
+{
+=09return (port->type =3D=3D PORT_MPS2UART) ? DRIVER_NAME : NULL;
+}
+
+static void mps2_uart_release_port(struct uart_port *port)
+{
+}
+
+static int mps2_uart_request_port(struct uart_port *port)
+{
+=09return 0;
+}
+
+static void mps2_uart_config_port(struct uart_port *port, int type)
+{
+=09if (type & UART_CONFIG_TYPE && !mps2_uart_request_port(port))
+=09=09port->type =3D PORT_MPS2UART;
+}
+
+static int mps2_uart_verify_port(struct uart_port *port, struct serial_str=
uct *serinfo)
+{
+=09return -EINVAL;
+}
+
+static const struct uart_ops mps2_uart_pops =3D {
+=09.tx_empty =3D mps2_uart_tx_empty,
+=09.set_mctrl =3D mps2_uart_set_mctrl,
+=09.get_mctrl =3D mps2_uart_get_mctrl,
+=09.stop_tx =3D mps2_uart_stop_tx,
+=09.start_tx =3D mps2_uart_start_tx,
+=09.stop_rx =3D mps2_uart_stop_rx,
+=09.enable_ms =3D mps2_uart_enable_ms,
+=09.break_ctl =3D mps2_uart_break_ctl,
+=09.startup =3D mps2_uart_startup,
+=09.shutdown =3D mps2_uart_shutdown,
+=09.set_termios =3D mps2_uart_set_termios,
+=09.type =3D mps2_uart_type,
+=09.release_port =3D mps2_uart_release_port,
+=09.request_port =3D mps2_uart_request_port,
+=09.config_port =3D mps2_uart_config_port,
+=09.verify_port =3D mps2_uart_verify_port,
+};
+
+static struct mps2_uart_port mps2_uart_ports[MPS2_MAX_PORTS];
+
+#ifdef CONFIG_SERIAL_MPS2_UART_CONSOLE
+static void mps2_uart_console_putchar(struct uart_port *port, int ch)
+{
+=09while (mps2_uart_read8(port, UARTn_STATE) & UARTn_STATE_TX_FULL)
+=09=09cpu_relax();
+
+=09mps2_uart_write8(port, ch, UARTn_DATA);
+}
+
+static void mps2_uart_console_write(struct console *co, const char *s, uns=
igned int cnt)
+{
+=09struct uart_port *port =3D &mps2_uart_ports[co->index].port;
+
+=09uart_console_write(port, s, cnt, mps2_uart_console_putchar);
+}
+
+static int mps2_uart_console_setup(struct console *co, char *options)
+{
+=09struct mps2_uart_port *mps_port;
+=09int baud =3D 9600;
+=09int bits =3D 8;
+=09int parity =3D 'n';
+=09int flow =3D 'n';
+
+=09if (co->index < 0 || co->index >=3D MPS2_MAX_PORTS)
+=09=09return -ENODEV;
+
+=09mps_port =3D &mps2_uart_ports[co->index];
+
+=09if (options)
+=09=09uart_parse_options(options, &baud, &parity, &bits, &flow);
+
+=09return uart_set_options(&mps_port->port, co, baud, parity, bits, flow);
+}
+
+static struct uart_driver mps2_uart_driver;
+
+static struct console mps2_uart_console =3D {
+=09.name =3D SERIAL_NAME,
+=09.device =3D uart_console_device,
+=09.write =3D mps2_uart_console_write,
+=09.setup =3D mps2_uart_console_setup,
+=09.flags =3D CON_PRINTBUFFER,
+=09.index =3D -1,
+=09.data =3D &mps2_uart_driver,
+};
+
+#define MPS2_SERIAL_CONSOLE (&mps2_uart_console)
+
+#else
+#define MPS2_SERIAL_CONSOLE NULL
+#endif
+
+static struct uart_driver mps2_uart_driver =3D {
+=09.driver_name =3D DRIVER_NAME,
+=09.dev_name =3D SERIAL_NAME,
+=09.nr =3D MPS2_MAX_PORTS,
+=09.cons =3D MPS2_SERIAL_CONSOLE,
+};
+
+static struct mps2_uart_port *mps2_of_get_port(struct platform_device *pde=
v)
+{
+=09struct device_node *np =3D pdev->dev.of_node;
+=09int id;
+
+=09if (!np)
+=09=09return NULL;
+
+=09id =3D of_alias_get_id(np, "serial");
+=09if (id < 0)
+=09=09id =3D 0;
+
+=09if (WARN_ON(id >=3D MPS2_MAX_PORTS))
+=09=09return NULL;
+
+=09mps2_uart_ports[id].port.line =3D id;
+=09return &mps2_uart_ports[id];
+}
+
+static int mps2_init_port(struct mps2_uart_port *mps_port,
+=09=09=09struct platform_device *pdev)
+{
+=09int ret =3D 0;
+=09struct resource *res;
+
+=09res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
+=09mps_port->port.membase =3D devm_ioremap_resource(&pdev->dev, res);
+=09if (IS_ERR(mps_port->port.membase))
+=09=09return PTR_ERR(mps_port->port.membase);
+
+=09mps_port->port.mapbase =3D res->start;
+=09mps_port->port.mapsize =3D resource_size(res);
+
+=09mps_port->rx_irq =3D platform_get_irq(pdev, 0);
+=09mps_port->tx_irq =3D platform_get_irq(pdev, 1);
+=09mps_port->port.irq =3D platform_get_irq(pdev, 2);
+
+=09mps_port->port.iotype =3D UPIO_MEM;
+=09mps_port->port.flags =3D UPF_BOOT_AUTOCONF;
+=09mps_port->port.fifosize =3D 1;
+=09mps_port->port.ops =3D &mps2_uart_pops;
+=09mps_port->port.dev =3D &pdev->dev;
+
+=09mps_port->clk =3D devm_clk_get(&pdev->dev, NULL);
+=09if (IS_ERR(mps_port->clk))
+=09=09return PTR_ERR(mps_port->clk);
+
+=09ret =3D clk_prepare_enable(mps_port->clk);
+=09if (ret)
+=09=09return ret;
+
+=09mps_port->port.uartclk =3D clk_get_rate(mps_port->clk);
+=09if (!mps_port->port.uartclk)
+=09=09ret =3D -EINVAL;
+
+=09clk_disable_unprepare(mps_port->clk);
+
+=09return ret;
+}
+
+static int mps2_serial_probe(struct platform_device *pdev)
+{
+=09struct mps2_uart_port *mps_port;
+=09int ret;
+
+=09mps_port =3D mps2_of_get_port(pdev);
+=09if (!mps_port)
+=09=09return -ENODEV;
+
+=09ret =3D mps2_init_port(mps_port, pdev);
+=09if (ret)
+=09=09return ret;
+
+=09ret =3D uart_add_one_port(&mps2_uart_driver, &mps_port->port);
+=09if (ret)
+=09=09return ret;
+
+=09platform_set_drvdata(pdev, mps_port);
+
+=09return 0;
+}
+
+static int mps2_serial_remove(struct platform_device *pdev)
+{
+=09struct mps2_uart_port *mps_port =3D platform_get_drvdata(pdev);
+
+=09uart_remove_one_port(&mps2_uart_driver, &mps_port->port);
+
+=09return 0;
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id mps2_match[] =3D {
+=09{ .compatible =3D "arm,mps2-uart", },
+=09{},
+};
+MODULE_DEVICE_TABLE(of, mps2_match);
+#endif
+
+static struct platform_driver mps2_serial_driver =3D {
+=09.probe =3D mps2_serial_probe,
+=09.remove =3D mps2_serial_remove,
+
+=09.driver =3D {
+=09=09.name =3D DRIVER_NAME,
+=09=09.of_match_table =3D of_match_ptr(mps2_match),
+=09},
+};
+
+static int __init mps2_uart_init(void)
+{
+=09int ret;
+
+=09ret =3D uart_register_driver(&mps2_uart_driver);
+=09if (ret)
+=09=09return ret;
+
+=09ret =3D platform_driver_register(&mps2_serial_driver);
+=09if (ret)
+=09=09uart_unregister_driver(&mps2_uart_driver);
+
+=09pr_info("MPS2 UART driver initialized\n");
+
+=09return ret;
+}
+module_init(mps2_uart_init);
+
+static void __exit mps2_uart_exit(void)
+{
+=09platform_driver_unregister(&mps2_serial_driver);
+=09uart_unregister_driver(&mps2_uart_driver);
+}
+module_exit(mps2_uart_exit);
+
+MODULE_AUTHOR("Vladimir Murzin <vladimir.murzin@arm.com>");
+MODULE_DESCRIPTION("MPS2 UART driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/serial_c=
ore.h
index 93ba148..f097fe9 100644
--- a/include/uapi/linux/serial_core.h
+++ b/include/uapi/linux/serial_core.h
@@ -261,4 +261,7 @@
 /* STM32 USART */
 #define PORT_STM32=09113
=20
+/* MPS2 UART */
+#define PORT_MPS2UART=09114
+
 #endif /* _UAPILINUX_SERIAL_CORE_H */
--=20
1.7.9.5
