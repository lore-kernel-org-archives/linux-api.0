From: Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v8 2/2] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Date: Tue, 27 Jan 2015 09:47:48 -0500
Message-ID: <54C7A514.6090206@hurleysoftware.com>
References: <sc9836-serial-v8> <1422345407-10037-1-git-send-email-chunyan.zhang@spreadtrum.com> <1422345407-10037-3-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422345407-10037-3-git-send-email-chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, florian.vaussard-p8DiymsW2f8@public.gmane.org, andrew-g2DYL2Zd6BY@public.gmane.org, hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shawn.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, orsonzhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, geng.ren-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, zhizhou.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, lanqing.liu-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, wei.qiao-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Chunyan,

Minor but important fixes below.

And for the v9 version, please only use "To:" for
"Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>"

All other recipients should only be Cc:

Regards,
Peter Hurley


On 01/27/2015 02:56 AM, Chunyan Zhang wrote:
> Add a full sc9836-uart driver for SC9836 SoC which is based on the
> spreadtrum sharkl64 platform.
> This driver also support earlycon.

[...]

> +static int sprd_probe_dt_alias(int index, struct device *dev)
> +{
> +	struct device_node *np;
> +	static bool seen_dev_with_alias;
> +	static bool seen_dev_without_alias;
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

delete these two lines; these were used for the message deleted in a
previous patch version.

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
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
delete this line.

> +		ret = index;
> +	} else {
> +		seen_dev_with_alias = true;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^
delete this line.

> +		if (ret >= ARRAY_SIZE(sprd_port) || sprd_port[ret] != NULL) {
> +			dev_warn(dev, "requested serial port %d  not available.\n", ret);
> +			ret = index;
> +		}
> +	}

Simplify the entire "if (IS_ERR_VALUE(ret))" statement to:

	if (IS_ERR_VALUE(ret))
		ret = index;
	else if (ret >= ..................) {
		dev_warn(.....);
		ret = index;
	}


> +
> +	return ret;
> +}
> +
> +static int sprd_remove(struct platform_device *dev)
> +{
> +	struct sprd_uart_port *sup = platform_get_drvdata(dev);
> +
> +	if (sup) {
> +		uart_remove_one_port(&sprd_uart_driver, &sup->port);
> +		sprd_port[sup->port.line] = NULL;
> +		sprd_ports_num--;
> +	}
> +
> +	if (!sprd_ports_num)
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
> +	pdev->id = index;
        ^^^^^^^^^^^^^^^^
delete this line.

The platform device id cannot be assigned by the driver.
(This was left over from trying to fix sprd_suspend/sprd_resume
but that's fixed correctly now.)

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
