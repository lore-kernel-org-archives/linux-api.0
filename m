From: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v5 04/11] nvmem: Add a simple NVMEM framework for consumers
Date: Tue, 16 Jun 2015 15:29:25 -0700
Message-ID: <5580A345.30204@codeaurora.org>
References: <1432226535-8640-1-git-send-email-srinivas.kandagatla@linaro.org> <1432226593-8817-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432226593-8817-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, linux-arm-kernel@lists.infradead.org
Cc: devicetree@vger.kernel.org, arnd@arndb.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, s.hauer@pengutronix.de, linux-kernel@vger.kernel.org, pantelis.antoniou@konsulko.com, Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>, Kumar Gala <galak@codeaurora.org>, mporter@konsulko.com, Maxime Ripard <maxime.ripard@free-electrons.com>, linux-api@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 05/21/2015 09:43 AM, Srinivas Kandagatla wrote:
> @@ -379,6 +380,351 @@ int nvmem_unregister(struct nvmem_device *nvmem)
[...]
> +
> +	return nvmem;
> +}
> +
> +static int __nvmem_device_put(struct nvmem_device *nvmem)

Why does this return int? It's not used anywhere.

> +{
> +	module_put(nvmem->owner);
> +	mutex_lock(&nvmem_mutex);
> +	nvmem->users--;
> +	mutex_unlock(&nvmem_mutex);
> +
> +	return 0;
> +}
> +
> +static struct nvmem_cell *nvmem_cell_get_from_list(const char *cell_id)
> +{
> +	struct nvmem_cell *cell = NULL;
> +	struct nvmem_device *nvmem;
> +
> +	nvmem = __nvmem_device_get(NULL, &cell, cell_id);
> +	if (IS_ERR(nvmem))
> +		return (struct nvmem_cell *)nvmem;

ERR_CAST?

> +
> +
> +	return cell;
> +
> +}
> +
> +static struct nvmem_cell *of_nvmem_cell_get(struct device_node *np,
> +					    const char *name)
> +{
> +	struct device_node *cell_np, *nvmem_np;
> +	struct nvmem_cell *cell;
> +	struct nvmem_device *nvmem;
> +	const __be32 *addr;
> +	int rval, len, index;
> +
> +	index = of_property_match_string(np, "nvmem-cell-names", name);
> +
> +	cell_np = of_parse_phandle(np, "nvmem-cell", index);
> +	if (!cell_np)
> +		return ERR_PTR(-EINVAL);
> +
> +	nvmem_np = of_get_next_parent(cell_np);
> +	if (!nvmem_np)
> +		return ERR_PTR(-EINVAL);
> +
> +	nvmem = __nvmem_device_get(nvmem_np, NULL, NULL);
> +	if (IS_ERR(nvmem))
> +		return (struct nvmem_cell *)nvmem;

ERR_CAST?

> +
> +	addr = of_get_property(cell_np, "reg", &len);
> +	if (!addr || (len < 2 * sizeof(int))) {
> +		dev_err(&nvmem->dev, "of_i2c: invalid reg on %s\n",

huh? of_i2c?


> +
> +	/* if it's not end on byte boundary */
> +	if ((nbits + bit_offset) % BITS_PER_BYTE) {
> +		/* setup the last byte with msb bits from nvmem */
> +		rc = regmap_raw_read(nvmem->regmap,
> +				    cell->offset + cell->bytes - 1, &v, 1);
> +		*p |= GENMASK(7, (nbits + bit_offset) % BITS_PER_BYTE) & v;
> +
> +	}
> +
> +	return buf;
> +}
> +
> +/**
> + * nvmem_cell_write(): Write to a given nvmem cell

This isn't kernel doc notation. It should be like

    nvmem_cell_write - Write to a given nvmem cell

> + *
> + * @cell: nvmem cell to be written.
> + * @buf: Buffer to be written.
> + * @len: length of buffer to be written to nvmem cell.
> + *
> + * The return value will be an length of bytes written or non zero on failure.
> + */
> +int nvmem_cell_write(struct nvmem_cell *cell, void *buf, ssize_t len)
[..]
> +
>  static int nvmem_init(void)
>  {
>  	return class_register(&nvmem_class);
> diff --git a/include/linux/nvmem-consumer.h b/include/linux/nvmem-consumer.h
> new file mode 100644
> index 0000000..c3fa8c7
> --- /dev/null
> +++ b/include/linux/nvmem-consumer.h
> @@ -0,0 +1,49 @@
> +/*
> + * nvmem framework consumer.
> + *
> + * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> + * Copyright (C) 2013 Maxime Ripard <maxime.ripard@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2.  This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#ifndef _LINUX_NVMEM_CONSUMER_H
> +#define _LINUX_NVMEM_CONSUMER_H
> +
> +/* consumer cookie */
> +struct nvmem_cell;
> +
> +#if IS_ENABLED(CONFIG_NVMEM)
> +
> +/* Cell based interface */
> +struct nvmem_cell *nvmem_cell_get(struct device *dev, const char *name);

We should probably forward declare struct device in this file too.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
