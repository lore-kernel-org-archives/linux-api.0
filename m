From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 2/4] nsfs: add ioctl to get an owning user namespace for
 ns file descriptor
Date: Tue, 6 Sep 2016 10:54:47 -0500
Message-ID: <20160906155447.GB13751@mail.hallyn.com>
References: <1473148036-32630-1-git-send-email-avagin@openvz.org>
 <1473148036-32630-3-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473148036-32630-3-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrei Vagin <avagin@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.linux-foundation.org, Serge Hallyn <serge.hallyn@canonical.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

Quoting Andrei Vagin (avagin@openvz.org):
> From: Andrey Vagin <avagin@openvz.org>
> 
> Each namespace has an owning user namespace and now there is not way
> to discover these relationships.
> 
> Understending namespaces relationships allows to answer the question:
> what capability does process X have to perform operations on a resource
> governed by namespace Y?
> 
> After a long discussion, Eric W. Biederman proposed to use ioctl-s for
> this purpose.
> 
> The NS_GET_USERNS ioctl returns a file descriptor to an owning user
> namespace.
> It returns EPERM if a target namespace is outside of a current user
> namespace.
> 
> v2: rename parent to relative
> 
> Link: https://lkml.org/lkml/2016/7/6/158
> Signed-off-by: Andrei Vagin <avagin@openvz.org>

Acked-by: Serge Hallyn <serge@hallyn.com>

