From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/8] cgroup: mount cgroupns-root when inside non-init
 cgroupns
Date: Tue, 24 Nov 2015 12:16:10 -0500
Message-ID: <20151124171610.GS17033@mtj.duckdns.org>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-8-git-send-email-serge@hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1447703505-29672-8-git-send-email-serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello,

On Mon, Nov 16, 2015 at 01:51:44PM -0600, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org wrote:
> +struct dentry *kernfs_obtain_root(struct super_block *sb,
> +				  struct kernfs_node *kn)
> +{
> +	struct dentry *dentry;
> +	struct inode *inode;
> +
> +	BUG_ON(sb->s_op != &kernfs_sops);
> +
> +	/* inode for the given kernfs_node should already exist. */
> +	inode = ilookup(sb, kn->ino);
> +	if (!inode) {
> +		pr_debug("kernfs: could not get inode for '");
> +		pr_cont_kernfs_path(kn);
> +		pr_cont("'.\n");
> +		return ERR_PTR(-EINVAL);
> +	}

Hmmm... but inode might not have been instantiated yet.  Why not use
kernfs_get_inode()?

> +	/* instantiate and link root dentry */
> +	dentry = d_obtain_root(inode);
> +	if (!dentry) {
> +		pr_debug("kernfs: could not get dentry for '");
> +		pr_cont_kernfs_path(kn);
> +		pr_cont("'.\n");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	/* If this is a new dentry, set it up. We need kernfs_mutex because this
> +	 * may be called by callers other than kernfs_fill_super. */

Formatting.

> +	mutex_lock(&kernfs_mutex);
> +	if (!dentry->d_fsdata) {
> +		kernfs_get(kn);
> +		dentry->d_fsdata = kn;
> +	} else {
> +		WARN_ON(dentry->d_fsdata != kn);
> +	}
> +	mutex_unlock(&kernfs_mutex);
> +
> +	return dentry;
> +}

Wouldn't it be simpler to walk dentry from kernfs root than
duplicating dentry instantiation?

> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 1d696de..0a3e893 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2112,11 +2120,31 @@ out_free:
>  	kfree(opts.release_agent);
>  	kfree(opts.name);
>  
> -	if (ret)
> +	if (ret) {
> +		put_cgroup_ns(ns);
>  		return ERR_PTR(ret);
> +	}
>  
>  	dentry = kernfs_mount(fs_type, flags, root->kf_root,
>  				CGROUP_SUPER_MAGIC, &new_sb);
> +
> +	if (!IS_ERR(dentry)) {
> +		/* In non-init cgroup namespace, instead of root cgroup's
> +		 * dentry, we return the dentry corresponding to the
> +		 * cgroupns->root_cgrp.
> +		 */

Formatting.

> +		if (ns != &init_cgroup_ns) {
> +			struct dentry *nsdentry;
> +			struct cgroup *cgrp;
> +
> +			cgrp = cset_cgroup_from_root(ns->root_cgrps, root);
> +			nsdentry = kernfs_obtain_root(dentry->d_sb,
> +				cgrp->kn);
> +			dput(dentry);
> +			dentry = nsdentry;
> +		}
> +	}

So, this would effectively allow namespace mounts to claim controllers
which aren't configured otherwise which doesn't seem like a good idea.
I think the right thing to do for namespace mounts is to always
require an existing superblock.

Thanks.

-- 
tejun
