From: Tobias Klauser <tklauser@distanz.ch>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Date: Wed, 26 Nov 2014 10:48:38 +0100
Message-ID: <20141126094838.GB17980@distanz.ch>
References: <Sharkl64-v3>
 <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1416917818-10506-6-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1416917818-10506-6-git-send-email-chunyan.zhang@spreadtrum.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, catalin.marinas@arm.com, gregkh@linuxfoundation.org, ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org, broonie@linaro.org, mark.rutland@arm.com, m-karicheri2@ti.com, pawel.moll@arm.com, artagnon@gmail.com, rrichter@cavium.com, will.deacon@arm.com, arnd@arndb.de, gnomes@lxorguk.ukuu.org.uk, corbet@lwn.net, jason@lakedaemon.net, broonie@kernel.org, heiko@sntech.de, shawn.guo@freescale.com, florian.vaussard@epfl.ch, andrew@lunn.ch, hytszk@gmail.com, orsonzhai@gmail.com, geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com, zhang.lyra@gmail.com, wei.qiao@spreadtrum.com, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, sprdlinux@freelists.org, linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2014-11-25 at 13:16:58 +0100, Chunyan Zhang <chunyan.zhang@spreadtrum.com> wrote:
> Add a full sc9836-uart driver for SC9836 SoC which is based on the
> spreadtrum sharkl64 platform.
> This driver also support earlycon.
> 
> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
> Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
> Originally-by: Lanqing Liu <lanqing.liu@spreadtrum.com>
> ---
>  Documentation/devices.txt        |    3 +
>  drivers/tty/serial/Kconfig       |   23 ++
>  drivers/tty/serial/Makefile      |    1 +
>  drivers/tty/serial/sprd_serial.c |  752 ++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/serial_core.h |    3 +
>  5 files changed, 782 insertions(+)
>  create mode 100644 drivers/tty/serial/sprd_serial.c
> 
[...]
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -1573,6 +1573,29 @@ config SERIAL_MEN_Z135
>  	  This driver can also be build as a module. If so, the module will be called
>  	  men_z135_uart.ko
>  
> +config SERIAL_SPRD
> +	tristate "Support for SPRD serial"
> +	depends on ARCH_SPRD
> +	select SERIAL_CORE
> +	help
> +          This enables the driver for the Spreadtrum's serial.
> +
> +config SERIAL_SPRD_NR
> +        int "Maximum number of sprd serial ports"
> +        depends on SERIAL_SPRD
> +        default "4"
> +
> +config SERIAL_SPRD_CONSOLE
> +        bool "SPRD UART console support"
> +        depends on SERIAL_SPRD=y
> +        select SERIAL_CORE_CONSOLE
> +	select SERIAL_EARLYCON
> +        help
> +	  Support for early debug console using Spreadtrum's serial. This enables
> +	  the console before standard serial driver is probed. This is enabled
> +	  with "earlycon" on the kernel command line. The console is
> +	  enabled when early_param is processed.
> +
>  endmenu

Please consistently use tabs instead of spaces for indentation. The help
text should be indented by one tabe + 2 spaces.

[...]
> diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
> new file mode 100644
> index 0000000..58214c8
> --- /dev/null
> +++ b/drivers/tty/serial/sprd_serial.c
[...]
> +static inline int handle_lsr_errors(struct uart_port *port,
> +	unsigned int *flag, unsigned int *lsr)

