From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v0 01/11] stm class: Introduce an abstraction for System
 Trace Module devices
Date: Mon, 9 Mar 2015 15:29:26 -0600
Message-ID: <CANLsYkzmnHSbfoWSEWkDx-UTuypALZv42FsZ0XVWz2bfqdGWZQ@mail.gmail.com>
References: <1425728161-164217-1-git-send-email-alexander.shishkin@linux.intel.com>
	<1425728161-164217-2-git-send-email-alexander.shishkin@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1425728161-164217-2-git-send-email-alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, peter.lachner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, norbert.schulz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keven.boell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yann.fouassier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, laurent.fert-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 7 March 2015 at 04:35, Alexander Shishkin
<alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> A System Trace Module (STM) is a device exporting data in System Trace
> Protocol (STP) format as defined by MIPI STP standards. Examples of such
> devices are Intel Trace Hub and Coresight STM.
>
> This abstraction provides a unified interface for software trace sources
> to send their data over an STM device to a debug host. In order to do
> that, such a trace source needs to be assigned a pair of master/channel
> identifiers that all the data from this source will be tagged with. The
> STP decoder on the debug host side will use these master/channel tags to
> distinguish different trace streams from one another inside one STP
> stream.
>
> This abstraction provides a configfs-based policy management mechanism
> for dynamic allocation of these master/channel pairs based on trace
> source-supplied string identifier. It has the flexibility of being
> defined at runtime and at the same time (provided that the policy
> definition is aligned with the decoding end) consistency.
>
> For userspace trace sources, this abstraction provides write()-based and
> mmap()-based (if the underlying stm device allows this) output mechanism.
>
> For kernel-side trace sources, we provide "stm_source" device class that
> can be connected to an stm device at run time.
>
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Cc: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  Documentation/ABI/testing/configfs-stp-policy    |  44 ++
>  Documentation/ABI/testing/sysfs-class-stm        |  14 +
>  Documentation/ABI/testing/sysfs-class-stm_source |  11 +
>  Documentation/trace/stm.txt                      |  77 +++
>  drivers/Kconfig                                  |   2 +
>  drivers/Makefile                                 |   1 +
>  drivers/stm/Kconfig                              |   8 +
>  drivers/stm/Makefile                             |   3 +
>  drivers/stm/core.c                               | 839 +++++++++++++++++++++++
>  drivers/stm/policy.c                             | 470 +++++++++++++
>  drivers/stm/stm.h                                |  77 +++
>  include/linux/stm.h                              |  87 +++
>  include/uapi/linux/stm.h                         |  47 ++
>  13 files changed, 1680 insertions(+)
>  create mode 100644 Documentation/ABI/testing/configfs-stp-policy
>  create mode 100644 Documentation/ABI/testing/sysfs-class-stm
>  create mode 100644 Documentation/ABI/testing/sysfs-class-stm_source
>  create mode 100644 Documentation/trace/stm.txt
>  create mode 100644 drivers/stm/Kconfig
>  create mode 100644 drivers/stm/Makefile
>  create mode 100644 drivers/stm/core.c
>  create mode 100644 drivers/stm/policy.c
>  create mode 100644 drivers/stm/stm.h
>  create mode 100644 include/linux/stm.h
>  create mode 100644 include/uapi/linux/stm.h
>

[Snip...]

> +
> +static int stm_output_assign(struct stm_device *stm, unsigned int width,
> +                            struct stp_policy_node *policy_node,
> +                            struct stm_output *output)
> +{
> +       unsigned int midx, cidx, mend, cend;
> +       int ret = -EBUSY;
> +
> +       if (width > stm->data->sw_nchannels)
> +               return -EINVAL;
> +
> +       if (policy_node) {

Where does this get set?  All I found is code that is switching on it.

> +               stp_policy_node_get_ranges(policy_node,
> +                                          &midx, &mend, &cidx, &cend);
> +       } else {
> +               midx = stm->data->sw_start;
> +               cidx = 0;
> +               mend = stm->data->sw_end;
> +               cend = stm->data->sw_nchannels - 1;
> +       }
> +
> +       spin_lock(&stm->mc_lock);
> +       if (output->nr_chans)
> +               goto unlock;
> +
> +       ret = stm_find_master_chan(stm, width, &midx, mend, &cidx, cend);
> +       if (ret)
> +               goto unlock;
> +
> +       output->master = midx;
> +       output->channel = cidx;
> +       output->nr_chans = width;
> +       stm_output_claim(stm, output);
> +       dev_dbg(stm->dev, "assigned %u:%u (+%u)\n", midx, cidx, width);
> +
> +       ret = 0;
> +unlock:
> +       spin_unlock(&stm->mc_lock);
> +
> +       return ret;
> +}
> +

[Snip...]

