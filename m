From: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v7 3/9] nvmem: Add nvmem_device based consumer apis.
Date: Tue, 14 Jul 2015 15:06:07 -0700
Message-ID: <20150714220607.GP30412@codeaurora.org>
References: <1436521427-10568-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1436521505-10779-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436521505-10779-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, pantelis.antoniou@konsulko.com, mporter@konsulko.com, stefan.wahren@i2se.com, wxt@rock-chips.com
List-Id: linux-api@vger.kernel.org

On 07/10, Srinivas Kandagatla wrote:
> +static int devm_nvmem_device_match(struct device *dev, void *res, void *data)
> +{
> +	struct nvmem_device **nvmem = res;
> +
> +	if (!nvmem || !*nvmem) {
> +		WARN_ON(!nvmem || !*nvmem);

This could be

	if (WARN_ON(!nvmem || !*nvmem))

> +		return 0;
> +	}
> +	return *nvmem == data;
> +}
> +
> [..]
> +
> +/**
> + * nvmem_device_write() - Write cell to a given nvmem device
> + *
> + * @nvmem: nvmem device to be written to.
> + * @offset: offset in nvmem device.
> + * @bytes: number of bytes to write.
> + * @buf: buffer to be written.
> + *
> + * The return value will be an length of bytes written or non zero on failure.

Should say negative value instead of non-zero? Length is
non-zero already.

General nitpick comment: Kernel-doc allows for a standard return
syntax.

	Return: length of bytes written or negative value on failure.

> diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
> index f589d3b..74eed42 100644
> --- a/include/linux/nvmem-provider.h
> +++ b/include/linux/nvmem-provider.h
> @@ -12,15 +12,9 @@
>  #ifndef _LINUX_NVMEM_PROVIDER_H
>  #define _LINUX_NVMEM_PROVIDER_H
>  
> -struct nvmem_device;
> +#include <linux/nvmem-consumer.h>
>  
> -struct nvmem_cell_info {
> -	const char		*name;
> -	int			offset;
> -	int			bytes;
> -	int			bit_offset;
> -	int			nbits;
> -};

Why does this move from provider to consumer? Can't we do put
this struct in the right place from the beginning?

> +struct nvmem_device;

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
