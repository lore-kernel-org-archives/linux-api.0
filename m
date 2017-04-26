From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] pid_ns: Introduce ioctl to set vector of
 ns_last_pid's on ns hierarhy
Date: Wed, 26 Apr 2017 17:53:53 +0200
Message-ID: <20170426155352.GA12131@redhat.com>
References: <149245014695.17600.12640895883798122726.stgit@localhost.localdomain>
 <149245057248.17600.1341652606136269734.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <149245057248.17600.1341652606136269734.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 04/17, Kirill Tkhai wrote:
>
> +struct pidns_ioc_req {
> +/* Set vector of last pids in namespace hierarchy */
> +#define PIDNS_REQ_SET_LAST_PID_VEC	0x1
> +	unsigned int req;
> +	void __user *data;
> +	unsigned int data_size;
> +	char std_fields[0];
> +};

see below,

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

why do you need to check ->child_reaper under tasklist_lock? this looks pointless.

In fact I do not understand how it is possible to hit pid_ns->child_reaper == NULL,
there must be at least one task in this namespace, otherwise you can't open a file
which has f_op == ns_file_operations, no?

> +	if (req->data_size >= PAGE_SIZE)
> +		return -EINVAL;
> +	str = vmalloc(req->data_size + 1);

then I don't understand why it makes sense to use vmalloc()

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

Well, this is ioctl(), do we really want to parse the strings?

Can't we make

	struct pidns_ioc_req {
		...
		int nr_pids;
		pid_t  pids[0];
	}

and just use get_user() in a loop? This way we can avoid vmalloc() or anything
else altogether.

Oleg.
