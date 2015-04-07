From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v4 04/10] eeprom: Add a simple EEPROM framework for eeprom
 consumers
Date: Tue, 07 Apr 2015 21:09:38 +0100
Message-ID: <55243982.7020907@linaro.org>
References: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org> <1427752670-17219-1-git-send-email-srinivas.kandagatla@linaro.org> <20150407184533.GA10278@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20150407184533.GA10278@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de
List-Id: linux-api@vger.kernel.org

Thanks Stephen for review,

On 07/04/15 19:45, Stephen Boyd wrote:
> On 03/30, Srinivas Kandagatla wrote:
>> @@ -130,6 +138,37 @@ static struct class eeprom_class = {
>>   	.dev_release	= eeprom_release,
>>   };
>>
>> +static int of_eeprom_match(struct device *dev, const void *eeprom_np)
>> +{
>> +	return dev->of_node == eeprom_np;
>> +}
>> +
>> +static struct eeprom_device *of_eeprom_find(struct device_node *eeprom_np)
>> +{
>> +	struct device *d;
>> +
>> +	if (!eeprom_np)
>> +		return NULL;
>> +
>> +	d = class_find_device(&eeprom_class, NULL, eeprom_np, of_eeprom_match);
>> +
>> +	return d ? to_eeprom(d) : NULL;
>> +}
>> +
>> +static int eeprom_match(struct device *dev, const void *data)
>> +{
>> +	return !strcmp(dev_name(dev), (const char *)data);
>
> Is this cast necessary?
May be an over do here, I will fix it.
>
>> +}
>> +
>> +static struct eeprom_device *eeprom_find(const char *name)
>> +{
>> +	struct device *d;
>> +
>> +	d = class_find_device(&eeprom_class, NULL, (void *)name, eeprom_match);
>
> Is this cast necessary?

I Will fix it in next version.
>
>> +
>> +	return d ? to_eeprom(d) : NULL;
>> +}
>> +
>>   /**
>>    * eeprom_register(): Register a eeprom device for given eeprom.
>>    * Also creates an binary entry in /sys/class/eeprom/name-id/eeprom
>> +
>> +/**
>> + * eeprom_cell_get(): Get eeprom cell of device form a given eeprom name
>
> s/form/from/

Will fix this in next version.
>
>> + * and blocks.
>> + *
>> + * @ename: eeprom device name that needs to be looked-up.
>> + * @blocks: eeprom blocks containing offset and length information.
>> + * @nblocks: number of eeprom blocks.
>> + *
>> + * The return value will be an ERR_PTR() on error or a valid pointer
>> + * to a struct eeprom_cell.  The eeprom_cell will be freed by the
>> + * eeprom_cell_put().
>> + */
>> +struct eeprom_cell *eeprom_cell_get(const char *ename,
>> +				    struct eeprom_block *blocks, int nblocks)
>> +{
>> +	return __eeprom_cell_get(NULL, ename, blocks, nblocks);
>> +}
>> +EXPORT_SYMBOL_GPL(eeprom_cell_get);
>> +
>> +/**
>> + * of_eeprom_cell_get(): Get eeprom cell of device form a given index
>
> s/form/from/
>
Ok,
>> + *
>> + * @dev node: Device tree node that uses the eeprom cell
>> +
>> +#ifndef _LINUX_EEPROM_CONSUMER_H
>> +#define _LINUX_EEPROM_CONSUMER_H
>> +
>> +struct eeprom_cell;
>> +
>> +struct eeprom_block {
>> +	loff_t offset;
>> +	size_t count;
>> +};
>> +#if IS_ENABLED(CONFIG_EEPROM)
>> +struct eeprom_cell *eeprom_cell_get(const char *ename,
>> +				    struct eeprom_block *blocks, int nblocks);
>> +void eeprom_cell_put(struct eeprom_cell *cell);
>> +char *eeprom_cell_read(struct eeprom_cell *cell, ssize_t *len);
>> +int eeprom_cell_write(struct eeprom_cell *cell, const char *buf, ssize_t len);
> [...]
>> +
>> +#if IS_ENABLED(CONFIG_EEPROM) && IS_ENABLED(CONFIG_OF)
>> +struct eeprom_cell *of_eeprom_cell_get(struct device_node *dev,
>> +				       const char *property);
>> +#else
>> +static inline struct eeprom_cell *of_eeprom_cell_get(struct device_node *np,
>> +						     const char *property)
>> +{
>> +	return ERR_PTR(-ENOSYS);
>> +}
>> +#endif
>> +#endif  /* ifndef _LINUX_EEPROM_CONSUMER_H */
>
> Do you have an overview of how to use these APIs? Maybe some
> Documentation/ is in order? I'm mostly interested in how the
> blocks array is supposed to work and how this hooks up to drivers
> that are using DT.

Only doc ATM is function level kernel doc in c file.
May be I can explain you for now and I will try to add some 
documentation with some usage examples in next version.

eeprom block array is just another way intended to get hold of eeprom 
content for non-DT providers/consumers, but DT consumers/providers can 
also use it. As of today SOC/mach level code could use it as well.

In eeprom_cell_get() case the lookup of provider is done based on 
provider name, this provider name is generally supplied by all the 
providers (both DT/non DT).

for example in qfprom case,
provider is registered from DT with eeprom config containing a unique name:
static struct eeprom_config econfig = {
	.name = "qfprom",
	.id = 0,
};

In the consumer case, the tsens driver could do some like in non DT way:

	struct eeprom_block blocks[4] ={
		{
		.offset = 0x404,
		.count = 0x4,
		},
		{
		.offset = 0x408,
		.count = 0x4,
		},
		{
		.offset = 0x40c,
		.count = 0x4,
		},
		{
		.offset = 0x410,
		.count = 0x4,
		},
	};
	calib_cell = eeprom_cell_get("qfprom0", blocks, 4);


Or in DT way
calib_cell  = of_eeprom_cell_get(np, "calib");


--srini
>
