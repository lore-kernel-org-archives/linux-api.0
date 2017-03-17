From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 5/8] nowait aio: return on congested block device
Date: Fri, 17 Mar 2017 10:03:18 +0800
Message-ID: <CACVXFVMTxxRM==3ton-=LmDHYKpBu2Sh59hs_gyvFCUtnQwjVQ@mail.gmail.com>
References: <20170315215107.5628-1-rgoldwyn@suse.de> <20170315215107.5628-6-rgoldwyn@suse.de>
 <eee4683d-9f44-434f-b97f-b0b24c7b3dab@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <eee4683d-9f44-434f-b97f-b0b24c7b3dab@kernel.dk>
Sender: linux-btrfs-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.com>, Christoph Hellwig <hch@infradead.org>, linux-block <linux-block@vger.kernel.org>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>, "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>, "open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>, Sagi Grimberg <sagi@grimberg.me>, avi@scylladb.com, linux-api@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 16, 2017 at 10:33 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 03/15/2017 03:51 PM, Goldwyn Rodrigues wrote:
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 0eeb99e..2e5cba2 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -2014,7 +2019,7 @@ blk_qc_t generic_make_request(struct bio *bio)
>>       do {
>>               struct request_queue *q = bdev_get_queue(bio->bi_bdev);
>>
>> -             if (likely(blk_queue_enter(q, false) == 0)) {
>> +             if (likely(blk_queue_enter(q, bio_flagged(bio, BIO_NOWAIT)) == 0)) {
>>                       struct bio_list hold;
>>                       struct bio_list lower, same;
>>
>> @@ -2040,7 +2045,10 @@ blk_qc_t generic_make_request(struct bio *bio)
>>                       bio_list_merge(&bio_list_on_stack, &same);
>>                       bio_list_merge(&bio_list_on_stack, &hold);
>>               } else {
>> -                     bio_io_error(bio);
>> +                     if (unlikely(bio_flagged(bio, BIO_NOWAIT)))
>> +                             bio_wouldblock_error(bio);
>> +                     else
>> +                             bio_io_error(bio);
>
> This doesn't look right. What if the queue is dying, and BIO_NOWAIT just
> happened to be set?
>
> And you're missing wbt_wait() as well as a blocking point. Ditto in
> blk-mq.

There are also tons of block points in dm/md/bcache, which need to be
considered or be documented at least, :-)



Thanks,
Ming Lei
