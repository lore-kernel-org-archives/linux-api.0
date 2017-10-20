From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [patch v9 1/4] drivers: jtag: Add JTAG core driver
Date: Fri, 20 Oct 2017 13:55:12 +0200
Message-ID: <20171020115512.GA2073@kroah.com>
References: <1505985932-27568-1-git-send-email-oleksandrs@mellanox.com>
 <1505985932-27568-2-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1505985932-27568-2-git-send-email-oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: arnd-r2nGTMty4D4@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org, tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mec-WqBc5aa1uDFeoWH0uzbU5w@public.gmane.org, vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 21, 2017 at 12:25:29PM +0300, Oleksandr Shamray wrote:
> +struct jtag {
> +	struct device *dev;
> +	struct cdev cdev;

Why are you using a cdev here and not just a normal misc device?  I
forgot if this is what you were doing before, sorry...

> +	int id;
> +	atomic_t open;

Why do you need this?

> +	const struct jtag_ops *ops;
> +	unsigned long priv[0] __aligned(ARCH_DMA_MINALIGN);

Huh?  Why is this needed to be dma aligned?  Why not just use the
private pointer in struct device?

> +};
> +
> +static dev_t jtag_devt;
> +static DEFINE_IDA(jtag_ida);
> +
> +void *jtag_priv(struct jtag *jtag)
> +{
> +	return jtag->priv;
> +}
> +EXPORT_SYMBOL_GPL(jtag_priv);
> +
> +static u8 *jtag_copy_from_user(__u64 udata, unsigned long bit_size)
> +{
> +	unsigned long size;
> +	void *kdata;
> +
> +	size = DIV_ROUND_UP(bit_size, BITS_PER_BYTE);
> +	kdata = memdup_user(u64_to_user_ptr(udata), size);

You only use this once, why not just open-code it?

> +
> +	return kdata;
> +}
> +
> +static unsigned long jtag_copy_to_user(__u64 udata, u8 *kdata,
> +				       unsigned long bit_size)
> +{
> +	unsigned long size;
> +
> +	size = DIV_ROUND_UP(bit_size, BITS_PER_BYTE);
> +
> +	return copy_to_user(u64_to_user_ptr(udata), (void *)(kdata), size);

Same here, making this a separate function seems odd.

> +}
> +
> +static struct class jtag_class = {
> +	.name = "jtag",
> +	.owner = THIS_MODULE,
> +};
> +
> +static int jtag_run_test_idle_op(struct jtag *jtag,
> +				 struct jtag_run_test_idle *idle)
> +{
> +	if (jtag->ops->idle)
> +		return jtag->ops->idle(jtag, idle);
> +	else
> +		return -EOPNOTSUPP;

Why is this a function?  Why not just do this work in the ioctl?

> +}
> +
> +static int jtag_xfer_op(struct jtag *jtag, struct jtag_xfer *xfer, u8 *data)
> +{
> +	if (jtag->ops->xfer)
> +		return jtag->ops->xfer(jtag, xfer, data);
> +	else
> +		return -EOPNOTSUPP;

Same here, doesn't need to be a function.

> +}
> +
> +static long jtag_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	struct jtag *jtag = file->private_data;
> +	struct jtag_run_test_idle idle;
> +	struct jtag_xfer xfer;
> +	u8 *xfer_data;
> +	u32 value;
> +	int err;
> +
> +	switch (cmd) {
> +	case JTAG_GIOCFREQ:
> +		if (jtag->ops->freq_get)
> +			err = jtag->ops->freq_get(jtag, &value);
> +		else
> +			err = -EOPNOTSUPP;
> +		if (err)
> +			break;
> +
> +		err = put_user(value, (__u32 *)arg);
> +		break;

Are you sure the return value of put_user is correct here?  Shouldn't
you return -EFAULT if err is not 0?

> +
> +	case JTAG_SIOCFREQ:
> +		err = get_user(value, (__u32 *)arg);
> +

why a blank line?

> +		if (value == 0)
> +			err = -EINVAL;

Check err first.

> +		if (err)
> +			break;

And set it properly, again err should be -EFAULT, right?

> +
> +		if (jtag->ops->freq_set)
> +			err = jtag->ops->freq_set(jtag, value);
> +		else
> +			err = -EOPNOTSUPP;
> +		break;
> +
> +	case JTAG_IOCRUNTEST:
> +		if (copy_from_user(&idle, (void *)arg,
> +				   sizeof(struct jtag_run_test_idle)))
> +			return -ENOMEM;
> +		err = jtag_run_test_idle_op(jtag, &idle);

Who validates the structure fields?  Is that up to the individual jtag
driver?  Why not do it in the core correctly so that it only has to be
done in one place and you do not have to audit every individual driver?

> +		break;
> +
> +	case JTAG_IOCXFER:
> +		if (copy_from_user(&xfer, (void *)arg,
> +				   sizeof(struct jtag_xfer)))
> +			return -EFAULT;
> +
> +		if (xfer.length >= JTAG_MAX_XFER_DATA_LEN)
> +			return -EFAULT;
> +
> +		xfer_data = jtag_copy_from_user(xfer.tdio, xfer.length);
> +		if (!xfer_data)
> +			return -ENOMEM;

Are you sure that's the correct error value?

> +
> +		err = jtag_xfer_op(jtag, &xfer, xfer_data);
> +		if (jtag_copy_to_user(xfer.tdio, xfer_data, xfer.length)) {
> +			kfree(xfer_data);
> +			return -EFAULT;
> +		}
> +
> +		kfree(xfer_data);
> +		if (copy_to_user((void *)arg, &xfer, sizeof(struct jtag_xfer)))
> +			return -EFAULT;
> +		break;
> +
> +	case JTAG_GIOCSTATUS:
> +		if (jtag->ops->status_get)
> +			err = jtag->ops->status_get(jtag, &value);
> +		else
> +			err = -EOPNOTSUPP;
> +		if (err)
> +			break;
> +
> +		err = put_user(value, (__u32 *)arg);

Same put_user err issue here.

> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +	return err;
> +}
> +
> +#ifdef CONFIG_COMPAT
> +static long jtag_ioctl_compat(struct file *file, unsigned int cmd,
> +			      unsigned long arg)
> +{
> +	return jtag_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
> +}
> +#endif

