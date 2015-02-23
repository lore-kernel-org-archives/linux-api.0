From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] eeprom: Add a simple EEPROM framework
Date: Mon, 23 Feb 2015 15:38:28 +0000
Message-ID: <54EB4974.2040801@linaro.org>
References: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org> <1424365708-26681-1-git-send-email-srinivas.kandagatla@linaro.org> <20150223150415.GF6236@finisterre.sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150223150415.GF6236-bheZrs9scGb3/WHNxyQH9YN0K6Il/+VY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Thankyou for the comments.

On 23/02/15 15:04, Mark Brown wrote:
> On Thu, Feb 19, 2015 at 05:08:28PM +0000, Srinivas Kandagatla wrote:
>
>>   .../devicetree/bindings/eeprom/eeprom.txt          |  48 ++++
>>   drivers/Kconfig                                    |   2 +
>>   drivers/Makefile                                   |   1 +
>>   drivers/eeprom/Kconfig                             |  19 ++
>>   drivers/eeprom/Makefile                            |   9 +
>>   drivers/eeprom/core.c                              | 290 +++++++++++++++++++++
>>   include/linux/eeprom-consumer.h                    |  73 ++++++
>>   include/linux/eeprom-provider.h                    |  51 ++++
>
> This seems to have a bunch of different things in it - there's some
> binding, there's some framework code, there's some user code for the
> framework...  splitting it up more would probably help with review.
> I'd at least make sure the framework is split from the DT code, that
> will cut down on the bulk and help make sure the framework isn't too DT
> tied.

Yes I agree, will make sure that I split it into different patches in 
next version.
>
>> +	if (read)
>> +		rc = regmap_bulk_read(eeprom->regmap, offset,
>> +				      buf, count/eeprom->stride);
>> +	else
>> +		rc = regmap_bulk_write(eeprom->regmap, offset,
>> +				       buf, count/eeprom->stride);
>> +
>> +	if (IS_ERR_VALUE(rc))
>> +		return 0;
>> +
>> +	return count;
>> +}
>
>> +static ssize_t bin_attr_eeprom_read(struct file *filp, struct kobject *kobj,
>> +				    struct bin_attribute *attr,
>> +				    char *buf, loff_t offset, size_t count)
>> +{
>> +	return bin_attr_eeprom_read_write(kobj, buf, offset, count, true);
>> +}
>
> I'm not sure the factoring out is actually helping the clarity here TBH.
>
ok.

>> +int eeprom_unregister(struct eeprom_device *eeprom)
>> +{
>> +	device_del(&eeprom->edev);
>> +
>> +	mutex_lock(&eeprom_list_mutex);
>> +	list_del(&eeprom->list);
>> +	mutex_unlock(&eeprom_list_mutex);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(eeprom_unregister);
>
> Here we return having dropped the lock without doing anything else with
> the eeprom, meaning the caller could delete it.
>
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
> Here we iterate the list, find the relevant eeprom and drop the lock
> while still holding a reference to the eeprom we just found.  This means
> that a removal could race with us and free the eeprom underneath us.
> I'm also not seeing anything stopping or even noticing a device being
> removed with a cell active on it.
>
As suggested by Stephen Boyd reference counting on eeprom should ensure 
safe removal of eeprom.

>> +/**
>> + * eeprom_cell_get(): Get eeprom cell of device form a given index.
>> + *
>> + * @dev: Device that will be interacted with
>> + * @index: Index of the eeprom cell.
>> + *
>> + * The return value will be an ERR_PTR() on error or a valid pointer
>> + * to a struct eeprom_cell.  The eeprom_cell will be freed by the
>> + * eeprom_cell_put().
>> + */
>> +struct eeprom_cell *eeprom_cell_get(struct device *dev, int index);
>
> Normally the kerneldoc goes with the function definition, not the
> prototype.
Thats true, will fix it in next version.
>
