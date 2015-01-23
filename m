From: Lyra Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v6 2/2] tty/serial: Add Spreadtrum sc9836-uart driver support
Date: Fri, 23 Jan 2015 21:32:43 +0800
Message-ID: <CAAfSe-vf+3sd6keo21CPbVnu9K6dBpSUUGEMcpbo25V2KPmi7g@mail.gmail.com>
References: <1421933706-4277-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1421933706-4277-3-git-send-email-chunyan.zhang@spreadtrum.com>
	<54C1C69B.6010100@hurleysoftware.com>
	<CAAfSe-s2Y_JSiR+HX4OOF_62q3JYN5k81JZuNe9CP9=shBpZzA@mail.gmail.com>
	<54C248D7.6040901@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54C248D7.6040901-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
Cc: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org" <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Shawn Guo <shawn.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, "ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org" <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "jslaby-AlSwsSmVLrQ@public.gmane.org" <jslaby-AlSwsSmVLrQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, "jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org" <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>, "florian.vaussard-p8DiymsW2f8@public.gmane.org" <florian.vaussard-p8DiymsW2f8@public.gmane.org>, "andrew-g2DYL2Zd6BY@public.gmane.org" <andrew-g2DYL2Zd6BY@public.gmane.org>, Hayato Suzuki <hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Orson Zhai <orsonzhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "geng.ren-lxIno14LUO0EEoCn2XhGlw@public.gmane.org" <geng.ren-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 23, 2015 at 9:12 PM, Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org> wrote:
> On 01/23/2015 02:23 AM, Lyra Zhang wrote:
>> Hi, Peter
>>
>> Many thanks to you for reviewing so carefully and giving us so many
>> suggestions and so clear explanations.
>
> :)
>
>> I'll address all of your comments and send an updated patch soon.
>>
>> On Fri, Jan 23, 2015 at 11:57 AM, Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org> wrote:
>
> [...]
>
>>>> +static void sprd_set_termios(struct uart_port *port,
>>>> +                                 struct ktermios *termios,
>>>> +                                 struct ktermios *old)
>>>> +{
>>>> +     unsigned int baud, quot;
>>>> +     unsigned int lcr, fc;
>>>> +     unsigned long flags;
>>>> +
>>>> +     /* ask the core to calculate the divisor for us */
>>>> +     baud = uart_get_baud_rate(port, termios, old, 1200, 3000000);
>>>                                                       ^^^^   ^^^^^^
>>>                                            mabye derive these from uartclk?
>>
>> I'm afraid I can't understand very clearly, Could you explain more
>> details please?
>
> Is the fixed clock divider == 8 and the uartclk == 26000000 ?
> If so,
>         baud = uartclk / 8 = 3250000
>
> I see now this is clamping baud inside the maximum, so this is fine.
> Please disregard my comment.
>
> [...]
>
>
>>>> +static int sprd_probe(struct platform_device *pdev)
>>>> +{
>>>> +     struct resource *res;
>>>> +     struct uart_port *up;
>>>> +     struct clk *clk;
>>>> +     int irq;
>>>> +     int index;
>>>> +     int ret;
>>>> +
>>>> +     for (index = 0; index < ARRAY_SIZE(sprd_port); index++)
>>>> +             if (sprd_port[index] == NULL)
>>>> +                     break;
>>>> +
>>>> +     if (index == ARRAY_SIZE(sprd_port))
>>>> +             return -EBUSY;
>>>> +
>>>> +     index = sprd_probe_dt_alias(index, &pdev->dev);
>>>> +
>>>> +     sprd_port[index] = devm_kzalloc(&pdev->dev,
>>>> +             sizeof(*sprd_port[index]), GFP_KERNEL);
>>>> +     if (!sprd_port[index])
>>>> +             return -ENOMEM;
>>>> +
>>>> +     up = &sprd_port[index]->port;
>>>> +     up->dev = &pdev->dev;
>>>> +     up->line = index;
>>>> +     up->type = PORT_SPRD;
>>>> +     up->iotype = SERIAL_IO_PORT;
>>>> +     up->uartclk = SPRD_DEF_RATE;
>>>> +     up->fifosize = SPRD_FIFO_SIZE;
>>>> +     up->ops = &serial_sprd_ops;
>>>> +     up->flags = ASYNC_BOOT_AUTOCONF;
>>>                     ^^^^^^^^^
>>>                     UPF_BOOT_AUTOCONF
>>>
>>> sparse will catch errors like this. See Documentation/sparse.txt
>>
>> you mean we should use UPF_BOOT_AUTOCONF, right?
>
> Yes. Only UPF_* flag definitions should be used with the uart_port.flags
> field.
>
> My comment regarding the sparse tool and documentation is because the
> flags field and UPF_* definitions use a type mechanism to generate
> warnings using the sparse tool if regular integer values are used
> with the flags field.
>
> The type mechanism was specifically introduced to catch using ASYNC_*
> definitions with the uart_port.flags field.
>
> [...]
>
>>>> +static int sprd_suspend(struct device *dev)
>>>> +{
>>>> +     int id = to_platform_device(dev)->id;
>>>> +     struct uart_port *port = &sprd_port[id]->port;
>>>
>>> I'm a little confused regarding the port indexing;
>>> is platform_device->id == line ?  Where did that happen?
>>>
>>
>> Oh, I'll change to assign platform_device->id with port->line in probe()
>
> I apologize; I should have made my comment clearer.
>
> The ->id should not be assigned.
>
> Replace
>
>         int id = to_platform_device(dev)->id;
>         struct uart_port *port = &sprd_port[id]->port;
>
>         uart_suspend_port(&sprd_uart_driver, port);
>
> with
>
>         struct sprd_uart_port *sup = dev_get_drvdata(dev);
>
>         uart_suspend_port(&sprd_uart_driver, &sup->port);
>
>
> I know it's not obvious but platform_get/set_drvdata() is really
> dev_get/set_drvdata() using the embedded struct device dev.
>

I've just sent the v7 before I saw your this email, but I'll address
this point in the next version.

Thanks a lot,
Chunyan

>>
>>>
>>>> +
>>>> +     uart_suspend_port(&sprd_uart_driver, port);
>>>> +
>>>> +     return 0;
>>>> +}
>>>> +
>>>> +static int sprd_resume(struct device *dev)
>>>> +{
>>>> +     int id = to_platform_device(dev)->id;
>>>> +     struct uart_port *port = &sprd_port[id]->port;
>>>> +
>>>> +     uart_resume_port(&sprd_uart_driver, port);
>
> same here
>
>>>> +     return 0;
>
