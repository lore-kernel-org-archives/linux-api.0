From: Sascha Hauer <s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Subject: Re: [PATCH v3 4/9] eeprom: Add a simple EEPROM framework for eeprom
 consumers
Date: Wed, 25 Mar 2015 08:16:30 +0100
Message-ID: <20150325071630.GW9742@pengutronix.de>
References: <1427236116-18531-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1427236219-18709-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1427236219-18709-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 24, 2015 at 10:30:19PM +0000, Srinivas Kandagatla wrote:
> This patch adds just consumers part of the framework just to enable easy
> review.
> 
> Up until now, EEPROM drivers were stored in drivers/misc, where they all had to
> duplicate pretty much the same code to register a sysfs file, allow in-kernel
> users to access the content of the devices they were driving, etc.
> 
> This was also a problem as far as other in-kernel users were involved, since
> the solutions used were pretty much different from on driver to another, there
> was a rather big abstraction leak.
> 
> This introduction of this framework aims at solving this. It also introduces DT
> representation for consumer devices to go get the data they require (MAC
> Addresses, SoC/Revision ID, part numbers, and so on) from the EEPROMs.
> 
> Having regmap interface to this framework would give much better
> abstraction for eeproms on different buses.

Thanks for working on this. This is something that is missing in the
kernel, it looks very promising to me.

Some comments inline

> +static struct eeprom_cell *__eeprom_cell_get(struct device_node *cell_np,
> +					     const char *ename,
> +					     struct eeprom_block *blocks,
> +					     int nblocks)
> +{
> +	struct eeprom_cell *cell;
> +	struct eeprom_device *eeprom = NULL;

No need to initialize.

> +	struct property *prop;
> +	const __be32 *vp;
> +	u32 pv;
> +	int i, rval;
> +
> +	mutex_lock(&eeprom_mutex);
> +
> +	eeprom = cell_np ? of_eeprom_find(cell_np->parent) : eeprom_find(ename);
> +	if (!eeprom) {
> +		mutex_unlock(&eeprom_mutex);
> +		return ERR_PTR(-EPROBE_DEFER);
> +	}
> +

> +/**
> + * of_eeprom_cell_get(): Get eeprom cell of device form a given index
> + *
> + * @dev: Device that will be interacted with
> + * @index: eeprom index in eeproms property.
> + *
> + * The return value will be an ERR_PTR() on error or a valid pointer
> + * to a struct eeprom_cell.  The eeprom_cell will be freed by the
> + * eeprom_cell_put().
> + */
> +struct eeprom_cell *of_eeprom_cell_get(struct device *dev, int index)
> +{

I think the consumer API could be improved. The dev pointer is only used
to get the struct device_node out of it, so the device_node could be
passed in directly. As written in my other mail I think the binding
would be better like "calibration = <&tsens_calibration>;", so this
function could be:

of_eeprom_cell_get(struct device_node *np, const char *name)

With this we could also get eeprom cells from subnodes which do not have
a struct device bound to them.

> +	struct device_node *cell_np;
> +
> +	if (!dev || !dev->of_node)
> +		return ERR_PTR(-EINVAL);
> +
> +	cell_np = of_parse_phandle(dev->of_node, "eeproms", index);
> +	if (!cell_np)
> +		return ERR_PTR(-EPROBE_DEFER);

-EPROBE_DEFER is not appropriate here. If of_parse_phandle fails it
won't work next time.

> +
> +	return __eeprom_cell_get(cell_np, NULL, NULL, 0);
> +}
> +EXPORT_SYMBOL_GPL(of_eeprom_cell_get);
> +
> +/**
> + * eeprom_cell_write(): Write to a given eeprom cell
> + *
> + * @cell: eeprom cell to be written.
> + * @buf: Buffer to be written.
> + * @len: length of buffer to be written to eeprom cell.
> + *
> + * The return value will be an non zero on error or a zero on successful write.

No, it returns the length.

> + */
> +int eeprom_cell_write(struct eeprom_cell *cell, const char *buf, ssize_t len)
> +{
> +	struct eeprom_device *eeprom = cell->eeprom;
> +	int i, rc, offset = 0;
> +
> +	if (!eeprom || !eeprom->regmap || len != cell->size)
> +		return -EINVAL;
> +
> +	for (i = 0; i < cell->nblocks; i++) {
> +		rc = regmap_bulk_write(eeprom->regmap, cell->blocks[i].offset,
> +				 buf + offset,
> +				 cell->blocks[i].count);
> +
> +		if (IS_ERR_VALUE(rc))
> +			return rc;
> +
> +		offset += cell->blocks[i].count;
> +	}
> +
> +	return len;
> +}
> +EXPORT_SYMBOL_GPL(eeprom_cell_write);
> +

> +static inline char *eeprom_cell_read(struct eeprom_cell *cell, ssize_t *len)
> +{
> +	return NULL;
> +}

The documentation above the real function states that this function
either returns an ERR_PTR() or a valid pointer. The wrapper should then
do the same.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
