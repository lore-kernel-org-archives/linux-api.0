From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 11/19] block: implement bio helper to add iter bvec pages
 to bio
Date: Thu, 21 Feb 2019 10:45:27 -0700
Message-ID: <b143e8c3-33d5-5f09-c441-98b3bf326d81@kernel.dk>
References: <20190211190049.7888-1-axboe@kernel.dk>
 <20190211190049.7888-13-axboe@kernel.dk> <20190220225856.GB28313@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190220225856.GB28313@ming.t460p>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/20/19 3:58 PM, Ming Lei wrote:
> On Mon, Feb 11, 2019 at 12:00:41PM -0700, Jens Axboe wrote:
>> For an ITER_BVEC, we can just iterate the iov and add the pages
>> to the bio directly. This requires that the caller doesn't releases
>> the pages on IO completion, we add a BIO_NO_PAGE_REF flag for that.
>>
>> The current two callers of bio_iov_iter_get_pages() are updated to
>> check if they need to release pages on completion. This makes them
>> work with bvecs that contain kernel mapped pages already.
>>
>> Reviewed-by: Hannes Reinecke <hare@suse.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  block/bio.c               | 59 ++++++++++++++++++++++++++++++++-------
>>  fs/block_dev.c            |  5 ++--
>>  fs/iomap.c                |  5 ++--
>>  include/linux/blk_types.h |  1 +
>>  4 files changed, 56 insertions(+), 14 deletions(-)
>>
>> diff --git a/block/bio.c b/block/bio.c
>> index 4db1008309ed..330df572cfb8 100644
>> --- a/block/bio.c
>> +++ b/block/bio.c
>> @@ -828,6 +828,23 @@ int bio_add_page(struct bio *bio, struct page *page,
>>  }
>>  EXPORT_SYMBOL(bio_add_page);
>>  
>> +static int __bio_iov_bvec_add_pages(struct bio *bio, struct iov_iter *iter)
>> +{
>> +	const struct bio_vec *bv = iter->bvec;
>> +	unsigned int len;
>> +	size_t size;
>> +
>> +	len = min_t(size_t, bv->bv_len, iter->count);
>> +	size = bio_add_page(bio, bv->bv_page, len,
>> +				bv->bv_offset + iter->iov_offset);
> 
> iter->iov_offset needs to be subtracted from 'len', looks
> the following delta change[1] is required, otherwise memory corruption
> can be observed when running xfstests over loop/dio.

Thanks, I folded this in.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
