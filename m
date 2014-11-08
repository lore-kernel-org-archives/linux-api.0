From: Li Xi <pkuelelixi@gmail.com>
Subject: [v6 4/4] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface support
Date: Sun,  9 Nov 2014 01:43:39 +0800
Message-ID: <1415468619-31851-5-git-send-email-lixi@ddn.com>
References: <1415468619-31851-1-git-send-email-lixi@ddn.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <1415468619-31851-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca, jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org, dmonakhov@openvz.org
List-Id: linux-api@vger.kernel.org

This patch adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR ioctl interface
support for ext4. The interface is kept consistent with
XFS_IOC_FSGETXATTR/XFS_IOC_FSGETXATTR.

Signed-off-by: Li Xi <lixi@ddn.com>
---
 fs/ext4/ext4.h          |    2 +
 fs/ext4/ioctl.c         |  330 +++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_fs.h         |   17 +--
 include/uapi/linux/fs.h |   21 +++
 4 files changed, 257 insertions(+), 113 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4c797da..2d20677 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -617,6 +617,8 @@ enum {
 #define EXT4_IOC_RESIZE_FS		_IOW('f', 16, __u64)
 #define EXT4_IOC_SWAP_BOOT		_IO('f', 17)
 #define EXT4_IOC_PRECACHE_EXTENTS	_IO('f', 18)
+#define EXT4_IOC_FSGETXATTR		FS_IOC_FSGETXATTR
+#define EXT4_IOC_FSSETXATTR		FS_IOC_FSSETXATTR
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index bfda18a..d38b4e8 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -14,6 +14,8 @@
 #include <linux/compat.h>
 #include <linux/mount.h>
 #include <linux/file.h>
+#include <linux/quotaops.h>
+#include <linux/quota.h>
 #include <asm/uaccess.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
@@ -198,126 +200,220 @@ journal_err_out:
 	return err;
 }
 
