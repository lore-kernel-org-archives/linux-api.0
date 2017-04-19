From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] pid_ns: Introduce ioctl to set vector of
 ns_last_pid's on ns hierarhy
Date: Wed, 19 Apr 2017 15:27:32 -0500
Message-ID: <20170419202732.GA31691@mail.hallyn.com>
References: <149245014695.17600.12640895883798122726.stgit@localhost.localdomain>
 <149245057248.17600.1341652606136269734.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <149245057248.17600.1341652606136269734.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Kirill Tkhai (ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org):
> On implementing of nested pid namespaces support in CRIU
> (checkpoint-restore in userspace tool) we run into
> the situation, that it's impossible to create a task with
> specific NSpid effectively. After commit 49f4d8b93ccf
> "pidns: Capture the user namespace and filter ns_last_pid"
> it is impossible to set ns_last_pid on any pid namespace,
> except task's active pid_ns (before the commit it was possible
> to write to pid_ns_for_children). Thus, if a restored task
> in a container has more than one pid_ns levels, the restorer
> code must have a task helper for every pid namespace
> of the task's pid_ns hierarhy.
> 
> This is a big problem, because of communication with
> a helper for every pid_ns in the hierarchy is not cheap
> and not performance-good as it implies many helpers wakeups
> to create a single task (independently, how you communicate
> with the helpers). This patch tries to decide the problem.
> 
> It introduces a new pid_ns ns_ioctl(PIDNS_REQ_SET_LAST_PID_VEC),
> which allows to write a vector of last pids on pid_ns hierarchy.
> The vector is passed as a ":"-delimited string with pids,
> written in reverse order. The first number corresponds to
> the opened namespace ns_last_pid, the second is to its parent, etc.
> So, if you have the pid namespaces hierarchy like:
> 
> pid_ns1 (grand father)
>   |
>   v
> pid_ns2 (father)
>   |
>   v
> pid_ns3 (child)
> 
> and the ns of task's of pid_ns3 is open, then the corresponding
> vector will be "last_ns_pid3:last_ns_pid2:last_ns_pid1". This
> vector may be short and it may contain less levels, for example,
> "last_ns_pid3:last_ns_pid2" or even "last_ns_pid3", in dependence
> of which levels you want to populate.
> 
> To write in a pid_ns's ns_last_pid we check that the writer task
> has CAP_SYS_ADMIN permittions in this pid_ns's user_ns.
> 
> One note about struct pidns_ioc_req. It's made extensible and
> may expanded in the future. The always existing fields present
> at the moment, the future fields and they sizes may be determined
> by pidns_ioc_req::req by the future code.
> 
> Signed-off-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Reviewed-by: Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>

(for both patches)

> ---
>  include/uapi/linux/nsfs.h |    9 +++++
>  kernel/pid_namespace.c    |   88 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 97 insertions(+)
> 
> diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
> index 544bbb661475..37bb4af917b5 100644
> --- a/include/uapi/linux/nsfs.h
> +++ b/include/uapi/linux/nsfs.h
> @@ -17,4 +17,13 @@
>  /* Execute namespace-specific ioctl */
>  #define NS_SPECIFIC_IOC		_IO(NSIO, 0x5)
>  
> +struct pidns_ioc_req {
> +/* Set vector of last pids in namespace hierarchy */
> +#define PIDNS_REQ_SET_LAST_PID_VEC	0x1
> +	unsigned int req;
> +	void __user *data;
> +	unsigned int data_size;
> +	char std_fields[0];
> +};
> +
>  #endif /* __LINUX_NSFS_H */
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index de461aa0bf9a..0e86fa15cd92 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -21,6 +21,8 @@
>  #include <linux/export.h>
>  #include <linux/sched/task.h>
>  #include <linux/sched/signal.h>
> +#include <linux/vmalloc.h>
> +#include <uapi/linux/nsfs.h>
>  
>  struct pid_cache {
>  	int nr_ids;
> @@ -428,6 +430,91 @@ static struct ns_common *pidns_get_parent(struct ns_common *ns)
>  	return &get_pid_ns(pid_ns)->ns;
>  }
>  
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +static long set_last_pid_vec(struct pid_namespace *pid_ns,
> +			     struct pidns_ioc_req *req)
> +{
> +	char *str, *p;
> +	int ret = 0;
> +	pid_t pid;
> +
> +	read_lock(&tasklist_lock);
> +	if (!pid_ns->child_reaper)
> +		ret = -EINVAL;
> +	read_unlock(&tasklist_lock);
> +	if (ret)
> +		return ret;
> +
> +	if (req->data_size >= PAGE_SIZE)
> +		return -EINVAL;
> +	str = vmalloc(req->data_size + 1);
> +	if (!str)
> +		return -ENOMEM;
> +	if (copy_from_user(str, req->data, req->data_size)) {
> +		ret = -EFAULT;
> +		goto out_vfree;
> +	}
> +	str[req->data_size] = '\0';
> +
> +	p = str;
> +	while (p && *p != '\0') {
> +		if (!ns_capable(pid_ns->user_ns, CAP_SYS_ADMIN)) {
> +			ret = -EPERM;
> +			goto out_vfree;
> +		}
> +
> +		if (sscanf(p, "%d", &pid) != 1 || pid < 0 || pid > pid_max) {
> +			ret = -EINVAL;
> +			goto out_vfree;
> +		}
> +
> +		/* Write directly: see the comment in pid_ns_ctl_handler() */
> +		pid_ns->last_pid = pid;
> +
> +		p = strchr(p, ':');
> +		pid_ns = pid_ns->parent;
> +		if (p) {
> +			if (!pid_ns) {
> +				ret = -EINVAL;
> +				goto out_vfree;
> +			}
> +			p++;
> +		}
> +	}
> +
> +	ret = 0;
> +out_vfree:
> +	vfree(str);
> +	return ret;
> +}
> +#else	/* CONFIG_CHECKPOINT_RESTORE */
> +static long set_last_pid_vec(struct pid_namespace *pid_ns,
> +			     struct pidns_ioc_req *req)
> +{
> +	return -ENOTTY;
> +}
> +#endif	/* CONFIG_CHECKPOINT_RESTORE */
> +
> +static long pidns_ioctl(struct ns_common *ns, unsigned long arg)
> +{
> +	struct pid_namespace *pid_ns = to_pid_ns(ns);
> +	struct pidns_ioc_req user_req;
> +	int ret;
> +
> +	ret = copy_from_user(&user_req, (void *)arg,
> +			     offsetof(struct pidns_ioc_req, std_fields));
> +	if (ret)
> +		return ret;
> +
> +	switch (user_req.req) {
> +	case PIDNS_REQ_SET_LAST_PID_VEC:
> +		return set_last_pid_vec(pid_ns, &user_req);
> +	default:
> +		return -ENOTTY;
> +	}
> +	return 0;
> +}
> +
>  static struct user_namespace *pidns_owner(struct ns_common *ns)
>  {
>  	return to_pid_ns(ns)->user_ns;
> @@ -441,6 +528,7 @@ const struct proc_ns_operations pidns_operations = {
>  	.install	= pidns_install,
>  	.owner		= pidns_owner,
>  	.get_parent	= pidns_get_parent,
> +	.ns_ioctl	= pidns_ioctl,
>  };
>  
>  static __init int pid_namespaces_init(void)
