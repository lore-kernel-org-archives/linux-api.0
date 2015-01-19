From: Lyra Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 5/5] tty/serial: Add Spreadtrum sc9836-uart driver support
Date: Mon, 19 Jan 2015 17:55:07 +0800
Message-ID: <CAAfSe-vqqpvbYe0bEeD-3_QsLYz4r7pxMuA1-L4cYRw9TY=NgA@mail.gmail.com>
References: <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1421402411-3479-6-git-send-email-chunyan.zhang@spreadtrum.com>
	<CAL_JsqJg=BtanmR_rhYthCUhKbErs8viZ7MMMXr-PmPjUV4BRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_JsqJg=BtanmR_rhYthCUhKbErs8viZ7MMMXr-PmPjUV4BRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, Florian Vaussard <florian.vaussard-p8DiymsW2f8@public.gmane.org>, Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Hayato Suzuki <hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Antony Pavlov <antonynpavlov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Joel Schopp <Joel.Schopp-5C7GfCeVMHo@public.gmane.org>Suravee Suthikulanit <S>
List-Id: linux-api@vger.kernel.org

On Sat, Jan 17, 2015 at 12:41 AM, Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Fri, Jan 16, 2015 at 4:00 AM, Chunyan Zhang
> <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org> wrote:
>> Add a full sc9836-uart driver for SC9836 SoC which is based on the
>> spreadtrum sharkl64 platform.
>> This driver also support earlycon.
>> This patch also replaced the spaces between the macros and their
>> values with the tabs in serial_core.h
>>
>> Signed-off-by: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
>> Signed-off-by: Orson Zhai <orson.zhai-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
>> Originally-by: Lanqing Liu <lanqing.liu-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>
>> ---
>>  drivers/tty/serial/Kconfig       |   18 +
>>  drivers/tty/serial/Makefile      |    1 +
>>  drivers/tty/serial/sprd_serial.c |  772 ++++++++++++++++++++++++++++++++++++++
>>  include/uapi/linux/serial_core.h |    3 +
>>  4 files changed, 794 insertions(+)
>>  create mode 100644 drivers/tty/serial/sprd_serial.c
>>
>> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
>> index c79b43c..969d3cd 100644
>> --- a/drivers/tty/serial/Kconfig
>> +++ b/drivers/tty/serial/Kconfig
>> @@ -1577,6 +1577,24 @@ config SERIAL_MEN_Z135
>>           This driver can also be build as a module. If so, the module will be called
>>           men_z135_uart.ko
>>
>> +config SERIAL_SPRD
>> +       tristate "Support for SPRD serial"
>
> Can the menu text spell out Spreadtrum. What SPRD means is not obvious.
>

Ok, I'll address it.

>> +       depends on ARCH_SPRD
>> +       select SERIAL_CORE
>> +       help
>> +         This enables the driver for the Spreadtrum's serial.
>> +
>> +config SERIAL_SPRD_CONSOLE
>> +       bool "SPRD UART console support"
>
> Same here.
>
>> +       depends on SERIAL_SPRD=y
>> +       select SERIAL_CORE_CONSOLE
>> +       select SERIAL_EARLYCON
>> +       help
>> +         Support for early debug console using Spreadtrum's serial. This enables
>> +         the console before standard serial driver is probed. This is enabled
>> +         with "earlycon" on the kernel command line. The console is
>> +         enabled when early_param is processed.
>> +
>>  endmenu
>>
>>  config SERIAL_MCTRL_GPIO
>> diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
>> index 9a548ac..4801aca 100644
>> --- a/drivers/tty/serial/Makefile
>> +++ b/drivers/tty/serial/Makefile
>> @@ -93,6 +93,7 @@ obj-$(CONFIG_SERIAL_ARC)      += arc_uart.o
>>  obj-$(CONFIG_SERIAL_RP2)       += rp2.o
>>  obj-$(CONFIG_SERIAL_FSL_LPUART)        += fsl_lpuart.o
>>  obj-$(CONFIG_SERIAL_MEN_Z135)  += men_z135_uart.o
>> +obj-$(CONFIG_SERIAL_SPRD) += sprd_serial.o
>>
>>  # GPIOLIB helpers for modem control lines
>>  obj-$(CONFIG_SERIAL_MCTRL_GPIO)        += serial_mctrl_gpio.o
>> diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
>> new file mode 100644
>> index 0000000..81839e4
>> --- /dev/null
>> +++ b/drivers/tty/serial/sprd_serial.c
>> @@ -0,0 +1,772 @@
>> +/*
>> + * Copyright (C) 2012 Spreadtrum Communications Inc.
>
> This is unchanged in 3 years?
>

ok, I'll change it to 2012-2015.

>> + *
>> + * This software is licensed under the terms of the GNU General Public
>> + * License version 2, as published by the Free Software Foundation, and
>> + * may be copied, distributed, and modified under those terms.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/console.h>
>> +#include <linux/delay.h>
>> +#include <linux/io.h>
>> +#include <linux/ioport.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/serial_core.h>
>> +#include <linux/serial.h>
>> +#include <linux/slab.h>
>> +#include <linux/tty.h>
>> +#include <linux/tty_flip.h>
>> +
>> +/* device name */
>> +#define UART_NR_MAX            8
>> +#define SPRD_TTY_NAME          "ttySPX"
>
> We really want to get away from per SOC serial names and use ttyS for
> serial port /dev names. There's issues switching existing drivers
> because this creates an ABI, so we can only have new drivers follow
> this.
>

ok. i see. I'll convert it to ttyS in the next version.

> [...]
>
>> +static struct platform_driver sprd_platform_driver = {
>> +       .probe          = sprd_probe,
>> +       .remove         = sprd_remove,
>> +       .driver         = {
>> +               .name   = "sprd_serial",
>> +               .of_match_table = of_match_ptr(serial_ids),
>> +               .pm     = &sprd_pm_ops,
>> +       },
>> +};
>> +
>> +static int __init sprd_serial_init(void)
>> +{
>> +       int ret = 0;
>> +
>> +       ret = uart_register_driver(&sprd_uart_driver);
>
> This can be done in probe now. Then you can use module_platform_driver().
>

Question:
1. there are 4 uart ports configured in dt for sprd_serial, so probe
will be called 4 times, but uart_register_driver only needs to be
called one time, so can we use uart_driver.state to check if
uart_register_driver has already been called ?

2. if I use module_platform_driver() instead of
module_init(sprd_serial_init)  and  module_exit(sprd_serial_exit) , I
must move uart_unregister_driver() which is now processed in
sprd_serial_exit() to sprd_remove(), there is a similar problem with
probe(), sprd_remove() will also be called 4 times, and actually it
should be called only one time. How can we deal with this case?

3. for the second question, we can check the platform_device->id, if
it is equal to the index of last port (e.g. 4 for this case), then
uart_unregister_driver() can be called. Does it work correctly? since
for this case, we must keep the order of releasing ports.


Thanks,
Chunyan


> Rob
