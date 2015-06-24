From: Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v6 6/9] nvmem: qfprom: Add Qualcomm QFPROM support.
Date: Wed, 24 Jun 2015 15:07:05 -0700
Message-ID: <558B2A09.3020407@codeaurora.org>
References: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org> <1435014556-26392-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435014556-26392-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, stefan.wahren-eS4NqCHxEME@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 06/22/2015 04:09 PM, Srinivas Kandagatla wrote:
> diff --git a/drivers/nvmem/qfprom.c b/drivers/nvmem/qfprom.c
> new file mode 100644
> index 0000000..7f7a82f
> --- /dev/null
> +++ b/drivers/nvmem/qfprom.c
> @@ -0,0 +1,89 @@
>
> +
> +#include <linux/platform_device.h>
> +#include <linux/nvmem-provider.h>
> +#include <linux/slab.h>
> +#include <linux/regmap.h>
> +#include <linux/device.h>
> +#include <linux/io.h>

Is this include used?

> +#include <linux/module.h>
> +#include <linux/delay.h>

Is this include used?

> +#include <linux/of.h>
> +
> +static struct regmap_config qfprom_regmap_config = {

Can this be const?

> +	.reg_bits = 32,
> +	.val_bits = 8,
> +	.reg_stride = 1,
> +};
> +
> +static struct nvmem_config econfig = {

And this one too?

> +	.name = "qfprom",
> +	.owner = THIS_MODULE,
> +};
> +


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
