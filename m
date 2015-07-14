From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 6/9] nvmem: qfprom: Add Qualcomm QFPROM support.
Date: Tue, 14 Jul 2015 23:02:53 +0100
Message-ID: <55A5870D.3070802@linaro.org>
References: <1436521427-10568-1-git-send-email-srinivas.kandagatla@linaro.org> <1436521529-10931-1-git-send-email-srinivas.kandagatla@linaro.org> <20150714211831.GN30412@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150714211831.GN30412-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, stefan.wahren-eS4NqCHxEME@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org
List-Id: linux-api@vger.kernel.org


Thanks Stephen for the comments.

On 14/07/15 22:18, Stephen Boyd wrote:
> On 07/10, Srinivas Kandagatla wrote:
>> This patch adds QFPROM support driver which is used by other drivers
>> like thermal sensor and cpufreq.
>>
>> On MSM parts there are some efuses (called qfprom) these fuses store
>> things like calibration data, speed bins.. etc. Drivers like cpufreq,
>> thermal sensors would read out this data for configuring the driver.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>
> I didn't see any reply on v6, but at least delay.h was removed.
> Same comments from v6 below.
Sorry I think I forgot to reply you on v6.
>
>> diff --git a/drivers/nvmem/qfprom.c b/drivers/nvmem/qfprom.c
>> new file mode 100644
>> index 0000000..0e22a03
>> --- /dev/null
>> +++ b/drivers/nvmem/qfprom.c
>> @@ -0,0 +1,87 @@
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
>> +#include <linux/io.h>
>
> Is this include used?
No, I don't think so, I will remove it.

>
>> +#include <linux/module.h>
>> +#include <linux/nvmem-provider.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/regmap.h>
>> +#include <linux/slab.h>
>> +
>> +static struct regmap_config qfprom_regmap_config = {
>
> Can this be const?
No, regmap config max_register is updated in the probe so we cant have 
this as constant.
>
>> +	.reg_bits = 32,
>> +	.val_bits = 8,
>> +	.reg_stride = 1,
>> +};
>> +
>> +static struct nvmem_config econfig = {
>
> Can this be const?
>
Same here, dev pointer is updated in probe so we can't make this constant.
>> +	.name = "qfprom",
>> +	.owner = THIS_MODULE,
>> +};
>> +
>
