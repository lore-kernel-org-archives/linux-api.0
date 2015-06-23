From: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>
Subject: Re: [PATCH v6 3/9] nvmem: Add nvmem_device based consumer apis.
Date: Tue, 23 Jun 2015 22:28:50 +0200 (CEST)
Message-ID: <1344600420.252283.1435091331020.JavaMail.open-xchange@oxbsltgw00.schlund.de>
References: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org> <1435014527-26265-1-git-send-email-srinivas.kandagatla@linaro.org>
Reply-To: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435014527-26265-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


> Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> hat am 23. Juni 2015 um
> 01:08 geschrieben:
>
>
> This patch adds read/write apis which are based on nvmem_device. It is
> common that the drivers like omap cape manager or qcom cpr driver to
> access bytes directly at particular offset in the eeprom and not from
> nvmem cell info in DT. These driver would need to get access to the nvmem
> directly, which is what these new APIS provide.
>
> [...]
> diff --git a/include/linux/nvmem-consumer.h b/include/linux/nvmem-consumer.h
> index 123af62..f9acc43 100644
> --- a/include/linux/nvmem-consumer.h
> +++ b/include/linux/nvmem-consumer.h
> @@ -15,6 +15,15 @@
> struct device;
> /* consumer cookie */
> struct nvmem_cell;
> +struct nvmem_device;
> +
> +struct nvmem_cell_info {
> + const char *name;
> + int offset;
> + int bytes;
> + int bit_offset;
> + int nbits;
> +};
>
> #if IS_ENABLED(CONFIG_NVMEM)
>
> @@ -26,6 +35,21 @@ void devm_nvmem_cell_put(struct device *dev, struct
> nvmem_cell *cell);
> void *nvmem_cell_read(struct nvmem_cell *cell, ssize_t *len);
> int nvmem_cell_write(struct nvmem_cell *cell, void *buf, ssize_t len);
>
> +/* direct nvmem device read/write interface */
> +struct nvmem_device *nvmem_device_get(struct device *dev, const char *name);
> +struct nvmem_device *devm_nvmem_device_get(struct device *dev,
> + const char *name);
> +void nvmem_device_put(struct nvmem_device *nvmem);
> +void devm_nvmem_device_put(struct device *dev, struct nvmem_device *nvmem);
> +int nvmem_device_read(struct nvmem_device *nvmem, unsigned int offset,
> + size_t bytes, void *buf);
> +int nvmem_device_write(struct nvmem_device *nvmem, unsigned int offset,
> + size_t bytes, void *buf);

Maybe i mixed something but those functions use the datatype unsigned int for
offset
and the offset in the structs use datatype int. Looks a little bit inconsistent.
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
