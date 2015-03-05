From: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Subject: Re: [PATCH v1 4/6] eeprom: sunxi: Move the SID driver to the eeprom
 framework
Date: Thu, 05 Mar 2015 11:15:15 +0100
Message-ID: <1425550515.24292.212.camel@x220>
References: <1425548685-12887-1-git-send-email-srinivas.kandagatla@linaro.org>
	 <1425548775-13067-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425548775-13067-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, andrew-g2DYL2Zd6BY@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2015-03-05 at 09:46 +0000, Srinivas Kandagatla wrote:
> --- a/drivers/eeprom/Kconfig
> +++ b/drivers/eeprom/Kconfig
> @@ -17,4 +17,15 @@ config EEPROM_DEBUG
>  	help
>  	  Say yes here to enable debugging support.
>  
> +config EEPROM_SUNXI_SID
> +	depends on ARCH_SUNXI
> +	tristate "Allwinner SoCs SID support"

Nit: make this the first option, please.

> +	select REGMAP_MMIO
> +	help
> +	  This is a driver for the 'security ID' available on various Allwinner
> +	  devices.
> +
> +	  This driver can also be built as a module. If so, the module
> +	  will be called sunxi_sid.

I think it will be called "eeprom-sunxi-sid". Am I right?

(There must be thousands of lines like this in the various Kconfig
files. Has anyone ever tried to autogenerate this info for the make
*config tools? Probably rather complicated...)

> +
>  endif
> diff --git a/drivers/eeprom/Makefile b/drivers/eeprom/Makefile
> index e130079..661422c 100644
> --- a/drivers/eeprom/Makefile
> +++ b/drivers/eeprom/Makefile
> @@ -7,3 +7,4 @@ ccflags-$(CONFIG_EEPROM_DEBUG) += -DDEBUG
>  obj-$(CONFIG_EEPROM)		+= core.o
>  
>  # Devices
> +obj-$(CONFIG_EEPROM_SUNXI_SID)	+= eeprom-sunxi-sid.o
> diff --git a/drivers/eeprom/eeprom-sunxi-sid.c b/drivers/eeprom/eeprom-sunxi-sid.c
> new file mode 100644
> index 0000000..eb32afb
> --- /dev/null
> +++ b/drivers/eeprom/eeprom-sunxi-sid.c
> @@ -0,0 +1,129 @@
> +/*
> + * Allwinner sunXi SoCs Security ID support.
> + *
> + * Copyright (c) 2013 Oliver Schinagl <oliver-dxLnbx3+1qmEVqv0pETR8A@public.gmane.org>
> + * Copyright (C) 2014 Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */

So the license is GPL v2.

> +MODULE_LICENSE("GPL");

Which means you probably want
    MODULE_LICENSE("GPL v2");

> --- a/drivers/misc/eeprom/sunxi_sid.c
> +++ /dev/null
> @@ -1,156 +0,0 @@
> -/*
> - * Copyright (c) 2013 Oliver Schinagl <oliver-dxLnbx3+1qmEVqv0pETR8A@public.gmane.org>
> - * http://www.linux-sunxi.org
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.

But the previous driver was GPL v2 or later.

> -MODULE_LICENSE("GPL");

And this matches that.

Was it intended to re-license this, or is the code basically new? (I
haven't compared the before and after code, to be honest.)


Paul Bolle
