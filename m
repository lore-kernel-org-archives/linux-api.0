From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] eeprom: Add a simple EEPROM framework
Date: Fri, 20 Feb 2015 08:27:27 +0000
Message-ID: <54E6EFEF.2000200@linaro.org>
References: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org> <1424365708-26681-1-git-send-email-srinivas.kandagatla@linaro.org> <20150219181230.GC795@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150219181230.GC795-g2DYL2Zd6BY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Thanks Andrew for your comments,

On 19/02/15 18:12, Andrew Lunn wrote:
>> +
>> +Required properties:
>> +
>> +eeproms: List of phandle and data cell specifier triplet, one triplet
>> +	 for each data cell the device might be interested in. The
>> +	 triplet consists of the phandle to the eeprom provider, then
>> +	 the offset in byte within that storage device, and the length
>
> bytes
>
>> +	 in byte of the data we care about.
>
> bytes
Yep will fix it in next version.
>
>> +
>> +Optional properties:
>> +
>> +eeprom-names: List of data cell name strings sorted in the same order
>> + 	      as the resets property. Consumers drivers will use
>
> resets? I guess this text was cut/paste from the reset documentation?\
>
I think so. Will fix it.
>> + 	      eeprom-names to differentiate between multiple cells,
>> + 	      and hence being able to know what these cells are for.
>> +
>> +For example:
>> +
>> +	device {
>> +		eeproms = <&at24 14 42>;
>
> I like to use 42, but is it realistic to have a soc-rev-id which is 42
> bytes long?  How about using 42 as the offset and a sensible length of
> say 4?
Ok, will fix it..
>
>> +		eeprom-names = "soc-rev-id";
>> +menuconfig EEPROM
>> +	bool "EEPROM Support"
>> +	depends on OF
>> +	help
>> +	  Support for EEPROM alike devices.
>
> like.
Ok
>
>> +
>> +	  This framework is designed to provide a generic interface to EEPROM
>
> EPROMs
Ok.
>
>> +
>> +
>> +static ssize_t bin_attr_eeprom_read_write(struct kobject *kobj,
>> +				    char *buf, loff_t offset,
>> +				    size_t count, bool read)
>> +{
>> +	struct device *dev = container_of(kobj, struct device, kobj);
>> +	struct eeprom_device *eeprom = container_of(dev, struct eeprom_device,
>> +						    edev);
>> +	int rc;
>> +
>> +	if (offset > eeprom->size)
>> +		return 0;
>> +
>> +	if (offset + count > eeprom->size)
>> +		count = eeprom->size - offset;
>> +
>> +	if (read)
>> +		rc = regmap_bulk_read(eeprom->regmap, offset,
>> +				      buf, count/eeprom->stride);
>
> This division will round down, so you could get one less byte than
> what you expected, and the value you actually return. It seems like
> there should be a check here, the count is a multiple of stride and
> return an error if it is not.
Thats a good catch, I will fix this for other such instances too.
>
>> +	else
>> +		rc = regmap_bulk_write(eeprom->regmap, offset,
>> +				       buf, count/eeprom->stride);
>> +
>> +	if (IS_ERR_VALUE(rc))
>> +		return 0;
>> +
>
> I don't think returning 0 here, and above is the best thing to
> do. Return the real error code from regmap, or EINVAL or some other
> error code for going off the end of the eerpom.
Ok, I will fix the return value here for both the cases.

>
>> +	return count;
>> +}
>> +
>> +static ssize_t bin_attr_eeprom_read(struct file *filp, struct kobject *kobj,
>> +				    struct bin_attribute *attr,
>> +				    char *buf, loff_t offset, size_t count)
>> +{
>> +	return bin_attr_eeprom_read_write(kobj, buf, offset, count, true);
>> +}
>> +
>> +static ssize_t bin_attr_eeprom_write(struct file *filp, struct kobject *kobj,
>> +				     struct bin_attribute *attr,
>> +				     char *buf, loff_t offset, size_t count)
>> +{
>> +	return bin_attr_eeprom_read_write(kobj, buf, offset, count, false);
>> +}
>>
>
> These two functions seem to be identical. So just have one of them?

One is read and other is write.. there is a true and false flag at the 
end of the call to bin_attr_eeprom_read_write().
>
> +
>> +static struct bin_attribute bin_attr_eeprom = {
>> +	.attr	= {
>> +		.name	= "eeprom",
>> +		.mode	= 0660,
>
> Symbolic values like S_IRUGO | S_IWUSR would be better.
Yep, thats correct, I will fix it.
>
> Are you also sure you want group write?
>
S_IWUSR should be enough.

>> +	},
>> +	.read	= bin_attr_eeprom_read,
>> +	.write	= bin_attr_eeprom_write,
>> +};
>> +
>> +static struct eeprom_cell *__eeprom_cell_get(struct device_node *node,
>> +					     int index)
>> +{
>> +	struct of_phandle_args args;
>> +	struct eeprom_cell *cell;
>> +	struct eeprom_device *e, *eeprom = NULL;
>> +	int ret;
>> +
>> +	ret = of_parse_phandle_with_args(node, "eeproms",
>> +					 "#eeprom-cells", index, &args);
>> +	if (ret)
>> +		return ERR_PTR(ret);
>> +
>> +	if (args.args_count != 2)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	mutex_lock(&eeprom_list_mutex);
>> +
>> +	list_for_each_entry(e, &eeprom_list, list) {
>> +		if (args.np == e->edev.of_node) {
>> +			eeprom = e;
>> +			break;
>> +		}
>> +	}
>> +	mutex_unlock(&eeprom_list_mutex);
>
> Shouldn't you increment a reference count to the eeprom here?  You are
> going to have trouble if the eeprom is unregistered and there is a
> call still referring to it.
Yes, Stephen Byod also pointed the same, having owner in eeprom_device 
should fix this.
I will fix it in next version.

>
>> +
>> +	if (!eeprom)
>> +		return ERR_PTR(-EPROBE_DEFER);
>> +
>> +	cell = kzalloc(sizeof(*cell), GFP_KERNEL);
>> +	if (!cell)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	cell->eeprom = eeprom;
>> +	cell->offset = args.args[0];
>> +	cell->count = args.args[1];
>> +
>> +	return cell;
>> +}
>> +
>> +
>> diff --git a/include/linux/eeprom-consumer.h b/include/linux/eeprom-consumer.h
>> new file mode 100644
>> index 0000000..706ae9d
>> --- /dev/null
>> +++ b/include/linux/eeprom-consumer.h
>> @@ -0,0 +1,73 @@
>> +/*
>> + * EEPROM framework consumer.
>> + *
>> + * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> + * Copyright (C) 2013 Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
>> + *
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2.  This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
>> +#ifndef _LINUX_EEPROM_CONSUMER_H
>> +#define _LINUX_EEPROM_CONSUMER_H
>> +
>> +struct eeprom_cell;
>> +
>> +/**
>> + * eeprom_cell_get(): Get eeprom cell of device form a given index.
>
> of a device for a
>
Ok, will be fixed in next version.
>> + *
>> + * @dev: Device that will be interacted with
>> + * @index: Index of the eeprom cell.
>> + *
>> + * The return value will be an ERR_PTR() on error or a valid pointer
>> + * to a struct eeprom_cell.  The eeprom_cell will be freed by the
>> + * eeprom_cell_put().
>> + */
>> +struct eeprom_cell *eeprom_cell_get(struct device *dev, int index);
>> +
>> +/**
>> + * eeprom_cell_get(): Get eeprom cell of device form a given name.
>
> same again
Ok, will be fixed in next version.
>
>> + *
>> + * @dev: Device that will be interacted with
>> + * @name: Name of the eeprom cell.
>> + *
>> + * The return value will be an ERR_PTR() on error or a valid pointer
>> + * to a struct eeprom_cell.  The eeprom_cell will be freed by the
>> + * eeprom_cell_put().
>> + */
>> +struct eeprom_cell *eeprom_cell_get_byname(struct device *dev,
>> +					   const char *name);
>> +
>> +/**
>> + * eeprom_cell_put(): Release previously allocated eeprom cell.
>> + *
>> + * @cell: Previously allocated eeprom cell by eeprom_cell_get()
>> + * or eeprom_cell_get_byname().
>> + */
>> +void eeprom_cell_put(struct eeprom_cell *cell);
>> +
>> +/**
>> + * eeprom_cell_read(): Read a given eeprom cell
>> + *
>> + * @cell: eeprom cell to be read.
>> + * @len: pointer to length of cell which will be populated on successful read.
>> + *
>> + * The return value will be an ERR_PTR() on error or a valid pointer
>> + * to a char * bufffer.  The buffer should be freed by the consumer with a
>> + * kfree().
>> + */
>> +char *eeprom_cell_read(struct eeprom_cell *cell, ssize_t *len);
>
> Would void * be better than char *? I guess the contents is mostly
> data, not strings.
Yes, thats sounds sensible.
>
>        Andrew
>
>> +
>> +/**

>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
