From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/3] iio: hmc5843: Add attributes for measurement
 config of bias current
Date: Sun, 21 Feb 2016 20:26:35 +0000
Message-ID: <56CA1D7B.9020207@kernel.org>
References: <1455489459-20422-1-git-send-email-cristina.moraru09@gmail.com>
 <1455489459-20422-2-git-send-email-cristina.moraru09@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455489459-20422-2-git-send-email-cristina.moraru09-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cristina Moraru <cristina.moraru09-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, knaack.h-Mmb7MZpHnFY@public.gmane.org, lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org, pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cristina.opriceana-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, marek-xXXSsgcRVICgSpxsJD1C4w@public.gmane.org, sdliyong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, k.kozlowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, afd-l0cyMroinI0@public.gmane.org, javier-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 14/02/16 22:37, Cristina Moraru wrote:
> Change static attribute meas_conf for bias current configuration
> to channel attribute in_magn_meas_conf and also add
> in_magn_meas_conf_available attribute to view available configurations.
> 
> This patch solves functionality bug: driver was using same function
> hmc5843_set_measurement_configuration for setting bias current config
> for all device types but the function was returning -EINVAL for any
> setting >= 0x03 although, for sensor HMC5983, value 3 is valid.
> 
> API for setting bias measurement configuration:
> 
> normal - 	Normal measurement configuration (default):
> 		In normal measurement configuration the device
> 		follows normal measurement flow. Pins BP and BN
> 		are left floating and high impedance.
> 
> positivebias - 	Positive bias configuration: In positive bias
> 		configuration, a positive current is forced across
> 		the resistive load on pins BP and BN.
> 
> negativebias - 	Negative bias configuration. In negative bias
> 		configuration, a negative current is forced across
> 		the resistive load on pins BP and BN.
> 
> disabled     - 	Only available on HMC5983. Magnetic sensor is disabled.
> 		Temperature sensor is enabled.
> 
> Signed-off-by: Cristina Moraru <cristina.moraru09-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Daniel Baluta <daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Hmm. I do slightly wonder if we can come up with a more generic name for this
as I doubt this will be the last magnetometer we ever see with this sort
of functionality.

Lets leave it be for now as it is not too much a burden to support a more
generic interface in addition to this one in the future.

Applied to the togreg branch of iio.git - initialy pushed out as testing for
the auto builders to play with it.

Thanks,

