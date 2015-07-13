From: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>
Subject: Re: [PATCH v7 2/9] nvmem: Add a simple NVMEM framework for
 consumers
Date: Mon, 13 Jul 2015 21:06:22 +0200 (CEST)
Message-ID: <1510509759.163664.1436814382477.JavaMail.open-xchange@oxbsltgw06.schlund.de>
References: <1436521427-10568-1-git-send-email-srinivas.kandagatla@linaro.org> <1436521495-10728-1-git-send-email-srinivas.kandagatla@linaro.org>
Reply-To: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436521495-10728-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Srinivas,

> Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> hat am 10. Juli 2015 um
> 11:44 geschrieben:
>
>
> [...]
> ---
> drivers/nvmem/core.c | 424 ++++++++++++++++++++++++++++++++++++++++-
> include/linux/nvmem-consumer.h | 76 ++++++++
> 2 files changed, 498 insertions(+), 2 deletions(-)
> create mode 100644 include/linux/nvmem-consumer.h
>
> diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
> index a779ad1..f429ad4 100644
> --- a/drivers/nvmem/core.c
> +++ b/drivers/nvmem/core.c
> @@ -15,14 +15,15 @@
> */
>
> #include <linux/device.h>
> -#include <linux/nvmem-provider.h>
> #include <linux/export.h>
> #include <linux/fs.h>
> #include <linux/idr.h>
> #include <linux/init.h>
> -#include <linux/regmap.h>

please avoid such changes in your patch series. This should be fixed in the
first patch.

Thanks
Stefan
