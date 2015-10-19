From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 1/2] serial: support register interface with 16-bit stride for console
Date: Mon, 19 Oct 2015 14:40:23 +0900
Message-ID: <1445233224-23150-2-git-send-email-yamada.masahiro@socionext.com>
References: <1445233224-23150-1-git-send-email-yamada.masahiro@socionext.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445233224-23150-1-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-serial@vger.kernel.org
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>, Kevin Cernekee <cernekee@gmail.com>, Jiri Slaby <jslaby@suse.com>, Rob Herring <robh@kernel.org>, linux-api@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, Wang Long <long.wanglong@huawei.com>, Noam Camus <noamc@ezchip.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eddie Huang <eddie.huang@mediatek.com>
List-Id: linux-api@vger.kernel.org

Currently, 8-bit (MMIO) and 32-bit (MMIO32) strides are supported for
the 8250 console, but 16-bit (MMIO16) stride is not.  The 8250 UART
device on my board has 16-bit stride (reg-shift = <1>) and I am eager
to use earlycon with it.

Refer to arch/arm/boot/dts/uniphier-support-card.dtsi:

        serialsc: uart@000b0000 {
                compatible = "ns16550a";
                reg = <0x000b0000 0x20>;
                clock-frequency = <12288000>;
                reg-shift = <1>;
        };

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 Documentation/kernel-parameters.txt  |  9 +++++----
 drivers/tty/serial/8250/8250_early.c |  5 +++++
 drivers/tty/serial/8250/8250_port.c  | 20 ++++++++++++++++++++
 drivers/tty/serial/earlycon.c        | 15 +++++++++++----
 drivers/tty/serial/serial_core.c     |  9 +++++++--
 include/linux/serial_core.h          |  1 +
 include/uapi/linux/serial.h          |  9 +++++----
 7 files changed, 54 insertions(+), 14 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 22a4b68..761f08c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -720,16 +720,17 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 		uart[8250],io,<addr>[,options]
 		uart[8250],mmio,<addr>[,options]
+		uart[8250],mmio16,<addr>[,options]
 		uart[8250],mmio32,<addr>[,options]
 		uart[8250],0x<addr>[,options]
 			Start an early, polled-mode console on the 8250/16550
 			UART at the specified I/O port or MMIO address,
 			switching to the matching ttyS device later.
 			MMIO inter-register address stride is either 8-bit
-			(mmio) or 32-bit (mmio32).
-			If none of [io|mmio|mmio32], <addr> is assumed to be
-			equivalent to 'mmio'. 'options' are specified in the
-			same format described for ttyS above; if unspecified,
+			(mmio), 16-bit (mmio16), or 32-bit (mmio32).
+			If none of [io|mmio|mmio16|mmio32], <addr> is assumed
+			to be equivalent to 'mmio'. 'options' are specified in
+			the same format described for ttyS above; if unspecified,
 			the h/w is not re-initialized.
 
 		hvc<n>	Use the hypervisor console device <n>. This is for
