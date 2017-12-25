From: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch v15 1/4] drivers: jtag: Add JTAG core driver
Date: Mon, 25 Dec 2017 15:09:08 -0800
Message-ID: <13433849-cb7d-e2c0-4ce9-d91a6012d7d7@gmail.com>
References: <1514202808-29747-1-git-send-email-oleksandrs@mellanox.com>
 <1514202808-29747-2-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514202808-29747-2-git-send-email-oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, openbmc-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org, jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org, tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vadimp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, system-sw-low-level-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, openocd-devel-owner-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Le 12/25/17 à 03:53, Oleksandr Shamray a écrit :
> Initial patch for JTAG driver
> JTAG class driver provide infrastructure to support hardware/software
> JTAG platform drivers. It provide user layer API interface for flashing
> and debugging external devices which equipped with JTAG interface
> using standard transactions.
> 
> Driver exposes set of IOCTL to user space for:
> - XFER:
> - SIR (Scan Instruction Register, IEEE 1149.1 Data Register scan);
> - SDR (Scan Data Register, IEEE 1149.1 Instruction Register scan);
> - RUNTEST (Forces the IEEE 1149.1 bus to a run state for a specified
>   number of clocks).
> - SIOCFREQ/GIOCFREQ for setting and reading JTAG frequency.
> 
> Driver core provides set of internal APIs for allocation and
> registration:
> - jtag_register;
> - jtag_unregister;
> - jtag_alloc;
> - jtag_free;
> 
> Platform driver on registration with jtag-core creates the next
> entry in dev folder:
> /dev/jtagX

Just some general comment, I am really surprised to see that there is
not a whole lot of generic code, actually, there is none, which tries to
manage the JTAG devices command queue, e.g: ala OpenOCD. All that this
is doing here is create a special character device with a bunch of
custom ioctl(), which means that a lot of code is going to be put within
in individual drivers. Have you given some thoughts on how you would
expand this framework for non ASPEED JTAG adapters? For instance, one
expectation is to see a bit-banged GPIO master, since that's quite
common, what would it look like here? How much code would I have to write?

[snip]

> +
> +void *jtag_priv(struct jtag *jtag)
> +{
> +	return jtag->priv;
> +}
> +EXPORT_SYMBOL_GPL(jtag_priv);

Can't you just create a static inline function in the public header for
that? This is usually what subsystems do, I can understand why you would
not want to expose struct jtag to other parts of the kernel, but still,
this looks ugly, so maybe consider splitting the header between provider
and consumer?

> +
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
> +
> +		if (jtag->ops->freq_get)
> +			err = jtag->ops->freq_get(jtag, &value);
> +		else
> +			err = -EOPNOTSUPP;
> +		if (err)
> +			break;
> +
> +		if (put_user(value, (__u32 *)arg))
> +			err = -EFAULT;
> +		break;
> +
> +	case JTAG_SIOCFREQ:
> +		if (get_user(value, (__u32 *)arg))
> +			return -EFAULT;
> +		if (value == 0)
> +			return -EINVAL;
> +
> +		if (jtag->ops->freq_set)
> +			err = jtag->ops->freq_set(jtag, value);
> +		else
> +			err = -EOPNOTSUPP;

You should check that before get_user()

> +		break;
> +
> +	case JTAG_IOCRUNTEST:
> +		if (copy_from_user(&idle, (void *)arg,
> +				   sizeof(struct jtag_run_test_idle)))
> +			return -EFAULT;
> +
> +		if (idle.endstate > JTAG_STATE_PAUSEDR)
> +			return -EINVAL;
> +
> +		if (jtag->ops->idle)
> +			err = jtag->ops->idle(jtag, &idle);
> +		else
> +			err = -EOPNOTSUPP;
> +		break;

Same here.

> +
> +	case JTAG_IOCXFER:
> +		if (copy_from_user(&xfer, (void *)arg,
> +				   sizeof(struct jtag_xfer)))
> +			return -EFAULT;
> +
> +		if (xfer.length >= JTAG_MAX_XFER_DATA_LEN)
> +			return -EINVAL;
> +
> +		if (xfer.type > JTAG_SDR_XFER)
> +			return -EINVAL;
> +
> +		if (xfer.direction > JTAG_WRITE_XFER)
> +			return -EINVAL;
> +
> +		if (xfer.endstate > JTAG_STATE_PAUSEDR)
> +			return -EINVAL;
> +
> +		data_size = DIV_ROUND_UP(xfer.length, BITS_PER_BYTE);
> +		xfer_data = memdup_user(u64_to_user_ptr(xfer.tdio), data_size);
> +
> +		if (!xfer_data)
> +			return -EFAULT;
> +
> +		if (jtag->ops->xfer) {
> +			err = jtag->ops->xfer(jtag, &xfer, xfer_data);
> +		} else {
> +			kfree(xfer_data);
> +			return -EOPNOTSUPP;
> +		}

Why don't you move all of the code here into a function which will make
the error handling consistent? Also, checking whether the jtag adapter
implements ops->xfer should probably be done before you do the
memdup_user().

