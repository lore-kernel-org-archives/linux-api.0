From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 3/9] nvmem: Add nvmem_device based consumer apis.
Date: Wed, 15 Jul 2015 09:21:19 +0100
Message-ID: <55A617FF.2030904@linaro.org>
References: <1436521427-10568-1-git-send-email-srinivas.kandagatla@linaro.org> <1436521505-10779-1-git-send-email-srinivas.kandagatla@linaro.org> <20150714220607.GP30412@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150714220607.GP30412-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, stefan.wahren-eS4NqCHxEME@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Thanks Stephen,

On 14/07/15 23:06, Stephen Boyd wrote:
> On 07/10, Srinivas Kandagatla wrote:
>> +static int devm_nvmem_device_match(struct device *dev, void *res, void *data)
>> +{
>> +	struct nvmem_device **nvmem = res;
>> +
>> +	if (!nvmem || !*nvmem) {
>> +		WARN_ON(!nvmem || !*nvmem);
>
> This could be
>
> 	if (WARN_ON(!nvmem || !*nvmem))
>
Yep, will fix it.
>> +		return 0;
>> +	}
>> +	return *nvmem == data;
>> +}
>> +
>> [..]
>> +
>> +/**
>> + * nvmem_device_write() - Write cell to a given nvmem device
>> + *
>> + * @nvmem: nvmem device to be written to.
>> + * @offset: offset in nvmem device.
>> + * @bytes: number of bytes to write.
>> + * @buf: buffer to be written.
>> + *
>> + * The return value will be an length of bytes written or non zero on failure.
>
> Should say negative value instead of non-zero? Length is
> non-zero already.
>
> General nitpick comment: Kernel-doc allows for a standard return
> syntax.
Ok, I will fix such instances.
>
> 	Return: length of bytes written or negative value on failure.
>
>> diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
>> index f589d3b..74eed42 100644
>> --- a/include/linux/nvmem-provider.h
>> +++ b/include/linux/nvmem-provider.h
>> @@ -12,15 +12,9 @@
>>   #ifndef _LINUX_NVMEM_PROVIDER_H
>>   #define _LINUX_NVMEM_PROVIDER_H
>>
>> -struct nvmem_device;
>> +#include <linux/nvmem-consumer.h>
>>
>> -struct nvmem_cell_info {
>> -	const char		*name;
>> -	int			offset;
>> -	int			bytes;
>> -	int			bit_offset;
>> -	int			nbits;
>> -};
>
> Why does this move from provider to consumer? Can't we do put
> this struct in the right place from the beginning?
>
  I will take care of it in next version.

--srini
>> +struct nvmem_device;
>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
