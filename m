From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 3/4] nsfs: add ioctl to get a parent namespace
Date: Tue, 6 Sep 2016 10:51:31 -0500
Message-ID: <20160906155131.GA13751@mail.hallyn.com>
References: <1473148036-32630-1-git-send-email-avagin@openvz.org>
 <1473148036-32630-4-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473148036-32630-4-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrei Vagin <avagin@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "W. Trevor King" <wking@tremily.us>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>
List-Id: linux-api@vger.kernel.org

Quoting Andrei Vagin (avagin@openvz.org):
> From: Andrey Vagin <avagin@openvz.org>
> 
> Pid and user namepaces are hierarchical. There is no way to discover
> parent-child relationships.
> 
> In a future we will use this interface to dump and restore nested
> namespaces.
> 
> Signed-off-by: Andrei Vagin <avagin@openvz.org>

Acked-by: Serge Hallyn <serge@hallyn.com>

> ---
>  fs/nsfs.c                 |  4 ++++
>  include/linux/proc_ns.h   |  1 +
>  include/uapi/linux/nsfs.h |  2 ++
>  kernel/pid_namespace.c    | 19 +++++++++++++++++++
>  kernel/user_namespace.c   |  1 +
>  5 files changed, 27 insertions(+)
> 
> diff --git a/fs/nsfs.c b/fs/nsfs.c
> index be7d193..11a4b15 100644
> --- a/fs/nsfs.c
> +++ b/fs/nsfs.c
> @@ -170,6 +170,10 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
>  	switch (ioctl) {
>  	case NS_GET_USERNS:
>  		return open_related_ns(ns, ns_get_owner);
> +	case NS_GET_PARENT:
> +		if (!ns->ops->get_parent)
> +			return -EINVAL;
> +		return open_related_ns(ns, ns->ops->get_parent);
>  	default:
>  		return -ENOTTY;
>  	}
> diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
> index ca85a43..12cb8bd 100644
> --- a/include/linux/proc_ns.h
> +++ b/include/linux/proc_ns.h
> @@ -19,6 +19,7 @@ struct proc_ns_operations {
>  	void (*put)(struct ns_common *ns);
>  	int (*install)(struct nsproxy *nsproxy, struct ns_common *ns);
>  	struct user_namespace *(*owner)(struct ns_common *ns);
> +	struct ns_common *(*get_parent)(struct ns_common *ns);
>  };
>  
>  extern const struct proc_ns_operations netns_operations;
> diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
> index 5cacd5c..3af6172 100644
> --- a/include/uapi/linux/nsfs.h
> +++ b/include/uapi/linux/nsfs.h
> @@ -7,5 +7,7 @@
>  
>  /* Returns a file descriptor that refers to an owning user namespace */
>  #define NS_GET_USERNS	_IO(NSIO, 0x1)
> +/* Returns a file descriptor that refers to a parent namespace */
> +#define NS_GET_PARENT	_IO(NSIO, 0x2)
>  
>  #endif /* __LINUX_NSFS_H */
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index c18f0f4f..aad470b 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -405,6 +405,24 @@ static int pidns_install(struct nsproxy *nsproxy, struct ns_common *ns)
>  	return 0;
>  }
>  
> +static struct ns_common *pidns_get_parent(struct ns_common *ns)
> +{
> +	struct pid_namespace *active = task_active_pid_ns(current);
> +	struct pid_namespace *pid_ns, *p;
> +
> +	/* See if the parent is in the current namespace */
> +	pid_ns = p = to_pid_ns(ns)->parent;
> +	for (;;) {
> +		if (!p)
> +			return ERR_PTR(-EPERM);
> +		if (p == active)
> +			break;
> +		p = p->parent;
> +	}
> +
> +	return &get_pid_ns(pid_ns)->ns;
> +}
> +
>  static struct user_namespace *pidns_owner(struct ns_common *ns)
>  {
>  	return to_pid_ns(ns)->user_ns;
> @@ -417,6 +435,7 @@ const struct proc_ns_operations pidns_operations = {
>  	.put		= pidns_put,
>  	.install	= pidns_install,
>  	.owner		= pidns_owner,
> +	.get_parent	= pidns_get_parent,
>  };
>  
>  static __init int pid_namespaces_init(void)
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 42a64d5..33b523c 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -1080,6 +1080,7 @@ const struct proc_ns_operations userns_operations = {
>  	.put		= userns_put,
>  	.install	= userns_install,
>  	.owner		= userns_owner,
> +	.get_parent	= ns_get_owner,
>  };
>  
>  static __init int user_namespaces_init(void)
> -- 
> 2.5.5