-long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+static int ext4_ioctl_setflags(struct file *filp, unsigned int flags)
 {
 	struct inode *inode = file_inode(filp);
-	struct super_block *sb = inode->i_sb;
 	struct ext4_inode_info *ei = EXT4_I(inode);
-	unsigned int flags;
+	handle_t *handle = NULL;
+	int err, migrate = 0;
+	struct ext4_iloc iloc;
+	unsigned int oldflags, mask, i;
+	unsigned int jflag;
 
-	ext4_debug("cmd = %u, arg = %lu\n", cmd, arg);
+	if (!inode_owner_or_capable(inode))
+		return -EACCES;
 
-	switch (cmd) {
-	case EXT4_IOC_GETFLAGS:
-		ext4_get_inode_flags(ei);
-		flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
-		return put_user(flags, (int __user *) arg);
-	case EXT4_IOC_SETFLAGS: {
-		handle_t *handle = NULL;
-		int err, migrate = 0;
-		struct ext4_iloc iloc;
-		unsigned int oldflags, mask, i;
-		unsigned int jflag;
+	err = mnt_want_write_file(filp);
+	if (err)
+		return err;
 
-		if (!inode_owner_or_capable(inode))
-			return -EACCES;
+	flags = ext4_mask_flags(inode->i_mode, flags);
 
-		if (get_user(flags, (int __user *) arg))
-			return -EFAULT;
+	err = -EPERM;
+	mutex_lock(&inode->i_mutex);
+	/* Is it quota file? Do not allow user to mess with it */
+	if (IS_NOQUOTA(inode))
+		goto flags_out;
 
-		err = mnt_want_write_file(filp);
-		if (err)
-			return err;
+	oldflags = ei->i_flags;
 
-		flags = ext4_mask_flags(inode->i_mode, flags);
+	/* The JOURNAL_DATA flag is modifiable only by root */
+	jflag = flags & EXT4_JOURNAL_DATA_FL;
 
-		err = -EPERM;
-		mutex_lock(&inode->i_mutex);
-		/* Is it quota file? Do not allow user to mess with it */
-		if (IS_NOQUOTA(inode))
+	/*
+	 * The IMMUTABLE and APPEND_ONLY flags can only be changed by
+	 * the relevant capability.
+	 *
+	 * This test looks nicer. Thanks to Pauline Middelink
+	 */
+	if ((flags ^ oldflags) & (EXT4_APPEND_FL | EXT4_IMMUTABLE_FL)) {
+		if (!capable(CAP_LINUX_IMMUTABLE))
 			goto flags_out;
+	}
 
-		oldflags = ei->i_flags;
-
-		/* The JOURNAL_DATA flag is modifiable only by root */
-		jflag = flags & EXT4_JOURNAL_DATA_FL;
-
-		/*
-		 * The IMMUTABLE and APPEND_ONLY flags can only be changed by
-		 * the relevant capability.
-		 *
-		 * This test looks nicer. Thanks to Pauline Middelink
-		 */
-		if ((flags ^ oldflags) & (EXT4_APPEND_FL | EXT4_IMMUTABLE_FL)) {
-			if (!capable(CAP_LINUX_IMMUTABLE))
-				goto flags_out;
-		}
-
-		/*
-		 * The JOURNAL_DATA flag can only be changed by
-		 * the relevant capability.
-		 */
-		if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL)) {
-			if (!capable(CAP_SYS_RESOURCE))
-				goto flags_out;
-		}
-		if ((flags ^ oldflags) & EXT4_EXTENTS_FL)
-			migrate = 1;
-
+	/*
+	 * The JOURNAL_DATA flag can only be changed by
+	 * the relevant capability.
+	 */
+	if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL)) {
+		if (!capable(CAP_SYS_RESOURCE))
+			goto flags_out;
+	}
+	if ((flags ^ oldflags) & EXT4_EXTENTS_FL)
+		migrate = 1;
 		if (flags & EXT4_EOFBLOCKS_FL) {
-			/* we don't support adding EOFBLOCKS flag */
-			if (!(oldflags & EXT4_EOFBLOCKS_FL)) {
-				err = -EOPNOTSUPP;
-				goto flags_out;
-			}
-		} else if (oldflags & EXT4_EOFBLOCKS_FL)
-			ext4_truncate(inode);
-
-		handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
-		if (IS_ERR(handle)) {
-			err = PTR_ERR(handle);
+		/* we don't support adding EOFBLOCKS flag */
+		if (!(oldflags & EXT4_EOFBLOCKS_FL)) {
+			err = -EOPNOTSUPP;
 			goto flags_out;
 		}
-		if (IS_SYNC(inode))
-			ext4_handle_sync(handle);
-		err = ext4_reserve_inode_write(handle, inode, &iloc);
-		if (err)
-			goto flags_err;
-
-		for (i = 0, mask = 1; i < 32; i++, mask <<= 1) {
-			if (!(mask & EXT4_FL_USER_MODIFIABLE))
-				continue;
-			if (mask & flags)
-				ext4_set_inode_flag(inode, i);
-			else
-				ext4_clear_inode_flag(inode, i);
-		}
+	} else if (oldflags & EXT4_EOFBLOCKS_FL)
+		ext4_truncate(inode);
 
-		ext4_set_inode_flags(inode);
-		inode->i_ctime = ext4_current_time(inode);
+	handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		goto flags_out;
+	}
+	if (IS_SYNC(inode))
+		ext4_handle_sync(handle);
+	err = ext4_reserve_inode_write(handle, inode, &iloc);
+	if (err)
+		goto flags_err;
+
+	for (i = 0, mask = 1; i < 32; i++, mask <<= 1) {
+		if (!(mask & EXT4_FL_USER_MODIFIABLE))
+			continue;
+		if (mask & flags)
+			ext4_set_inode_flag(inode, i);
+		else
+			ext4_clear_inode_flag(inode, i);
+	}
 
-		err = ext4_mark_iloc_dirty(handle, inode, &iloc);
-flags_err:
-		ext4_journal_stop(handle);
-		if (err)
-			goto flags_out;
+	ext4_set_inode_flags(inode);
+	inode->i_ctime = ext4_current_time(inode);
 
-		if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL))
-			err = ext4_change_inode_journal_flag(inode, jflag);
-		if (err)
-			goto flags_out;
-		if (migrate) {
-			if (flags & EXT4_EXTENTS_FL)
-				err = ext4_ext_migrate(inode);
-			else
-				err = ext4_ind_migrate(inode);
-		}
+	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
+flags_err:
+	ext4_journal_stop(handle);
+	if (err)
+		goto flags_out;
+
+	if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL))
+		err = ext4_change_inode_journal_flag(inode, jflag);
+	if (err)
+		goto flags_out;
+	if (migrate) {
+		if (flags & EXT4_EXTENTS_FL)
+			err = ext4_ext_migrate(inode);
+		else
+			err = ext4_ind_migrate(inode);
+	}
 
 flags_out:
