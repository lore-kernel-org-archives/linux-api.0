From: Varka Bhadram <varkabhadram@gmail.com>
Subject: Re: [PATCH v4] add support for Freescale's MMA8653FC 10 bit accelerometer
Date: Fri, 20 Mar 2015 17:01:14 +0530
Message-ID: <550C0502.7090507@gmail.com>
References: <1426850431-31550-1-git-send-email-martink@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-input-owner@vger.kernel.org>
In-Reply-To: <1426850431-31550-1-git-send-email-martink@posteo.de>
Sender: linux-input-owner@vger.kernel.org
To: Martin Kepplinger <martink@posteo.de>, mark.rutland@arm.com, robh+dt@kernel.org, Pawel.Moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, dmitry.torokhov@gmail.com, alexander.stein@systec-electronic.com
Cc: hadess@hadess.net, akpm@linux-foundation.org, gregkh@linuxfoundation.org, linux-api@vger.kernel.org, devicetree@vger.kernel.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, Martin Kepplinger <martin.kepplinger@theobroma-systems.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>
List-Id: linux-api@vger.kernel.org

On 03/20/2015 04:50 PM, Martin Kepplinger wrote:
> From: Martin Kepplinger <martin.kepplinger@theobroma-systems.com>
>
> The MMA8653FC is a low-power, three-axis, capacitive micromachined
> accelerometer with 10 bits of resolution with flexible user-programmable
> options.
>
> Embedded interrupt functions enable overall power savings, by relieving the
> host processor from continuously polling data, for example using the poll()
> system call.
>
> The device can be configured to generate wake-up interrupt signals from any
> combination of the configurable embedded functions, enabling the MMA8653FC
> to monitor events while remaining in a low-power mode during periods of
> inactivity.
>
> This driver provides devicetree properties to program the device's behaviour
> and a simple, tested and documented sysfs interface. The data sheet and more
> information is available on Freescale's website.
>
> Signed-off-by: Martin Kepplinger <martin.kepplinger@theobroma-systems.com>
> Signed-off-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>
> ---
>
(...)

