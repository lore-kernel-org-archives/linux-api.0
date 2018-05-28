From: Oleksandr Shamray <oleksandrs@mellanox.com>
Subject: RE: [patch v22 1/4] drivers: jtag: Add JTAG core driver
Date: Mon, 28 May 2018 15:59:46 +0000
Message-ID: <AM5PR0501MB24490173AD50A2E478DFCF35B16E0@AM5PR0501MB2449.eurprd05.prod.outlook.com>
References: <1527503652-21975-1-git-send-email-oleksandrs@mellanox.com>
 <1527503652-21975-2-git-send-email-oleksandrs@mellanox.com>
 <20180528123527.GA17613@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180528123527.GA17613@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "arnd@arndb.de" <arnd@arndb.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>, "joel@jms.id.au" <joel@jms.id.au>, "jiri@resnulli.us" <jiri@resnulli.us>, "tklauser@distanz.ch" <tklauser@distanz.ch>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, Vadim Pasternak <vadimp@mellanox.com>, system-sw-low-level <system-sw-low-level@mellanox.com>, "robh+dt@kernel.org" <robh+dt@kernel.org>, "openocd-devel-owner@lists.sourceforge.net" <openocd-devel-owner@lists.sourceforge.net>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, davem@dave
List-Id: linux-api@vger.kernel.org

Hi Greg.

Thanks for your review.
Please see my comments inline.

Best Regards,
Oleksandr Shamray

> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: 28 =CD=C1=D1 2018 =C7. 15:35
> To: Oleksandr Shamray <oleksandrs@mellanox.com>
> Cc: arnd@arndb.de; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; devicetree@vger.kernel.org;
> openbmc@lists.ozlabs.org; joel@jms.id.au; jiri@resnulli.us;
> tklauser@distanz.ch; linux-serial@vger.kernel.org; Vadim Pasternak
> <vadimp@mellanox.com>; system-sw-low-level <system-sw-low-
> level@mellanox.com>; robh+dt@kernel.org; openocd-devel-
> owner@lists.sourceforge.net; linux-api@vger.kernel.org;
> davem@davemloft.net; mchehab@kernel.org
> Subject: Re: [patch v22 1/4] drivers: jtag: Add JTAG core driver
>=20
> On Mon, May 28, 2018 at 01:34:09PM +0300, Oleksandr Shamray wrote:
> > Initial patch for JTAG driver
> > JTAG class driver provide infrastructure to support hardware/software
> > JTAG platform drivers. It provide user layer API interface for
> > flashing and debugging external devices which equipped with JTAG
> > interface using standard transactions.
> >
> > Driver exposes set of IOCTL to user space for:
> > - XFER:
> > - SIR (Scan Instruction Register, IEEE 1149.1 Data Register scan);
> > - SDR (Scan Data Register, IEEE 1149.1 Instruction Register scan);
> > - RUNTEST (Forces the IEEE 1149.1 bus to a run state for a specified
> >   number of clocks).
> > - SIOCFREQ/GIOCFREQ for setting and reading JTAG frequency.
> >
> > Driver core provides set of internal APIs for allocation and
> > registration:
> > - jtag_register;
> > - jtag_unregister;
> > - jtag_alloc;
> > - jtag_free;
> >
> > Platform driver on registration with jtag-core creates the next entry
> > in dev folder:
> > /dev/jtagX
> >
> > Signed-off-by: Oleksandr Shamray <oleksandrs@mellanox.com>
> > Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> > Acked-by: Philippe Ombredanne <pombredanne@nexb.com>
> > ---
> > v21->v22
>=20
> 22 versions, way to stick with this...
>=20
> Anyway, time to review it again.  I feel it's really close, but I don't w=
ant to
> apply it yet as the api feels odd in places.  If others have asked you to=
 make
