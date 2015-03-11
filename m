From: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [v9 4/5] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface support
Date: Wed, 11 Mar 2015 12:03:22 +0900
Message-ID: <1426043003-31043-5-git-send-email-lixi@ddn.com>
References: <1426043003-31043-1-git-send-email-lixi@ddn.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426043003-31043-1-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR ioctl interface
support for ext4. The interface is kept consistent with
XFS_IOC_FSGETXATTR/XFS_IOC_FSGETXATTR.

Signed-off-by: Li Xi <lixi-LfVdkaOWEx8@public.gmane.org>
---
 fs/ext4/ext4.h          |   47 +++++++
 fs/ext4/ioctl.c         |  341 +++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_fs.h         |   47 +++----
 include/uapi/linux/fs.h |   32 +++++
 4 files changed, 338 insertions(+), 129 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3443456..2f4b9ba 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -385,6 +385,51 @@ struct flex_groups {
 #define EXT4_FL_USER_VISIBLE		0x204BDFFF /* User visible flags */
 #define EXT4_FL_USER_MODIFIABLE		0x204380FF /* User modifiable flags */
 
+#define EXT4_FL_XFLAG_VISIBLE		(EXT4_SYNC_FL | \
+					 EXT4_IMMUTABLE_FL | \
+					 EXT4_APPEND_FL | \
+					 EXT4_NOATIME_FL | \
+					 EXT4_PROJINHERIT_FL)
+
+/* Transfer internal flags to xflags */
+static inline __u32 ext4_iflags_to_xflags(unsigned long iflags)
+{
+	__u32 xflags = 0;
+
+	if (iflags & EXT4_SYNC_FL)
+		xflags |= FS_XFLAG_SYNC;
+	if (iflags & EXT4_IMMUTABLE_FL)
+		xflags |= FS_XFLAG_IMMUTABLE;
+	if (iflags & EXT4_APPEND_FL)
+		xflags |= FS_XFLAG_APPEND;
+	if (iflags & EXT4_NOATIME_FL)
+		xflags |= FS_XFLAG_NOATIME;
+	if (iflags & EXT4_PROJINHERIT_FL)
+		xflags |= FS_XFLAG_PROJINHERIT;
+	return xflags;
+}
+
+/* Transfer xflags flags to internal */
+static inline unsigned long ext4_xflags_to_iflags(__u32 xflags)
+{
+	unsigned long iflags = 0;
+
+	if (xflags & FS_XFLAG_SYNC)
+		iflags |= EXT4_SYNC_FL;
+	if (xflags & FS_XFLAG_IMMUTABLE)
+		iflags |= EXT4_IMMUTABLE_FL;
+	if (xflags & FS_XFLAG_APPEND)
+		iflags |= EXT4_APPEND_FL;
+	if (xflags & FS_XFLAG_NODUMP)
+		iflags |= EXT4_NODUMP_FL;
+	if (xflags & FS_XFLAG_NOATIME)
+		iflags |= EXT4_NOATIME_FL;
+	if (xflags & FS_XFLAG_PROJINHERIT)
+		iflags |= EXT4_PROJINHERIT_FL;
+
+	return iflags;
+}
+
 /* Flags that should be inherited by new inodes from their parent. */
 #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
 			   EXT4_SYNC_FL | EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
@@ -607,6 +652,8 @@ enum {
 #define EXT4_IOC_RESIZE_FS		_IOW('f', 16, __u64)
 #define EXT4_IOC_SWAP_BOOT		_IO('f', 17)
 #define EXT4_IOC_PRECACHE_EXTENTS	_IO('f', 18)
+#define EXT4_IOC_FSGETXATTR		FS_IOC_FSGETXATTR
+#define EXT4_IOC_FSSETXATTR		FS_IOC_FSSETXATTR
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index f58a0d1..20a6337 100644
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
@@ -196,126 +198,229 @@ journal_err_out:
 	return err;
 }
 
-long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+static int ext4_ioctl_setflags(struct file *filp,
+			       unsigned int flags, int is_from_xflags)
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
+	if (is_from_xflags)
+		flags &= EXT4_FL_XFLAG_VISIBLE;
+
+	err = -EPERM;
+	mutex_lock(&inode->i_mutex);
+	/* Is it quota file? Do not allow user to mess with it */
+	if (IS_NOQUOTA(inode))
+		goto flags_out;
+
+	oldflags = ei->i_flags;
+	if (is_from_xflags)
+		oldflags &= EXT4_FL_XFLAG_VISIBLE;
+
+	/* The JOURNAL_DATA flag is modifiable only by root */
+	jflag = flags & EXT4_JOURNAL_DATA_FL;
+	if (is_from_xflags)
+		jflag &= EXT4_FL_XFLAG_VISIBLE;
+
+	/*
+	 * The IMMUTABLE and APPEND_ONLY flags can only be changed by
+	 * the relevant capability.
+	 *
+	 * This test looks nicer. Thanks to Pauline Middelink
+	 */
+	if ((flags ^ oldflags) & (EXT4_APPEND_FL | EXT4_IMMUTABLE_FL)) {
+		if (!capable(CAP_LINUX_IMMUTABLE))
+			goto flags_out;
+	}
 