Why do you need a compat callback for a new ioctl?  Create your
structures properly and this should not be needed, right?

> +
> +static int jtag_open(struct inode *inode, struct file *file)
> +{
> +	struct jtag *jtag = container_of(inode->i_cdev, struct jtag, cdev);
> +
> +	if (atomic_read(&jtag->open)) {
> +		dev_info(NULL, "jtag already opened\n");
> +		return -EBUSY;

Why do you care if multiple opens can happen?

> +	}
> +
> +	atomic_inc(&jtag->open);

Oh look, you just raced with two different people opening at the same
time :(

An atomic value is never a replacement for a lock, sorry.

> +	file->private_data = jtag;
> +	return 0;
> +}
> +
> +static int jtag_release(struct inode *inode, struct file *file)
> +{
> +	struct jtag *jtag = file->private_data;
> +
> +	atomic_dec(&jtag->open);

Again, not needed.

> +	return 0;
> +}
> +
> +static const struct file_operations jtag_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= jtag_open,
> +	.release	= jtag_release,
> +	.llseek		= noop_llseek,
> +	.unlocked_ioctl = jtag_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl	= jtag_ioctl_compat,
> +#endif
> +};
> +
> +struct jtag *jtag_alloc(size_t priv_size, const struct jtag_ops *ops)
> +{
> +	struct jtag *jtag;
> +
> +	jtag = kzalloc(sizeof(*jtag) + round_up(priv_size, ARCH_DMA_MINALIGN),
> +		       GFP_KERNEL);
> +	if (!jtag)
> +		return NULL;
> +
> +	jtag->ops = ops;
> +	return jtag;
> +}
> +EXPORT_SYMBOL_GPL(jtag_alloc);

register should allocate and register the device, why pass a structure
back that the caller then has to do something else with to use it?

