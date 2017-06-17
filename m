From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 1/2] mm: introduce bmap_walk()
Date: Fri, 16 Jun 2017 18:15:29 -0700
Message-ID: <149766212976.22552.11210067224152823950.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149766212410.22552.15957843500156182524.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <149766212410.22552.15957843500156182524.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Refactor the core of generic_swapfile_activate() into bmap_walk() so
that it can be used by a new daxfile_activate() helper (to be added).

There should be no functional differences as a result of this change,
although it does add the capability to perform the bmap with a given
page-size. This is in support of daxfile users that want to ensure huge
page usage.

Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 mm/page_io.c |   86 +++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 67 insertions(+), 19 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 23f6d0d3470f..5cec9a3d49f2 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -135,11 +135,22 @@ static void end_swap_bio_read(struct bio *bio)
 	bio_put(bio);
 }
 
-int generic_swapfile_activate(struct swap_info_struct *sis,
-				struct file *swap_file,
-				sector_t *span)
+enum bmap_check {
+	BMAP_WALK_UNALIGNED,
+	BMAP_WALK_DISCONTIG,
+	BMAP_WALK_FULLPAGE,
+	BMAP_WALK_DONE,
+};
+
+typedef int (*bmap_check_fn)(sector_t block, unsigned long page_no,
+		enum bmap_check type, void *ctx);
+
+static int bmap_walk(struct file *file, const unsigned page_size,
+		const unsigned long page_max, sector_t *span,
+		bmap_check_fn check, void *ctx)
 {
-	struct address_space *mapping = swap_file->f_mapping;
+	struct address_space *mapping = file->f_mapping;
+	const unsigned page_shift = ilog2(page_size);
 	struct inode *inode = mapping->host;
 	unsigned blocks_per_page;
 	unsigned long page_no;
@@ -152,7 +163,7 @@ int generic_swapfile_activate(struct swap_info_struct *sis,
 	int ret;
 
 	blkbits = inode->i_blkbits;
-	blocks_per_page = PAGE_SIZE >> blkbits;
+	blocks_per_page = page_size >> blkbits;
 
 	/*
 	 * Map all the blocks into the extent list.  This code doesn't try
@@ -162,7 +173,7 @@ int generic_swapfile_activate(struct swap_info_struct *sis,
 	page_no = 0;
 	last_block = i_size_read(inode) >> blkbits;
 	while ((probe_block + blocks_per_page) <= last_block &&
-			page_no < sis->max) {
+			page_no < page_max) {
 		unsigned block_in_page;
 		sector_t first_block;
 
@@ -173,11 +184,15 @@ int generic_swapfile_activate(struct swap_info_struct *sis,
 			goto bad_bmap;
 
 		/*
-		 * It must be PAGE_SIZE aligned on-disk
+		 * It must be @page_size aligned on-disk
 		 */
 		if (first_block & (blocks_per_page - 1)) {
 			probe_block++;
-			goto reprobe;
+			ret = check(first_block, page_no,
+					BMAP_WALK_UNALIGNED, ctx);
+			if (ret == -EAGAIN)
+				goto reprobe;
+			goto bad_bmap;
 		}
 
 		for (block_in_page = 1; block_in_page < blocks_per_page;
@@ -190,11 +205,15 @@ int generic_swapfile_activate(struct swap_info_struct *sis,
 			if (block != first_block + block_in_page) {
 				/* Discontiguity */
 				probe_block++;
-				goto reprobe;
+				ret = check(first_block, page_no,
+						BMAP_WALK_DISCONTIG, ctx);
+				if (ret == -EAGAIN)
+					goto reprobe;
+				goto bad_bmap;
 			}
 		}
 
-		first_block >>= (PAGE_SHIFT - blkbits);
+		first_block >>= (page_shift - blkbits);
 		if (page_no) {	/* exclude the header page */
 			if (first_block < lowest_block)
 				lowest_block = first_block;
@@ -203,9 +222,9 @@ int generic_swapfile_activate(struct swap_info_struct *sis,
 		}
 
 		/*
-		 * We found a PAGE_SIZE-length, PAGE_SIZE-aligned run of blocks
+		 * We found a @page_size-{length,aligned} run of blocks
 		 */
-		ret = add_swap_extent(sis, page_no, 1, first_block);
+		ret = check(first_block, page_no, BMAP_WALK_FULLPAGE, ctx);
 		if (ret < 0)
 			goto out;
 		nr_extents += ret;
@@ -215,20 +234,49 @@ int generic_swapfile_activate(struct swap_info_struct *sis,
 		continue;
 	}
 	ret = nr_extents;
-	*span = 1 + highest_block - lowest_block;
-	if (page_no == 0)
-		page_no = 1;	/* force Empty message */
-	sis->max = page_no;
-	sis->pages = page_no - 1;
-	sis->highest_bit = page_no - 1;
+	if (span)
+		*span = 1 + highest_block - lowest_block;
+	check(highest_block, page_no, BMAP_WALK_DONE, ctx);
 out:
 	return ret;
 bad_bmap:
-	pr_err("swapon: swapfile has holes\n");
 	ret = -EINVAL;
 	goto out;
 }
 
+static int swapfile_check(sector_t block, unsigned long page_no,
+		enum bmap_check type, void *_sis)
+{
+	struct swap_info_struct *sis = _sis;
+
+	if (type == BMAP_WALK_DONE) {
+		if (page_no == 0)
+			page_no = 1;	/* force Empty message */
+		sis->max = page_no;
+		sis->pages = page_no - 1;
+		sis->highest_bit = page_no - 1;
+		return 0;
+	}
+
+	if (type != BMAP_WALK_FULLPAGE)
+		return -EAGAIN;
+
+	return add_swap_extent(sis, page_no, 1, block);
+}
+
+int generic_swapfile_activate(struct swap_info_struct *sis,
+				struct file *swap_file,
+				sector_t *span)
+{
+	int rc = bmap_walk(swap_file, PAGE_SIZE, sis->max, span,
+			swapfile_check, sis);
+
+	if (rc < 0)
+		pr_err("swapon: swapfile has holes\n");
+
+	return rc;
+}
+
 /*
  * We may have stale swap cache pages in memory: notice
  * them here and get rid of the unnecessary final write.
