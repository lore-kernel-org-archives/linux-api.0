From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v7 3/9] nvmem: Add nvmem_device based consumer apis.
Date: Fri, 10 Jul 2015 03:49:25 -0700
Message-ID: <1436525365.24866.36.camel@perches.com>
References: <1436521427-10568-1-git-send-email-srinivas.kandagatla@linaro.org>
	 <1436521505-10779-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436521505-10779-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, stefan.wahren-eS4NqCHxEME@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 2015-07-10 at 10:45 +0100, Srinivas Kandagatla wrote:
> This patch adds read/write apis which are based on nvmem_device.

More trivia:

> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c

> +static struct nvmem_device *nvmem_find(const char *name)
> +{
> +	struct device *d;
> +
> +	d = bus_find_device(&nvmem_bus_type, NULL, (void *)name, nvmem_match);
> +
> +	return d ? to_nvmem_device(d) : NULL;

Maybe:
	d = bus_find_device(...);
	if (!d)
		return NULL;

	return to_nvmem_device(d);

> +struct nvmem_device *of_nvmem_device_get(struct device_node *np, const char *id)
> +{
[]
> +	return __nvmem_device_get(nvmem_np, NULL, NULL);
> +

odd blank line
> +}
> +EXPORT_SYMBOL_GPL(of_nvmem_device_get);

> +struct nvmem_device *nvmem_device_get(struct device *dev, const char *dev_name)
> +{
[]
> +	return nvmem_find(dev_name);
> +

here too

> +}
> +EXPORT_SYMBOL_GPL(nvmem_device_get);

[]

> +void devm_nvmem_device_put(struct device *dev, struct nvmem_device *nvmem)
> +{
> +	int ret;
> +
> +	ret = devres_release(dev, devm_nvmem_device_release,
> +			     devm_nvmem_device_match, nvmem);
> +
> +	WARN_ON(ret);
> +

Last unnecessary blank line I'll mention
(it seems to be the last one anyway)

> +}
> +EXPORT_SYMBOL_GPL(devm_nvmem_device_put);
