From: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] eeprom: Add a simple EEPROM framework
Date: Thu, 19 Feb 2015 18:36:32 -0800
Message-ID: <54E69DB0.60701@codeaurora.org>
References: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org> <1424365708-26681-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424365708-26681-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/19/15 09:08, Srinivas Kandagatla wrote:
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index c70d6e4..d7afc82 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -184,4 +184,6 @@ source "drivers/thunderbolt/Kconfig"
>  
>  source "drivers/android/Kconfig"
>  
> +source "drivers/eeprom/Kconfig"
> +
>  endmenu
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 527a6da..57eb5b0 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -165,3 +165,4 @@ obj-$(CONFIG_RAS)		+= ras/
>  obj-$(CONFIG_THUNDERBOLT)	+= thunderbolt/
>  obj-$(CONFIG_CORESIGHT)		+= coresight/
>  obj-$(CONFIG_ANDROID)		+= android/
> +obj-$(CONFIG_EEPROM)		+= eeprom/
> diff --git a/drivers/eeprom/Kconfig b/drivers/eeprom/Kconfig
> new file mode 100644
> index 0000000..2c5452a
> --- /dev/null
> +++ b/drivers/eeprom/Kconfig
> @@ -0,0 +1,19 @@
> +menuconfig EEPROM
> +	bool "EEPROM Support"
> +	depends on OF

Doesn't this need some sort of select REGMAP somewhere?

Also, why do we need to use regmap for the eeprom framework read/write
ops? I liked the simple eeprom::{read,write} API that Maxime had. The
regmap part could be a regmap-eeprom driver that implements read/write
ops like you've done in the core.

> +	help
> +	  Support for EEPROM alike devices.
> +
> +	  This framework is designed to provide a generic interface to EEPROM
> +	  from both the Linux Kernel and the userspace.
> +
> +	  If unsure, say no.
> +
> +if EEPROM
> +
> +config EEPROM_DEBUG
> +	bool "EEPROM debug support"
> +	help
> +	  Say yes here to enable debugging support.
> +
> +endif
>
> diff --git a/include/linux/eeprom-provider.h b/include/linux/eeprom-provider.h
> new file mode 100644
> index 0000000..3943c2f
> --- /dev/null
> +++ b/include/linux/eeprom-provider.h
> @@ -0,0 +1,51 @@
> +/*
> + * EEPROM framework provider.
> + *
> + * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> + * Copyright (C) 2013 Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#ifndef _LINUX_EEPROM_PROVIDER_H
> +#define _LINUX_EEPROM_PROVIDER_H
> +
> +#include <linux/device.h>
> +#include <linux/regmap.h>
> +#include <linux/list.h>
> +
> +struct eeprom_device {
> +	struct regmap		*regmap;
> +	int			stride;
> +	size_t			size;
> +	struct device		*dev;
> +
> +	/* Internal to framework */
> +	struct device		edev;
> +	int			id;
> +	struct list_head	list;

Should there be a module owner here to handle module removal?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
