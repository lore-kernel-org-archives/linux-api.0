From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v6 08/11] tpm: Driver for supporting multiple emulated
 TPMs
Date: Thu, 10 Mar 2016 18:39:15 +0200
Message-ID: <20160310163915.GA4863@intel.com>
References: <1457545170-30120-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1457545170-30120-9-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457545170-30120-9-git-send-email-stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 09, 2016 at 12:39:27PM -0500, Stefan Berger wrote:
> This patch implements a driver for supporting multiple emulated TPMs in a
> system.
> 
> The driver implements a device /dev/vtpmx that is used to created
> a client device pair /dev/tpmX (e.g., /dev/tpm10) and a server side that
> is accessed using a file descriptor returned by an ioctl.
> The device /dev/tpmX is the usual TPM device created by the core TPM
> driver. Applications or kernel subsystems can send TPM commands to it
> and the corresponding server-side file descriptor receives these
> commands and delivers them to an emulated TPM.

I wrote my first test program 'tpm2-simulator-vtpm' that at the moment
opens /dev/vtpmx and creates a device. As next step I'm going to
extend this script to connect MS TPM 2.0 simulator based on the work
by Peter Huewe.

It is available here:

git://git.infradead.org/users/jjs/tpm2-scripts.git

The first obvious thing that I observed is that the device is closed
when /dev/vtpmx is closed.

Some might want to use this in a way that the created virtual device
is not closed when /dev/vtpmx is closed.

However, since we have the 'flags' parameter in struct vtpm_new_dev
this is not an issue. We could later on add a new flag for this
behavior and add a new ioctl for destroying a vtpm device. Do you see
that anything would prevent adding this functionality later on if we
ever need it?

/Jarkko

> Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> CC: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> CC: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  drivers/char/tpm/Kconfig    |  10 +
>  drivers/char/tpm/Makefile   |   1 +
>  drivers/char/tpm/tpm_vtpm.c | 566 ++++++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/Kbuild   |   1 +
>  include/uapi/linux/vtpm.h   |  41 ++++
>  5 files changed, 619 insertions(+)
>  create mode 100644 drivers/char/tpm/tpm_vtpm.c
>  create mode 100644 include/uapi/linux/vtpm.h
> 
> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> index 3b84a8b..4c4e843 100644
> --- a/drivers/char/tpm/Kconfig
> +++ b/drivers/char/tpm/Kconfig
> @@ -122,5 +122,15 @@ config TCG_CRB
>  	  from within Linux.  To compile this driver as a module, choose
>  	  M here; the module will be called tpm_crb.
>  
> +config TCG_VTPM
> +	tristate "VTPM Interface"
> +	depends on TCG_TPM
> +	---help---
> +	  This driver supports an emulated TPM (vTPM) running in userspace.
> +	  A device /dev/vtpmx is provided that creates a device pair
> +	  /dev/vtpmX and a server-side file descriptor on which the vTPM
> +	  can receive commands.
> +
> +
>  source "drivers/char/tpm/st33zp24/Kconfig"
>  endif # TCG_TPM
> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> index 56e8f1f..1a409c57 100644
> --- a/drivers/char/tpm/Makefile
> +++ b/drivers/char/tpm/Makefile
> @@ -23,3 +23,4 @@ obj-$(CONFIG_TCG_IBMVTPM) += tpm_ibmvtpm.o
>  obj-$(CONFIG_TCG_TIS_ST33ZP24) += st33zp24/
>  obj-$(CONFIG_TCG_XEN) += xen-tpmfront.o
>  obj-$(CONFIG_TCG_CRB) += tpm_crb.o
> +obj-$(CONFIG_TCG_VTPM) += tpm_vtpm.o
> diff --git a/drivers/char/tpm/tpm_vtpm.c b/drivers/char/tpm/tpm_vtpm.c
> new file mode 100644
> index 0000000..0da311b
> --- /dev/null
> +++ b/drivers/char/tpm/tpm_vtpm.c
> @@ -0,0 +1,566 @@
> +/*
> + * Copyright (C) 2015, 2016 IBM Corporation
> + *
> + * Author: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> + *
> + * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> + *
> + * Device driver for vTPM.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation, version 2 of the
> + * License.
> + *
> + */
> +
> +#include <linux/types.h>
> +#include <linux/spinlock.h>
> +#include <linux/uaccess.h>
> +#include <linux/wait.h>
> +#include <linux/miscdevice.h>
> +#include <linux/vtpm.h>
> +#include <linux/file.h>
> +#include <linux/anon_inodes.h>
> +#include <linux/poll.h>
> +#include <linux/compat.h>
> +
> +#include "tpm.h"
> +
> +#define VTPM_REQ_COMPLETE_FLAG  BIT(0)
> +
> +struct vtpm_dev {
> +	struct tpm_chip *chip;
> +
> +	u32 flags;                   /* public API flags */
> +
> +	wait_queue_head_t wq;
> +
> +	struct mutex buf_lock;       /* protect buffer and flags */
> +
> +	long state;                  /* internal state */
> +#define STATE_OPENED_FLAG        BIT(0)
> +#define STATE_WAIT_RESPONSE_FLAG BIT(1)  /* waiting for emulator response */
> +
> +	size_t req_len;              /* length of queued TPM request */
> +	size_t resp_len;             /* length of queued TPM response */
> +	u8 buffer[TPM_BUFSIZE];      /* request/response buffer */
> +};
> +
> +
> +static void vtpm_delete_device(struct vtpm_dev *vtpm_dev);
> +
> +/*
> + * Functions related to 'server side'
> + */
> +
> +/**
> + * vtpm_fops_read - Read TPM commands on 'server side'
> + *
> + * Return value:
> + *	Number of bytes read or negative error code
> + */
> +static ssize_t vtpm_fops_read(struct file *filp, char __user *buf,
> +			      size_t count, loff_t *off)
> +{
> +	struct vtpm_dev *vtpm_dev = filp->private_data;
> +	size_t len;
> +	int sig, rc;
> +
> +	sig = wait_event_interruptible(vtpm_dev->wq, vtpm_dev->req_len != 0);
> +	if (sig)
> +		return -EINTR;
> +
> +	mutex_lock(&vtpm_dev->buf_lock);
> +
> +	len = vtpm_dev->req_len;
> +
> +	if (count < len) {
> +		mutex_unlock(&vtpm_dev->buf_lock);
> +		pr_debug("Invalid size in recv: count=%zd, req_len=%zd\n",
> +			 count, len);
> +		return -EIO;
> +	}
> +
> +	rc = copy_to_user(buf, vtpm_dev->buffer, len);
> +	memset(vtpm_dev->buffer, 0, len);
> +	vtpm_dev->req_len = 0;
> +
> +	if (!rc)
> +		vtpm_dev->state |= STATE_WAIT_RESPONSE_FLAG;
> +
> +	mutex_unlock(&vtpm_dev->buf_lock);
> +
> +	if (rc)
> +		return -EFAULT;
> +
> +	return len;
> +}
> +
> +/**
> + * vtpm_fops_write - Write TPM responses on 'server side'
> + *
> + * Return value:
> + *	Number of bytes read or negative error value
> + */
> +static ssize_t vtpm_fops_write(struct file *filp, const char __user *buf,
> +			       size_t count, loff_t *off)
> +{
> +	struct vtpm_dev *vtpm_dev = filp->private_data;
> +
> +	mutex_lock(&vtpm_dev->buf_lock);
> +
> +	if (count > sizeof(vtpm_dev->buffer) ||
> +	    !(vtpm_dev->state & STATE_WAIT_RESPONSE_FLAG)) {
> +		mutex_unlock(&vtpm_dev->buf_lock);
> +		return -EIO;
> +	}
> +
> +	vtpm_dev->state &= ~STATE_WAIT_RESPONSE_FLAG;
> +
> +	vtpm_dev->req_len = 0;
> +
> +	if (copy_from_user(vtpm_dev->buffer, buf, count)) {
> +		mutex_unlock(&vtpm_dev->buf_lock);
> +		return -EFAULT;
> +	}
> +
> +	vtpm_dev->resp_len = count;
> +
> +	mutex_unlock(&vtpm_dev->buf_lock);
> +
> +	wake_up_interruptible(&vtpm_dev->wq);
> +
> +	return count;
> +}
> +
> +/*
> + * vtpm_fops_poll: Poll status on 'server side'
> + *
> + * Return value:
> + *      Poll flags
> + */
> +static unsigned int vtpm_fops_poll(struct file *filp, poll_table *wait)
> +{
> +	struct vtpm_dev *vtpm_dev = filp->private_data;
> +	unsigned ret;
> +
> +	poll_wait(filp, &vtpm_dev->wq, wait);
> +
> +	ret = POLLOUT;
> +
> +	mutex_lock(&vtpm_dev->buf_lock);
> +
> +	if (vtpm_dev->req_len)
> +		ret |= POLLIN | POLLRDNORM;
> +
> +	mutex_unlock(&vtpm_dev->buf_lock);
> +
> +	return ret;
> +}
> +
> +/*
> + * vtpm_fops_open - Open vTPM device on 'server side'
> + *
> + * Called when setting up the anonymous file descriptor
> + */
> +static void vtpm_fops_open(struct file *filp)
> +{
> +	struct vtpm_dev *vtpm_dev = filp->private_data;
> +
> +	vtpm_dev->state |= STATE_OPENED_FLAG;
> +}
> +
> +/**
> + * vtpm_fops_undo_open - counter-part to vtpm_fops_open
> + *
> + * Call to undo vtpm_fops_open
> + */
> +static void vtpm_fops_undo_open(struct vtpm_dev *vtpm_dev)
> +{
> +	mutex_lock(&vtpm_dev->buf_lock);
> +
> +	vtpm_dev->state &= ~STATE_OPENED_FLAG;
> +
> +	mutex_unlock(&vtpm_dev->buf_lock);
> +
> +	/* no more TPM responses -- wake up anyone waiting for them */
> +	wake_up_interruptible(&vtpm_dev->wq);
> +}
> +
> +/*
> + * vtpm_fops_release: Close 'server side'
> + *
> + * Return value:
> + *      Always returns 0.
> + */
> +static int vtpm_fops_release(struct inode *inode, struct file *filp)
> +{
> +	struct vtpm_dev *vtpm_dev = filp->private_data;
> +
> +	filp->private_data = NULL;
> +
> +	vtpm_delete_device(vtpm_dev);
> +
> +	return 0;
> +}
> +
> +static const struct file_operations vtpm_fops = {
> +	.owner = THIS_MODULE,
> +	.llseek = no_llseek,
> +	.read = vtpm_fops_read,
> +	.write = vtpm_fops_write,
> +	.poll = vtpm_fops_poll,
> +	.release = vtpm_fops_release,
> +};
> +
> +/*
> + * Functions invoked by the core TPM driver to send TPM commands to
> + * 'server side' and receive responses from there.
> + */
> +
> +/*
> + * Called when core TPM driver reads TPM responses from 'server side'
> + *
> + * Return value:
> + *      Number of TPM response bytes read, negative error value otherwise
> + */
> +static int vtpm_tpm_op_recv(struct tpm_chip *chip, u8 *buf, size_t count)
> +{
> +	struct vtpm_dev *vtpm_dev = chip->vendor.priv;
> +	size_t len;
> +
> +	if (!vtpm_dev)
> +		return -EIO;
> +
> +	/* process gone ? */
> +	mutex_lock(&vtpm_dev->buf_lock);
> +
> +	if (!(vtpm_dev->state & STATE_OPENED_FLAG)) {
> +		mutex_unlock(&vtpm_dev->buf_lock);
> +		return -EPIPE;
> +	}
> +
> +	len = vtpm_dev->resp_len;
> +	if (count < len) {
> +		dev_err(&chip->dev,
> +			"Invalid size in recv: count=%zd, resp_len=%zd\n",
> +			count, len);
> +		len = -EIO;
> +		goto out;
> +	}
> +
> +	memcpy(buf, vtpm_dev->buffer, len);
> +	vtpm_dev->resp_len = 0;
> +
> +out:
> +	mutex_unlock(&vtpm_dev->buf_lock);
> +
> +	return len;
> +}
> +
> +/*
> + * Called when core TPM driver forwards TPM requests to 'server side'.
> + *
> + * Return value:
> + *      0 in case of success, negative error value otherwise.
> + */
> +static int vtpm_tpm_op_send(struct tpm_chip *chip, u8 *buf, size_t count)
> +{
> +	struct vtpm_dev *vtpm_dev = chip->vendor.priv;
> +	int rc = 0;
> +
> +	if (!vtpm_dev)
> +		return -EIO;
> +
> +	if (count > sizeof(vtpm_dev->buffer)) {
> +		dev_err(&chip->dev,
> +			"Invalid size in send: count=%zd, buffer size=%zd\n",
> +			count, sizeof(vtpm_dev->buffer));
> +		return -EIO;
> +	}
> +
> +	mutex_lock(&vtpm_dev->buf_lock);
> +
> +	if (!(vtpm_dev->state & STATE_OPENED_FLAG)) {
> +		mutex_unlock(&vtpm_dev->buf_lock);
> +		return -EPIPE;
> +	}
> +
> +	vtpm_dev->resp_len = 0;
> +
> +	vtpm_dev->req_len = count;
> +	memcpy(vtpm_dev->buffer, buf, count);
> +
> +	vtpm_dev->state &= ~STATE_WAIT_RESPONSE_FLAG;
> +
> +	mutex_unlock(&vtpm_dev->buf_lock);
> +
> +	wake_up_interruptible(&vtpm_dev->wq);
> +
> +	return rc;
> +}
> +
> +static void vtpm_tpm_op_cancel(struct tpm_chip *chip)
> +{
> +	/* not supported */
> +}
> +
> +static u8 vtpm_tpm_op_status(struct tpm_chip *chip)
> +{
> +	struct vtpm_dev *vtpm_dev = chip->vendor.priv;
> +
> +	if (vtpm_dev->resp_len)
> +		return VTPM_REQ_COMPLETE_FLAG;
> +
> +	return 0;
> +}
> +
> +static bool vtpm_tpm_req_canceled(struct tpm_chip  *chip, u8 status)
> +{
> +	struct vtpm_dev *vtpm_dev = chip->vendor.priv;
> +	bool ret;
> +
> +	mutex_lock(&vtpm_dev->buf_lock);
> +
> +	ret = !(vtpm_dev->state & STATE_OPENED_FLAG);
> +
> +	mutex_unlock(&vtpm_dev->buf_lock);
> +
> +	return ret;
> +}
> +
> +static const struct tpm_class_ops vtpm_tpm_ops = {
> +	.recv = vtpm_tpm_op_recv,
> +	.send = vtpm_tpm_op_send,
> +	.cancel = vtpm_tpm_op_cancel,
> +	.status = vtpm_tpm_op_status,
> +	.req_complete_mask = VTPM_REQ_COMPLETE_FLAG,
> +	.req_complete_val = VTPM_REQ_COMPLETE_FLAG,
> +	.req_canceled = vtpm_tpm_req_canceled,
> +};
> +
> +/*
> + * Code related to creation and deletion of device pairs
> + */
> +static struct vtpm_dev *vtpm_create_vtpm_dev(void)
> +{
> +	struct vtpm_dev *vtpm_dev;
> +	struct tpm_chip *chip;
> +	int err;
> +
> +	vtpm_dev = kzalloc(sizeof(*vtpm_dev), GFP_KERNEL);
> +	if (vtpm_dev == NULL)
> +		return ERR_PTR(-ENOMEM);
> +
> +	init_waitqueue_head(&vtpm_dev->wq);
> +	mutex_init(&vtpm_dev->buf_lock);
> +
> +	chip = tpm_chip_alloc(NULL, &vtpm_tpm_ops);
> +	if (IS_ERR(chip)) {
> +		err = PTR_ERR(chip);
> +		goto err_vtpm_dev_free;
> +	}
> +	chip->vendor.priv = vtpm_dev;
> +
> +	vtpm_dev->chip = chip;
> +
> +	return vtpm_dev;
> +
> +err_vtpm_dev_free:
> +	kfree(vtpm_dev);
> +
> +	return ERR_PTR(err);
> +}
> +
> +/*
> + * Undo what has been done in vtpm_create_vtpm_dev
> + */
> +static inline void vtpm_delete_vtpm_dev(struct vtpm_dev *vtpm_dev)
> +{
> +	put_device(&vtpm_dev->chip->dev); /* frees chip */
> +	kfree(vtpm_dev);
> +}
> +
> +/*
> + * Create a /dev/tpm%d and 'server side' file descriptor pair
> + *
> + * Return value:
> + *      Returns file pointer on success, an error value otherwise
> + */
> +static struct file *vtpm_create_device(
> +				       struct vtpm_new_dev *vtpm_new_dev)
> +{
> +	struct vtpm_dev *vtpm_dev;
> +	int rc, fd;
> +	struct file *file;
> +
> +	if (vtpm_new_dev->flags & ~VTPM_FLAGS_ALL)
> +		return ERR_PTR(-EOPNOTSUPP);
> +
> +	vtpm_dev = vtpm_create_vtpm_dev();
> +	if (IS_ERR(vtpm_dev))
> +		return ERR_CAST(vtpm_dev);
> +
> +	vtpm_dev->flags = vtpm_new_dev->flags;
> +
> +	/* setup an anonymous file for the server-side */
> +	fd = get_unused_fd_flags(O_RDWR);
> +	if (fd < 0) {
> +		rc = fd;
> +		goto err_delete_vtpm_dev;
> +	}
> +
> +	file = anon_inode_getfile("[vtpms]", &vtpm_fops, vtpm_dev, O_RDWR);
> +	if (IS_ERR(file)) {
> +		rc = PTR_ERR(file);
> +		goto err_put_unused_fd;
> +	}
> +
> +	/* from now on we can unwind with put_unused_fd() + fput() */
> +	/* simulate an open() on the server side */
> +	vtpm_fops_open(file);
> +
> +	if (vtpm_dev->flags & VTPM_FLAG_TPM2)
> +		vtpm_dev->chip->flags |= TPM_CHIP_FLAG_TPM2;
> +
> +	rc = tpm_chip_register(vtpm_dev->chip);
> +	if (rc)
> +		goto err_vtpm_fput;
> +
> +	vtpm_new_dev->fd = fd;
> +	vtpm_new_dev->major = MAJOR(vtpm_dev->chip->dev.devt);
> +	vtpm_new_dev->minor = MINOR(vtpm_dev->chip->dev.devt);
> +	vtpm_new_dev->dev_num = vtpm_dev->chip->dev_num;
> +
> +	return file;
> +
> +err_vtpm_fput:
> +	put_unused_fd(fd);
> +	fput(file);
> +
> +	return ERR_PTR(rc);
> +
> +err_put_unused_fd:
> +	put_unused_fd(fd);
> +
> +err_delete_vtpm_dev:
> +	vtpm_delete_vtpm_dev(vtpm_dev);
> +
> +	return ERR_PTR(rc);
> +}
> +
> +/*
> + * Counter part to vtpm_create_device.
> + */
> +static void vtpm_delete_device(struct vtpm_dev *vtpm_dev)
> +{
> +	tpm_chip_unregister(vtpm_dev->chip);
> +
> +	vtpm_fops_undo_open(vtpm_dev);
> +
> +	vtpm_delete_vtpm_dev(vtpm_dev);
> +}
> +
> +/*
> + * Code related to the control device /dev/vtpmx
> + */
> +
> +/*
> + * vtpmx_fops_ioctl: ioctl on /dev/vtpmx
> + *
> + * Return value:
> + *      Returns 0 on success, a negative error code otherwise.
> + */
> +static long vtpmx_fops_ioctl(struct file *f, unsigned int ioctl,
> +			    unsigned long arg)
> +{
> +	void __user *argp = (void __user *)arg;
> +	struct vtpm_new_dev *vtpm_new_dev_p;
> +	struct vtpm_new_dev vtpm_new_dev;
> +	struct file *file;
> +
> +	switch (ioctl) {
> +	case VTPM_NEW_DEV:
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EPERM;
> +		vtpm_new_dev_p = argp;
> +		if (copy_from_user(&vtpm_new_dev, vtpm_new_dev_p,
> +				   sizeof(vtpm_new_dev)))
> +			return -EFAULT;
> +		file = vtpm_create_device(&vtpm_new_dev);
> +		if (IS_ERR(file))
> +			return PTR_ERR(file);
> +		if (copy_to_user(vtpm_new_dev_p, &vtpm_new_dev,
> +				 sizeof(vtpm_new_dev))) {
> +			put_unused_fd(vtpm_new_dev.fd);
> +			fput(file);
> +			return -EFAULT;
> +		}
> +
> +		fd_install(vtpm_new_dev.fd, file);
> +		return 0;
> +
> +	default:
> +		return -ENOIOCTLCMD;
> +	}
> +}
> +
> +#ifdef CONFIG_COMPAT
> +static long vtpmx_fops_compat_ioctl(struct file *f, unsigned int ioctl,
> +				    unsigned long arg)
> +{
> +	return vtpmx_fops_ioctl(f, ioctl, (unsigned long)compat_ptr(arg));
> +}
> +#endif
> +
> +static const struct file_operations vtpmx_fops = {
> +	.owner = THIS_MODULE,
> +	.unlocked_ioctl = vtpmx_fops_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl = vtpmx_fops_compat_ioctl,
> +#endif
> +	.llseek = noop_llseek,
> +};
> +
> +static struct miscdevice vtpmx_miscdev = {
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = "vtpmx",
> +	.fops = &vtpmx_fops,
> +};
> +
> +static int vtpmx_init(void)
> +{
> +	return misc_register(&vtpmx_miscdev);
> +}
> +
> +static void vtpmx_cleanup(void)
> +{
> +	misc_deregister(&vtpmx_miscdev);
> +}
> +
> +static int __init vtpm_module_init(void)
> +{
> +	int rc;
> +
> +	rc = vtpmx_init();
> +	if (rc) {
> +		pr_err("couldn't create vtpmx device\n");
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +static void __exit vtpm_module_exit(void)
> +{
> +	vtpmx_cleanup();
> +}
> +
> +module_init(vtpm_module_init);
> +module_exit(vtpm_module_exit);
> +
> +MODULE_AUTHOR("Stefan Berger (stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)");
> +MODULE_DESCRIPTION("vTPM Driver");
> +MODULE_VERSION("0.1");
> +MODULE_LICENSE("GPL");
> diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
> index ebd10e6..3a602c9 100644
> --- a/include/uapi/linux/Kbuild
> +++ b/include/uapi/linux/Kbuild
> @@ -449,6 +449,7 @@ header-y += virtio_scsi.h
>  header-y += virtio_types.h
>  header-y += vm_sockets.h
>  header-y += vt.h
> +header-y += vtpm.h
>  header-y += wait.h
>  header-y += wanrouter.h
>  header-y += watchdog.h
> diff --git a/include/uapi/linux/vtpm.h b/include/uapi/linux/vtpm.h
> new file mode 100644
> index 0000000..4adc486
> --- /dev/null
> +++ b/include/uapi/linux/vtpm.h
> @@ -0,0 +1,41 @@
> +/*
> + * Definitions for the VTPM interface
> + * Copyright (c) 2015, 2016, IBM Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +
> +#ifndef _UAPI_LINUX_VTPM_H
> +#define _UAPI_LINUX_VTPM_H
> +
> +#include <linux/types.h>
> +#include <linux/ioctl.h>
> +
> +/* ioctls */
> +
> +struct vtpm_new_dev {
> +	__u32 flags;         /* input */
> +	__u32 dev_num;       /* output */
> +	__u32 fd;            /* output */
> +	__u32 major;         /* output */
> +	__u32 minor;         /* output */
> +};
> +
> +/* above flags */
> +#define VTPM_FLAG_TPM2           1  /* emulator is TPM 2 */
> +
> +/* all supported flags */
> +#define VTPM_FLAGS_ALL  (VTPM_FLAG_TPM2)
> +
> +#define VTPM_TPM 0xa0
> +
> +#define VTPM_NEW_DEV         _IOW(VTPM_TPM, 0x00, struct vtpm_new_dev)

I'd rather use VTPM_IOC_NEW_DEV.

> +
> +#endif /* _UAPI_LINUX_VTPM_H */
> -- 
> 2.4.3

/Jarkko
 