-		mutex_unlock(&inode->i_mutex);
-		mnt_drop_write_file(filp);
+	mutex_unlock(&inode->i_mutex);
+	mnt_drop_write_file(filp);
+	return err;
+}
+
+static int ext4_ioctl_setproject(struct file *filp, __u32 projid)
+{
+	struct inode *inode = file_inode(filp);
+	struct super_block *sb = inode->i_sb;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	int err;
+	handle_t *handle;
+	kprojid_t kprojid;
+	struct ext4_iloc iloc;
+	struct ext4_inode *raw_inode;
+
+	struct dquot *transfer_to[EXT4_MAXQUOTAS] = { };
+
+	/* Make sure caller can change project. */
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (projid != EXT4_DEF_PROJID
+	    && !EXT4_HAS_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_PROJECT))
+		return -EOPNOTSUPP;
+
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_PROJECT)) {
+		BUG_ON(__kprojid_val(EXT4_I(inode)->i_projid)
+		       != EXT4_DEF_PROJID);
+		if (projid != EXT4_DEF_PROJID)
+			return -EOPNOTSUPP;
+		else
+			return 0;
+	}
+
+	kprojid = make_kprojid(&init_user_ns, (projid_t)projid);
+
+	if (projid_eq(kprojid, EXT4_I(inode)->i_projid))
+		return 0;
+
+	err = mnt_want_write_file(filp);
+	if (err)
 		return err;
+
+	err = -EPERM;
+	mutex_lock(&inode->i_mutex);
+	/* Is it quota file? Do not allow user to mess with it */
+	if (IS_NOQUOTA(inode))
+		goto project_out;
+
+	dquot_initialize(inode);
+
+	handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
+		EXT4_QUOTA_INIT_BLOCKS(sb) +
+		EXT4_QUOTA_DEL_BLOCKS(sb) + 3);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		goto project_out;
+	}
+
+	err = ext4_reserve_inode_write(handle, inode, &iloc);
+	if (err)
+		goto project_stop;
+
+	raw_inode = ext4_raw_inode(&iloc);
+	if ((EXT4_INODE_SIZE(sb) <=
+	     EXT4_GOOD_OLD_INODE_SIZE) ||
+	    (!EXT4_FITS_IN_INODE(raw_inode, ei, i_projid))) {
+	    	err = -EFBIG;
+	    	goto project_stop;
 	}
+
+	transfer_to[PRJQUOTA] = dqget(sb, make_kqid_projid(kprojid));
+	if (!transfer_to[PRJQUOTA])
+		goto project_set;
+
+	err = __dquot_transfer(inode, transfer_to);
+	dqput(transfer_to[PRJQUOTA]);
+	if (err)
+		goto project_stop;
+
+project_set:
+	EXT4_I(inode)->i_projid = kprojid;
+	inode->i_ctime = ext4_current_time(inode);
+	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
+project_stop:
+	ext4_journal_stop(handle);
+project_out:
+	mutex_unlock(&inode->i_mutex);
+	mnt_drop_write_file(filp);
+	return err;
+}
+
+long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode = file_inode(filp);
+	struct super_block *sb = inode->i_sb;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	unsigned int flags;
+
+	ext4_debug("cmd = %u, arg = %lu\n", cmd, arg);
+
+	switch (cmd) {
+	case EXT4_IOC_GETFLAGS:
+		ext4_get_inode_flags(ei);
+		flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
+		return put_user(flags, (int __user *) arg);
+	case EXT4_IOC_SETFLAGS:
+		if (get_user(flags, (int __user *) arg))
+			return -EFAULT;
+		return ext4_ioctl_setflags(filp, flags);
 	case EXT4_IOC_GETVERSION:
 	case EXT4_IOC_GETVERSION_OLD:
 		return put_user(inode->i_generation, (int __user *) arg);
@@ -617,7 +713,45 @@ resizefs_out:
 	}
 	case EXT4_IOC_PRECACHE_EXTENTS:
 		return ext4_ext_precache(inode);
