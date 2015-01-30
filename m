From: Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH v10 2/2] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Date: Fri, 30 Jan 2015 10:32:54 -0500
Message-ID: <54CBA426.7050900@hurleysoftware.com>
References: <sc9836-serial-v10> <1422443324-25082-1-git-send-email-chunyan.zhang@spreadtrum.com> <1422443324-25082-3-git-send-email-chunyan.zhang@spreadtrum.com> <54CA5128.8050500@gmail.com> <54CA568E.6080306@hurleysoftware.com> <20150129160553.GC26493@n2100.arm.linux.org.uk> <20150130101838.GC16744@ulmo> <54CB72F7.8060706@hurleysoftware.com> <20150130140854.GJ26493@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150130140854.GJ26493@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thierry Reding <thierry.reding@gmail.com>, Varka Bhadram <varkabhadram@gmail.com>, Chunyan Zhang <chunyan.zhang@spreadtrum.com>, gregkh@linuxfoundation.org, mark.rutland@arm.com, gnomes@lxorguk.ukuu.org.uk, heiko@sntech.de, andrew@lunn.ch, jslaby@suse.cz, lanqing.liu@spreadtrum.com, pawel.moll@arm.com, zhang.lyra@gmail.com, zhizhou.zhang@spreadtrum.com, geng.ren@spreadtrum.com, antonynpavlov@gmail.com, linux-serial@vger.kernel.org, grant.likely@linaro.org, orsonzhai@gmail.com, florian.vaussard@epfl.ch, devicetree@vger.kernel.org, jason@lakedaemon.net, arnd@arndb.de, ijc+devicetree@hellion.org.uk, hytszk@gmail.com, robh+dt@kernel.org, wei.qiao@spreadtrum.com, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, galak@codeaurora.org, shawn.guo@linaro.org
List-Id: linux-api@vger.kernel.org

On 01/30/2015 09:08 AM, Russell King - ARM Linux wrote:
> On Fri, Jan 30, 2015 at 07:03:03AM -0500, Peter Hurley wrote:
>> On 01/30/2015 05:18 AM, Thierry Reding wrote:
>>> -ENODEV is certainly not the correct return value if a resource is not
>>> available. It translates to "no such device", but the device must
>>> clearly be there, otherwise the ->probe() shouldn't have been called.
>>
>> -ENODEV is the appropriate return from the probe(); there is no device.
> 
> No it is not.  "no such device" means "the device is not present".  If
> the device is not present, we wouldn't have a struct device associated
> with it.
> 
> The missing resource is an error condition: what it's saying is that the
> device is there, but something has failed in providing the IO regions
> necessary to access it.  That's really something very different from
> "there is no device present".

This is masking behavior changes behind what is essentially a refactor.
For example, here's Felipe's changelog to omap-serial:

commit d044d2356f8dd18c755e13f34318bc03ef9c6887
Author: Felipe Balbi <balbi@ti.com>
Date:   Wed Apr 23 09:58:33 2014 -0500

    tty: serial: omap: switch over to devm_ioremap_resource
    
    just using helper function to remove some duplicated
    code a bit. While at that, also move allocation of
    struct uart_omap_port higher in the code so that
    we return much earlier in case of no memory.
    
    Signed-off-by: Felipe Balbi <balbi@ti.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

No mention of correcting an error return value here.

Why change the error return from probe() now?

Before you say consistency, I think you should look at the stats below.
IOW, if you want to change the error code return from probe() for
consistency's sake, a tree-wide patch would be the appropriate way.


>>> Or if it really isn't there, then you'd at least need a memory region
>>> to probe, otherwise you can't determine whether it's there or not. So
>>> from the perspective of a device driver I think a missing, or NULL,
>>> resource, is indeed an "invalid argument".
>>
>> Trying to argue that a missing host bus window is an "invalid argument"
>> to probe() is just trying to make the shoe fit.
> 
> As is arguing that -ENODEV is an appropriate return value for the missing
> resource.
> 
> Moreover, returning -ENODEV is actually *bad* in this case - the kernel's
> generic probe handling does not report the failure of the driver to bind
> given this, so a missing resource potentially becomes a silent failure of
> a driver - leading users to wonder why their devices aren't found.
> 
> If we /really/ have a problem with the error code, then why not invent
> a new error code to cater for this condition - maybe, EBADRES (bad resource).
> 
>>> I understand that people might see some ambiguity there, and -EINVAL is
>>> certainly not a very accurate description, but such is the nature of
>>> error codes. You pick what fits best. -ENXIO and -EADDRNOTAVAIL had been
>>> under discussion as well if I remember correctly, but they both equally
>>> ambiguous. -ENODATA might have been a better fit, but that too has a
>>> different meaning in other contexts.
>>>
>>> Besides, there's an error message that goes along with the error code
>>> return, that should remove any ambiguity for people looking at dmesg.
>>>
>>> All of that said, the original assertion that the check is not required
>>> is still valid. We can argue at length about the specific error code but
>>> if we decide that it needs to change, then we should modify
>>> devm_ioremap_resource() rather than requiring all callers to perform the
>>> extra check again.
>>
>> None of the devm_ioremap_resource() changes have been submitted for
>> serial drivers.
> 
> $ grep devm_ioremap_resource drivers/tty/serial/ -r | wc -l
> 10

