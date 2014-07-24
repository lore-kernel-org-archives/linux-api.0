From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] cgroup: add function to get task's cgroup on default
 hierarchy
Date: Thu, 24 Jul 2014 16:59:02 +0000
Message-ID: <20140724165902.GQ26600@ubuntumail>
References: <adityakali-cgroupns>
 <1405626731-12220-1-git-send-email-adityakali@google.com>
 <1405626731-12220-4-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1405626731-12220-4-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> get_task_cgroup() returns the (reference counted) cgroup of the
> given task on the default hierarchy.
> 
> Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

> ---
>  include/linux/cgroup.h |  1 +
>  kernel/cgroup.c        | 25 +++++++++++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index b5223c5..707c302 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -591,6 +591,7 @@ static inline void pr_cont_cgroup_path(struct cgroup *cgrp)
>  }
>  
>  char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
> +struct cgroup *get_task_cgroup(struct task_struct *task);
>  
>  int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
>  int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 1e94b71..1671345 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1937,6 +1937,31 @@ char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
>  }
>  EXPORT_SYMBOL_GPL(task_cgroup_path);
>  
> +/*
> + * get_task_cgroup - returns the cgroup of the task in the default cgroup
> + * hierarchy.
> + *
> + * @task: target task
> + * This function returns the @task's cgroup on the default cgroup hierarchy. The
> + * returned cgroup has its reference incremented (by calling cgroup_get()). So
> + * the caller must cgroup_put() the obtained reference once it is done with it.
> + */
> +struct cgroup *get_task_cgroup(struct task_struct *task)
> +{
> +	struct cgroup *cgrp;
> +
> +	mutex_lock(&cgroup_mutex);
> +	down_read(&css_set_rwsem);
> +
> +	cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
> +	cgroup_get(cgrp);
> +
> +	up_read(&css_set_rwsem);
> +	mutex_unlock(&cgroup_mutex);
> +	return cgrp;
> +}
> +EXPORT_SYMBOL_GPL(get_task_cgroup);
> +
>  /* used to track tasks and other necessary states during migration */
>  struct cgroup_taskset {
>  	/* the src and dst cset list running through cset->mg_node */
> -- 
> 2.0.0.526.g5318336
> 
> _______________________________________________
> Containers mailing list
> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
