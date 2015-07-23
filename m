From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v8 8/9] nvmem: sunxi: Move the SID driver to the nvmem
 framework
Date: Thu, 23 Jul 2015 16:48:54 +0100
Message-ID: <55B10CE6.2080001@linaro.org>
References: <1437403352-4091-1-git-send-email-srinivas.kandagatla@linaro.org> <1437403462-4432-1-git-send-email-srinivas.kandagatla@linaro.org> <55B105B6.7000502@i2se.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55B105B6.7000502-eS4NqCHxEME@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 23/07/15 16:18, Stefan Wahren wrote:
> Hi Srinivas,
>
> Am 20.07.2015 um 16:44 schrieb Srinivas Kandagatla:
>> From: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
>>
>> Now that we have the nvmem framework, we can consolidate the common
>> driver code. Move the driver to the framework, and hopefully, it will
>> fix the sysfs file creation race.
>>
>> Signed-off-by: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
>> [srinivas.kandagatla: Moved to regmap based EEPROM framework]
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>   Documentation/ABI/testing/sysfs-driver-sunxi-sid   |  22 ---
>>   .../bindings/misc/allwinner,sunxi-sid.txt          |  17 ---
>>   .../bindings/nvmem/allwinner,sunxi-sid.txt         |  21 +++
>>   drivers/misc/eeprom/Kconfig                        |  13 --
>>   drivers/misc/eeprom/Makefile                       |   1 -
>>   drivers/misc/eeprom/sunxi_sid.c                    | 156 --------------------
>>   drivers/nvmem/Kconfig                              |  11 ++
>>   drivers/nvmem/Makefile                             |   2 +
>>   drivers/nvmem/sunxi_sid.c                          | 159 +++++++++++++++++++++
>>   9 files changed, 193 insertions(+), 209 deletions(-)
>>   delete mode 100644 Documentation/ABI/testing/sysfs-driver-sunxi-sid
>>   delete mode 100644 Documentation/devicetree/bindings/misc/allwinner,sunxi-sid.txt
>>   create mode 100644 Documentation/devicetree/bindings/nvmem/allwinner,sunxi-sid.txt
>>   delete mode 100644 drivers/misc/eeprom/sunxi_sid.c
>>   create mode 100644 drivers/nvmem/sunxi_sid.c
>>
>> [...]
>> diff --git a/drivers/nvmem/Makefile b/drivers/nvmem/Makefile
>> index ff44fe9..4328b93 100644
>> --- a/drivers/nvmem/Makefile
>> +++ b/drivers/nvmem/Makefile
>> @@ -8,3 +8,5 @@ nvmem_core-y			:= core.o
>>   # Devices
>>   obj-$(CONFIG_QCOM_QFPROM)	+= nvmem_qfprom.o
>>   nvmem_qfprom-y			:= qfprom.o
>> +obj-$(CONFIG_NVMEM_SUNXI_SID)	+= nvmem_sunxi_sid.o
>> +nvmem_sunxi_sid-y		:= sunxi_sid.o
>
> is it really necessary to have 2 lines for a single driver?
>
> Why not the following line?
>
> obj-$(CONFIG_NVMEM_SUNXI_SID)	+= sunxi_sid.o
>
We can do that, but only reason i did it this way is to make the module 
naming consistent like nvmem_*.ko

--srini

> Regards
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
