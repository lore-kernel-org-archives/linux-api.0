From: "Michael Kerrisk" <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [take 3] Use pid in inotify events.
Date: Mon, 17 Nov 2008 11:59:11 -0500
Message-ID: <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com>
	 <20081116232450.GA13547@ioremap.net>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081116232450.GA13547-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Cc: Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Evgeniy,

On Sun, Nov 16, 2008 at 6:24 PM, Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org> wrote:
> Hi.
>
> This patch allows to send IO origin PID in inotify events (using cookie
> fields for all events except moving, where it is already used to track
> move from and move to parts) when its uid matches inotify owner uid or
> when inotify owner has admin (CAP_SYS_ADMIN) capabilities (Jeff
> Schroeder's idea).
>
> This is a resend of the previous patch, which was not commented by
> anyone. Does it mean no one objects? If so, please apply.

NAK.  If we are going to do this -- and I leave the security
discussions to others more knowlegeable on that score than me -- then
the API design should be better than this.  The current design is a
hack.  Why exclude rename events?  Why re-use the cookie field?  The
only answers I can guess at are that the current patch is less work to
write.  IMO, there are (much) better design possibilities, using
inotify1(), as I suggested earlier in this thread.

Thanks,

Michael

> Also removed John McCutchan's email, which bounces.
>
> Signed-off-by: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
>
> diff --git a/fs/inotify.c b/fs/inotify.c
> index 690e725..835259d 100644
> --- a/fs/inotify.c
> +++ b/fs/inotify.c
> @@ -69,6 +69,9 @@ static atomic_t inotify_cookie;
>  * inotify_add_watch() to the final put_inotify_watch().
>  */
>
> +#define IH_FLAGS_ADMIN         (0x00000001)
> +/* handler owner has admin capabilities */
> +
>  /*
>  * struct inotify_handle - represents an inotify instance
>  *
> @@ -80,6 +83,8 @@ struct inotify_handle {
>        struct list_head        watches;        /* list of watches */
>        atomic_t                count;          /* reference count */
>        u32                     last_wd;        /* the last wd allocated */
> +       uid_t                   uid;            /* owner's uid */
> +       u32                     flags;          /* operation flags */
>        const struct inotify_operations *in_ops; /* inotify caller operations */
>  };
>
> @@ -292,6 +297,11 @@ void inotify_inode_queue_event(struct inode *inode, u32 mask, u32 cookie,
>                        mutex_lock(&ih->mutex);
>                        if (watch_mask & IN_ONESHOT)
>                                remove_watch_no_event(watch, ih);
> +
> +                       if (!cookie && ((ih->flags & IH_FLAGS_ADMIN) ||
> +                                       (current->uid == ih->uid)))
> +                               cookie = task_tgid_vnr(current);
> +
>                        ih->in_ops->handle_event(watch, watch->wd, mask, cookie,
>                                                 name, n_inode);
>                        mutex_unlock(&ih->mutex);
> @@ -459,6 +469,10 @@ struct inotify_handle *inotify_init(const struct inotify_operations *ops)
>        mutex_init(&ih->mutex);
>        ih->last_wd = 0;
>        ih->in_ops = ops;
> +       ih->uid = current->user->uid;
> +       ih->flags = 0;
> +       if (capable(CAP_SYS_ADMIN))
> +               ih->flags |= IH_FLAGS_ADMIN;
>        atomic_set(&ih->count, 0);
>        get_inotify_handle(ih);
>
> --
>        Evgeniy Polyakov
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