> +
> +/**
> + * stm_source_register_device() - register an stm_source device
> + * @parent:    parent device
> + * @data:      device description structure
> + *
> + * This will create a device of stm_source class that can write
> + * data to an stm device once linked.
> + *
> + * Return:     0 on success, -errno otherwise.
> + */
> +int stm_source_register_device(struct device *parent,
> +                              struct stm_source_data *data)
> +{
> +       struct stm_source_device *src;
> +       struct device *dev;
> +
> +       if (!stm_core_up)
> +               return -EPROBE_DEFER;
> +
> +       src = kzalloc(sizeof(*src), GFP_KERNEL);
> +       if (!src)
> +               return -ENOMEM;
> +
> +       dev = device_create(&stm_source_class, parent, MKDEV(0, 0), NULL, "%s",
> +                           data->name);
> +       if (IS_ERR(dev)) {
> +               kfree(src);
> +               return PTR_ERR(dev);
> +       }
> +
> +       spin_lock_init(&src->link_lock);
> +       INIT_LIST_HEAD(&src->link_entry);
> +       src->dev = dev;
> +       src->data = data;
> +       data->src = src;
> +       dev_set_drvdata(dev, src);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(stm_source_register_device);
> +

[Snip...]

It's really not clear (at least to me) how stm_source_device works.
They make a bridge between the kernel and the STM devices but the
"link" between them is not obvious.  More documentation perhaps?

[Snip...]

> +
> +/**
> + * struct stm_data - STM device description and callbacks
> + * @name:              device name
> + * @stm:               internal structure, only used by stm class code
> + * @sw_start:          first STP master
> + * @sw_end:            last STP master
> + * @sw_nchannels:      number of STP channels per master
> + * @sw_mmiosz:         size of one channel's IO space, for mmap, optional
> + * @write:             write callback
> + * @mmio_addr:         mmap callback, optional
> + *
> + * Fill out this structure before calling stm_register_device() to create
> + * an STM device and stm_unregister_device() to destroy it. It will also be
> + * passed back to write() and mmio_addr() callbacks.
> + */
> +struct stm_data {
> +       const char              *name;
> +       struct stm_device       *stm;
> +       unsigned int            sw_start;
> +       unsigned int            sw_end;

The above kernel doc is the only place where "sw_start" and "sw_end"
are described as first and last STP masters.  Other than that it takes
a really long time to figure out what they really are.  I think a
better naming convention can be chosen here.

> +       unsigned int            sw_nchannels;
> +       unsigned int            sw_mmiosz;
> +       ssize_t                 (*write)(struct stm_data *, unsigned int,
> +                                        unsigned int, const char *, size_t);
> +       phys_addr_t             (*mmio_addr)(struct stm_data *, unsigned int,
> +                                            unsigned int, unsigned int);
> +       void                    (*link)(struct stm_data *, unsigned int,
> +                                       unsigned int);
> +       void                    (*unlink)(struct stm_data *, unsigned int,
> +                                         unsigned int);

It is really not clear to me what the "link" and "unlink" functions do
- documenting what they're for and explain when to use them and (not
use them) would be appreciated.

I think we should also add two things to this structure:  1) a private
field and 2) a (*stm_drv_ioctl) stub.

The private field would be filled by the registrant and left alone by
the generic-stm core.  When parsing the commands in
"stm_char_ioctl()", data->stm_drv_ioctl(private, cmd, arg) could be
called to let architecture specific drivers deal with it.  That way
applications can deal with a single configuration file descriptor.

> +};
> +
> +int stm_register_device(struct device *parent, struct stm_data *stm_data,
> +                       struct module *owner);
> +void stm_unregister_device(struct stm_data *stm_data);
> +
> +struct stm_source_device;
> +
> +/**
> + * struct stm_source_data - STM source device description and callbacks
> + * @name:      device name, will be used for policy lookup
> + * @src:       internal structure, only used by stm class code
> + * @nr_chans:  number of channels to allocate
> + * @link:      called when STM device gets linked to this source
> + * @unlink:    called when STH device is about to be unlinked
> + *
> + * Fill in this structure before calling stm_source_register_device() to
> + * register a source device. Also pass it to unregister and write calls.
> + */
> +struct stm_source_data {
> +       const char              *name;
> +       struct stm_source_device *src;
> +       unsigned int            percpu;
> +       unsigned int            nr_chans;
> +       int                     (*link)(struct stm_source_data *data);
> +       void                    (*unlink)(struct stm_source_data *data);
> +};
> +

I didn't get the linking/unlinking process - it is also not clear as
to why we need struct stm_data and struct stm_source_data.  More
explanation on this would be good.

> +int stm_source_register_device(struct device *parent,
> +                              struct stm_source_data *data);
> +void stm_source_unregister_device(struct stm_source_data *data);
> +
> +int stm_source_write(struct stm_source_data *data, unsigned int chan,
> +                    const char *buf, size_t count);
> +
> +#endif /* _STM_H_ */
> diff --git a/include/uapi/linux/stm.h b/include/uapi/linux/stm.h
> new file mode 100644
> index 0000000000..042b58b53b
> --- /dev/null
> +++ b/include/uapi/linux/stm.h
> @@ -0,0 +1,47 @@
> +/*
> + * System Trace Module (STM) userspace interfaces
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
> +#ifndef _UAPI_LINUX_STM_H
> +#define _UAPI_LINUX_STM_H
> +
> +/**
> + * struct stp_policy_id - identification for the STP policy
> + * @size:      size of the structure including real id[] length
> + * @master:    assigned master
> + * @channel:   first assigned channel
> + * @width:     number of requested channels
> + * @id:                identification string
> + *
> + * User must calculate the total size of the structure and put it into
> + * @size field, fill out the @id and desired @width. In return, kernel
> + * fills out @master, @channel and @width.
> + */
> +struct stp_policy_id {
> +       __u32           size;
> +       __u16           master;
> +       __u16           channel;
> +       __u16           width;
> +       /* padding */
> +       __u16           __reserved_0;
> +       __u32           __reserved_1;
> +       char            id[0];
> +};
> +
> +#define STP_POLICY_ID_SET      _IOWR('%', 0, struct stp_policy_id)
> +#define STP_POLICY_ID_GET      _IOR('%', 1, struct stp_policy_id)
> +
> +#endif /* _UAPI_LINUX_STM_H */
> --
> 2.1.4
>

Aside from the above points I think this is all very good work.  The
patchset should likely be broken up in two sets, one for the generic
STM architecture wrapper and another for the Intel TH part.  That way
things can be worked on independently.

On my side I will get a prototype going that folds the current
coresight-stm driver in this new mindset - I'll let you know how
things go.

Thanks,
Mathieu
