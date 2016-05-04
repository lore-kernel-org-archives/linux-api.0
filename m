From: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH 09/13] iio: health/afe440x: Use regmap fields
Date: Wed, 4 May 2016 10:30:21 -0500
Message-ID: <572A158D.9040100@ti.com>
References: <1462135023-14445-1-git-send-email-afd@ti.com>
 <1462135023-14445-10-git-send-email-afd@ti.com>
 <45523060-7ae8-076f-dece-34e76e8a740a@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <45523060-7ae8-076f-dece-34e76e8a740a-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 05/04/2016 05:10 AM, Jonathan Cameron wrote:
> On 01/05/16 21:36, Andrew F. Davis wrote:
>> These drivers can use regmap fields to access fields in registers, this
>> allows us to remove some macros/defines and simplify code, do this here.
>>
>> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> This could almost be a poster boy for why regmap field stuff is good ;)
> So often it ends up more marginal than this.
> 

I know, I am really pleased how well it worked out here.

Andrew

> Applied.
> 
> Jonathan
>> ---
>>  drivers/iio/health/afe4403.c | 118 ++++++++++++++++----------------
>>  drivers/iio/health/afe4404.c | 156 ++++++++++++++++++++++---------------------
>>  drivers/iio/health/afe440x.h |  25 +------
>>  3 files changed, 144 insertions(+), 155 deletions(-)
>>
>> diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
>> index 4a58064..1950155 100644
>> --- a/drivers/iio/health/afe4403.c
>> +++ b/drivers/iio/health/afe4403.c
>> @@ -39,32 +39,6 @@
>>  #define AFE4403_TIAGAIN			0x20
>>  #define AFE4403_TIA_AMB_GAIN		0x21
>>  
>> -/* AFE4403 GAIN register fields */
>> -#define AFE4403_TIAGAIN_RES_MASK	GENMASK(2, 0)
>> -#define AFE4403_TIAGAIN_RES_SHIFT	0
>> -#define AFE4403_TIAGAIN_CAP_MASK	GENMASK(7, 3)
>> -#define AFE4403_TIAGAIN_CAP_SHIFT	3
>> -
>> -/* AFE4403 LEDCNTRL register fields */
>> -#define AFE440X_LEDCNTRL_LED1_MASK		GENMASK(15, 8)
>> -#define AFE440X_LEDCNTRL_LED1_SHIFT		8
>> -#define AFE440X_LEDCNTRL_LED2_MASK		GENMASK(7, 0)
>> -#define AFE440X_LEDCNTRL_LED2_SHIFT		0
>> -#define AFE440X_LEDCNTRL_LED_RANGE_MASK		GENMASK(17, 16)
>> -#define AFE440X_LEDCNTRL_LED_RANGE_SHIFT	16
>> -
>> -/* AFE4403 CONTROL2 register fields */
>> -#define AFE440X_CONTROL2_PWR_DWN_TX	BIT(2)
>> -#define AFE440X_CONTROL2_EN_SLOW_DIAG	BIT(8)
>> -#define AFE440X_CONTROL2_DIAG_OUT_TRI	BIT(10)
>> -#define AFE440X_CONTROL2_TX_BRDG_MOD	BIT(11)
>> -#define AFE440X_CONTROL2_TX_REF_MASK	GENMASK(18, 17)
>> -#define AFE440X_CONTROL2_TX_REF_SHIFT	17
>> -
>> -/* AFE4404 NULL fields */
>> -#define NULL_MASK	0
>> -#define NULL_SHIFT	0
>> -
>>  /* AFE4403 LEDCNTRL values */
>>  #define AFE440X_LEDCNTRL_RANGE_TX_HALF	0x1
>>  #define AFE440X_LEDCNTRL_RANGE_TX_FULL	0x2
>> @@ -102,11 +76,35 @@
>>  #define AFE4403_TIAGAIN_RES_1_M		0x6
>>  #define AFE4403_TIAGAIN_RES_NONE	0x7
>>  
>> +enum afe4403_fields {
>> +	/* Gains */
>> +	F_RF_LED1, F_CF_LED1,
>> +	F_RF_LED, F_CF_LED,
>> +
>> +	/* LED Current */
>> +	F_ILED1, F_ILED2,
>> +
>> +	/* sentinel */
>> +	F_MAX_FIELDS
>> +};
>> +
>> +static const struct reg_field afe4403_reg_fields[] = {
>> +	/* Gains */
>> +	[F_RF_LED1]	= REG_FIELD(AFE4403_TIAGAIN, 0, 2),
>> +	[F_CF_LED1]	= REG_FIELD(AFE4403_TIAGAIN, 3, 7),
>> +	[F_RF_LED]	= REG_FIELD(AFE4403_TIA_AMB_GAIN, 0, 2),
>> +	[F_CF_LED]	= REG_FIELD(AFE4403_TIA_AMB_GAIN, 3, 7),
>> +	/* LED Current */
>> +	[F_ILED1]	= REG_FIELD(AFE440X_LEDCNTRL, 0, 7),
>> +	[F_ILED2]	= REG_FIELD(AFE440X_LEDCNTRL, 8, 15),
>> +};
>> +
>>  /**
>>   * struct afe4403_data - AFE4403 device instance data
>>   * @dev: Device structure
>>   * @spi: SPI device handle
>>   * @regmap: Register map of the device
>> + * @fields: Register fields of the device
>>   * @regulator: Pointer to the regulator for the IC
>>   * @trig: IIO trigger for this device
>>   * @irq: ADC_RDY line interrupt number
>> @@ -115,6 +113,7 @@ struct afe4403_data {
>>  	struct device *dev;
>>  	struct spi_device *spi;
>>  	struct regmap *regmap;
>> +	struct regmap_field *fields[F_MAX_FIELDS];
>>  	struct regulator *regulator;
>>  	struct iio_trigger *trig;
>>  	int irq;
>> @@ -131,15 +130,18 @@ enum afe4403_chan_id {
>>  	ILED2,
>>  };
>>  
>> -static const struct afe440x_reg_info afe4403_reg_info[] = {
>> -	[LED2] = AFE440X_REG_INFO(AFE440X_LED2VAL, 0, NULL),
>> -	[ALED2] = AFE440X_REG_INFO(AFE440X_ALED2VAL, 0, NULL),
>> -	[LED1] = AFE440X_REG_INFO(AFE440X_LED1VAL, 0, NULL),
>> -	[ALED1] = AFE440X_REG_INFO(AFE440X_ALED1VAL, 0, NULL),
>> -	[LED2_ALED2] = AFE440X_REG_INFO(AFE440X_LED2_ALED2VAL, 0, NULL),
>> -	[LED1_ALED1] = AFE440X_REG_INFO(AFE440X_LED1_ALED1VAL, 0, NULL),
>> -	[ILED1] = AFE440X_REG_INFO(AFE440X_LEDCNTRL, 0, AFE440X_LEDCNTRL_LED1),
>> -	[ILED2] = AFE440X_REG_INFO(AFE440X_LEDCNTRL, 0, AFE440X_LEDCNTRL_LED2),
>> +static const unsigned int afe4403_channel_values[] = {
>> +	[LED2] = AFE440X_LED2VAL,
>> +	[ALED2] = AFE440X_ALED2VAL,
>> +	[LED1] = AFE440X_LED1VAL,
>> +	[ALED1] = AFE440X_ALED1VAL,
>> +	[LED2_ALED2] = AFE440X_LED2_ALED2VAL,
>> +	[LED1_ALED1] = AFE440X_LED1_ALED1VAL,
>> +};
>> +
>> +static const unsigned int afe4403_channel_leds[] = {
>> +	[ILED1] = F_ILED1,
>> +	[ILED2] = F_ILED2,
>>  };
>>  
>>  static const struct iio_chan_spec afe4403_channels[] = {
>> @@ -184,13 +186,10 @@ static ssize_t afe440x_show_register(struct device *dev,
>>  	int vals[2];
>>  	int ret;
>>  
>> -	ret = regmap_read(afe->regmap, afe440x_attr->reg, &reg_val);
>> +	ret = regmap_field_read(afe->fields[afe440x_attr->field], &reg_val);
>>  	if (ret)
>>  		return ret;
>>  
>> -	reg_val &= afe440x_attr->mask;
>> -	reg_val >>= afe440x_attr->shift;
>> -
>>  	if (reg_val >= afe440x_attr->table_size)
>>  		return -EINVAL;
>>  
>> @@ -220,20 +219,18 @@ static ssize_t afe440x_store_register(struct device *dev,
>>  	if (val == afe440x_attr->table_size)
>>  		return -EINVAL;
>>  
>> -	ret = regmap_update_bits(afe->regmap, afe440x_attr->reg,
>> -				 afe440x_attr->mask,
>> -				 (val << afe440x_attr->shift));
>> +	ret = regmap_field_write(afe->fields[afe440x_attr->field], val);
>>  	if (ret)
>>  		return ret;
>>  
>>  	return count;
>>  }
>>  
>> -static AFE440X_ATTR(tia_resistance1, AFE4403_TIAGAIN, AFE4403_TIAGAIN_RES, afe4403_res_table);
>> -static AFE440X_ATTR(tia_capacitance1, AFE4403_TIAGAIN, AFE4403_TIAGAIN_CAP, afe4403_cap_table);
>> +static AFE440X_ATTR(tia_resistance1, F_RF_LED1, afe4403_res_table);
>> +static AFE440X_ATTR(tia_capacitance1, F_CF_LED1, afe4403_cap_table);
>>  
>> -static AFE440X_ATTR(tia_resistance2, AFE4403_TIA_AMB_GAIN, AFE4403_TIAGAIN_RES, afe4403_res_table);
>> -static AFE440X_ATTR(tia_capacitance2, AFE4403_TIA_AMB_GAIN, AFE4403_TIAGAIN_RES, afe4403_cap_table);
>> +static AFE440X_ATTR(tia_resistance2, F_RF_LED, afe4403_res_table);
>> +static AFE440X_ATTR(tia_capacitance2, F_CF_LED, afe4403_cap_table);
>>  
>>  static struct attribute *afe440x_attributes[] = {
>>  	&afe440x_attr_tia_resistance1.dev_attr.attr,
>> @@ -282,14 +279,15 @@ static int afe4403_read_raw(struct iio_dev *indio_dev,
>>  			    int *val, int *val2, long mask)
>>  {
>>  	struct afe4403_data *afe = iio_priv(indio_dev);
>> -	const struct afe440x_reg_info reg_info = afe4403_reg_info[chan->address];
>> +	unsigned int reg = afe4403_channel_values[chan->address];
>> +	unsigned int field = afe4403_channel_leds[chan->address];
>>  	int ret;
>>  
>>  	switch (chan->type) {
>>  	case IIO_INTENSITY:
>>  		switch (mask) {
>>  		case IIO_CHAN_INFO_RAW:
>> -			ret = afe4403_read(afe, reg_info.reg, val);
>> +			ret = afe4403_read(afe, reg, val);
>>  			if (ret)
>>  				return ret;
>>  			return IIO_VAL_INT;
>> @@ -298,11 +296,9 @@ static int afe4403_read_raw(struct iio_dev *indio_dev,
>>  	case IIO_CURRENT:
>>  		switch (mask) {
>>  		case IIO_CHAN_INFO_RAW:
>> -			ret = regmap_read(afe->regmap, reg_info.reg, val);
>> +			ret = regmap_field_read(afe->fields[field], val);
>>  			if (ret)
>>  				return ret;
>> -			*val &= reg_info.mask;
>> -			*val >>= reg_info.shift;
>>  			return IIO_VAL_INT;
>>  		case IIO_CHAN_INFO_SCALE:
>>  			*val = 0;
>> @@ -322,16 +318,13 @@ static int afe4403_write_raw(struct iio_dev *indio_dev,
>>  			     int val, int val2, long mask)
>>  {
>>  	struct afe4403_data *afe = iio_priv(indio_dev);
>> -	const struct afe440x_reg_info reg_info = afe4403_reg_info[chan->address];
>> +	unsigned int field = afe4403_channel_leds[chan->address];
>>  
>>  	switch (chan->type) {
>>  	case IIO_CURRENT:
>>  		switch (mask) {
>>  		case IIO_CHAN_INFO_RAW:
>> -			return regmap_update_bits(afe->regmap,
>> -				reg_info.reg,
>> -				reg_info.mask,
>> -				(val << reg_info.shift));
>> +			return regmap_field_write(afe->fields[field], val);
>>  		}
>>  		break;
>>  	default:
>> @@ -366,7 +359,7 @@ static irqreturn_t afe4403_trigger_handler(int irq, void *private)
>>  	for_each_set_bit(bit, indio_dev->active_scan_mask,
>>  			 indio_dev->masklength) {
>>  		ret = spi_write_then_read(afe->spi,
>> -					  &afe4403_reg_info[bit].reg, 1,
>> +					  &afe4403_channel_values[bit], 1,
>>  					  rx, 3);
>>  		if (ret)
>>  			goto err;
>> @@ -503,7 +496,7 @@ static int afe4403_probe(struct spi_device *spi)
>>  {
>>  	struct iio_dev *indio_dev;
>>  	struct afe4403_data *afe;
>> -	int ret;
>> +	int i, ret;
>>  
>>  	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(*afe));
>>  	if (!indio_dev)
>> @@ -522,6 +515,15 @@ static int afe4403_probe(struct spi_device *spi)
>>  		return PTR_ERR(afe->regmap);
>>  	}
>>  
>> +	for (i = 0; i < F_MAX_FIELDS; i++) {
>> +		afe->fields[i] = devm_regmap_field_alloc(afe->dev, afe->regmap,
>> +							 afe4403_reg_fields[i]);
>> +		if (IS_ERR(afe->fields[i])) {
>> +			dev_err(afe->dev, "Unable to allocate regmap fields\n");
>> +			return PTR_ERR(afe->fields[i]);
>> +		}
>> +	}
>> +
>>  	afe->regulator = devm_regulator_get(afe->dev, "tx_sup");
>>  	if (IS_ERR(afe->regulator)) {
>>  		dev_err(afe->dev, "Unable to get regulator\n");
>> diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
>> index 7806a45..0d1af4a 100644
>> --- a/drivers/iio/health/afe4404.c
>> +++ b/drivers/iio/health/afe4404.c
>> @@ -48,43 +48,9 @@
>>  #define AFE4404_AVG_LED2_ALED2VAL	0x3f
>>  #define AFE4404_AVG_LED1_ALED1VAL	0x40
>>  
>> -/* AFE4404 GAIN register fields */
>> -#define AFE4404_TIA_GAIN_RES_MASK	GENMASK(2, 0)
>> -#define AFE4404_TIA_GAIN_RES_SHIFT	0
>> -#define AFE4404_TIA_GAIN_CAP_MASK	GENMASK(5, 3)
>> -#define AFE4404_TIA_GAIN_CAP_SHIFT	3
>> -
>> -/* AFE4404 LEDCNTRL register fields */
>> -#define AFE4404_LEDCNTRL_ILED1_MASK	GENMASK(5, 0)
>> -#define AFE4404_LEDCNTRL_ILED1_SHIFT	0
>> -#define AFE4404_LEDCNTRL_ILED2_MASK	GENMASK(11, 6)
>> -#define AFE4404_LEDCNTRL_ILED2_SHIFT	6
>> -#define AFE4404_LEDCNTRL_ILED3_MASK	GENMASK(17, 12)
>> -#define AFE4404_LEDCNTRL_ILED3_SHIFT	12
>> -
>> -/* AFE4404 CONTROL2 register fields */
>> -#define AFE440X_CONTROL2_ILED_2X_MASK	BIT(17)
>> -#define AFE440X_CONTROL2_ILED_2X_SHIFT	17
>> -
>>  /* AFE4404 CONTROL3 register fields */
>>  #define AFE440X_CONTROL3_OSC_ENABLE	BIT(9)
>>  
>> -/* AFE4404 OFFDAC register current fields */
>> -#define AFE4404_OFFDAC_CURR_LED1_MASK	GENMASK(9, 5)
>> -#define AFE4404_OFFDAC_CURR_LED1_SHIFT	5
>> -#define AFE4404_OFFDAC_CURR_LED2_MASK	GENMASK(19, 15)
>> -#define AFE4404_OFFDAC_CURR_LED2_SHIFT	15
>> -#define AFE4404_OFFDAC_CURR_LED3_MASK	GENMASK(4, 0)
>> -#define AFE4404_OFFDAC_CURR_LED3_SHIFT	0
>> -#define AFE4404_OFFDAC_CURR_ALED1_MASK	GENMASK(14, 10)
>> -#define AFE4404_OFFDAC_CURR_ALED1_SHIFT	10
>> -#define AFE4404_OFFDAC_CURR_ALED2_MASK	GENMASK(4, 0)
>> -#define AFE4404_OFFDAC_CURR_ALED2_SHIFT	0
>> -
>> -/* AFE4404 NULL fields */
>> -#define NULL_MASK	0
>> -#define NULL_SHIFT	0
>> -
>>  /* AFE4404 TIA_GAIN_CAP values */
>>  #define AFE4404_TIA_GAIN_CAP_5_P	0x0
>>  #define AFE4404_TIA_GAIN_CAP_2_5_P	0x1
>> @@ -105,10 +71,43 @@
>>  #define AFE4404_TIA_GAIN_RES_1_M	0x6
>>  #define AFE4404_TIA_GAIN_RES_2_M	0x7
>>  
>> +enum afe4404_fields {
>> +	/* Gains */
>> +	F_TIA_GAIN_SEP, F_TIA_CF_SEP,
>> +	F_TIA_GAIN, TIA_CF,
>> +
>> +	/* LED Current */
>> +	F_ILED1, F_ILED2, F_ILED3,
>> +
>> +	/* Offset DAC */
>> +	F_OFFDAC_AMB2, F_OFFDAC_LED1, F_OFFDAC_AMB1, F_OFFDAC_LED2,
>> +
>> +	/* sentinel */
>> +	F_MAX_FIELDS
>> +};
>> +
>> +static const struct reg_field afe4404_reg_fields[] = {
>> +	/* Gains */
>> +	[F_TIA_GAIN_SEP]	= REG_FIELD(AFE4404_TIA_GAIN_SEP, 0, 2),
>> +	[F_TIA_CF_SEP]		= REG_FIELD(AFE4404_TIA_GAIN_SEP, 3, 5),
>> +	[F_TIA_GAIN]		= REG_FIELD(AFE4404_TIA_GAIN, 0, 2),
>> +	[TIA_CF]		= REG_FIELD(AFE4404_TIA_GAIN, 3, 5),
>> +	/* LED Current */
>> +	[F_ILED1]		= REG_FIELD(AFE440X_LEDCNTRL, 0, 5),
>> +	[F_ILED2]		= REG_FIELD(AFE440X_LEDCNTRL, 6, 11),
>> +	[F_ILED3]		= REG_FIELD(AFE440X_LEDCNTRL, 12, 17),
>> +	/* Offset DAC */
>> +	[F_OFFDAC_AMB2]		= REG_FIELD(AFE4404_OFFDAC, 0, 4),
>> +	[F_OFFDAC_LED1]		= REG_FIELD(AFE4404_OFFDAC, 5, 9),
>> +	[F_OFFDAC_AMB1]		= REG_FIELD(AFE4404_OFFDAC, 10, 14),
>> +	[F_OFFDAC_LED2]		= REG_FIELD(AFE4404_OFFDAC, 15, 19),
>> +};
>> +
>>  /**
>>   * struct afe4404_data - AFE4404 device instance data
>>   * @dev: Device structure
>>   * @regmap: Register map of the device
>> + * @fields: Register fields of the device
>>   * @regulator: Pointer to the regulator for the IC
>>   * @trig: IIO trigger for this device
>>   * @irq: ADC_RDY line interrupt number
>> @@ -116,6 +115,7 @@
>>  struct afe4404_data {
>>  	struct device *dev;
>>  	struct regmap *regmap;
>> +	struct regmap_field *fields[F_MAX_FIELDS];
>>  	struct regulator *regulator;
>>  	struct iio_trigger *trig;
>>  	int irq;
>> @@ -133,16 +133,26 @@ enum afe4404_chan_id {
>>  	ILED3,
>>  };
>>  
>> -static const struct afe440x_reg_info afe4404_reg_info[] = {
>> -	[LED2] = AFE440X_REG_INFO(AFE440X_LED2VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_LED2),
>> -	[ALED2] = AFE440X_REG_INFO(AFE440X_ALED2VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_ALED2),
>> -	[LED1] = AFE440X_REG_INFO(AFE440X_LED1VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_LED1),
>> -	[ALED1] = AFE440X_REG_INFO(AFE440X_ALED1VAL, AFE4404_OFFDAC, AFE4404_OFFDAC_CURR_ALED1),
>> -	[LED2_ALED2] = AFE440X_REG_INFO(AFE440X_LED2_ALED2VAL, 0, NULL),
>> -	[LED1_ALED1] = AFE440X_REG_INFO(AFE440X_LED1_ALED1VAL, 0, NULL),
>> -	[ILED1] = AFE440X_REG_INFO(AFE440X_LEDCNTRL, 0, AFE4404_LEDCNTRL_ILED1),
>> -	[ILED2] = AFE440X_REG_INFO(AFE440X_LEDCNTRL, 0, AFE4404_LEDCNTRL_ILED2),
>> -	[ILED3] = AFE440X_REG_INFO(AFE440X_LEDCNTRL, 0, AFE4404_LEDCNTRL_ILED3),
>> +static const unsigned int afe4404_channel_values[] = {
>> +	[LED2] = AFE440X_LED2VAL,
>> +	[ALED2] = AFE440X_ALED2VAL,
>> +	[LED1] = AFE440X_LED1VAL,
>> +	[ALED1] = AFE440X_ALED1VAL,
>> +	[LED2_ALED2] = AFE440X_LED2_ALED2VAL,
>> +	[LED1_ALED1] = AFE440X_LED1_ALED1VAL,
>> +};
>> +
>> +static const unsigned int afe4404_channel_leds[] = {
>> +	[ILED1] = F_ILED1,
>> +	[ILED2] = F_ILED2,
>> +	[ILED3] = F_ILED3,
>> +};
>> +
>> +static const unsigned int afe4404_channel_offdacs[] = {
>> +	[LED2] = F_OFFDAC_LED2,
>> +	[ALED2] = F_OFFDAC_AMB2,
>> +	[LED1] = F_OFFDAC_LED1,
>> +	[ALED1] = F_OFFDAC_AMB1,
>>  };
>>  
>>  static const struct iio_chan_spec afe4404_channels[] = {
>> @@ -194,13 +204,10 @@ static ssize_t afe440x_show_register(struct device *dev,
>>  	int vals[2];
>>  	int ret;
>>  
>> -	ret = regmap_read(afe->regmap, afe440x_attr->reg, &reg_val);
>> +	ret = regmap_field_read(afe->fields[afe440x_attr->field], &reg_val);
>>  	if (ret)
>>  		return ret;
>>  
>> -	reg_val &= afe440x_attr->mask;
>> -	reg_val >>= afe440x_attr->shift;
>> -
>>  	if (reg_val >= afe440x_attr->table_size)
>>  		return -EINVAL;
>>  
>> @@ -230,20 +237,18 @@ static ssize_t afe440x_store_register(struct device *dev,
>>  	if (val == afe440x_attr->table_size)
>>  		return -EINVAL;
>>  
>> -	ret = regmap_update_bits(afe->regmap, afe440x_attr->reg,
>> -				 afe440x_attr->mask,
>> -				 (val << afe440x_attr->shift));
>> +	ret = regmap_field_write(afe->fields[afe440x_attr->field], val);
>>  	if (ret)
>>  		return ret;
>>  
>>  	return count;
>>  }
>>  
>> -static AFE440X_ATTR(tia_resistance1, AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_RES, afe4404_res_table);
>> -static AFE440X_ATTR(tia_capacitance1, AFE4404_TIA_GAIN, AFE4404_TIA_GAIN_CAP, afe4404_cap_table);
>> +static AFE440X_ATTR(tia_resistance1, F_TIA_GAIN, afe4404_res_table);
>> +static AFE440X_ATTR(tia_capacitance1, TIA_CF, afe4404_cap_table);
>>  
>> -static AFE440X_ATTR(tia_resistance2, AFE4404_TIA_GAIN_SEP, AFE4404_TIA_GAIN_RES, afe4404_res_table);
>> -static AFE440X_ATTR(tia_capacitance2, AFE4404_TIA_GAIN_SEP, AFE4404_TIA_GAIN_CAP, afe4404_cap_table);
>> +static AFE440X_ATTR(tia_resistance2, F_TIA_GAIN_SEP, afe4404_res_table);
>> +static AFE440X_ATTR(tia_capacitance2, F_TIA_CF_SEP, afe4404_cap_table);
>>  
>>  static struct attribute *afe440x_attributes[] = {
>>  	&afe440x_attr_tia_resistance1.dev_attr.attr,
>> @@ -264,35 +269,32 @@ static int afe4404_read_raw(struct iio_dev *indio_dev,
>>  			    int *val, int *val2, long mask)
>>  {
>>  	struct afe4404_data *afe = iio_priv(indio_dev);
>> -	const struct afe440x_reg_info reg_info = afe4404_reg_info[chan->address];
>> +	unsigned int value_reg = afe4404_channel_values[chan->address];
>> +	unsigned int led_field = afe4404_channel_leds[chan->address];
>> +	unsigned int offdac_field = afe4404_channel_offdacs[chan->address];
>>  	int ret;
>>  
>>  	switch (chan->type) {
>>  	case IIO_INTENSITY:
>>  		switch (mask) {
>>  		case IIO_CHAN_INFO_RAW:
>> -			ret = regmap_read(afe->regmap, reg_info.reg, val);
>> +			ret = regmap_read(afe->regmap, value_reg, val);
>>  			if (ret)
>>  				return ret;
>>  			return IIO_VAL_INT;
>>  		case IIO_CHAN_INFO_OFFSET:
>> -			ret = regmap_read(afe->regmap, reg_info.offreg,
>> -					  val);
>> +			ret = regmap_field_read(afe->fields[offdac_field], val);
>>  			if (ret)
>>  				return ret;
>> -			*val &= reg_info.mask;
>> -			*val >>= reg_info.shift;
>>  			return IIO_VAL_INT;
>>  		}
>>  		break;
>>  	case IIO_CURRENT:
>>  		switch (mask) {
>>  		case IIO_CHAN_INFO_RAW:
>> -			ret = regmap_read(afe->regmap, reg_info.reg, val);
>> +			ret = regmap_field_read(afe->fields[led_field], val);
>>  			if (ret)
>>  				return ret;
>> -			*val &= reg_info.mask;
>> -			*val >>= reg_info.shift;
>>  			return IIO_VAL_INT;
>>  		case IIO_CHAN_INFO_SCALE:
>>  			*val = 0;
>> @@ -312,25 +314,20 @@ static int afe4404_write_raw(struct iio_dev *indio_dev,
>>  			     int val, int val2, long mask)
>>  {
>>  	struct afe4404_data *afe = iio_priv(indio_dev);
>> -	const struct afe440x_reg_info reg_info = afe4404_reg_info[chan->address];
>> +	unsigned int led_field = afe4404_channel_leds[chan->address];
>> +	unsigned int offdac_field = afe4404_channel_offdacs[chan->address];
>>  
>>  	switch (chan->type) {
>>  	case IIO_INTENSITY:
>>  		switch (mask) {
>>  		case IIO_CHAN_INFO_OFFSET:
>> -			return regmap_update_bits(afe->regmap,
>> -				reg_info.offreg,
>> -				reg_info.mask,
>> -				(val << reg_info.shift));
>> +			return regmap_field_write(afe->fields[offdac_field], val);
>>  		}
>>  		break;
>>  	case IIO_CURRENT:
>>  		switch (mask) {
>>  		case IIO_CHAN_INFO_RAW:
>> -			return regmap_update_bits(afe->regmap,
>> -				reg_info.reg,
>> -				reg_info.mask,
>> -				(val << reg_info.shift));
>> +			return regmap_field_write(afe->fields[led_field], val);
>>  		}
>>  		break;
>>  	default:
>> @@ -357,7 +354,7 @@ static irqreturn_t afe4404_trigger_handler(int irq, void *private)
>>  
>>  	for_each_set_bit(bit, indio_dev->active_scan_mask,
>>  			 indio_dev->masklength) {
>> -		ret = regmap_read(afe->regmap, afe4404_reg_info[bit].reg,
>> +		ret = regmap_read(afe->regmap, afe4404_channel_values[bit],
>>  				  &buffer[i++]);
>>  		if (ret)
>>  			goto err;
>> @@ -490,7 +487,7 @@ static int afe4404_probe(struct i2c_client *client,
>>  {
>>  	struct iio_dev *indio_dev;
>>  	struct afe4404_data *afe;
>> -	int ret;
>> +	int i, ret;
>>  
>>  	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*afe));
>>  	if (!indio_dev)
>> @@ -508,6 +505,15 @@ static int afe4404_probe(struct i2c_client *client,
>>  		return PTR_ERR(afe->regmap);
>>  	}
>>  
>> +	for (i = 0; i < F_MAX_FIELDS; i++) {
>> +		afe->fields[i] = devm_regmap_field_alloc(afe->dev, afe->regmap,
>> +							 afe4404_reg_fields[i]);
>> +		if (IS_ERR(afe->fields[i])) {
>> +			dev_err(afe->dev, "Unable to allocate regmap fields\n");
>> +			return PTR_ERR(afe->fields[i]);
>> +		}
>> +	}
>> +
>>  	afe->regulator = devm_regulator_get(afe->dev, "tx_sup");
>>  	if (IS_ERR(afe->regulator)) {
>>  		dev_err(afe->dev, "Unable to get regulator\n");
>> diff --git a/drivers/iio/health/afe440x.h b/drivers/iio/health/afe440x.h
>> index 713972f..1a0f247 100644
>> --- a/drivers/iio/health/afe440x.h
>> +++ b/drivers/iio/health/afe440x.h
>> @@ -88,21 +88,6 @@
>>  #define AFE440X_CONTROL0_WRITE		0x0
>>  #define AFE440X_CONTROL0_READ		0x1
>>  
>> -struct afe440x_reg_info {
>> -	unsigned int reg;
>> -	unsigned int offreg;
>> -	unsigned int shift;
>> -	unsigned int mask;
>> -};
>> -
>> -#define AFE440X_REG_INFO(_reg, _offreg, _sm)			\
>> -	{							\
>> -		.reg = _reg,					\
>> -		.offreg = _offreg,				\
>> -		.shift = _sm ## _SHIFT,				\
>> -		.mask = _sm ## _MASK,				\
>> -	}
>> -
>>  #define AFE440X_INTENSITY_CHAN(_index, _mask)			\
>>  	{							\
>>  		.type = IIO_INTENSITY,				\
>> @@ -157,9 +142,7 @@ static DEVICE_ATTR_RO(_name)
>>  
>>  struct afe440x_attr {
>>  	struct device_attribute dev_attr;
>> -	unsigned int reg;
>> -	unsigned int shift;
>> -	unsigned int mask;
>> +	unsigned int field;
>>  	const struct afe440x_val_table *val_table;
>>  	unsigned int table_size;
>>  };
>> @@ -167,14 +150,12 @@ struct afe440x_attr {
>>  #define to_afe440x_attr(_dev_attr)				\
>>  	container_of(_dev_attr, struct afe440x_attr, dev_attr)
>>  
>> -#define AFE440X_ATTR(_name, _reg, _field, _table)		\
>> +#define AFE440X_ATTR(_name, _field, _table)			\
>>  	struct afe440x_attr afe440x_attr_##_name = {		\
>>  		.dev_attr = __ATTR(_name, (S_IRUGO | S_IWUSR),	\
>>  				   afe440x_show_register,	\
>>  				   afe440x_store_register),	\
>> -		.reg = _reg,					\
>> -		.shift = _field ## _SHIFT,			\
>> -		.mask = _field ## _MASK,			\
>> +		.field = _field,				\
>>  		.val_table = _table,				\
>>  		.table_size = ARRAY_SIZE(_table),		\
>>  	}
>>
> 
