From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 6/7] blk-mq: enable polling support by default
Date: Fri, 26 Feb 2016 15:44:30 -0500
Message-ID: <x49fuwfmcb5.fsf@segfault.boston.devel.redhat.com>
References: <1456160876-14560-1-git-send-email-hch@lst.de>
	<1456160876-14560-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456160876-14560-7-git-send-email-hch-jcswGhMUV9g@public.gmane.org> (Christoph
	Hellwig's message of "Mon, 22 Feb 2016 18:07:55 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi, Christoph,

Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> writes:

> Now that applications need to explicitly ask for polling we can enable it
> by default in blk-mq drivers.

I don't think this is a good idea.  I'd just enable it in nvme and the
micron driver for now.

Cheers,
Jeff

>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  include/linux/blkdev.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 4571ef1..458f6ef 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -499,7 +499,8 @@ struct request_queue {
>  
>  #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
>  				 (1 << QUEUE_FLAG_STACKABLE)	|	\
> -				 (1 << QUEUE_FLAG_SAME_COMP))
> +				 (1 << QUEUE_FLAG_SAME_COMP)	|	\
> +				 (1 << QUEUE_FLAG_POLL))
>  
>  static inline void queue_lockdep_assert_held(struct request_queue *q)
>  {
