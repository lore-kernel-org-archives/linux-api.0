From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RFC] introduce ioctl to completely invalidate page cache
Date: Thu, 02 Oct 2014 13:59:40 -0600
Message-ID: <542DAEAC.8010203@kernel.dk>
References: <1412266184-23776-1-git-send-email-thanos.makatos@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1412266184-23776-1-git-send-email-thanos.makatos@citrix.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Thanos Makatos <thanos.makatos@citrix.com>, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, jlayton@poochiereds.net, bfields@fieldses.org, jack@suse.cz
List-Id: linux-api@vger.kernel.org

On 10/02/2014 10:09 AM, Thanos Makatos wrote:
> This patch introduces a new ioctl called BLKFLUSHBUFS2, which is pretty
> similar to BLKFLUSHBUFS except that is also invalidates the page cache.
> This allows for a complete invalidation of the cached data of a
> particular block device, which might be useful for cases like
> synchronising the caches of an iSCSI block device used by multiple
> hosts.
> 
> Signed-off-by: Thanos Makatos <thanos.makatos@citrix.com>
> ---
>  block/compat_ioctl.c    |    1 +
>  block/ioctl.c           |   13 +++++++++++--
>  include/uapi/linux/fs.h |    1 +
>  3 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
> index 18b282c..672388ab 100644
> --- a/block/compat_ioctl.c
> +++ b/block/compat_ioctl.c
> @@ -688,6 +688,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
>  	case BLKDISCARDZEROES:
>  		return compat_put_uint(arg, bdev_discard_zeroes_data(bdev));
>  	case BLKFLSBUF:
> +	case BLKFLSBUF2:
>  	case BLKROSET:
>  	case BLKDISCARD:
>  	case BLKSECDISCARD:
> diff --git a/block/ioctl.c b/block/ioctl.c
> index d6cda81..0c427a7 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -268,6 +268,12 @@ static inline int is_unrecognized_ioctl(int ret)
>  		ret == -ENOIOCTLCMD;
>  }
>  
> +static void flush_buffer_cache(struct block_device *bdev)
> +{
> +	fsync_bdev(bdev);
> +	invalidate_bdev(bdev);
> +}
> +
>  /*
>   * always keep this in sync with compat_blkdev_ioctl()
>   */
> @@ -282,6 +288,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
>  
>  	switch(cmd) {
>  	case BLKFLSBUF:
> +	case BLKFLSBUF2:
>  		if (!capable(CAP_SYS_ADMIN))
>  			return -EACCES;
>  
> @@ -289,8 +296,10 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
>  		if (!is_unrecognized_ioctl(ret))
>  			return ret;
>  
> -		fsync_bdev(bdev);
> -		invalidate_bdev(bdev);
> +		flush_buffer_cache(bdev);
> +		if (BLKFLSBUF2 == cmd)
> +			return invalidate_inode_pages2(
> +					bdev->bd_inode->i_mapping);
>  		return 0;

We're currently ignoring the buffer cache sync and invalidation (which
is odd), but at least being consistent would be good.

Might also need a filemap_write_and_wait() to sync before invalidation.

-- 
Jens Axboe

