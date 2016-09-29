From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/3] block: require write_same and discard requests align to
 logical block size
Date: Thu, 29 Sep 2016 14:16:30 -0700
Message-ID: <147518379026.22791.4437508871355153928.stgit@birch.djwong.org>
References: <147518377601.22791.14436504108602322570.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <147518377601.22791.14436504108602322570.stgit@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: axboe@kernel.dk, akpm@linux-foundation.org, darrick.wong@oracle.com
Cc: linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.com>, tytso@mit.edu, snitzer@redhat.com, martin.petersen@oracle.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, hch@infradead.org, dm-devel@redhat.com, hare@suse.de, linux-fsdevel@vger.kernel.org, bart.vanassche@sandisk.com, Christoph Hellwig <hch@lst.de>
List-Id: linux-api@vger.kernel.org

Make sure that the offset and length arguments that we're using to
construct WRITE SAME and DISCARD requests are actually aligned to the
logical block size.  Failure to do this causes other errors in other
parts of the block layer or the SCSI layer because disks don't support
partial logical block writes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 block/blk-lib.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/block/blk-lib.c b/block/blk-lib.c
index 083e56f..46fe924 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -31,6 +31,7 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	unsigned int granularity;
 	enum req_op op;
 	int alignment;
+	sector_t bs_mask;
 
 	if (!q)
 		return -ENXIO;
@@ -50,6 +51,10 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		op = REQ_OP_DISCARD;
 	}
 
+	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
+	if ((sector | nr_sects) & bs_mask)
+		return -EINVAL;
+
 	/* Zero-sector (unknown) and one-sector granularities are the same.  */
 	granularity = max(q->limits.discard_granularity >> 9, 1U);
 	alignment = (bdev_discard_alignment(bdev) >> 9) % granularity;
@@ -150,10 +155,15 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
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
 
@@ -202,6 +212,11 @@ static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	int ret;
 	struct bio *bio = NULL;
 	unsigned int sz;
+	sector_t bs_mask;
+
+	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
+	if ((sector | nr_sects) & bs_mask)
+		return -EINVAL;
 
 	while (nr_sects != 0) {
 		bio = next_bio(bio, min(nr_sects, (sector_t)BIO_MAX_PAGES),

