From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv1 4/8] cgroup: export cgroup_get() and cgroup_put()
Date: Thu, 16 Oct 2014 18:14:21 +0200
Message-ID: <20141016161421.GD1392@mail.hallyn.com>
References: <adityakali-cgroupns>
 <1413235430-22944-1-git-send-email-adityakali@google.com>
 <1413235430-22944-5-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1413235430-22944-5-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> move cgroup_get() and cgroup_put() into cgroup.h so that
> they can be called from other places.
> 
> Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

> ---
>  include/linux/cgroup.h | 22 ++++++++++++++++++++++
>  kernel/cgroup.c        | 22 ----------------------
>  2 files changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 80ed6e0..4a0eb2d 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -521,6 +521,28 @@ static inline bool cgroup_on_dfl(const struct cgroup *cgrp)
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
> +static inline bool cgroup_tryget(struct cgroup *cgrp)
> +{
> +	return css_tryget(&cgrp->self);
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
> index 56d507b..2b3e9f9 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -284,12 +284,6 @@ static struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
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
> @@ -1002,22 +996,6 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
>  	return mode;
>  }
>  
> -static void cgroup_get(struct cgroup *cgrp)
> -{
> -	WARN_ON_ONCE(cgroup_is_dead(cgrp));
> -	css_get(&cgrp->self);
> -}
> -
> -static bool cgroup_tryget(struct cgroup *cgrp)
> -{
> -	return css_tryget(&cgrp->self);
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
> 2.1.0.rc2.206.gedb03e5
> 
> _______________________________________________
> Containers mailing list
> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
