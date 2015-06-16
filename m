From: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v5 08/11] nvmem: qfprom: Add Qualcomm QFPROM support.
Date: Tue, 16 Jun 2015 16:00:43 -0700
Message-ID: <5580AA9B.7040001@codeaurora.org>
References: <1432226535-8640-1-git-send-email-srinivas.kandagatla@linaro.org> <1432226675-9039-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1432226675-9039-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, pantelis.antoniou@konsulko.com, mporter@konsulko.com
List-Id: linux-api@vger.kernel.org

On 05/21/2015 09:44 AM, Srinivas Kandagatla wrote:
> diff --git a/drivers/nvmem/Kconfig b/drivers/nvmem/Kconfig
> index f157b6d..e665e23 100644
> --- a/drivers/nvmem/Kconfig
> +++ b/drivers/nvmem/Kconfig
> @@ -8,3 +8,18 @@ menuconfig NVMEM
>  	  from both the Linux Kernel and the userspace.
>  
>  	  If unsure, say no.
> +
> +if NVMEM
> +
> +config QCOM_QFPROM
> +	tristate "QCOM QFPROM Support"
> +	depends on ARCH_QCOM

 || COMPILE_TEST?

> +	select REGMAP_MMIO
> +	help
> +	  Say y here to enable QFPROM support. The QFPROM provides access
> +	  functions for QFPROM data to rest of the drivers via nvmem interface.
> +
> +	  This driver can also be built as a module. If so, the module
> +	  will be called nvmem-qfprom.
> +
> +endif
> diff --git a/drivers/nvmem/Makefile b/drivers/nvmem/Makefile
> index f694cfc..caea611 100644
> --- a/drivers/nvmem/Makefile
> +++ b/drivers/nvmem/Makefile
> @@ -5,3 +5,7 @@
>  obj-$(CONFIG_NVMEM)		+= nvmem_core.o
>  nvmem_core-y			:= core.o
>  nvmem_core-y			+= nvmem-mmio.o
> +
> +# Devices
> +obj-$(CONFIG_QCOM_QFPROM)	+= nvmem_qfprom.o
> +nvmem_qfprom-y			:= qfprom.o

Why not just

obj-$(CONFIG_QCOM_QFPROM) += nvmem_qfprom.o

?

> diff --git a/drivers/nvmem/qfprom.c b/drivers/nvmem/qfprom.c
> new file mode 100644
> index 0000000..5ea84bb
> --- /dev/null
> +++ b/drivers/nvmem/qfprom.c
> @@ -0,0 +1,51 @@
> +/*
> + * Copyright (C) 2015 Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include "nvmem-mmio.h"
> +
> +static struct regmap_config qfprom_regmap_config = {

const?

> +	.reg_bits = 32,
> +	.val_bits = 8,
> +	.reg_stride = 1,
> +};
> +
> +static struct nvmem_config econfig = {

const?

> +	.name = "qfprom",
> +	.owner = THIS_MODULE,
> +};
> +
> +static struct nvmem_mmio_data qfprom_data = {

const?

> +	.nvmem_config = &econfig,
> +	.regmap_config = &qfprom_regmap_config,
> +};
>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
