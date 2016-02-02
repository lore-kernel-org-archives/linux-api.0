From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v2 05/10] serial: mps2-uart: add support for early console
Date: Tue,  2 Feb 2016 11:39:54 +0000
Message-ID: <1454413199-26573-6-git-send-email-vladimir.murzin@arm.com>
References: <1454413199-26573-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1454413199-26573-1-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, robh+dt@kernel.org, linux-serial@vger.kernel.org, galak@codeaurora.org, jslaby@suse.cz, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

This adds support early console for MPS2 UART which can be enabled via
earlycon=mps2,0x40004000

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 drivers/tty/serial/Kconfig     |    1 +
 drivers/tty/serial/mps2-uart.c |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 3a248be..4ed6e51 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1454,6 +1454,7 @@ config SERIAL_MPS2_UART_CONSOLE
 	bool "MPS2 UART console support"
 	depends on SERIAL_MPS2_UART
 	select SERIAL_CORE_CONSOLE
+	select SERIAL_EARLYCON
 
 config SERIAL_MPS2_UART
 	bool "MPS2 UART port"
diff --git a/drivers/tty/serial/mps2-uart.c b/drivers/tty/serial/mps2-uart.c
index 4d113ec..530dcab 100644
--- a/drivers/tty/serial/mps2-uart.c
+++ b/drivers/tty/serial/mps2-uart.c
@@ -435,6 +435,36 @@ static struct console mps2_uart_console = {
 
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
+EARLYCON_DECLARE(mps2, mps2_early_console_setup);
+OF_EARLYCON_DECLARE(mps2, "arm,mps2-uart", mps2_early_console_setup);
+
 #else
 #define MPS2_SERIAL_CONSOLE NULL
 #endif
-- 
1.7.9.5
