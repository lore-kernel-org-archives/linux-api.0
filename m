From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
Date: Thu, 16 Mar 2017 08:33:38 -0600
Message-ID: <eee4683d-9f44-434f-b97f-b0b24c7b3dab@kernel.dk>
References: <20170315215107.5628-1-rgoldwyn@suse.de>
 <20170315215107.5628-6-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170315215107.5628-6-rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jack-IBi9RG/b67k@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 03/15/2017 03:51 PM, Goldwyn Rodrigues wrote:
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 0eeb99e..2e5cba2 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2014,7 +2019,7 @@ blk_qc_t generic_make_request(struct bio *bio)
>  	do {
>  		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
>  
> -		if (likely(blk_queue_enter(q, false) == 0)) {
> +		if (likely(blk_queue_enter(q, bio_flagged(bio, BIO_NOWAIT)) == 0)) {
>  			struct bio_list hold;
>  			struct bio_list lower, same;
>  
> @@ -2040,7 +2045,10 @@ blk_qc_t generic_make_request(struct bio *bio)
>  			bio_list_merge(&bio_list_on_stack, &same);
>  			bio_list_merge(&bio_list_on_stack, &hold);
>  		} else {
> -			bio_io_error(bio);
> +			if (unlikely(bio_flagged(bio, BIO_NOWAIT)))
> +				bio_wouldblock_error(bio);
> +			else
> +				bio_io_error(bio);

This doesn't look right. What if the queue is dying, and BIO_NOWAIT just
happened to be set?

And you're missing wbt_wait() as well as a blocking point. Ditto in
blk-mq.

> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 159187a..942ce8c 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1518,6 +1518,8 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
>  	rq = blk_mq_sched_get_request(q, bio, bio->bi_opf, &data);
>  	if (unlikely(!rq)) {
>  		__wbt_done(q->rq_wb, wb_acct);
> +		if (bio && bio_flagged(bio, BIO_NOWAIT))
> +			bio_wouldblock_error(bio);
>  		return BLK_QC_T_NONE;
>  	}
>  

This seems a little fragile now, since not both paths free the bio.

-- 
Jens Axboe