-		if (get_user(flags, (int __user *) arg))
-			return -EFAULT;
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
+		if (flags & EXT4_EOFBLOCKS_FL) {
+		/* we don't support adding EOFBLOCKS flag */
+		if (!(oldflags & EXT4_EOFBLOCKS_FL)) {
+			err = -EOPNOTSUPP;
+			goto flags_out;
+		}
+	} else if (oldflags & EXT4_EOFBLOCKS_FL)
+		ext4_truncate(inode);
 
-		err = mnt_want_write_file(filp);
-		if (err)
-			return err;
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
+		if (is_from_xflags && !(mask & EXT4_FL_XFLAG_VISIBLE))
+			continue;
+		if (mask & flags)
+			ext4_set_inode_flag(inode, i);
+		else
+			ext4_clear_inode_flag(inode, i);
+	}
 
-		flags = ext4_mask_flags(inode->i_mode, flags);
+	ext4_set_inode_flags(inode);
+	inode->i_ctime = ext4_current_time(inode);
 
-		err = -EPERM;
-		mutex_lock(&inode->i_mutex);
-		/* Is it quota file? Do not allow user to mess with it */
-		if (IS_NOQUOTA(inode))
-			goto flags_out;
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
 
-		oldflags = ei->i_flags;
+flags_out:
+	mutex_unlock(&inode->i_mutex);
+	mnt_drop_write_file(filp);
+	return err;
+}
 
-		/* The JOURNAL_DATA flag is modifiable only by root */
-		jflag = flags & EXT4_JOURNAL_DATA_FL;
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
+	kprojid = make_kprojid(&init_user_ns, (projid_t)projid);
 
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
+	if (projid_eq(kprojid, EXT4_I(inode)->i_projid))
+		return 0;
 
-		if (flags & EXT4_EOFBLOCKS_FL) {
-			/* we don't support adding EOFBLOCKS flag */
-			if (!(oldflags & EXT4_EOFBLOCKS_FL)) {
-				err = -EOPNOTSUPP;
-				goto flags_out;
-			}
-		} else if (oldflags & EXT4_EOFBLOCKS_FL)
-			ext4_truncate(inode);
+	err = mnt_want_write_file(filp);
+	if (err)
+		return err;
 
-		handle = ext4_journal_start(inode, EXT4_HT_INODE, 1);
-		if (IS_ERR(handle)) {
-			err = PTR_ERR(handle);
-			goto flags_out;
-		}
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
+	err = -EPERM;
+	mutex_lock(&inode->i_mutex);
+	/* Is it quota file? Do not allow user to mess with it */
+	if (IS_NOQUOTA(inode))
+		goto project_out;
 
-		ext4_set_inode_flags(inode);
-		inode->i_ctime = ext4_current_time(inode);
+	dquot_initialize(inode);
 
-		err = ext4_mark_iloc_dirty(handle, inode, &iloc);
-flags_err:
-		ext4_journal_stop(handle);
-		if (err)
-			goto flags_out;
+	handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
+		EXT4_QUOTA_INIT_BLOCKS(sb) +
+		EXT4_QUOTA_DEL_BLOCKS(sb) + 3);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		goto project_out;
+	}
 
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
+	err = ext4_reserve_inode_write(handle, inode, &iloc);
+	if (err)
+		goto project_stop;
 
-flags_out:
-		mutex_unlock(&inode->i_mutex);
-		mnt_drop_write_file(filp);
-		return err;
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
+		return ext4_ioctl_setflags(filp, flags, 0);
 	case EXT4_IOC_GETVERSION:
 	case EXT4_IOC_GETVERSION_OLD:
 		return put_user(inode->i_generation, (int __user *) arg);
@@ -615,7 +720,45 @@ resizefs_out:
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
+		fa.fsx_xflags = ext4_iflags_to_xflags(ei->i_flags & EXT4_FL_USER_VISIBLE);
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
 
