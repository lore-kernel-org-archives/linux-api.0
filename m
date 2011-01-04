From: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 4/5] implement metadata_ra in btrfs
Date: Tue, 04 Jan 2011 13:40:39 +0800
Message-ID: <1294119639.1949.369.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Implementation btrfs .metadata_readahead. In btrfs, all metadata pages are in a
special btree_inode. We do readahead in it.

Signed-off-by: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
 fs/btrfs/disk-io.c |   10 ++++++++++
 fs/btrfs/super.c   |    1 +
 fs/btrfs/volumes.c |   38 ++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h |    2 ++
 mm/readahead.c     |    1 +
 5 files changed, 52 insertions(+)

Index: linux/fs/btrfs/disk-io.c
===================================================================
--- linux.orig/fs/btrfs/disk-io.c	2010-12-31 08:52:00.000000000 +0800
+++ linux/fs/btrfs/disk-io.c	2011-01-03 21:16:12.000000000 +0800
@@ -774,6 +774,15 @@ static int btree_readpage(struct file *f
 	return extent_read_full_page(tree, page, btree_get_extent);
 }
 
+static int btree_readpages(struct file *file, struct address_space *mapping,
+		struct list_head *pages, unsigned nr_pages)
+{
+	struct extent_io_tree *tree;
+	tree = &BTRFS_I(mapping->host)->io_tree;
+	return extent_readpages(tree, mapping, pages, nr_pages,
+			btree_get_extent);
+}
+
 static int btree_releasepage(struct page *page, gfp_t gfp_flags)
 {
 	struct extent_io_tree *tree;
@@ -817,6 +826,7 @@ static void btree_invalidatepage(struct
 
 static const struct address_space_operations btree_aops = {
 	.readpage	= btree_readpage,
+	.readpages	= btree_readpages,
 	.writepage	= btree_writepage,
 	.writepages	= btree_writepages,
 	.releasepage	= btree_releasepage,
Index: linux/fs/btrfs/super.c
===================================================================
--- linux.orig/fs/btrfs/super.c	2011-01-03 21:16:00.000000000 +0800
+++ linux/fs/btrfs/super.c	2011-01-03 21:16:12.000000000 +0800
@@ -922,6 +922,7 @@ static const struct super_operations btr
 	.freeze_fs	= btrfs_freeze,
 	.unfreeze_fs	= btrfs_unfreeze,
 	.metadata_incore = btrfs_metadata_incore,
+	.metadata_readahead = btrfs_metadata_readahead,
 };
 
 static const struct file_operations btrfs_ctl_fops = {
Index: linux/mm/readahead.c
===================================================================
--- linux.orig/mm/readahead.c	2010-12-31 08:51:36.000000000 +0800
+++ linux/mm/readahead.c	2011-01-03 21:16:12.000000000 +0800
@@ -228,6 +228,7 @@ int force_page_cache_readahead(struct ad
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(force_page_cache_readahead);
 
 /*
  * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
Index: linux/fs/btrfs/volumes.c
===================================================================
--- linux.orig/fs/btrfs/volumes.c	2010-12-31 08:52:00.000000000 +0800
+++ linux/fs/btrfs/volumes.c	2011-01-03 21:16:12.000000000 +0800
@@ -3448,3 +3448,41 @@ error:
 	btrfs_free_path(path);
 	return ret;
 }
+
+int btrfs_metadata_readahead(struct super_block *sb, loff_t offset,
+	ssize_t size)
+{
+	struct btrfs_root *tree_root = btrfs_sb(sb);
+	struct inode *btree_inode = tree_root->fs_info->btree_inode;
+	struct address_space *mapping = btree_inode->i_mapping;
+	struct btrfs_fs_info *info = tree_root->fs_info;
+	struct btrfs_block_group_cache *cache = NULL;
+	u64 bytenr = offset;
+	int retval = -EINVAL;
+
+	lock_chunks(tree_root);
+	/* Make sure readahead range is in valid chunk */
+	while (1) {
+		cache = btrfs_lookup_block_group(info, bytenr);
+		if (!cache)
+			break;
+
+		if (cache->key.objectid + cache->key.offset >=
+				offset + size) {
+			retval = 0;
+			break;
+		}
+		bytenr = cache->key.objectid + cache->key.offset;
+		btrfs_put_block_group(cache);
+		cache = NULL;
+	}
+	if (cache)
+		btrfs_put_block_group(cache);
+
+	if (!retval)
+		force_page_cache_readahead(mapping, NULL,
+			offset >> PAGE_CACHE_SHIFT,
+			size >> PAGE_CACHE_SHIFT);
+	unlock_chunks(tree_root);
+	return retval;
+}
Index: linux/fs/btrfs/volumes.h
===================================================================
--- linux.orig/fs/btrfs/volumes.h	2010-12-31 08:52:00.000000000 +0800
+++ linux/fs/btrfs/volumes.h	2011-01-03 21:16:12.000000000 +0800
@@ -185,4 +185,6 @@ int btrfs_chunk_readonly(struct btrfs_ro
 int find_free_dev_extent(struct btrfs_trans_handle *trans,
 			 struct btrfs_device *device, u64 num_bytes,
 			 u64 *start, u64 *max_avail);
+int btrfs_metadata_readahead(struct super_block *sb, loff_t offset,
+	ssize_t size);
 #endif
