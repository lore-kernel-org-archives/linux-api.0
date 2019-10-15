From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH v2 3/5] btrfs: generalize btrfs_lookup_bio_sums_dio()
Date: Tue, 15 Oct 2019 11:42:41 -0700
Message-ID: <01fdb646d7572f7d0d123937835db5c605e25a5e.1571164762.git.osandov@fb.com>
References: <cover.1571164762.git.osandov@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1571164762.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, linux-api@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

This isn't actually dio-specific; it just looks up the csums starting at
the given offset instead of using the page index. Rename it to
btrfs_lookup_bio_sums_at_offset() and add the dst parameter. We might
even want to expose __btrfs_lookup_bio_sums() as the public API instead
of having two trivial wrappers, but I'll leave that for another day.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/ctree.h     |  5 +++--
 fs/btrfs/file-item.c | 18 +++++++++---------
 fs/btrfs/inode.c     |  4 ++--
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 19d669d12ca1..71552b2ca340 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2791,8 +2791,9 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 		    struct btrfs_fs_info *fs_info, u64 bytenr, u64 len);
 blk_status_t btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio,
 				   u8 *dst);
-blk_status_t btrfs_lookup_bio_sums_dio(struct inode *inode, struct bio *bio,
-			      u64 logical_offset);
+blk_status_t btrfs_lookup_bio_sums_at_offset(struct inode *inode,
+					     struct bio *bio, u64 offset,
+					     u8 *dst);
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     u64 objectid, u64 pos,
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 1a599f50837b..d98f06fc2978 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -148,8 +148,9 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static blk_status_t __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio,
-				   u64 logical_offset, u8 *dst, int dio)
+static blk_status_t __btrfs_lookup_bio_sums(struct inode *inode,
+					    struct bio *bio,
+					    bool at_offset, u64 offset, u8 *dst)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct bio_vec bvec;
@@ -159,7 +160,6 @@ static blk_status_t __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_path *path;
 	u8 *csum;
-	u64 offset = 0;
 	u64 item_start_offset = 0;
 	u64 item_last_offset = 0;
 	u64 disk_bytenr;
@@ -205,15 +205,13 @@ static blk_status_t __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio
 	}
 
 	disk_bytenr = (u64)bio->bi_iter.bi_sector << 9;
-	if (dio)
-		offset = logical_offset;
 
 	bio_for_each_segment(bvec, bio, iter) {
 		page_bytes_left = bvec.bv_len;
 		if (count)
 			goto next;
 
-		if (!dio)
+		if (!at_offset)
 			offset = page_offset(bvec.bv_page) + bvec.bv_offset;
 		count = btrfs_find_ordered_sum(inode, offset, disk_bytenr,
 					       csum, nblocks);
@@ -291,12 +289,14 @@ static blk_status_t __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio
 blk_status_t btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio,
 				   u8 *dst)
 {
-	return __btrfs_lookup_bio_sums(inode, bio, 0, dst, 0);
+	return __btrfs_lookup_bio_sums(inode, bio, false, 0, dst);
 }
 
-blk_status_t btrfs_lookup_bio_sums_dio(struct inode *inode, struct bio *bio, u64 offset)
+blk_status_t btrfs_lookup_bio_sums_at_offset(struct inode *inode,
+					     struct bio *bio, u64 offset,
+					     u8 *dst)
 {
-	return __btrfs_lookup_bio_sums(inode, bio, offset, NULL, 1);
+	return __btrfs_lookup_bio_sums(inode, bio, true, offset, dst);
 }
 
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0f2754eaa05b..8bce46122ef7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8319,8 +8319,8 @@ static inline blk_status_t btrfs_lookup_and_bind_dio_csum(struct inode *inode,
 	 * contention.
 	 */
 	if (dip->logical_offset == file_offset) {
-		ret = btrfs_lookup_bio_sums_dio(inode, dip->orig_bio,
-						file_offset);
+		ret = btrfs_lookup_bio_sums_at_offset(inode, dip->orig_bio,
+						      file_offset, NULL);
 		if (ret)
 			return ret;
 	}
-- 
2.23.0
