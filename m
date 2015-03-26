From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2 01/11] stm class: Introduce an abstraction for System
 Trace Module devices
Date: Thu, 26 Mar 2015 23:35:01 +0100
Message-ID: <20150326223501.GB13694@kroah.com>
References: <1427056381-27614-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1427056381-27614-2-git-send-email-alexander.shishkin@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1427056381-27614-2-git-send-email-alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org, peter.lachner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, norbert.schulz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keven.boell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yann.fouassier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, laurent.fert-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 22, 2015 at 10:32:51PM +0200, Alexander Shishkin wrote:
> +static struct attribute *stm_attrs[] = {
> +	&dev_attr_masters.attr,
> +	&dev_attr_channels.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group stm_group = {
> +	.attrs	= stm_attrs,
> +};
> +
> +static const struct attribute_group *stm_groups[] = {
> +	&stm_group,
> +	NULL,
> +};
> +

ATTRIBUTE_GROUP(stm)?

> +static struct class stm_class = {
> +	.name		= "stm",
> +	.dev_groups	= stm_groups,
> +};
> +
> +static int stm_dev_match(struct device *dev, const void *data)
> +{
> +	const char *name = data;
> +
> +	return sysfs_streq(name, dev_name(dev));
> +}
> +
> +/**
> + * stm_find_device() - find stm device by name
> + * @buf:	character buffer containing the name
> + * @len:	length of the name in @buf
> + *
> + * This is called from attributes' store methods, so it will
> + * also trim the trailing newline if necessary.

Why is this needed and the device isn't the one that was just passed to
you in the attribute store method?

> +static int stm_char_open(struct inode *inode, struct file *file)
> +{
> +	struct stm_file *stmf;
> +	struct device *dev;
> +	unsigned int major = imajor(inode);
> +	int err = -ENODEV;
> +
> +	dev = class_find_device(&stm_class, NULL, &major, major_match);
> +	if (!dev)
> +		return -ENODEV;

Where are you documenting your character devices, the major/minor usage,
and the ioctls?  Is that in some other patch?

> +static long
> +stm_char_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	struct stm_file *stmf = file->private_data;
> +	struct stm_data *stm_data = stmf->stm->data;
> +	int err = -ENOTTY;
> +
> +	switch (cmd) {
> +	case STP_POLICY_ID_SET:
> +		err = stm_char_policy_set_ioctl(stmf, (void __user *)arg);

Cast to the proper structure/type instead of void * please.

> +		if (err)
> +			return err;
> +
> +		return stm_char_policy_get_ioctl(stmf, (void __user *)arg);

Same here.

> +
> +	case STP_POLICY_ID_GET:
> +		return stm_char_policy_get_ioctl(stmf, (void __user *)arg);

Same here.

> +	default:
> +		if (stm_data->ioctl)
> +			err = stm_data->ioctl(stm_data, cmd, arg);

oh that's fun, two levels of ioctls, ugh, that makes auditing the code
hard...

> --- /dev/null
> +++ b/drivers/hwtracing/stm/stm.h
> @@ -0,0 +1,79 @@
> +/*
> + * System Trace Module (STM) infrastructure
> + * Copyright (c) 2014, Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * STM class implements generic infrastructure for  System Trace Module devices
> + * as defined in MIPI STPv2 specification.
> + */
> +
> +#ifndef _CLASS_STM_H_
> +#define _CLASS_STM_H_

"_CLASS_" ?

> +
> +struct stp_policy;
> +struct stp_policy_node;
> +
> +struct stp_policy_node *
> +stp_policy_node_lookup(struct stp_policy *policy, char *s);
> +void stp_policy_unbind(struct stp_policy *policy);
> +
> +void stp_policy_node_get_ranges(struct stp_policy_node *policy_node,
> +				unsigned int *mstart, unsigned int *mend,
> +				unsigned int *cstart, unsigned int *cend);
> +int stp_configfs_init(void);
> +void stp_configfs_exit(void);
> +
> +struct stp_master {
> +	unsigned int	nr_free;
> +	unsigned long	chan_map[0];
> +};
> +
> +struct stm_device {
> +	struct device		*dev;
> +	struct module		*owner;
> +	struct stp_policy	*policy;
> +	struct mutex		policy_mutex;
> +	int			major;
> +	unsigned int		sw_nmasters;
> +	struct stm_data		*data;
> +	spinlock_t		link_lock;
> +	struct list_head	link_list;
> +	/* master allocation */
> +	spinlock_t		mc_lock;
> +	struct stp_master	*masters[0];
> +};

This is a "device" so please embed struct device into the device, don't
have it as a pointer.

And modules can not "own" data, they "own" code, so why does the device
have a module pointer?

Every device gets a new major number?  Is that really needed?

> +struct stm_output {
> +	unsigned int		master;
> +	unsigned int		channel;
> +	unsigned int		nr_chans;
> +};
> +
> +struct stm_file {
> +	struct stm_device	*stm;
> +	struct stp_policy_node	*policy_node;
> +	struct stm_output	output;
> +};
> +
> +struct device *stm_find_device(const char *name, size_t len);
> +
> +struct stm_source_device {
> +	struct device		*dev;

Same device question here, this needs to be embedded, not a pointer, to
properly control the lifecycle of this structure.

> +/**
> + * struct stp_policy_id - identification for the STP policy
> + * @size:	size of the structure including real id[] length
> + * @master:	assigned master
> + * @channel:	first assigned channel
> + * @width:	number of requested channels
> + * @id:		identification string
> + *
> + * User must calculate the total size of the structure and put it into
> + * @size field, fill out the @id and desired @width. In return, kernel
> + * fills out @master, @channel and @width.
> + */
> +struct stp_policy_id {
> +	__u32		size;
> +	__u16		master;
> +	__u16		channel;
> +	__u16		width;
> +	/* padding */
> +	__u16		__reserved_0;
> +	__u32		__reserved_1;
> +	char		id[0];
> +};
> +
> +#define STP_POLICY_ID_SET	_IOWR('%', 0, struct stp_policy_id)
> +#define STP_POLICY_ID_GET	_IOR('%', 1, struct stp_policy_id)

Where did you get those ioctl numbers from?

And why need an ioctl at all?

thanks,

greg k-h
