From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v8 6/9] nvmem: qfprom: Add Qualcomm QFPROM support.
Date: Tue, 21 Jul 2015 10:42:52 +0100
Message-ID: <55AE141C.8000802@linaro.org>
References: <1437403352-4091-1-git-send-email-srinivas.kandagatla@linaro.org> <1437403445-4348-1-git-send-email-srinivas.kandagatla@linaro.org> <55AD6636.4050302@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <55AD6636.4050302@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, pantelis.antoniou@konsulko.com, mporter@konsulko.com, stefan.wahren@i2se.com, wxt@rock-chips.com
List-Id: linux-api@vger.kernel.org



On 20/07/15 22:20, Stephen Boyd wrote:
> On 07/20/2015 07:44 AM, Srinivas Kandagatla wrote:
>> This patch adds QFPROM support driver which is used by other drivers
>> like thermal sensor and cpufreq.
>>
>> On MSM parts there are some efuses (called qfprom) these fuses store
>> things like calibration data, speed bins.. etc. Drivers like cpufreq,
>> thermal sensors would read out this data for configuring the driver.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>
> One comment below, otherwise
>
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
>
Thanks for review,  I will send v9 by removing slab.h.

>> diff --git a/drivers/nvmem/qfprom.c b/drivers/nvmem/qfprom.c
>> new file mode 100644
>> index 0000000..ba5e2b4
>> --- /dev/null
>> +++ b/drivers/nvmem/qfprom.c
>> @@ -0,0 +1,86 @@
>> +/*
>> + * Copyright (C) 2015 Srinivas Kandagatla
>> <srinivas.kandagatla@linaro.org>
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
>> +#include <linux/nvmem-provider.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/regmap.h>
>> +#include <linux/slab.h>
>
> This include is used?
>
