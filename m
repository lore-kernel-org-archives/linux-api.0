From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fanotify: Make wait for permission events interruptible
Date: Mon, 15 Apr 2019 11:59:07 +0200
Message-ID: <20190415095907.GA14466@quack2.suse.cz>
References: <20190321151142.17104-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190321151142.17104-1-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: Orion Poplawski <orion@nwra.com>, Vivek Trivedi <t.vivek@samsung.com>, Amir Goldstein <amir73il@gmail.com>, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Jan Kara <jack@suse.cz>
List-Id: linux-api@vger.kernel.org

On Thu 21-03-19 16:11:42, Jan Kara wrote:
> Switch waiting for response to fanotify permission events interruptible.
> This allows e.g. the system to be suspended while there are some
> fanotify permission events pending (which is reportedly pretty common
> when for example AV solution is in use). However just making the wait
> interruptible can result in e.g. open(2) returning -EINTR where
> previously such error code never happened in practice. To avoid
> confusion of userspace due to this error code, return -ERESTARTNOINTR
> instead.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/notify/fanotify/fanotify.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> Orion, can you give this patch some testing with your usecase? Also if anybody
> sees any issue with returning -ERESTARTNOINTR I have missed, please speak up.

Ping Orion? Did you have any chance to give this patch a try? Does it fix
hibernation issues you observe without causing issues with bash and other
programs? I'd like to queue this patch for the coming merge window but
I'd like to see some testing results showing that it actually helps
anything... Thanks!

								Honza

> 
> diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
> index 6b9c27548997..eb790853844b 100644
> --- a/fs/notify/fanotify/fanotify.c
> +++ b/fs/notify/fanotify/fanotify.c
> @@ -92,10 +92,17 @@ static int fanotify_get_response(struct fsnotify_group *group,
>  
>  	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
>  
> -	ret = wait_event_killable(group->fanotify_data.access_waitq,
> -				  event->state == FAN_EVENT_ANSWERED);
> +	ret = wait_event_interruptible(group->fanotify_data.access_waitq,
> +				       event->state == FAN_EVENT_ANSWERED);
>  	/* Signal pending? */
>  	if (ret < 0) {
> +		/*
> +		 * Force restarting a syscall so that this is mostly invisible
> +		 * for userspace which is not prepared for handling EINTR e.g.
> +		 * from open(2).
> +		 */
> +		if (ret == -ERESTARTSYS)
> +			ret = -ERESTARTNOINTR;
>  		spin_lock(&group->notification_lock);
>  		/* Event reported to userspace and no answer yet? */
>  		if (event->state == FAN_EVENT_REPORTED) {
> -- 
> 2.16.4
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