> +static int mma8653fc_i2c_probe(struct i2c_client *client,
> +				       const struct i2c_device_id *id)
> +{
> +	struct mma8653fc *mma;
> +	const struct mma8653fc_pdata *pdata;
> +	int err;
> +	u8 byte;
> +
> +	err = i2c_check_functionality(client->adapter,
> +			I2C_FUNC_SMBUS_BYTE_DATA);
> +	if (!err) {
> +		dev_err(&client->dev, "SMBUS Byte Data not Supported\n");
> +		return -EIO;
> +	}
> +
> +	mma = kzalloc(sizeof(*mma), GFP_KERNEL);

Why not devm_* API..?

> +	if (!mma) {
> +		err = -ENOMEM;
> +		goto err_out;
> +	}
> +
> +	pdata = dev_get_platdata(&client->dev);
> +	if (!pdata) {
> +		pdata = mma8653fc_probe_dt(&client->dev);
> +		if (IS_ERR(pdata)) {
> +			err = PTR_ERR(pdata);
> +			pr_err("pdata from DT failed\n");

Use dev_err() instead of pr_err()..

> +			goto err_free_mem;
> +		}
> +	}
> +	mma->pdata = *pdata;
> +	pdata = &mma->pdata;
> +	mma->client = client;
> +	mma->read = &mma8653fc_read;
> +	mma->write = &mma8653fc_write;
> +
> +	mutex_init(&mma->mutex);
> +
> +	i2c_set_clientdata(client, mma);
> +
> +	err = sysfs_create_group(&client->dev.kobj, &mma8653fc_attr_group);
> +	if (err)
> +		goto err_free_mem;
> +
> +	mma->irq = irq_of_parse_and_map(client->dev.of_node, 0);
> +	if (!mma->irq) {
> +		dev_err(&client->dev, "Unable to parse or map IRQ\n");
> +		goto no_irq;
> +	}
> +
> +	err = irq_set_irq_type(mma->irq, IRQ_TYPE_EDGE_FALLING);
> +	if (err) {
> +		dev_err(&client->dev, "set_irq_type failed\n");
> +		goto err_free_mem;
> +	}
> +
> +	err = request_threaded_irq(mma->irq, NULL, mma8653fc_irq, IRQF_ONESHOT,
> +				   dev_name(&mma->client->dev), mma);

devm_* API..?

> +	if (err) {
> +		dev_err(&client->dev, "irq %d busy?\n", mma->irq);
> +		goto err_free_mem;
> +	}
> +
> +	if (mma->write(mma, MMA8653FC_CTRL_REG2, SOFT_RESET))
> +		goto err_free_irq;
> +
> +	__mma8653fc_disable(mma);
> +	mma->standby = true;
> +
> +	/* enable desired interrupts */
> +	mma->orientation = '\0';
> +	mma->bafro = '\0';
> +	byte = 0;
> +	if (pdata->int_src_data_ready) {
> +		byte |= INT_EN_DRDY;
> +		dev_dbg(&client->dev, "DATA READY interrupt source enabled\n");
> +	}
> +	if (pdata->int_src_ff_mt_x || pdata->int_src_ff_mt_y ||
> +	    pdata->int_src_ff_mt_z) {
> +		byte |= INT_EN_FF_MT;
> +		dev_dbg(&client->dev, "FF MT interrupt source enabled\n");
> +	}
> +	if (pdata->int_src_lndprt) {
> +		if (mma->write(mma, MMA8653FC_PL_CFG, PL_EN))
> +			goto err_free_irq;
> +		byte |= INT_EN_LNDPRT;
> +		dev_dbg(&client->dev, "LNDPRT interrupt source enabled\n");
> +	}
> +	if (pdata->int_src_aslp) {
> +		byte |= INT_EN_ASLP;
> +		dev_dbg(&client->dev, "ASLP interrupt source enabled\n");
> +	}
> +	if (mma->write(mma, MMA8653FC_CTRL_REG4, byte))
> +		goto err_free_irq;
> +
> +	/* force everything to line 1 */
> +	if (pdata->int1) {
> +		if (mma->write(mma, MMA8653FC_CTRL_REG5,
> +				 (INT_CFG_ASLP | INT_CFG_LNDPRT |
> +				 INT_CFG_FF_MT | INT_CFG_DRDY)))
> +			goto err_free_irq;
> +		dev_dbg(&client->dev, "using interrupt line 1\n");
> +	}
> +no_irq:
> +	/* range mode */
> +	byte = mma->read(mma, MMA8653FC_XYZ_DATA_CFG);
> +	byte &= ~RANGE_MASK;
> +	switch (pdata->range) {
> +	case DYN_RANGE_2G:
> +		byte |= RANGE2G;
> +		dev_dbg(&client->dev, "use 2g range\n");
> +		break;
> +	case DYN_RANGE_4G:
> +		byte |= RANGE4G;
> +		dev_dbg(&client->dev, "use 4g range\n");
> +		break;
> +	case DYN_RANGE_8G:
> +		byte |= RANGE8G;
> +		dev_dbg(&client->dev, "use 8g range\n");
> +		break;
> +	default:
> +		dev_err(&client->dev, "wrong range mode value\n");
> +		goto err_free_irq;
> +	}
> +	if (mma->write(mma, MMA8653FC_XYZ_DATA_CFG, byte))
> +		goto err_free_irq;
> +
> +	/* data calibration offsets */
> +	if (pdata->x_axis_offset) {
> +		if (mma->write(mma, MMA8653FC_OFF_X, pdata->x_axis_offset))
> +			goto err_free_irq;
> +	}
> +	if (pdata->y_axis_offset) {
> +		if (mma->write(mma, MMA8653FC_OFF_Y, pdata->y_axis_offset))
> +			goto err_free_irq;
> +	}
> +	if (pdata->z_axis_offset) {
> +		if (mma->write(mma, MMA8653FC_OFF_Z, pdata->z_axis_offset))
> +			goto err_free_irq;
> +	}
> +
> +	/* if autosleep, wake on both landscape and motion changes */
> +	if (pdata->auto_wake_sleep) {
> +		byte = 0;
> +		byte |= WAKE_LNDPRT;
> +		byte |= WAKE_FF_MT;
> +		if (mma->write(mma, MMA8653FC_CTRL_REG3, byte))
> +			goto err_free_irq;
> +		if (mma->write(mma, MMA8653FC_CTRL_REG2, SLPE))
> +			goto err_free_irq;
> +		dev_dbg(&client->dev, "auto sleep enabled\n");
> +	}
> +
> +	/* data rates */
> +	byte = 0;
> +	byte = mma->read(mma, MMA8653FC_CTRL_REG1);
> +	if (byte < 0)
> +		goto err_free_irq;
> +	byte &= ~ODR_MASK;
> +	byte |= ODR_DEFAULT;
> +	byte &= ~ASLP_RATE_MASK;
> +	byte |= ASLP_RATE_DEFAULT;
> +	if (mma->write(mma, MMA8653FC_CTRL_REG1, byte))
> +		goto err_free_irq;
> +
> +	/* freefall / motion config */
> +	byte = 0;
> +	if (pdata->motion_mode) {
> +		byte |= FF_MT_CFG_OAE;
> +		dev_dbg(&client->dev, "detect motion instead of freefall\n");
> +	}
> +	byte |= FF_MT_CFG_ELE;
> +	if (pdata->int_src_ff_mt_x)
> +		byte |= FF_MT_CFG_XEFE;
> +	if (pdata->int_src_ff_mt_y)
> +		byte |= FF_MT_CFG_YEFE;
> +	if (pdata->int_src_ff_mt_z)
> +		byte |= FF_MT_CFG_ZEFE;
> +	if (mma->write(mma, MMA8653FC_FF_MT_CFG, byte))
> +		goto err_free_irq;
> +
> +	if (pdata->freefall_motion_thr) {
> +		if (mma->write(mma, MMA8653FC_FF_MT_THS,
> +				 pdata->freefall_motion_thr))
> +			goto err_free_irq;
> +		/* calculate back to mg */
> +		dev_dbg(&client->dev, "threshold set to %dmg\n",
> +			 (63 * pdata->freefall_motion_thr) - 1);
> +	}
> +
> +	byte = mma->read(mma, MMA8653FC_WHO_AM_I);
> +	if (byte != MMA8653FC_DEVICE_ID) {
> +		dev_err(&client->dev, "wrong device for driver\n");
> +		goto err_free_irq;
> +	}
> +	dev_info(&client->dev,
> +		 "accelerometer driver loaded. device id %x\n", byte);
> +
> +	return 0;
> +
> + err_free_irq:
> +	if (mma->irq)
> +		free_irq(mma->irq, mma);
> + err_free_mem:
> +	kfree(mma);

If we use devm_* API's above steps are not required

> + err_out:
> +	return err;
> +}
> +
> +static int mma8653fc_remove(struct i2c_client *client)
> +{
> +	struct mma8653fc *mma = i2c_get_clientdata(client);
> +
> +	free_irq(mma->irq, mma);
> +	dev_dbg(&client->dev, "unregistered accelerometer\n");
> +	kfree(mma);

same as above..



-- 
Varka Bhadram

