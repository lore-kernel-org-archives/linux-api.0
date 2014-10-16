From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv1 7/8] cgroup: cgroup namespace setns support
Date: Thu, 16 Oct 2014 23:12:36 +0200
Message-ID: <20141016211236.GA4308@mail.hallyn.com>
References: <adityakali-cgroupns>
	<1413235430-22944-1-git-send-email-adityakali@google.com>
	<1413235430-22944-8-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1413235430-22944-8-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Aditya Kali (adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> setns on a cgroup namespace is allowed only if
> * task has CAP_SYS_ADMIN in its current user-namespace and
>   over the user-namespace associated with target cgroupns.
> * task's current cgroup is descendent of the target cgroupns-root
>   cgroup.

What is the point of this?

If I'm a user logged into
/lxc/c1/user.slice/user-1000.slice/session-c12.scope and I start
a container which is in
/lxc/c1/user.slice/user-1000.slice/session-c12.scope/x1
then I will want to be able to enter the container's cgroup.
The container's cgroup root is under my own (satisfying the
below condition0 but my cgroup is not a descendent of the
container's cgroup.


> * target cgroupns-root is same as or deeper than task's current
>   cgroupns-root. This is so that the task cannot escape out of its
>   cgroupns-root. This also ensures that setns() only makes the task
>   get restricted to a deeper cgroup hierarchy.
> 
> Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup_namespace.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup_namespace.c b/kernel/cgroup_namespace.c
> index c16604f..c612946 100644
> --- a/kernel/cgroup_namespace.c
> +++ b/kernel/cgroup_namespace.c
> @@ -80,8 +80,48 @@ err_out:
>  
>  static int cgroupns_install(struct nsproxy *nsproxy, void *ns)
>  {
> -	pr_info("setns not supported for cgroup namespace");
> -	return -EINVAL;
> +	struct cgroup_namespace *cgroup_ns = ns;
> +	struct task_struct *task = current;
> +	struct cgroup *cgrp = NULL;
> +	int err = 0;
> +
> +	if (!ns_capable(current_user_ns(), CAP_SYS_ADMIN) ||
> +	    !ns_capable(cgroup_ns->user_ns, CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	/* Prevent cgroup changes for this task. */
> +	threadgroup_lock(task);
> +
> +	cgrp = get_task_cgroup(task);
> +
> +	err = -EINVAL;
> +	if (!cgroup_on_dfl(cgrp))
> +		goto out_unlock;
> +
> +	/* Allow switch only if the task's current cgroup is descendant of the
> +	 * target cgroup_ns->root_cgrp.
> +	 */
> +	if (!cgroup_is_descendant(cgrp, cgroup_ns->root_cgrp))
> +		goto out_unlock;
> +
> +	/* Only allow setns to a cgroupns root-ed deeper than task's current
> +	 * cgroupns-root. This will make sure that tasks cannot escape their
> +	 * cgroupns by attaching to parent cgroupns.
> +	 */
> +	if (!cgroup_is_descendant(cgroup_ns->root_cgrp,
> +				  task_cgroupns_root(task)))
> +		goto out_unlock;
> +
> +	err = 0;
> +	get_cgroup_ns(cgroup_ns);
> +	put_cgroup_ns(nsproxy->cgroup_ns);
> +	nsproxy->cgroup_ns = cgroup_ns;
> +
> +out_unlock:
> +	threadgroup_unlock(current);
> +	if (cgrp)
> +		cgroup_put(cgrp);
> +	return err;
>  }
>  
>  static void *cgroupns_get(struct task_struct *task)
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
