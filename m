From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/19] block: implement bio helper to add iter bvec pages
 to bio
Date: Sat, 9 Feb 2019 10:45:15 +0100
Message-ID: <837729ed-38ff-c3ef-f0de-01e488b28b57@suse.de>
References: <20190208173423.27014-1-axboe@kernel.dk>
 <20190208173423.27014-12-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20190208173423.27014-12-axboe@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org
Cc: hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 2/8/19 6:34 PM, Jens Axboe wrote:
> For an ITER_BVEC, we can just iterate the iov and add the pages
> to the bio directly. This requires that the caller doesn't releases
> the pages on IO completion, we add a BIO_NO_PAGE_REF flag for that.
> 
> The current two callers of bio_iov_iter_get_pages() are updated to
> check if they need to release pages on completion. This makes them
> work with bvecs that contain kernel mapped pages already.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   block/bio.c               | 59 ++++++++++++++++++++++++++++++++-------
>   fs/block_dev.c            |  5 ++--
>   fs/iomap.c                |  5 ++--
>   include/linux/blk_types.h |  1 +
>   4 files changed, 56 insertions(+), 14 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes


--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
