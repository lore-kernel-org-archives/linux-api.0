From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] nowait aio: return on congested block device
Date: Wed, 12 Apr 2017 01:36:25 -0700
Message-ID: <20170412083625.GB22363@infradead.org>
References: <20170411142619.27205-1-rgoldwyn@suse.de>
 <20170411142619.27205-6-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170411142619.27205-6-rgoldwyn@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-api@vger.kernel.org

As mentioned last time around, this should be a REQ_NOWAIT flag so
that it can be easily passed down to the request layer.

> +static inline void bio_wouldblock_error(struct bio *bio)
> +{
> +	bio->bi_error = -EAGAIN;
> +	bio_endio(bio);
> +}

Please skip this helper..

> +#define QUEUE_FLAG_NOWAIT      28	/* queue supports BIO_NOWAIT */

Please make the flag name a little more descriptive, this sounds like
it will never wait.
