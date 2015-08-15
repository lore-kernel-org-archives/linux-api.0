From: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>
Subject: Re: [PATCH RFC 3/3] nvmem: add permission flags in nvmem_config
Date: Sat, 15 Aug 2015 09:21:56 +0200 (CEST)
Message-ID: <1634428787.18822.1439623316281.JavaMail.open-xchange@oxbsltgw04.schlund.de>
References: <1439290931-18232-1-git-send-email-srinivas.kandagatla@linaro.org> <1439291024-18375-1-git-send-email-srinivas.kandagatla@linaro.org>
Reply-To: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439291024-18375-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, maitysanchayan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Srinivas,

> Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> hat am 11. August 2015 um
> 13:03 geschrieben:
>
>
> This patch adds perm variable to nvmem_config structure which will allow
> providers to specify the permissions required for the sysfs binary file.
> This permission is applied on top of root-only access permissions set by
> the core.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> drivers/nvmem/core.c | 1 +
> include/linux/nvmem-provider.h | 1 +
> 2 files changed, 2 insertions(+)
>
> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
> index 414ed23..7481387 100644
> --- a/drivers/nvmem/core.c
> +++ b/drivers/nvmem/core.c
> @@ -312,6 +312,7 @@ struct nvmem_device *nvmem_register(const struct
> nvmem_config *config)
> config->read_only;
> nvmem->bin = bin_attr_template;
> nvmem->bin.attr.mode = nvmem->read_only ? : (S_IRUSR | S_IWUSR);
> + nvmem->bin.attr.mode |= config->perm;
> nvmem->bin.size = nvmem->size;
> device_initialize(&nvmem->dev);
>
> diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
> index 0b68caf..de9a61f 100644
> --- a/include/linux/nvmem-provider.h
> +++ b/include/linux/nvmem-provider.h
> @@ -23,6 +23,7 @@ struct nvmem_config {
> const struct nvmem_cell_info *cells;
> int ncells;
> bool read_only;
> + u16 perm; /* visibility in sysfs */

how about "umode_t mode" or "umode_t sysfs_mode"?

Beside that the whole series looks good to me.

Thanks Stefan
