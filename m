From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v5 10/11] nvmem: sunxi: Move the SID driver to the nvmem
 framework
Date: Thu, 18 Jun 2015 14:09:52 +0100
Message-ID: <5582C320.40605@linaro.org>
References: <1432226535-8640-1-git-send-email-srinivas.kandagatla@linaro.org> <1432226733-9243-1-git-send-email-srinivas.kandagatla@linaro.org> <5580AB72.6010909@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5580AB72.6010909@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, pantelis.antoniou@konsulko.com, mporter@konsulko.com
List-Id: linux-api@vger.kernel.org



On 17/06/15 00:04, Stephen Boyd wrote:
> On 05/21/2015 09:45 AM, Srinivas Kandagatla wrote:
>> diff --git a/drivers/nvmem/Makefile b/drivers/nvmem/Makefile
>> index caea611..cc46791 100644
>> --- a/drivers/nvmem/Makefile
>> +++ b/drivers/nvmem/Makefile
>> @@ -9,3 +9,5 @@ nvmem_core-y			+= nvmem-mmio.o
>>   # Devices
>>   obj-$(CONFIG_QCOM_QFPROM)	+= nvmem_qfprom.o
>>   nvmem_qfprom-y			:= qfprom.o
>> +obj-$(CONFIG_NVMEM_SUNXI_SID)	+= nvmem-sunxi-sid.o
>> +nvmem-sunxi-sid-y		:= sunxi-sid.o
>
> Oh I see, so the module has nvmem- in the name. Isn't there some way to
> add a rule to do that for all provider drivers?
>
I will give it a try, and also fix the other comments on this patch.


>> diff --git a/drivers/nvmem/sunxi-sid.c b/drivers/nvmem/sunxi-sid.c
>> new file mode 100644
>> index 0000000..5bfce35
>> --- /dev/null
>> +++ b/drivers/nvmem/sunxi-sid.c
>> @@ -0,0 +1,64 @@
>> +/*
>> + * Allwinner sunXi SoCs Security ID support.
>> + *
>> + * Copyright (c) 2013 Oliver Schinagl <oliver@schinagl.nl>
>> + * Copyright (C) 2014 Maxime Ripard <maxime.ripard@free-electrons.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include "nvmem-mmio.h"
>> +
>> +static bool sunxi_sid_writeable_reg(struct device *dev, unsigned int reg)
>> +{
>> +	return false;
>> +}
>> +
>> +static struct nvmem_config econfig = {
>
> const?
>
>> +	.name = "sunix-sid",
>> +	.owner = THIS_MODULE,
>> +};
>> +
>> +static struct regmap_config sunxi_sid_regmap_config = {
>
> const?
>
>> +	.reg_bits = 32,
>> +	.val_bits = 32,
>> +	.reg_stride = 4,
>> +	.writeable_reg = sunxi_sid_writeable_reg,
>> +};
>> +
>> +static struct nvmem_mmio_data sunxi_data = {
>
> const?
>
>> +	.nvmem_config = &econfig,
>> +	.regmap_config = &sunxi_sid_regmap_config,
>> +};
>> +
>
>
