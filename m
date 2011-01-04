From: Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH v2 2/5] implement metadata_incore in btrfs
Date: Tue, 04 Jan 2011 13:40:35 +0800
Message-ID: <1294119635.1949.367.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Arjan van de Ven <arjan@infradead.org>, "Yan, Zheng" <zheng.z.yan@linux.intel.com>, linux-api@vger.kernel.org, mtk.manpages@gmail.com
List-Id: linux-api@vger.kernel.org

Implement btrfs specific .metadata_incore.
In btrfs, all metadata pages are in a special btree_inode, we take pages from it.
we only account updated and referenced pages here. Say we collect metadata info
in one boot, do metadata readahead in next boot and we might collect metadata
again. The readahead could read garbage data in as metadata could be changed
from first run. If we only account updated pages, the metadata info collected
by userspace will increase every run. Btrfs alloc_extent_buffer will do
mark_page_accessed() for pages which will be used soon, so we could use
referenced bit to filter some garbage pages.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 fs/btrfs/super.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

Index: linux/fs/btrfs/super.c
===================================================================
--- linux.orig/fs/btrfs/super.c	2010-12-31 08:52:00.000000000 +0800
+++ linux/fs/btrfs/super.c	2011-01-03 21:16:00.000000000 +0800
@@ -39,6 +39,7 @@
 #include <linux/miscdevice.h>
 #include <linux/magic.h>
 #include <linux/slab.h>
+#include <linux/pagevec.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -845,6 +846,67 @@ static int btrfs_unfreeze(struct super_b
 	return 0;
 }
 
+static int btrfs_metadata_incore(struct super_block *sb, loff_t *offset,
+	ssize_t *size)
+{
+	struct btrfs_root *tree_root = btrfs_sb(sb);
+	struct inode *btree_inode = tree_root->fs_info->btree_inode;
+	struct pagevec pvec;
+	pgoff_t index = (*offset) >> PAGE_CACHE_SHIFT;
+	int i, nr_pages;
+
+	*size = 0;
+retry:
+	pagevec_init(&pvec, 0);
+	nr_pages = pagevec_lookup(&pvec, btree_inode->i_mapping, index,
+		PAGEVEC_SIZE);
+	if (nr_pages == 0)
+		goto out;
+	for (i = 0; i < nr_pages; i++) {
+		struct page *page = pvec.pages[i];
+
+		/*
+		 * we only account updated and referenced pages here. Say we
+		 * collect metadata info in one boot, do metadata readahead in
+		 * next boot and we collect metadata again. The readahead could
+		 * read garbage data in as metadata could be changed from first
+		 * run. If we only account updated pages, the metadata info
+		 * collected by userspace will increase every run. Btrfs
+		 * alloc_extent_buffer will do mark_page_accessed() for pages
+		 * which will be used soon, so we could use referenced bit to
+		 * filter some garbage pages.
+		 */
+		if (PageUptodate(page) && PageReferenced(page)) {
+			if (*size == 0) {
+				*size += PAGE_CACHE_SIZE;
+				*offset = page->index << PAGE_CACHE_SHIFT;
+				continue;
+			}
+			if (page->index !=
+			    (*offset + *size) >> PAGE_CACHE_SHIFT)
+				break;
+			*size += PAGE_CACHE_SIZE;
+		} else if (*size > 0)
+			break;
+		else
+			index = page->index + 1;
+	}
+	pagevec_release(&pvec);
+
+	/*
+	 * all pages are filtered out because of referenced bit, but this
+	 * doesn't mean we have no pages anymore in the btree_inode. so we
+	 * retry the search and 'index' is already set to next start address
+	 */
+	if (nr_pages > 0 && *size == 0)
+		goto retry;
+out:
+	if (*size > 0)
+		return 0;
+	else
+		return -ENOENT;
+}
+
 static const struct super_operations btrfs_super_ops = {
 	.drop_inode	= btrfs_drop_inode,
 	.evict_inode	= btrfs_evict_inode,
@@ -859,6 +921,7 @@ static const struct super_operations btr
 	.remount_fs	= btrfs_remount,
 	.freeze_fs	= btrfs_freeze,
 	.unfreeze_fs	= btrfs_unfreeze,
+	.metadata_incore = btrfs_metadata_incore,
 };
 
 static const struct file_operations btrfs_ctl_fops = {