+		err = ext4_ioctl_setflags(filp, ext4_xflags_to_iflags(fa.fsx_xflags), 1);
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
index 18dc721..64c7ae6 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -36,38 +36,25 @@ struct dioattr {
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
  */
-#define XFS_XFLAG_REALTIME	0x00000001	/* data in realtime volume */
-#define XFS_XFLAG_PREALLOC	0x00000002	/* preallocated file extents */
-#define XFS_XFLAG_IMMUTABLE	0x00000008	/* file cannot be modified */
-#define XFS_XFLAG_APPEND	0x00000010	/* all writes append */
-#define XFS_XFLAG_SYNC		0x00000020	/* all writes synchronous */
-#define XFS_XFLAG_NOATIME	0x00000040	/* do not update access time */
-#define XFS_XFLAG_NODUMP	0x00000080	/* do not include in backups */
-#define XFS_XFLAG_RTINHERIT	0x00000100	/* create with rt bit set */
-#define XFS_XFLAG_PROJINHERIT	0x00000200	/* create with parents projid */
-#define XFS_XFLAG_NOSYMLINKS	0x00000400	/* disallow symlink creation */
-#define XFS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
-#define XFS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
-#define XFS_XFLAG_NODEFRAG	0x00002000  	/* do not defragment */
-#define XFS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
-#define XFS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
+#define XFS_XFLAG_REALTIME	FS_XFLAG_REALTIME	/* data in realtime volume */
+#define XFS_XFLAG_PREALLOC	FS_XFLAG_PREALLOC	/* preallocated file extents */
+#define XFS_XFLAG_IMMUTABLE	FS_XFLAG_IMMUTABLE	/* file cannot be modified */
+#define XFS_XFLAG_APPEND	FS_XFLAG_APPEND		/* all writes append */
+#define XFS_XFLAG_SYNC		FS_XFLAG_SYNC		/* all writes synchronous */
+#define XFS_XFLAG_NOATIME	FS_XFLAG_NOATIME	/* do not update access time */
+#define XFS_XFLAG_NODUMP	FS_XFLAG_NODUMP		/* do not include in backups */
+#define XFS_XFLAG_RTINHERIT	FS_XFLAG_RTINHERIT	/* create with rt bit set */
+#define XFS_XFLAG_PROJINHERIT	FS_XFLAG_PROJINHERIT	/* create with parents projid */
+#define XFS_XFLAG_NOSYMLINKS	FS_XFLAG_NOSYMLINKS	/* disallow symlink creation */
+#define XFS_XFLAG_EXTSIZE	FS_XFLAG_EXTSIZE	/* extent size allocator hint */
+#define XFS_XFLAG_EXTSZINHERIT	FS_XFLAG_EXTSZINHERIT	/* inherit inode extent size */
+#define XFS_XFLAG_NODEFRAG	FS_XFLAG_NODEFRAG  	/* do not defragment */
+#define XFS_XFLAG_FILESTREAM	FS_XFLAG_FILESTREAM	/* use filestream allocator */
+#define XFS_XFLAG_HASATTR	FS_XFLAG_HASATTR	/* no DIFLAG for this	*/
 
 /*
  * Structure for XFS_IOC_GETBMAP.
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
index fcbf647..20bb694 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -58,6 +58,36 @@ struct inodes_stat_t {
 	long dummy[5];		/* padding for sysctl ABI compatibility */
 };
 
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
+
+/*
+ * Flags for the fsx_xflags field
+ */
+#define FS_XFLAG_REALTIME	0x00000001	/* data in realtime volume */
+#define FS_XFLAG_PREALLOC	0x00000002	/* preallocated file extents */
+#define FS_XFLAG_IMMUTABLE	0x00000008	/* file cannot be modified */
+#define FS_XFLAG_APPEND		0x00000010	/* all writes append */
+#define FS_XFLAG_SYNC		0x00000020	/* all writes synchronous */
+#define FS_XFLAG_NOATIME	0x00000040	/* do not update access time */
+#define FS_XFLAG_NODUMP		0x00000080	/* do not include in backups */
+#define FS_XFLAG_RTINHERIT	0x00000100	/* create with rt bit set */
+#define FS_XFLAG_PROJINHERIT	0x00000200	/* create with parents projid */
+#define FS_XFLAG_NOSYMLINKS	0x00000400	/* disallow symlink creation */
+#define FS_XFLAG_EXTSIZE	0x00000800	/* extent size allocator hint */
+#define FS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
+#define FS_XFLAG_NODEFRAG	0x00002000  	/* do not defragment */
+#define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
+#define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this */
+
 
 #define NR_FILE  8192	/* this can well be larger on a larger system */
 
@@ -163,6 +193,8 @@ struct inodes_stat_t {
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
