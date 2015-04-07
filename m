From: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v4 04/10] eeprom: Add a simple EEPROM framework for
 eeprom consumers
Date: Tue, 7 Apr 2015 11:45:33 -0700
Message-ID: <20150407184533.GA10278@codeaurora.org>
References: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1427752670-17219-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427752670-17219-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de
List-Id: linux-api@vger.kernel.org

On 03/30, Srinivas Kandagatla wrote:
> @@ -130,6 +138,37 @@ static struct class eeprom_class = {
>  	.dev_release	= eeprom_release,
>  };
>  
> +static int of_eeprom_match(struct device *dev, const void *eeprom_np)
> +{
> +	return dev->of_node == eeprom_np;
> +}
> +
> +static struct eeprom_device *of_eeprom_find(struct device_node *eeprom_np)
> +{
> +	struct device *d;
> +
> +	if (!eeprom_np)
> +		return NULL;
> +
> +	d = class_find_device(&eeprom_class, NULL, eeprom_np, of_eeprom_match);
> +
> +	return d ? to_eeprom(d) : NULL;
> +}
> +
> +static int eeprom_match(struct device *dev, const void *data)
> +{
> +	return !strcmp(dev_name(dev), (const char *)data);

Is this cast necessary?

> +}
> +
> +static struct eeprom_device *eeprom_find(const char *name)
> +{
> +	struct device *d;
> +
> +	d = class_find_device(&eeprom_class, NULL, (void *)name, eeprom_match);

Is this cast necessary?

> +
> +	return d ? to_eeprom(d) : NULL;
> +}
> +
>  /**
>   * eeprom_register(): Register a eeprom device for given eeprom.
>   * Also creates an binary entry in /sys/class/eeprom/name-id/eeprom
> +
> +/**
> + * eeprom_cell_get(): Get eeprom cell of device form a given eeprom name

s/form/from/

> + * and blocks.
> + *
> + * @ename: eeprom device name that needs to be looked-up.
> + * @blocks: eeprom blocks containing offset and length information.
> + * @nblocks: number of eeprom blocks.
> + *
> + * The return value will be an ERR_PTR() on error or a valid pointer
> + * to a struct eeprom_cell.  The eeprom_cell will be freed by the
> + * eeprom_cell_put().
> + */
> +struct eeprom_cell *eeprom_cell_get(const char *ename,
> +				    struct eeprom_block *blocks, int nblocks)
> +{
> +	return __eeprom_cell_get(NULL, ename, blocks, nblocks);
> +}
> +EXPORT_SYMBOL_GPL(eeprom_cell_get);
> +
> +/**
> + * of_eeprom_cell_get(): Get eeprom cell of device form a given index

s/form/from/

> + *
> + * @dev node: Device tree node that uses the eeprom cell
> + * @index: eeprom index in eeproms property.
> + *
> + * The return value will be an ERR_PTR() on error or a valid pointer
> + * to a struct eeprom_cell.  The eeprom_cell will be freed by the
> + * eeprom_cell_put().
> + */
> +struct eeprom_cell *of_eeprom_cell_get(struct device_node *np, const char *name)
> +{
> +	struct device_node *cell_np;
> +
> +	cell_np = of_parse_phandle(np, name, 0);
> +	if (!cell_np)
> +		return ERR_PTR(-EINVAL);
> +
> +	return __eeprom_cell_get(cell_np, NULL, NULL, 0);
> +}
> +EXPORT_SYMBOL_GPL(of_eeprom_cell_get);
> +
> diff --git a/include/linux/eeprom-consumer.h b/include/linux/eeprom-consumer.h
> new file mode 100644
> index 0000000..effa417
> --- /dev/null
> +++ b/include/linux/eeprom-consumer.h
> @@ -0,0 +1,61 @@
> +/*
> + * EEPROM framework consumer.
> + *
> + * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> + * Copyright (C) 2013 Maxime Ripard <maxime.ripard@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#ifndef _LINUX_EEPROM_CONSUMER_H
> +#define _LINUX_EEPROM_CONSUMER_H
> +
> +struct eeprom_cell;
> +
> +struct eeprom_block {
> +	loff_t offset;
> +	size_t count;
> +};
> +#if IS_ENABLED(CONFIG_EEPROM)
> +struct eeprom_cell *eeprom_cell_get(const char *ename,
> +				    struct eeprom_block *blocks, int nblocks);
> +void eeprom_cell_put(struct eeprom_cell *cell);
> +char *eeprom_cell_read(struct eeprom_cell *cell, ssize_t *len);
> +int eeprom_cell_write(struct eeprom_cell *cell, const char *buf, ssize_t len);
[...]
> +
> +#if IS_ENABLED(CONFIG_EEPROM) && IS_ENABLED(CONFIG_OF)
> +struct eeprom_cell *of_eeprom_cell_get(struct device_node *dev,
> +				       const char *property);
> +#else
> +static inline struct eeprom_cell *of_eeprom_cell_get(struct device_node *np,
> +						     const char *property)
> +{
> +	return ERR_PTR(-ENOSYS);
> +}
> +#endif
> +#endif  /* ifndef _LINUX_EEPROM_CONSUMER_H */

Do you have an overview of how to use these APIs? Maybe some
Documentation/ is in order? I'm mostly interested in how the
blocks array is supposed to work and how this hooks up to drivers
that are using DT.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
