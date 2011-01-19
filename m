From: Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH v3 5/5] validate extent_buffer if it's readahead in btrfs
Date: Wed, 19 Jan 2011 09:15:27 +0800
Message-ID: <1295399727.1949.868.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Arjan van de Ven <arjan@infradead.org>, "Yan, Zheng" <zheng.z.yan@linux.intel.com>, "Wu, Fengguang" <fengguang.wu@intel.com>, linux-api <linux-api@vger.kernel.org>, manpages <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

do validation for extent_buffer if it's skipped before

With metadata readahead, we slightly change the behavior. Before it, we allocate
an extent_buffer (so set page->private), do metadata read and
btree_readpage_end_io_hook() will do validation. After it, we directly do
metadata readahead, and since in this case page hasn't ->private,
btree_readpage_end_io_hook() will not do validation. This patch fixes this.
It addes a new flag to indicate if a buffer is validated. If not and even
the buffer is uptodated, we will do a validation.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 fs/btrfs/disk-io.c     |   71 ++++++++++++++++++++++++++++++-------------------
 fs/btrfs/disk-io.h     |    2 +
 fs/btrfs/extent-tree.c |    1 
 fs/btrfs/extent_io.c   |   14 ++++++++-
 fs/btrfs/extent_io.h   |    1 
 5 files changed, 60 insertions(+), 29 deletions(-)

Index: linux/fs/btrfs/disk-io.c
===================================================================
--- linux.orig/fs/btrfs/disk-io.c	2011-01-18 10:53:07.000000000 +0800
+++ linux/fs/btrfs/disk-io.c	2011-01-18 11:16:41.000000000 +0800
@@ -424,12 +424,53 @@ void btrfs_set_buffer_lockdep_class(stru
 }
 #endif
 
