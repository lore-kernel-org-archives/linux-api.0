From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv3 7/8] cgroup: mount cgroupns-root when inside non-init
	cgroupns
Date: Fri, 12 Dec 2014 16:55:00 +0800
Message-ID: <548AAD64.8040004@huawei.com>
References: <adityakali-cgroupns>
	<1417744550-6461-1-git-send-email-adityakali@google.com>
	<1417744550-6461-8-git-send-email-adityakali@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1417744550-6461-8-git-send-email-adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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
Cc: richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 2014/12/5 9:55, Aditya Kali wrote:
> This patch enables cgroup mounting inside userns when a process
> as appropriate privileges. The cgroup filesystem mounted is

s/as/has

> rooted at the cgroupns-root. Thus, in a container-setup, only
> the hierarchy under the cgroupns-root is exposed inside the container.
> This allows container management tools to run inside the containers
> without depending on any global state.
> In order to support this, a new kernfs api is added to lookup the
> dentry for the cgroupns-root.
> 
> Signed-off-by: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/kernfs/mount.c      | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/kernfs.h |  2 ++
>  kernel/cgroup.c        | 46 +++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 95 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> index f973ae9..efe5e15 100644
> --- a/fs/kernfs/mount.c
> +++ b/fs/kernfs/mount.c
> @@ -62,6 +62,54 @@ struct kernfs_root *kernfs_root_from_sb(struct super_block *sb)
>  	return NULL;
>  }
>  
> +/**
> + * kernfs_obtain_root - get a dentry for the given kernfs_node
> + * @sb: the kernfs super_block
> + * @kn: kernfs_node for which a dentry is needed
> + *
> + * This can used used by callers which want to mount only a part of the kernfs

s/used used/be used/

s/which/who

> + * as root of the filesystem.
> + */
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
> +
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

/*
 * ...
 */

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

Seperate this as a standalone patch?

> +
>  static int kernfs_fill_super(struct super_block *sb, unsigned long magic)
>  {
>  	struct kernfs_super_info *info = kernfs_info(sb);
> diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> index 3c2be75..b9538e0 100644
> --- a/include/linux/kernfs.h
> +++ b/include/linux/kernfs.h
> @@ -274,6 +274,8 @@ void kernfs_put(struct kernfs_node *kn);
>  struct kernfs_node *kernfs_node_from_dentry(struct dentry *dentry);
>  struct kernfs_root *kernfs_root_from_sb(struct super_block *sb);
>  
> +struct dentry *kernfs_obtain_root(struct super_block *sb,
> +				  struct kernfs_node *kn);
>  struct kernfs_root *kernfs_create_root(struct kernfs_syscall_ops *scops,
>  				       unsigned int flags, void *priv);
>  void kernfs_destroy_root(struct kernfs_root *root);
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index b1ae6d9..e779890 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1438,6 +1438,14 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
>  			return -ENOENT;
>  	}
>  
> +	/* If inside a non-init cgroup namespace, only allow default hierarchy
> +	 * to be mounted.
> +	 */

/*
 * ...
 */

> +	if ((current->nsproxy->cgroup_ns != &init_cgroup_ns) &&
> +	    !(opts->flags & CGRP_ROOT_SANE_BEHAVIOR)) {
> +		return -EINVAL;
> +	}
> +
>  	if (opts->flags & CGRP_ROOT_SANE_BEHAVIOR) {
>  		pr_warn("sane_behavior: this is still under development and its behaviors will change, proceed at your own risk\n");
>  		if (nr_opts != 1) {
> @@ -1630,6 +1638,15 @@ static void init_cgroup_root(struct cgroup_root *root,
>  		set_bit(CGRP_CPUSET_CLONE_CHILDREN, &root->cgrp.flags);
>  }
>  
> +struct dentry *cgroupns_get_root(struct super_block *sb,
> +				 struct cgroup_namespace *ns)
> +{
> +	struct dentry *nsdentry;
> +
> +	nsdentry = kernfs_obtain_root(sb, ns->root_cgrp->kn);
> +	return nsdentry;
> +}
> +
>  static int cgroup_setup_root(struct cgroup_root *root, unsigned int ss_mask)
>  {
>  	LIST_HEAD(tmp_links);
> @@ -1734,6 +1751,14 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
>  	int ret;
>  	int i;
>  	bool new_sb;
> +	struct cgroup_namespace *ns =
> +		get_cgroup_ns(current->nsproxy->cgroup_ns);
> +
> +	/* Check if the caller has permission to mount. */
> +	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN)) {
> +		put_cgroup_ns(ns);
> +		return ERR_PTR(-EPERM);
> +	}
>  
>  	/*
>  	 * The first time anyone tries to mount a cgroup, enable the list
> @@ -1866,11 +1891,28 @@ out_free:
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
> +	if (!IS_ERR(dentry) && (root == &cgrp_dfl_root)) {
> +		/* If this mount is for the default hierarchy in non-init cgroup
> +		 * namespace, then instead of root cgroup's dentry, we return
> +		 * the dentry corresponding to the cgroupns->root_cgrp.
> +		 */
> +		if (ns != &init_cgroup_ns) {
> +			struct dentry *nsdentry;
> +
> +			nsdentry = cgroupns_get_root(dentry->d_sb, ns);
> +			dput(dentry);
> +			dentry = nsdentry;
> +		}
> +	}
> +
>  	if (IS_ERR(dentry) || !new_sb)
>  		cgroup_put(&root->cgrp);
>  
> @@ -1883,6 +1925,7 @@ out_free:
>  		deactivate_super(pinned_sb);
>  	}
>  
> +	put_cgroup_ns(ns);
>  	return dentry;
>  }
>  
> @@ -1911,6 +1954,7 @@ static struct file_system_type cgroup_fs_type = {
>  	.name = "cgroup",
>  	.mount = cgroup_mount,
>  	.kill_sb = cgroup_kill_sb,
> +	.fs_flags = FS_USERNS_MOUNT,
>  };
>  
>  static struct kobject *cgroup_kobj;
> 