Ok, not 'none' but hardly tree-wide.

And of those 10 drivers now using devm_ioremap_resource(),
3 drivers still return ENODEV for a missing resource [1]. (FWIW, I wrote 'none'
on the basis of a grep of devm_ioremap_resource and looking at the last one,
serial-tegra.c, which has exactly the construct objected to in the Spreadtrum
driver).

Another 9 drivers still use plain devm_ioremap(), even those with
trivial conversions like samsung.c [2]

Of the serial drivers which use platform_get_resource(),
10 return  ENODEV
5  return  EINVAL (not including those converted to devm_ioremap_resource())
4  return  ENXIO
3  return  ENOMEM
2  return  ENOENT
1  returns EBUSY
1  returns EFAULT

So to recap, I see no reason to respin this driver submission when:
1. even drivers already using devm_ioremap_resource() aren't consistent
2. drivers which could trivially use devm_ioremap_resource, don't
3. there's no basis for requiring consistent return value _yet_
   (or even what that value should be)
4. the platform_get_resource()/devm_ioremap_resource is an awkward code construct

Regards,
Peter Hurley


[1]
drivers/tty/serial/bcm63xx_uart.c-	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
drivers/tty/serial/bcm63xx_uart.c-	if (!res_mem)
drivers/tty/serial/bcm63xx_uart.c-		return -ENODEV;
drivers/tty/serial/bcm63xx_uart.c-
drivers/tty/serial/bcm63xx_uart.c-	port->mapbase = res_mem->start;
drivers/tty/serial/bcm63xx_uart.c:	port->membase = devm_ioremap_resource(&pdev->dev, res_mem);

drivers/tty/serial/vt8500_serial.c-	mmres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
drivers/tty/serial/vt8500_serial.c-	irqres = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
drivers/tty/serial/vt8500_serial.c-	if (!mmres || !irqres)
drivers/tty/serial/vt8500_serial.c-		return -ENODEV;
[...]
drivers/tty/serial/vt8500_serial.c:	vt8500_port->uart.membase = devm_ioremap_resource(&pdev->dev, mmres);

drivers/tty/serial/serial-tegra.c-	resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
drivers/tty/serial/serial-tegra.c-	if (!resource) {
drivers/tty/serial/serial-tegra.c-		dev_err(&pdev->dev, "No IO memory resource\n");
drivers/tty/serial/serial-tegra.c-		return -ENODEV;
drivers/tty/serial/serial-tegra.c-	}
drivers/tty/serial/serial-tegra.c-
drivers/tty/serial/serial-tegra.c-	u->mapbase = resource->start;
drivers/tty/serial/serial-tegra.c:	u->membase = devm_ioremap_resource(&pdev->dev, resource);


[2]
drivers/tty/serial/samsung.c:	res = platform_get_resource(platdev, IORESOURCE_MEM, 0);
drivers/tty/serial/samsung.c-	if (res == NULL) {
drivers/tty/serial/samsung.c-		dev_err(port->dev, "failed to find memory resource for uart\n");
drivers/tty/serial/samsung.c-		return -EINVAL;
drivers/tty/serial/samsung.c-	}
drivers/tty/serial/samsung.c-
drivers/tty/serial/samsung.c-	dbg("resource %pR)\n", res);
drivers/tty/serial/samsung.c-
drivers/tty/serial/samsung.c-	port->membase = devm_ioremap(port->dev, res->start, resource_size(res));
drivers/tty/serial/samsung.c-	if (!port->membase) {
drivers/tty/serial/samsung.c-		dev_err(port->dev, "failed to remap controller address\n");