diff --git a/drivers/tty/serial/8250/8250_early.c b/drivers/tty/serial/8250/8250_early.c
index faed05f..7aff3d8 100644
--- a/drivers/tty/serial/8250/8250_early.c
+++ b/drivers/tty/serial/8250/8250_early.c
@@ -40,6 +40,8 @@ static unsigned int __init serial8250_early_in(struct uart_port *port, int offse
 	switch (port->iotype) {
 	case UPIO_MEM:
 		return readb(port->membase + offset);
+	case UPIO_MEM16:
+		return readw(port->membase + (offset << 1));
 	case UPIO_MEM32:
 		return readl(port->membase + (offset << 2));
 	case UPIO_MEM32BE:
@@ -57,6 +59,9 @@ static void __init serial8250_early_out(struct uart_port *port, int offset, int
 	case UPIO_MEM:
 		writeb(value, port->membase + offset);
 		break;
+	case UPIO_MEM16:
+		writew(value, port->membase + (offset << 1));
+		break;
 	case UPIO_MEM32:
 		writel(value, port->membase + (offset << 2));
 		break;
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 0bbf340..f976948 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -368,6 +368,18 @@ static void mem_serial_out(struct uart_port *p, int offset, int value)
 	writeb(value, p->membase + offset);
 }
 
+static void mem16_serial_out(struct uart_port *p, int offset, int value)
+{
+	offset = offset << p->regshift;
+	writew(value, p->membase + offset);
+}
+
+static unsigned int mem16_serial_in(struct uart_port *p, int offset)
+{
+	offset = offset << p->regshift;
+	return readw(p->membase + offset);
+}
+
 static void mem32_serial_out(struct uart_port *p, int offset, int value)
 {
 	offset = offset << p->regshift;
@@ -425,6 +437,11 @@ static void set_io_from_upio(struct uart_port *p)
 		p->serial_out = mem_serial_out;
 		break;
 
+	case UPIO_MEM16:
+		p->serial_in = mem16_serial_in;
+		p->serial_out = mem16_serial_out;
+		break;
+
 	case UPIO_MEM32:
 		p->serial_in = mem32_serial_in;
 		p->serial_out = mem32_serial_out;
@@ -459,6 +476,7 @@ serial_port_out_sync(struct uart_port *p, int offset, int value)
 {
 	switch (p->iotype) {
 	case UPIO_MEM:
+	case UPIO_MEM16:
 	case UPIO_MEM32:
 	case UPIO_MEM32BE:
 	case UPIO_AU:
@@ -2447,6 +2465,7 @@ static int serial8250_request_std_resource(struct uart_8250_port *up)
 	case UPIO_TSI:
 	case UPIO_MEM32:
 	case UPIO_MEM32BE:
+	case UPIO_MEM16:
 	case UPIO_MEM:
 		if (!port->mapbase)
 			break;
@@ -2484,6 +2503,7 @@ static void serial8250_release_std_resource(struct uart_8250_port *up)
 	case UPIO_TSI:
 	case UPIO_MEM32:
 	case UPIO_MEM32BE:
+	case UPIO_MEM16:
 	case UPIO_MEM:
 		if (!port->mapbase)
 			break;
diff --git a/drivers/tty/serial/earlycon.c b/drivers/tty/serial/earlycon.c
index f096360..07f7393 100644
--- a/drivers/tty/serial/earlycon.c
+++ b/drivers/tty/serial/earlycon.c
@@ -71,10 +71,16 @@ static int __init parse_options(struct earlycon_device *device, char *options)
 		return -EINVAL;
 
 	switch (port->iotype) {
+	case UPIO_MEM:
+		port->mapbase = addr;
+		break;
+	case UPIO_MEM16:
+		port->regshift = 1;
+		port->mapbase = addr;
+		break;
 	case UPIO_MEM32:
 	case UPIO_MEM32BE:
-		port->regshift = 2;	/* fall-through */
-	case UPIO_MEM:
+		port->regshift = 2;
 		port->mapbase = addr;
 		break;
 	case UPIO_PORT:
@@ -91,10 +97,11 @@ static int __init parse_options(struct earlycon_device *device, char *options)
 		strlcpy(device->options, options, length);
 	}
 
-	if (port->iotype == UPIO_MEM || port->iotype == UPIO_MEM32 ||
-	    port->iotype == UPIO_MEM32BE)
+	if (port->iotype == UPIO_MEM || port->iotype == UPIO_MEM16 ||
+	    port->iotype == UPIO_MEM32 || port->iotype == UPIO_MEM32BE)
 		pr_info("Early serial console at MMIO%s 0x%llx (options '%s')\n",
 			(port->iotype == UPIO_MEM) ? "" :
+			(port->iotype == UPIO_MEM16) ? "16" :
 			(port->iotype == UPIO_MEM32) ? "32" : "32be",
 			(unsigned long long)port->mapbase,
 			device->options);
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 603d2cc..325acce 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1819,8 +1819,8 @@ uart_get_console(struct uart_port *ports, int nr, struct console *co)
  *	@options: ptr for <options> field; NULL if not present (out)
  *
  *	Decodes earlycon kernel command line parameters of the form
- *	   earlycon=<name>,io|mmio|mmio32|mmio32be,<addr>,<options>
- *	   console=<name>,io|mmio|mmio32|mmio32be,<addr>,<options>
+ *	   earlycon=<name>,io|mmio|mmio16|mmio32|mmio32be,<addr>,<options>
+ *	   console=<name>,io|mmio|mmio16|mmio32|mmio32be,<addr>,<options>
  *
  *	The optional form
  *	   earlycon=<name>,0x<addr>,<options>
@@ -1835,6 +1835,9 @@ int uart_parse_earlycon(char *p, unsigned char *iotype, unsigned long *addr,
 	if (strncmp(p, "mmio,", 5) == 0) {
 		*iotype = UPIO_MEM;
 		p += 5;
+	} else if (strncmp(p, "mmio16,", 7) == 0) {
+		*iotype = UPIO_MEM16;
+		p += 7;
 	} else if (strncmp(p, "mmio32,", 7) == 0) {
 		*iotype = UPIO_MEM32;
 		p += 7;
@@ -2183,6 +2186,7 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 			 "I/O 0x%lx offset 0x%x", port->iobase, port->hub6);
 		break;
 	case UPIO_MEM:
+	case UPIO_MEM16:
 	case UPIO_MEM32:
 	case UPIO_MEM32BE:
 	case UPIO_AU:
@@ -2828,6 +2832,7 @@ int uart_match_port(struct uart_port *port1, struct uart_port *port2)
 		return (port1->iobase == port2->iobase) &&
 		       (port1->hub6   == port2->hub6);
 	case UPIO_MEM:
+	case UPIO_MEM16:
 	case UPIO_MEM32:
 	case UPIO_MEM32BE:
 	case UPIO_AU:
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 297d4fa..e2ded87 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -146,6 +146,7 @@ struct uart_port {
 #define UPIO_PORT		(SERIAL_IO_PORT)	/* 8b I/O port access */
 #define UPIO_HUB6		(SERIAL_IO_HUB6)	/* Hub6 ISA card */
 #define UPIO_MEM		(SERIAL_IO_MEM)		/* 8b MMIO access */
+#define UPIO_MEM16		(SERIAL_IO_MEM16)	/* 16b little endian */
 #define UPIO_MEM32		(SERIAL_IO_MEM32)	/* 32b little endian */
 #define UPIO_AU			(SERIAL_IO_AU)		/* Au1x00 and RT288x type IO */
 #define UPIO_TSI		(SERIAL_IO_TSI)		/* Tsi108/109 type IO */
diff --git a/include/uapi/linux/serial.h b/include/uapi/linux/serial.h
index 25331f9..1d20d9c 100644
--- a/include/uapi/linux/serial.h
+++ b/include/uapi/linux/serial.h
@@ -65,10 +65,11 @@ struct serial_struct {
 #define SERIAL_IO_PORT	0
 #define SERIAL_IO_HUB6	1
 #define SERIAL_IO_MEM	2
-#define SERIAL_IO_MEM32	  3
-#define SERIAL_IO_AU	  4
-#define SERIAL_IO_TSI	  5
-#define SERIAL_IO_MEM32BE 6
+#define SERIAL_IO_MEM16	3
+#define SERIAL_IO_MEM32	  4
+#define SERIAL_IO_AU	  5
+#define SERIAL_IO_TSI	  6
+#define SERIAL_IO_MEM32BE 7
 
 #define UART_CLEAR_FIFO		0x01
 #define UART_USE_FIFO		0x02
-- 
1.9.1
