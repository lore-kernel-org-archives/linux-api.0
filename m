From: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v8 1/9] nvmem: Add a simple NVMEM framework for nvmem
 providers
Date: Mon, 20 Jul 2015 14:11:46 -0700
Message-ID: <55AD6412.9070205@codeaurora.org>
References: <1437403352-4091-1-git-send-email-srinivas.kandagatla@linaro.org> <1437403392-4136-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437403392-4136-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, stefan.wahren-eS4NqCHxEME@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 07/20/2015 07:43 AM, Srinivas Kandagatla wrote:
> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
> new file mode 100644
> index 0000000..bde5528
> --- /dev/null
> +++ b/drivers/nvmem/core.c
> @@ -0,0 +1,384 @@
>
> +
> +static int nvmem_add_cells(struct nvmem_device *nvmem,
> +			   const struct nvmem_config *cfg)
> +{
> +	struct nvmem_cell **cells;
> +	const struct nvmem_cell_info *info = cfg->cells;
> +	int i, rval;
> +
> +	cells = kzalloc(sizeof(*cells) * cfg->ncells, GFP_KERNEL);

kcalloc?

> +	if (!cells)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < cfg->ncells; i++) {
> +		cells[i] = kzalloc(sizeof(**cells), GFP_KERNEL);
> +		if (!cells[i]) {
> +			rval = -ENOMEM;
> +			goto err;
> +		}
> +
> +		rval = nvmem_cell_info_to_nvmem_cell(nvmem, &info[i], cells[i]);
> +		if (IS_ERR_VALUE(rval)) {
> +			kfree(cells[i]);
> +			goto err;
> +		}
> +
> +		nvmem_cell_add(cells[i]);
> +	}
> +
> +	nvmem->ncells = cfg->ncells;
> +	/* remove tmp array */
> +	kfree(cells);
> +
> +	return 0;
> +err:
> +	while (--i)
> +		nvmem_cell_drop(cells[i]);
> +
> +	return rval;
> +}
> +
> +/**
> + * nvmem_register() - Register a nvmem device for given nvmem_config.
> + * Also creates an binary entry in /sys/bus/nvmem/devices/dev-name/nvmem
> + *
> + * @config: nvmem device configuration with which nvmem device is created.
> + *
> + * Return: Will be an ERR_PTR() on error or a valid pointer to nvmem_device
> + * on success.
> + */
> +

Why the newline?

> +struct nvmem_device *nvmem_register(const struct nvmem_config *config)
> +{
> +	struct nvmem_device *nvmem;
> +	struct device_node *np;
> +	struct regmap *rm;
> +	int rval;
> +
> +	if (!config->dev)
> +		return ERR_PTR(-EINVAL);
> +
> +	rm = dev_get_regmap(config->dev, NULL);
> +	if (!rm) {
> +		dev_err(config->dev, "Regmap not found\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	nvmem = kzalloc(sizeof(*nvmem), GFP_KERNEL);
> +	if (!nvmem)
> +		return ERR_PTR(-ENOMEM);
> +
> +	nvmem->id = ida_simple_get(&nvmem_ida, 0, 0, GFP_KERNEL);
> +	if (nvmem->id < 0) {
> +		kfree(nvmem);
> +		return ERR_PTR(nvmem->id);

Oops, we already freed nvmem.

> +	}
> +
> +	nvmem->regmap = rm;
> +	nvmem->owner = config->owner;
> +	nvmem->stride = regmap_get_reg_stride(rm);
> +	nvmem->word_size = regmap_get_val_bytes(rm);
> +	nvmem->size = regmap_get_max_register(rm) + nvmem->stride;
> +	nvmem->dev.type = &nvmem_provider_type;
> +	nvmem->dev.bus = &nvmem_bus_type;
> +	nvmem->dev.parent = config->dev;
> +	np = config->dev->of_node;
> +	nvmem->dev.of_node = np;
> +	dev_set_name(&nvmem->dev, "%s%d",
> +		     config->name ? : "nvmem", config->id);
> +
> +	nvmem->read_only = np ? of_property_read_bool(np, "read-only") : 0;

of_property_read_bool(NULL, ..) "does the right thing" and returns false 
already.

> +
> +	nvmem->read_only |= config->read_only;
> +
> +	device_initialize(&nvmem->dev);
> +
> +	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
> +
> +	rval = device_add(&nvmem->dev);
> +	if (rval) {
> +		ida_simple_remove(&nvmem_ida, nvmem->id);
> +		kfree(nvmem);
> +		return ERR_PTR(rval);
> +	}
> +
> +	if (device_create_bin_file(&nvmem->dev,
> +				nvmem->read_only ? &bin_attr_ro_nvmem :
> +				&bin_attr_rw_nvmem))
> +		dev_warn(&nvmem->dev, "Failed to create sysfs binary file\n");

Why can't we have device_add() add the binary file attribute too?

> +
> +	if (config->cells)
> +		nvmem_add_cells(nvmem, config);
> +
> +	return nvmem;
> +}
> +EXPORT_SYMBOL_GPL(nvmem_register);
> +
> +/**
> + * nvmem_unregister() - Unregister previously registered nvmem device
> + *
> + * @nvmem: Pointer to previously registered nvmem device.
> + *
> + * Return: Will be an negative on error or a zero on success.
> + */
> +int nvmem_unregister(struct nvmem_device *nvmem)
> +{
> +	mutex_lock(&nvmem_mutex);
> +	if (nvmem->users) {
> +		mutex_unlock(&nvmem_mutex);
> +		return -EBUSY;
> +	}
> +	mutex_unlock(&nvmem_mutex);

This lock doesn't seem to be doing anything in this patch? Perhaps it 
should be added in the second patch where consumers start making it useful?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
