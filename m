From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: Re: [PATCH v3 4/9] eeprom: Add a simple EEPROM framework for eeprom
 consumers
Date: Wed, 25 Mar 2015 12:29:16 +0000
Message-ID: <5512AA1C.2050608@linaro.org>
References: <1427236116-18531-1-git-send-email-srinivas.kandagatla@linaro.org> <1427236219-18709-1-git-send-email-srinivas.kandagatla@linaro.org> <20150325071630.GW9742@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20150325071630.GW9742@pengutronix.de>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org
List-Id: linux-api@vger.kernel.org



On 25/03/15 07:16, Sascha Hauer wrote:
> On Tue, Mar 24, 2015 at 10:30:19PM +0000, Srinivas Kandagatla wrote:
>> This patch adds just consumers part of the framework just to enable easy
>> review.
>>
>> Up until now, EEPROM drivers were stored in drivers/misc, where they all had to
>> duplicate pretty much the same code to register a sysfs file, allow in-kernel
>> users to access the content of the devices they were driving, etc.
>>
>> This was also a problem as far as other in-kernel users were involved, since
>> the solutions used were pretty much different from on driver to another, there
>> was a rather big abstraction leak.
>>
>> This introduction of this framework aims at solving this. It also introduces DT
>> representation for consumer devices to go get the data they require (MAC
>> Addresses, SoC/Revision ID, part numbers, and so on) from the EEPROMs.
>>
>> Having regmap interface to this framework would give much better
>> abstraction for eeproms on different buses.
>
> Thanks for working on this. This is something that is missing in the
> kernel, it looks very promising to me.
>
> Some comments inline
>
>> +static struct eeprom_cell *__eeprom_cell_get(struct device_node *cell_np,
>> +					     const char *ename,
>> +					     struct eeprom_block *blocks,
>> +					     int nblocks)
>> +{
>> +	struct eeprom_cell *cell;
>> +	struct eeprom_device *eeprom = NULL;
>
> No need to initialize.
Sure.. Will fix it.

>
>> +	struct property *prop;
>> +	const __be32 *vp;
>> +	u32 pv;
>> +	int i, rval;
>> +
>> +	mutex_lock(&eeprom_mutex);
>> +
>> +	eeprom = cell_np ? of_eeprom_find(cell_np->parent) : eeprom_find(ename);
>> +	if (!eeprom) {
>> +		mutex_unlock(&eeprom_mutex);
>> +		return ERR_PTR(-EPROBE_DEFER);
>> +	}
>> +
>
>> +/**
>> + * of_eeprom_cell_get(): Get eeprom cell of device form a given index
>> + *
>> + * @dev: Device that will be interacted with
>> + * @index: eeprom index in eeproms property.
>> + *
>> + * The return value will be an ERR_PTR() on error or a valid pointer
>> + * to a struct eeprom_cell.  The eeprom_cell will be freed by the
>> + * eeprom_cell_put().
>> + */
>> +struct eeprom_cell *of_eeprom_cell_get(struct device *dev, int index)
>> +{
>
> I think the consumer API could be improved. The dev pointer is only used
> to get the struct device_node out of it, so the device_node could be
> passed in directly. As written in my other mail I think the binding
> would be better like "calibration = <&tsens_calibration>;", so this
> function could be:
>
> of_eeprom_cell_get(struct device_node *np, const char *name)
>
> With this we could also get eeprom cells from subnodes which do not have
> a struct device bound to them.
>
Its a good point, I will give it a try and see.

>> +	struct device_node *cell_np;
>> +
>> +	if (!dev || !dev->of_node)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	cell_np = of_parse_phandle(dev->of_node, "eeproms", index);
>> +	if (!cell_np)
>> +		return ERR_PTR(-EPROBE_DEFER);
>
> -EPROBE_DEFER is not appropriate here. If of_parse_phandle fails it
> won't work next time.
>
That's right, if it cant parse it now, it would also fail next time too.
Will fix it in next version.

>> +
>> +	return __eeprom_cell_get(cell_np, NULL, NULL, 0);
>> +}
>> +EXPORT_SYMBOL_GPL(of_eeprom_cell_get);
>> +
>> +/**
>> + * eeprom_cell_write(): Write to a given eeprom cell
>> + *
>> + * @cell: eeprom cell to be written.
>> + * @buf: Buffer to be written.
>> + * @len: length of buffer to be written to eeprom cell.
>> + *
>> + * The return value will be an non zero on error or a zero on successful write.
>
> No, it returns the length.
>
Yes, thats true, will fix it in next version.

>> + */
>> +int eeprom_cell_write(struct eeprom_cell *cell, const char *buf, ssize_t len)
>> +{
>> +	struct eeprom_device *eeprom = cell->eeprom;
>> +	int i, rc, offset = 0;
>> +
>> +	if (!eeprom || !eeprom->regmap || len != cell->size)
>> +		return -EINVAL;
>> +
>> +	for (i = 0; i < cell->nblocks; i++) {
>> +		rc = regmap_bulk_write(eeprom->regmap, cell->blocks[i].offset,
>> +				 buf + offset,
>> +				 cell->blocks[i].count);
>> +
>> +		if (IS_ERR_VALUE(rc))
>> +			return rc;
>> +
>> +		offset += cell->blocks[i].count;
>> +	}
>> +
>> +	return len;
>> +}
>> +EXPORT_SYMBOL_GPL(eeprom_cell_write);
>> +
>
>> +static inline char *eeprom_cell_read(struct eeprom_cell *cell, ssize_t *len)
>> +{
>> +	return NULL;
>> +}
>
> The documentation above the real function states that this function
> either returns an ERR_PTR() or a valid pointer. The wrapper should then
> do the same.
>
Will fix this in next version.

> Sascha
>
>
