From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/3] block: require write_same and discard requests align to
	logical block size
Date: Tue, 12 Apr 2016 21:01:35 -0700
Message-ID: <20160413040135.10562.74550.stgit@birch.djwong.org>
References: <20160413040121.10562.98998.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20160413040121.10562.98998.stgit@birch.djwong.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: darrick.wong@oracle.com
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, hch@infradead.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-api@vger.kernel.org

Make sure that the offset and length arguments that we're using to
construct WRITE SAME and DISCARD requests are actually aligned to the
logical block size.  Failure to do this causes other errors in other
parts of the block layer or the SCSI layer because disks don't support
partial logical block writes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-lib.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/block/blk-lib.c b/block/blk-lib.c
index 9ebf653..9dca6bb 100644
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
+	if ((sector | nr_sects) & bs_mask)
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
+	if ((sector | nr_sects) & bs_mask)
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
+	if ((sector | nr_sects) & bs_mask)
+		return -EINVAL;
+
 	atomic_set(&bb.done, 1);
 	bb.error = 0;
 	bb.wait = &wait;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
