From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v1 1/6] eeprom: Add a simple EEPROM framework for eeprom
 providers
Date: Thu, 05 Mar 2015 11:23:44 +0100
Message-ID: <1425551024.24292.218.camel@x220>
References: <1425548685-12887-1-git-send-email-srinivas.kandagatla@linaro.org>
	 <1425548741-12930-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425548741-12930-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Kumar Gala <galak@codeaurora.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>, andrew@lunn.ch, Arnd Bergmann <arnd@arndb.de>, broonie@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2015-03-05 at 09:45 +0000, Srinivas Kandagatla wrote:
> --- /dev/null
> +++ b/drivers/eeprom/Kconfig
> @@ -0,0 +1,20 @@
> +menuconfig EEPROM
> +	bool "EEPROM Support"

EEPROM is a bool symbol.

> +	depends on OF
> +	select REGMAP
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
> diff --git a/drivers/eeprom/Makefile b/drivers/eeprom/Makefile
> new file mode 100644
> index 0000000..e130079
> --- /dev/null
> +++ b/drivers/eeprom/Makefile
> @@ -0,0 +1,9 @@
> +#
> +# Makefile for eeprom drivers.
> +#
> +
> +ccflags-$(CONFIG_EEPROM_DEBUG) += -DDEBUG
> +
> +obj-$(CONFIG_EEPROM)		+= core.o

So core.o will be built-in (or not built at all, of course).

> +# Devices
> diff --git a/drivers/eeprom/core.c b/drivers/eeprom/core.c
> new file mode 100644
> index 0000000..243e466
> --- /dev/null
> +++ b/drivers/eeprom/core.c
> @@ -0,0 +1,208 @@
> +/*
> + * EEPROM framework core.
> + *
> + * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> + * Copyright (C) 2013 Maxime Ripard <maxime.ripard@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/eeprom-provider.h>
> +#include <linux/export.h>
> +#include <linux/fs.h>
> +#include <linux/idr.h>
> +#include <linux/init.h>
> +#include <linux/module.h>

So I guess this header is not needed.

> +#include <linux/of.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>

> +module_exit(eeprom_exit);

And this will never be called.

> +MODULE_AUTHOR("Srinivas Kandagatla <srinivas.kandagatla@linaro.org");
> +MODULE_AUTHOR("Maxime Ripard <maxime.ripard@free-electrons.com");
> +MODULE_DESCRIPTION("EEPROM Driver Core");
> +MODULE_LICENSE("GPL");

And those four macros will basically be preprocessed away. But if you
actually want this code to be built modular too, and change EEPROM to
tristate, you probably want to use
    MODULE_LICENSE("GPL v2");

here.


Paul Bolle