> ---
>  fs/nsfs.c                 | 95 ++++++++++++++++++++++++++++++++++++++++-------
>  include/uapi/linux/nsfs.h | 11 ++++++
>  2 files changed, 93 insertions(+), 13 deletions(-)
>  create mode 100644 include/uapi/linux/nsfs.h
> 
> diff --git a/fs/nsfs.c b/fs/nsfs.c
> index 8f20d60..be7d193 100644
> --- a/fs/nsfs.c
> +++ b/fs/nsfs.c
> @@ -5,11 +5,16 @@
>  #include <linux/magic.h>
>  #include <linux/ktime.h>
>  #include <linux/seq_file.h>
> +#include <linux/user_namespace.h>
> +#include <linux/nsfs.h>
>  
>  static struct vfsmount *nsfs_mnt;
>  
> +static long ns_ioctl(struct file *filp, unsigned int ioctl,
> +			unsigned long arg);
>  static const struct file_operations ns_file_operations = {
>  	.llseek		= no_llseek,
> +	.unlocked_ioctl = ns_ioctl,
>  };
>  
>  static char *ns_dname(struct dentry *dentry, char *buffer, int buflen)
> @@ -44,22 +49,14 @@ static void nsfs_evict(struct inode *inode)
>  	ns->ops->put(ns);
>  }
>  
> -void *ns_get_path(struct path *path, struct task_struct *task,
> -			const struct proc_ns_operations *ns_ops)
> +static void *__ns_get_path(struct path *path, struct ns_common *ns)
>  {
>  	struct vfsmount *mnt = mntget(nsfs_mnt);
>  	struct qstr qname = { .name = "", };
>  	struct dentry *dentry;
>  	struct inode *inode;
> -	struct ns_common *ns;
>  	unsigned long d;
>  
> -again:
> -	ns = ns_ops->get(task);
> -	if (!ns) {
> -		mntput(mnt);
> -		return ERR_PTR(-ENOENT);
> -	}
>  	rcu_read_lock();
>  	d = atomic_long_read(&ns->stashed);
>  	if (!d)
> @@ -68,7 +65,7 @@ again:
>  	if (!lockref_get_not_dead(&dentry->d_lockref))
>  		goto slow;
>  	rcu_read_unlock();
> -	ns_ops->put(ns);
> +	ns->ops->put(ns);
>  got_it:
>  	path->mnt = mnt;
>  	path->dentry = dentry;
> @@ -77,7 +74,7 @@ slow:
>  	rcu_read_unlock();
>  	inode = new_inode_pseudo(mnt->mnt_sb);
>  	if (!inode) {
> -		ns_ops->put(ns);
> +		ns->ops->put(ns);
>  		mntput(mnt);
>  		return ERR_PTR(-ENOMEM);
>  	}
> @@ -95,17 +92,89 @@ slow:
>  		return ERR_PTR(-ENOMEM);
>  	}
>  	d_instantiate(dentry, inode);
> -	dentry->d_fsdata = (void *)ns_ops;
> +	dentry->d_fsdata = (void *)ns->ops;
>  	d = atomic_long_cmpxchg(&ns->stashed, 0, (unsigned long)dentry);
>  	if (d) {
>  		d_delete(dentry);	/* make sure ->d_prune() does nothing */
>  		dput(dentry);
>  		cpu_relax();
> -		goto again;
> +		return ERR_PTR(-EAGAIN);
>  	}
>  	goto got_it;
>  }
>  
> +void *ns_get_path(struct path *path, struct task_struct *task,
> +			const struct proc_ns_operations *ns_ops)
> +{
> +	struct ns_common *ns;
> +	void *ret;
> +
> +again:
> +	ns = ns_ops->get(task);
> +	if (!ns)
> +		return ERR_PTR(-ENOENT);
> +
> +	ret = __ns_get_path(path, ns);
> +	if (IS_ERR(ret) && PTR_ERR(ret) == -EAGAIN)
> +		goto again;
> +	return ret;
> +}
> +
> +static int open_related_ns(struct ns_common *ns,
> +		   struct ns_common *(*get_ns)(struct ns_common *ns))
> +{
> +	struct path path = {};
> +	struct file *f;
> +	void *err;
> +	int fd;
> +
> +	fd = get_unused_fd_flags(O_CLOEXEC);
> +	if (fd < 0)
> +		return fd;
> +
> +	while (1) {
> +		struct ns_common *relative;
> +
> +		relative = get_ns(ns);
> +		if (IS_ERR(relative)) {
> +			put_unused_fd(fd);
> +			return PTR_ERR(relative);
> +		}
> +
> +		err = __ns_get_path(&path, relative);
> +		if (IS_ERR(err) && PTR_ERR(err) == -EAGAIN)
> +			continue;
> +		break;
> +	}
> +	if (IS_ERR(err)) {
> +		put_unused_fd(fd);
> +		return PTR_ERR(err);
> +	}
> +
> +	f = dentry_open(&path, O_RDONLY, current_cred());
> +	path_put(&path);
> +	if (IS_ERR(f)) {
> +		put_unused_fd(fd);
> +		fd = PTR_ERR(f);
> +	} else
> +		fd_install(fd, f);
> +
> +	return fd;
> +}
> +
> +static long ns_ioctl(struct file *filp, unsigned int ioctl,
> +			unsigned long arg)
> +{
> +	struct ns_common *ns = get_proc_ns(file_inode(filp));
> +
> +	switch (ioctl) {
> +	case NS_GET_USERNS:
> +		return open_related_ns(ns, ns_get_owner);
> +	default:
> +		return -ENOTTY;
> +	}
> +}
> +
>  int ns_get_name(char *buf, size_t size, struct task_struct *task,
>  			const struct proc_ns_operations *ns_ops)
>  {
> diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
> new file mode 100644
> index 0000000..5cacd5c
> --- /dev/null
> +++ b/include/uapi/linux/nsfs.h
> @@ -0,0 +1,11 @@
> +#ifndef __LINUX_NSFS_H
> +#define __LINUX_NSFS_H
> +
> +#include <linux/ioctl.h>
> +
> +#define NSIO	0xb7
> +
> +/* Returns a file descriptor that refers to an owning user namespace */
> +#define NS_GET_USERNS	_IO(NSIO, 0x1)
> +
> +#endif /* __LINUX_NSFS_H */
> -- 
> 2.5.5
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
