From: Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH v6 2/2] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Date: Thu, 22 Jan 2015 22:57:15 -0500
Message-ID: <54C1C69B.6010100@hurleysoftware.com>
References: <sprd-serial-v6> <1421933706-4277-1-git-send-email-chunyan.zhang@spreadtrum.com> <1421933706-4277-3-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1421933706-4277-3-git-send-email-chunyan.zhang@spreadtrum.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>, gregkh@linuxfoundation.org, robh+dt@kernel.org
Cc: mark.rutland@arm.com, arnd@arndb.de, gnomes@lxorguk.ukuu.org.uk, shawn.guo@linaro.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, grant.likely@linaro.org, heiko@sntech.de, jason@lakedaemon.net, florian.vaussard@epfl.ch, andrew@lunn.ch, hytszk@gmail.com, antonynpavlov@gmail.com, orsonzhai@gmail.com, geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com, zhang.lyra@gmail.com, wei.qiao@spreadtrum.com, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Chunyan,

On 01/22/2015 08:35 AM, Chunyan Zhang wrote:
> Add a full sc9836-uart driver for SC9836 SoC which is based on the
> spreadtrum sharkl64 platform.
> This driver also support earlycon.

Looking good. Comments below.

> This patch also replaced the spaces between the macros and their
> values with the tabs in serial_core.h

Notes about patch changes goes...

> 
> Originally-by: Lanqing Liu <lanqing.liu@spreadtrum.com>
> Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
> ---

...here. For example,

* Replaced spaces with tab for PORT_SPRD define in serial_core.h

