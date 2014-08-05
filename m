From: Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 1/3] tty: serial: 8250: Add new capability for highspeed register
Date: Tue,  5 Aug 2014 12:54:11 +0200
Message-ID: <1407236054-30994-2-git-send-email-matthias.bgg@gmail.com>
References: <1407236054-30994-1-git-send-email-matthias.bgg@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1407236054-30994-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rdunlap@infradead.org, gregkh@linuxfoundation.org, jslaby@suse.cz, grant.likely@linaro.org, matthias.bgg@gmail.com, heikki.krogerus@linux.intel.com, alan@linux.intel.com, paul.gortmaker@windriver.com, asierra@xes-inc.com, mwelling@ieee.org, dianders@chromium.org, m-karicheri2@ti.com, jschultz@xes-inc.com, mingo@elte.hu, balbi@ti.com, heiko@sntech.de, devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patch adds a new capability to the 8250 driver framework. The Mediatek UART
port has a highspeed register to set the baudrate the port will work with.
This influences the calculation of the divisor.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 drivers/tty/serial/8250/8250.h      |    1 +
 drivers/tty/serial/8250/8250_core.c |   47 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/serial_reg.h     |    6 +++++
 3 files changed, 54 insertions(+)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 1ebf853..2b17655 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -70,6 +70,7 @@ struct serial8250_config {
 #define UART_CAP_UUE	(1 << 12)	/* UART needs IER bit 6 set (Xscale) */
 #define UART_CAP_RTOIE	(1 << 13)	/* UART needs IER bit 4 set (Xscale, Tegra) */
 #define UART_CAP_HFIFO	(1 << 14)	/* UART has a "hidden" FIFO */
+#define UART_CAP_HIGHS	(1 << 15)	/* UART has a highspeed register (Mediatek) */
 
 #define UART_BUG_QUOT	(1 << 0)	/* UART has buggy quot LSB */
 #define UART_BUG_TXEN	(1 << 1)	/* UART has buggy TX IIR status */
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 27f7ad6..a0c531b 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -2434,6 +2434,53 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 	serial_dl_write(up, quot);
 
 	/*
+	 * Mediatek UARTs use an extra highspeed register (UART_MTK_HIGHS)
+	 *
+	 * We need to recalcualte the quot register, as the claculation depends
+	 * on the vaule in the highspeed register.
+	 *
+	 * Some baudrates are not supported by the chip, so we use the next
+	 * lower rate supported.
+	 *
+	 * If highspeed register is set to 3, we need to specify sample count
+	 * and sample point to increase accuracy. If not, we reset the
+	 * registers to their default values.
+	 */
+	if (up->port.flags & UART_CAP_HIGHS) {
+		if (baud <= 115200) {
+			serial_port_out(port, UART_MTK_HIGHS, 0x0);
+		} else if (baud <= 576000) {
+			serial_port_out(port, UART_MTK_HIGHS, 0x2);
+
+			/* Set to next lower baudrate supported */
+			if ((baud == 500000) || (baud == 576000))
+				baud = 460800;
+			quot = DIV_ROUND_CLOSEST(port->uartclk, 4 * baud);
+		} else {
+			serial_port_out(port, UART_MTK_HIGHS, 0x3);
+
+			/* Set to highest baudrate supported */
+			if (baud >= 1152000)
+				baud = 1000000;
+			quot = DIV_ROUND_CLOSEST(port->uartclk, 256 * baud);
+		}
+
+		serial_dl_write(up, quot);
+
+		if (baud > 460800) {
+			unsigned int tmp;
+
+			tmp = DIV_ROUND_CLOSEST(port->uartclk, quot * baud);
+			serial_port_out(port, UART_MTK_SAMPLE_COUNT, tmp - 1);
+			serial_port_out(port, UART_MTK_SAMPLE_POINT,
+						(tmp - 2) >> 1);
+		} else {
+			serial_port_out(port, UART_MTK_SAMPLE_COUNT, 0x00);
+			serial_port_out(port, UART_MTK_SAMPLE_POINT, 0xff);
+		}
+	}
+
+	/*
 	 * XR17V35x UARTs have an extra fractional divisor register (DLD)
 	 *
 	 * We need to recalculate all of the registers, because DLM and DLL
diff --git a/include/uapi/linux/serial_reg.h b/include/uapi/linux/serial_reg.h
index 99b4705..f6dc97c 100644
--- a/include/uapi/linux/serial_reg.h
+++ b/include/uapi/linux/serial_reg.h
@@ -385,5 +385,11 @@
 #define UART_EXAR_TXTRG		0x0a	/* Tx FIFO trigger level write-only */
 #define UART_EXAR_RXTRG		0x0b	/* Rx FIFO trigger level write-only */
 
+/*
+ * These are definitions for the Mediatek UART
+ */
+#define UART_MTK_HIGHS		0x09	/* Highspeed register */
+#define UART_MTK_SAMPLE_COUNT	0x0a	/* Sample count register */
+#define UART_MTK_SAMPLE_POINT	0x0b	/* Sample point register */
 #endif /* _LINUX_SERIAL_REG_H */
 
-- 
1.7.9.5

