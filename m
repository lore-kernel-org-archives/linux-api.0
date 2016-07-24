From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 4/5] nsfs: add ioctl to get a parent namespace
Date: Sun, 24 Jul 2016 00:07:24 -0500
Message-ID: <87zip7lj3n.fsf@x220.int.ebiederm.org>
References: <CANaxB-xw_xBUq=0uT14ANv-jfg2NsGaPy=jyDO9=yF03_7toSw@mail.gmail.com>
	<1468548742-32136-1-git-send-email-avagin@openvz.org>
	<1468548742-32136-4-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468548742-32136-4-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> (Andrey
	Vagin's message of "Thu, 14 Jul 2016 19:12:21 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> writes:

> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index 3529a03..a63adfb 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -388,12 +388,38 @@ static int pidns_install(struct nsproxy *nsproxy, struct ns_common *ns)
>  	return 0;
>  }
>  
> +static struct ns_common *pidns_get_parent(struct ns_common *ns)
> +{
> +	struct pid_namespace *active = task_active_pid_ns(current);
> +	struct pid_namespace *pid_ns, *p;
> +
> +	pid_ns = to_pid_ns(ns);
> +	if (pid_ns == &init_pid_ns) {
> +		if (capable(CAP_SYS_ADMIN))
> +			return ERR_PTR(-ENOENT);
> +		return ERR_PTR(-EPERM);
> +	}
> +
> +	pid_ns = p = pid_ns->parent;
> +
> +	for (;;) {
> +		if (p == active)
> +			break;
> +		if (p == &init_pid_ns)
> +			return ERR_PTR(-EPERM);
> +		p = p->parent;
> +	}

Similarly to the user namespace issue the permission check here needs to
be:
	if (!ns_capable(pid_ns->user_ns, CAP_SYS_ADMIN)
		return ERR_PTR(-EPERM);
> +
> +	return &get_pid_ns(pid_ns)->ns;
> +}
> +
>  const struct proc_ns_operations pidns_operations = {
>  	.name		= "pid",
>  	.type		= CLONE_NEWPID,
>  	.get		= pidns_get,
>  	.put		= pidns_put,
>  	.install	= pidns_install,
> +	.get_parent	= pidns_get_parent,
>  };
>  

Eric