+int btree_validate_extent_buffer(struct btrfs_root *root,
+	struct extent_buffer *eb)
+{
+	u64 found_start;
+	int found_level;
+	int ret = 0;
+
+	if (!test_bit(EXTENT_BUFFER_UNCHECKED, &eb->bflags))
+		return 0;
+
+	found_start = btrfs_header_bytenr(eb);
+	if (found_start != eb->start) {
+		if (printk_ratelimit()) {
+			printk(KERN_INFO "btrfs bad tree block start "
+			       "%llu %llu\n",
+			       (unsigned long long)found_start,
+			       (unsigned long long)eb->start);
+		}
+		ret = -EIO;
+		goto err;
+	}
+
+	if (check_tree_block_fsid(root, eb)) {
+		if (printk_ratelimit()) {
+			printk(KERN_INFO "btrfs bad fsid on block %llu\n",
+			       (unsigned long long)eb->start);
+		}
+		ret = -EIO;
+		goto err;
+	}
+	found_level = btrfs_header_level(eb);
+
+	btrfs_set_buffer_lockdep_class(eb, found_level);
+
+	ret = csum_tree_block(root, eb, 1);
+	if (ret)
+		ret = -EIO;
+err:
+	if (ret == 0)
+		clear_bit(EXTENT_BUFFER_UNCHECKED, &eb->bflags);
+	return ret;
+}
+
 static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 			       struct extent_state *state)
 {
 	struct extent_io_tree *tree;
-	u64 found_start;
-	int found_level;
 	unsigned long len;
 	struct extent_buffer *eb;
 	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
@@ -450,17 +491,6 @@ static int btree_readpage_end_io_hook(st
 		goto out;
 	}
 
-	found_start = btrfs_header_bytenr(eb);
-	if (found_start != start) {
-		if (printk_ratelimit()) {
-			printk(KERN_INFO "btrfs bad tree block start "
-			       "%llu %llu\n",
-			       (unsigned long long)found_start,
-			       (unsigned long long)eb->start);
-		}
-		ret = -EIO;
-		goto err;
-	}
 	if (eb->first_page != page) {
 		printk(KERN_INFO "btrfs bad first page %lu %lu\n",
 		       eb->first_page->index, page->index);
@@ -468,21 +498,8 @@ static int btree_readpage_end_io_hook(st
 		ret = -EIO;
 		goto err;
 	}
-	if (check_tree_block_fsid(root, eb)) {
-		if (printk_ratelimit()) {
-			printk(KERN_INFO "btrfs bad fsid on block %llu\n",
-			       (unsigned long long)eb->start);
-		}
-		ret = -EIO;
-		goto err;
-	}
-	found_level = btrfs_header_level(eb);
-
-	btrfs_set_buffer_lockdep_class(eb, found_level);
 
-	ret = csum_tree_block(root, eb, 1);
-	if (ret)
-		ret = -EIO;
+	ret = btree_validate_extent_buffer(root, eb);
 
 	end = min_t(u64, eb->len, PAGE_CACHE_SIZE);
 	end = eb->start + end - 1;
Index: linux/fs/btrfs/disk-io.h
===================================================================
--- linux.orig/fs/btrfs/disk-io.h	2011-01-18 10:53:07.000000000 +0800
+++ linux/fs/btrfs/disk-io.h	2011-01-18 10:57:54.000000000 +0800
@@ -36,6 +36,8 @@ static inline u64 btrfs_sb_offset(int mi
 struct btrfs_device;
 struct btrfs_fs_devices;
 
+int btree_validate_extent_buffer(struct btrfs_root *root,
+	struct extent_buffer *eb);
 struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 				      u32 blocksize, u64 parent_transid);
 int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
Index: linux/fs/btrfs/extent_io.c
===================================================================
--- linux.orig/fs/btrfs/extent_io.c	2011-01-18 10:53:07.000000000 +0800
+++ linux/fs/btrfs/extent_io.c	2011-01-18 10:57:54.000000000 +0800
@@ -14,6 +14,7 @@
 #include "extent_map.h"
 #include "compat.h"
 #include "ctree.h"
+#include "disk-io.h"
 #include "btrfs_inode.h"
 
 static struct kmem_cache *extent_state_cache;
@@ -3194,6 +3195,7 @@ struct extent_buffer *alloc_extent_buffe
 			uptodate = 0;
 		unlock_page(p);
 	}
+	set_bit(EXTENT_BUFFER_UNCHECKED, &eb->bflags);
 	if (uptodate)
 		set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 
@@ -3424,9 +3426,10 @@ int read_extent_buffer_pages(struct exte
 	unsigned long num_pages;
 	struct bio *bio = NULL;
 	unsigned long bio_flags = 0;
+	struct btrfs_root *root = BTRFS_I(tree->mapping->host)->root;
 
 	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
-		return 0;
+		goto out;
 
 	if (test_range_bit(tree, eb->start, eb->start + eb->len - 1,
 			   EXTENT_UPTODATE, 1, NULL)) {
@@ -3491,8 +3494,10 @@ int read_extent_buffer_pages(struct exte
 			ret = -EIO;
 	}
 
-	if (!ret)
+	if (!ret) {
 		set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+		goto out;
+	}
 	return ret;
 
 unlock_exit:
@@ -3503,6 +3508,11 @@ unlock_exit:
 		unlock_page(page);
 		locked_pages--;
 	}
+out:
+	if (!ret && test_bit(EXTENT_BUFFER_UNCHECKED, &eb->bflags) &&
+		test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
+		return btree_validate_extent_buffer(root, eb);
+
 	return ret;
 }
 
Index: linux/fs/btrfs/extent_io.h
===================================================================
--- linux.orig/fs/btrfs/extent_io.h	2011-01-18 10:53:07.000000000 +0800
+++ linux/fs/btrfs/extent_io.h	2011-01-18 10:57:54.000000000 +0800
@@ -31,6 +31,7 @@
 #define EXTENT_BUFFER_UPTODATE 0
 #define EXTENT_BUFFER_BLOCKING 1
 #define EXTENT_BUFFER_DIRTY 2
+#define EXTENT_BUFFER_UNCHECKED 3
 
 /* these are flags for extent_clear_unlock_delalloc */
 #define EXTENT_CLEAR_UNLOCK_PAGE 0x1
Index: linux/fs/btrfs/extent-tree.c
===================================================================
--- linux.orig/fs/btrfs/extent-tree.c	2011-01-18 10:53:07.000000000 +0800
+++ linux/fs/btrfs/extent-tree.c	2011-01-18 10:57:54.000000000 +0800
@@ -5606,6 +5606,7 @@ struct extent_buffer *btrfs_init_new_buf
 	clean_tree_block(trans, root, buf);
 
 	btrfs_set_lock_blocking(buf);
+	clear_bit(EXTENT_BUFFER_UNCHECKED, &buf->bflags);
 	btrfs_set_buffer_uptodate(buf);
 
 	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID) {


