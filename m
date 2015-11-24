From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/8] cgroup: add function to get task's cgroup
Date: Tue, 24 Nov 2015 11:27:28 -0500
Message-ID: <20151124162728.GN17033@mtj.duckdns.org>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
	<1447703505-29672-4-git-send-email-serge@hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447703505-29672-4-git-send-email-serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

On Mon, Nov 16, 2015 at 01:51:40PM -0600, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org wrote:
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 22e3754..29f0b02 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -326,6 +326,7 @@ static inline bool css_tryget_online(struct cgroup_subsys_state *css)
>  		return percpu_ref_tryget_live(&css->refcnt);
>  	return true;
>  }
> +struct cgroup *get_task_cgroup(struct task_struct *task);

Please move this where other prototypes are.

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
> +	spin_lock_bh(&css_set_lock);
> +
> +	cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
> +	cgroup_get(cgrp);
> +
> +	spin_unlock_bh(&css_set_lock);
> +	mutex_unlock(&cgroup_mutex);
> +	return cgrp;
> +}
> +EXPORT_SYMBOL_GPL(get_task_cgroup);

So, exposing cgroup_mutex this way can lead to ugly lock dependency
issues as cgroup_mutex is expected to be outside of pretty much
everything.  task_cgroup_path() does it but it has no users (should
prolly removed) and cgroup_attach_task_all() is pretty specific.

Hmmm... cc'ing Li (btw, please cc him and Johannes from the next
posting).  Li, I don't think cset_cgroup_from_root() really needs
cgroup_mutex.  css_set_lock seems to be enough.  What do you think?

Thanks.

-- 
tejun
