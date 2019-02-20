From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 11/19] block: implement bio helper to add iter bvec pages
 to bio
Date: Thu, 21 Feb 2019 06:58:57 +0800
Message-ID: <20190220225856.GB28313@ming.t460p>
References: <20190211190049.7888-1-axboe@kernel.dk>
 <20190211190049.7888-13-axboe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20190211190049.7888-13-axboe@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, linux-api@vger.kernel.org, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, jannh@google.com, viro@ZenIV.linux.org.uk
List-Id: linux-api@vger.kernel.org

On Mon, Feb 11, 2019 at 12:00:41PM -0700, Jens Axboe wrote:
> For an ITER_BVEC, we can just iterate the iov and add the pages
> to the bio directly. This requires that the caller doesn't releases
> the pages on IO completion, we add a BIO_NO_PAGE_REF flag for that.
> 
> The current two callers of bio_iov_iter_get_pages() are updated to
> check if they need to release pages on completion. This makes them
> work with bvecs that contain kernel mapped pages already.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  block/bio.c               | 59 ++++++++++++++++++++++++++++++++-------
>  fs/block_dev.c            |  5 ++--
>  fs/iomap.c                |  5 ++--
>  include/linux/blk_types.h |  1 +
>  4 files changed, 56 insertions(+), 14 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 4db1008309ed..330df572cfb8 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -828,6 +828,23 @@ int bio_add_page(struct bio *bio, struct page *page,
>  }
>  EXPORT_SYMBOL(bio_add_page);
>  
> +static int __bio_iov_bvec_add_pages(struct bio *bio, struct iov_iter *iter)
> +{
> +	const struct bio_vec *bv = iter->bvec;
> +	unsigned int len;
> +	size_t size;
> +
> +	len = min_t(size_t, bv->bv_len, iter->count);
> +	size = bio_add_page(bio, bv->bv_page, len,
> +				bv->bv_offset + iter->iov_offset);

iter->iov_offset needs to be subtracted from 'len', looks
the following delta change[1] is required, otherwise memory corruption
can be observed when running xfstests over loop/dio.

Another interesting thing is that bio_add_page() is capable of
adding multi contiguous pages actually, especially loop uses
ITER_BVEC to pass multi-page bvecs. Even though pages in loop's
ITER_BVEC may belong to user-space, looks it is still safe to not
grab the page ref given it has been done by fs. 

[1]
diff --git a/block/bio.c b/block/bio.c
index 3b49963676fc..df99bb3816a1 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -842,7 +842,10 @@ static int __bio_iov_bvec_add_pages(struct bio *bio, struct iov_iter *iter)
 	unsigned int len;
 	size_t size;
 
-	len = min_t(size_t, bv->bv_len, iter->count);
+	if (WARN_ON_ONCE(iter->iov_offset > bv->bv_len))
+		return -EINVAL;
+
+	len = min_t(size_t, bv->bv_len - iter->iov_offset, iter->count);
 	size = bio_add_page(bio, bv->bv_page, len,
 				bv->bv_offset + iter->iov_offset);
 	if (size == len) {

Thanks,
Ming

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