>  drivers/tty/serial/Kconfig       |   18 +
>  drivers/tty/serial/Makefile      |    1 +
>  drivers/tty/serial/sprd_serial.c |  801 ++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/serial_core.h |    3 +
>  4 files changed, 823 insertions(+)
>  create mode 100644 drivers/tty/serial/sprd_serial.c
> 
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index c79b43c..13211f7 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -1577,6 +1577,24 @@ config SERIAL_MEN_Z135
>  	  This driver can also be build as a module. If so, the module will be called
>  	  men_z135_uart.ko
>  
> +config SERIAL_SPRD
> +	tristate "Support for Spreadtrum serial"
> +	depends on ARCH_SPRD
> +	select SERIAL_CORE
> +	help
> +	  This enables the driver for the Spreadtrum's serial.
> +
> +config SERIAL_SPRD_CONSOLE
> +	bool "Spreadtrum UART console support"
> +	depends on SERIAL_SPRD=y
> +	select SERIAL_CORE_CONSOLE
> +	select SERIAL_EARLYCON
> +	help
> +	  Support for early debug console using Spreadtrum's serial. This enables
> +	  the console before standard serial driver is probed. This is enabled
> +	  with "earlycon" on the kernel command line. The console is
> +	  enabled when early_param is processed.
> +
>  endmenu
>  
>  config SERIAL_MCTRL_GPIO
> diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
> index 9a548ac..4801aca 100644
> --- a/drivers/tty/serial/Makefile
> +++ b/drivers/tty/serial/Makefile
> @@ -93,6 +93,7 @@ obj-$(CONFIG_SERIAL_ARC)	+= arc_uart.o
>  obj-$(CONFIG_SERIAL_RP2)	+= rp2.o
>  obj-$(CONFIG_SERIAL_FSL_LPUART)	+= fsl_lpuart.o
>  obj-$(CONFIG_SERIAL_MEN_Z135)	+= men_z135_uart.o
> +obj-$(CONFIG_SERIAL_SPRD) += sprd_serial.o
>  
>  # GPIOLIB helpers for modem control lines
>  obj-$(CONFIG_SERIAL_MCTRL_GPIO)	+= serial_mctrl_gpio.o
> diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
> new file mode 100644
> index 0000000..fd98541
> --- /dev/null
> +++ b/drivers/tty/serial/sprd_serial.c
> @@ -0,0 +1,801 @@
> +/*
> + * Copyright (C) 2012-2015 Spreadtrum Communications Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/console.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/ioport.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/serial_core.h>
> +#include <linux/serial.h>
> +#include <linux/slab.h>
> +#include <linux/tty.h>
> +#include <linux/tty_flip.h>
> +
> +/* device name */
> +#define UART_NR_MAX		8
> +#define SPRD_TTY_NAME		"ttyS"
> +#define SPRD_FIFO_SIZE		128
> +#define SPRD_DEF_RATE		26000000
> +#define SPRD_TIMEOUT		2048
> +
> +/* the offset of serial registers and BITs for them */
> +/* data registers */
> +#define SPRD_TXD		0x0000
> +#define SPRD_RXD		0x0004
> +
> +/* line status register and its BITs  */
> +#define SPRD_LSR		0x0008
> +#define SPRD_LSR_OE		BIT(4)
> +#define SPRD_LSR_FE		BIT(3)
> +#define SPRD_LSR_PE		BIT(2)
> +#define SPRD_LSR_BI		BIT(7)
> +#define SPRD_LSR_TX_OVER	BIT(15)
> +
> +/* data number in TX and RX fifo */
> +#define SPRD_STS1		0x000C
> +
> +/* interrupt enable register and its BITs */
> +#define SPRD_IEN		0x0010
> +#define SPRD_IEN_RX_FULL	BIT(0)
> +#define SPRD_IEN_TX_EMPTY	BIT(1)
> +#define SPRD_IEN_BREAK_DETECT	BIT(7)
> +#define SPRD_IEN_TIMEOUT	BIT(13)
> +
> +/* interrupt clear register */
> +#define SPRD_ICLR		0x0014
> +
> +/* line control register */
> +#define SPRD_LCR		0x0018
> +#define SPRD_LCR_STOP_1BIT	0x10
> +#define SPRD_LCR_STOP_2BIT	0x30
> +#define SPRD_LCR_DATA_LEN	(BIT(2) | BIT(3))
> +#define SPRD_LCR_DATA_LEN5	0x0
> +#define SPRD_LCR_DATA_LEN6	0x4
> +#define SPRD_LCR_DATA_LEN7	0x8
> +#define SPRD_LCR_DATA_LEN8	0xc
> +#define SPRD_LCR_PARITY		(BIT(0) | BIT(1))
> +#define SPRD_LCR_PARITY_EN	0x2
> +#define SPRD_LCR_EVEN_PAR	0x0
> +#define SPRD_LCR_ODD_PAR	0x1
> +
> +/* control register 1 */
> +#define SPRD_CTL1		0x001C
> +#define RX_HW_FLOW_CTL_THLD	BIT(6)
> +#define RX_HW_FLOW_CTL_EN	BIT(7)
> +#define TX_HW_FLOW_CTL_EN	BIT(8)
> +
> +/* fifo threshold register */
> +#define SPRD_CTL2		0x0020
> +#define THLD_TX_EMPTY		0x40
> +#define THLD_RX_FULL		0x40
> +
> +/* config baud rate register */
> +#define SPRD_CLKD0		0x0024
> +#define SPRD_CLKD1		0x0028
> +
> +/* interrupt mask status register */
> +#define SPRD_IMSR		0x002C
> +#define SPRD_IMSR_RX_FIFO_FULL	BIT(0)
> +#define SPRD_IMSR_TX_FIFO_EMPTY	BIT(1)
> +#define SPRD_IMSR_BREAK_DETECT	BIT(7)
> +#define SPRD_IMSR_TIMEOUT	BIT(13)
> +
> +struct reg_backup {
> +	uint32_t ien;

	u32	ien;

same for others

> +	uint32_t ctrl0;
> +	uint32_t ctrl1;
> +	uint32_t ctrl2;
> +	uint32_t clkd0;
> +	uint32_t clkd1;
> +	uint32_t dspwait;
> +};
> +
> +struct sprd_uart_port {
> +	struct uart_port port;
> +	struct reg_backup reg_bak;
> +	char name[16];
> +};
> +
> +static struct sprd_uart_port *sprd_port[UART_NR_MAX] = { NULL };
                                                        ^^^^^^^^^^
Don't need the initializer.

