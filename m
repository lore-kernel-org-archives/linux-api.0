From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] cgroup: export cgroup_get() and cgroup_put()
Date: Thu, 24 Jul 2014 17:03:16 +0000
Message-ID: <20140724170316.GS26600@ubuntumail>
References: <adityakali-cgroupns>
 <1405626731-12220-1-git-send-email-adityakali@google.com>
 <1405626731-12220-5-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1405626731-12220-5-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> move cgroup_get() and cgroup_put() into cgroup.h so that
> they can be called from other places.
> 
> Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

> ---
>  include/linux/cgroup.h | 17 +++++++++++++++++
>  kernel/cgroup.c        | 18 ------------------
>  2 files changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 707c302..4ea477f 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -530,6 +530,23 @@ static inline bool cgroup_on_dfl(const struct cgroup *cgrp)
>  	return cgrp->root == &cgrp_dfl_root;
>  }
>  
> +/* convenient tests for these bits */
> +static inline bool cgroup_is_dead(const struct cgroup *cgrp)
> +{
> +	return !(cgrp->self.flags & CSS_ONLINE);
> +}
> +
> +static inline void cgroup_get(struct cgroup *cgrp)
> +{
> +	WARN_ON_ONCE(cgroup_is_dead(cgrp));
> +	css_get(&cgrp->self);
> +}
> +
> +static inline void cgroup_put(struct cgroup *cgrp)
> +{
> +	css_put(&cgrp->self);
> +}
> +
>  /* no synchronization, the result can only be used as a hint */
>  static inline bool cgroup_has_tasks(struct cgroup *cgrp)
>  {
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 1671345..8552513 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -185,7 +185,6 @@ static int need_forkexit_callback __read_mostly;
>  static struct cftype cgroup_dfl_base_files[];
>  static struct cftype cgroup_legacy_base_files[];
>  
> -static void cgroup_put(struct cgroup *cgrp);
>  static int rebind_subsystems(struct cgroup_root *dst_root,
>  			     unsigned int ss_mask);
>  static int cgroup_destroy_locked(struct cgroup *cgrp);
> @@ -286,12 +285,6 @@ static struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
>  	return cgroup_css(cgrp, ss);
>  }
>  
> -/* convenient tests for these bits */
> -static inline bool cgroup_is_dead(const struct cgroup *cgrp)
> -{
> -	return !(cgrp->self.flags & CSS_ONLINE);
> -}
> -
>  struct cgroup_subsys_state *of_css(struct kernfs_open_file *of)
>  {
>  	struct cgroup *cgrp = of->kn->parent->priv;
> @@ -1029,17 +1022,6 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
>  	return mode;
>  }
>  
> -static void cgroup_get(struct cgroup *cgrp)
> -{
> -	WARN_ON_ONCE(cgroup_is_dead(cgrp));
> -	css_get(&cgrp->self);
> -}
> -
> -static void cgroup_put(struct cgroup *cgrp)
> -{
> -	css_put(&cgrp->self);
> -}
> -
>  /**
>   * cgroup_refresh_child_subsys_mask - update child_subsys_mask
>   * @cgrp: the target cgroup
> -- 
> 2.0.0.526.g5318336
> 
> _______________________________________________
> Containers mailing list
> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
