From: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Subject: Re: [PATCH v1 5/6] eeprom: qfprom: Add Qualcomm QFPROM support.
Date: Thu, 05 Mar 2015 11:02:37 +0100
Message-ID: <1425549757.24292.204.camel@x220>
References: <1425548685-12887-1-git-send-email-srinivas.kandagatla@linaro.org>
	 <1425548783-13110-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425548783-13110-1-git-send-email-srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, andrew-g2DYL2Zd6BY@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2015-03-05 at 09:46 +0000, Srinivas Kandagatla wrote:
> diff --git a/drivers/eeprom/Kconfig b/drivers/eeprom/Kconfig
> index bff8ecb..65325c7 100644
> --- a/drivers/eeprom/Kconfig
> +++ b/drivers/eeprom/Kconfig
> @@ -28,4 +28,11 @@ config EEPROM_SUNXI_SID
>  	  This driver can also be built as a module. If so, the module
>  	  will be called sunxi_sid.
>  
> +config QCOM_QFPROM
> +	tristate "QCOM QFPROM Support"
> +        depends on EEPROM

Make this one tab, please.

> +	select REGMAP_MMIO
> +	help
> +          Say y here to enable QFPROM support. The QFPROM provides access
> +          functions for QFPROM data to rest of the drivers via eeprom interface.

And this one tab and two spaces, please.

All utterly trivial, of course, but I found a less trivial problem with
this patch, so I included these two comments anyway.

>  endif
> diff --git a/drivers/eeprom/Makefile b/drivers/eeprom/Makefile
> index 661422c..f99c824 100644
> --- a/drivers/eeprom/Makefile
> +++ b/drivers/eeprom/Makefile
> @@ -8,3 +8,4 @@ obj-$(CONFIG_EEPROM)		+= core.o
>  
>  # Devices
>  obj-$(CONFIG_EEPROM_SUNXI_SID)	+= eeprom-sunxi-sid.o
> +obj-$(CONFIG_QCOM_QFPROM)	+= qfprom.o
> diff --git a/drivers/eeprom/qfprom.c b/drivers/eeprom/qfprom.c
> new file mode 100644
> index 0000000..371a8c0
> --- /dev/null
> +++ b/drivers/eeprom/qfprom.c
> @@ -0,0 +1,74 @@
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/err.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/eeprom-provider.h>

[...]

> +MODULE_LICENSE("GPL2");

This will taint the kernel on module load. I guess you meant
    MODULE_LICENSE("GPL v2");

but there's no comment with some lines about the license at the top of
this file, so I can't be sure.


Paul Bolle

(Chances are that by the end of this week everybody is so tired of
messages like this that people actually check this stuff before
submitting, and there's no need to review this anymore for the rest of
this year. That would be mission accomplished, I guess.)