> +
> +static inline unsigned int serial_in(struct uart_port *port, int offset)
> +{
> +	return readl_relaxed(port->membase + offset);
> +}
> +
> +static inline void serial_out(struct uart_port *port, int offset, int value)
> +{
> +	writel_relaxed(value, port->membase + offset);
> +}
> +
> +static unsigned int sprd_tx_empty(struct uart_port *port)
> +{
> +	if (serial_in(port, SPRD_STS1) & 0xff00)
> +		return 0;
> +	else
> +		return TIOCSER_TEMT;
> +}
> +
> +static unsigned int sprd_get_mctrl(struct uart_port *port)
> +{
> +	return TIOCM_DSR | TIOCM_CTS;
> +}
> +
> +static void sprd_set_mctrl(struct uart_port *port, unsigned int mctrl)
> +{
> +	/* nothing to do */
> +}
> +
> +static void sprd_stop_tx(struct uart_port *port)
> +{
> +	unsigned int ien, iclr;
> +
> +	iclr = serial_in(port, SPRD_ICLR);
> +	ien = serial_in(port, SPRD_IEN);
> +
> +	iclr |= SPRD_IEN_TX_EMPTY;
> +	ien &= ~SPRD_IEN_TX_EMPTY;
> +
> +	serial_out(port, SPRD_ICLR, iclr);
> +	serial_out(port, SPRD_IEN, ien);
> +}
> +
> +static void sprd_start_tx(struct uart_port *port)
> +{
> +	unsigned int ien;
> +
> +	ien = serial_in(port, SPRD_IEN);
> +	if (!(ien & SPRD_IEN_TX_EMPTY)) {
> +		ien |= SPRD_IEN_TX_EMPTY;
> +		serial_out(port, SPRD_IEN, ien);
> +	}
> +}
> +
> +static void sprd_stop_rx(struct uart_port *port)
> +{
> +	unsigned int ien, iclr;
> +
> +	iclr = serial_in(port, SPRD_ICLR);
> +	ien = serial_in(port, SPRD_IEN);
> +
> +	ien &= ~(SPRD_IEN_RX_FULL | SPRD_IEN_BREAK_DETECT);
> +	iclr |= SPRD_IEN_RX_FULL | SPRD_IEN_BREAK_DETECT;
> +
> +	serial_out(port, SPRD_IEN, ien);
> +	serial_out(port, SPRD_ICLR, iclr);
> +}
> +
> +/* The Sprd serial does not support this function. */
> +static void sprd_break_ctl(struct uart_port *port, int break_state)
> +{
> +	/* nothing to do */
> +}
> +
> +static inline int handle_lsr_errors(struct uart_port *port,
> +				    unsigned int *flag,
> +				    unsigned int *lsr)

Don't declare this inline. gcc will inline single call site
functions.

> +{
> +	int ret = 0;
> +
> +	/* statistics */
> +	if (*lsr & SPRD_LSR_BI) {
> +		*lsr &= ~(SPRD_LSR_FE | SPRD_LSR_PE);
> +		port->icount.brk++;
> +		ret = uart_handle_break(port);
> +		if (ret)
> +			return ret;
> +	} else if (*lsr & SPRD_LSR_PE)
> +		port->icount.parity++;
> +	else if (*lsr & SPRD_LSR_FE)
> +		port->icount.frame++;
> +	if (*lsr & SPRD_LSR_OE)
> +		port->icount.overrun++;
> +
> +	/* mask off conditions which should be ignored */
> +	*lsr &= port->read_status_mask;
> +	if (*lsr & SPRD_LSR_BI)
> +		*flag = TTY_BREAK;
> +	else if (*lsr & SPRD_LSR_PE)
> +		*flag = TTY_PARITY;
> +	else if (*lsr & SPRD_LSR_FE)
> +		*flag = TTY_FRAME;
> +
> +	return ret;
> +}
> +
> +static inline void sprd_rx(int irq, void *dev_id)
                                       ^^^^^^^^^^^^
                                       struct uart_port *port

The 'irq' parameter is unused, remove it.
Don't declare inline.

> +{
> +	struct uart_port *port = dev_id;
        ^^^^^^^^^
delete this line.

> +	struct tty_port *tty = &port->state->port;
> +	unsigned int ch, flag, lsr, max_count = SPRD_TIMEOUT;
                                                ^^^^^^^^^
                                                == 2048?

That's a lot. Most (all?) other drivers use 256.

> +
> +	while ((serial_in(port, SPRD_STS1) & 0x00ff) && max_count--) {
> +		lsr = serial_in(port, SPRD_LSR);
> +		ch = serial_in(port, SPRD_RXD);
> +		flag = TTY_NORMAL;
> +		port->icount.rx++;
> +
> +		if (lsr & (SPRD_LSR_BI | SPRD_LSR_PE
> +			| SPRD_LSR_FE | SPRD_LSR_OE))

operators should trail on the previous line, like

		if (lsr & (SPRD_LSR_BI | SPRD_LSR_PE |
			   SPRD_LSR_FE | SPRD_LSR_OE))


> +			if (handle_lsr_errors(port, &lsr, &flag))
> +				continue;
> +		if (uart_handle_sysrq_char(port, ch))
> +			continue;
> +
> +		uart_insert_char(port, lsr, SPRD_LSR_OE, ch, flag);
> +	}
> +
> +	tty_flip_buffer_push(tty);
> +}
> +
> +static inline void sprd_tx(int irq, void *dev_id)
                                       ^^^^^^^^^^^^^
                                       struct uart_port *port

