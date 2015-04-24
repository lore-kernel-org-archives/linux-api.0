From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 01/11] stm class: Introduce an abstraction for System
 Trace Module devices
Date: Fri, 24 Apr 2015 16:07:13 -0600
Message-ID: <CANLsYkzirrkP_=joY8k8a-Ly+-yT18OOxeySkiDU-aAqGtTE6A@mail.gmail.com>
References: <1427056381-27614-1-git-send-email-alexander.shishkin@linux.intel.com>
	<1427056381-27614-2-git-send-email-alexander.shishkin@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427056381-27614-2-git-send-email-alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, peter.lachner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, norbert.schulz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, keven.boell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yann.fouassier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, laurent.fert-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pratik Patel <pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[...]

> +
> +static int __init stm_core_init(void)
> +{
> +       int err;
> +
> +       err = class_register(&stm_class);
> +       if (err)
> +               return err;
> +
> +       err = class_register(&stm_source_class);
> +       if (err)
> +               goto err_stm;
> +
> +       err = stp_configfs_init();

You can't move "stp_configfs_init()" here and leave "stm_core_init()"
as a "postcore_initcall()".  Function "stp_configfs_init()" calls
"configfs_register_subsystem()" which, after some time, will end up
calling "configfs_new_dirent()".  In there an access to the cache
allocator is done on "configfs_dir_cachep", but it is only initialised
in "configfs_init()" at "module_init()" time, resulting in a -ENOMEM
error.

I don't see how it can be different on x86 but on ARM it is definitely
a problem.

Mathieu

> +       if (err)
> +               goto err_src;
> +
> +       init_srcu_struct(&stm_source_srcu);
> +
> +       stm_core_up++;
> +
> +       return 0;
> +
> +err_src:
> +       class_unregister(&stm_source_class);
> +err_stm:
> +       class_unregister(&stm_class);
> +
> +       return err;
> +}
> +
> +postcore_initcall(stm_core_init);
> +
> +static void __exit stm_core_exit(void)
> +{
> +       class_unregister(&stm_source_class);
> +       class_unregister(&stm_class);
> +       stp_configfs_exit();
> +}
> +
> +module_exit(stm_core_exit);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("System Trace Module device class");
> +MODULE_AUTHOR("Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>");
> diff --git a/drivers/hwtracing/stm/policy.c b/drivers/hwtracing/stm/policy.c
> new file mode 100644
> index 0000000000..b5c59a0e0c
> --- /dev/null
> +++ b/drivers/hwtracing/stm/policy.c
> @@ -0,0 +1,467 @@
> +/*
> + * System Trace Module (STM) master/channel allocation policy management
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
> + * A master/channel allocation policy allows mapping string identifiers to
> + * master and channel ranges, where allocation can be done.
> + */
> +
> +#define pr_fmt(fmt)    KBUILD_MODNAME ": " fmt
> +
> +#include <linux/types.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/configfs.h>
> +#include <linux/slab.h>
> +#include <linux/stm.h>
> +#include "stm.h"
> +
> +/*
> + * STP Master/Channel allocation policy configfs layout.
> + */
> +
> +struct stp_policy {
> +       struct config_group     group;
> +       struct stm_device       *stm;
> +};
> +
> +struct stp_policy_node {
> +       struct config_group     group;
> +       struct stm_device       *stm;
> +       struct stp_policy       *policy;
> +       unsigned int            first_master;
> +       unsigned int            last_master;
> +       unsigned int            first_channel;
> +       unsigned int            last_channel;
> +};
> +
> +void stp_policy_node_get_ranges(struct stp_policy_node *policy_node,
> +                               unsigned int *mstart, unsigned int *mend,
> +                               unsigned int *cstart, unsigned int *cend)
> +{
> +       *mstart = policy_node->first_master;
> +       *mend   = policy_node->last_master;
> +       *cstart = policy_node->first_channel;
> +       *cend   = policy_node->last_channel;
> +}
> +
> +static inline char *stp_policy_node_name(struct stp_policy_node *policy_node)
> +{
> +       return policy_node->group.cg_item.ci_name ? : "<none>";
> +}
> +
> +static inline struct stp_policy *to_stp_policy(struct config_item *item)
> +{
> +       return item ?
> +               container_of(to_config_group(item), struct stp_policy, group) :
> +               NULL;
> +}
> +
> +static inline struct stp_policy_node *
> +to_stp_policy_node(struct config_item *item)
> +{
> +       return item ?
> +               container_of(to_config_group(item), struct stp_policy_node,
> +                            group) :
> +               NULL;
> +}
> +
> +static ssize_t stp_policy_node_masters_show(struct stp_policy_node *policy_node,
> +                                           char *page)
> +{
> +       ssize_t count;
> +
> +       count = sprintf(page, "%u %u\n", policy_node->first_master,
> +                       policy_node->last_master);
> +
> +       return count;
> +}
> +
> +static ssize_t
> +stp_policy_node_masters_store(struct stp_policy_node *policy_node,
> +                             const char *page, size_t count)
> +{
> +       struct stm_device *stm = policy_node->stm;
> +       unsigned int first, last;
> +       char *p = (char *) page;
> +
> +       if (sscanf(p, "%u %u", &first, &last) != 2)
> +               return -EINVAL;
> +
> +       /* must be within [sw_start..sw_end], which is an inclusive range */
> +       if (first > INT_MAX || last > INT_MAX || first > last ||
> +           first < stm->data->sw_start ||
> +           last > stm->data->sw_end)
> +               return -ERANGE;
> +
> +       policy_node->first_master = first;
> +       policy_node->last_master = last;
> +
> +       return count;
> +}
> +
> +static ssize_t
> +stp_policy_node_channels_show(struct stp_policy_node *policy_node, char *page)
> +{
> +       ssize_t count;
> +
> +       count = sprintf(page, "%u %u\n", policy_node->first_channel,
> +                       policy_node->last_channel);
> +
> +       return count;
> +}
> +
> +static ssize_t
> +stp_policy_node_channels_store(struct stp_policy_node *policy_node,
> +                              const char *page, size_t count)
> +{
> +       unsigned int first, last;
> +       char *p = (char *) page;
> +
> +       if (sscanf(p, "%u %u", &first, &last) != 2)
> +               return -EINVAL;
> +
> +       if (first > INT_MAX || last > INT_MAX || first > last ||
> +           last >= policy_node->stm->data->sw_nchannels)
> +               return -ERANGE;
> +
> +       policy_node->first_channel = first;
> +       policy_node->last_channel = last;
> +
> +       return count;
> +}
> +
> +static void stp_policy_node_release(struct config_item *item)
> +{
> +       kfree(to_stp_policy_node(item));
> +}
> +
> +struct stp_policy_node_attribute {
> +       struct configfs_attribute       attr;
> +       ssize_t (*show)(struct stp_policy_node *, char *);
> +       ssize_t (*store)(struct stp_policy_node *, const char *, size_t);
> +};
> +
> +static ssize_t stp_policy_node_attr_show(struct config_item *item,
> +                                        struct configfs_attribute *attr,
> +                                        char *page)
> +{
> +       struct stp_policy_node *policy_node = to_stp_policy_node(item);
> +       struct stp_policy_node_attribute *pn_attr =
> +               container_of(attr, struct stp_policy_node_attribute, attr);
> +       ssize_t count = 0;
> +
> +       if (pn_attr->show)
> +               count = pn_attr->show(policy_node, page);
> +
> +       return count;
> +}
> +
> +static ssize_t stp_policy_node_attr_store(struct config_item *item,
> +                                         struct configfs_attribute *attr,
> +                                         const char *page, size_t len)
> +{
> +       struct stp_policy_node *policy_node = to_stp_policy_node(item);
> +       struct stp_policy_node_attribute *pn_attr =
> +               container_of(attr, struct stp_policy_node_attribute, attr);
> +       ssize_t count = -EINVAL;
> +
> +       if (pn_attr->store)
> +               count = pn_attr->store(policy_node, page, len);
> +
> +       return count;
> +}
> +
> +static struct configfs_item_operations stp_policy_node_item_ops = {
> +       .release                = stp_policy_node_release,
> +       .show_attribute         = stp_policy_node_attr_show,
> +       .store_attribute        = stp_policy_node_attr_store,
> +};
> +
> +static struct stp_policy_node_attribute stp_policy_node_attr_range = {
> +       .attr   = {
> +               .ca_owner = THIS_MODULE,
> +               .ca_name = "masters",
> +               .ca_mode = S_IRUGO | S_IWUSR,
> +       },
> +       .show   = stp_policy_node_masters_show,
> +       .store  = stp_policy_node_masters_store,
> +};
> +
> +static struct stp_policy_node_attribute stp_policy_node_attr_channels = {
> +       .attr   = {
> +               .ca_owner = THIS_MODULE,
> +               .ca_name = "channels",
> +               .ca_mode = S_IRUGO | S_IWUSR,
> +       },
> +       .show   = stp_policy_node_channels_show,
> +       .store  = stp_policy_node_channels_store,
> +};
> +
> +static struct configfs_attribute *stp_policy_node_attrs[] = {
> +       &stp_policy_node_attr_range.attr,
> +       &stp_policy_node_attr_channels.attr,
> +       NULL,
> +};
> +
> +static struct config_item_type stp_policy_type;
> +static struct config_item_type stp_policy_node_type;
> +
> +static struct config_group *
> +stp_policy_node_make(struct config_group *group, const char *name)
> +{
> +       struct stp_policy_node *policy_node, *parent_node;
> +       struct stp_policy *policy;
> +
> +       if (group->cg_item.ci_type == &stp_policy_type) {
> +               policy = container_of(group, struct stp_policy, group);
> +       } else {
> +               parent_node = container_of(group, struct stp_policy_node,
> +                                          group);
> +               policy = parent_node->policy;
> +       }
> +
> +       if (!policy->stm)
> +               return ERR_PTR(-ENODEV);
> +
> +       policy_node = kzalloc(sizeof(struct stp_policy_node), GFP_KERNEL);
> +       if (!policy_node)
> +               return ERR_PTR(-ENOMEM);
> +
> +       config_group_init_type_name(&policy_node->group, name,
> +                                   &stp_policy_node_type);
> +
> +       policy_node->policy = policy;
> +       policy_node->stm = policy->stm;
> +
> +       /* default values for the attributes */
> +       policy_node->first_master = policy->stm->data->sw_start;
> +       policy_node->last_master = policy->stm->data->sw_end;
> +       policy_node->first_channel = 0;
> +       policy_node->last_channel = policy->stm->data->sw_nchannels - 1;
> +
> +       return &policy_node->group;
> +}
> +
> +static void
> +stp_policy_node_drop(struct config_group *group, struct config_item *item)
> +{
> +       config_item_put(item);
> +}
> +
> +static struct configfs_group_operations stp_policy_node_group_ops = {
> +       .make_group     = stp_policy_node_make,
> +       .drop_item      = stp_policy_node_drop,
> +};
> +
> +static struct config_item_type stp_policy_node_type = {
> +       .ct_item_ops    = &stp_policy_node_item_ops,
> +       .ct_group_ops   = &stp_policy_node_group_ops,
> +       .ct_attrs       = stp_policy_node_attrs,
> +       .ct_owner       = THIS_MODULE,
> +};
> +
> +/*
> + * Root group: policies.
> + */
> +static struct configfs_attribute stp_policy_attr_device = {
> +       .ca_owner = THIS_MODULE,
> +       .ca_name = "device",
> +       .ca_mode = S_IRUGO | S_IWUSR,
> +};
> +
> +static struct configfs_attribute *stp_policy_attrs[] = {
> +       &stp_policy_attr_device,
> +       NULL,
> +};
> +
> +static ssize_t stp_policy_attr_show(struct config_item *item,
> +                                   struct configfs_attribute *attr,
> +                                   char *page)
> +{
> +       struct stp_policy *policy = to_stp_policy(item);
> +
> +       return sprintf(page, "%s\n",
> +                      (policy && policy->stm) ?
> +                      policy->stm->data->name :
> +                      "<none>");
> +}
> +
> +static ssize_t stp_policy_attr_store(struct config_item *item,
> +                                    struct configfs_attribute *attr,
> +                                    const char *page, size_t len)
> +{
> +       struct stp_policy *policy = to_stp_policy(item);
> +       ssize_t count = -EINVAL;
> +       struct device *dev;
> +
> +       dev = stm_find_device(page, len);
> +       if (dev) {
> +               count = len;
> +               if (policy->stm)
> +                       put_device(policy->stm->dev);
> +
> +               policy->stm = dev_get_drvdata(dev);
> +
> +               mutex_lock(&policy->stm->policy_mutex);
> +               policy->stm->policy = policy;
> +               mutex_unlock(&policy->stm->policy_mutex);
> +       }
> +
> +       return count;
> +}
> +
> +void stp_policy_unbind(struct stp_policy *policy)
> +{
> +       put_device(policy->stm->dev);
> +
> +       mutex_lock(&policy->stm->policy_mutex);
> +       policy->stm->policy = NULL;
> +       mutex_unlock(&policy->stm->policy_mutex);
> +
> +       policy->stm = NULL;
> +}
> +
> +static void stp_policy_release(struct config_item *item)
> +{
> +       struct stp_policy *policy = to_stp_policy(item);
> +
> +       stp_policy_unbind(policy);
> +       kfree(policy);
> +}
> +
> +static struct configfs_item_operations stp_policy_item_ops = {
> +       .release                = stp_policy_release,
> +       .show_attribute         = stp_policy_attr_show,
> +       .store_attribute        = stp_policy_attr_store,
> +};
> +
> +static struct configfs_group_operations stp_policy_group_ops = {
> +       .make_group     = stp_policy_node_make,
> +};
> +
> +static struct config_item_type stp_policy_type = {
> +       .ct_item_ops    = &stp_policy_item_ops,
> +       .ct_group_ops   = &stp_policy_group_ops,
> +       .ct_attrs       = stp_policy_attrs,
> +       .ct_owner       = THIS_MODULE,
> +};
> +
> +static struct config_group *
> +stp_policies_make(struct config_group *group, const char *name)
> +{
> +       struct stp_policy *policy;
> +
> +       policy = kzalloc(sizeof(*policy), GFP_KERNEL);
> +       if (!policy)
> +               return ERR_PTR(-ENOMEM);
> +
> +       config_group_init_type_name(&policy->group, name,
> +                                   &stp_policy_type);
> +       policy->stm = NULL;
> +
> +       return &policy->group;
> +}
> +
> +static struct configfs_group_operations stp_policies_group_ops = {
> +       .make_group     = stp_policies_make,
> +};
> +
> +static struct config_item_type stp_policies_type = {
> +       .ct_group_ops   = &stp_policies_group_ops,
> +       .ct_owner       = THIS_MODULE,
> +};
> +
> +static struct configfs_subsystem stp_policy_subsys = {
> +       .su_group = {
> +               .cg_item = {
> +                       .ci_namebuf     = "stp-policy",
> +                       .ci_type        = &stp_policies_type,
> +               },
> +       },
> +};
> +
> +/*
> + * Lock the policy mutex from the outside
> + */
> +static struct stp_policy_node *
> +__stp_policy_node_lookup(struct stp_policy *policy, char *s)
> +{
> +       struct stp_policy_node *policy_node, *ret;
> +       struct list_head *head = &policy->group.cg_children;
> +       struct config_item *item;
> +       char *start, *end = s;
> +
> +       if (list_empty(head))
> +               return NULL;
> +
> +       /* return the first entry if everything else fails */
> +       item = list_entry(head->next, struct config_item, ci_entry);
> +       ret = to_stp_policy_node(item);
> +
> +next:
> +       for (;;) {
> +               start = strsep(&end, "/");
> +               if (!start)
> +                       break;
> +
> +               if (!*start)
> +                       continue;
> +
> +               list_for_each_entry(item, head, ci_entry) {
> +                       policy_node = to_stp_policy_node(item);
> +
> +                       if (!strcmp(start,
> +                                   policy_node->group.cg_item.ci_name)) {
> +                               ret = policy_node;
> +
> +                               if (!end)
> +                                       goto out;
> +
> +                               head = &policy_node->group.cg_children;
> +                               goto next;
> +                       }
> +               }
> +               break;
> +       }
> +
> +out:
> +       return ret;
> +}
> +
> +struct stp_policy_node *
> +stp_policy_node_lookup(struct stp_policy *policy, char *s)
> +{
> +       struct stp_policy_node *policy_node;
> +
> +       mutex_lock(&stp_policy_subsys.su_mutex);
> +       policy_node = __stp_policy_node_lookup(policy, s);
> +       mutex_unlock(&stp_policy_subsys.su_mutex);
> +
> +       return policy_node;
> +}
> +
> +int __init stp_configfs_init(void)
> +{
> +       int err;
> +
> +       config_group_init(&stp_policy_subsys.su_group);
> +       mutex_init(&stp_policy_subsys.su_mutex);
> +       err = configfs_register_subsystem(&stp_policy_subsys);
> +
> +       return err;
> +}
> +
> +void __exit stp_configfs_exit(void)
> +{
> +       configfs_unregister_subsystem(&stp_policy_subsys);
> +}
> diff --git a/drivers/hwtracing/stm/stm.h b/drivers/hwtracing/stm/stm.h
> new file mode 100644
> index 0000000000..4d088a1400
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
> +
> +struct stp_policy;
> +struct stp_policy_node;
> +
> +struct stp_policy_node *
> +stp_policy_node_lookup(struct stp_policy *policy, char *s);
> +void stp_policy_unbind(struct stp_policy *policy);
> +
> +void stp_policy_node_get_ranges(struct stp_policy_node *policy_node,
> +                               unsigned int *mstart, unsigned int *mend,
> +                               unsigned int *cstart, unsigned int *cend);
> +int stp_configfs_init(void);
> +void stp_configfs_exit(void);
> +
> +struct stp_master {
> +       unsigned int    nr_free;
> +       unsigned long   chan_map[0];
> +};
> +
> +struct stm_device {
> +       struct device           *dev;
> +       struct module           *owner;
> +       struct stp_policy       *policy;
> +       struct mutex            policy_mutex;
> +       int                     major;
> +       unsigned int            sw_nmasters;
> +       struct stm_data         *data;
> +       spinlock_t              link_lock;
> +       struct list_head        link_list;
> +       /* master allocation */
> +       spinlock_t              mc_lock;
> +       struct stp_master       *masters[0];
> +};
> +
> +struct stm_output {
> +       unsigned int            master;
> +       unsigned int            channel;
> +       unsigned int            nr_chans;
> +};
> +
> +struct stm_file {
> +       struct stm_device       *stm;
> +       struct stp_policy_node  *policy_node;
> +       struct stm_output       output;
> +};
> +
> +struct device *stm_find_device(const char *name, size_t len);
> +
> +struct stm_source_device {
> +       struct device           *dev;
> +       struct stm_source_data  *data;
> +       spinlock_t              link_lock;
> +       struct stm_device       *link;
> +       struct list_head        link_entry;
> +       /* one output per stm_source device */
> +       struct stp_policy_node  *policy_node;
> +       struct stm_output       output;
> +};
> +
> +#endif /* _CLASS_STM_H_ */
> diff --git a/include/linux/stm.h b/include/linux/stm.h
> new file mode 100644
> index 0000000000..976c94d8f1
> --- /dev/null
> +++ b/include/linux/stm.h
> @@ -0,0 +1,102 @@
> +/*
> + * System Trace Module (STM) infrastructure apis
> + * Copyright (C) 2014 Intel Corporation.
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
> +#ifndef _STM_H_
> +#define _STM_H_
> +
> +#include <linux/device.h>
> +
> +struct stp_policy;
> +
> +struct stm_device;
> +
> +/**
> + * struct stm_data - STM device description and callbacks
> + * @name:              device name
> + * @stm:               internal structure, only used by stm class code
> + * @sw_start:          first STP master available to software
> + * @sw_end:            last STP master available to software
> + * @sw_nchannels:      number of STP channels per master
> + * @sw_mmiosz:         size of one channel's IO space, for mmap, optional
> + * @write:             write callback
> + * @mmio_addr:         mmap callback, optional
> + * @link:              called when a new stm_source gets linked to us, optional
> + * @unlink:            likewise for unlinking, again optional
> + * @ioctl:             ioctl callback for device-specific commands
> + *
> + * Fill out this structure before calling stm_register_device() to create
> + * an STM device and stm_unregister_device() to destroy it. It will also be
> + * passed back to @write(), @mmio_addr(), @link(), @unlink() and @ioctl()
> + * callbacks.
> + *
> + * Normally, an STM device will have a range of masters available to software
> + * and the rest being statically assigned to various hardware trace sources.
> + * The former is defined by the the range [@sw_start..@sw_end] of the device
> + * description. That is, the lowest master that can be allocated to software
> + * writers is @sw_start and data from this writer will appear is @sw_start
> + * master in the STP stream.
> + */
> +struct stm_data {
> +       const char              *name;
> +       struct stm_device       *stm;
> +       unsigned int            sw_start;
> +       unsigned int            sw_end;
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
> +       long                    (*ioctl)(struct stm_data *, unsigned int,
> +                                        unsigned long);
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
> + * @link:      called when this source gets linked to an STM device
> + * @unlink:    called when this source is about to get unlinked from its STM
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
