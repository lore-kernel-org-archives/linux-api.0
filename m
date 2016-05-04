From: Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 04/13] iio: health/afe440x: Always use separate gain
 values
Date: Wed, 4 May 2016 11:02:29 +0100
Message-ID: <c875266c-f675-bba3-4e05-bf34ea02df2c@kernel.org>
References: <1462135023-14445-1-git-send-email-afd@ti.com>
 <1462135023-14445-5-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462135023-14445-5-git-send-email-afd@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Andrew F. Davis" <afd@ti.com>, Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-iio@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 01/05/16 21:36, Andrew F. Davis wrote:
> Locking the two gain stages to the same setting adds no value for us,
> so initialize them as unlocked and remove the sysfs for unlocking them.
> This also allows us to greatly simplify showing and setting the gain
> registers.
> 
> Signed-off-by: Andrew F. Davis <afd@ti.com>
Hmm. ABI change but as you said it's an improvement.

Honestly I doubt anyone is using this device without also using userspace that
you are providing so lets apply this an cross our fingers that no one minds.

Applied.
> ---
>  .../ABI/testing/sysfs-bus-iio-health-afe440x       |  9 ----
>  drivers/iio/health/afe4403.c                       | 60 ++++++----------------
>  drivers/iio/health/afe4404.c                       | 60 ++++++----------------
>  drivers/iio/health/afe440x.h                       | 15 ++----
>  4 files changed, 37 insertions(+), 107 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-health-afe440x b/Documentation/ABI/testing/sysfs-bus-iio-health-afe440x
> index 3740f25..b19053a 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio-health-afe440x
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-health-afe440x
> @@ -8,15 +8,6 @@ Description:
>  		Transimpedance Amplifier. Y is 1 for Rf1 and Cf1, Y is 2 for
>  		Rf2 and Cf2 values.
>  
> -What:		/sys/bus/iio/devices/iio:deviceX/tia_separate_en
> -Date:		December 2015
> -KernelVersion:
> -Contact:	Andrew F. Davis <afd@ti.com>
> -Description:
> -		Enable or disable separate settings for the TransImpedance
> -		Amplifier above, when disabled both values are set by the
> -		first channel.
> -
>  What:		/sys/bus/iio/devices/iio:deviceX/in_intensity_ledY_raw
>  		/sys/bus/iio/devices/iio:deviceX/in_intensity_ledY_ambient_raw
>  Date:		December 2015
> diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
> index 5484785..bcff528 100644
> --- a/drivers/iio/health/afe4403.c
> +++ b/drivers/iio/health/afe4403.c
> @@ -180,9 +180,9 @@ static ssize_t afe440x_show_register(struct device *dev,
>  	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
>  	struct afe4403_data *afe = iio_priv(indio_dev);
>  	struct afe440x_attr *afe440x_attr = to_afe440x_attr(attr);
> -	unsigned int reg_val, type;
> +	unsigned int reg_val;
>  	int vals[2];
> -	int ret, val_len;
> +	int ret;
>  
>  	ret = regmap_read(afe->regmap, afe440x_attr->reg, &reg_val);
>  	if (ret)
> @@ -191,27 +191,13 @@ static ssize_t afe440x_show_register(struct device *dev,
>  	reg_val &= afe440x_attr->mask;
>  	reg_val >>= afe440x_attr->shift;
>  
> -	switch (afe440x_attr->type) {
> -	case SIMPLE:
> -		type = IIO_VAL_INT;
> -		val_len = 1;
> -		vals[0] = reg_val;
> -		break;
> -	case RESISTANCE:
> -	case CAPACITANCE:
> -		type = IIO_VAL_INT_PLUS_MICRO;
> -		val_len = 2;
> -		if (reg_val < afe440x_attr->table_size) {
> -			vals[0] = afe440x_attr->val_table[reg_val].integer;
> -			vals[1] = afe440x_attr->val_table[reg_val].fract;
> -			break;
> -		}
> +	if (reg_val >= afe440x_attr->table_size)
>  		return -EINVAL;
> -	default:
> -		return -EINVAL;
> -	}
>  
> -	return iio_format_value(buf, type, val_len, vals);
> +	vals[0] = afe440x_attr->val_table[reg_val].integer;
> +	vals[1] = afe440x_attr->val_table[reg_val].fract;
> +
> +	return iio_format_value(buf, IIO_VAL_INT_PLUS_MICRO, 2, vals);
>  }
>  
>  static ssize_t afe440x_store_register(struct device *dev,
> @@ -227,22 +213,12 @@ static ssize_t afe440x_store_register(struct device *dev,
>  	if (ret)
>  		return ret;
>  
> -	switch (afe440x_attr->type) {
> -	case SIMPLE:
> -		val = integer;
> -		break;
> -	case RESISTANCE:
> -	case CAPACITANCE:
> -		for (val = 0; val < afe440x_attr->table_size; val++)
> -			if (afe440x_attr->val_table[val].integer == integer &&
> -			    afe440x_attr->val_table[val].fract == fract)
> -				break;
> -		if (val == afe440x_attr->table_size)
> -			return -EINVAL;
> -		break;
> -	default:
> +	for (val = 0; val < afe440x_attr->table_size; val++)
> +		if (afe440x_attr->val_table[val].integer == integer &&
> +		    afe440x_attr->val_table[val].fract == fract)
> +			break;
> +	if (val == afe440x_attr->table_size)
>  		return -EINVAL;
> -	}
>  
>  	ret = regmap_update_bits(afe->regmap, afe440x_attr->reg,
>  				 afe440x_attr->mask,
> @@ -253,16 +229,13 @@ static ssize_t afe440x_store_register(struct device *dev,
>  	return count;
>  }
>  
> -static AFE440X_ATTR(tia_separate_en, AFE4403_TIAGAIN, AFE440X_TIAGAIN_ENSEPGAIN, SIMPLE, NULL, 0);
> -
> -static AFE440X_ATTR(tia_resistance1, AFE4403_TIAGAIN, AFE4403_TIAGAIN_RES, RESISTANCE, afe4403_res_table, ARRAY_SIZE(afe4403_res_table));
> -static AFE440X_ATTR(tia_capacitance1, AFE4403_TIAGAIN, AFE4403_TIAGAIN_CAP, CAPACITANCE, afe4403_cap_table, ARRAY_SIZE(afe4403_cap_table));
> +static AFE440X_ATTR(tia_resistance1, AFE4403_TIAGAIN, AFE4403_TIAGAIN_RES, afe4403_res_table);
> +static AFE440X_ATTR(tia_capacitance1, AFE4403_TIAGAIN, AFE4403_TIAGAIN_CAP, afe4403_cap_table);
>  
> -static AFE440X_ATTR(tia_resistance2, AFE4403_TIA_AMB_GAIN, AFE4403_TIAGAIN_RES, RESISTANCE, afe4403_res_table, ARRAY_SIZE(afe4403_res_table));
> -static AFE440X_ATTR(tia_capacitance2, AFE4403_TIA_AMB_GAIN, AFE4403_TIAGAIN_RES, CAPACITANCE, afe4403_cap_table, ARRAY_SIZE(afe4403_cap_table));
> +static AFE440X_ATTR(tia_resistance2, AFE4403_TIA_AMB_GAIN, AFE4403_TIAGAIN_RES, afe4403_res_table);
> +static AFE440X_ATTR(tia_capacitance2, AFE4403_TIA_AMB_GAIN, AFE4403_TIAGAIN_RES, afe4403_cap_table);
>  
>  static struct attribute *afe440x_attributes[] = {
> -	&afe440x_attr_tia_separate_en.dev_attr.attr,
>  	&afe440x_attr_tia_resistance1.dev_attr.attr,
>  	&afe440x_attr_tia_capacitance1.dev_attr.attr,
>  	&afe440x_attr_tia_resistance2.dev_attr.attr,
> @@ -473,6 +446,7 @@ static const struct iio_trigger_ops afe4403_trigger_ops = {
>  static const struct reg_sequence afe4403_reg_sequences[] = {
>  	AFE4403_TIMING_PAIRS,
>  	{ AFE440X_CONTROL1, AFE440X_CONTROL1_TIMEREN },
> +	{ AFE4403_TIAGAIN, AFE440X_TIAGAIN_ENSEPGAIN },
>  };
>  
>  static const struct regmap_range afe4403_yes_ranges[] = {
> diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
> index 2d4c522..b9c1666 100644
> --- a/drivers/iio/health/afe4404.c
> +++ b/drivers/iio/health/afe4404.c
> @@ -193,9 +193,9 @@ static ssize_t afe440x_show_register(struct device *dev,
>  	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
>  	struct afe4404_data *afe = iio_priv(indio_dev);
>  	struct afe440x_attr *afe440x_attr = to_afe440x_attr(attr);
> -	unsigned int reg_val, type;
> +	unsigned int reg_val;
>  	int vals[2];
> -	int ret, val_len;
> +	int ret;
>  
>  	ret = regmap_read(afe->regmap, afe440x_attr->reg, &reg_val);
>  	if (ret)
> @@ -204,27 +204,13 @@ static ssize_t afe440x_show_register(struct device *dev,
>  	reg_val &= afe440x_attr->mask;
>  	reg_val >>= afe440x_attr->shift;
>  
> -	switch (afe440x_attr->type) {
> -	case SIMPLE:
> -		type = IIO_VAL_INT;
> -		val_len = 1;
> -		vals[0] = reg_val;
> -		break;
> -	case RESISTANCE:
> -	case CAPACITANCE:
> -		type = IIO_VAL_INT_PLUS_MICRO;
> -		val_len = 2;
> -		if (reg_val < afe440x_attr->table_size) {
> -			vals[0] = afe440x_attr->val_table[reg_val].integer;
> -			vals[1] = afe440x_attr->val_table[reg_val].fract;
> -			break;
> -		}
> +	if (reg_val >= afe440x_attr->table_size)
>  		return -EINVAL;
> -	default:
> -		return -EINVAL;
> -	}
>  
> -	return iio_format_value(buf, type, val_len, vals);
> +	vals[0] = afe440x_attr->val_table[reg_val].integer;
> +	vals[1] = afe440x_attr->val_table[reg_val].fract;
> +
> +	return iio_format_value(buf, IIO_VAL_INT_PLUS_MICRO, 2, vals);
>  }
>  
>  static ssize_t afe440x_store_register(struct device *dev,
> @@ -240,22 +226,12 @@ static ssize_t afe440x_store_register(struct device *dev,
>  	if (ret)
>  		return ret;
>  
> -	switch (afe440x_attr->type) {
> -	case SIMPLE:
> -		val = integer;
> -		break;
> -	case RESISTANCE:
> -	case CAPACITANCE:
> -		for (val = 0; val < afe440x_attr->table_size; val++)
> -			if (afe440x_attr->val_table[val].integer == integer &&
> -			    afe440x_attr->val_table[val].fract == fract)
> -				break;
> -		if (val == afe440x_attr->table_size)
> -			return -EINVAL;
> -		break;
> -	default:
> +	for (val = 0; val < afe440x_attr->table_size; val++)
> +		if (afe440x_attr->val_table[val].integer == integer &&
> +		    afe440x_attr->val_table[val].fract == fract)
> +			break;
> +	if (val == afe440x_attr->table_size)
>  		return -EINVAL;
> -	}
>  
>  	ret = regmap_update_bits(afe->regmap, afe440x_attr->reg,
>  				 afe440x_attr->mask,
> @@ -266,16 +242,13 @@ static ssize_t afe440x_store_register(struct device *dev,
>  	return count;
>  }
>  
> -static AFE440X_ATTR(tia_separate_en, AFE4404_TIA_GAIN_SEP, AFE440X_TIAGAIN_ENSEPGAIN, SIMPLE, NULL, 0);
> -
> -static AFE440X_ATTR(tia_resistance1, AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_RES, RESISTANCE, afe4404_res_table, ARRAY_SIZE(afe4404_res_table));
> -static AFE440X_ATTR(tia_capacitance1, AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_CAP, CAPACITANCE, afe4404_cap_table, ARRAY_SIZE(afe4404_cap_table));
> +static AFE440X_ATTR(tia_resistance1, AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_RES, afe4404_res_table);
> +static AFE440X_ATTR(tia_capacitance1, AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_CAP, afe4404_cap_table);
>  
> -static AFE440X_ATTR(tia_resistance2, AFE4404_TIA_GAIN_SEP, AFE4404_TIA_GAIN_RES, RESISTANCE, afe4404_res_table, ARRAY_SIZE(afe4404_res_table));
> -static AFE440X_ATTR(tia_capacitance2, AFE4404_TIA_GAIN_SEP, AFE4404_TIA_GAIN_CAP, CAPACITANCE, afe4404_cap_table, ARRAY_SIZE(afe4404_cap_table));
> +static AFE440X_ATTR(tia_resistance2, AFE4404_TIA_GAIN_SEP, AFE4404_TIA_GAIN_RES, afe4404_res_table);
> +static AFE440X_ATTR(tia_capacitance2, AFE4404_TIA_GAIN_SEP, AFE4404_TIA_GAIN_CAP, afe4404_cap_table);
>  
>  static struct attribute *afe440x_attributes[] = {
> -	&afe440x_attr_tia_separate_en.dev_attr.attr,
>  	&afe440x_attr_tia_resistance1.dev_attr.attr,
>  	&afe440x_attr_tia_capacitance1.dev_attr.attr,
>  	&afe440x_attr_tia_resistance2.dev_attr.attr,
> @@ -443,6 +416,7 @@ static const struct iio_trigger_ops afe4404_trigger_ops = {
>  static const struct reg_sequence afe4404_reg_sequences[] = {
>  	AFE4404_TIMING_PAIRS,
>  	{ AFE440X_CONTROL1, AFE440X_CONTROL1_TIMEREN },
> +	{ AFE4404_TIA_GAIN_SEP, AFE440X_TIAGAIN_ENSEPGAIN },
>  	{ AFE440X_CONTROL2, AFE440X_CONTROL3_OSC_ENABLE	},
>  };
>  
> diff --git a/drivers/iio/health/afe440x.h b/drivers/iio/health/afe440x.h
> index c671ab7..544bbab 100644
> --- a/drivers/iio/health/afe440x.h
> +++ b/drivers/iio/health/afe440x.h
> @@ -71,8 +71,7 @@
>  #define AFE440X_CONTROL1_TIMEREN	BIT(8)
>  
>  /* TIAGAIN register fields */
> -#define AFE440X_TIAGAIN_ENSEPGAIN_MASK	BIT(15)
> -#define AFE440X_TIAGAIN_ENSEPGAIN_SHIFT	15
> +#define AFE440X_TIAGAIN_ENSEPGAIN	BIT(15)
>  
>  /* CONTROL2 register fields */
>  #define AFE440X_CONTROL2_PDN_AFE	BIT(0)
> @@ -133,12 +132,6 @@ struct afe440x_reg_info {
>  		.output = true,					\
>  	}
>  
> -enum afe440x_reg_type {
> -	SIMPLE,
> -	RESISTANCE,
> -	CAPACITANCE,
> -};
> -
>  struct afe440x_val_table {
>  	int integer;
>  	int fract;
> @@ -167,7 +160,6 @@ struct afe440x_attr {
>  	unsigned int reg;
>  	unsigned int shift;
>  	unsigned int mask;
> -	enum afe440x_reg_type type;
>  	const struct afe440x_val_table *val_table;
>  	unsigned int table_size;
>  };
> @@ -175,7 +167,7 @@ struct afe440x_attr {
>  #define to_afe440x_attr(_dev_attr)				\
>  	container_of(_dev_attr, struct afe440x_attr, dev_attr)
>  
> -#define AFE440X_ATTR(_name, _reg, _field, _type, _table, _size)	\
> +#define AFE440X_ATTR(_name, _reg, _field, _table)		\
>  	struct afe440x_attr afe440x_attr_##_name = {		\
>  		.dev_attr = __ATTR(_name, (S_IRUGO | S_IWUSR),	\
>  				   afe440x_show_register,	\
> @@ -183,9 +175,8 @@ struct afe440x_attr {
>  		.reg = _reg,					\
>  		.shift = _field ## _SHIFT,			\
>  		.mask = _field ## _MASK,			\
> -		.type = _type,					\
>  		.val_table = _table,				\
> -		.table_size = _size,				\
> +		.table_size = ARRAY_SIZE(_table),		\
>  	}
>  
>  #endif /* _AFE440X_H */
> 
