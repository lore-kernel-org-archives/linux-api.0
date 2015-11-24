From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/8] cgroup: introduce cgroup namespaces
Date: Tue, 24 Nov 2015 11:49:27 -0500
Message-ID: <20151124164927.GP17033@mtj.duckdns.org>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-6-git-send-email-serge@hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447703505-29672-6-git-send-email-serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

On Mon, Nov 16, 2015 at 01:51:42PM -0600, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org wrote:
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 99096be..b3ce9d9 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -17,6 +17,9 @@
>  #include <linux/seq_file.h>
>  #include <linux/kernfs.h>
>  #include <linux/jump_label.h>
> +#include <linux/nsproxy.h>
> +#include <linux/types.h>
> +#include <linux/ns_common.h>
>  
>  #include <linux/cgroup-defs.h>
>  
> @@ -237,6 +240,10 @@ static inline bool cgroup_is_dead(const struct cgroup *cgrp)
>  	return !(cgrp->self.flags & CSS_ONLINE);
>  }
>  
> +static inline void css_get(struct cgroup_subsys_state *css);
> +static inline void css_put(struct cgroup_subsys_state *css);
> +static inline bool css_tryget(struct cgroup_subsys_state *css);

Heh, what's going on here?

> +
>  static inline void cgroup_get(struct cgroup *cgrp)
>  {
>  	WARN_ON_ONCE(cgroup_is_dead(cgrp));
> @@ -284,9 +291,11 @@ static inline void cgroup_put(struct cgroup *cgrp)
>  			;						\
>  		else
>  
> -/*
> - * Inline functions.
> - */
> +extern char * __must_check cgroup_path_ns(struct cgroup_namespace *ns,
> +		struct cgroup *cgrp, char *buf, size_t buflen);
> +
> +extern char * __must_check cgroup_path(struct cgroup *cgrp, char *buf,
> +		size_t buflen);

Please move them next to other prototypes and drop extern.

> diff --git a/include/linux/cgroup_namespace.h b/include/linux/cgroup_namespace.h
> new file mode 100644
> index 0000000..ed181c3
> --- /dev/null
> +++ b/include/linux/cgroup_namespace.h
> @@ -0,0 +1,46 @@
> +#ifndef _LINUX_CGROUP_NAMESPACE_H
> +#define _LINUX_CGROUP_NAMESPACE_H
> +
> +#include <linux/nsproxy.h>
> +#include <linux/cgroup.h>
> +#include <linux/types.h>
> +#include <linux/user_namespace.h>
> +
> +struct css_set;

Blank line here or linux/cgroup-defs.h can be included.

> +struct cgroup_namespace {
> +	atomic_t		count;
> +	struct ns_common	ns;
> +	struct user_namespace	*user_ns;
> +	struct css_set          *root_cgrps;
> +};
> +
> +extern struct cgroup_namespace init_cgroup_ns;
> +
> +static inline struct cgroup_namespace *get_cgroup_ns(
> +		struct cgroup_namespace *ns)

I personally prefer putting just the return type on a separate line
when things get too long.

static inline struct cgroup_namespace *
get_cgroup_ns(struct cgroup_namespace *ns)

> +{
> +	if (ns)
> +		atomic_inc(&ns->count);
> +	return ns;
> +}

Ugh... if the function doesn't do anything about the return type,
please make it a void function.  We tried the above style with kobj
and driver model and it ended up pretty horrible.

> +#ifdef CONFIG_CGROUPS
> +extern void free_cgroup_ns(struct cgroup_namespace *ns);
> +extern struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
> +					       struct user_namespace *user_ns,
> +					       struct cgroup_namespace *old_ns);

Please drop extern.

> +#else /* CONFIG_CGROUP */
> +static inline void free_cgroup_ns(struct cgroup_namespace *ns) { }
> +static inline struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
> +					struct user_namespace *user_ns,
> +					struct cgroup_namespace *old_ns)
> +{ return old_ns; }
> +#endif
> +
> +static inline void put_cgroup_ns(struct cgroup_namespace *ns)
> +{
> +	if (ns && atomic_dec_and_test(&ns->count))
> +		free_cgroup_ns(ns);
> +}
> +
> +#endif  /* _LINUX_CGROUP_NAMESPACE_H */

I don't know.  Does this warrant a separate file?

> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index e972259..1d696de 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -57,6 +57,8 @@
>  #include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
>  #include <linux/kthread.h>
>  #include <linux/delay.h>
> +#include <linux/proc_ns.h>
> +#include <linux/cgroup_namespace.h>
>  
>  #include <linux/atomic.h>
>  
> @@ -290,6 +292,15 @@ static bool cgroup_on_dfl(const struct cgroup *cgrp)
>  {
>  	return cgrp->root == &cgrp_dfl_root;
>  }
> +struct cgroup_namespace init_cgroup_ns = {
> +	.count = {
> +		.counter = 1,
> +	},
> +	.user_ns = &init_user_ns,
> +	.ns.ops = &cgroupns_operations,
> +	.ns.inum = PROC_CGROUP_INIT_INO,
> +	.root_cgrps = &init_css_set,
> +};

Can you please tab align the assignments?

> @@ -2148,6 +2159,28 @@ static struct file_system_type cgroup_fs_type = {
>  	.kill_sb = cgroup_kill_sb,
>  };
>  
> +char * __must_check cgroup_path_ns(struct cgroup_namespace *ns,
> +						 struct cgroup *cgrp, char *buf,
> +						 size_t buflen)

Please align to the same column as the argument on the first line and
make the optional @ns the last argument.

> +{
> +	if (ns) {
> +		struct cgroup *root;
> +		root = cset_cgroup_from_root(ns->root_cgrps, cgrp->root);
> +		return kernfs_path_from_node(root->kn, cgrp->kn, buf,
> +					     buflen);
> +	} else {
> +		return kernfs_path(cgrp->kn, buf, buflen);
> +	}
> +}
> +
> +char * __must_check cgroup_path(struct cgroup *cgrp, char *buf,
> +					      size_t buflen)
> +{
> +	return cgroup_path_ns(current->nsproxy->cgroup_ns, cgrp, buf,
> +				      buflen);

Ditto with alignment.

> diff --git a/kernel/cgroup_namespace.c b/kernel/cgroup_namespace.c
> new file mode 100644
> index 0000000..ef20777
> --- /dev/null
> +++ b/kernel/cgroup_namespace.c
> @@ -0,0 +1,127 @@
> +/*
> + *  Copyright (C) 2014 Google Inc.
> + *
> + *  Author: Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org)
> + *
> + *  This program is free software; you can redistribute it and/or modify it
> + *  under the terms of the GNU General Public License as published by the Free
> + *  Software Foundation, version 2 of the License.
> + */
> +
> +#include <linux/cgroup.h>
> +#include <linux/cgroup_namespace.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/nsproxy.h>
> +#include <linux/proc_ns.h>
> +
> +const struct proc_ns_operations cgroupns_operations;
> +
> +static struct cgroup_namespace *alloc_cgroup_ns(void)
> +{
> +	struct cgroup_namespace *new_ns;
> +	int ret;
> +
> +	new_ns = kzalloc(sizeof(struct cgroup_namespace), GFP_KERNEL);
> +	if (!new_ns)
> +		return ERR_PTR(-ENOMEM);
> +	ret = ns_alloc_inum(&new_ns->ns);
> +	if (ret) {
> +		kfree(new_ns);
> +		return ERR_PTR(ret);
> +	}
> +	atomic_set(&new_ns->count, 1);
> +	new_ns->ns.ops = &cgroupns_operations;
> +	return new_ns;
> +}
> +
> +extern void put_css_set(struct css_set *cset);
> +extern  void get_css_set(struct css_set *cset);

Heh, idk, so we're moving cgroup_get/put() to cgroup.h while
redclaring css_set functions in this file?

> +struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
> +					struct user_namespace *user_ns,
> +					struct cgroup_namespace *old_ns)
> +{
> +	struct cgroup_namespace *new_ns = NULL;
> +	struct css_set *cgrps = NULL;
> +	int err;
> +
> +	BUG_ON(!old_ns);
> +
> +	if (!(flags & CLONE_NEWCGROUP))
> +		return get_cgroup_ns(old_ns);
> +
> +	/* Allow only sysadmin to create cgroup namespace. */
> +	err = -EPERM;
> +	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
> +		goto err_out;
> +
> +	cgrps = task_css_set(current);
> +	get_css_set(cgrps);
> +
> +	err = -ENOMEM;
> +	new_ns = alloc_cgroup_ns();
> +	if (!new_ns)
> +		goto err_out;
> +
> +	new_ns->user_ns = get_user_ns(user_ns);
> +	new_ns->root_cgrps = cgrps;

Let's name it ->root_cset.  The data structures involved are already
really confusing.  No need to add more to it.

Thanks.

-- 
tejun