> these changes to look like this, I'm sorry, then please push back on me:
>=20
> > +/*
> > + * JTAG core driver supports up to 256 devices
> > + * JTAG device name will be in range jtag0-jtag255
> > + * Set maximum len of jtag id to 3
> > + */
> > +
> > +#define MAX_JTAG_DEVS	255
>=20
> Why have a max at all?  You should be able to just dynamically allocate t=
hem.
> Anyway, if you do want a max, you need to be able to properly keep the ma=
x
> number, and right now you have a race when registering (you check the
> number, and then much later do you increment it, a pointless use of an
> atomic value if I've ever seen one...)
>=20

You are right. It's not good idea to have restriction of max dev number.
I will remove all regarding It.

> > +#define MAX_JTAG_NAME_LEN (sizeof("jtag") + 3)
> > +
> > +struct jtag {
> > +	struct miscdevice miscdev;
>=20
> If you are a miscdev, why even have a max number?  Just let the max
> number of miscdev devices rule things.
>=20
> > +	const struct jtag_ops *ops;
> > +	int id;
> > +	bool opened;
>=20
> You shouldn't care about this, but ok...

Jtag HW not support to using with multiple requests from different users. S=
o we prohibit this.

>=20
> > +	struct mutex open_lock;
> > +	unsigned long priv[0];
> > +};
> > +
> > +static DEFINE_IDA(jtag_ida);
> > +
> > +static atomic_t jtag_refcount =3D ATOMIC_INIT(0);
>=20
> Either use it as an atomic properly (test_and_set), or just leave it as a=
n int, or
> better yet, don't use it at all.

It will be removed.

>=20
> > +void *jtag_priv(struct jtag *jtag)
> > +{
> > +	return jtag->priv;
> > +}
> > +EXPORT_SYMBOL_GPL(jtag_priv);
>=20
> Api naming issue here.  Traditionally this is a "get/set_drvdata" type fu=
nction,
> as in dev_get_drvdata(), or dev_set_drvdata.  But, you are right in that =
the
> network stack has a netdev_priv() call, where you probably copied this id=
ea
> from.
>=20
> I don't know, I guess it's ok as-is, as it's the way networking does it, =
it's your
> call though.
>=20

Yes,  I did as in networking.=20

> > +static long jtag_ioctl(struct file *file, unsigned int cmd, unsigned
> > +long arg) {
> > +	struct jtag *jtag =3D file->private_data;
> > +	struct jtag_run_test_idle idle;
> > +	struct jtag_xfer xfer;
> > +	u8 *xfer_data;
> > +	u32 data_size;
> > +	u32 value;
> > +	int err;
> > +
> > +	if (!arg)
> > +		return -EINVAL;
> > +
> > +	switch (cmd) {
> > +	case JTAG_GIOCFREQ:
> > +		if (!jtag->ops->freq_get)
> > +			return -EOPNOTSUPP;
> > +
> > +		err =3D jtag->ops->freq_get(jtag, &value);
> > +		if (err)
> > +			break;
> > +
> > +		if (put_user(value, (__u32 __user *)arg))
> > +			err =3D -EFAULT;
> > +		break;
> > +
> > +	case JTAG_SIOCFREQ:
> > +		if (!jtag->ops->freq_set)
> > +			return -EOPNOTSUPP;
> > +
> > +		if (get_user(value, (__u32 __user *)arg))
> > +			return -EFAULT;
> > +		if (value =3D=3D 0)
> > +			return -EINVAL;
> > +
> > +		err =3D jtag->ops->freq_set(jtag, value);
> > +		break;
> > +
> > +	case JTAG_IOCRUNTEST:
> > +		if (copy_from_user(&idle, (const void __user *)arg,
> > +				   sizeof(struct jtag_run_test_idle)))
> > +			return -EFAULT;
> > +
> > +		if (idle.endstate > JTAG_STATE_PAUSEDR)
> > +			return -EINVAL;
>=20
> No validation that idle contains sane values?  Don't make every jtag driv=
er
> have to do this type of validation please.
>=20

I have partially validation of idle structure  (if (idle.endstate > JTAG_ST=
ATE_PAUSEDR)).
But I will add more validation.

>=20
> > +
> > +		err =3D jtag->ops->idle(jtag, &idle);
> > +		break;
> > +
> > +	case JTAG_IOCXFER:
> > +		if (copy_from_user(&xfer, (const void __user *)arg,
> > +				   sizeof(struct jtag_xfer)))
> > +			return -EFAULT;
> > +
> > +		if (xfer.length >=3D JTAG_MAX_XFER_DATA_LEN)
> > +			return -EINVAL;
> > +
> > +		if (xfer.type > JTAG_SDR_XFER)
> > +			return -EINVAL;
> > +
> > +		if (xfer.direction > JTAG_WRITE_XFER)
> > +			return -EINVAL;
> > +
> > +		if (xfer.endstate > JTAG_STATE_PAUSEDR)
> > +			return -EINVAL;
> > +
>=20
> See, you do good error checking here, why not for the previous ioctl?
>=20
>=20
> > +		data_size =3D DIV_ROUND_UP(xfer.length, BITS_PER_BYTE);
> > +		xfer_data =3D memdup_user(u64_to_user_ptr(xfer.tdio),
> data_size);
> > +
>=20
> No blank line.
>=20

Will remove

> > +		if (IS_ERR(xfer_data))
> > +			return -EFAULT;
> > +
> > +		err =3D jtag->ops->xfer(jtag, &xfer, xfer_data);
> > +		if (err) {
> > +			kfree(xfer_data);
> > +			return -EFAULT;
>=20
> Why not return the error given to you?  -EFAULT is only if there is a mem=
ory
> error in a copy_to/from_user() call.
>=20

Will change return code to err

> > +		}
> > +
> > +		err =3D copy_to_user(u64_to_user_ptr(xfer.tdio),
> > +				   (void *)xfer_data, data_size);
> > +		kfree(xfer_data);
> > +		if (err)
> > +			return -EFAULT;
>=20
> Like here, that's correct.
>=20
> > +
> > +		if (copy_to_user((void __user *)arg, (void *)&xfer,
> > +				 sizeof(struct jtag_xfer)))
> > +			return -EFAULT;
> > +		break;
> > +
> > +	case JTAG_GIOCSTATUS:
> > +		err =3D jtag->ops->status_get(jtag, &value);
> > +		if (err)
> > +			break;
> > +
> > +		err =3D put_user(value, (__u32 __user *)arg);
> > +		break;
> > +	case JTAG_SIOCMODE:
> > +		if (!jtag->ops->mode_set)
> > +			return -EOPNOTSUPP;
> > +
> > +		if (get_user(value, (__u32 __user *)arg))
> > +			return -EFAULT;
> > +		if (value =3D=3D 0)
> > +			return -EINVAL;
> > +
> > +		err =3D jtag->ops->mode_set(jtag, value);
> > +		break;
> > +
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +	return err;
> > +}
> > +
> > +static int jtag_open(struct inode *inode, struct file *file) {
> > +	struct jtag *jtag =3D container_of(file->private_data, struct jtag,
> > +miscdev);
> > +
> > +	if (mutex_lock_interruptible(&jtag->open_lock))
> > +		return -ERESTARTSYS;
>=20
> Why restart?  Just grab the lock, you don't want to have to do restartabl=
e
> logic in userspace, right?

Will change like:

ret =3D mutex_lock_interruptible(&jtag->open_lock);
if (ret)
	return ret;

>=20
> > +
> > +	if (jtag->opened) {
> > +		mutex_unlock(&jtag->open_lock);
> > +		return -EBUSY;
>=20
> Why do you care about only 1 userspace open call?  What does that buy you=
?
> Userspace can always pass around that file descriptor and use it in multi=
ple
> places, so you are not really "protecting" yourself from anything.
>=20

Accessing to JTAG HW from multiple processes will make confusion in the wor=
k of the JTAG protocol.
And I want to prohibit this.

> And better yet, if you get rid of this, your open/release functions get v=
ery
> tiny and simple.
>=20
> > +	}
> > +	jtag->opened =3D true;
> > +	mutex_unlock(&jtag->open_lock);
> > +
> > +	nonseekable_open(inode, file);
>=20
> No error checking of the return value?  Not good :(

Will add error handling

>=20
> > +	file->private_data =3D jtag;
> > +	return 0;
> > +}
> > +
> > +static int jtag_release(struct inode *inode, struct file *file) {
> > +	struct jtag *jtag =3D file->private_data;
> > +
> > +	mutex_lock(&jtag->open_lock);
> > +	jtag->opened =3D false;
> > +	mutex_unlock(&jtag->open_lock);
> > +	return 0;
> > +}
> > +
> > +static const struct file_operations jtag_fops =3D {
> > +	.owner		=3D THIS_MODULE,
> > +	.open		=3D jtag_open,
> > +	.release	=3D jtag_release,
> > +	.llseek		=3D noop_llseek,
> > +	.unlocked_ioctl =3D jtag_ioctl,
> > +};
> > +
> > +struct jtag *jtag_alloc(struct device *host, size_t priv_size,
> > +			const struct jtag_ops *ops)
> > +{
> > +	struct jtag *jtag;
> > +
> > +	if (!host)
> > +		return NULL;
> > +
> > +	if (!ops)
> > +		return NULL;
> > +
> > +	if (!ops->idle || !ops->status_get || !ops->xfer)
> > +		return NULL;
> > +
> > +	jtag =3D kzalloc(sizeof(*jtag) + priv_size, GFP_KERNEL);
> > +	if (!jtag)
> > +		return NULL;
> > +
> > +	jtag->ops =3D ops;
> > +	jtag->miscdev.parent =3D host;
> > +
> > +	return jtag;
> > +}
> > +EXPORT_SYMBOL_GPL(jtag_alloc);
> > +
> > +void jtag_free(struct jtag *jtag)
> > +{
> > +	kfree(jtag);
> > +}
> > +EXPORT_SYMBOL_GPL(jtag_free);
> > +
> > +static int jtag_register(struct jtag *jtag) {
> > +	struct device *dev =3D jtag->miscdev.parent;
> > +	char *name;
> > +	int err;
> > +	int id;
> > +
> > +	if (!dev)
> > +		return -ENODEV;
> > +
> > +	if (atomic_read(&jtag_refcount) >=3D MAX_JTAG_DEVS)
> > +		return -ENOSPC;
>=20
> Here, you are reading the value, and then setting it a long ways away.
> What happens if two people call this at the same time.  Not good.
> Either do it correctly, or better yet, don't do it at all.
>=20

Removed.

> > +
> > +	id =3D ida_simple_get(&jtag_ida, 0, 0, GFP_KERNEL);
> > +	if (id < 0)
> > +		return id;
> > +
> > +	jtag->id =3D id;
> > +	jtag->opened =3D false;
> > +
> > +	name =3D kzalloc(MAX_JTAG_NAME_LEN, GFP_KERNEL);
> > +	if (!name) {
> > +		err =3D -ENOMEM;
> > +		goto err_jtag_alloc;
> > +	}
> > +
> > +	err =3D snprintf(name, MAX_JTAG_NAME_LEN, "jtag%d", id);
> > +	if (err < 0)
> > +		goto err_jtag_name;
> > +
> > +	mutex_init(&jtag->open_lock);
> > +	jtag->miscdev.fops =3D  &jtag_fops;
> > +	jtag->miscdev.minor =3D MISC_DYNAMIC_MINOR;
> > +	jtag->miscdev.name =3D name;
> > +
> > +	err =3D misc_register(&jtag->miscdev);
> > +	if (err) {
> > +		dev_err(jtag->miscdev.parent, "Unable to register
> device\n");
> > +		goto err_jtag_name;
> > +	}
> > +	pr_info("%s %d\n", __func__, __LINE__);
> > +	atomic_inc(&jtag_refcount);
> > +	return 0;
> > +
> > +err_jtag_name:
> > +	kfree(name);
> > +err_jtag_alloc:
> > +	ida_simple_remove(&jtag_ida, id);
> > +	return err;
> > +}
> > +
> > +static void jtag_unregister(struct jtag *jtag) {
> > +	misc_deregister(&jtag->miscdev);
> > +	kfree(jtag->miscdev.name);
> > +	ida_simple_remove(&jtag_ida, jtag->id);
> > +	atomic_dec(&jtag_refcount);
> > +}
> > +
> > +static void devm_jtag_unregister(struct device *dev, void *res) {
> > +	jtag_unregister(*(struct jtag **)res); }
> > +
> > +int devm_jtag_register(struct device *dev, struct jtag *jtag) {
> > +	struct jtag **ptr;
> > +	int ret;
> > +
> > +	ptr =3D devres_alloc(devm_jtag_unregister, sizeof(*ptr),
> GFP_KERNEL);
> > +	if (!ptr)
> > +		return -ENOMEM;
> > +
> > +	ret =3D jtag_register(jtag);
> > +	if (!ret) {
> > +		*ptr =3D jtag;
> > +		devres_add(dev, ptr);
> > +	} else {
> > +		devres_free(ptr);
> > +	}
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(devm_jtag_register);
> > +
> > +static void __exit jtag_exit(void)
> > +{
> > +	ida_destroy(&jtag_ida);
> > +}
> > +
> > +module_exit(jtag_exit);
> > +
> > +MODULE_AUTHOR("Oleksandr Shamray <oleksandrs@mellanox.com>");
> > +MODULE_DESCRIPTION("Generic jtag support"); MODULE_LICENSE("GPL
> v2");
> > diff --git a/include/linux/jtag.h b/include/linux/jtag.h new file mode
> > 100644 index 0000000..56d784d
> > --- /dev/null
> > +++ b/include/linux/jtag.h
> > @@ -0,0 +1,43 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// include/linux/jtag.h - JTAG class driver // // Copyright (c) 2018
> > +Mellanox Technologies. All rights reserved.
> > +// Copyright (c) 2018 Oleksandr Shamray <oleksandrs@mellanox.com>
> > +
> > +#ifndef __JTAG_H
> > +#define __JTAG_H
> > +
> > +#include <uapi/linux/jtag.h>
> > +
> > +#define jtag_u64_to_ptr(arg) ((void *)(uintptr_t)arg)
>=20
> Why do you need such a horrid cast?  What is this for?  And why use uintp=
tr_t
> at all?  It's not a "normal" kernel type.
>=20

Not needed - will be removed.

> > +
> > +#define JTAG_MAX_XFER_DATA_LEN 65535
> > +
> > +struct jtag;
> > +/**
> > + * struct jtag_ops - callbacks for JTAG control functions:
> > + *
> > + * @freq_get: get frequency function. Filled by dev driver
> > + * @freq_set: set frequency function. Filled by dev driver
> > + * @status_get: set status function. Mandatory func. Filled by dev
> > +driver
> > + * @idle: set JTAG to idle state function. Mandatory func. Filled by
> > +dev driver
> > + * @xfer: send JTAG xfer function. Mandatory func. Filled by dev
> > +driver
> > + * @mode_set: set specific work mode for JTAG. Filled by dev driver
> > +*/ struct jtag_ops {
> > +	int (*freq_get)(struct jtag *jtag, u32 *freq);
> > +	int (*freq_set)(struct jtag *jtag, u32 freq);
> > +	int (*status_get)(struct jtag *jtag, u32 *state);
> > +	int (*idle)(struct jtag *jtag, struct jtag_run_test_idle *idle);
> > +	int (*xfer)(struct jtag *jtag, struct jtag_xfer *xfer, u8 *xfer_data)=
;
> > +	int (*mode_set)(struct jtag *jtag, u32 mode_mask); };
> > +
> > +void *jtag_priv(struct jtag *jtag);
> > +int devm_jtag_register(struct device *dev, struct jtag *jtag); void
> > +devm_jtag_unregister(struct device *dev, void *res); struct jtag
> > +*jtag_alloc(struct device *host, size_t priv_size,
> > +			const struct jtag_ops *ops);
> > +void jtag_free(struct jtag *jtag);
> > +
> > +#endif /* __JTAG_H */
> > diff --git a/include/uapi/linux/jtag.h b/include/uapi/linux/jtag.h new
> > file mode 100644 index 0000000..8bbf1a7
> > --- /dev/null
> > +++ b/include/uapi/linux/jtag.h
> > @@ -0,0 +1,102 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// include/uapi/linux/jtag.h - JTAG class driver uapi // // Copyright
> > +(c) 2018 Mellanox Technologies. All rights reserved.
> > +// Copyright (c) 2018 Oleksandr Shamray <oleksandrs@mellanox.com>
> > +
> > +#ifndef __UAPI_LINUX_JTAG_H
> > +#define __UAPI_LINUX_JTAG_H
> > +
> > +/*
> > + * JTAG_XFER_HW_MODE: JTAG hardware mode. Used to set HW drived
> or
> > +bitbang
> > + * mode. This is bitmask param of ioctl JTAG_SIOCMODE command  */
> > +#define  JTAG_XFER_HW_MODE 1
> > +
> > +/**
> > + * enum jtag_endstate:
> > + *
> > + * @JTAG_STATE_IDLE: JTAG state machine IDLE state
> > + * @JTAG_STATE_PAUSEIR: JTAG state machine PAUSE_IR state
> > + * @JTAG_STATE_PAUSEDR: JTAG state machine PAUSE_DR state  */
> enum
> > +jtag_endstate {
> > +	JTAG_STATE_IDLE,
> > +	JTAG_STATE_PAUSEIR,
> > +	JTAG_STATE_PAUSEDR,
> > +};
> > +
> > +/**
> > + * enum jtag_xfer_type:
> > + *
> > + * @JTAG_SIR_XFER: SIR transfer
> > + * @JTAG_SDR_XFER: SDR transfer
> > + */
> > +enum jtag_xfer_type {
> > +	JTAG_SIR_XFER,
> > +	JTAG_SDR_XFER,
> > +};
> > +
> > +/**
> > + * enum jtag_xfer_direction:
> > + *
> > + * @JTAG_READ_XFER: read transfer
> > + * @JTAG_WRITE_XFER: write transfer
> > + */
> > +enum jtag_xfer_direction {
> > +	JTAG_READ_XFER,
> > +	JTAG_WRITE_XFER,
> > +};
> > +
> > +/**
> > + * struct jtag_run_test_idle - forces JTAG state machine to
> > + * RUN_TEST/IDLE state
> > + *
> > + * @reset: 0 - run IDLE/PAUSE from current state
> > + *         1 - go through TEST_LOGIC/RESET state before  IDLE/PAUSE
> > + * @end: completion flag
> > + * @tck: clock counter
> > + *
> > + * Structure provide interface to JTAG device for  JTAG IDLE execution=
.
> > + */
> > +struct jtag_run_test_idle {
> > +	__u8	reset;
> > +	__u8	endstate;
> > +	__u8	tck;
> > +};
> > +
> > +/**
> > + * struct jtag_xfer - jtag xfer:
> > + *
> > + * @type: transfer type
> > + * @direction: xfer direction
> > + * @length: xfer bits len
> > + * @tdio : xfer data array
> > + * @endir: xfer end state
> > + *
> > + * Structure provide interface to JTAG device for JTAG SDR/SIR xfer
> execution.
> > + */
> > +struct jtag_xfer {
> > +	__u8	type;
> > +	__u8	direction;
> > +	__u8	endstate;
> > +	__u8	padding;
> > +	__u32	length;
> > +	__u64	tdio;
> > +};
> > +
> > +/* ioctl interface */
> > +#define __JTAG_IOCTL_MAGIC	0xb2
> > +
> > +#define JTAG_IOCRUNTEST	_IOW(__JTAG_IOCTL_MAGIC, 0,\
> > +			     struct jtag_run_test_idle)
>=20
> No need for 2 lines here, fits just fine on one.

Ok

>=20
> > +#define JTAG_SIOCFREQ	_IOW(__JTAG_IOCTL_MAGIC, 1, unsigned
> int)
> > +#define JTAG_GIOCFREQ	_IOR(__JTAG_IOCTL_MAGIC, 2, unsigned int)
> > +#define JTAG_IOCXFER	_IOWR(__JTAG_IOCTL_MAGIC, 3, struct
> jtag_xfer)
> > +#define JTAG_GIOCSTATUS _IOWR(__JTAG_IOCTL_MAGIC, 4, enum
> jtag_endstate)
> > +#define JTAG_SIOCMODE	_IOW(__JTAG_IOCTL_MAGIC, 5, unsigned
> int)
> > +
> > +#define JTAG_FIRST_MINOR 0
>=20
> Why is this in a uapi file?

Not needed - will be removed.

>=20
> > +#define JTAG_MAX_DEVICES 32
>=20
> This is never used, why is it in a uapi file?
>=20

Not needed - will be removed.

> So, almost there, with the above mentioned things, I think you can make t=
he
> code even simpler, which is always better, right?
>=20
> thanks,
>=20
> greg k-h

Thanks.

BR,
Oleksandr Shamray
