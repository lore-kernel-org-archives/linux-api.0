From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 5/5] tty/serial: Add Spreadtrum sc9836-uart driver support
Date: Tue, 20 Jan 2015 14:17:56 -0600
Message-ID: <CAL_JsqJz+G6WjBSf=ye9rTLBUD9bw54szhZJROD5WTKMG99NHQ@mail.gmail.com>
References: <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1421402411-3479-6-git-send-email-chunyan.zhang@spreadtrum.com>
 <CAL_JsqJg=BtanmR_rhYthCUhKbErs8viZ7MMMXr-PmPjUV4BRQ@mail.gmail.com>
 <CAAfSe-vqqpvbYe0bEeD-3_QsLYz4r7pxMuA1-L4cYRw9TY=NgA@mail.gmail.com>
 <CAL_JsqLTArm1v8ka39_KLq2jMKkK2ZXQ6-an=JSWVgTK1LWmOg@mail.gmail.com> <CAAfSe-tAwURc_P+-0+m22ao9r+Fud6Ae89JF8FGsWgg_49Mdhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAfSe-tAwURc_P+-0+m22ao9r+Fud6Ae89JF8FGsWgg_49Mdhg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lyra Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, Florian Vaussard <florian.vaussard-p8DiymsW2f8@public.gmane.org>, Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Hayato Suzuki <hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Antony Pavlov <antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Joel Schopp <Joel.Schopp-5C7GfCeVMHo@public.gmane.org>Suravee Suthikulanit <S>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 20, 2015 at 1:37 AM, Lyra Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi, Rob
>
> I still have a question to be conform, specific describes below:
>
> On Mon, Jan 19, 2015 at 10:11 PM, Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Mon, Jan 19, 2015 at 3:55 AM, Lyra Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> On Sat, Jan 17, 2015 at 12:41 AM, Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> On Fri, Jan 16, 2015 at 4:00 AM, Chunyan Zhang
>>>> <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org> wrote:
>>>>> Add a full sc9836-uart driver for SC9836 SoC which is based on the
>>>>> spreadtrum sharkl64 platform.
>>>>> This driver also support earlycon.
>>>>> This patch also replaced the spaces between the macros and their
>>>>> values with the tabs in serial_core.h
>>
>> [...]
>>
>>>>> +static int __init sprd_serial_init(void)
>>>>> +{
>>>>> +       int ret = 0;
>>>>> +
>>>>> +       ret = uart_register_driver(&sprd_uart_driver);
>>>>
>>>> This can be done in probe now. Then you can use module_platform_driver().
>>>>
>>>
>>> Question:
>>> 1. there are 4 uart ports configured in dt for sprd_serial, so probe
>>> will be called 4 times, but uart_register_driver only needs to be
>>> called one time, so can we use uart_driver.state to check if
>>> uart_register_driver has already been called ?
>>
>> Yes.
>>
>>> 2. if I use module_platform_driver() instead of
>>> module_init(sprd_serial_init)  and  module_exit(sprd_serial_exit) , I
>>> must move uart_unregister_driver() which is now processed in
>>> sprd_serial_exit() to sprd_remove(), there is a similar problem with
>>> probe(), sprd_remove() will also be called 4 times, and actually it
>>> should be called only one time. How can we deal with this case?
>>
>> Look at pl01x or Samsung UART drivers which have done this conversion.
>
> Samsung UART does use module_platform_driver, but pl010/pl011 doesn't.

That is because pl011 is an amba_device rather than a platform_device
and there is not an equivalent macro for this boilerplate (although I
think one has been posted recently).

> In the Samsung UART driver, uart_unregister_driver is processed in
> remove(), like below:
>
> static int s3c24xx_serial_remove(struct platform_device *dev)
> {
>     struct uart_port *port = s3c24xx_dev_to_port(&dev->dev);
>
>     if (port) {
>         s3c24xx_serial_cpufreq_deregister(to_ourport(port));
>         uart_remove_one_port(&s3c24xx_uart_drv, port);
>     }
>
>     uart_unregister_driver(&s3c24xx_uart_drv);
> }
>
> if this serial has more than one ports, uart_unregister_driver() must
> be called multiple times when the device need to be removed.
> I think there may be a problem because that uart_unregister_driver()
> will do kfree(drv->state) every time when it's called.

Yes. Looks like a bug still in the Samsung driver. So follow what the
pl01x driver does. It had the same problem, but there is a follow-up
commit to fix it.

Rob