+	case EXT4_IOC_FSGETXATTR:
+	{
+		struct fsxattr fa;
+
+		memset(&fa, 0, sizeof(struct fsxattr));
+
+		ext4_get_inode_flags(ei);
+		fa.fsx_xflags = ei->i_flags & EXT4_FL_USER_VISIBLE;
+
+		if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+				EXT4_FEATURE_RO_COMPAT_PROJECT)) {
+			fa.fsx_projid = (__u32)from_kprojid(&init_user_ns,
+				EXT4_I(inode)->i_projid);
+		}
+
+		if (copy_to_user((struct fsxattr __user *)arg,
+				 &fa, sizeof(fa)))
+			return -EFAULT;
+		return 0;
+	}
+	case EXT4_IOC_FSSETXATTR:
+	{
+		struct fsxattr fa;
+		int err;
+
+		if (copy_from_user(&fa, (struct fsxattr __user *)arg,
+				   sizeof(fa)))
+			return -EFAULT;
 
+		err = ext4_ioctl_setflags(filp, fa.fsx_xflags);
+		if (err)
+			return err;
+
+		err = ext4_ioctl_setproject(filp, fa.fsx_projid);
+		if (err)
+			return err;
+
+		return 0;
+	}
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index 18dc721..5dd6013 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -36,19 +36,6 @@ struct dioattr {
 #endif
 
 /*
- * Structure for XFS_IOC_FSGETXATTR[A] and XFS_IOC_FSSETXATTR.
- */
-#ifndef HAVE_FSXATTR
-struct fsxattr {
-	__u32		fsx_xflags;	/* xflags field value (get/set) */
-	__u32		fsx_extsize;	/* extsize field value (get/set)*/
-	__u32		fsx_nextents;	/* nextents field value (get)	*/
-	__u32		fsx_projid;	/* project identifier (get/set) */
-	unsigned char	fsx_pad[12];
-};
-#endif
-
-/*
  * Flags for the bs_xflags/fsx_xflags field
  * There should be a one-to-one correspondence between these flags and the
  * XFS_DIFLAG_s.
@@ -503,8 +490,8 @@ typedef struct xfs_swapext
 #define XFS_IOC_ALLOCSP		_IOW ('X', 10, struct xfs_flock64)
 #define XFS_IOC_FREESP		_IOW ('X', 11, struct xfs_flock64)
 #define XFS_IOC_DIOINFO		_IOR ('X', 30, struct dioattr)
-#define XFS_IOC_FSGETXATTR	_IOR ('X', 31, struct fsxattr)
-#define XFS_IOC_FSSETXATTR	_IOW ('X', 32, struct fsxattr)
+#define XFS_IOC_FSGETXATTR	FS_IOC_FSGETXATTR
+#define XFS_IOC_FSSETXATTR	FS_IOC_FSSETXATTR
 #define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
 #define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
 #define XFS_IOC_GETBMAP		_IOWR('X', 38, struct getbmap)
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 3735fa0..78bcb2b 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -58,6 +58,25 @@ struct inodes_stat_t {
 	long dummy[5];		/* padding for sysctl ABI compatibility */
 };
 
+/*
+ * Extend attribute flags. These should be or-ed together to figure out what
+ * is valid.
+ */
+#define FSX_XFLAGS	(1 << 0)
+#define FSX_EXTSIZE	(1 << 1)
+#define FSX_NEXTENTS	(1 << 2)
+#define FSX_PROJID	(1 << 3)
+
+/*
+ * Structure for FS_IOC_FSGETXATTR and FS_IOC_FSSETXATTR.
+ */
+struct fsxattr {
+	__u32		fsx_xflags;	/* xflags field value (get/set) */
+	__u32		fsx_extsize;	/* extsize field value (get/set)*/
+	__u32		fsx_nextents;	/* nextents field value (get)	*/
+	__u32		fsx_projid;	/* project identifier (get/set) */
+	unsigned char	fsx_pad[12];
+};
 
 #define NR_FILE  8192	/* this can well be larger on a larger system */
 
@@ -163,6 +182,8 @@ struct inodes_stat_t {
 #define	FS_IOC_GETVERSION		_IOR('v', 1, long)
 #define	FS_IOC_SETVERSION		_IOW('v', 2, long)
 #define FS_IOC_FIEMAP			_IOWR('f', 11, struct fiemap)
+#define FS_IOC_FSGETXATTR		_IOR('f', 31, struct fsxattr)
+#define FS_IOC_FSSETXATTR		_IOW('f', 32, struct fsxattr)
 #define FS_IOC32_GETFLAGS		_IOR('f', 1, int)
 #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
 #define FS_IOC32_GETVERSION		_IOR('v', 1, int)
-- 
1.7.1

