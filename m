From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2] fanotify: don't expose EOPENSTALE to userspace
Date: Tue, 25 Apr 2017 15:57:08 +0200
Message-ID: <20170425135708.GA8319@quack2.suse.cz>
References: <1493119775-4558-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1493119775-4558-1-git-send-email-amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Marko Rauhamaa <marko.rauhamaa-xdZvthzU1HpWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Trond Myklebust <trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, "J . Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue 25-04-17 14:29:35, Amir Goldstein wrote:
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
> Reported-by: Marko Rauhamaa <marko.rauhamaa-xdZvthzU1HpWk0Htik3J/w@public.gmane.org>
> Tested-by: Marko Rauhamaa <marko.rauhamaa-xdZvthzU1HpWk0Htik3J/w@public.gmane.org>
> Cc: <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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

Thanks! I've merged the patch to my tree and will push it to Linus during
the merge window.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
