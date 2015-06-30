From: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>
Subject: [PATCH RESEND] Btrfs: add autodefrag inode flag
Date: Tue, 30 Jun 2015 09:32:20 -0700
Message-ID: <85de09b87ad7b2847ea001f5bb03c044e8b419aa.1435681574.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

In some cases, we may not want to enable automatic defragmentation for
the whole filesystem with the "autodefrag" mount option but we still
want to defragment specific files or directories. Add an inode flag
which allows us to do specify that.

Signed-off-by: Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>
---
Resending this because I didn't send it to fsdevel or linux-api last
time and I'm adding a new user-facing inode flag.

 fs/btrfs/ctree.h        |  1 +
 fs/btrfs/file.c         | 18 ++++++++++--------
 fs/btrfs/ioctl.c        | 13 +++++++++++--
 include/uapi/linux/fs.h |  1 +
 4 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6f364e1d8d3d..e898bb2822ef 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2234,6 +2234,7 @@ do {                                                                   \
 #define BTRFS_INODE_NOATIME		(1 << 9)
 #define BTRFS_INODE_DIRSYNC		(1 << 10)
 #define BTRFS_INODE_COMPRESS		(1 << 11)
+#define BTRFS_INODE_AUTODEFRAG		(1 << 12)
 
 #define BTRFS_INODE_ROOT_ITEM_INIT	(1 << 31)
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b072e17479aa..33bead79da7a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -129,15 +129,17 @@ static int __btrfs_add_inode_defrag(struct inode *inode,
 	return 0;
 }
 
-static inline int __need_auto_defrag(struct btrfs_root *root)
+static inline int __need_auto_defrag(struct btrfs_root *root,
+				     struct inode *inode)
 {
-	if (!btrfs_test_opt(root, AUTO_DEFRAG))
-		return 0;
-
 	if (btrfs_fs_closing(root->fs_info))
 		return 0;
 
-	return 1;
+	if (btrfs_test_opt(root, AUTO_DEFRAG))
+		return 1;
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_AUTODEFRAG)
+		return 1;
+	return 0;
 }
 
 /*
@@ -152,7 +154,7 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 	u64 transid;
 	int ret;
 
-	if (!__need_auto_defrag(root))
+	if (!__need_auto_defrag(root, inode))
 		return 0;
 
 	if (test_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags))
@@ -199,7 +201,7 @@ static void btrfs_requeue_inode_defrag(struct inode *inode,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 
-	if (!__need_auto_defrag(root))
+	if (!__need_auto_defrag(root, inode))
 		goto out;
 
 	/*
@@ -372,7 +374,7 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 			     &fs_info->fs_state))
 			break;
 
-		if (!__need_auto_defrag(fs_info->tree_root))
+		if (btrfs_fs_closing(fs_info))
 			break;
 
 		/* find an inode to defrag */
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1c22c6518504..c1a45d507613 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -121,6 +121,8 @@ static unsigned int btrfs_flags_to_ioctl(unsigned int flags)
 		iflags |= FS_DIRSYNC_FL;
 	if (flags & BTRFS_INODE_NODATACOW)
 		iflags |= FS_NOCOW_FL;
+	if (flags & BTRFS_INODE_AUTODEFRAG)
+		iflags |= FS_AUTODEFRAG_FL;
 
 	if ((flags & BTRFS_INODE_COMPRESS) && !(flags & BTRFS_INODE_NOCOMPRESS))
 		iflags |= FS_COMPR_FL;
@@ -157,7 +159,7 @@ void btrfs_update_iflags(struct inode *inode)
 /*
  * Inherit flags from the parent inode.
  *
- * Currently only the compression flags and the cow flags are inherited.
+ * Currently only the compression, cow, and autodefrag flags are inherited.
  */
 void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
 {
@@ -182,6 +184,9 @@ void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
 	}
 
+	if (flags & BTRFS_INODE_AUTODEFRAG)
+		BTRFS_I(inode)->flags |= BTRFS_INODE_AUTODEFRAG;
+
 	btrfs_update_iflags(inode);
 }
 
@@ -201,7 +206,7 @@ static int check_flags(unsigned int flags)
 		      FS_NOATIME_FL | FS_NODUMP_FL | \
 		      FS_SYNC_FL | FS_DIRSYNC_FL | \
 		      FS_NOCOMP_FL | FS_COMPR_FL |
-		      FS_NOCOW_FL))
+		      FS_NOCOW_FL | FS_AUTODEFRAG_FL))
 		return -EOPNOTSUPP;
 
 	if ((flags & FS_NOCOMP_FL) && (flags & FS_COMPR_FL))
@@ -278,6 +283,10 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		ip->flags |= BTRFS_INODE_DIRSYNC;
 	else
 		ip->flags &= ~BTRFS_INODE_DIRSYNC;
+	if (flags & FS_AUTODEFRAG_FL)
+		ip->flags |= BTRFS_INODE_AUTODEFRAG;
+	else
+		ip->flags &= ~BTRFS_INODE_AUTODEFRAG;
 	if (flags & FS_NOCOW_FL) {
 		if (S_ISREG(mode)) {
 			/*
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 9b964a5920af..8c7e8c7a0236 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -197,6 +197,7 @@ struct inodes_stat_t {
 #define FS_EXTENT_FL			0x00080000 /* Extents */
 #define FS_DIRECTIO_FL			0x00100000 /* Use direct i/o */
 #define FS_NOCOW_FL			0x00800000 /* Do not cow file */
+#define FS_AUTODEFRAG_FL		0x01000000 /* Auto-defragment file */
 #define FS_RESERVED_FL			0x80000000 /* reserved for ext2 lib */
 
 #define FS_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
-- 
2.4.4
