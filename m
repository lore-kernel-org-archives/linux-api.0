From: Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 1/2] serial: support register interface with 16-bit stride for console
Date: Tue, 20 Oct 2015 12:36:28 +0900
Message-ID: <1445312189-28876-2-git-send-email-yamada.masahiro@socionext.com>
References: <1445312189-28876-1-git-send-email-yamada.masahiro@socionext.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445312189-28876-1-git-send-email-yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vineet Gupta <Vineet.Gupta1-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, Kevin Cernekee <cernekee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jiri Slaby <jslaby-IBi9RG/b67k@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eddie Huang <eddie.huang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Currently, 8-bit (MMIO) and 32-bit (MMIO32) register strides are
supported for the 8250 console, but 16-bit (MMIO16) stride is not.
The 8250 UART device on my board is connected to a 16-bit bus
(reg-shift = <1>) and I am eager to use earlycon with it.

Refer to arch/arm/boot/dts/uniphier-support-card.dtsi:

        serialsc: uart@000b0000 {
                compatible = "ns16550a";
                reg = <0x000b0000 0x20>;
                clock-frequency = <12288000>;
                reg-shift = <1>;
        };

Signed-off-by: Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>
---

Changes in v2:
  - Do not change userspace-exported macros

 Documentation/kernel-parameters.txt  |  9 +++++----
 drivers/tty/serial/8250/8250_early.c |  5 +++++
 drivers/tty/serial/8250/8250_port.c  | 20 ++++++++++++++++++++
 drivers/tty/serial/earlycon.c        | 15 +++++++++++----
 drivers/tty/serial/serial_core.c     |  9 +++++++--
 include/linux/serial_core.h          |  1 +
 include/uapi/linux/serial.h          |  1 +
 7 files changed, 50 insertions(+), 10 deletions(-)

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
index 297d4fa..35aa87b 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -150,6 +150,7 @@ struct uart_port {
 #define UPIO_AU			(SERIAL_IO_AU)		/* Au1x00 and RT288x type IO */
 #define UPIO_TSI		(SERIAL_IO_TSI)		/* Tsi108/109 type IO */
 #define UPIO_MEM32BE		(SERIAL_IO_MEM32BE)	/* 32b big endian */
+#define UPIO_MEM16		(SERIAL_IO_MEM16)	/* 16b little endian */
 
 	unsigned int		read_status_mask;	/* driver specific */
 	unsigned int		ignore_status_mask;	/* driver specific */
diff --git a/include/uapi/linux/serial.h b/include/uapi/linux/serial.h
index 25331f9..5d59c3e 100644
--- a/include/uapi/linux/serial.h
+++ b/include/uapi/linux/serial.h
@@ -69,6 +69,7 @@ struct serial_struct {
 #define SERIAL_IO_AU	  4
 #define SERIAL_IO_TSI	  5
 #define SERIAL_IO_MEM32BE 6
+#define SERIAL_IO_MEM16	7
 
 #define UART_CLEAR_FIFO		0x01
 #define UART_USE_FIFO		0x02
-- 
1.9.1
