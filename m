From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH] cgroup namespaces: add a 'nsroot=' mountinfo field
Date: Thu, 14 Apr 2016 09:42:00 -0500
Message-ID: <87oa9c6ymf.fsf@x220.int.ebiederm.org>
References: <20160321234133.GA22463@mail.hallyn.com>
	<20160413175736.GC3676@htj.duckdns.org>
	<20160414040436.GA3739@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160414040436.GA3739-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org> (Serge E. Hallyn's
	message of "Wed, 13 Apr 2016 23:04:36 -0500")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Linux Containers <containers-qjLDD68F18O7TbgM5vRIOg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:

> This is so that userspace can distinguish a mount made in a cgroup
> namespace from a bind mount from a cgroup subdirectory.

To do that do you need to print the path, or is an extra option that
reveals nothing except that it was a cgroup mount sufficient?

Is there any practical difference between a mount in a namespace and a
bind mount?

Given the way the conversation has been going I think it would be good
to see the answers to these questions.  Perhaps I missed it but I
haven't seen the answers to those questions.

Eric


>
> Signed-off-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> ---
> Changelog: 2016-04-13: pass kernfs_node rather than dentry to show_options
> ---
>  fs/kernfs/mount.c      |  2 +-
>  include/linux/kernfs.h |  3 ++-
>  kernel/cgroup.c        | 28 +++++++++++++++++++++++++++-
>  3 files changed, 30 insertions(+), 3 deletions(-)
>
> diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> index f73541f..58e8a86 100644
> --- a/fs/kernfs/mount.c
> +++ b/fs/kernfs/mount.c
> @@ -36,7 +36,7 @@ static int kernfs_sop_show_options(struct seq_file *sf, struct dentry *dentry)
>  	struct kernfs_syscall_ops *scops = root->syscall_ops;
>  
>  	if (scops && scops->show_options)
> -		return scops->show_options(sf, root);
> +		return scops->show_options(sf, dentry->d_fsdata, root);
>  	return 0;
>  }
>  
> diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> index c06c442..72b4081 100644
> --- a/include/linux/kernfs.h
> +++ b/include/linux/kernfs.h
> @@ -145,7 +145,8 @@ struct kernfs_node {
>   */
>  struct kernfs_syscall_ops {
>  	int (*remount_fs)(struct kernfs_root *root, int *flags, char *data);
> -	int (*show_options)(struct seq_file *sf, struct kernfs_root *root);
> +	int (*show_options)(struct seq_file *sf, struct kernfs_node *kn,
> +			    struct kernfs_root *root);
>  
>  	int (*mkdir)(struct kernfs_node *parent, const char *name,
>  		     umode_t mode);
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 671dc05..4d26d07 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1593,7 +1593,31 @@ static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
>  	return 0;
>  }
>  
> -static int cgroup_show_options(struct seq_file *seq,
> +static void cgroup_show_nsroot(struct seq_file *seq, struct kernfs_node *knode,
> +			       struct kernfs_root *kroot)
> +{
> +	char *nsroot;
> +	int len, ret;
> +
> +	if (!kroot)
> +		return;
> +	len = kernfs_path_from_node(knode, kroot->kn, NULL, 0);
> +	if (len <= 0)
> +		return;
> +	nsroot = kzalloc(len + 1, GFP_ATOMIC);
> +	if (!nsroot)
> +		return;
> +	ret = kernfs_path_from_node(knode, kroot->kn, nsroot, len + 1);
> +	if (ret <= 0 || ret > len)
> +		goto out;
> +
> +	seq_show_option(seq, "nsroot", nsroot);
> +
> +out:
> +	kfree(nsroot);
> +}
> +
> +static int cgroup_show_options(struct seq_file *seq, struct kernfs_node *kn,
>  			       struct kernfs_root *kf_root)
>  {
>  	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
> @@ -1619,6 +1643,8 @@ static int cgroup_show_options(struct seq_file *seq,
>  		seq_puts(seq, ",clone_children");
>  	if (strlen(root->name))
>  		seq_show_option(seq, "name", root->name);
> +	cgroup_show_nsroot(seq, kn, kf_root);
> +
>  	return 0;
>  }
