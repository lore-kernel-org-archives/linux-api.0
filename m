From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH] fs: add an ioctl to get an owning userns for a superblock
Date: Tue, 09 May 2017 19:34:00 -0500
Message-ID: <87k25psg7b.fsf@xmission.com>
References: <20170509231938.6467-1-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170509231938.6467-1-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> (Andrei Vagin's message
        of "Tue, 9 May 2017 16:19:38 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> writes:

> The introduced ioctl returns a file descriptor that refers to a owning
> user namespace for a superblock which is associated with a target file
> descriptor.
>
> EPERM is returned if the current process doesn't have CAP_SYS_ADMIN in
> the returned user namespace.
>
> This information is required to dump and restore mount namespaces. We
> need to know to which user namespace a superblock is belonged to.
>
> We already have the SIOCGSKNS ioctl for sockets to get a network
> namespace, so it looks reasonable to use the same interface for
> superblocks too.
>
> This functionality can be useful for users in order to understand
> a running system.

This will probably work.  And the capability check eases any concerns
I might have that this would be a trivial information leak.

That said can we hold off just a little bit.  If open_fs work actually
turns into a real interface that would seem to be the perfect place
to stick this functionality.

Eric

>
> Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Cc: Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Andrei Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> ---
>  fs/ioctl.c              | 23 +++++++++++++++++++++++
>  include/uapi/linux/fs.h |  2 ++
>  2 files changed, 25 insertions(+)
>
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 569db68..22bbf37 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -16,6 +16,8 @@
>  #include <linux/buffer_head.h>
>  #include <linux/falloc.h>
>  #include <linux/sched/signal.h>
> +#include <linux/proc_fs.h>
> +#include <linux/user_namespace.h>
>  
>  #include "internal.h"
>  
> @@ -614,6 +616,25 @@ static int ioctl_file_dedupe_range(struct file *file, void __user *arg)
>  	return ret;
>  }
>  
> +static struct ns_common *get_sb_userns(struct ns_common *ns_common)
> +{
> +	struct user_namespace *ns;
> +
> +	ns = container_of(ns_common, struct user_namespace, ns);
> +
> +	return &get_user_ns(ns)->ns;
> +}
> +
> +static int ioctl_fs_sb_userns(struct file *filp)
> +{
> +	struct super_block *sb = file_inode(filp)->i_sb;
> +
> +	if (!ns_capable(sb->s_user_ns, CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	return open_related_ns(&sb->s_user_ns->ns, get_sb_userns);
> +}
> +
>  /*
>   * When you add any new common ioctls to the switches above and below
>   * please update compat_sys_ioctl() too.
> @@ -677,6 +698,8 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
>  
>  	case FIDEDUPERANGE:
>  		return ioctl_file_dedupe_range(filp, argp);
> +	case FS_IOC_SB_USERNS:
> +		return ioctl_fs_sb_userns(filp);
>  
>  	default:
>  		if (S_ISREG(inode->i_mode))
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 33423aa..26ef2d5 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -246,6 +246,8 @@ struct fsxattr {
>  #define FICLONE		_IOW(0x94, 9, int)
>  #define FICLONERANGE	_IOW(0x94, 13, struct file_clone_range)
>  #define FIDEDUPERANGE	_IOWR(0x94, 54, struct file_dedupe_range)
> +/* Get a file descriptor to an owning userns for a superblock */
> +#define FS_IOC_SB_USERNS		_IOR('X', 55, int)
>  
>  #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
>  #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
