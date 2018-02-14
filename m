From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2] inotify: Extend ioctl to allow to request id of new
 watch descriptor
Date: Wed, 14 Feb 2018 11:18:11 +0100
Message-ID: <20180214101811.2m7atg4ca7w64m3u@quack2.suse.cz>
References: <151810242614.30935.12876744458891870220.stgit@localhost.localdomain>
 <ca006760-de72-37b3-f6fd-311c86f29b62@virtuozzo.com>
 <20180209125656.e440e0518540d6b76ae42bc0@linux-foundation.org>
 <bb9bafab-9a50-d19e-7293-65e74aca4720@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <bb9bafab-9a50-d19e-7293-65e74aca4720-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org, amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gorcunov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat 10-02-18 01:45:16, Kirill Tkhai wrote:
> On 09.02.2018 23:56, Andrew Morton wrote:
> > On Fri, 9 Feb 2018 18:04:54 +0300 Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
> > 
> >> Watch descriptor is id of the watch created by inotify_add_watch().
> >> It is allocated in inotify_add_to_idr(), and takes the numbers
> >> starting from 1. Every new inotify watch obtains next available
> >> number (usually, old + 1), as served by idr_alloc_cyclic().
> >>
> >> CRIU (Checkpoint/Restore In Userspace) project supports inotify
> >> files, and restores watched descriptors with the same numbers,
> >> they had before dump. Since there was no kernel support, we
> >> had to use cycle to add a watch with specific descriptor id:
> >>
> >> 	while (1) {
> >> 		int wd;
> >>
> >> 		wd = inotify_add_watch(inotify_fd, path, mask);
> >> 		if (wd < 0) {
> >> 			break;
> >> 		} else if (wd == desired_wd_id) {
> >> 			ret = 0;
> >> 			break;
> >> 		}
> >>
> >> 		inotify_rm_watch(inotify_fd, wd);
> >> 	}
> >>
> >> (You may find the actual code at the below link:
> >>  https://github.com/checkpoint-restore/criu/blob/v3.7/criu/fsnotify.c#L577)
> >>
> >> The cycle is suboptiomal and very expensive, but since there is no better
> >> kernel support, it was the only way to restore that. Happily, we had met
> >> mostly descriptors with small id, and this approach had worked somehow.
> >>
> >> But recent time containers with inotify with big watch descriptors
> >> begun to come, and this way stopped to work at all. When descriptor id
> >> is something about 0x34d71d6, the restoring process spins in busy loop
> >> for a long time, and the restore hungs and delay of migration from node
> >> to node could easily be watched.
> >>
> >> This patch aims to solve this problem. It introduces new ioctl
> >> INOTIFY_IOC_SETNEXTWD, which allows to request the number of next created
> >> watch descriptor from userspace. It simply calls idr_set_cursor() primitive
> >> to populate idr::idr_next, so that next idr_alloc_cyclic() allocation
> >> will return this id, if it is not occupied. This is the way which is
> >> used to restore some other resources from userspace. For example,
> >> /proc/sys/kernel/ns_last_pid works the same for task pids.
> >>
> >> The new code is under CONFIG_CHECKPOINT_RESTORE #define, so small system
> >> may exclude it.
> >>
> > 
> > Reviewed-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> > 
> > With a little cleanup:
> > 
> > --- a/fs/notify/inotify/inotify_user.c~inotify-extend-ioctl-to-allow-to-request-id-of-new-watch-descriptor-fix
> > +++ a/fs/notify/inotify/inotify_user.c
> > @@ -285,7 +285,6 @@ static int inotify_release(struct inode
> >  static long inotify_ioctl(struct file *file, unsigned int cmd,
> >  			  unsigned long arg)
> >  {
> > -	struct inotify_group_private_data *data __maybe_unused;
> >  	struct fsnotify_group *group;
> >  	struct fsnotify_event *fsn_event;
> >  	void __user *p;
> > @@ -294,7 +293,6 @@ static long inotify_ioctl(struct file *f
> >  
> >  	group = file->private_data;
> >  	p = (void __user *) arg;
> > -	data = &group->inotify_data;
> >  
> >  	pr_debug("%s: group=%p cmd=%u\n", __func__, group, cmd);
> >  
> > @@ -313,6 +311,9 @@ static long inotify_ioctl(struct file *f
> >  	case INOTIFY_IOC_SETNEXTWD:
> >  		ret = -EINVAL;
> >  		if (arg >= 1 && arg <= INT_MAX) {
> > +			struct inotify_group_private_data *data;
> > +
> > +			data = &group->inotify_data;
> >  			spin_lock(&data->idr_lock);
> >  			idr_set_cursor(&data->idr, (unsigned int)arg);
> >  			spin_unlock(&data->idr_lock);
> 
> I have no objections.

Thanks guys, I have added the patch (with cleanup included) to my tree.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
