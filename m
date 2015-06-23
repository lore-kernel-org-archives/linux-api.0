From: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>
Subject: Re: [PATCH v6 1/9] nvmem: Add a simple NVMEM framework for nvmem
 providers
Date: Tue, 23 Jun 2015 22:10:59 +0200 (CEST)
Message-ID: <982684639.251832.1435090259373.JavaMail.open-xchange@oxbsltgw00.schlund.de>
References: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org> <1435014507-26181-1-git-send-email-srinivas.kandagatla@linaro.org>
Reply-To: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435014507-26181-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Srinivas,

sorry for the messed up indention.

> Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> hat am 23. Juni 2015 um
> 01:08 geschrieben:
>
>
> [...]
> --- /dev/null
> +++ b/drivers/nvmem/Kconfig
> @@ -0,0 +1,10 @@
> +menuconfig NVMEM
> + tristate "NVMEM Support"
> + select REGMAP
> + help
> + Support for NVMEM devices.
> +
> + This framework is designed to provide a generic interface to NVMEM
> + from both the Linux Kernel and the userspace.

In order to avoid confusion it would be good to write here what does NVMEM mean.

> +
> + If unsure, say no.
> diff --git a/drivers/nvmem/Makefile b/drivers/nvmem/Makefile
> new file mode 100644
> index 0000000..6df2c69
> --- /dev/null
> +++ b/drivers/nvmem/Makefile
> @@ -0,0 +1,6 @@
> +#
> +# Makefile for nvmem drivers.
> +#
> +
> +obj-$(CONFIG_NVMEM) += nvmem_core.o
> +nvmem_core-y := core.o
> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
> new file mode 100644
> index 0000000..17a826d
> --- /dev/null
> +++ b/drivers/nvmem/core.c
> @@ -0,0 +1,398 @@
> +/*
> + * nvmem framework core.
> + *
> + * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> + * Copyright (C) 2013 Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/nvmem-provider.h>
> +#include <linux/export.h>
> +#include <linux/fs.h>
> +#include <linux/idr.h>
> +#include <linux/init.h>
> +#include <linux/regmap.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/slab.h>

Sorting alphabetically would by nice

> + [...]
> +/**
> + * nvmem_register() - Register a nvmem device for given nvmem_config.
> + * Also creates an binary entry in /sys/class/nvmem/dev-name/nvmem
> + *
> + * @config: nvmem device configuration with which nvmem device is created.
> + *
> + * The return value will be an ERR_PTR() on error or a valid pointer
> + * to nvmem_device.
> + */
> +
> +struct nvmem_device *nvmem_register(struct nvmem_config *config)
> +{
> + struct nvmem_device *nvmem;
> + struct regmap *rm;
> + int rval;
> +
> + if (!config->dev)
> + return ERR_PTR(-EINVAL);
> +
> + rm = dev_get_regmap(config->dev, NULL);
> + if (!rm) {
> + dev_err(config->dev, "Regmap not found\n");
> + return ERR_PTR(-EINVAL);
> + }
> +
> + nvmem = kzalloc(sizeof(*nvmem), GFP_KERNEL);
> + if (!nvmem)
> + return ERR_PTR(-ENOMEM);
> +
> + nvmem->id = ida_simple_get(&nvmem_ida, 0, 0, GFP_KERNEL);
> + if (nvmem->id < 0) {
> + kfree(nvmem);
> + return ERR_PTR(nvmem->id);
> + }
> +
> + nvmem->regmap = rm;
> + nvmem->owner = config->owner;
> + nvmem->stride = regmap_get_reg_stride(rm);
> + nvmem->word_size = regmap_get_val_bytes(rm);
> + nvmem->size = regmap_get_max_register(rm) + nvmem->stride;
> + nvmem->dev.class = &nvmem_class;
> + nvmem->dev.parent = config->dev;
> + nvmem->dev.of_node = config->dev->of_node;
> + dev_set_name(&nvmem->dev, "%s%d",
> + config->name ? : "nvmem", config->id);
> +
> + nvmem->read_only = nvmem->dev.of_node ?
> + of_property_read_bool(nvmem->dev.of_node,
> + "read-only") :
> + config->read_only;
> +
> + device_initialize(&nvmem->dev);
> +
> + dev_dbg(&nvmem->dev, "Registering nvmem device %s\n",
> + dev_name(&nvmem->dev));
> +
> + rval = device_add(&nvmem->dev);
> + if (rval) {
> + ida_simple_remove(&nvmem_ida, nvmem->id);
> + kfree(nvmem);
> + return ERR_PTR(rval);
> + }
> +
> + /* update sysfs attributes */
> + if (nvmem->read_only)
> + sysfs_update_group(&nvmem->dev.kobj, &nvmem_bin_ro_group);
> +
> + if (config->cells)
> + nvmem_add_cells(nvmem, config);

I think this would be a better place for the debug message from above.
Additionally we could add the cell count and so on.

Stefan
