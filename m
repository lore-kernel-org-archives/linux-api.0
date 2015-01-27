From: Lyra Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH v8 2/2] tty/serial: Add Spreadtrum sc9836-uart driver support
Date: Tue, 27 Jan 2015 23:51:55 +0800
Message-ID: <CAAfSe-v3jnR7O0KFp-c_fBer6KyPbLZ-HS8c+Lsf4uA1-TXXtA@mail.gmail.com>
References: <1422345407-10037-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1422345407-10037-3-git-send-email-chunyan.zhang@spreadtrum.com>
	<54C7A514.6090206@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54C7A514.6090206@hurleysoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Hurley <peter@hurleysoftware.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>, "robh+dt@kernel.org" <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>, "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>, Pawel Moll <pawel.moll@arm.com>, "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Grant Likely <grant.likely@linaro.org>, "jslaby@suse.cz" <jslaby@suse.cz>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, "jason@lakedaemon.net" <jason@lakedaemon.net>, "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>, "andrew@lunn.ch" <andrew@lunn.ch>, Hayato Suzuki <hytszk@gmail.com>, "antonynpavlov@gmail.com" <antonynpavlov@gmail.com>, Shawn Guo <shawn.guo@linaro.org>, Orson Zhai <orsonzhai@gmail.com>, "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>, "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>, lanqing.
List-Id: linux-api@vger.kernel.org

On Tue, Jan 27, 2015 at 10:47 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> Hi Chunyan,
>
> Minor but important fixes below.
>
> And for the v9 version, please only use "To:" for
> "Greg Kroah-Hartman <gregkh@linuxfoundation.org>"
>

Ok, thank you, I'll address your comments below and send the v9 to Greg.

Greg,
sorry, I'll send you a updated version tomorrow.

> All other recipients should only be Cc:
>
> Regards,
> Peter Hurley
>
>
> On 01/27/2015 02:56 AM, Chunyan Zhang wrote:
>> Add a full sc9836-uart driver for SC9836 SoC which is based on the
>> spreadtrum sharkl64 platform.
>> This driver also support earlycon.
>
> [...]
>
>> +static int sprd_probe_dt_alias(int index, struct device *dev)
>> +{
>> +     struct device_node *np;
>> +     static bool seen_dev_with_alias;
>> +     static bool seen_dev_without_alias;
>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> delete these two lines; these were used for the message deleted in a
> previous patch version.
>
>> +     int ret = index;
>> +
>> +     if (!IS_ENABLED(CONFIG_OF))
>> +             return ret;
>> +
>> +     np = dev->of_node;
>> +     if (!np)
>> +             return ret;
>> +
>> +     ret = of_alias_get_id(np, "serial");
>> +     if (IS_ERR_VALUE(ret)) {
>> +             seen_dev_without_alias = true;
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> delete this line.
>
>> +             ret = index;
>> +     } else {
>> +             seen_dev_with_alias = true;
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> delete this line.
>
>> +             if (ret >= ARRAY_SIZE(sprd_port) || sprd_port[ret] != NULL) {
>> +                     dev_warn(dev, "requested serial port %d  not available.\n", ret);
>> +                     ret = index;
>> +             }
>> +     }
>
> Simplify the entire "if (IS_ERR_VALUE(ret))" statement to:
>
>         if (IS_ERR_VALUE(ret))
>                 ret = index;
>         else if (ret >= ..................) {
>                 dev_warn(.....);
>                 ret = index;
>         }
>
>
>> +
>> +     return ret;
>> +}
>> +
>> +static int sprd_remove(struct platform_device *dev)
>> +{
>> +     struct sprd_uart_port *sup = platform_get_drvdata(dev);
>> +
>> +     if (sup) {
>> +             uart_remove_one_port(&sprd_uart_driver, &sup->port);
>> +             sprd_port[sup->port.line] = NULL;
>> +             sprd_ports_num--;
>> +     }
>> +
>> +     if (!sprd_ports_num)
>> +             uart_unregister_driver(&sprd_uart_driver);
>> +
>> +     return 0;
>> +}
>> +
>> +static int sprd_probe(struct platform_device *pdev)
>> +{
>> +     struct resource *res;
>> +     struct uart_port *up;
>> +     struct clk *clk;
>> +     int irq;
>> +     int index;
>> +     int ret;
>> +
>> +     for (index = 0; index < ARRAY_SIZE(sprd_port); index++)
>> +             if (sprd_port[index] == NULL)
>> +                     break;
>> +
>> +     if (index == ARRAY_SIZE(sprd_port))
>> +             return -EBUSY;
>> +
>> +     index = sprd_probe_dt_alias(index, &pdev->dev);
>> +
>> +     sprd_port[index] = devm_kzalloc(&pdev->dev,
>> +             sizeof(*sprd_port[index]), GFP_KERNEL);
>> +     if (!sprd_port[index])
>> +             return -ENOMEM;
>> +
>> +     pdev->id = index;
>         ^^^^^^^^^^^^^^^^
> delete this line.
>
> The platform device id cannot be assigned by the driver.
> (This was left over from trying to fix sprd_suspend/sprd_resume
> but that's fixed correctly now.)
>
>> +
>> +     up = &sprd_port[index]->port;
>> +     up->dev = &pdev->dev;
>> +     up->line = index;
>> +     up->type = PORT_SPRD;
>> +     up->iotype = SERIAL_IO_PORT;
>> +     up->uartclk = SPRD_DEF_RATE;
>> +     up->fifosize = SPRD_FIFO_SIZE;
>> +     up->ops = &serial_sprd_ops;
>> +     up->flags = UPF_BOOT_AUTOCONF;
>> +
>> +     clk = devm_clk_get(&pdev->dev, NULL);
>> +     if (!IS_ERR(clk))
>> +             up->uartclk = clk_get_rate(clk);
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     if (!res) {
>> +             dev_err(&pdev->dev, "not provide mem resource\n");
>> +             return -ENODEV;
>> +     }
>> +     up->mapbase = res->start;
>> +     up->membase = devm_ioremap_resource(&pdev->dev, res);
>> +     if (IS_ERR(up->membase))
>> +             return PTR_ERR(up->membase);
>> +
>> +     irq = platform_get_irq(pdev, 0);
>> +     if (irq < 0) {
>> +             dev_err(&pdev->dev, "not provide irq resource\n");
>> +             return -ENODEV;
>> +     }
>> +     up->irq = irq;
>> +
>> +     if (!sprd_ports_num) {
>> +             ret = uart_register_driver(&sprd_uart_driver);
>> +             if (ret < 0) {
>> +                     pr_err("Failed to register SPRD-UART driver\n");
>> +                     return ret;
>> +             }
>> +     }
>> +     sprd_ports_num++;
>> +
>> +     ret = uart_add_one_port(&sprd_uart_driver, up);
>> +     if (ret) {
>> +             sprd_port[index] = NULL;
>> +             sprd_remove(pdev);
>> +     }
>> +
>> +     platform_set_drvdata(pdev, up);
>> +
>> +     return ret;
>> +}
>
