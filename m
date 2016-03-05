From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/3] block: require write_same and discard requests align to
 logical block size
Date: Fri, 04 Mar 2016 16:56:10 -0800
Message-ID: <20160305005610.29738.18727.stgit@birch.djwong.org>
References: <20160305005556.29738.66782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160305005556.29738.66782.stgit@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, torvalds@linux-foundation.org, darrick.wong@oracle.com
Cc: hch@infradead.org, tytso@mit.edu, martin.petersen@oracle.com, linux-api@vger.kernel.org, david@fromorbit.com, linux-kernel@vger.kernel.org, shane.seymour@hpe.com, bfields@fieldses.org, linux-fsdevel@vger.kernel.org, jlayton@poochiereds.net, akpm@linux-foundation.org
List-Id: linux-api@vger.kernel.org

Make sure that the offset and length arguments that we're using to
construct WRITE SAME and DISCARD requests are actually aligned to the
logical block size.  Failure to do this causes other errors in other
parts of the block layer or the SCSI layer because disks don't support
partial logical block writes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 block/blk-lib.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/block/blk-lib.c b/block/blk-lib.c
index 9ebf653..3e5ca28 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -49,6 +49,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	struct bio *bio;
 	int ret = 0;
 	struct blk_plug plug;
+	sector_t bs_mask;
 
 	if (!q)
 		return -ENXIO;
@@ -56,6 +57,10 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	if (!blk_queue_discard(q))
 		return -EOPNOTSUPP;
 
+	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
+	if ((sector & bs_mask) || ((sector + nr_sects) & bs_mask))
+		return -EINVAL;
+
 	/* Zero-sector (unknown) and one-sector granularities are the same.  */
 	granularity = max(q->limits.discard_granularity >> 9, 1U);
 	alignment = (bdev_discard_alignment(bdev) >> 9) % granularity;
@@ -148,6 +153,7 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q = bdev_get_queue(bdev);
 	unsigned int max_write_same_sectors;
+	sector_t bs_mask;
 	struct bio_batch bb;
 	struct bio *bio;
 	int ret = 0;
@@ -155,6 +161,10 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 	if (!q)
 		return -ENXIO;
 
+	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
+	if ((sector & bs_mask) || ((sector + nr_sects) & bs_mask))
+		return -EINVAL;
+
 	/* Ensure that max_write_same_sectors doesn't overflow bi_size */
 	max_write_same_sectors = UINT_MAX >> 9;
 
@@ -218,9 +228,14 @@ static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	int ret;
 	struct bio *bio;
 	struct bio_batch bb;
+	sector_t bs_mask;
 	unsigned int sz;
 	DECLARE_COMPLETION_ONSTACK(wait);
 
+	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
+	if ((sector & bs_mask) || ((sector + nr_sects) & bs_mask))
+		return -EINVAL;
+
 	atomic_set(&bb.done, 1);
 	bb.error = 0;
 	bb.wait = &wait;
