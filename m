From: Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 08/13] iio: health/afe440x: Remove channel names
Date: Wed, 4 May 2016 11:08:01 +0100
Message-ID: <f0679a4f-c8f0-1712-e7fc-a61350734a03@kernel.org>
References: <1462135023-14445-1-git-send-email-afd@ti.com>
 <1462135023-14445-9-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462135023-14445-9-git-send-email-afd@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Andrew F. Davis" <afd@ti.com>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-iio@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 01/05/16 21:36, Andrew F. Davis wrote:
> These AFEs have 4 ADC mesuring stages (called LED2, ALED2, LED1, and
> ALED1 in the datasheet), we map these as channels, these stages can serve
> different purposes depending on the application. For instance the AFE4404
> has an additional LED (LED3), this LED can be timed to be active during
> stage 2 (or anystage, but the datasheet describes this case and the name
> of the stage reflects this use). This ability is used further in upcoming
> parts that tie the front-end gain and the LED timings together. For these
> reasons we remove explicit naming the channels.
> 
> Without channel names it is best that the index numbers are in order to
> match the stage number, reorder the channel numbers.
> 
> Signed-off-by: Andrew F. Davis <afd@ti.com>
Youch - this is rather major surgery.

Hmm. Given how non standard an ABI we ended up with in the first place
again, let us cross our fingers that all the userspace for this is
effectively under your control currently.

Getting a little more nervous about this - but worth the risk I think
for the simpler result.

Applied

