From: Lyra Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver support
Date: Thu, 27 Nov 2014 19:05:05 +0800
Message-ID: <CAAfSe-uToEA0duiuQJWSTAOwnmcuz5npKKE+e3_FXxq6p98GsQ@mail.gmail.com>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1416917818-10506-6-git-send-email-chunyan.zhang@spreadtrum.com>
	<20141125200353.GA7653@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20141125200353.GA7653@kroah.com>
Sender: linux-doc-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>, Grant Likely <grant.likely@linaro.org>, "robh+dt@kernel.org" <robh+dt@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>, "jslaby@suse.cz" <jslaby@suse.cz>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@linaro.org>, Mark Rutland <mark.rutland@arm.com>, "m-karicheri2@ti.com" <m-karicheri2@ti.com>, Pawel Moll <pawel.moll@arm.com>, Ramkumar Ramachandra <artagnon@gmail.com>, "rrichter@cavium.com" <rrichter@cavium.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, gnomes@lxorguk.ukuu.org.uk, Jonathan Corbet <corbet@lwn.net>, jason@lakedaemon.net, Mark Brown <broonie@kernel.org>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, shawn.guo@freescale.com, florian.vaussard@epfl.ch, andrew@lunn.ch, Hayato Suzuki <hytszk@gmail.com>
List-Id: linux-api@vger.kernel.org

2014-11-26 4:03 GMT+08:00 Greg KH <gregkh@linuxfoundation.org>:
> On Tue, Nov 25, 2014 at 08:16:58PM +0800, Chunyan Zhang wrote:
>> Add a full sc9836-uart driver for SC9836 SoC which is based on the
>> spreadtrum sharkl64 platform.
>> This driver also support earlycon.
>>
>> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
>> Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
>> Originally-by: Lanqing Liu <lanqing.liu@spreadtrum.com>
>
> Some objections:
>
>> +static struct platform_driver sprd_platform_driver = {
>> +     .probe = sprd_probe,
>> +     .remove = sprd_remove,
>> +     .suspend = sprd_suspend,
>> +     .resume = sprd_resume,
>> +     .driver = {
>> +                .name = "sprd_serial",
>> +                .owner = THIS_MODULE,
>
> platform drivers don't need .owner in them anymore, it's handled by the
> driver core automatically.
>
OK, will remove it in v4.
>
>> +                .of_match_table = of_match_ptr(serial_ids),
>> +                },
>> +};
>> +
>> +static int __init sprd_serial_init(void)
>> +{
>> +     int ret = 0;
>> +
>> +     ret = uart_register_driver(&sprd_uart_driver);
>> +     if (unlikely(ret != 0))
>> +             return ret;
>
> NEVER use unlikely unless you can measure the difference without it.
> And even then, you better be able to justify it.  For something as dumb
> as this type of check, youare working against the complier and cpu which
> already knows that 0 is the usual response.
>
> So please remove all usages of likely/unlikely in this patch series.
>
OK, will remove it.
>> +
>> +     ret = platform_driver_register(&sprd_platform_driver);
>> +     if (unlikely(ret != 0))
>> +             uart_unregister_driver(&sprd_uart_driver);
>> +
>> +     return ret;
>> +}
>> +
>> +static void __exit sprd_serial_exit(void)
>> +{
>> +     platform_driver_unregister(&sprd_platform_driver);
>> +     uart_unregister_driver(&sprd_uart_driver);
>> +}
>> +
>> +module_init(sprd_serial_init);
>> +module_exit(sprd_serial_exit);
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_DESCRIPTION("Spreadtrum SoC serial driver series");
>> diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/serial_core.h
>> index 16ad852..d9a8c88 100644
>> --- a/include/uapi/linux/serial_core.h
>> +++ b/include/uapi/linux/serial_core.h
>> @@ -247,4 +247,7 @@
>>  /* MESON */
>>  #define PORT_MESON   109
>>
>> +/* SPRD SERIAL  */
>> +#define PORT_SPRD   110
>
> Please use a tab character here.
OK.


Thanks for your comments!
Chunyan
