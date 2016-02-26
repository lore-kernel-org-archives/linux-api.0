From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/7] direct-io: only use block polling if explicitly requested
Date: Fri, 26 Feb 2016 16:58:28 -0500
Message-ID: <x49k2lrkubf.fsf@segfault.boston.devel.redhat.com>
References: <1456160876-14560-1-git-send-email-hch@lst.de>
	<1456160876-14560-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456160876-14560-6-git-send-email-hch-jcswGhMUV9g@public.gmane.org> (Christoph
	Hellwig's message of "Mon, 22 Feb 2016 18:07:54 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> writes:

> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Reviewed-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> ---
>  fs/direct-io.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index d6a9012..0a8d937 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -445,7 +445,8 @@ static struct bio *dio_await_one(struct dio *dio)
>  		__set_current_state(TASK_UNINTERRUPTIBLE);
>  		dio->waiter = current;
>  		spin_unlock_irqrestore(&dio->bio_lock, flags);
> -		if (!blk_poll(bdev_get_queue(dio->bio_bdev), dio->bio_cookie))
> +		if (!(dio->iocb->ki_flags & IOCB_HIPRI) ||
> +		    !blk_poll(bdev_get_queue(dio->bio_bdev), dio->bio_cookie))
>  			io_schedule();
>  		/* wake up sets us TASK_RUNNING */
>  		spin_lock_irqsave(&dio->bio_lock, flags);
