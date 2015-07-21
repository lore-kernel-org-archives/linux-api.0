From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v8 1/9] nvmem: Add a simple NVMEM framework for nvmem
 providers
Date: Tue, 21 Jul 2015 10:41:44 +0100
Message-ID: <55AE13D8.6020301@linaro.org>
References: <1437403352-4091-1-git-send-email-srinivas.kandagatla@linaro.org> <1437403392-4136-1-git-send-email-srinivas.kandagatla@linaro.org> <55AD6412.9070205@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55AD6412.9070205@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, pantelis.antoniou@konsulko.com, mporter@konsulko.com, stefan.wahren@i2se.com, wxt@rock-chips.com, Maxime Ripard <maxime.ripard@free-electrons.com>
List-Id: linux-api@vger.kernel.org

Thanks Stephen for review,

On 20/07/15 22:11, Stephen Boyd wrote:
> On 07/20/2015 07:43 AM, Srinivas Kandagatla wrote:
>> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
>> new file mode 100644
>> index 0000000..bde5528
>> --- /dev/null
>> +++ b/drivers/nvmem/core.c
>> @@ -0,0 +1,384 @@
>>
>> +
>> +static int nvmem_add_cells(struct nvmem_device *nvmem,
>> +               const struct nvmem_config *cfg)
>> +{
>> +    struct nvmem_cell **cells;
>> +    const struct nvmem_cell_info *info = cfg->cells;
>> +    int i, rval;
>> +
>> +    cells = kzalloc(sizeof(*cells) * cfg->ncells, GFP_KERNEL);
>
> kcalloc?

Only reason for using kzalloc is to give the code more flexibility to 
free any pointer in the array in case of errors.

>
>> +    if (!cells)
>> +        return -ENOMEM;
>> +
>> +    for (i = 0; i < cfg->ncells; i++) {
>> +        cells[i] = kzalloc(sizeof(**cells), GFP_KERNEL);
>> +        if (!cells[i]) {
>> +            rval = -ENOMEM;
>> +            goto err;
>> +        }
>> +
>> +        rval = nvmem_cell_info_to_nvmem_cell(nvmem, &info[i], cells[i]);
>> +        if (IS_ERR_VALUE(rval)) {
>> +            kfree(cells[i]);
>> +            goto err;
>> +        }
>> +
>> +        nvmem_cell_add(cells[i]);
>> +    }
>> +
>> +    nvmem->ncells = cfg->ncells;
>> +    /* remove tmp array */
>> +    kfree(cells);
>> +
>> +    return 0;
>> +err:
>> +    while (--i)
>> +        nvmem_cell_drop(cells[i]);
>> +
>> +    return rval;
>> +}
>> +
>> +/**
>> + * nvmem_register() - Register a nvmem device for given nvmem_config.
>> + * Also creates an binary entry in /sys/bus/nvmem/devices/dev-name/nvmem
>> + *
>> + * @config: nvmem device configuration with which nvmem device is
>> created.
>> + *
>> + * Return: Will be an ERR_PTR() on error or a valid pointer to
>> nvmem_device
>> + * on success.
>> + */
>> +
>
> Why the newline?
Yep, fixed it now.

>
>> +struct nvmem_device *nvmem_register(const struct nvmem_config *config)
>> +{
>> +    struct nvmem_device *nvmem;
>> +    struct device_node *np;
>> +    struct regmap *rm;
>> +    int rval;
>> +
>> +    if (!config->dev)
>> +        return ERR_PTR(-EINVAL);
>> +
>> +    rm = dev_get_regmap(config->dev, NULL);
>> +    if (!rm) {
>> +        dev_err(config->dev, "Regmap not found\n");
>> +        return ERR_PTR(-EINVAL);
>> +    }
>> +
>> +    nvmem = kzalloc(sizeof(*nvmem), GFP_KERNEL);
>> +    if (!nvmem)
>> +        return ERR_PTR(-ENOMEM);
>> +
>> +    nvmem->id = ida_simple_get(&nvmem_ida, 0, 0, GFP_KERNEL);
>> +    if (nvmem->id < 0) {
>> +        kfree(nvmem);
>> +        return ERR_PTR(nvmem->id);
>
> Oops, we already freed nvmem.
>
Oops, Fixed this one too.

>> +    }
>> +
>> +    nvmem->regmap = rm;
>> +    nvmem->owner = config->owner;
>> +    nvmem->stride = regmap_get_reg_stride(rm);
>> +    nvmem->word_size = regmap_get_val_bytes(rm);
>> +    nvmem->size = regmap_get_max_register(rm) + nvmem->stride;
>> +    nvmem->dev.type = &nvmem_provider_type;
>> +    nvmem->dev.bus = &nvmem_bus_type;
>> +    nvmem->dev.parent = config->dev;
>> +    np = config->dev->of_node;
>> +    nvmem->dev.of_node = np;
>> +    dev_set_name(&nvmem->dev, "%s%d",
>> +             config->name ? : "nvmem", config->id);
>> +
>> +    nvmem->read_only = np ? of_property_read_bool(np, "read-only") : 0;
>
> of_property_read_bool(NULL, ..) "does the right thing" and returns false
> already.
thanks, that should make this more simple.
>
>> +
>> +    nvmem->read_only |= config->read_only;
>> +
>> +    device_initialize(&nvmem->dev);
>> +
>> +    dev_dbg(&nvmem->dev, "Registering nvmem device %s\n", config->name);
>> +
>> +    rval = device_add(&nvmem->dev);
>> +    if (rval) {
>> +        ida_simple_remove(&nvmem_ida, nvmem->id);
>> +        kfree(nvmem);
>> +        return ERR_PTR(rval);
>> +    }
>> +
>> +    if (device_create_bin_file(&nvmem->dev,
>> +                nvmem->read_only ? &bin_attr_ro_nvmem :
>> +                &bin_attr_rw_nvmem))
>> +        dev_warn(&nvmem->dev, "Failed to create sysfs binary file\n");
>
> Why can't we have device_add() add the binary file attribute too?
>
Yes we can set dev.groups directly before device_add, I did this change too.
>> +
>> +    if (config->cells)
>> +        nvmem_add_cells(nvmem, config);
>> +
>> +    return nvmem;
>> +}
>> +EXPORT_SYMBOL_GPL(nvmem_register);
>> +
>> +/**
>> + * nvmem_unregister() - Unregister previously registered nvmem device
>> + *
>> + * @nvmem: Pointer to previously registered nvmem device.
>> + *
>> + * Return: Will be an negative on error or a zero on success.
>> + */
>> +int nvmem_unregister(struct nvmem_device *nvmem)
>> +{
>> +    mutex_lock(&nvmem_mutex);
>> +    if (nvmem->users) {
>> +        mutex_unlock(&nvmem_mutex);
>> +        return -EBUSY;
>> +    }
>> +    mutex_unlock(&nvmem_mutex);
>
> This lock doesn't seem to be doing anything in this patch? Perhaps it
> should be added in the second patch where consumers start making it useful?
Ok, make sense. I moved this too.
I have v9 ready will send it.

--srini
>
