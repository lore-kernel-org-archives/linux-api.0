From: Varka Bhadram <varkabhadram-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v10 2/2] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Date: Thu, 29 Jan 2015 21:02:41 +0530
Message-ID: <54CA5299.6050304@gmail.com>
References: <sc9836-serial-v10> <1422443324-25082-1-git-send-email-chunyan.zhang@spreadtrum.com> <1422443324-25082-3-git-send-email-chunyan.zhang@spreadtrum.com> <54CA5128.8050500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54CA5128.8050500-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, florian.vaussard-p8DiymsW2f8@public.gmane.org, andrew-g2DYL2Zd6BY@public.gmane.org, hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shawn.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, orsonzhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, geng.ren-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, zhizhou.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, lanqing.liu-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, wei.qiao-lxIno14LUO0EEoCn2XhGlw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thursday 29 January 2015 08:56 PM, Varka Bhadram wrote:
> Hi,
>
> On Wednesday 28 January 2015 04:38 PM, Chunyan Zhang wrote:
>> Add a full sc9836-uart driver for SC9836 SoC which is based on the
>> spreadtrum sharkl64 platform.
>> This driver also support earlycon.
>>
>> Originally-by: Lanqing Liu <lanqing.liu-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
>> Signed-off-by: Orson Zhai <orson.zhai-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
>> Signed-off-by: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
>> Acked-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
>> Reviewed-by: Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
>> ---
>>   drivers/tty/serial/Kconfig       |   18 +
>>   drivers/tty/serial/Makefile      |    1 +
>>   drivers/tty/serial/sprd_serial.c |  793 
>> ++++++++++++++++++++++++++++++++++++++
>>   include/uapi/linux/serial_core.h |    3 +
>>   4 files changed, 815 insertions(+)
>>   create mode 100644 drivers/tty/serial/sprd_serial.c
>>
> (...)
>
>> +static int sprd_probe(struct platform_device *pdev)
>> +{
>> +    struct resource *res;
>> +    struct uart_port *up;
>> +    struct clk *clk;
>> +    int irq;
>> +    int index;
>> +    int ret;
>> +
>> +    for (index = 0; index < ARRAY_SIZE(sprd_port); index++)
>> +        if (sprd_port[index] == NULL)
>> +            break;
>> +
>> +    if (index == ARRAY_SIZE(sprd_port))
>> +        return -EBUSY;
>> +
>> +    index = sprd_probe_dt_alias(index, &pdev->dev);
>> +
>> +    sprd_port[index] = devm_kzalloc(&pdev->dev,
>> +        sizeof(*sprd_port[index]), GFP_KERNEL);
>> +    if (!sprd_port[index])
>> +        return -ENOMEM;
>> +
>> +    up = &sprd_port[index]->port;
>> +    up->dev = &pdev->dev;
>> +    up->line = index;
>> +    up->type = PORT_SPRD;
>> +    up->iotype = SERIAL_IO_PORT;
>> +    up->uartclk = SPRD_DEF_RATE;
>> +    up->fifosize = SPRD_FIFO_SIZE;
>> +    up->ops = &serial_sprd_ops;
>> +    up->flags = UPF_BOOT_AUTOCONF;
>> +
>> +    clk = devm_clk_get(&pdev->dev, NULL);
>> +    if (!IS_ERR(clk))
>> +        up->uartclk = clk_get_rate(clk);
>> +
>> +    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +    if (!res) {
>> +        dev_err(&pdev->dev, "not provide mem resource\n");
>> +        return -ENODEV;
>> +    }
>
> This check is not required. It will be done by devm_ioremap_resource()
>
>> +    up->mapbase = res->start;

Accessing of 'res' has to be done after devm_ioremap_resource()

>> +    up->membase = devm_ioremap_resource(&pdev->dev, res);
>> +    if (IS_ERR(up->membase))
>> +        return PTR_ERR(up->membase);
>> +
>>
>

-- 
Thanks,
Varka Bhadram.