Jonathan
> ---
> Changes since v1:
>         Changed user interface for bias configuration from
>         integer values to string values in order to make it
>         more suggestive.
>         Used iio_enum from implementation.
>  drivers/staging/iio/magnetometer/hmc5843_core.c | 133 ++++++++++++++++--------
>  1 file changed, 87 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/staging/iio/magnetometer/hmc5843_core.c b/drivers/staging/iio/magnetometer/hmc5843_core.c
> index e270ea1..77882b4 100644
> --- a/drivers/staging/iio/magnetometer/hmc5843_core.c
> +++ b/drivers/staging/iio/magnetometer/hmc5843_core.c
> @@ -65,6 +65,33 @@
>  #define HMC5843_MEAS_CONF_NEGATIVE_BIAS		0x02
>  #define HMC5843_MEAS_CONF_MASK			0x03
>  
> +/*
> + * API for setting the measurement configuration to
> + * Normal, Positive bias and Negative bias
> + *
> + * From the datasheet:
> + * 0 - Normal measurement configuration (default): In normal measurement
> + *     configuration the device follows normal measurement flow. Pins BP
> + *     and BN are left floating and high impedance.
> + *
> + * 1 - Positive bias configuration: In positive bias configuration, a
> + *     positive current is forced across the resistive load on pins BP
> + *     and BN.
> + *
> + * 2 - Negative bias configuration. In negative bias configuration, a
> + *     negative current is forced across the resistive load on pins BP
> + *     and BN.
> + *
> + * 3 - Only available on HMC5983. Magnetic sensor is disabled.
> + *     Temperature sensor is enabled.
> + */
> +
> +static const char *const hmc5843_meas_conf_modes[] = {"normal", "positivebias",
> +						      "negativebias"};
> +
> +static const char *const hmc5983_meas_conf_modes[] = {"normal", "positivebias",
> +						      "negativebias",
> +						      "disabled"};
>  /* Scaling factors: 10000000/Gain */
>  static const int hmc5843_regval_to_nanoscale[] = {
>  	6173, 7692, 10309, 12821, 18868, 21739, 25641, 35714
> @@ -173,24 +200,6 @@ static int hmc5843_read_measurement(struct hmc5843_data *data,
>  	return IIO_VAL_INT;
>  }
>  
> -/*
> - * API for setting the measurement configuration to
> - * Normal, Positive bias and Negative bias
> - *
> - * From the datasheet:
> - * 0 - Normal measurement configuration (default): In normal measurement
> - *     configuration the device follows normal measurement flow. Pins BP
> - *     and BN are left floating and high impedance.
> - *
> - * 1 - Positive bias configuration: In positive bias configuration, a
> - *     positive current is forced across the resistive load on pins BP
> - *     and BN.
> - *
> - * 2 - Negative bias configuration. In negative bias configuration, a
> - *     negative current is forced across the resistive load on pins BP
> - *     and BN.
> - *
> - */
>  static int hmc5843_set_meas_conf(struct hmc5843_data *data, u8 meas_conf)
>  {
>  	int ret;
> @@ -204,48 +213,55 @@ static int hmc5843_set_meas_conf(struct hmc5843_data *data, u8 meas_conf)
>  }
>  
>  static
> -ssize_t hmc5843_show_measurement_configuration(struct device *dev,
> -					       struct device_attribute *attr,
> -					       char *buf)
> +int hmc5843_show_measurement_configuration(struct iio_dev *indio_dev,
> +					   const struct iio_chan_spec *chan)
>  {
> -	struct hmc5843_data *data = iio_priv(dev_to_iio_dev(dev));
> +	struct hmc5843_data *data = iio_priv(indio_dev);
>  	unsigned int val;
>  	int ret;
>  
>  	ret = regmap_read(data->regmap, HMC5843_CONFIG_REG_A, &val);
>  	if (ret)
>  		return ret;
> -	val &= HMC5843_MEAS_CONF_MASK;
>  
> -	return sprintf(buf, "%d\n", val);
> +	return val & HMC5843_MEAS_CONF_MASK;
>  }
>  
>  static
> -ssize_t hmc5843_set_measurement_configuration(struct device *dev,
> -					      struct device_attribute *attr,
> -					      const char *buf,
> -					      size_t count)
> +int hmc5843_set_measurement_configuration(struct iio_dev *indio_dev,
> +					  const struct iio_chan_spec *chan,
> +					  unsigned int meas_conf)
>  {
> -	struct hmc5843_data *data = iio_priv(dev_to_iio_dev(dev));
> -	unsigned long meas_conf = 0;
> -	int ret;
> +	struct hmc5843_data *data = iio_priv(indio_dev);
>  
> -	ret = kstrtoul(buf, 10, &meas_conf);
> -	if (ret)
> -		return ret;
> -	if (meas_conf >= HMC5843_MEAS_CONF_MASK)
> -		return -EINVAL;
> +	return hmc5843_set_meas_conf(data, meas_conf);
> +}
>  
> -	ret = hmc5843_set_meas_conf(data, meas_conf);
> +static const struct iio_enum hmc5843_meas_conf_enum = {
> +	.items = hmc5843_meas_conf_modes,
> +	.num_items = ARRAY_SIZE(hmc5843_meas_conf_modes),
> +	.get = hmc5843_show_measurement_configuration,
> +	.set = hmc5843_set_measurement_configuration,
> +};
>  
> -	return (ret < 0) ? ret : count;
> -}
> +static const struct iio_chan_spec_ext_info hmc5843_ext_info[] = {
> +	IIO_ENUM("meas_conf", true, &hmc5843_meas_conf_enum),
> +	IIO_ENUM_AVAILABLE("meas_conf", &hmc5843_meas_conf_enum),
> +	{ },
> +};
>  
> -static IIO_DEVICE_ATTR(meas_conf,
> -			S_IWUSR | S_IRUGO,
> -			hmc5843_show_measurement_configuration,
> -			hmc5843_set_measurement_configuration,
> -			0);
> +static const struct iio_enum hmc5983_meas_conf_enum = {
> +	.items = hmc5983_meas_conf_modes,
> +	.num_items = ARRAY_SIZE(hmc5983_meas_conf_modes),
> +	.get = hmc5843_show_measurement_configuration,
> +	.set = hmc5843_set_measurement_configuration,
> +};
> +
> +static const struct iio_chan_spec_ext_info hmc5983_ext_info[] = {
> +	IIO_ENUM("meas_conf", true, &hmc5983_meas_conf_enum),
> +	IIO_ENUM_AVAILABLE("meas_conf", &hmc5983_meas_conf_enum),
> +	{ },
> +};
>  
>  static
>  ssize_t hmc5843_show_samp_freq_avail(struct device *dev,
> @@ -458,6 +474,25 @@ done:
>  			.storagebits = 16,				\
>  			.endianness = IIO_BE,				\
>  		},							\
> +		.ext_info = hmc5843_ext_info,	\
> +	}
> +
> +#define HMC5983_CHANNEL(axis, idx)					\
> +	{								\
> +		.type = IIO_MAGN,					\
> +		.modified = 1,						\
> +		.channel2 = IIO_MOD_##axis,				\
> +		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
> +		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE) |	\
> +			BIT(IIO_CHAN_INFO_SAMP_FREQ),			\
> +		.scan_index = idx,					\
> +		.scan_type = {						\
> +			.sign = 's',					\
> +			.realbits = 16,					\
> +			.storagebits = 16,				\
> +			.endianness = IIO_BE,				\
> +		},							\
> +		.ext_info = hmc5983_ext_info,	\
>  	}
>  
>  static const struct iio_chan_spec hmc5843_channels[] = {
> @@ -475,8 +510,14 @@ static const struct iio_chan_spec hmc5883_channels[] = {
>  	IIO_CHAN_SOFT_TIMESTAMP(3),
>  };
>  
> +static const struct iio_chan_spec hmc5983_channels[] = {
> +	HMC5983_CHANNEL(X, 0),
> +	HMC5983_CHANNEL(Z, 1),
> +	HMC5983_CHANNEL(Y, 2),
> +	IIO_CHAN_SOFT_TIMESTAMP(3),
> +};
> +
>  static struct attribute *hmc5843_attributes[] = {
> -	&iio_dev_attr_meas_conf.dev_attr.attr,
>  	&iio_dev_attr_scale_available.dev_attr.attr,
>  	&iio_dev_attr_sampling_frequency_available.dev_attr.attr,
>  	NULL
> @@ -515,7 +556,7 @@ static const struct hmc5843_chip_info hmc5843_chip_info_tbl[] = {
>  				ARRAY_SIZE(hmc5883l_regval_to_nanoscale),
>  	},
>  	[HMC5983_ID] = {
> -		.channels = hmc5883_channels,
> +		.channels = hmc5983_channels,
>  		.regval_to_samp_freq = hmc5983_regval_to_samp_freq,
>  		.n_regval_to_samp_freq =
>  				ARRAY_SIZE(hmc5983_regval_to_samp_freq),
> 
