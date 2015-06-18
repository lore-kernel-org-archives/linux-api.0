From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 03/11] nvmem: Add a simple NVMEM framework for nvmem
 providers
Date: Thu, 18 Jun 2015 13:46:38 +0100
Message-ID: <5582BDAE.5040008@linaro.org>
References: <1432226535-8640-1-git-send-email-srinivas.kandagatla@linaro.org> <1432226583-8775-1-git-send-email-srinivas.kandagatla@linaro.org> <5580A678.4080304@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5580A678.4080304-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Many thanks for review.

On 16/06/15 23:43, Stephen Boyd wrote:
> On 05/21/2015 09:43 AM, Srinivas Kandagatla wrote:
>>
>> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
>> new file mode 100644
>> index 0000000..6c2f0b1
>> --- /dev/null
>> +++ b/drivers/nvmem/core.c
>> @@ -0,0 +1,398 @@
>> +/*
>> + * nvmem framework core.
>> + *
>> + * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> + * Copyright (C) 2013 Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
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
>> +#include <linux/nvmem-provider.h>
>> +#include <linux/export.h>
>> +#include <linux/fs.h>
>> +#include <linux/idr.h>
>> +#include <linux/init.h>
>> +#include <linux/regmap.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/slab.h>
>> +#include <linux/uaccess.h>
>
> Is this include used?
>
Yep, not required.
>> +
>> +static int of_nvmem_match(struct device *dev, const void *nvmem_np)
>> +{
>> +	return dev->of_node == nvmem_np;
>> +}
>> +
>> +static struct nvmem_device *of_nvmem_find(struct device_node *nvmem_np)
>
> const?
Sure,
>
>> +{
>> +	struct device *d;
>> +
>> +	if (!nvmem_np)
>> +		return NULL;
>> +
>> +	d = class_find_device(&nvmem_class, NULL, nvmem_np, of_nvmem_match);
>> +
>> +	return d ? to_nvmem_device(d) : NULL;
>> +}
>> +
>> +static struct nvmem_cell *nvmem_find_cell(const char *cell_id)
>> +{
>> +	struct nvmem_cell *p;
>> +
>> +	list_for_each_entry(p, &nvmem_cells, node) {
>
> Unnecessary braces.
Yep, Will remove it.
>
>> +		if (p && !strcmp(p->name, cell_id))
>> +			return p;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +static void nvmem_cell_drop(struct nvmem_cell *cell)
>> +{
>> +	mutex_lock(&nvmem_cells_mutex);
>> +	list_del(&cell->node);
>> +	mutex_unlock(&nvmem_cells_mutex);
>> +	kfree(cell);
>> +}
>> +
>> +static void nvmem_device_remove_all_cells(struct nvmem_device *nvmem)
>> +{
>> +	struct nvmem_cell *cell = NULL;
>
> Unnecessary initialization
Yes.
>
>> +	struct list_head *p, *n;
>> +
>> +	list_for_each_safe(p, n, &nvmem_cells) {
>> +		cell = list_entry(p, struct nvmem_cell, node);
>> +		if (cell->nvmem == nvmem)
>> +			nvmem_cell_drop(cell);
>> +	}
> [..]
>> +
>> +static int nvmem_add_cells(struct nvmem_device *nvmem,
>> +			   struct nvmem_config *cfg)
>> +{
>> +	struct nvmem_cell **cells;
>> +	struct nvmem_cell_info *info = cfg->cells;
>> +	int i, rval;
>> +
>> +	cells = kzalloc(sizeof(*cells) * cfg->ncells, GFP_KERNEL);
>
> kcalloc
This is temporary array, I did this on intention, to make it easy to 
kfree cells which are found invalid at runtime.
>
>> +	if (!cells)
>> +		return -ENOMEM;
>> +
>> +	for (i = 0; i < cfg->ncells; i++) {
>> +		cells[i] = kzalloc(sizeof(struct nvmem_cell), GFP_KERNEL);
>
> sizeof(**cells) ?
Yep.

>
>> +
>> +/**
>> + * nvmem_register(): Register a nvmem device for given nvmem.
>> + * Also creates an binary entry in /sys/class/nvmem/dev-name/nvmem
>> + *
>> + * @nvmem: nvmem device that needs to be created
>
> You mean @config?
>
Yes, I will fix it.

>> + *
>> + * The return value will be an ERR_PTR() on error or a valid pointer
>> +	nvmem->dev.of_node = config->dev->of_node;
>> +	dev_set_name(&nvmem->dev, "%s%d",
>> +		     config->name ? : "nvmem", config->id);
>
> It may be better to always name it nvmem%d so that we don't allow the
> possibility of conflicts.
We can do that, but I wanted to make the sysfs and dev entries more 
readable than just nvmem0, nvmem1...
>
>> +
>> +	nvmem->read_only = of_property_read_bool(nvmem->dev.of_node,
>> +						 "read-only");
>
> What if we're not using DT? How would we specify read_only?
>
Thanks for spotting, you are correct, I need to add read_only flag to 
nvmem_config too.


>> +
>> +	device_initialize(&nvmem->dev);
>> +
>> +	dev_dbg(&nvmem->dev, "Registering nvmem device %s\n",
>> +		dev_name(&nvmem->dev));
>> +
>> +	rval = device_add(&nvmem->dev);
>> +	if (rval) {
>> +		ida_simple_remove(&nvmem_ida, nvmem->id);
>> +		kfree(nvmem);
>> +		return ERR_PTR(rval);
>> +	}
>> +
>> +	/* update sysfs attributes */
>> +	if (nvmem->read_only)
>> +		sysfs_update_group(&nvmem->dev.kobj, &nvmem_bin_ro_group);
>
> It would be nice if this could be done before the device was registered.
> Perhaps have two device_types, one for read-only and one for read/write?

The attributes are actually coming from the class object, so we have no 
choice to update the attributes before the device is registered.

May it would be more safe to have default as read-only and modify it to 
read/write based on read-only flag?


>
>> +
>> + */
>> +int nvmem_unregister(struct nvmem_device *nvmem)
>> +{
>> +	mutex_lock(&nvmem_mutex);
>> +	if (nvmem->users) {
>> +		mutex_unlock(&nvmem_mutex);
>> +		return -EBUSY;
>
> Hmm... that doesn't seem nice. Typically when something is unregistered
> we have to pull the rug out from underneath the users and start
> returning errors to them. The provider needs to be free to unregister
> because it's been forcibly removed. So really this function should
> return void.
>
The consumer api is get/put style, so consumers who already have 
references to the provider, removing provider forcefully might lead to 
dangling pointer. Having said that I can give a try and see how it looks.

>> +	}
>> +	mutex_unlock(&nvmem_mutex);
>> +
>> +	nvmem_device_remove_all_cells(nvmem);
>> +	device_del(&nvmem->dev);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(nvmem_unregister);
>> +
>> +static int nvmem_init(void)
>
> __init? And __exit on nvmem_exit?
yep, will do that.
>
>> +{
>> +	return class_register(&nvmem_class);
>
> I thought class was on the way out? Aren't we supposed to use bus types
> for new stuff?
Do you remember any conversation on the list about this? I could not 
find it on web.

on the other hand, nvmem is not really a bus, making it a bus type 
sounds incorrect to me.


--srini

>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
