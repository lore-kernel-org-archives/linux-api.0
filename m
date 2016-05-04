From: Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 10/13] iio: health/afe440x: Make gain settings a modifier
 for the stages
Date: Wed, 4 May 2016 11:12:25 +0100
Message-ID: <817330f6-5e03-043f-3571-c61df9ae4580@kernel.org>
References: <1462135023-14445-1-git-send-email-afd@ti.com>
 <1462135023-14445-11-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462135023-14445-11-git-send-email-afd@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Andrew F. Davis" <afd@ti.com>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-iio@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 01/05/16 21:37, Andrew F. Davis wrote:
> Currently the TIA gain settings are exported to userspace as sysfs
> entries that do not clearly represent their internal relation to the
> sampling stages. The gain settings are enabled on a per-stage basis,
> this can be seen in figure 24 of the current AFE4404 datasheet.
> These gain settings should therefore be tied to the channels that are
> read during these stages. Make this change here.
> 
> Signed-off-by: Andrew F. Davis <afd@ti.com>
I'd not understood this right originally.  Good to clear this up!

Applied.  I'll add a reply to the cover letter later explaining why
I am risking these ABI changes, whilst bouncing back much smaller ones.

Jonathan
> ---
>  .../ABI/testing/sysfs-bus-iio-health-afe440x       | 19 ++++++------
>  drivers/iio/health/afe4403.c                       | 34 ++++++++++++++--------
>  drivers/iio/health/afe4404.c                       | 34 ++++++++++++++--------
>  3 files changed, 53 insertions(+), 34 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-health-afe440x b/Documentation/ABI/testing/sysfs-bus-iio-health-afe440x
> index a067073..6adba90 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio-health-afe440x
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-health-afe440x
> @@ -1,13 +1,3 @@
> -What:		/sys/bus/iio/devices/iio:deviceX/tia_resistanceY
> -		/sys/bus/iio/devices/iio:deviceX/tia_capacitanceY
> -Date:		December 2015
> -KernelVersion:
> -Contact:	Andrew F. Davis <afd@ti.com>
> -Description:
> -		Get and set the resistance and the capacitance settings for the
> -		Transimpedance Amplifier. Y is 1 for Rf1 and Cf1, Y is 2 for
> -		Rf2 and Cf2 values.
> -
>  What:		/sys/bus/iio/devices/iio:deviceX/in_intensityY_raw
>  Date:		May 2016
>  KernelVersion:
> @@ -33,6 +23,15 @@ Description:
>  		Get and set the offset cancellation DAC setting for these
>  		stages. The values are expressed in 5-bit sign-magnitude.
>  
> +What:		/sys/bus/iio/devices/iio:deviceX/in_intensityY_resistance
> +What:		/sys/bus/iio/devices/iio:deviceX/in_intensityY_capacitance
> +Date:		May 2016
> +KernelVersion:
> +Contact:	Andrew F. Davis <afd@ti.com>
> +Description:
> +		Get and set the resistance and the capacitance settings for the
> +		Transimpedance Amplifier during the associated stage.
> +
>  What:		/sys/bus/iio/devices/iio:deviceX/out_currentY_raw
>  Date:		May 2016
>  KernelVersion:
> diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
> index 1950155..610631b 100644
> --- a/drivers/iio/health/afe4403.c
> +++ b/drivers/iio/health/afe4403.c
> @@ -161,7 +161,7 @@ static const struct afe440x_val_table afe4403_res_table[] = {
>  	{ 500000 }, { 250000 }, { 100000 }, { 50000 },
>  	{ 25000 }, { 10000 }, { 1000000 }, { 0 },
>  };
> -AFE440X_TABLE_ATTR(tia_resistance_available, afe4403_res_table);
> +AFE440X_TABLE_ATTR(in_intensity_resistance_available, afe4403_res_table);
>  
>  static const struct afe440x_val_table afe4403_cap_table[] = {
>  	{ 0, 5000 }, { 0, 10000 }, { 0, 20000 }, { 0, 25000 },
> @@ -173,7 +173,7 @@ static const struct afe440x_val_table afe4403_cap_table[] = {
>  	{ 0, 205000 }, { 0, 210000 }, { 0, 220000 }, { 0, 225000 },
>  	{ 0, 230000 }, { 0, 235000 }, { 0, 245000 }, { 0, 250000 },
>  };
> -AFE440X_TABLE_ATTR(tia_capacitance_available, afe4403_cap_table);
> +AFE440X_TABLE_ATTR(in_intensity_capacitance_available, afe4403_cap_table);
>  
>  static ssize_t afe440x_show_register(struct device *dev,
>  				     struct device_attribute *attr,
> @@ -226,19 +226,29 @@ static ssize_t afe440x_store_register(struct device *dev,
>  	return count;
>  }
>  
> -static AFE440X_ATTR(tia_resistance1, F_RF_LED1, afe4403_res_table);
> -static AFE440X_ATTR(tia_capacitance1, F_CF_LED1, afe4403_cap_table);
> +static AFE440X_ATTR(in_intensity1_resistance, F_RF_LED, afe4403_res_table);
> +static AFE440X_ATTR(in_intensity1_capacitance, F_CF_LED, afe4403_cap_table);
>  
> -static AFE440X_ATTR(tia_resistance2, F_RF_LED, afe4403_res_table);
> -static AFE440X_ATTR(tia_capacitance2, F_CF_LED, afe4403_cap_table);
> +static AFE440X_ATTR(in_intensity2_resistance, F_RF_LED, afe4403_res_table);
> +static AFE440X_ATTR(in_intensity2_capacitance, F_CF_LED, afe4403_cap_table);
> +
> +static AFE440X_ATTR(in_intensity3_resistance, F_RF_LED1, afe4403_res_table);
> +static AFE440X_ATTR(in_intensity3_capacitance, F_CF_LED1, afe4403_cap_table);
> +
> +static AFE440X_ATTR(in_intensity4_resistance, F_RF_LED1, afe4403_res_table);
> +static AFE440X_ATTR(in_intensity4_capacitance, F_CF_LED1, afe4403_cap_table);
>  
>  static struct attribute *afe440x_attributes[] = {
> -	&afe440x_attr_tia_resistance1.dev_attr.attr,
> -	&afe440x_attr_tia_capacitance1.dev_attr.attr,
> -	&afe440x_attr_tia_resistance2.dev_attr.attr,
> -	&afe440x_attr_tia_capacitance2.dev_attr.attr,
> -	&dev_attr_tia_resistance_available.attr,
> -	&dev_attr_tia_capacitance_available.attr,
> +	&dev_attr_in_intensity_resistance_available.attr,
> +	&dev_attr_in_intensity_capacitance_available.attr,
> +	&afe440x_attr_in_intensity1_resistance.dev_attr.attr,
> +	&afe440x_attr_in_intensity1_capacitance.dev_attr.attr,
> +	&afe440x_attr_in_intensity2_resistance.dev_attr.attr,
> +	&afe440x_attr_in_intensity2_capacitance.dev_attr.attr,
> +	&afe440x_attr_in_intensity3_resistance.dev_attr.attr,
> +	&afe440x_attr_in_intensity3_capacitance.dev_attr.attr,
> +	&afe440x_attr_in_intensity4_resistance.dev_attr.attr,
> +	&afe440x_attr_in_intensity4_capacitance.dev_attr.attr,
>  	NULL
>  };
>  
> diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
> index 0d1af4a..69116cd 100644
> --- a/drivers/iio/health/afe4404.c
> +++ b/drivers/iio/health/afe4404.c
> @@ -179,7 +179,7 @@ static const struct afe440x_val_table afe4404_res_table[] = {
>  	{ .integer = 1000000, .fract = 0 },
>  	{ .integer = 2000000, .fract = 0 },
>  };
> -AFE440X_TABLE_ATTR(tia_resistance_available, afe4404_res_table);
> +AFE440X_TABLE_ATTR(in_intensity_resistance_available, afe4404_res_table);
>  
>  static const struct afe440x_val_table afe4404_cap_table[] = {
>  	{ .integer = 0, .fract = 5000 },
> @@ -191,7 +191,7 @@ static const struct afe440x_val_table afe4404_cap_table[] = {
>  	{ .integer = 0, .fract = 25000 },
>  	{ .integer = 0, .fract = 22500 },
>  };
> -AFE440X_TABLE_ATTR(tia_capacitance_available, afe4404_cap_table);
> +AFE440X_TABLE_ATTR(in_intensity_capacitance_available, afe4404_cap_table);
>  
>  static ssize_t afe440x_show_register(struct device *dev,
>  				     struct device_attribute *attr,
> @@ -244,19 +244,29 @@ static ssize_t afe440x_store_register(struct device *dev,
>  	return count;
>  }
>  
> -static AFE440X_ATTR(tia_resistance1, F_TIA_GAIN, afe4404_res_table);
> -static AFE440X_ATTR(tia_capacitance1, TIA_CF, afe4404_cap_table);
> +static AFE440X_ATTR(in_intensity1_resistance, F_TIA_GAIN_SEP, afe4404_res_table);
> +static AFE440X_ATTR(in_intensity1_capacitance, F_TIA_CF_SEP, afe4404_cap_table);
>  
> -static AFE440X_ATTR(tia_resistance2, F_TIA_GAIN_SEP, afe4404_res_table);
> -static AFE440X_ATTR(tia_capacitance2, F_TIA_CF_SEP, afe4404_cap_table);
> +static AFE440X_ATTR(in_intensity2_resistance, F_TIA_GAIN_SEP, afe4404_res_table);
> +static AFE440X_ATTR(in_intensity2_capacitance, F_TIA_CF_SEP, afe4404_cap_table);
> +
> +static AFE440X_ATTR(in_intensity3_resistance, F_TIA_GAIN, afe4404_res_table);
> +static AFE440X_ATTR(in_intensity3_capacitance, TIA_CF, afe4404_cap_table);
> +
> +static AFE440X_ATTR(in_intensity4_resistance, F_TIA_GAIN, afe4404_res_table);
> +static AFE440X_ATTR(in_intensity4_capacitance, TIA_CF, afe4404_cap_table);
>  
>  static struct attribute *afe440x_attributes[] = {
> -	&afe440x_attr_tia_resistance1.dev_attr.attr,
> -	&afe440x_attr_tia_capacitance1.dev_attr.attr,
> -	&afe440x_attr_tia_resistance2.dev_attr.attr,
> -	&afe440x_attr_tia_capacitance2.dev_attr.attr,
> -	&dev_attr_tia_resistance_available.attr,
> -	&dev_attr_tia_capacitance_available.attr,
> +	&dev_attr_in_intensity_resistance_available.attr,
> +	&dev_attr_in_intensity_capacitance_available.attr,
> +	&afe440x_attr_in_intensity1_resistance.dev_attr.attr,
> +	&afe440x_attr_in_intensity1_capacitance.dev_attr.attr,
> +	&afe440x_attr_in_intensity2_resistance.dev_attr.attr,
> +	&afe440x_attr_in_intensity2_capacitance.dev_attr.attr,
> +	&afe440x_attr_in_intensity3_resistance.dev_attr.attr,
> +	&afe440x_attr_in_intensity3_capacitance.dev_attr.attr,
> +	&afe440x_attr_in_intensity4_resistance.dev_attr.attr,
> +	&afe440x_attr_in_intensity4_capacitance.dev_attr.attr,
>  	NULL
>  };
>  
> 
