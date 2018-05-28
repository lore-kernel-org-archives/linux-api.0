From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [patch v22 1/4] drivers: jtag: Add JTAG core driver
Date: Mon, 28 May 2018 14:35:27 +0200
Message-ID: <20180528123527.GA17613@kroah.com>
References: <1527503652-21975-1-git-send-email-oleksandrs@mellanox.com>
 <1527503652-21975-2-git-send-email-oleksandrs@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1527503652-21975-2-git-send-email-oleksandrs@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Shamray <oleksandrs@mellanox.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, openbmc@lists.ozlabs.org, joel@jms.id.au, jiri@resnulli.us, tklauser@distanz.ch, linux-serial@vger.kernel.org, vadimp@mellanox.com, system-sw-low-level@mellanox.com, robh+dt@kernel.org, openocd-devel-owner@lists.sourceforge.net, linux-api@vger.kernel.org, davem@davemloft.net, mchehab@kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, May 28, 2018 at 01:34:09PM +0300, Oleksandr Shamray wrote:
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
> 
> Signed-off-by: Oleksandr Shamray <oleksandrs@mellanox.com>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> Acked-by: Philippe Ombredanne <pombredanne@nexb.com>
> ---
> v21->v22

22 versions, way to stick with this...

Anyway, time to review it again.  I feel it's really close, but I don't
want to apply it yet as the api feels odd in places.  If others have
asked you to make these changes to look like this, I'm sorry, then
please push back on me:

> +/*
> + * JTAG core driver supports up to 256 devices
> + * JTAG device name will be in range jtag0-jtag255
> + * Set maximum len of jtag id to 3
> + */
> +
> +#define MAX_JTAG_DEVS	255

