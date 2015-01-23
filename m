From: Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v7 2/2] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Date: Fri, 23 Jan 2015 08:31:37 -0500
Message-ID: <54C24D39.1080607@hurleysoftware.com>
References: <sprd-serial-v7> <1422018066-24997-1-git-send-email-chunyan.zhang@spreadtrum.com> <1422018066-24997-3-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422018066-24997-3-git-send-email-chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: jslaby-AlSwsSmVLrQ@public.gmane.org, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, florian.vaussard-p8DiymsW2f8@public.gmane.org, andrew-g2DYL2Zd6BY@public.gmane.org, hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shawn.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, orsonzhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, geng.ren-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, zhizhou.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, lanqing.liu-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, wei.qiao-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Chunyan,

Just the minor fix to zeroing the stack local in sprd_set_termios()
and using dev_get_drvdata() in sprd_suspend()/sprd_resume().

Regards,
Peter Hurley

On 01/23/2015 08:01 AM, Chunyan Zhang wrote:
> Add a full sc9836-uart driver for SC9836 SoC which is based on the
> spreadtrum sharkl64 platform.
> This driver also support earlycon.

[...]

> +static void sprd_set_termios(struct uart_port *port,
> +				    struct ktermios *termios,
> +				    struct ktermios *old)
> +{
> +	unsigned int baud, quot;
> +	unsigned int lcr, fc;

	unsigned int lcr = 0, fc;

> +	unsigned long flags;
> +
> +	/* ask the core to calculate the divisor for us */
> +	baud = uart_get_baud_rate(port, termios, old, 0, SPRD_BAUD_IO_LIMIT);
> +
> +	quot = (unsigned int)((port->uartclk + baud / 2) / baud);
> +
> +	/* set data length */
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

[...]

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
> +	pdev->id = index;

see my recent reply regarding this and sprd_suspend/sprd_resume.

> +
> +	up = &sprd_port[index]->port;
> +	up->dev = &pdev->dev;
> +	up->line = index;
> +	up->type = PORT_SPRD;
> +	up->iotype = SERIAL_IO_PORT;
> +	up->uartclk = SPRD_DEF_RATE;
> +	up->fifosize = SPRD_FIFO_SIZE;
> +	up->ops = &serial_sprd_ops;
> +	up->flags = UPF_BOOT_AUTOCONF;
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
> +	if (!sprd_ports_num) {
> +		ret = uart_register_driver(&sprd_uart_driver);
> +		if (ret < 0) {
> +			pr_err("Failed to register SPRD-UART driver\n");
> +			return ret;
> +		}
> +	}
> +	sprd_ports_num++;
> +
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
> +
> +	uart_suspend_port(&sprd_uart_driver, port);

same comment: see my recent reply using dev_get_drvdata().

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


--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
