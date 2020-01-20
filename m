From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 1/6] cgroup: unify attach permission checking
Date: Mon, 20 Jan 2020 15:42:45 +0100
Message-ID: <20200120144244.GD30403@redhat.com>
References: <20200117181219.14542-1-christian.brauner@ubuntu.com>
 <20200117181219.14542-2-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200117181219.14542-2-christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

I guess I am totally confused, but...

On 01/17, Christian Brauner wrote:
>
> +static inline bool cgroup_same_domain(const struct cgroup *src_cgrp,
> +				      const struct cgroup *dst_cgrp)
> +{
> +	return src_cgrp->dom_cgrp == dst_cgrp->dom_cgrp;
> +}
> +
> +static int cgroup_attach_permissions(struct cgroup *src_cgrp,
> +				     struct cgroup *dst_cgrp,
> +				     struct super_block *sb, bool thread)
> +{
> +	int ret = 0;
> +
> +	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp, sb);
> +	if (ret)
> +		return ret;
> +
> +	ret = cgroup_migrate_vet_dst(dst_cgrp);
> +	if (ret)
> +		return ret;
> +
> +	if (thread &&
> +	    !cgroup_same_domain(src_cgrp->dom_cgrp, dst_cgrp->dom_cgrp))
                                        ^^^^^^^^^^          ^^^^^^^^^^

             cgroup_same_domain(src_cgrp, dst_cgrp)

no?

And given that cgroup_same_domain() has no other users, perhaps it can
simply check

	     src_cgrp->dom_cgrp != dst_cgrp->dom_cgrp

?

Oleg.
