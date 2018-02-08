From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] inotify: Extend ioctl to allow to request id of new
 watch descriptor
Date: Thu, 8 Feb 2018 17:14:00 +0100
Message-ID: <20180208161400.t4i42kkpddm2k766@quack2.suse.cz>
References: <151810242614.30935.12876744458891870220.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <151810242614.30935.12876744458891870220.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gorcunov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

[Added CC to linux-api]

On Thu 08-02-18 18:07:37, Kirill Tkhai wrote:
> Watch descriptor is id of the watch created by inotify_add_watch().
> It is allocated in inotify_add_to_idr(), and takes the numbers
> starting from 1. Every new inotify watch obtains next available
> number (usually, old + 1), as served by idr_alloc_cyclic().
> 
> CRIU (Checkpoint/Restore In Userspace) project supports inotify
> files, and restores watched descriptors with the same numbers,
> they had before dump. Since there was no kernel support, we
> had to use cycle to add a watch with specific descriptor id:
> 
> 	while (1) {
> 		int wd;
> 
> 		wd = inotify_add_watch(inotify_fd, path, mask);
> 		if (wd < 0) {
> 			break;
> 		} else if (wd == desired_wd_id) {
> 			ret = 0;
> 			break;
> 		}
> 
> 		inotify_rm_watch(inotify_fd, wd);
> 	}
> 
> (You may find the actual code at the below link:
>  https://github.com/checkpoint-restore/criu/blob/v3.7/criu/fsnotify.c#L577)
> 
> The cycle is suboptiomal and very expensive, but since there is no better
> kernel support, it was the only way to restore that. Happily, we had met
> mostly descriptors with small id, and this approach had worked somehow.
> 
> But recent time containers with inotify with big watch descriptors
> begun to come, and this way stopped to work at all. When descriptor id
> is something about 0x34d71d6, the restoring process spins in busy loop
> for a long time, and the restore hungs and delay of migration from node
> to node could easily be watched.
> 
> This patch aims to solve this problem. It introduces new ioctl
> INOTIFY_IOC_SETNEXTWD, which allows to request the number of next created
> watch descriptor from userspace. It simply calls idr_set_cursor() primitive
> to populate idr::idr_next, so that next idr_alloc_cyclic() allocation
> will return this id, if it is not occupied. This is the way which is
> used to restore some other resources from userspace. For example,
> /proc/sys/kernel/ns_last_pid works the same for task pids.
> 
> The new code is under CONFIG_CHECKPOINT_RESTORE #define, so small system
> may exclude it. The only change in generic inotify part is idr_alloc_cyclic()
> end argument. We had 0 there, and idr subsystem replaced it with INT_MAX
> in idr_get_free(). So, the max possible id was INT_MAX (see idr_get_free()
> again).
> 
> Since I need INOTIFY_IDR_END to check ioctl's third argument, it's better
> it's defined as positive number. But when not-zero value is passed
> to idr_get_free(), this function decrements it. Also, idr_alloc_cyclic()
> defined @end as int argument. So, it's impossible to pass positive @end
> argument to idr_alloc_cyclic() to get INT_MAX id. And after this patch
> inotify watch descriptors ids will take numbers [1, INT_MAX-1], INT_MAX
> will be unavailable.
> 
> Signed-off-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

I'm not thrilled by this but OTOH I also don't know about a better option.
The patch as such looks OK to me so unless someone objects I'll take it to
my tree in a few days.

								Honza


> ---
>  fs/notify/inotify/inotify_user.c |   19 ++++++++++++++++++-
>  include/uapi/linux/inotify.h     |    8 ++++++++
>  2 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
> index 5c29bf16814f..3c824e252c84 100644
> --- a/fs/notify/inotify/inotify_user.c
> +++ b/fs/notify/inotify/inotify_user.c
> @@ -44,6 +44,9 @@
>  
>  #include <asm/ioctls.h>
>  
> +#define INOTIFY_IDR_START	1
> +#define INOTIFY_IDR_END		S32_MAX
> +
>  /* configurable via /proc/sys/fs/inotify/ */
>  static int inotify_max_queued_events __read_mostly;
>  
> @@ -285,6 +288,7 @@ static int inotify_release(struct inode *ignored, struct file *file)
>  static long inotify_ioctl(struct file *file, unsigned int cmd,
>  			  unsigned long arg)
>  {
> +	struct inotify_group_private_data *data __maybe_unused;
>  	struct fsnotify_group *group;
>  	struct fsnotify_event *fsn_event;
>  	void __user *p;
> @@ -293,6 +297,7 @@ static long inotify_ioctl(struct file *file, unsigned int cmd,
>  
>  	group = file->private_data;
>  	p = (void __user *) arg;
> +	data = &group->inotify_data;
>  
>  	pr_debug("%s: group=%p cmd=%u\n", __func__, group, cmd);
>  
> @@ -307,6 +312,17 @@ static long inotify_ioctl(struct file *file, unsigned int cmd,
>  		spin_unlock(&group->notification_lock);
>  		ret = put_user(send_len, (int __user *) p);
>  		break;
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +	case INOTIFY_IOC_SETNEXTWD:
> +		ret = -EINVAL;
> +		if (arg >= INOTIFY_IDR_START && arg < INOTIFY_IDR_END) {
> +			spin_lock(&data->idr_lock);
> +			idr_set_cursor(&data->idr, (unsigned int)arg);
> +			spin_unlock(&data->idr_lock);
> +			ret = 0;
> +		}
> +		break;
> +#endif /* CONFIG_CHECKPOINT_RESTORE */
>  	}
>  
>  	return ret;
> @@ -349,7 +365,8 @@ static int inotify_add_to_idr(struct idr *idr, spinlock_t *idr_lock,
>  	idr_preload(GFP_KERNEL);
>  	spin_lock(idr_lock);
>  
> -	ret = idr_alloc_cyclic(idr, i_mark, 1, 0, GFP_NOWAIT);
> +	ret = idr_alloc_cyclic(idr, i_mark, INOTIFY_IDR_START,
> +			       INOTIFY_IDR_END, GFP_NOWAIT);
>  	if (ret >= 0) {
>  		/* we added the mark to the idr, take a reference */
>  		i_mark->wd = ret;
> diff --git a/include/uapi/linux/inotify.h b/include/uapi/linux/inotify.h
> index 5474461683db..245489342c14 100644
> --- a/include/uapi/linux/inotify.h
> +++ b/include/uapi/linux/inotify.h
> @@ -71,5 +71,13 @@ struct inotify_event {
>  #define IN_CLOEXEC O_CLOEXEC
>  #define IN_NONBLOCK O_NONBLOCK
>  
> +/*
> + * ioctl numbers: inotify uses 'I' prefix for all ioctls,
> + * except historical FIONREAD, which based on 'T'.
> + *
> + * INOTIFY_IOC_SETNEXTWD: set desired number of next created
> + * watch descriptor.
> + */
> +#define INOTIFY_IOC_SETNEXTWD	_IOW('I', 0, __s32)
>  
>  #endif /* _UAPI_LINUX_INOTIFY_H */
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