Jonathan
> ---
>  .../ABI/testing/sysfs-bus-iio-health-afe440x       | 39 ++++++++++------------
>  drivers/iio/health/afe4403.c                       | 28 ++++++++--------
>  drivers/iio/health/afe4404.c                       | 30 ++++++++---------
>  drivers/iio/health/afe440x.h                       |  8 ++---
>  4 files changed, 51 insertions(+), 54 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-health-afe440x b/Documentation/ABI/testing/sysfs-bus-iio-health-afe440x
> index b19053a..a067073 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio-health-afe440x
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-health-afe440x
> @@ -8,38 +8,35 @@ Description:
>  		Transimpedance Amplifier. Y is 1 for Rf1 and Cf1, Y is 2 for
>  		Rf2 and Cf2 values.
>  
> -What:		/sys/bus/iio/devices/iio:deviceX/in_intensity_ledY_raw
> -		/sys/bus/iio/devices/iio:deviceX/in_intensity_ledY_ambient_raw
> -Date:		December 2015
> +What:		/sys/bus/iio/devices/iio:deviceX/in_intensityY_raw
> +Date:		May 2016
>  KernelVersion:
>  Contact:	Andrew F. Davis <afd@ti.com>
>  Description:
>  		Get measured values from the ADC for these stages. Y is the
> -		specific LED number. The values are expressed in 24-bit twos
> -		complement.
> -
> -What:		/sys/bus/iio/devices/iio:deviceX/in_intensity_ledY-ledY_ambient_raw
> -Date:		December 2015
> -KernelVersion:
> -Contact:	Andrew F. Davis <afd@ti.com>
> -Description:
> -		Get differential values from the ADC for these stages. Y is the
> -		specific LED number. The values are expressed in 24-bit twos
> -		complement for the specified LEDs.
> +		specific stage number corresponding to datasheet stage names
> +		as follows:
> +		1 -> LED2
> +		2 -> ALED2/LED3
> +		3 -> LED1
> +		4 -> ALED1/LED4
> +		Note that channels 5 and 6 represent LED2-ALED2 and LED1-ALED1
> +		respectively which simply helper channels containing the
> +		calculated difference in the value of stage 1 - 2 and 3 - 4.
> +		The values are expressed in 24-bit twos complement.
>  
> -What:		/sys/bus/iio/devices/iio:deviceX/out_current_ledY_offset
> -		/sys/bus/iio/devices/iio:deviceX/out_current_ledY_ambient_offset
> -Date:		December 2015
> +What:		/sys/bus/iio/devices/iio:deviceX/in_intensityY_offset
> +Date:		May 2016
>  KernelVersion:
>  Contact:	Andrew F. Davis <afd@ti.com>
>  Description:
>  		Get and set the offset cancellation DAC setting for these
>  		stages. The values are expressed in 5-bit sign-magnitude.
>  
> -What:		/sys/bus/iio/devices/iio:deviceX/out_current_ledY_raw
> -Date:		December 2015
> +What:		/sys/bus/iio/devices/iio:deviceX/out_currentY_raw
> +Date:		May 2016
>  KernelVersion:
>  Contact:	Andrew F. Davis <afd@ti.com>
>  Description:
> -		Get and set the LED current for the specified LED. Y is the
> -		specific LED number.
> +		Get and set the LED current for the specified LED active during
> +		this stage. Y is the specific stage number.
> diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
> index cac6090..4a58064 100644
> --- a/drivers/iio/health/afe4403.c
> +++ b/drivers/iio/health/afe4403.c
> @@ -121,38 +121,38 @@ struct afe4403_data {
>  };
>  
>  enum afe4403_chan_id {
> +	LED2 = 1,
> +	ALED2,
>  	LED1,
>  	ALED1,
> -	LED2,
> -	ALED2,
> -	LED1_ALED1,
>  	LED2_ALED2,
> +	LED1_ALED1,
>  	ILED1,
>  	ILED2,
>  };
>  
>  static const struct afe440x_reg_info afe4403_reg_info[] = {
> -	[LED1] = AFE440X_REG_INFO(AFE440X_LED1VAL, 0, NULL),
> -	[ALED1] = AFE440X_REG_INFO(AFE440X_ALED1VAL, 0, NULL),
>  	[LED2] = AFE440X_REG_INFO(AFE440X_LED2VAL, 0, NULL),
>  	[ALED2] = AFE440X_REG_INFO(AFE440X_ALED2VAL, 0, NULL),
> -	[LED1_ALED1] = AFE440X_REG_INFO(AFE440X_LED1_ALED1VAL, 0, NULL),
> +	[LED1] = AFE440X_REG_INFO(AFE440X_LED1VAL, 0, NULL),
> +	[ALED1] = AFE440X_REG_INFO(AFE440X_ALED1VAL, 0, NULL),
>  	[LED2_ALED2] = AFE440X_REG_INFO(AFE440X_LED2_ALED2VAL, 0, NULL),
> +	[LED1_ALED1] = AFE440X_REG_INFO(AFE440X_LED1_ALED1VAL, 0, NULL),
>  	[ILED1] = AFE440X_REG_INFO(AFE440X_LEDCNTRL, 0, AFE440X_LEDCNTRL_LED1),
>  	[ILED2] = AFE440X_REG_INFO(AFE440X_LEDCNTRL, 0, AFE440X_LEDCNTRL_LED2),
>  };
>  
>  static const struct iio_chan_spec afe4403_channels[] = {
>  	/* ADC values */
> -	AFE440X_INTENSITY_CHAN(LED1, "led1", 0),
> -	AFE440X_INTENSITY_CHAN(ALED1, "led1_ambient", 0),
> -	AFE440X_INTENSITY_CHAN(LED2, "led2", 0),
> -	AFE440X_INTENSITY_CHAN(ALED2, "led2_ambient", 0),
> -	AFE440X_INTENSITY_CHAN(LED1_ALED1, "led1-led1_ambient", 0),
> -	AFE440X_INTENSITY_CHAN(LED2_ALED2, "led2-led2_ambient", 0),
> +	AFE440X_INTENSITY_CHAN(LED2, 0),
> +	AFE440X_INTENSITY_CHAN(ALED2, 0),
> +	AFE440X_INTENSITY_CHAN(LED1, 0),
> +	AFE440X_INTENSITY_CHAN(ALED1, 0),
> +	AFE440X_INTENSITY_CHAN(LED2_ALED2, 0),
> +	AFE440X_INTENSITY_CHAN(LED1_ALED1, 0),
>  	/* LED current */
> -	AFE440X_CURRENT_CHAN(ILED1, "led1"),
> -	AFE440X_CURRENT_CHAN(ILED2, "led2"),
> +	AFE440X_CURRENT_CHAN(ILED1),
> +	AFE440X_CURRENT_CHAN(ILED2),
>  };
>  
>  static const struct afe440x_val_table afe4403_res_table[] = {
> diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
> index 2edb7d7..7806a45 100644
> --- a/drivers/iio/health/afe4404.c
> +++ b/drivers/iio/health/afe4404.c
> @@ -122,24 +122,24 @@ struct afe4404_data {
>  };
>  
>  enum afe4404_chan_id {
> +	LED2 = 1,
> +	ALED2,
>  	LED1,
>  	ALED1,
> -	LED2,
> -	ALED2,
> -	LED1_ALED1,
>  	LED2_ALED2,
> +	LED1_ALED1,
>  	ILED1,
>  	ILED2,
>  	ILED3,
>  };
>  
>  static const struct afe440x_reg_info afe4404_reg_info[] = {
> -	[LED1] = AFE440X_REG_INFO(AFE440X_LED1VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_LED1),
> -	[ALED1] = AFE440X_REG_INFO(AFE440X_ALED1VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_ALED1),
>  	[LED2] = AFE440X_REG_INFO(AFE440X_LED2VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_LED2),
>  	[ALED2] = AFE440X_REG_INFO(AFE440X_ALED2VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_ALED2),
> -	[LED1_ALED1] = AFE440X_REG_INFO(AFE440X_LED1_ALED1VAL, 0, NULL),
> +	[LED1] = AFE440X_REG_INFO(AFE440X_LED1VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_LED1),
> +	[ALED1] = AFE440X_REG_INFO(AFE440X_ALED1VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_ALED1),
>  	[LED2_ALED2] = AFE440X_REG_INFO(AFE440X_LED2_ALED2VAL, 0, NULL),
> +	[LED1_ALED1] = AFE440X_REG_INFO(AFE440X_LED1_ALED1VAL, 0, NULL),
>  	[ILED1] = AFE440X_REG_INFO(AFE440X_LEDCNTRL, 0, AFE4404_LEDCNTRL_ILED1),
>  	[ILED2] = AFE440X_REG_INFO(AFE440X_LEDCNTRL, 0, AFE4404_LEDCNTRL_ILED2),
>  	[ILED3] = AFE440X_REG_INFO(AFE440X_LEDCNTRL, 0, AFE4404_LEDCNTRL_ILED3),
> @@ -147,16 +147,16 @@ static const struct afe440x_reg_info afe4404_reg_info[] = {
>  
>  static const struct iio_chan_spec afe4404_channels[] = {
>  	/* ADC values */
> -	AFE440X_INTENSITY_CHAN(LED1, "led1", BIT(IIO_CHAN_INFO_OFFSET)),
> -	AFE440X_INTENSITY_CHAN(ALED1, "led1_ambient", BIT(IIO_CHAN_INFO_OFFSET)),
> -	AFE440X_INTENSITY_CHAN(LED2, "led2", BIT(IIO_CHAN_INFO_OFFSET)),
> -	AFE440X_INTENSITY_CHAN(ALED2, "led2_ambient", BIT(IIO_CHAN_INFO_OFFSET)),
> -	AFE440X_INTENSITY_CHAN(LED1_ALED1, "led1-led1_ambient", 0),
> -	AFE440X_INTENSITY_CHAN(LED2_ALED2, "led2-led2_ambient", 0),
> +	AFE440X_INTENSITY_CHAN(LED2, BIT(IIO_CHAN_INFO_OFFSET)),
> +	AFE440X_INTENSITY_CHAN(ALED2, BIT(IIO_CHAN_INFO_OFFSET)),
> +	AFE440X_INTENSITY_CHAN(LED1, BIT(IIO_CHAN_INFO_OFFSET)),
> +	AFE440X_INTENSITY_CHAN(ALED1, BIT(IIO_CHAN_INFO_OFFSET)),
> +	AFE440X_INTENSITY_CHAN(LED2_ALED2, 0),
> +	AFE440X_INTENSITY_CHAN(LED1_ALED1, 0),
>  	/* LED current */
> -	AFE440X_CURRENT_CHAN(ILED1, "led1"),
> -	AFE440X_CURRENT_CHAN(ILED2, "led2"),
> -	AFE440X_CURRENT_CHAN(ILED3, "led3"),
> +	AFE440X_CURRENT_CHAN(ILED1),
> +	AFE440X_CURRENT_CHAN(ILED2),
> +	AFE440X_CURRENT_CHAN(ILED3),
>  };
>  
>  static const struct afe440x_val_table afe4404_res_table[] = {
> diff --git a/drivers/iio/health/afe440x.h b/drivers/iio/health/afe440x.h
> index 583d071..713972f 100644
> --- a/drivers/iio/health/afe440x.h
> +++ b/drivers/iio/health/afe440x.h
> @@ -103,7 +103,7 @@ struct afe440x_reg_info {
>  		.mask = _sm ## _MASK,				\
>  	}
>  
> -#define AFE440X_INTENSITY_CHAN(_index, _name, _mask)		\
> +#define AFE440X_INTENSITY_CHAN(_index, _mask)			\
>  	{							\
>  		.type = IIO_INTENSITY,				\
>  		.channel = _index,				\
> @@ -115,20 +115,20 @@ struct afe440x_reg_info {
>  				.storagebits = 32,		\
>  				.endianness = IIO_CPU,		\
>  		},						\
> -		.extend_name = _name,				\
>  		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |	\
>  			_mask,					\
> +		.indexed = true,				\
>  	}
>  
> -#define AFE440X_CURRENT_CHAN(_index, _name)			\
> +#define AFE440X_CURRENT_CHAN(_index)				\
>  	{							\
>  		.type = IIO_CURRENT,				\
>  		.channel = _index,				\
>  		.address = _index,				\
>  		.scan_index = -1,				\
> -		.extend_name = _name,				\
>  		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |	\
>  			BIT(IIO_CHAN_INFO_SCALE),		\
> +		.indexed = true,				\
>  		.output = true,					\
>  	}
>  
> 
