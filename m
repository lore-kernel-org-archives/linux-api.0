From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC PATCH] fs: fsnotify: account fsnotify metadata to kmemcg
Date: Tue, 31 Oct 2017 11:50:30 +0100
Message-ID: <20171031105030.GE8989@quack2.suse.cz>
References: <1508448056-21779-1-git-send-email-yang.s@alibaba-inc.com>
 <CAOQ4uxhPhXrMLu18TGKDA=ezUVHara95qJQ+BTCio8BHm-u6NA@mail.gmail.com>
 <b530521e-5215-f735-444a-13f722d90e40@alibaba-inc.com>
 <CAOQ4uxhFOoSknnG-0Jyv+=iCDjVNnAg6SiO-msxw4tORkVKJGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhFOoSknnG-0Jyv+=iCDjVNnAg6SiO-msxw4tORkVKJGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yang Shi <yang.s-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun 22-10-17 11:24:17, Amir Goldstein wrote:
> But I think there is another problem, not introduced by your change, but could
> be amplified because of it - when a non-permission event allocation fails, the
> event is silently dropped, AFAICT, with no indication to listener.
> That seems like a bug to me, because there is a perfectly safe way to deal with
> event allocation failure - queue the overflow event.
> 
> I am not going to be the one to determine if fixing this alleged bug is a
> prerequisite for merging your patch, but I think enforcing memory limits on
> event allocation could amplify that bug, so it should be fixed.
> 
> The upside is that with both your accounting fix and ENOMEM = overlflow
> fix, it going to be easy to write a test that verifies both of them:
> - Run a listener in memcg with limited kmem and unlimited (or very
> large) event queue
> - Produce events inside memcg without listener reading them
> - Read event and expect an OVERFLOW event
> 
> This is a simple variant of LTP tests inotify05 and fanotify05.
> 
> I realize that is user application behavior change and that documentation
> implies that an OVERFLOW event is not expected when using
> FAN_UNLIMITED_QUEUE, but IMO no one will come shouting
> if we stop silently dropping events, so it is better to fix this and update
> documentation.
> 
> Attached a compile-tested patch to implement overflow on ENOMEM
> Hope this helps to test your patch and then we can merge both, accompanied
> with LTP tests for inotify and fanotify.
> 
> Amir.

> From 112ecd54045f14aff2c42622fabb4ffab9f0d8ff Mon Sep 17 00:00:00 2001
> From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Sun, 22 Oct 2017 11:13:10 +0300
> Subject: [PATCH] fsnotify: queue an overflow event on failure to allocate
>  event
> 
> In low memory situations, non permissions events are silently dropped.
> It is better to queue an OVERFLOW event in that case to let the listener
> know about the lost event.
> 
> With this change, an application can now get an FAN_Q_OVERFLOW event,
> even if it used flag FAN_UNLIMITED_QUEUE on fanotify_init().
> 
> Signed-off-by: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

So I agree something like this is desirable but I'm uneasy about using
{IN|FAN}_Q_OVERFLOW for this. Firstly, it is userspace visible change for
FAN_UNLIMITED_QUEUE queues which could confuse applications as you properly
note. Secondly, the event is similar to queue overflow but not quite the
same (it is not that the application would be too slow in processing
events, it is just that the system is in a problematic state overall). What
are your thoughts on adding a new event flags like FAN_Q_LOSTEVENT or
something like that? Probably the biggest downside there I see is that apps
would have to learn to use it...

								Honza

> ---
>  fs/notify/fanotify/fanotify.c        | 10 ++++++++--
>  fs/notify/inotify/inotify_fsnotify.c |  8 ++++++--
>  fs/notify/notification.c             |  3 ++-
>  3 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
> index 2fa99aeaa095..412a32838f58 100644
> --- a/fs/notify/fanotify/fanotify.c
> +++ b/fs/notify/fanotify/fanotify.c
> @@ -212,8 +212,14 @@ static int fanotify_handle_event(struct fsnotify_group *group,
>  		 mask);
>  
>  	event = fanotify_alloc_event(inode, mask, data);
> -	if (unlikely(!event))
> -		return -ENOMEM;
> +	if (unlikely(!event)) {
> +		if (mask & FAN_ALL_PERM_EVENTS)
> +			return -ENOMEM;
> +
> +		/* Queue an overflow event on failure to allocate event */
> +		fsnotify_add_event(group, group->overflow_event, NULL);
> +		return 0;
> +	}
>  
>  	fsn_event = &event->fse;
>  	ret = fsnotify_add_event(group, fsn_event, fanotify_merge);
> diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
> index 8b73332735ba..d1837da2ef15 100644
> --- a/fs/notify/inotify/inotify_fsnotify.c
> +++ b/fs/notify/inotify/inotify_fsnotify.c
> @@ -99,8 +99,11 @@ int inotify_handle_event(struct fsnotify_group *group,
>  			      fsn_mark);
>  
>  	event = kmalloc(alloc_len, GFP_KERNEL);
> -	if (unlikely(!event))
> -		return -ENOMEM;
> +	if (unlikely(!event)) {
> +		/* Queue an overflow event on failure to allocate event */
> +		fsnotify_add_event(group, group->overflow_event, NULL);
> +		goto oneshot;
> +	}
>  
>  	fsn_event = &event->fse;
>  	fsnotify_init_event(fsn_event, inode, mask);
> @@ -116,6 +119,7 @@ int inotify_handle_event(struct fsnotify_group *group,
>  		fsnotify_destroy_event(group, fsn_event);
>  	}
>  
> +oneshot:
>  	if (inode_mark->mask & IN_ONESHOT)
>  		fsnotify_destroy_mark(inode_mark, group);
>  
> diff --git a/fs/notify/notification.c b/fs/notify/notification.c
> index 66f85c651c52..5abd69976a47 100644
> --- a/fs/notify/notification.c
> +++ b/fs/notify/notification.c
> @@ -111,7 +111,8 @@ int fsnotify_add_event(struct fsnotify_group *group,
>  		return 2;
>  	}
>  
> -	if (group->q_len >= group->max_events) {
> +	if (group->q_len >= group->max_events ||
> +	    event == group->overflow_event) {
>  		ret = 2;
>  		/* Queue overflow event only if it isn't already queued */
>  		if (!list_empty(&group->overflow_event->list)) {
> -- 
> 2.7.4
> 

-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
