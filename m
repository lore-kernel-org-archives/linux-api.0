From: Julia Cartwright <juliac@eso.teric.us>
Subject: Re: [patch v17 1/4] drivers: jtag: Add JTAG core driver
Date: Wed, 17 Jan 2018 13:14:41 -0600
Message-ID: <20180117191441.GE2818@kryptos.localdomain>
References: <1516087139-7510-1-git-send-email-oleksandrs@mellanox.com>
 <1516087139-7510-2-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516087139-7510-2-git-send-email-oleksandrs@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Shamray <oleksandrs@mellanox.com>
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, openbmc@lists.ozlabs.org, joel@jms.id.au, jiri@resnulli.us, tklauser@distanz.ch, linux-serial@vger.kernel.org, vadimp@mellanox.com, system-sw-low-level@mellanox.com, robh+dt@kernel.org, openocd-devel-owner@lists.sourceforge.net, linux-api@vger.kernel.org, davem@davemloft.net, mchehab@kernel.org, Jiri Pirko <jiri@mellanox.com>
List-Id: linux-api@vger.kernel.org

Hello Oleksandr-

On Tue, Jan 16, 2018 at 09:18:56AM +0200, Oleksandr Shamray wrote:
[..]
> v16->v17
> Comments pointed by Julia Cartwright <juliac@eso.teric.us>

More review feedback below:

[..]
> +++ b/drivers/jtag/jtag.c
[..]
> +static long jtag_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	struct jtag *jtag = file->private_data;
> +	struct jtag_run_test_idle idle;
> +	struct jtag_xfer xfer;
> +	u8 *xfer_data;
> +	u32 data_size;
> +	u32 value;
> +	int err;
> +
> +	if (!arg)
> +		return -EINVAL;
> +
> +	switch (cmd) {
> +	case JTAG_GIOCFREQ:
> +		if (!jtag->ops->freq_get)
> +			err = -EOPNOTSUPP;

Did you mean:

			return -EOPNOTSUPP;

?

> +
> +		err = jtag->ops->freq_get(jtag, &value);

Otherwise you're check was worthless, you'll call NULL here.

Also, w.r.t. the set of ops which are required to be implemented: this
isn't the right place to do the check.

Instead, do it in jtag_alloc():

	struct jtag *jtag_alloc(size_t priv_size, const struct jtag_ops *ops)
	{
		struct jtag *jtag;

		if (!ops->freq_get || !ops->xfer || ...) /* fixup condition */
			return NULL;

		jtag = kzalloc(sizeof(*jtag) + priv_size, GFP_KERNEL);
		if (!jtag)
			return NULL;

		jtag->ops = ops;
		return jtag;
	}
	EXPORT_SYMBOL_GPL(jtag_alloc);

[..]
> +	case JTAG_IOCXFER:
[..]
> +		data_size = DIV_ROUND_UP(xfer.length, BITS_PER_BYTE);
> +		xfer_data = memdup_user(u64_to_user_ptr(xfer.tdio), data_size);
> +
> +		if (!xfer_data)

memdup_user() doesn't return NULL on error.  You need to check for
IS_ERR(xfer_data).

> +			return -EFAULT;
> +
> +		err = jtag->ops->xfer(jtag, &xfer, xfer_data);
> +		if (err) {
> +			kfree(xfer_data);
> +			return -EFAULT;
> +		}
> +
> +		err = copy_to_user(u64_to_user_ptr(xfer.tdio),
> +				   (void *)(xfer_data), data_size);
> +
> +		if (err) {
> +			kfree(xfer_data);
> +			return -EFAULT;
> +		}
> +
> +		kfree(xfer_data);

Move the kfree() above the if (err).

> +		if (copy_to_user((void *)arg, &xfer, sizeof(struct jtag_xfer)))
> +			return -EFAULT;
> +		break;
> +
> +	case JTAG_GIOCSTATUS:
> +		if (!jtag->ops->status_get)
> +			return -EOPNOTSUPP;
> +
> +		err = jtag->ops->status_get(jtag, &value);
> +		if (err)
> +			break;
> +
> +		err = put_user(value, (__u32 *)arg);
> +		if (err)
> +			err = -EFAULT;

put_user() returns -EFAULT on failure, so this shouldn't be necessary.

[..]
> --- /dev/null
> +++ b/include/uapi/linux/jtag.h
[..]
> +/**
> + * struct jtag_xfer - jtag xfer:
> + *
> + * @type: transfer type
> + * @direction: xfer direction
> + * @length: xfer bits len
> + * @tdio : xfer data array
> + * @endir: xfer end state
> + *
> + * Structure represents interface to JTAG device for jtag sdr xfer
> + * execution.
> + */
> +struct jtag_xfer {
> +	__u8	type;
> +	__u8	direction;
> +	__u8	endstate;

Just to be as unambiguous as possible, considering this is ABI, I would
suggest explicitly putting a padding byte here.

> +	__u32	length;
> +	__u64	tdio;
> +};

Thanks,
   Julia
