From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [REVIEW][PATCH 2/4] proc: Implement /proc/thread-self to point
	at the directory of the current thread
Date: Wed, 6 Aug 2014 16:35:00 +0200
Message-ID: <20140806143500.GA23127@mail.hallyn.com>
References: <87oaw5caq1.fsf@x220.int.ebiederm.org>
	<87bns5cakh.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87bns5cakh.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Eric W. Biederman (ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org):
> 
> /proc/thread-self is derived from /proc/self.  /proc/thread-self
> points to the directory in proc containing information about the
> current thread.
> 
> This funtionality has been missing for a long time, and is tricky to
> implement in userspace as gettid() is not exported by glibc.  More
> importantly this allows fixing defects in /proc/mounts and /proc/net
> where in a threaded application today they wind up being empty files
> when only the initial pthread has exited, causing problems for other
> threads.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

Hi Eric,

I've not had a chance to test these, but apart from two trivial
comments below these look good to me, and I appreciate the feature.
So with the two fixes (if needed),

Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

> ---
>  fs/proc/Makefile              |  1 +
>  fs/proc/base.c                | 15 +++++---
>  fs/proc/inode.c               |  7 +++-
>  fs/proc/internal.h            |  6 +++
>  fs/proc/root.c                |  3 ++
>  fs/proc/thread_self.c         | 85 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pid_namespace.h |  1 +
>  7 files changed, 112 insertions(+), 6 deletions(-)
>  create mode 100644 fs/proc/thread_self.c
> 
> diff --git a/fs/proc/Makefile b/fs/proc/Makefile
> index 239493ec718e..7151ea428041 100644
> --- a/fs/proc/Makefile
> +++ b/fs/proc/Makefile
> @@ -23,6 +23,7 @@ proc-y	+= version.o
>  proc-y	+= softirqs.o
>  proc-y	+= namespaces.o
>  proc-y	+= self.o
> +proc-y	+= thread_self.o
>  proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
>  proc-$(CONFIG_NET)		+= proc_net.o
>  proc-$(CONFIG_PROC_KCORE)	+= kcore.o
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index ed34e405c6b9..0131156ce7c9 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2847,7 +2847,7 @@ retry:
>  	return iter;
>  }
>  
> -#define TGID_OFFSET (FIRST_PROCESS_ENTRY + 1)
> +#define TGID_OFFSET (FIRST_PROCESS_ENTRY + 2)
>  
>  /* for the /proc/ directory itself, after non-process stuff has been done */
>  int proc_pid_readdir(struct file *file, struct dir_context *ctx)
> @@ -2859,14 +2859,19 @@ int proc_pid_readdir(struct file *file, struct dir_context *ctx)
>  	if (pos >= PID_MAX_LIMIT + TGID_OFFSET)
>  		return 0;
>  
> -	if (pos == TGID_OFFSET - 1) {
> +	if (pos == TGID_OFFSET - 2) {
>  		struct inode *inode = ns->proc_self->d_inode;
>  		if (!dir_emit(ctx, "self", 4, inode->i_ino, DT_LNK))
>  			return 0;
> -		iter.tgid = 0;
> -	} else {
> -		iter.tgid = pos - TGID_OFFSET;
> +		ctx->pos = pos = pos + 1;
> +	}
> +	if (pos == TGID_OFFSET - 1) {
> +		struct inode *inode = ns->proc_thread_self->d_inode;
> +		if (!dir_emit(ctx, "thread-self", 11, inode->i_ino, DT_LNK))
> +			return 0;
> +		ctx->pos = pos = pos + 1;
>  	}
> +	iter.tgid = pos - TGID_OFFSET;
>  	iter.task = NULL;
>  	for (iter = next_tgid(ns, iter);
>  	     iter.task;
> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 0adbc02d60e3..333080d7a671 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -442,6 +442,7 @@ struct inode *proc_get_inode(struct super_block *sb, struct proc_dir_entry *de)
>  int proc_fill_super(struct super_block *s)
>  {
>  	struct inode *root_inode;
> +	int ret;
>  
>  	s->s_flags |= MS_NODIRATIME | MS_NOSUID | MS_NOEXEC;
>  	s->s_blocksize = 1024;
> @@ -463,5 +464,9 @@ int proc_fill_super(struct super_block *s)
>  		return -ENOMEM;
>  	}
>  
> -	return proc_setup_self(s);
> +	ret = proc_setup_self(s);
> +	if (ret) {
> +		return ret;
> +	}
> +	return proc_setup_thread_self(s);
>  }
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index 3ab6d14e71c5..ee04619173b2 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -234,6 +234,12 @@ static inline int proc_net_init(void) { return 0; }
>  extern int proc_setup_self(struct super_block *);
>  
>  /*
> + * proc_thread_self.c
> + */
> +extern int proc_setup_thread_self(struct super_block *);
> +extern void proc_thread_self_init(void);
> +
> +/*
>   * proc_sysctl.c
>   */
>  #ifdef CONFIG_PROC_SYSCTL
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 5dbadecb234d..48f1c03bc7ed 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -149,6 +149,8 @@ static void proc_kill_sb(struct super_block *sb)
>  	ns = (struct pid_namespace *)sb->s_fs_info;
>  	if (ns->proc_self)
>  		dput(ns->proc_self);
> +	if (ns->proc_thread_self)
> +		dput(ns->proc_thread_self);
>  	kill_anon_super(sb);
>  	put_pid_ns(ns);
>  }
> @@ -170,6 +172,7 @@ void __init proc_root_init(void)
>  		return;
>  
>  	proc_self_init();
> +	proc_thread_self_init();
>  	proc_symlink("mounts", NULL, "self/mounts");
>  
>  	proc_net_init();
> diff --git a/fs/proc/thread_self.c b/fs/proc/thread_self.c
> new file mode 100644
> index 000000000000..59075b509df3
> --- /dev/null
> +++ b/fs/proc/thread_self.c
> @@ -0,0 +1,85 @@
> +#include <linux/sched.h>
> +#include <linux/namei.h>
> +#include <linux/slab.h>
> +#include <linux/pid_namespace.h>
> +#include "internal.h"
> +
> +/*
> + * /proc/thread_self:
> + */
> +static int proc_thread_self_readlink(struct dentry *dentry, char __user *buffer,
> +			      int buflen)
> +{
> +	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
> +	pid_t tgid = task_tgid_nr_ns(current, ns);
> +	pid_t pid = task_pid_nr_ns(current, ns);
> +	char tmp[PROC_NUMBUF + 6 + PROC_NUMBUF];

In the extreme case you're not adding space for a \0 ?  (Unless
PROC_NUMBUF includes that)

