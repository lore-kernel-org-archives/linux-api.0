From: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Subject: Re: [PATCH v2 01/11] coresight-etm4x: Adding CoreSight ETM4x driver
Date: Thu, 30 Apr 2015 23:29:57 +0200
Message-ID: <1430429397.2187.34.camel@x220>
References: <1430327795-10710-1-git-send-email-mathieu.poirier@linaro.org>
	 <1430327795-10710-2-git-send-email-mathieu.poirier@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430327795-10710-2-git-send-email-mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kaixu.xia-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2015-04-29 at 11:16 -0600, Mathieu Poirier wrote:
> --- a/drivers/hwtracing/coresight/Kconfig
> +++ b/drivers/hwtracing/coresight/Kconfig

> +config CORESIGHT_SOURCE_ETM4X
> +	bool "CoreSight Embedded Trace Macrocell 4.x driver"
> +	depends on ARM64
> +	select CORESIGHT_LINKS_AND_SINKS
> +	help
> +	  This driver provides support for the ETM4.x tracer module, tracing the
> +	  instructions that a processor is executing. This is primarily useful
> +	  for instruction level tracing. Depending on the implemented version
> +	  data tracing may also be available.

(Please add an empty line here.)

>  endif

> --- a/drivers/hwtracing/coresight/Makefile
> +++ b/drivers/hwtracing/coresight/Makefile

> +obj-$(CONFIG_CORESIGHT_SOURCE_ETM4X) += coresight-etm4x.o

CORESIGHT_SOURCE_ETM4X is a bool symbol, so coresight-etm4x.o can never
be part of a module, right?

(If I'm wrong, we're done here.)

> --- /dev/null
> +++ b/drivers/hwtracing/coresight/coresight-etm4x.c

> +#include <linux/module.h>

Is this include needed?

> +static struct amba_driver etm4x_driver = {
> +	.drv = {
> +		.name   = "coresight-etm4x",
> +		.owner  = THIS_MODULE,

For built-in code this is basically equivalent to NULL (see
include/linux/export.h).

> +	},
> +	.probe		= etm4_probe,
> +	.remove		= etm4_remove,
> +	.id_table	= etm4_ids,
> +};
> +
> +module_amba_driver(etm4x_driver);

In a message I sent a short while ago, I suggested that for built-in
only code this is equivalent to calling
    amba_driver_register(&etm4x_driver);

from within a function marked with some sort of *initcall(). Please
double check.

> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("CoreSight Embedded Trace Macrocell v4 driver");

These macros will be effectively be preprocessed away for built-in only
code.

(There is also a reference to module_param_named(). I don't know by
heart how that works for built-in only code, sorry.)


Paul Bolle
