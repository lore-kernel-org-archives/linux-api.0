From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v5 05/10] serial: mps2-uart: add support for early console
Date: Fri,  1 Apr 2016 15:02:56 +0100
Message-ID: <1459519381-34441-6-git-send-email-vladimir.murzin@arm.com>
References: <1459519381-34441-1-git-send-email-vladimir.murzin@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459519381-34441-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, liviu.dudau@arm.com, sudeep.holla@arm.com, lorenzo.pieralisi@arm.com
Cc: mark.rutland@arm.com, gnomes@lxorguk.ukuu.org.uk, peter@hurleysoftware.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, andy.shevchenko@gmail.com, robh+dt@kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This adds support early console for MPS2 UART which can be enabled via
earlycon=mps2,0x40004000

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/Kconfig     |    1 +
 drivers/tty/serial/mps2-uart.c |   28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 3673ef0..4e6d2d1 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1450,6 +1450,7 @@ config SERIAL_MPS2_UART_CONSOLE
 	bool "MPS2 UART console support"
 	depends on SERIAL_MPS2_UART
 	select SERIAL_CORE_CONSOLE
+	select SERIAL_EARLYCON
 
 config SERIAL_MPS2_UART
 	bool "MPS2 UART port"
diff --git a/drivers/tty/serial/mps2-uart.c b/drivers/tty/serial/mps2-uart.c
index 1ae0b39..e8ad935 100644
--- a/drivers/tty/serial/mps2-uart.c
+++ b/drivers/tty/serial/mps2-uart.c
@@ -451,6 +451,34 @@ static struct console mps2_uart_console = {
 
 #define MPS2_SERIAL_CONSOLE (&mps2_uart_console)
 
+static void mps2_early_putchar(struct uart_port *port, int ch)
+{
+
+	while (readb(port->membase + UARTn_STATE) & UARTn_STATE_TX_FULL)
+		cpu_relax();
+
+	writeb((unsigned char)ch, port->membase + UARTn_DATA);
+}
+
+static void mps2_early_write(struct console *con, const char *s, unsigned n)
+{
+	struct earlycon_device *dev = con->data;
+
+	uart_console_write(&dev->port, s, n, mps2_early_putchar);
+}
+
+static int __init mps2_early_console_setup(struct earlycon_device *device,
+					   const char *opt)
+{
+	if (!device->port.membase)
+		return -ENODEV;
+
+	device->con->write = mps2_early_write;
+
+	return 0;
+}
+OF_EARLYCON_DECLARE(mps2, "arm,mps2-uart", mps2_early_console_setup);
+
 #else
 #define MPS2_SERIAL_CONSOLE NULL
 #endif
-- 
1.7.9.5
