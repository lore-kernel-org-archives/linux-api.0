From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
Date: Wed, 19 Apr 2017 10:21:39 -0500
Message-ID: <d3467259-675a-2723-7cf9-d4f2f067d634@suse.de>
References: <20170414120257.8932-1-rgoldwyn@suse.de>
 <20170414120257.8932-6-rgoldwyn@suse.de>
 <20170419064505.GD20053@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170419064505.GD20053@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-api@vger.kernel.org



On 04/19/2017 01:45 AM, Christoph Hellwig wrote:
> 
>> +	if (bio->bi_opf & REQ_NOWAIT) {
>> +		if (!blk_queue_nowait(q)) {
>> +			err = -EOPNOTSUPP;
>> +			goto end_io;
>> +		}
>> +		if (!(bio->bi_opf & REQ_SYNC)) {
> 
> I don't understand this check at all..

It is to ensure at the block layer that NOWAIT comes only for DIRECT
calls only. I should probably change it to REQ_SYNC | REQ_IDLE.

> 
>> +			if (unlikely(!blk_queue_dying(q) && (bio->bi_opf & REQ_NOWAIT)))
> 
> Please break lines after 80 characters.
> 
>> @@ -119,6 +119,9 @@ struct request *blk_mq_sched_get_request(struct request_queue *q,
>>  	if (likely(!data->hctx))
>>  		data->hctx = blk_mq_map_queue(q, data->ctx->cpu);
>>  
>> +	if (bio && (bio->bi_opf & REQ_NOWAIT))
>> +		data->flags |= BLK_MQ_REQ_NOWAIT;
> 
> Check the op flag again here.
> 
>> +++ b/block/blk-mq.c
>> @@ -1538,6 +1538,8 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
>>  	rq = blk_mq_sched_get_request(q, bio, bio->bi_opf, &data);
>>  	if (unlikely(!rq)) {
>>  		__wbt_done(q->rq_wb, wb_acct);
>> +		if (bio && (bio->bi_opf & REQ_NOWAIT))
>> +			bio_wouldblock_error(bio);
> 
> bio iѕ dereferences unconditionally above, so you can do the same.
> 
>> @@ -1662,6 +1664,8 @@ static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
>>  	rq = blk_mq_sched_get_request(q, bio, bio->bi_opf, &data);
>>  	if (unlikely(!rq)) {
>>  		__wbt_done(q->rq_wb, wb_acct);
>> +		if (bio && (bio->bi_opf & REQ_NOWAIT))
>> +			bio_wouldblock_error(bio);
> 
> Same here.  Although blk_sq_make_request is gone anyway in the current
> block tree..
> 
>> +	/* Request queue supports BIO_NOWAIT */
>> +	queue_flag_set_unlocked(QUEUE_FLAG_NOWAIT, q);
> 
> BIO_NOWAIT is gone.  And the comment would not be needed if the
> flag had a more descriptive name, e.g. QUEUE_FLAG_NOWAIT_SUPPORT.
> 
> And I think all request based drivers should set the flag implicitly
> as ->queuecommand can't sleep, and ->queue_rq only when it's always
> offloaded to a workqueue when the BLK_MQ_F_BLOCKING flag is set.
> 

Yes, Do we have a central point (like a probe() function call?) where
this can be done?


-- 
Goldwyn