> +
> +void jtag_free(struct jtag *jtag)
> +{
> +	kfree(jtag);
> +}
> +EXPORT_SYMBOL_GPL(jtag_free);
> +
> +int jtag_register(struct jtag *jtag)
> +{
> +	int id;
> +	int err;
> +
> +	id = ida_simple_get(&jtag_ida, 0, 0, GFP_KERNEL);
> +	if (id < 0)
> +		return id;
> +
> +	jtag->id = id;
> +	cdev_init(&jtag->cdev, &jtag_fops);
> +	jtag->cdev.owner = THIS_MODULE;
> +	err = cdev_add(&jtag->cdev, MKDEV(MAJOR(jtag_devt), jtag->id), 1);
> +	if (err)
> +		goto err_cdev;

misc device would be so much simpler and easier here :(


> +
> +	/* Register this jtag device with the driver core */
> +	jtag->dev = device_create(&jtag_class, NULL, MKDEV(MAJOR(jtag_devt),
> +							   jtag->id),
> +				  NULL, "jtag%d", jtag->id);
> +	if (!jtag->dev)
> +		goto err_device_create;
> +
> +	atomic_set(&jtag->open, 0);
> +	dev_set_drvdata(jtag->dev, jtag);
> +	return err;
> +
> +err_device_create:
> +	cdev_del(&jtag->cdev);
> +err_cdev:
> +	ida_simple_remove(&jtag_ida, id);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(jtag_register);
> +
> +void jtag_unregister(struct jtag *jtag)
> +{
> +	struct device *dev = jtag->dev;
> +
> +	cdev_del(&jtag->cdev);
> +	device_unregister(dev);
> +	ida_simple_remove(&jtag_ida, jtag->id);
> +}
> +EXPORT_SYMBOL_GPL(jtag_unregister);
> +
> +static int __init jtag_init(void)
> +{
> +	int err;
> +
> +	err = alloc_chrdev_region(&jtag_devt, JTAG_FIRST_MINOR,
> +				  JTAG_MAX_DEVICES, "jtag");
> +	if (err)
> +		return err;
> +
> +	err = class_register(&jtag_class);
> +	if (err)
> +		unregister_chrdev_region(jtag_devt, JTAG_MAX_DEVICES);
> +
> +	return err;
> +}
> +
> +static void __exit jtag_exit(void)
> +{
> +	class_unregister(&jtag_class);
> +	unregister_chrdev_region(jtag_devt, JTAG_MAX_DEVICES);

Your idr leaked memory :(



> +}
> +
> +module_init(jtag_init);
> +module_exit(jtag_exit);
> +
> +MODULE_AUTHOR("Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>");
> +MODULE_DESCRIPTION("Generic jtag support");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/jtag.h b/include/linux/jtag.h
> new file mode 100644
> index 0000000..c016fed
> --- /dev/null
> +++ b/include/linux/jtag.h
> @@ -0,0 +1,48 @@
> +/*
> + * drivers/jtag/jtag.c
> + *
> + * Copyright (c) 2017 Mellanox Technologies. All rights reserved.
> + * Copyright (c) 2017 Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> + *
> + * Released under the GPLv2 only.
> + * SPDX-License-Identifier: GPL-2.0
> + */
> +
> +#ifndef __JTAG_H
> +#define __JTAG_H
> +
> +#include <uapi/linux/jtag.h>
> +
> +#ifndef ARCH_DMA_MINALIGN
> +#define ARCH_DMA_MINALIGN 1
> +#endif
> +
> +#define jtag_u64_to_ptr(arg) ((void *)(uintptr_t)arg)
> +
> +#define JTAG_MAX_XFER_DATA_LEN 65535
> +
> +struct jtag;
> +/**
> + * struct jtag_ops - callbacks for jtag control functions:
> + *
> + * @freq_get: get frequency function. Filled by device driver
> + * @freq_set: set frequency function. Filled by device driver
> + * @status_get: set status function. Filled by device driver
> + * @idle: set JTAG to idle state function. Filled by device driver
> + * @xfer: send JTAG xfer function. Filled by device driver
> + */
> +struct jtag_ops {
> +	int (*freq_get)(struct jtag *jtag, u32 *freq);
> +	int (*freq_set)(struct jtag *jtag, u32 freq);
> +	int (*status_get)(struct jtag *jtag, u32 *state);
> +	int (*idle)(struct jtag *jtag, struct jtag_run_test_idle *idle);
> +	int (*xfer)(struct jtag *jtag, struct jtag_xfer *xfer);
> +};
> +
> +void *jtag_priv(struct jtag *jtag);
> +int jtag_register(struct jtag *jtag);
> +void jtag_unregister(struct jtag *jtag);
> +struct jtag *jtag_alloc(size_t priv_size, const struct jtag_ops *ops);
> +void jtag_free(struct jtag *jtag);
> +
> +#endif /* __JTAG_H */
> diff --git a/include/uapi/linux/jtag.h b/include/uapi/linux/jtag.h
> new file mode 100644
> index 0000000..180bf22
> --- /dev/null
> +++ b/include/uapi/linux/jtag.h
> @@ -0,0 +1,115 @@
> +/*
> + * JTAG class driver
> + *
> + * Copyright (c) 2017 Mellanox Technologies. All rights reserved.
> + * Copyright (c) 2017 Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> + *
> + * Released under the GPLv2/BSD.
> + * SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> + */
> +
> +#ifndef __UAPI_LINUX_JTAG_H
> +#define __UAPI_LINUX_JTAG_H
> +
> +/**
> + * enum jtag_xfer_mode:
> + *
> + * @JTAG_XFER_HW_MODE: hardware mode transfer
> + * @JTAG_XFER_SW_MODE: software mode transfer
> + */
> +enum jtag_xfer_mode {
> +	JTAG_XFER_HW_MODE,
> +	JTAG_XFER_SW_MODE,
> +};
> +
> +/**
> + * enum jtag_endstate:
> + *
> + * @JTAG_STATE_IDLE: JTAG state machine IDLE state
> + * @JTAG_STATE_PAUSEIR: JTAG state machine PAUSE_IR state
> + * @JTAG_STATE_PAUSEDR: JTAG state machine PAUSE_DR state
> + */
> +enum jtag_endstate {
> +	JTAG_STATE_IDLE,
> +	JTAG_STATE_PAUSEIR,
> +	JTAG_STATE_PAUSEDR,
> +};
> +
> +/**
> + * enum jtag_xfer_type:
> + *
> + * @JTAG_SIR_XFER: SIR transfer
> + * @JTAG_SDR_XFER: SDR transfer
> + */
> +enum jtag_xfer_type {
> +	JTAG_SIR_XFER,
> +	JTAG_SDR_XFER,
> +};
> +
> +/**
> + * enum jtag_xfer_direction:
> + *
> + * @JTAG_READ_XFER: read transfer
> + * @JTAG_WRITE_XFER: write transfer
> + */
> +enum jtag_xfer_direction {
> +	JTAG_READ_XFER,
> +	JTAG_WRITE_XFER,
> +};
> +
> +/**
> + * struct jtag_run_test_idle - forces JTAG state machine to
> + * RUN_TEST/IDLE state
> + *
> + * @mode: access mode
> + * @reset: 0 - run IDLE/PAUSE from current state
> + *         1 - go through TEST_LOGIC/RESET state before  IDLE/PAUSE
> + * @end: completion flag
> + * @tck: clock counter
> + *
> + * Structure represents interface to JTAG device for jtag idle
> + * execution.
> + */
> +struct jtag_run_test_idle {
> +	__u8	mode;
> +	__u8	reset;
> +	__u8	endstate;
> +	__u8	tck;
> +};
> +
> +/**
> + * struct jtag_xfer - jtag xfer:
> + *
> + * @mode: access mode
> + * @type: transfer type
> + * @direction: xfer direction
> + * @length: xfer bits len
> + * @tdio : xfer data array
> + * @endir: xfer end state
> + *
> + * Structure represents interface to Aspeed JTAG device for jtag sdr xfer
> + * execution.
> + */
> +struct jtag_xfer {
> +	__u8	mode;
> +	__u8	type;
> +	__u8	direction;
> +	__u8	endstate;
> +	__u32	length;
> +	__u64	tdio;

I don't see anything odd here that requires a compat ioctl callback, do
you?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