The 'irq' parameter is unused, remove it.
Don't declare inline.

> +{
> +	struct uart_port *port = dev_id;
         ^^^^^^^^^
delete this line.

> +	struct circ_buf *xmit = &port->state->xmit;
> +	int count;
> +
> +	if (port->x_char) {
> +		serial_out(port, SPRD_TXD, port->x_char);
> +		port->icount.tx++;
> +		port->x_char = 0;
> +		return;
> +	}
> +
> +	if (uart_circ_empty(xmit) || uart_tx_stopped(port)) {
> +		sprd_stop_tx(port);
> +		return;
> +	}
> +
> +	count = THLD_TX_EMPTY;
> +	do {
> +		serial_out(port, SPRD_TXD, xmit->buf[xmit->tail]);
> +		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
> +		port->icount.tx++;
> +		if (uart_circ_empty(xmit))
> +			break;
> +	} while (--count > 0);
> +
> +	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
> +		uart_write_wakeup(port);
> +
> +	if (uart_circ_empty(xmit))
> +		sprd_stop_tx(port);
> +}
> +
> +/* this handles the interrupt from one port */
> +static irqreturn_t sprd_handle_irq(int irq, void *dev_id)
> +{
> +	struct uart_port *port = (struct uart_port *)dev_id;
                                    ^^^^^^^^^^^
Don't need the type cast.

> +	unsigned int ims;
> +
> +	spin_lock(&port->lock);
> +
> +	ims = serial_in(port, SPRD_IMSR);
> +
> +	if (!ims)
> +		return IRQ_NONE;
> +
> +	serial_out(port, SPRD_ICLR, ~0);
> +
> +	if (ims & (SPRD_IMSR_RX_FIFO_FULL |
> +		SPRD_IMSR_BREAK_DETECT | SPRD_IMSR_TIMEOUT))
> +		sprd_rx(irq, port);
> +
> +	if (ims & SPRD_IMSR_TX_FIFO_EMPTY)
> +		sprd_tx(irq, port);
> +
> +	spin_unlock(&port->lock);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int sprd_startup(struct uart_port *port)
> +{
> +	int ret = 0;
> +	unsigned int ien, ctrl1;
> +	unsigned int timeout;
> +	struct sprd_uart_port *sp;

	unsigned long flags;

> +
> +	serial_out(port, SPRD_CTL2, ((THLD_TX_EMPTY << 8) | THLD_RX_FULL));
> +
> +	/* clear rx fifo */
> +	timeout = SPRD_TIMEOUT;
> +	while (timeout-- && serial_in(port, SPRD_STS1) & 0x00ff)
> +		serial_in(port, SPRD_RXD);
> +
> +	/* clear tx fifo */
> +	timeout = SPRD_TIMEOUT;
> +	while (timeout-- && serial_in(port, SPRD_STS1) & 0xff00)
> +		cpu_relax();
> +
> +	/* clear interrupt */
> +	serial_out(port, SPRD_IEN, 0x0);
                                   ^^^
                                 just 0

> +	serial_out(port, SPRD_ICLR, ~0);
> +
> +	/* allocate irq */
> +	sp = container_of(port, struct sprd_uart_port, port);
> +	snprintf(sp->name, sizeof(sp->name), "sprd_serial%d", port->line);
> +	ret = devm_request_irq(port->dev, port->irq, sprd_handle_irq,
> +				IRQF_SHARED, sp->name, port);
> +	if (ret) {
> +		dev_err(port->dev, "fail to request serial irq %d, ret=%d\n",
> +			port->irq, ret);
> +		return ret;
> +	}
> +	ctrl1 = serial_in(port, SPRD_CTL1);
> +	ctrl1 |= 0x3e00 | THLD_RX_FULL;
                 ^^^^^
What is this magic number?

> +	serial_out(port, SPRD_CTL1, ctrl1);
> +
> +	/* enable interrupt */
> +	spin_lock(&port->lock);

	spin_lock_irqsave(&port->lock, flags);

> +	ien = serial_in(port, SPRD_IEN);
> +	ien |= SPRD_IEN_RX_FULL | SPRD_IEN_BREAK_DETECT | SPRD_IEN_TIMEOUT;
> +	serial_out(port, SPRD_IEN, ien);
> +	spin_unlock(&port->lock);

	spin_unlock_irqrestore(&port->lock, flags);

> +
> +	return 0;
> +}
> +
> +static void sprd_shutdown(struct uart_port *port)
> +{
> +	serial_out(port, SPRD_IEN, 0x0);
                                   ^^^
                                 just 0

> +	serial_out(port, SPRD_ICLR, ~0);
> +	devm_free_irq(port->dev, port->irq, port);
> +}
> +
> +static void sprd_set_termios(struct uart_port *port,
> +				    struct ktermios *termios,
> +				    struct ktermios *old)
> +{
> +	unsigned int baud, quot;
> +	unsigned int lcr, fc;
> +	unsigned long flags;
> +
> +	/* ask the core to calculate the divisor for us */
> +	baud = uart_get_baud_rate(port, termios, old, 1200, 3000000);
                                                      ^^^^   ^^^^^^
                                           mabye derive these from uartclk?

> +
> +	quot = (unsigned int)((port->uartclk + baud / 2) / baud);
> +
> +	/* set data length */
> +	lcr = serial_in(port, SPRD_LCR);
> +	lcr &= ~SPRD_LCR_DATA_LEN;

What bits are being preserved in SPRD_LCR that you need to read the
current value? IOW, why can't SPRD_LCR be defined only by the termios
c_cflag? Like,

	lcr = 0;

> +	switch (termios->c_cflag & CSIZE) {
> +	case CS5:
> +		lcr |= SPRD_LCR_DATA_LEN5;
> +		break;
> +	case CS6:
> +		lcr |= SPRD_LCR_DATA_LEN6;
> +		break;
> +	case CS7:
> +		lcr |= SPRD_LCR_DATA_LEN7;
> +		break;
> +	case CS8:
> +	default:
> +		lcr |= SPRD_LCR_DATA_LEN8;
> +		break;
> +	}
> +
> +	/* calculate stop bits */
> +	lcr &= ~(SPRD_LCR_STOP_1BIT | SPRD_LCR_STOP_2BIT);
> +	if (termios->c_cflag & CSTOPB)
> +		lcr |= SPRD_LCR_STOP_2BIT;
> +	else
> +		lcr |= SPRD_LCR_STOP_1BIT;
> +
> +	/* calculate parity */
> +	lcr &= ~SPRD_LCR_PARITY;
> +	termios->c_cflag &= ~CMSPAR;	/* no support mark/space */
> +	if (termios->c_cflag & PARENB) {
> +		lcr |= SPRD_LCR_PARITY_EN;
> +		if (termios->c_cflag & PARODD)
> +			lcr |= SPRD_LCR_ODD_PAR;
> +		else
> +			lcr |= SPRD_LCR_EVEN_PAR;
> +	}
> +
> +	spin_lock_irqsave(&port->lock, flags);
> +
> +	/* update the per-port timeout */
> +	uart_update_timeout(port, termios->c_cflag, baud);
> +
> +	port->read_status_mask = SPRD_LSR_OE;
> +	if (termios->c_iflag & INPCK)
> +		port->read_status_mask |= SPRD_LSR_FE | SPRD_LSR_PE;
> +	if (termios->c_iflag & (BRKINT | PARMRK))

	if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))