> +	if (!pid)
> +		return -ENOENT;
> +	sprintf(tmp, "%d/task/%d", tgid, pid);
> +	return readlink_copy(buffer, buflen, tmp);
> +}
> +
> +static void *proc_thread_self_follow_link(struct dentry *dentry, struct nameidata *nd)
> +{
> +	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
> +	pid_t tgid = task_tgid_nr_ns(current, ns);
> +	pid_t pid = task_pid_nr_ns(current, ns);
> +	char *name = ERR_PTR(-ENOENT);
> +	if (pid) {
> +		name = kmalloc(PROC_NUMBUF + 6 + PROC_NUMBUF, GFP_KERNEL);

Same here.

> +		if (!name)
> +			name = ERR_PTR(-ENOMEM);
> +		else
> +			sprintf(name, "%d/task/%d", tgid, pid);
> +	}
> +	nd_set_link(nd, name);
> +	return NULL;
> +}
> +
> +static const struct inode_operations proc_thread_self_inode_operations = {
> +	.readlink	= proc_thread_self_readlink,
> +	.follow_link	= proc_thread_self_follow_link,
> +	.put_link	= kfree_put_link,
> +};
> +
> +static unsigned thread_self_inum;
> +
> +int proc_setup_thread_self(struct super_block *s)
> +{
> +	struct inode *root_inode = s->s_root->d_inode;
> +	struct pid_namespace *ns = s->s_fs_info;
> +	struct dentry *thread_self;
> +
> +	mutex_lock(&root_inode->i_mutex);
> +	thread_self = d_alloc_name(s->s_root, "thread-self");
> +	if (thread_self) {
> +		struct inode *inode = new_inode_pseudo(s);
> +		if (inode) {
> +			inode->i_ino = thread_self_inum;
> +			inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
> +			inode->i_mode = S_IFLNK | S_IRWXUGO;
> +			inode->i_uid = GLOBAL_ROOT_UID;
> +			inode->i_gid = GLOBAL_ROOT_GID;
> +			inode->i_op = &proc_thread_self_inode_operations;
> +			d_add(thread_self, inode);
> +		} else {
> +			dput(thread_self);
> +			thread_self = ERR_PTR(-ENOMEM);
> +		}
> +	} else {
> +		thread_self = ERR_PTR(-ENOMEM);
> +	}
> +	mutex_unlock(&root_inode->i_mutex);
> +	if (IS_ERR(thread_self)) {
> +		pr_err("proc_fill_super: can't allocate /proc/thread_self\n");
> +		return PTR_ERR(thread_self);
> +	}
> +	ns->proc_thread_self = thread_self;
> +	return 0;
> +}
> +
> +void __init proc_thread_self_init(void)
> +{
> +	proc_alloc_inum(&thread_self_inum);
> +}
> diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
> index 7246ef3d4455..1997ffc295a7 100644
> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -33,6 +33,7 @@ struct pid_namespace {
>  #ifdef CONFIG_PROC_FS
>  	struct vfsmount *proc_mnt;
>  	struct dentry *proc_self;
> +	struct dentry *proc_thread_self;
>  #endif
>  #ifdef CONFIG_BSD_PROCESS_ACCT
>  	struct bsd_acct_struct *bacct;
> -- 
> 1.9.1
> 
> _______________________________________________
> Containers mailing list
> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
