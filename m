From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RESEND] [PATCH] block: create ioctl to discard-or-zeroout a
 range of blocks
Date: Fri, 13 Feb 2015 00:51:19 -0800
Message-ID: <20150213085119.GB11034@birch.djwong.org>
References: <20150129020025.GE9981@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150129020025.GE9981@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>
List-Id: linux-api@vger.kernel.org

So, uh, it's been a couple of weeks...

Jens: Any comments?  Nobody's objected to either the function or the interface;
can this go in -next?

--D

On Wed, Jan 28, 2015 at 06:00:25PM -0800, Darrick J. Wong wrote:
> Create a new ioctl to expose the block layer's newfound ability to
> issue either a zeroing discard, a WRITE SAME with a zero page, or a
> regular write with the zero page.  This BLKZEROOUT2 ioctl takes
> {start, length, flags} as parameters.  So far, the only flag available
> is to enable the zeroing discard part -- without it, the call invokes
> the old BLKZEROOUT behavior.  start and length have the same meaning
> as in BLKZEROOUT.
> 
> Furthermore, because BLKZEROOUT2 issues commands directly to the
> storage device, we must invalidate the page cache (as a regular
> O_DIRECT write would do) to avoid returning stale cache contents at a
> later time.
> 
> This patch depends on "block: Add discard flag to
> blkdev_issue_zeroout() function" in Jens' for-3.20/core branch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  block/ioctl.c           |   45 ++++++++++++++++++++++++++++++++++++++-------
>  include/uapi/linux/fs.h |    7 +++++++
>  2 files changed, 45 insertions(+), 7 deletions(-)
> 
> diff --git a/block/ioctl.c b/block/ioctl.c
> index 7d8befd..ff623d5 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -186,19 +186,39 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
>  }
>  
>  static int blk_ioctl_zeroout(struct block_device *bdev, uint64_t start,
> -			     uint64_t len)
> +			     uint64_t len, uint32_t flags)
>  {
> +	int ret;
> +	struct address_space *mapping;
> +	uint64_t end = start + len - 1;
> +
> +	if (flags & ~BLKZEROOUT2_DISCARD_OK)
> +		return -EINVAL;
>  	if (start & 511)
>  		return -EINVAL;
>  	if (len & 511)
>  		return -EINVAL;
> -	start >>= 9;
> -	len >>= 9;
> -
> -	if (start + len > (i_size_read(bdev->bd_inode) >> 9))
> +	if (end >= i_size_read(bdev->bd_inode))
>  		return -EINVAL;
>  
> -	return blkdev_issue_zeroout(bdev, start, len, GFP_KERNEL, false);
> +	/* Invalidate the page cache, including dirty pages */
> +	mapping = bdev->bd_inode->i_mapping;
> +	truncate_inode_pages_range(mapping, start, end);
> +
> +	ret = blkdev_issue_zeroout(bdev, start >> 9, len >> 9, GFP_KERNEL,
> +				   flags & BLKZEROOUT2_DISCARD_OK);
> +	if (ret)
> +		goto out;
> +
> +	/*
> +	 * Invalidate again; if someone wandered in and dirtied a page,
> +	 * the caller will be given -EBUSY.
> +	 */
> +	ret = invalidate_inode_pages2_range(mapping,
> +					    start >> PAGE_CACHE_SHIFT,
> +					    end >> PAGE_CACHE_SHIFT);
> +out:
> +	return ret;
>  }
>  
>  static int put_ushort(unsigned long arg, unsigned short val)
> @@ -326,7 +346,18 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
>  		if (copy_from_user(range, (void __user *)arg, sizeof(range)))
>  			return -EFAULT;
>  
> -		return blk_ioctl_zeroout(bdev, range[0], range[1]);
> +		return blk_ioctl_zeroout(bdev, range[0], range[1], 0);
> +	}
> +	case BLKZEROOUT2: {
> +		struct blkzeroout2 p;
> +
> +		if (!(mode & FMODE_WRITE))
> +			return -EBADF;
> +
> +		if (copy_from_user(&p, (void __user *)arg, sizeof(p)))
> +			return -EFAULT;
> +
> +		return blk_ioctl_zeroout(bdev, p.start, p.length, p.flags);
>  	}
>  
>  	case HDIO_GETGEO: {
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 3735fa0..54d24ea 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -150,6 +150,13 @@ struct inodes_stat_t {
>  #define BLKSECDISCARD _IO(0x12,125)
>  #define BLKROTATIONAL _IO(0x12,126)
>  #define BLKZEROOUT _IO(0x12,127)
> +struct blkzeroout2 {
> +	__u64 start;
> +	__u64 length;
> +	__u32 flags;
> +};
> +#define BLKZEROOUT2_DISCARD_OK	1
> +#define BLKZEROOUT2 _IOR(0x12, 127, struct blkzeroout2)
>  
>  #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
>  #define FIBMAP	   _IO(0x00,1)	/* bmap access */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
