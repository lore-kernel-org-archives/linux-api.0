From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v7 2/9] nvmem: Add a simple NVMEM framework for consumers
Date: Fri, 10 Jul 2015 03:42:57 -0700
Message-ID: <1436524977.24866.31.camel@perches.com>
References: <1436521427-10568-1-git-send-email-srinivas.kandagatla@linaro.org>
	 <1436521495-10728-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436521495-10728-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, stefan.wahren-eS4NqCHxEME@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2015-07-10 at 10:44 +0100, Srinivas Kandagatla wrote:
> This patch adds just consumers part of the framework just to enable easy
> review.

Trivial notes:

> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
> @@ -334,6 +335,7 @@ struct nvmem_device *nvmem_register(struct nvmem_config *config)
>  	if (config->cells)
>  		nvmem_add_cells(nvmem, config);
>  
> +

superfluous newline

> +static struct nvmem_cell *nvmem_cell_get_from_list(const char *cell_id)
> +{
> +	struct nvmem_cell *cell = NULL;
> +	struct nvmem_device *nvmem;
> +
> +	nvmem = __nvmem_device_get(NULL, &cell, cell_id);
> +	if (IS_ERR(nvmem))
> +		return ERR_CAST(nvmem);
> +
> +

extra blank line here too

> +/**
> + * nvmem_cell_read() - Read a given nvmem cell
> + *
> + * @cell: nvmem cell to be read.
> + * @len: pointer to length of cell which will be populated on successful read.
> + *
> + * The return value will be an ERR_PTR() on error or a valid pointer
> + * to a char * bufffer.  The buffer should be freed by the consumer with a

One too many f's in buffer, it's returning a void *

> + * kfree().
> + */
> +void *nvmem_cell_read(struct nvmem_cell *cell, size_t *len)
> +{
> +	struct nvmem_device *nvmem = cell->nvmem;
> +	u8 *buf;
[]
> +	return buf;
> +}
> +EXPORT_SYMBOL_GPL(nvmem_cell_read);

[]

> +/**
> + * nvmem_cell_write() - Write to a given nvmem cell
> + *
> + * @cell: nvmem cell to be written.
> + * @buf: Buffer to be written.
> + * @len: length of buffer to be written to nvmem cell.
> + *
> + * The return value will be an length of bytes written or non zero on failure.

less than zero or maybe negative on failure?

> + */
> +int nvmem_cell_write(struct nvmem_cell *cell, void *buf, size_t len)
> +{
> +	struct nvmem_device *nvmem = cell->nvmem;
> +	int rc;
> +	void *wbuf = buf;

This variable and assignment seems unnecessary as buf could be reused.

> +
> +	if (!nvmem || !nvmem->regmap || nvmem->read_only ||
> +	    (cell->bit_offset == 0 && len != cell->bytes))
> +		return -EINVAL;
> +
> +	if (cell->bit_offset || cell->nbits) {
> +		wbuf = nvmem_cell_prepare_write_buffer(cell, buf, len);
> +		if (IS_ERR(wbuf))
> +			return PTR_ERR(wbuf);
> +	}
> +
> +	rc = regmap_raw_write(nvmem->regmap, cell->offset, wbuf, cell->bytes);
> +
> +	/* free the tmp buffer */
> +	if (cell->bit_offset)
> +		kfree(wbuf);
> +
> +	if (IS_ERR_VALUE(rc))
> +		return rc;
> +
> +	return len;
> +}
> +EXPORT_SYMBOL_GPL(nvmem_cell_write);
