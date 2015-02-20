From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [RFC PATCH 1/3] eeprom: Add a simple EEPROM framework
Date: Fri, 20 Feb 2015 19:00:22 +0000
Message-ID: <54E78446.8050800@linaro.org>
References: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org> <1424365708-26681-1-git-send-email-srinivas.kandagatla@linaro.org> <20150220174641.GI8656@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150220174641.GI8656@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, broonie@kernel.org, Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Maxime Ripard <maxime.ripard@free-electrons.com>
List-Id: linux-api@vger.kernel.org



On 20/02/15 17:46, Russell King - ARM Linux wrote:
> On Thu, Feb 19, 2015 at 05:08:28PM +0000, Srinivas Kandagatla wrote:
>> +static struct class eeprom_class = {
>> +	.name		= "eeprom",
>> +	.dev_groups	= eeprom_dev_groups,
>> +};
>> +
>> +int eeprom_register(struct eeprom_device *eeprom)
>> +{
>> +	int rval;
>> +
>> +	if (!eeprom->regmap || !eeprom->size) {
>> +		dev_err(eeprom->dev, "Regmap not found\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	eeprom->id = ida_simple_get(&eeprom_ida, 0, 0, GFP_KERNEL);
>> +	if (eeprom->id < 0)
>> +		return eeprom->id;
>> +
>> +	eeprom->edev.class = &eeprom_class;
>> +	eeprom->edev.parent = eeprom->dev;
>> +	eeprom->edev.of_node = eeprom->dev ? eeprom->dev->of_node : NULL;
>> +	dev_set_name(&eeprom->edev, "eeprom%d", eeprom->id);
>> +
>> +	device_initialize(&eeprom->edev);
>> +
>> +	dev_dbg(&eeprom->edev, "Registering eeprom device %s\n",
>> +		dev_name(&eeprom->edev));
>> +
>> +	rval = device_add(&eeprom->edev);
>> +	if (rval)
>> +		return rval;
>> +
>> +	mutex_lock(&eeprom_list_mutex);
>> +	list_add(&eeprom->list, &eeprom_list);
>> +	mutex_unlock(&eeprom_list_mutex);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(eeprom_register);
>> +
>> +int eeprom_unregister(struct eeprom_device *eeprom)
>> +{
>> +	device_del(&eeprom->edev);
>> +
>> +	mutex_lock(&eeprom_list_mutex);
>> +	list_del(&eeprom->list);
>> +	mutex_unlock(&eeprom_list_mutex);
>> +
>> +	return 0;
>
> There's problems with this.  "edev" is embedded into eeprom, and "edev"
> is a refcounted structure - it has a lifetime, and the lifetime of
> eeprom is thus determined by edev.
>
> What this means is that calling eeprom_unregister() and then freeing
> the eeprom structure is a potentially unsafe operation - the memory
> backing edev must only be freed when the release method for the
> struct device has been called.

Thats a good catch, Yes I see the issue.

Moving the struct eeprom_device allocation to eeprom core.c should 
address this issue. This makes eeprom self contained and can safely free 
the eeprom_device memory in eeprom_class.eeprom_release().

Will fix this in next version.

>
>> +struct eeprom_device {
>> +	struct regmap		*regmap;
>> +	int			stride;
>> +	size_t			size;
>> +	struct device		*dev;
>
> Failing to understand and address the driver model life time issues is
> a major blocker for this patch.  Sorry.
>