Why have a max at all?  You should be able to just dynamically allocate
them.  Anyway, if you do want a max, you need to be able to properly
keep the max number, and right now you have a race when registering (you
check the number, and then much later do you increment it, a pointless
use of an atomic value if I've ever seen one...)

> +#define MAX_JTAG_NAME_LEN (sizeof("jtag") + 3)
> +
> +struct jtag {
> +	struct miscdevice miscdev;

If you are a miscdev, why even have a max number?  Just let the max
number of miscdev devices rule things.

> +	const struct jtag_ops *ops;
> +	int id;
> +	bool opened;

You shouldn't care about this, but ok...

> +	struct mutex open_lock;
> +	unsigned long priv[0];
> +};
> +
> +static DEFINE_IDA(jtag_ida);
> +
> +static atomic_t jtag_refcount = ATOMIC_INIT(0);

Either use it as an atomic properly (test_and_set), or just leave it as
an int, or better yet, don't use it at all.

> +void *jtag_priv(struct jtag *jtag)
> +{
> +	return jtag->priv;
> +}
> +EXPORT_SYMBOL_GPL(jtag_priv);

Api naming issue here.  Traditionally this is a "get/set_drvdata" type
function, as in dev_get_drvdata(), or dev_set_drvdata.  But, you are
right in that the network stack has a netdev_priv() call, where you
probably copied this idea from.

I don't know, I guess it's ok as-is, as it's the way networking does it,
it's your call though.

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
> +			return -EOPNOTSUPP;
> +
> +		err = jtag->ops->freq_get(jtag, &value);
> +		if (err)
> +			break;
> +
> +		if (put_user(value, (__u32 __user *)arg))
> +			err = -EFAULT;
> +		break;
> +
> +	case JTAG_SIOCFREQ:
> +		if (!jtag->ops->freq_set)
> +			return -EOPNOTSUPP;
> +
> +		if (get_user(value, (__u32 __user *)arg))
> +			return -EFAULT;
> +		if (value == 0)
> +			return -EINVAL;
> +
> +		err = jtag->ops->freq_set(jtag, value);
> +		break;
> +
> +	case JTAG_IOCRUNTEST:
> +		if (copy_from_user(&idle, (const void __user *)arg,
> +				   sizeof(struct jtag_run_test_idle)))
> +			return -EFAULT;
> +
> +		if (idle.endstate > JTAG_STATE_PAUSEDR)
> +			return -EINVAL;

No validation that idle contains sane values?  Don't make every jtag
driver have to do this type of validation please.


> +
> +		err = jtag->ops->idle(jtag, &idle);
> +		break;
> +
> +	case JTAG_IOCXFER:
> +		if (copy_from_user(&xfer, (const void __user *)arg,
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

See, you do good error checking here, why not for the previous ioctl?


> +		data_size = DIV_ROUND_UP(xfer.length, BITS_PER_BYTE);
> +		xfer_data = memdup_user(u64_to_user_ptr(xfer.tdio), data_size);
> +

No blank line.

> +		if (IS_ERR(xfer_data))
> +			return -EFAULT;
> +
> +		err = jtag->ops->xfer(jtag, &xfer, xfer_data);
> +		if (err) {
> +			kfree(xfer_data);
> +			return -EFAULT;

Why not return the error given to you?  -EFAULT is only if there is a
memory error in a copy_to/from_user() call.

> +		}
> +
> +		err = copy_to_user(u64_to_user_ptr(xfer.tdio),
> +				   (void *)xfer_data, data_size);
> +		kfree(xfer_data);
> +		if (err)
> +			return -EFAULT;

Like here, that's correct.

> +
> +		if (copy_to_user((void __user *)arg, (void *)&xfer,
> +				 sizeof(struct jtag_xfer)))
> +			return -EFAULT;
> +		break;
> +
> +	case JTAG_GIOCSTATUS:
> +		err = jtag->ops->status_get(jtag, &value);
> +		if (err)
> +			break;
> +
> +		err = put_user(value, (__u32 __user *)arg);
> +		break;
> +	case JTAG_SIOCMODE:
> +		if (!jtag->ops->mode_set)
> +			return -EOPNOTSUPP;
> +
> +		if (get_user(value, (__u32 __user *)arg))
> +			return -EFAULT;
> +		if (value == 0)
> +			return -EINVAL;
> +
> +		err = jtag->ops->mode_set(jtag, value);
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +	return err;
> +}
> +
> +static int jtag_open(struct inode *inode, struct file *file)
> +{
> +	struct jtag *jtag = container_of(file->private_data, struct jtag, miscdev);
> +
> +	if (mutex_lock_interruptible(&jtag->open_lock))
> +		return -ERESTARTSYS;

Why restart?  Just grab the lock, you don't want to have to do
restartable logic in userspace, right?

> +
> +	if (jtag->opened) {
> +		mutex_unlock(&jtag->open_lock);
> +		return -EBUSY;

Why do you care about only 1 userspace open call?  What does that buy
you?  Userspace can always pass around that file descriptor and use it
in multiple places, so you are not really "protecting" yourself from
anything.

And better yet, if you get rid of this, your open/release functions get
very tiny and simple.

> +	}
> +	jtag->opened = true;
> +	mutex_unlock(&jtag->open_lock);
> +
> +	nonseekable_open(inode, file);

No error checking of the return value?  Not good :(

> +	file->private_data = jtag;
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
> +struct jtag *jtag_alloc(struct device *host, size_t priv_size,
> +			const struct jtag_ops *ops)
> +{
> +	struct jtag *jtag;
> +
> +	if (!host)
> +		return NULL;
> +
> +	if (!ops)
> +		return NULL;
> +
> +	if (!ops->idle || !ops->status_get || !ops->xfer)
> +		return NULL;
> +
> +	jtag = kzalloc(sizeof(*jtag) + priv_size, GFP_KERNEL);
> +	if (!jtag)
> +		return NULL;
> +
> +	jtag->ops = ops;
> +	jtag->miscdev.parent = host;
> +
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
> +static int jtag_register(struct jtag *jtag)
> +{
> +	struct device *dev = jtag->miscdev.parent;
> +	char *name;
> +	int err;
> +	int id;
> +
> +	if (!dev)
> +		return -ENODEV;
> +
> +	if (atomic_read(&jtag_refcount) >= MAX_JTAG_DEVS)
> +		return -ENOSPC;

Here, you are reading the value, and then setting it a long ways away.
What happens if two people call this at the same time.  Not good.
Either do it correctly, or better yet, don't do it at all.

> +
> +	id = ida_simple_get(&jtag_ida, 0, 0, GFP_KERNEL);
> +	if (id < 0)
> +		return id;
> +
> +	jtag->id = id;
> +	jtag->opened = false;
> +
> +	name = kzalloc(MAX_JTAG_NAME_LEN, GFP_KERNEL);
> +	if (!name) {
> +		err = -ENOMEM;
> +		goto err_jtag_alloc;
> +	}
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
> +	if (err) {
> +		dev_err(jtag->miscdev.parent, "Unable to register device\n");
> +		goto err_jtag_name;
> +	}
> +	pr_info("%s %d\n", __func__, __LINE__);
> +	atomic_inc(&jtag_refcount);
> +	return 0;
> +
> +err_jtag_name:
> +	kfree(name);
> +err_jtag_alloc:
> +	ida_simple_remove(&jtag_ida, id);
> +	return err;
> +}
> +
> +static void jtag_unregister(struct jtag *jtag)
> +{
> +	misc_deregister(&jtag->miscdev);
> +	kfree(jtag->miscdev.name);
> +	ida_simple_remove(&jtag_ida, jtag->id);
> +	atomic_dec(&jtag_refcount);
> +}
> +
> +static void devm_jtag_unregister(struct device *dev, void *res)
> +{
> +	jtag_unregister(*(struct jtag **)res);
> +}
> +
> +int devm_jtag_register(struct device *dev, struct jtag *jtag)
> +{
> +	struct jtag **ptr;
> +	int ret;
> +
> +	ptr = devres_alloc(devm_jtag_unregister, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr)
> +		return -ENOMEM;
> +
> +	ret = jtag_register(jtag);
> +	if (!ret) {
> +		*ptr = jtag;
> +		devres_add(dev, ptr);
> +	} else {
> +		devres_free(ptr);
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(devm_jtag_register);
> +
> +static void __exit jtag_exit(void)
> +{
> +	ida_destroy(&jtag_ida);
> +}
> +
> +module_exit(jtag_exit);
> +
> +MODULE_AUTHOR("Oleksandr Shamray <oleksandrs@mellanox.com>");
> +MODULE_DESCRIPTION("Generic jtag support");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/jtag.h b/include/linux/jtag.h
> new file mode 100644
> index 0000000..56d784d
> --- /dev/null
> +++ b/include/linux/jtag.h
> @@ -0,0 +1,43 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// include/linux/jtag.h - JTAG class driver
> +//
> +// Copyright (c) 2018 Mellanox Technologies. All rights reserved.
> +// Copyright (c) 2018 Oleksandr Shamray <oleksandrs@mellanox.com>
> +
> +#ifndef __JTAG_H
> +#define __JTAG_H
> +
> +#include <uapi/linux/jtag.h>
> +
> +#define jtag_u64_to_ptr(arg) ((void *)(uintptr_t)arg)

Why do you need such a horrid cast?  What is this for?  And why use
uintptr_t at all?  It's not a "normal" kernel type.

> +
> +#define JTAG_MAX_XFER_DATA_LEN 65535
> +
> +struct jtag;
> +/**
> + * struct jtag_ops - callbacks for JTAG control functions:
> + *
> + * @freq_get: get frequency function. Filled by dev driver
> + * @freq_set: set frequency function. Filled by dev driver
> + * @status_get: set status function. Mandatory func. Filled by dev driver
> + * @idle: set JTAG to idle state function. Mandatory func. Filled by dev driver
> + * @xfer: send JTAG xfer function. Mandatory func. Filled by dev driver
> + * @mode_set: set specific work mode for JTAG. Filled by dev driver
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
> +int devm_jtag_register(struct device *dev, struct jtag *jtag);
> +void devm_jtag_unregister(struct device *dev, void *res);
> +struct jtag *jtag_alloc(struct device *host, size_t priv_size,
> +			const struct jtag_ops *ops);
> +void jtag_free(struct jtag *jtag);
> +
> +#endif /* __JTAG_H */
> diff --git a/include/uapi/linux/jtag.h b/include/uapi/linux/jtag.h
> new file mode 100644
> index 0000000..8bbf1a7
> --- /dev/null
> +++ b/include/uapi/linux/jtag.h
> @@ -0,0 +1,102 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// include/uapi/linux/jtag.h - JTAG class driver uapi
> +//
> +// Copyright (c) 2018 Mellanox Technologies. All rights reserved.
> +// Copyright (c) 2018 Oleksandr Shamray <oleksandrs@mellanox.com>
> +
> +#ifndef __UAPI_LINUX_JTAG_H
> +#define __UAPI_LINUX_JTAG_H
> +
> +/*
> + * JTAG_XFER_HW_MODE: JTAG hardware mode. Used to set HW drived or bitbang
> + * mode. This is bitmask param of ioctl JTAG_SIOCMODE command
> + */
> +#define  JTAG_XFER_HW_MODE 1
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
> + * @reset: 0 - run IDLE/PAUSE from current state
> + *         1 - go through TEST_LOGIC/RESET state before  IDLE/PAUSE
> + * @end: completion flag
> + * @tck: clock counter
> + *
> + * Structure provide interface to JTAG device for  JTAG IDLE execution.
> + */
> +struct jtag_run_test_idle {
> +	__u8	reset;
> +	__u8	endstate;
> +	__u8	tck;
> +};
> +
> +/**
> + * struct jtag_xfer - jtag xfer:
> + *
> + * @type: transfer type
> + * @direction: xfer direction
> + * @length: xfer bits len
> + * @tdio : xfer data array
> + * @endir: xfer end state
> + *
> + * Structure provide interface to JTAG device for JTAG SDR/SIR xfer execution.
> + */
> +struct jtag_xfer {
> +	__u8	type;
> +	__u8	direction;
> +	__u8	endstate;
> +	__u8	padding;
> +	__u32	length;
> +	__u64	tdio;
> +};
> +
> +/* ioctl interface */
> +#define __JTAG_IOCTL_MAGIC	0xb2
> +
> +#define JTAG_IOCRUNTEST	_IOW(__JTAG_IOCTL_MAGIC, 0,\
> +			     struct jtag_run_test_idle)

No need for 2 lines here, fits just fine on one.

> +#define JTAG_SIOCFREQ	_IOW(__JTAG_IOCTL_MAGIC, 1, unsigned int)
> +#define JTAG_GIOCFREQ	_IOR(__JTAG_IOCTL_MAGIC, 2, unsigned int)
> +#define JTAG_IOCXFER	_IOWR(__JTAG_IOCTL_MAGIC, 3, struct jtag_xfer)
> +#define JTAG_GIOCSTATUS _IOWR(__JTAG_IOCTL_MAGIC, 4, enum jtag_endstate)
> +#define JTAG_SIOCMODE	_IOW(__JTAG_IOCTL_MAGIC, 5, unsigned int)
> +
> +#define JTAG_FIRST_MINOR 0

Why is this in a uapi file?

> +#define JTAG_MAX_DEVICES 32

This is never used, why is it in a uapi file?

So, almost there, with the above mentioned things, I think you can make
the code even simpler, which is always better, right?

thanks,

greg k-h
