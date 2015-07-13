From: Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Subject: Re: [PATCH v7 1/9] nvmem: Add a simple NVMEM framework for nvmem
 providers
Date: Mon, 13 Jul 2015 18:50:29 +0200
Message-ID: <1436806229.11945.5.camel@pengutronix.de>
References: <1436521427-10568-1-git-send-email-srinivas.kandagatla@linaro.org>
	 <1436521486-10682-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436521486-10682-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, stefan.wahren-eS4NqCHxEME@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Srinivas,

Am Freitag, den 10.07.2015, 10:44 +0100 schrieb Srinivas Kandagatla:
> This patch adds just providers part of the framework just to enable easy
> review.
[...]
> +/**
> + * nvmem_register() - Register a nvmem device for given nvmem_config.
> + * Also creates an binary entry in /sys/bus/nvmem/devices/dev-name/nvmem
> + *
> + * @config: nvmem device configuration with which nvmem device is created.
> + *
> + * The return value will be an ERR_PTR() on error or a valid pointer
> + * to nvmem_device.
> + */
> +
> +struct nvmem_device *nvmem_register(struct nvmem_config *config)
> +{
[...]
> +	nvmem->read_only = nvmem->dev.of_node ?
> +				of_property_read_bool(nvmem->dev.of_node,
> +				"read-only") :
> +				config->read_only;

I think read_only should be set if any of the device node property or
nvmem_config->read_only request it. That way, even if the nvmem is
theoretically writeable (no read-only property in DT), the driver still
can make it read-only if writing isn't implemented:

+	nvmem->read_only = nvmem->dev.of_node ?
+				of_property_read_bool(nvmem->dev.of_node,
+				"read-only") : 0;
+	nvmem->read_only |= config->read_only;

[...]
> new file mode 100644
> index 0000000..f589d3b
> --- /dev/null
> +++ b/include/linux/nvmem-provider.h
[...]
> +struct nvmem_config {
> +	struct device		*dev;
> +	const char		*name;
> +	int			id;
> +	struct module		*owner;
> +	struct nvmem_cell_info	*cells;

Should that be const?

> +	int			ncells;
> +	bool			read_only;
> +};
> +
> +#if IS_ENABLED(CONFIG_NVMEM)
> +
> +struct nvmem_device *nvmem_register(struct nvmem_config *cfg);

Then that could be made const, too.

best regards
Philipp
