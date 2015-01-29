From: Varka Bhadram <varkabhadram@gmail.com>
Subject: Re: [PATCH v10 2/2] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Date: Thu, 29 Jan 2015 20:56:32 +0530
Message-ID: <54CA5128.8050500@gmail.com>
References: <sc9836-serial-v10> <1422443324-25082-1-git-send-email-chunyan.zhang@spreadtrum.com> <1422443324-25082-3-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1422443324-25082-3-git-send-email-chunyan.zhang@spreadtrum.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>, gregkh@linuxfoundation.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, arnd@arndb.de, gnomes@lxorguk.ukuu.org.uk, peter@hurleysoftware.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, grant.likely@linaro.org, jslaby@suse.cz, heiko@sntech.de, jason@lakedaemon.net, florian.vaussard@epfl.ch, andrew@lunn.ch, hytszk@gmail.com, antonynpavlov@gmail.com, shawn.guo@linaro.org, orsonzhai@gmail.com, geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com, zhang.lyra@gmail.com, wei.qiao@spreadtrum.com, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Hi,

On Wednesday 28 January 2015 04:38 PM, Chunyan Zhang wrote:
> Add a full sc9836-uart driver for SC9836 SoC which is based on the
> spreadtrum sharkl64 platform.
> This driver also support earlycon.
>
> Originally-by: Lanqing Liu <lanqing.liu@spreadtrum.com>
> Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>   drivers/tty/serial/Kconfig       |   18 +
>   drivers/tty/serial/Makefile      |    1 +
>   drivers/tty/serial/sprd_serial.c |  793 ++++++++++++++++++++++++++++++++++++++
>   include/uapi/linux/serial_core.h |    3 +
>   4 files changed, 815 insertions(+)
>   create mode 100644 drivers/tty/serial/sprd_serial.c
>
(...)

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

This check is not required. It will be done by devm_ioremap_resource()

> +	up->mapbase = res->start;
> +	up->membase = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(up->membase))
> +		return PTR_ERR(up->membase);
> +
>

-- 
Thanks,
Varka Bhadram.
