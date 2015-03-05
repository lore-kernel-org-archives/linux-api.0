From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 1/6] eeprom: Add a simple EEPROM framework for eeprom
 providers
Date: Thu, 05 Mar 2015 10:35:13 +0000
Message-ID: <54F83161.3070007@linaro.org>
References: <1425548685-12887-1-git-send-email-srinivas.kandagatla@linaro.org>	 <1425548741-12930-1-git-send-email-srinivas.kandagatla@linaro.org> <1425551024.24292.218.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425551024.24292.218.camel@x220>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, andrew-g2DYL2Zd6BY@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 05/03/15 10:23, Paul Bolle wrote:
> On Thu, 2015-03-05 at 09:45 +0000, Srinivas Kandagatla wrote:
>> --- /dev/null
>> +++ b/drivers/eeprom/Kconfig
>> @@ -0,0 +1,20 @@
>> +menuconfig EEPROM
>> +	bool "EEPROM Support"
>
> EEPROM is a bool symbol.
>
>> +	depends on OF
>> +	select REGMAP
>> +	help
>> +	  Support for EEPROM alike devices.
>> +
>> +	  This framework is designed to provide a generic interface to EEPROM
>> +	  from both the Linux Kernel and the userspace.
>> +
>> +	  If unsure, say no.
>> +
>> +if EEPROM
>> +
>> +config EEPROM_DEBUG
>> +	bool "EEPROM debug support"
>> +	help
>> +	  Say yes here to enable debugging support.
>> +
>> +endif
>> diff --git a/drivers/eeprom/Makefile b/drivers/eeprom/Makefile
>> new file mode 100644
>> index 0000000..e130079
>> --- /dev/null
>> +++ b/drivers/eeprom/Makefile
>> @@ -0,0 +1,9 @@
>> +#
>> +# Makefile for eeprom drivers.
>> +#
>> +
>> +ccflags-$(CONFIG_EEPROM_DEBUG) += -DDEBUG
>> +
>> +obj-$(CONFIG_EEPROM)		+= core.o
>
> So core.o will be built-in (or not built at all, of course).
>
>> +# Devices
>> diff --git a/drivers/eeprom/core.c b/drivers/eeprom/core.c
>> new file mode 100644
>> index 0000000..243e466
>> --- /dev/null
>> +++ b/drivers/eeprom/core.c
>> @@ -0,0 +1,208 @@
>> +/*
>> + * EEPROM framework core.
>> + *
>> + * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> + * Copyright (C) 2013 Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
>> + *
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2.  This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
>> +#include <linux/device.h>
>> +#include <linux/eeprom-provider.h>
>> +#include <linux/export.h>
>> +#include <linux/fs.h>
>> +#include <linux/idr.h>
>> +#include <linux/init.h>
>> +#include <linux/module.h>
>
> So I guess this header is not needed.
>
>> +#include <linux/of.h>
>> +#include <linux/slab.h>
>> +#include <linux/uaccess.h>
>
>> +module_exit(eeprom_exit);
>
> And this will never be called.
>
>> +MODULE_AUTHOR("Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org");
>> +MODULE_AUTHOR("Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org");
>> +MODULE_DESCRIPTION("EEPROM Driver Core");
>> +MODULE_LICENSE("GPL");
>
> And those four macros will basically be preprocessed away. But if you
> actually want this code to be built modular too, and change EEPROM to
> tristate, you probably want to use
>      MODULE_LICENSE("GPL v2");
>
> here.

Thanks, Thats a good catch,
There is no reason why this driver can't be a module, I will change the 
Kconfig and License in next version.


>
>
> Paul Bolle
>
