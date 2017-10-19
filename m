From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 17/17] xfs: support for synchronous DAX faults
Date: Thu, 19 Oct 2017 14:58:16 +0200
Message-ID: <20171019125817.11580-18-jack@suse.cz>
References: <20171019125817.11580-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20171019125817.11580-1-jack-AlSwsSmVLrQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Return IOMAP_F_DIRTY from xfs_file_iomap_begin() when asked to prepare
blocks for writing and the inode is pinned, and has dirty fields other
than the timestamps.  In __xfs_filemap_fault() we then detect this case
and call dax_finish_sync_fault() to make sure all metadata is committed,
and to insert the page table entry.

Note that this will also dirty corresponding radix tree entry which is
what we want - fsync(2) will still provide data integrity guarantees for
applications not using userspace flushing. And applications using
userspace flushing can avoid calling fsync(2) and thus avoid the
performance overhead.

[JK: Added VM_SYNC flag handling]

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/xfs/xfs_file.c  | 17 ++++++++++++++++-
 fs/xfs/xfs_iomap.c |  5 +++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7c6b8def6eed..9b8058774af3 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -44,6 +44,7 @@
 #include <linux/falloc.h>
 #include <linux/pagevec.h>
 #include <linux/backing-dev.h>
+#include <linux/mman.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -1040,7 +1041,11 @@ __xfs_filemap_fault(
 
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 	if (IS_DAX(inode)) {
-		ret = dax_iomap_fault(vmf, pe_size, NULL, &xfs_iomap_ops);
+		pfn_t pfn;
+
+		ret = dax_iomap_fault(vmf, pe_size, &pfn, &xfs_iomap_ops);
+		if (ret & VM_FAULT_NEEDDSYNC)
+			ret = dax_finish_sync_fault(vmf, pe_size, pfn);
 	} else {
 		if (write_fault)
 			ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
@@ -1131,6 +1136,13 @@ xfs_file_mmap(
 	struct file	*filp,
 	struct vm_area_struct *vma)
 {
+	/*
+	 * We don't support synchronous mappings for non-DAX files. At least
+	 * until someone comes with a sensible use case.
+	 */
+	if (!IS_DAX(file_inode(filp)) && (vma->vm_flags & VM_SYNC))
+		return -EOPNOTSUPP;
+
 	file_accessed(filp);
 	vma->vm_ops = &xfs_file_vm_ops;
 	if (IS_DAX(file_inode(filp)))
@@ -1138,6 +1150,8 @@ xfs_file_mmap(
 	return 0;
 }
 
+#define XFS_MAP_SUPPORTED (LEGACY_MAP_MASK | MAP_SYNC)
+
 const struct file_operations xfs_file_operations = {
 	.llseek		= xfs_file_llseek,
 	.read_iter	= xfs_file_read_iter,
@@ -1149,6 +1163,7 @@ const struct file_operations xfs_file_operations = {
 	.compat_ioctl	= xfs_file_compat_ioctl,
 #endif
 	.mmap		= xfs_file_mmap,
+	.mmap_supported_flags	= XFS_MAP_SUPPORTED,
 	.open		= xfs_file_open,
 	.release	= xfs_file_release,
 	.fsync		= xfs_file_fsync,
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f179bdf1644d..b43be199fbdf 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -33,6 +33,7 @@
 #include "xfs_error.h"
 #include "xfs_trans.h"
 #include "xfs_trans_space.h"
+#include "xfs_inode_item.h"
 #include "xfs_iomap.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
@@ -1086,6 +1087,10 @@ xfs_file_iomap_begin(
 		trace_xfs_iomap_found(ip, offset, length, 0, &imap);
 	}
 
+	if ((flags & IOMAP_WRITE) && xfs_ipincount(ip) &&
+	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
+		iomap->flags |= IOMAP_F_DIRTY;
+
 	xfs_bmbt_to_iomap(ip, iomap, &imap);
 
 	if (shared)
-- 
2.12.3
