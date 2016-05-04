From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/13] iio: health/afe440x: Fix kernel-doc format
Date: Wed, 4 May 2016 10:58:32 +0100
Message-ID: <3597f852-8c82-3ae1-d6a1-d82ac0dceae2@kernel.org>
References: <1462135023-14445-1-git-send-email-afd@ti.com>
 <1462135023-14445-2-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462135023-14445-2-git-send-email-afd-l0cyMroinI0@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 01/05/16 21:36, Andrew F. Davis wrote:
> Fix kernel-doc formatting for structs, and while we are making little
> fixes, clarify the module description and update the copywrite.
> 
> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
Applied to the togreg branch of iio.git - to be pushed out in a day or two
as testing.

Thanks,

Jonathan
> ---
>  drivers/iio/health/afe4403.c | 18 +++++++++---------
>  drivers/iio/health/afe4404.c | 16 ++++++++--------
>  2 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
> index 88e43f8..2094113 100644
> --- a/drivers/iio/health/afe4403.c
> +++ b/drivers/iio/health/afe4403.c
> @@ -1,7 +1,7 @@
>  /*
>   * AFE4403 Heart Rate Monitors and Low-Cost Pulse Oximeters
>   *
> - * Copyright (C) 2015 Texas Instruments Incorporated - http://www.ti.com/
> + * Copyright (C) 2015-2016 Texas Instruments Incorporated - http://www.ti.com/
>   *	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
>   *
>   * This program is free software; you can redistribute it and/or modify
> @@ -103,13 +103,13 @@
>  #define AFE4403_TIAGAIN_RES_NONE	0x7
>  
>  /**
> - * struct afe4403_data
> - * @dev - Device structure
> - * @spi - SPI device handle
> - * @regmap - Register map of the device
> - * @regulator - Pointer to the regulator for the IC
> - * @trig - IIO trigger for this device
> - * @irq - ADC_RDY line interrupt number
> + * struct afe4403_data - AFE4403 device instance data
> + * @dev: Device structure
> + * @spi: SPI device handle
> + * @regmap: Register map of the device
> + * @regulator: Pointer to the regulator for the IC
> + * @trig: IIO trigger for this device
> + * @irq: ADC_RDY line interrupt number
>   */
>  struct afe4403_data {
>  	struct device *dev;
> @@ -704,5 +704,5 @@ static struct spi_driver afe4403_spi_driver = {
>  module_spi_driver(afe4403_spi_driver);
>  
>  MODULE_AUTHOR("Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>");
> -MODULE_DESCRIPTION("TI AFE4403 Heart Rate and Pulse Oximeter");
> +MODULE_DESCRIPTION("TI AFE4403 Heart Rate Monitor and Pulse Oximeter AFE");
>  MODULE_LICENSE("GPL v2");
> diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
> index 5096a46..7127d03 100644
> --- a/drivers/iio/health/afe4404.c
> +++ b/drivers/iio/health/afe4404.c
> @@ -1,7 +1,7 @@
>  /*
>   * AFE4404 Heart Rate Monitors and Low-Cost Pulse Oximeters
>   *
> - * Copyright (C) 2015 Texas Instruments Incorporated - http://www.ti.com/
> + * Copyright (C) 2015-2016 Texas Instruments Incorporated - http://www.ti.com/
>   *	Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
>   *
>   * This program is free software; you can redistribute it and/or modify
> @@ -106,12 +106,12 @@
>  #define AFE4404_TIA_GAIN_RES_2_M	0x7
>  
>  /**
> - * struct afe4404_data
> - * @dev - Device structure
> - * @regmap - Register map of the device
> - * @regulator - Pointer to the regulator for the IC
> - * @trig - IIO trigger for this device
> - * @irq - ADC_RDY line interrupt number
> + * struct afe4404_data - AFE4404 device instance data
> + * @dev: Device structure
> + * @regmap: Register map of the device
> + * @regulator: Pointer to the regulator for the IC
> + * @trig: IIO trigger for this device
> + * @irq: ADC_RDY line interrupt number
>   */
>  struct afe4404_data {
>  	struct device *dev;
> @@ -675,5 +675,5 @@ static struct i2c_driver afe4404_i2c_driver = {
>  module_i2c_driver(afe4404_i2c_driver);
>  
>  MODULE_AUTHOR("Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>");
> -MODULE_DESCRIPTION("TI AFE4404 Heart Rate and Pulse Oximeter");
> +MODULE_DESCRIPTION("TI AFE4404 Heart Rate Monitor and Pulse Oximeter AFE");
>  MODULE_LICENSE("GPL v2");
> 
