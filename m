From: Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v4] serial: support 16-bit register interface for console
Date: Wed, 28 Oct 2015 12:46:05 +0900
Message-ID: <1446003965-11457-1-git-send-email-yamada.masahiro@socionext.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiri Slaby <jslaby-IBi9RG/b67k@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Currently, 8-bit (MMIO) and 32-bit (MMIO32) register interfaces are
supported for the 8250 console, but the 16-bit (MMIO16) is not.
The 8250 UART device on my board is connected to a 16-bit bus and
my main motivation is to use earlycon with it.
(Refer to arch/arm/boot/dts/uniphier-support-card.dtsi)

Signed-off-by: Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>
---

Changes in v4:
  - Rebase on tty-next branch of TTY subsystem

Changes in v3:
  - Adjust of_platform_serial_setup(), univ8250_console_match()
    for UPIO_MEM16

Changes in v2:
  - Do not change userspace-exported macros

 Documentation/kernel-parameters.txt  |  9 +++++----
 drivers/tty/serial/8250/8250_core.c  |  7 ++++---
 drivers/tty/serial/8250/8250_early.c |  5 +++++
 drivers/tty/serial/8250/8250_port.c  | 20 ++++++++++++++++++++
 drivers/tty/serial/earlycon.c        | 15 +++++++++++----
 drivers/tty/serial/of_serial.c       |  3 +++
 drivers/tty/serial/serial_core.c     |  9 +++++++--
 include/linux/serial_core.h          |  1 +
 include/uapi/linux/serial.h          |  1 +
 9 files changed, 57 insertions(+), 13 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 8d9dd53..8b6f6e8 100644
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
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 3912646..c9720a9 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -620,7 +620,7 @@ static int univ8250_console_setup(struct console *co, char *options)
  *	@options: ptr to option string from console command line
  *
  *	Only attempts to match console command lines of the form:
- *	    console=uart[8250],io|mmio|mmio32,<addr>[,<options>]
+ *	    console=uart[8250],io|mmio|mmio16|mmio32,<addr>[,<options>]
  *	    console=uart[8250],0x<addr>[,<options>]
  *	This form is used to register an initial earlycon boot console and
  *	replace it with the serial8250_console at 8250 driver init.
@@ -650,8 +650,9 @@ static int univ8250_console_match(struct console *co, char *name, int idx,
 
 		if (port->iotype != iotype)
 			continue;
-		if ((iotype == UPIO_MEM || iotype == UPIO_MEM32) &&
-		    (port->mapbase != addr))
+		if ((iotype == UPIO_MEM || iotype == UPIO_MEM16 ||
+		     iotype == UPIO_MEM32 || iotype == UPIO_MEM32BE)
+		    && (port->mapbase != addr))
 			continue;
 		if (iotype == UPIO_PORT && port->iobase != addr)
 			continue;
diff --git a/drivers/tty/serial/8250/8250_early.c b/drivers/tty/serial/8250/8250_early.c
index ceb8579..e9d4acb 100644
--- a/drivers/tty/serial/8250/8250_early.c
+++ b/drivers/tty/serial/8250/8250_early.c
@@ -42,6 +42,8 @@ static unsigned int __init serial8250_early_in(struct uart_port *port, int offse
 	switch (port->iotype) {
 	case UPIO_MEM:
 		return readb(port->membase + offset);
+	case UPIO_MEM16:
+		return readw(port->membase + (offset << 1));
 	case UPIO_MEM32:
 		return readl(port->membase + (offset << 2));
 	case UPIO_MEM32BE:
@@ -59,6 +61,9 @@ static void __init serial8250_early_out(struct uart_port *port, int offset, int
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
index 52d82d2..8d262bc 100644
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
@@ -2462,6 +2480,7 @@ static int serial8250_request_std_resource(struct uart_8250_port *up)
 	case UPIO_TSI:
 	case UPIO_MEM32:
 	case UPIO_MEM32BE:
+	case UPIO_MEM16:
 	case UPIO_MEM:
 		if (!port->mapbase)
 			break;
@@ -2499,6 +2518,7 @@ static void serial8250_release_std_resource(struct uart_8250_port *up)
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
diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index de50296..6d002ee 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -122,6 +122,9 @@ static int of_platform_serial_setup(struct platform_device *ofdev,
 		case 1:
 			port->iotype = UPIO_MEM;
 			break;
+		case 2:
+			port->iotype = UPIO_MEM16;
+			break;
 		case 4:
 			port->iotype = of_device_is_big_endian(np) ?
 				       UPIO_MEM32BE : UPIO_MEM32;
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index def5199..90608aa 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1818,8 +1818,8 @@ uart_get_console(struct uart_port *ports, int nr, struct console *co)
  *	@options: ptr for <options> field; NULL if not present (out)
  *
  *	Decodes earlycon kernel command line parameters of the form
- *	   earlycon=<name>,io|mmio|mmio32|mmio32be|mmio32native,<addr>,<options>
- *	   console=<name>,io|mmio|mmio32|mmio32be|mmio32native,<addr>,<options>
+ *	   earlycon=<name>,io|mmio|mmio16|mmio32|mmio32be|mmio32native,<addr>,<options>
+ *	   console=<name>,io|mmio|mmio16|mmio32|mmio32be|mmio32native,<addr>,<options>
  *
  *	The optional form
  *	   earlycon=<name>,0x<addr>,<options>
@@ -1834,6 +1834,9 @@ int uart_parse_earlycon(char *p, unsigned char *iotype, unsigned long *addr,
 	if (strncmp(p, "mmio,", 5) == 0) {
 		*iotype = UPIO_MEM;
 		p += 5;
+	} else if (strncmp(p, "mmio16,", 7) == 0) {
+		*iotype = UPIO_MEM16;
+		p += 7;
 	} else if (strncmp(p, "mmio32,", 7) == 0) {
 		*iotype = UPIO_MEM32;
 		p += 7;
@@ -2186,6 +2189,7 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
 			 "I/O 0x%lx offset 0x%x", port->iobase, port->hub6);
 		break;
 	case UPIO_MEM:
+	case UPIO_MEM16:
 	case UPIO_MEM32:
 	case UPIO_MEM32BE:
 	case UPIO_AU:
@@ -2831,6 +2835,7 @@ int uart_match_port(struct uart_port *port1, struct uart_port *port2)
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
