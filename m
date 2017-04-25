From: "J . Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH v2] fanotify: don't expose EOPENSTALE to userspace
Date: Tue, 25 Apr 2017 09:42:30 -0400
Message-ID: <20170425134230.GE30046@fieldses.org>
References: <1493119775-4558-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1493119775-4558-1-git-send-email-amir73il@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Marko Rauhamaa <marko.rauhamaa@f-secure.com>, Al Viro <viro@zeniv.linux.org.uk>, Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 25, 2017 at 02:29:35PM +0300, Amir Goldstein wrote:
> When delivering an event to userspace for a file on an NFS share,
> if the file is deleted on server side before user reads the event,
> user will not get the event.
> 
> If the event queue contained several events, the stale event is
> quietly dropped and read() returns to user with events read so far
> in the buffer.
> 
> If the event queue contains a single stale event or if the stale
> event is a permission event, read() returns to user with the kernel
> internal error code 518 (EOPENSTALE), which is not a POSIX error code.
> 
> Check the internal return value -EOPENSTALE in fanotify_read(), just
> the same as it is checked in path_openat() and drop the event in the
> cases that it is not already dropped.

Makes sense to me.

Of course we can't prevent the case where a file's deleted on the server
after the read but before the application uses the event, so the
application could see ESTALE on a later operation; but that's not the
case you're talking about here.

--b.

> 
> This is a reproducer from Marko Rauhamaa:
> 
> Just take the example program listed under "man fanotify" ("fantest")
> and follow these steps:
> 
>     ==============================================================
>     NFS Server    NFS Client(1)     NFS Client(2)
>     ==============================================================
>     # echo foo >/nfsshare/bar.txt
>                   # cat /nfsshare/bar.txt
>                   foo
>                                     # ./fantest /nfsshare
>                                     Press enter key to terminate.
>                                     Listening for events.
>     # rm -f /nfsshare/bar.txt
>                   # cat /nfsshare/bar.txt
>                                     read: Unknown error 518
>                   cat: /nfsshare/bar.txt: Operation not permitted
>     ==============================================================
> 
> where NFS Client (1) and (2) are two terminal sessions on a single NFS
> Client machine.
> 
> Reported-by: Marko Rauhamaa <marko.rauhamaa@f-secure.com>
> Tested-by: Marko Rauhamaa <marko.rauhamaa@f-secure.com>
> Cc: <linux-api@vger.kernel.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/notify/fanotify/fanotify_user.c | 26 ++++++++++++++++++--------
>  1 file changed, 18 insertions(+), 8 deletions(-)
> 
> Jan,
> 
> This is v2 patch that was tested by Marko.
> It includes your fix to my v1 patch.
> 
> Marko tested both blocking and non-blocking fanotify fd.
> I did not test with stale NFS files myself, but I did test by emulating
> stale NFS files with orphan files, using this test patch to create_fd():
> 
>                 put_unused_fd(client_fd);
>                 client_fd = PTR_ERR(new_file);
> >       } else if (!event->path.dentry->d_inode ||
> >                  !event->path.dentry->d_inode->i_nlink) {
> >               put_unused_fd(client_fd);
> >               fput(new_file);
> >               return -EOPENSTALE;
>         } else {
>                 *file = new_file;
>         }
> 
> I CC'ed linux-api in case Michael would want to add a BUGS note on this
> and CC'ed stable because we should consider patching this bug in older
> kernels. After all, Marko discovered this bug in a RHEL kernel.
> 
> Thanks,
> Amir.
> 
> 
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 2b37f27..4b3437d 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -295,27 +295,37 @@ static ssize_t fanotify_read(struct file *file, char __user *buf,
>  		}
>  
>  		ret = copy_event_to_user(group, kevent, buf);
> +		if (unlikely(ret == -EOPENSTALE)) {
> +			/*
> +			 * We cannot report events with stale fd so drop it.
> +			 * Setting ret to 0 will continue the event loop and
> +			 * do the right thing if there are no more events to
> +			 * read (i.e. return bytes read, -EAGAIN or wait).
> +			 */
> +			ret = 0;
> +		}
> +
>  		/*
>  		 * Permission events get queued to wait for response.  Other
>  		 * events can be destroyed now.
>  		 */
>  		if (!(kevent->mask & FAN_ALL_PERM_EVENTS)) {
>  			fsnotify_destroy_event(group, kevent);
> -			if (ret < 0)
> -				break;
>  		} else {
>  #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
> -			if (ret < 0) {
> +			if (ret <= 0) {
>  				FANOTIFY_PE(kevent)->response = FAN_DENY;
>  				wake_up(&group->fanotify_data.access_waitq);
> -				break;
> +			} else {
> +				spin_lock(&group->notification_lock);
> +				list_add_tail(&kevent->list,
> +					&group->fanotify_data.access_list);
> +				spin_unlock(&group->notification_lock);
>  			}
> -			spin_lock(&group->notification_lock);
> -			list_add_tail(&kevent->list,
> -				      &group->fanotify_data.access_list);
> -			spin_unlock(&group->notification_lock);
>  #endif
>  		}
> +		if (ret < 0)
> +			break;
>  		buf += ret;
>  		count -= ret;
>  	}
> -- 
> 2.7.4
