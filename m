From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 5/9] nowait aio: return on congested block device
Date: Wed, 12 Apr 2017 13:31:43 -0500
Message-ID: <7fba3538-8c91-20e5-63f1-6e063caaaffb@suse.de>
References: <20170411142619.27205-1-rgoldwyn@suse.de>
 <20170411142619.27205-6-rgoldwyn@suse.de>
 <20170412083625.GB22363@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170412083625.GB22363@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-api@vger.kernel.org



On 04/12/2017 03:36 AM, Christoph Hellwig wrote:
> As mentioned last time around, this should be a REQ_NOWAIT flag so
> that it can be easily passed dow? n to the request layer.
> 
>> +static inline void bio_wouldblock_error(struct bio *bio)
>> +{
>> +	bio->bi_error = -EAGAIN;
>> +	bio_endio(bio);
>> +}
> 
> Please skip this helper..

Why? It is being called three times?
I am incorporating all the rest of the comments, besides this one. Thanks.

> 
>> +#define QUEUE_FLAG_NOWAIT      28	/* queue supports BIO_NOWAIT */
> 
> Please make the flag name a little more descriptive, this sounds like
> it will never wait.
> 

-- 
Goldwyn