Because if IGNBRK is set and a BRK is received, sprd_rx() should operate
like this:
	                                         /*    - RESULT -     */
	lsr = serial_in(SPRD_LSR)                /* lsr = SPRD_LSR_BI */
        ch  = serial_in(SPRD_RXD)                /* ch  = 0           */

	lsr & SPRD_LSR_BI ?  yes
        handle_lsr_errors(lsr, flag)

            lsr &= read_status_mask              /* lsr = SPRD_LSR_BI */
            flag = TTY_BREAK

        uart_insert_char(lsr, ch, flag)
	    lsr & ignore_status_mask == 0? no    /* ch _not_ inserted */


> +		port->read_status_mask |= SPRD_LSR_BI;
> +
> +	/* characters to ignore */
> +	port->ignore_status_mask = 0;
> +	if (termios->c_iflag & IGNPAR)
> +		port->ignore_status_mask |= SPRD_LSR_PE | SPRD_LSR_FE;
> +	if (termios->c_iflag & IGNBRK) {
> +		port->ignore_status_mask |= SPRD_LSR_BI;
> +		/*
> +		 * If we're ignoring parity and break indicators,
> +		 * ignore overruns too (for real raw support).
> +		 */
> +		if (termios->c_iflag & IGNPAR)
> +			port->ignore_status_mask |= SPRD_LSR_OE;
> +	}
> +
> +	/* flow control */
> +	fc = serial_in(port, SPRD_CTL1);
> +	fc &= ~(RX_HW_FLOW_CTL_THLD | RX_HW_FLOW_CTL_EN | TX_HW_FLOW_CTL_EN);
> +	if (termios->c_cflag & CRTSCTS) {
> +		fc |= RX_HW_FLOW_CTL_THLD;
> +		fc |= RX_HW_FLOW_CTL_EN;
> +		fc |= TX_HW_FLOW_CTL_EN;
> +	}
> +
> +	/* clock divider bit0~bit15 */
> +	serial_out(port, SPRD_CLKD0, quot & 0xffff);
> +
> +	/* clock divider bit16~bit20 */
> +	serial_out(port, SPRD_CLKD1, (quot & 0x1f0000) >> 16);
> +	serial_out(port, SPRD_LCR, lcr);
> +	fc |= 0x3e00 | THLD_RX_FULL;
> +	serial_out(port, SPRD_CTL1, fc);
> +
> +	spin_unlock_irqrestore(&port->lock, flags);
> +
> +	/* Don't rewrite B0 */
> +	if (tty_termios_baud_rate(termios))
> +		tty_termios_encode_baud_rate(termios, baud, baud);
> +}
> +
> +static const char *sprd_type(struct uart_port *port)
> +{
> +	return "SPX";
> +}
> +
> +static void sprd_release_port(struct uart_port *port)
> +{
> +	/* nothing to do */
> +}
> +
> +static int sprd_request_port(struct uart_port *port)
> +{
> +	return 0;
> +}
> +
> +static void sprd_config_port(struct uart_port *port, int flags)
> +{
> +	if (flags & UART_CONFIG_TYPE)
> +		port->type = PORT_SPRD;
> +}
> +
> +static int sprd_verify_port(struct uart_port *port,
> +				   struct serial_struct *ser)
> +{
> +	if (ser->type != PORT_SPRD)
> +		return -EINVAL;
> +	if (port->irq != ser->irq)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static struct uart_ops serial_sprd_ops = {
> +	.tx_empty = sprd_tx_empty,
> +	.get_mctrl = sprd_get_mctrl,
> +	.set_mctrl = sprd_set_mctrl,
> +	.stop_tx = sprd_stop_tx,
> +	.start_tx = sprd_start_tx,
> +	.stop_rx = sprd_stop_rx,
> +	.break_ctl = sprd_break_ctl,
> +	.startup = sprd_startup,
> +	.shutdown = sprd_shutdown,
> +	.set_termios = sprd_set_termios,
> +	.type = sprd_type,
> +	.release_port = sprd_release_port,
> +	.request_port = sprd_request_port,
> +	.config_port = sprd_config_port,
> +	.verify_port = sprd_verify_port,
> +};
> +
> +#ifdef CONFIG_SERIAL_SPRD_CONSOLE
> +static inline void wait_for_xmitr(struct uart_port *port)
> +{
> +	unsigned int status, tmout = 10000;
> +
> +	/* wait up to 10ms for the character(s) to be sent */
> +	do {
> +		status = serial_in(port, SPRD_STS1);
> +		if (--tmout == 0)
> +			break;
> +		udelay(1);
> +	} while (status & 0xff00);
> +}
> +
> +static void sprd_console_putchar(struct uart_port *port, int ch)
> +{
> +	wait_for_xmitr(port);
> +	serial_out(port, SPRD_TXD, ch);
> +}
> +
> +static void sprd_console_write(struct console *co, const char *s,
> +				      unsigned int count)
> +{
> +	struct uart_port *port = &sprd_port[co->index]->port;
> +	int locked = 1;
> +	unsigned long flags;
> +
> +	if (oops_in_progress)
> +		locked = spin_trylock(&port->lock);

	if (port->sysrq)
		locked = 0;
	else if (oops_in_progress)
		locked = spin_trylock_irqsave(&port->lock, flags);

> +	else
> +		spin_lock_irqsave(&port->lock, flags);
> +
> +	uart_console_write(port, s, count, sprd_console_putchar);
> +
> +	/* wait for transmitter to become empty */
> +	wait_for_xmitr(port);
> +
> +	if (locked)
> +		spin_unlock_irqrestore(&port->lock, flags);
> +}
> +
> +static int __init sprd_console_setup(struct console *co, char *options)
> +{
> +	struct uart_port *port;
> +	int baud = 115200;
> +	int bits = 8;
> +	int parity = 'n';
> +	int flow = 'n';
> +
> +	if (co->index >= UART_NR_MAX || co->index < 0)
> +		co->index = 0;
> +
> +	port = &sprd_port[co->index]->port;
> +	if (port == NULL) {
> +		pr_info("serial port %d not yet initialized\n", co->index);
> +		return -ENODEV;
> +	}
> +	if (options)
> +		uart_parse_options(options, &baud, &parity, &bits, &flow);
> +
> +	return uart_set_options(port, co, baud, parity, bits, flow);
> +}
> +
> +static struct uart_driver sprd_uart_driver;
> +static struct console sprd_console = {
> +	.name = SPRD_TTY_NAME,
> +	.write = sprd_console_write,
> +	.device = uart_console_device,
> +	.setup = sprd_console_setup,
> +	.flags = CON_PRINTBUFFER,
> +	.index = -1,
> +	.data = &sprd_uart_driver,
> +};
> +
> +#define SPRD_CONSOLE	(&sprd_console)
> +
> +/* Support for earlycon */
> +static void sprd_putc(struct uart_port *port, int c)
> +{
> +	unsigned int timeout = SPRD_TIMEOUT;
> +
> +	while (timeout-- &&
> +		   !(readl(port->membase + SPRD_LSR) & SPRD_LSR_TX_OVER))
> +		cpu_relax();
> +
> +	writeb(c, port->membase + SPRD_TXD);
> +}
> +
> +static void sprd_early_write(struct console *con, const char *s,
> +				    unsigned n)
> +{
> +	struct earlycon_device *dev = con->data;
> +
> +	uart_console_write(&dev->port, s, n, sprd_putc);
> +}
> +
> +static int __init sprd_early_console_setup(
> +				struct earlycon_device *device,
> +				const char *opt)
> +{
> +	if (!device->port.membase)
> +		return -ENODEV;
> +
> +	device->con->write = sprd_early_write;
> +	return 0;
> +}
> +
> +EARLYCON_DECLARE(sprd_serial, sprd_early_console_setup);
> +OF_EARLYCON_DECLARE(sprd_serial, "sprd,sc9836-uart",
> +		    sprd_early_console_setup);
> +
> +#else /* !CONFIG_SERIAL_SPRD_CONSOLE */
> +#define SPRD_CONSOLE		NULL
> +#endif
> +
> +static struct uart_driver sprd_uart_driver = {
> +	.owner = THIS_MODULE,
> +	.driver_name = "sprd_serial",
> +	.dev_name = SPRD_TTY_NAME,
> +	.major = 0,
> +	.minor = 0,
> +	.nr = UART_NR_MAX,
> +	.cons = SPRD_CONSOLE,
> +};
> +
> +static int sprd_probe_dt_alias(int index, struct device *dev)
> +{
> +	struct device_node *np;
> +	static bool seen_dev_with_alias;
> +	static bool seen_dev_without_alias;
> +	int ret = index;
> +
> +	if (!IS_ENABLED(CONFIG_OF))
> +		return ret;
> +
> +	np = dev->of_node;
> +	if (!np)
> +		return ret;
> +
> +	ret = of_alias_get_id(np, "serial");
> +	if (IS_ERR_VALUE(ret)) {
> +		seen_dev_without_alias = true;
> +		ret = index;
> +	} else {
> +		seen_dev_with_alias = true;
> +		if (ret >= ARRAY_SIZE(sprd_port) || sprd_port[ret] != NULL) {
> +			dev_warn(dev, "requested serial port %d  not available.\n", ret);
> +			ret = index;
> +		}
> +	}
> +
> +	if (seen_dev_with_alias && seen_dev_without_alias)
> +		dev_warn(dev, "aliased and non-aliased serial devices found in device tree. Serial port enumeration may be unpredictable.\n");

Is this necessary? Why does a user want to know this?

> +
> +	return ret;
> +}
> +
> +static int sprd_remove(struct platform_device *dev)
> +{
> +	struct sprd_uart_port *sup = platform_get_drvdata(dev);
> +	bool busy = false;
> +	int i;
> +
> +	if (sup)
> +		uart_remove_one_port(&sprd_uart_driver, &sup->port);

see comment in sprd_probe()

	if (sup) {
		uart_remove_one_port();
		sprd_port[sup->line] = NULL;
		sprd_ports--;
	}

	if (!sprd_ports)
		uart_unregister_driver();

> +
> +	for (i = 0; i < ARRAY_SIZE(sprd_port); i++)
> +		if (sprd_port[i] == sup)
> +			sprd_port[i] = NULL;
> +		else if (sprd_port[i])
> +			busy = true;
> +
> +	if (!busy)
> +		uart_unregister_driver(&sprd_uart_driver);
> +
> +	return 0;
> +}
> +
> +static int sprd_probe(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	struct uart_port *up;
> +	struct clk *clk;
> +	int irq;
> +	int index;
> +	int ret;
> +
> +	for (index = 0; index < ARRAY_SIZE(sprd_port); index++)
> +		if (sprd_port[index] == NULL)
> +			break;
> +
> +	if (index == ARRAY_SIZE(sprd_port))
> +		return -EBUSY;
> +
> +	index = sprd_probe_dt_alias(index, &pdev->dev);
> +
> +	sprd_port[index] = devm_kzalloc(&pdev->dev,
> +		sizeof(*sprd_port[index]), GFP_KERNEL);
> +	if (!sprd_port[index])
> +		return -ENOMEM;
> +
> +	up = &sprd_port[index]->port;
> +	up->dev = &pdev->dev;
> +	up->line = index;
> +	up->type = PORT_SPRD;
> +	up->iotype = SERIAL_IO_PORT;
> +	up->uartclk = SPRD_DEF_RATE;
> +	up->fifosize = SPRD_FIFO_SIZE;
> +	up->ops = &serial_sprd_ops;
> +	up->flags = ASYNC_BOOT_AUTOCONF;
                    ^^^^^^^^^
                    UPF_BOOT_AUTOCONF

sparse will catch errors like this. See Documentation/sparse.txt

> +
> +	clk = devm_clk_get(&pdev->dev, NULL);
> +	if (!IS_ERR(clk))
> +		up->uartclk = clk_get_rate(clk);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "not provide mem resource\n");
> +		return -ENODEV;
> +	}
> +	up->mapbase = res->start;
> +	up->membase = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(up->membase))
> +		return PTR_ERR(up->membase);
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "not provide irq resource\n");
> +		return -ENODEV;
> +	}
> +	up->irq = irq;
> +
> +	if (!sprd_uart_driver.state) {
             ^^^^^^^^^^^^^^^^^^^^^^
I know Rob said this was ok, but it's not.

Just use a global counter.

	if (!sprd_ports) {

> +		ret = uart_register_driver(&sprd_uart_driver);
> +		if (ret < 0) {
> +			pr_err("Failed to register SPRD-UART driver\n");
> +			return ret;
> +		}
> +	}
> +

	sprd_ports++;

> +	ret = uart_add_one_port(&sprd_uart_driver, up);
> +	if (ret) {
> +		sprd_port[index] = NULL;
> +		sprd_remove(pdev);
> +	}
> +
> +	platform_set_drvdata(pdev, up);
> +
> +	return ret;
> +}
> +
> +static int sprd_suspend(struct device *dev)
> +{
> +	int id = to_platform_device(dev)->id;
> +	struct uart_port *port = &sprd_port[id]->port;

I'm a little confused regarding the port indexing;
is platform_device->id == line ?  Where did that happen?


> +
> +	uart_suspend_port(&sprd_uart_driver, port);
> +
> +	return 0;
> +}
> +
> +static int sprd_resume(struct device *dev)
> +{
> +	int id = to_platform_device(dev)->id;
> +	struct uart_port *port = &sprd_port[id]->port;
> +
> +	uart_resume_port(&sprd_uart_driver, port);
> +
> +	return 0;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(sprd_pm_ops, sprd_suspend, sprd_resume);
> +
> +static const struct of_device_id serial_ids[] = {
> +	{.compatible = "sprd,sc9836-uart",},
> +	{}
> +};
> +
> +static struct platform_driver sprd_platform_driver = {
> +	.probe		= sprd_probe,
> +	.remove		= sprd_remove,
> +	.driver		= {
> +		.name	= "sprd_serial",
> +		.of_match_table = of_match_ptr(serial_ids),
> +		.pm	= &sprd_pm_ops,
> +	},
> +};
> +
> +module_platform_driver(sprd_platform_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Spreadtrum SoC serial driver series");
> diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/serial_core.h
> index c172180..7e6eb39 100644
> --- a/include/uapi/linux/serial_core.h
> +++ b/include/uapi/linux/serial_core.h
> @@ -248,4 +248,7 @@
>  /* MESON */
>  #define PORT_MESON	109
>  
> +/* SPRD SERIAL  */
> +#define PORT_SPRD	110
> +
>  #endif /* _UAPILINUX_SERIAL_CORE_H */
> 