This line should be aligned with the opening ( above.

> +{
> +	int ret = 0;
> +
> +	/* stastics */
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
> +{
> +	struct uart_port *port = (struct uart_port *)dev_id;

No need to cast a void pointer.

> +	struct tty_port *tty = &port->state->port;
> +	unsigned int ch, flag, lsr, max_count = 2048;
> +
> +	while ((serial_in(port, SPRD_STS1) & 0x00ff) && max_count--) {
> +		lsr = serial_in(port, SPRD_LSR);
> +		ch = serial_in(port, SPRD_RXD);
> +		flag = TTY_NORMAL;
> +		port->icount.rx++;
> +
> +		if (unlikely(lsr & (SPRD_LSR_BI | SPRD_LSR_PE
> +				| SPRD_LSR_FE | SPRD_LSR_OE)))
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
[...]
> +static void sprd_console_write(struct console *co, const char *s,
> +				      unsigned int count)
> +{
> +	struct uart_port *port = (struct uart_port *)sprd_port[co->index];

Better explicitly access the .port member of sprd_port[co->index] here
instead of casting.

> +	int ien;
> +	int locked = 1;
> +
> +	if (oops_in_progress)
> +		locked = spin_trylock(&port->lock);
> +	else
> +		spin_lock(&port->lock);
> +	/* save the IEN then disable the interrupts */
> +	ien = serial_in(port, SPRD_IEN);
> +	serial_out(port, SPRD_IEN, 0x0);
> +
> +	uart_console_write(port, s, count, sprd_console_putchar);
> +
> +	/* wait for transmitter to become empty and restore the IEN */
> +	wait_for_xmitr(port);
> +	serial_out(port, SPRD_IEN, ien);
> +	if (locked)
> +		spin_unlock(&port->lock);
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
> +	if (unlikely(co->index >= UART_NR_MAX || co->index < 0))
> +		co->index = 0;
> +
> +	port = (struct uart_port *)sprd_port[co->index];

Same here, use the .port member of struct sprd_port[co->index].

> +	if (port == NULL) {
> +		pr_info("srial port %d not yet initialized\n", co->index);

Typo: should be serial instead of srial.

> +		return -ENODEV;
> +	}
> +	if (options)
> +		uart_parse_options(options, &baud, &parity, &bits, &flow);
> +
> +	return uart_set_options(port, co, baud, parity, bits, flow);
> +}
[...]
> +static int sprd_probe(struct platform_device *pdev)
> +{
> +	struct resource *mem;
> +	struct device_node *np = pdev->dev.of_node;
> +	struct uart_port *up;
> +	struct clk *clk;
> +	int irq;
> +
> +
> +	if (np)
> +		pdev->id = of_alias_get_id(np, "serial");
> +
> +	if (unlikely(pdev->id < 0 || pdev->id >= UART_NR_MAX)) {
> +		dev_err(&pdev->dev, "does not support id %d\n", pdev->id);
> +		return -ENXIO;
> +	}
> +
> +	sprd_port[pdev->id] = devm_kzalloc(&pdev->dev,
> +		sizeof(*sprd_port[pdev->id]), GFP_KERNEL);
> +	if (!sprd_port[pdev->id])
> +		return -ENOMEM;
> +
> +	up = (struct uart_port *)sprd_port[pdev->id];
> +	up->dev = &pdev->dev;
> +	up->line = pdev->id;
> +	up->type = PORT_SPRD;
> +	up->iotype = SERIAL_IO_PORT;
> +	up->uartclk = SPRD_DEF_RATE;
> +	up->fifosize = SPRD_FIFO_SIZE;
> +	up->ops = &serial_sprd_ops;
> +	up->flags = ASYNC_BOOT_AUTOCONF;
> +
> +	clk = devm_clk_get(&pdev->dev, NULL);
> +	if (!IS_ERR(clk))
> +		up->uartclk = clk_get_rate(clk);
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (unlikely(!mem)) {
> +		dev_err(&pdev->dev, "not provide mem resource\n");
> +		return -ENODEV;
> +	}
> +	up->mapbase = mem->start;
> +	up->membase = ioremap(mem->start, resource_size(mem));

Return value of ioremap() should be checked for NULL.

> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (unlikely(irq < 0)) {
> +		dev_err(&pdev->dev, "not provide irq resource\n");
> +		return -ENODEV;
> +	}
> +	up->irq = irq;
> +
> +	platform_set_drvdata(pdev, up);
> +
> +	return uart_add_one_port(&sprd_uart_driver, up);
> +}
> +
> +static int sprd_remove(struct platform_device *dev)
> +{
> +	struct uart_port *up = platform_get_drvdata(dev);
> +
> +	return uart_remove_one_port(&sprd_uart_driver, up);
> +}
> +
> +static int sprd_suspend(struct platform_device *dev, pm_message_t state)
> +{
> +	int id = dev->id;
> +	struct uart_port *port = (struct uart_port *)sprd_port[id];
> +	struct reg_backup *reg_bak = &(sprd_port[id]->reg_bak);
> +
> +	reg_bak->ien = serial_in(port, SPRD_IEN);
> +	reg_bak->ctrl0 = serial_in(port, SPRD_LCR);
> +	reg_bak->ctrl1 = serial_in(port, SPRD_CTL1);
> +	reg_bak->ctrl2 = serial_in(port, SPRD_CTL2);
> +	reg_bak->clkd0 = serial_in(port, SPRD_CLKD0);
> +	reg_bak->clkd1 = serial_in(port, SPRD_CLKD1);
> +
> +	return 0;
> +}
> +
> +static int sprd_resume(struct platform_device *dev)
> +{
> +	int id = dev->id;
> +	struct uart_port *port = (struct uart_port *)sprd_port[id];

Access the .port member instead of the cast.

> +	struct reg_backup *reg_bak = &(sprd_port[id]->reg_bak);
> +
> +	serial_out(port, SPRD_LCR, reg_bak->ctrl0);
> +	serial_out(port, SPRD_CTL1, reg_bak->ctrl1);
> +	serial_out(port, SPRD_CTL2, reg_bak->ctrl2);
> +	serial_out(port, SPRD_CLKD0, reg_bak->clkd0);
> +	serial_out(port, SPRD_CLKD1, reg_bak->clkd1);
> +	serial_out(port, SPRD_IEN, reg_bak->ien);
> +
> +	return 0;
> +}
