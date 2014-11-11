From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] block: Introduce blkdev_issue_zeroout_discard()
 function
Date: Mon, 10 Nov 2014 16:04:33 -0800
Message-ID: <20141111000433.GA10047@birch.djwong.org>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
 <1415336894-15327-4-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1415336894-15327-4-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, neilb@suse.de, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 07, 2014 at 12:08:14AM -0500, Martin K. Petersen wrote:
> blkdev_issue_discard() will zero a given block range on disk. This is
> done by way of either WRITE SAME or regular WRITE. I.e. the blocks on
> disk will be written and thus provisioned.
> 
> There are use cases where the desired behavior is to zero the blocks but
> unprovision them if possible. The blocks must deterministically contain
> zeroes when they are subsequently read back.
> 
> This patch introduces a blkdev_issue_zeroout_discard() call that
> provides this functionality. If a block device guarantees
> discard_zeroes_data the new function will use discard to clear the block
> range. If the device does not support discard_zeroes_data or if the
> discard request fails we will fall back to blkdev_issue_zeroout() to
> ensure predictable results.

Can this be plumbed into a BLK* ioctl too?  I'll write a patch, if this is ok
with everyone:

struct blkzeroout_t {
	__u64 start;
	__u64 end;
	__u32 flags;
};
#define BLKZEROOUT_DISCARD_OK	1

#define BLKZEROOUT_V2		_IOR(0x12, 127, sizeof(struct blkzeroout_t))

...and make it zap the page cache per earlier discussion.  This seems to be a
good fit with what we've been discussing for mke2fs.

--D

> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  block/blk-lib.c        | 44 ++++++++++++++++++++++++++++++++++++++++++--
>  include/linux/blkdev.h |  2 ++
>  2 files changed, 44 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index 8411be3c19d3..2ffec6a01c71 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -278,14 +278,18 @@ static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
>  }
>  
>  /**
> - * blkdev_issue_zeroout - zero-fill a block range
> + * blkdev_issue_zeroout - zero-fill and provision a block range
>   * @bdev:	blockdev to write
>   * @sector:	start sector
>   * @nr_sects:	number of sectors to write
>   * @gfp_mask:	memory allocation flags (for bio_alloc)
>   *
>   * Description:
> - *  Generate and issue number of bios with zerofiled pages.
> + *  Zero-fill a block range. The blocks will be provisioned
> + *  (allocated/anchored) and are guaranteed to return zeroes when read
> + *  back. This function will attempt to use WRITE SAME to optimize the
> + *  process if the block device supports it. Otherwise it will fall back
> + *  to zeroing the blocks using regular WRITE calls.
>   */
>  
>  int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
> @@ -305,3 +309,39 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
>  	return __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask);
>  }
>  EXPORT_SYMBOL(blkdev_issue_zeroout);
> +
> +/**
> + * blkdev_issue_zeroout_discard - zero-fill and attempt to discard block range
> + * @bdev:	blockdev to write
> + * @sector:	start sector
> + * @nr_sects:	number of sectors to write
> + * @gfp_mask:	memory allocation flags (for bio_alloc)
> + *
> + * Description:
> + *  Zero-fill a block range. In contrast to blkdev_issue_zeroout() this
> + *  function will attempt to deprovision (deallocate/discard) the blocks
> + *  in question. It will only do so if the underlying device guarantees
> + *  that subsequent READ operations to the block range in question will
> + *  return zeroes. If the device does not provide hard guarantees or if
> + *  the DISCARD attempt should fail the block range will be explicitly
> + *  zeroed using blkdev_issue_zeroout().
> + */
> +
> +int blkdev_issue_zeroout_discard(struct block_device *bdev, sector_t sector,
> +				 sector_t nr_sects, gfp_t gfp_mask)
> +{
> +	struct request_queue *q = bdev_get_queue(bdev);
> +
> +	if (blk_queue_discard(q) && q->limits.discard_zeroes_data) {
> +		unsigned char bdn[BDEVNAME_SIZE];
> +
> +		if (!blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, 0))
> +			return 0;
> +
> +		bdevname(bdev, bdn);
> +		pr_err("%s: DISCARD failed. Manually zeroing.\n", bdn);
> +	}
> +
> +	return blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask);
> +}
> +EXPORT_SYMBOL(blkdev_issue_zeroout_discard);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index aac0f9ea952a..078b6e5f488a 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1164,6 +1164,8 @@ extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
>  		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
>  extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
>  			sector_t nr_sects, gfp_t gfp_mask);
> +extern int blkdev_issue_zeroout_discard(struct block_device *bdev,
> +			sector_t sector, sector_t nr_sects, gfp_t gfp_mask);
>  static inline int sb_issue_discard(struct super_block *sb, sector_t block,
>  		sector_t nr_blocks, gfp_t gfp_mask, unsigned long flags)
>  {
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
