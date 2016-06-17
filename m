From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] block: require write_same and discard requests align to
 logical block size
Date: Thu, 16 Jun 2016 18:17:41 -0700
Message-ID: <146612626092.12764.773833541076937471.stgit@birch.djwong.org>
References: <146612624734.12764.4316680863289411106.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <146612624734.12764.4316680863289411106.stgit-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfoster-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Make sure that the offset and length arguments that we're using to
construct WRITE SAME and DISCARD requests are actually aligned to the
logical block size.  Failure to do this causes other errors in other
parts of the block layer or the SCSI layer because disks don't support
partial logical block writes.

Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/blk-lib.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/block/blk-lib.c b/block/blk-lib.c
index 9e29dc3..012aa98 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -29,6 +29,7 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	struct bio *bio = *biop;
 	unsigned int granularity;
 	int alignment;
+	sector_t bs_mask;
 
 	if (!q)
 		return -ENXIO;
@@ -37,6 +38,10 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	if ((type & REQ_SECURE) && !blk_queue_secdiscard(q))
 		return -EOPNOTSUPP;
 
+	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
+	if ((sector | nr_sects) & bs_mask)
+		return -EINVAL;
+
 	/* Zero-sector (unknown) and one-sector granularities are the same.  */
 	granularity = max(q->limits.discard_granularity >> 9, 1U);
 	alignment = (bdev_discard_alignment(bdev) >> 9) % granularity;
@@ -140,10 +145,15 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 	unsigned int max_write_same_sectors;
 	struct bio *bio = NULL;
 	int ret = 0;
+	sector_t bs_mask;
 
 	if (!q)
 		return -ENXIO;
 
+	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
+	if ((sector | nr_sects) & bs_mask)
+		return -EINVAL;
+
 	/* Ensure that max_write_same_sectors doesn't overflow bi_size */
 	max_write_same_sectors = UINT_MAX >> 9;
 
@@ -191,6 +201,11 @@ static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	int ret;
 	struct bio *bio = NULL;
 	unsigned int sz;
+	sector_t bs_mask;
+
+	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
+	if ((sector | nr_sects) & bs_mask)
+		return -EINVAL;
 
 	while (nr_sects != 0) {
 		bio = next_bio(bio, WRITE,
