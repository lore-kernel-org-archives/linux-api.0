From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 07/11] nvmem: Add simple nvmem-mmio consumer helper
 functions.
Date: Thu, 18 Jun 2015 14:08:48 +0100
Message-ID: <5582C2E0.9080503@linaro.org>
References: <1432226535-8640-1-git-send-email-srinivas.kandagatla@linaro.org> <1432226665-8994-1-git-send-email-srinivas.kandagatla@linaro.org> <5580AA05.90709@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5580AA05.90709-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 16/06/15 23:58, Stephen Boyd wrote:
> On 05/21/2015 09:44 AM, Srinivas Kandagatla wrote:
>> diff --git a/drivers/nvmem/nvmem-mmio.c b/drivers/nvmem/nvmem-mmio.c
>> new file mode 100644
>> index 0000000..0d8131f
>> --- /dev/null
>> +++ b/drivers/nvmem/nvmem-mmio.c
>> @@ -0,0 +1,69 @@
>> +/*
>> + * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/device.h>
>> +#include <linux/module.h>
>> +#include <linux/err.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>
> #include <linux/platform_device.h>
> #include <linux/nvmem_provider.h>
> #include <linux/regmap.h>
>
These are included in nvmem-mmio.h, however for clarity sake I could add 
them here too.
>> +#include "nvmem-mmio.h"
>> +
>> +int nvmem_mmio_remove(struct platform_device *pdev)
>> +{
>> +	struct nvmem_device *nvmem = platform_get_drvdata(pdev);
>> +
>> +	return nvmem_unregister(nvmem);
>> +}
>> +EXPORT_SYMBOL_GPL(nvmem_mmio_remove);
>> +
>> +int nvmem_mmio_probe(struct platform_device *pdev)
>> +{
>> +
> [...]
>> +
>> +	platform_set_drvdata(pdev, nvmem);
>
> It may be better to return the nvmem device instead so that the one
> drvdata member is usable by the calling driver.
Makes sense.. I will give it a try.

>
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(nvmem_mmio_probe);
>
> Kernel-doc on these exported functions?
Yep, thanks for spotting, I will fix it.
>
>> diff --git a/drivers/nvmem/nvmem-mmio.h b/drivers/nvmem/nvmem-mmio.h
>> new file mode 100644
>> index 0000000..a2ad4e5
>> --- /dev/null
>> +++ b/drivers/nvmem/nvmem-mmio.h
>> @@ -0,0 +1,41 @@
>> +/*
>> + * MMIO based nvmem providers.
>> + *
>> + * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> + *
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2.  This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
>> +#ifndef _LINUX_NVMEM_MMIO_H
>> +#define _LINUX_NVMEM_MMIO_H
>> +
>> +#include <linux/platform_device.h>
>
> Forward declare struct platform_device instead.
>
>> +#include <linux/nvmem-provider.h>
>
> Forward declare nvmem_config instead.
>
>> +#include <linux/regmap.h>
>
> Forward declare regmap_config instead.
>
>> +
>> +struct nvmem_mmio_data {
>> +	struct regmap_config *regmap_config;
>> +	struct nvmem_config *nvmem_config;
>> +};
>> +
>> +#if IS_ENABLED(CONFIG_NVMEM)
>> +
>> +int nvmem_mmio_probe(struct platform_device *pdev);
>> +int nvmem_mmio_remove(struct platform_device *pdev);
>