> +
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
> +		if (err)
> +			err = -EFAULT;
> +		break;
> +	case JTAG_SIOCMODE:
> +		if (get_user(value, (__u32 *)arg))
> +			return -EFAULT;
> +		if (value == 0)
> +			return -EINVAL;
> +
> +		if (jtag->ops->mode_set)
> +			err = jtag->ops->mode_set(jtag, value);
> +		else
> +			err = -EOPNOTSUPP;
> +		break;

Same here, this can be checked before get_user().

> +
> +	default:
> +		return -EINVAL;
> +	}
> +	return err;
> +}
> +
> +static int jtag_open(struct inode *inode, struct file *file)
> +{
> +	struct jtag *jtag = container_of(file->private_data, struct jtag,
> +					 miscdev);
> +
> +	if (mutex_lock_interruptible(&jtag->open_lock))
> +		return -ERESTARTSYS;
> +
> +	if (jtag->opened) {
> +		mutex_unlock(&jtag->open_lock);
> +		return -EINVAL;

-EBUSY maybe?

> +	}
> +
> +	nonseekable_open(inode, file);
> +	file->private_data = jtag;
> +	jtag->opened = true;
> +	mutex_unlock(&jtag->open_lock);
> +	return 0;
> +}
> +
> +static int jtag_release(struct inode *inode, struct file *file)
> +{
> +	struct jtag *jtag = file->private_data;
> +
> +	mutex_lock(&jtag->open_lock);
> +	jtag->opened = false;
> +	mutex_unlock(&jtag->open_lock);
> +	return 0;
> +}
> +
> +static const struct file_operations jtag_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= jtag_open,
> +	.release	= jtag_release,
> +	.llseek		= noop_llseek,
> +	.unlocked_ioctl = jtag_ioctl,
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

If you set ARCH_DMA_MINALIGN to 1 when not defined, what is this
achieving that kmalloc() is not already doing?

> +
> +	jtag->ops = ops;
> +	return jtag;
> +}
> +EXPORT_SYMBOL_GPL(jtag_alloc);
> +
> +void jtag_free(struct jtag *jtag)
> +{
> +	kfree(jtag);
> +}
> +EXPORT_SYMBOL_GPL(jtag_free);
> +
> +int jtag_register(struct jtag *jtag)
> +{
> +	char *name;
> +	int err;
> +	int id;
> +
> +	id = ida_simple_get(&jtag_ida, 0, 0, GFP_KERNEL);
> +	if (id < 0)
> +		return id;
> +
> +	jtag->id = id;
> +
> +	name = kzalloc(MAX_JTAG_NAME_LEN, GFP_KERNEL);
> +	if (!name) {
> +		err = -ENOMEM;
> +		goto err_jtag_alloc;
> +	}

Can't you use jtag->miscdev.dev here to simplify the allocation error
handling?

> +
> +	err = snprintf(name, MAX_JTAG_NAME_LEN, "jtag%d", id);
> +	if (err < 0)
> +		goto err_jtag_name;
> +
> +	mutex_init(&jtag->open_lock);
> +	jtag->miscdev.fops =  &jtag_fops;
> +	jtag->miscdev.minor = MISC_DYNAMIC_MINOR;
> +	jtag->miscdev.name = name;
> +
> +	err = misc_register(&jtag->miscdev);
> +	if (err)
> +		dev_err(jtag->dev, "Unable to register device\n");
> +	else
> +		return 0;
> +	jtag->opened = false;
> +
> +err_jtag_name:
> +	kfree(name);
> +err_jtag_alloc:
> +	ida_simple_remove(&jtag_ida, id);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(jtag_register);
> +
> +void jtag_unregister(struct jtag *jtag)
> +{
> +	misc_deregister(&jtag->miscdev);
> +	kfree(jtag->miscdev.name);
> +	ida_simple_remove(&jtag_ida, jtag->id);
> +}
> +EXPORT_SYMBOL_GPL(jtag_unregister);
> +
> +static void __exit jtag_exit(void)
> +{
> +	ida_destroy(&jtag_ida);
> +}
> +
> +module_exit(jtag_exit);
> +
> +MODULE_AUTHOR("Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>");
> +MODULE_DESCRIPTION("Generic jtag support");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/jtag.h b/include/linux/jtag.h
> new file mode 100644
> index 0000000..312c641
> --- /dev/null
> +++ b/include/linux/jtag.h
> @@ -0,0 +1,45 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// include/linux/jtag.h - JTAG class driver
> +//
> +// Copyright (c) 2017 Mellanox Technologies. All rights reserved.
> +// Copyright (c) 2017 Oleksandr Shamray <oleksandrs-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> +
> +#ifndef __JTAG_H
> +#define __JTAG_H
> +
> +#include <uapi/linux/jtag.h>
> +
> +#ifndef ARCH_DMA_MINALIGN
> +#define ARCH_DMA_MINALIGN 1
> +#endif

Why?

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
> +	int (*xfer)(struct jtag *jtag, struct jtag_xfer *xfer, u8 *xfer_data);
> +	int (*mode_set)(struct jtag *jtag, u32 mode_mask);
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
> index 0000000..cda2520
> --- /dev/null
> +++ b/include/uapi/linux/jtag.h

[snip]

> +struct jtag_xfer {
> +	__u8	type;
> +	__u8	direction;

Can these two be an enum referring to what you defined earlier?

> +	__u8	endstate;
> +	__u32	length;
> +	__u64	tdio;
> +};
-- 
Florian
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
