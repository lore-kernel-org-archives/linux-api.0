From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/5] misc: Beaglebone capemanager
Date: Wed, 13 May 2015 04:55:14 -0700
Message-ID: <20150513115514.GB1021@kroah.com>
References: <1431503985-31853-1-git-send-email-pantelis.antoniou@konsulko.com>
 <1431503985-31853-2-git-send-email-pantelis.antoniou@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431503985-31853-2-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-doc-owner@vger.kernel.org
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Robert Nelson <robertcnelson@gmail.com>, Rob Herring <robherring2@gmail.com>, Grant Likely <grant.likely@secretlab.ca>, Jonathan Corbet <corbet@lwn.net>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Guenter Roeck <linux@roeck-us.net>, Geert Uytterhoeven <geert+renesas@glider.be>, =?iso-8859-1?Q?Beno=EEt?= Cousso <bcousson@baylibre.com>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, Pantelis Antoniou <panto@antoniou-consulting.com>
List-Id: linux-api@vger.kernel.org

On Wed, May 13, 2015 at 10:59:41AM +0300, Pantelis Antoniou wrote:
> A cape loader based on DT overlays and DT objects.
> 
> This is the beaglebone cape manager which allows capes to be automatically
> probed and instantiated via means of a device tree overlay deduced from
> the part-number and version contained on the cape's EEPROM.
> 
> The reference manual contains information about the specification
> and the contents of the EEPROM.
> 
> http://beagleboard.org/static/beaglebone/latest/Docs/Hardware/BONE_SRM.pdf
> 
> Documentation about the workings of the cape manager is located
> in Documentation/misc-devices/bone_capemgr.txt
> 
> This driver is using the EEPROM framework interface to retrieve
> the data stored on the baseboard and cape EEPROMs.
> 
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> ---
>  drivers/misc/Kconfig        |   10 +
>  drivers/misc/Makefile       |    1 +
>  drivers/misc/bone_capemgr.c | 1926 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1937 insertions(+)
>  create mode 100644 drivers/misc/bone_capemgr.c
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 006242c..f9e09e1 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -515,6 +515,16 @@ config VEXPRESS_SYSCFG
>  	  bus. System Configuration interface is one of the possible means
>  	  of generating transactions on this bus.
>  
> +config BONE_CAPEMGR
> +	tristate "Beaglebone cape manager"
> +	depends on ARCH_OMAP2PLUS && OF
> +	select EEPROM
> +	select OF_OVERLAY
> +	default n

N is always the default, please remove.

> +	help
> +	  Say Y here to include support for automatic loading of
> +	  beaglebone capes.
> +

What about if it's a module?


>  source "drivers/misc/c2port/Kconfig"
>  source "drivers/misc/eeprom/Kconfig"
>  source "drivers/misc/cb710/Kconfig"
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 7d5c4cd..659b78b 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -56,3 +56,4 @@ obj-$(CONFIG_GENWQE)		+= genwqe/
>  obj-$(CONFIG_ECHO)		+= echo/
>  obj-$(CONFIG_VEXPRESS_SYSCFG)	+= vexpress-syscfg.o
>  obj-$(CONFIG_CXL_BASE)		+= cxl/
> +obj-$(CONFIG_BONE_CAPEMGR)	+= bone_capemgr.o
> diff --git a/drivers/misc/bone_capemgr.c b/drivers/misc/bone_capemgr.c
> new file mode 100644
> index 0000000..423719c
> --- /dev/null
> +++ b/drivers/misc/bone_capemgr.c
> @@ -0,0 +1,1926 @@
> +/*
> + * TI Beaglebone cape manager
> + *
> + * Copyright (C) 2012 Texas Instruments Inc.
> + * Copyright (C) 2012-2015 Konsulko Group.
> + * Author: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.

I have to ask, do you really mean, "or any later version"?


> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/interrupt.h>
> +#include <linux/completion.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_fdt.h>
> +#include <linux/slab.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/firmware.h>
> +#include <linux/err.h>
> +#include <linux/ctype.h>
> +#include <linux/string.h>
> +#include <linux/memory.h>
> +#include <linux/kthread.h>
> +#include <linux/wait.h>
> +#include <linux/file.h>
> +#include <linux/fs.h>
> +#include <linux/eeprom-consumer.h>
> +
> +/* disabled capes */
> +static char *disable_partno;
> +module_param(disable_partno, charp, 0444);
> +MODULE_PARM_DESC(disable_partno,
> +		"Comma delimited list of PART-NUMBER[:REV] of disabled capes");
> +
> +/* enable capes */
> +static char *enable_partno;
> +module_param(enable_partno, charp, 0444);
> +MODULE_PARM_DESC(enable_partno,
> +		"Comma delimited list of PART-NUMBER[:REV] of enabled capes");
> +
> +/* delay to scan on boot until rootfs appears */
> +static int boot_scan_period = 1000;
> +module_param(boot_scan_period, int, 0444);
> +MODULE_PARM_DESC(boot_scan_period,
> +		"boot scan period until rootfs firmware is available");

Ick, no module parameters please, can't we drop these?

And we have a rootfs delay option already for the whole system, this
module shouldn't need a special one.

thanks,

greg k-h
