From: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [v5 4/5] Adds ioctl interface support for ext4 project
Date: Sun, 26 Oct 2014 13:22:52 +0800
Message-ID: <1414300973-1118-5-git-send-email-lixi@ddn.com>
References: <1414300973-1118-1-git-send-email-lixi@ddn.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414300973-1118-1-git-send-email-lixi-LfVdkaOWEx8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch adds ioctl interface for setting/getting project of ext4.

Signed-off-by: Li Xi <lixi-LfVdkaOWEx8@public.gmane.org>
---
 Documentation/filesystems/ext4.txt |    4 ++
 fs/ext4/ext4.h                     |    2 +
 fs/ext4/ioctl.c                    |  102 ++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 919a329..9c98e62 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -609,6 +609,10 @@ EXT4_IOC_SWAP_BOOT	      Swap i_blocks and associated attributes
 			      The data blocks of the previous boot loader
 			      will be associated with the given inode.
 
+ EXT4_IOC_GETPROJECT	      Get project ID associated with inode.
+
+ EXT4_IOC_SETPROJECT	      Set Project ID associated with inode.
+
 ..............................................................................
 
 References
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4c797da..f0e3e08 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -617,6 +617,8 @@ enum {
 #define EXT4_IOC_RESIZE_FS		_IOW('f', 16, __u64)
 #define EXT4_IOC_SWAP_BOOT		_IO('f', 17)
 #define EXT4_IOC_PRECACHE_EXTENTS	_IO('f', 18)
+#define EXT4_IOC_GETPROJECT		_IOR('f', 19, long)
+#define EXT4_IOC_SETPROJECT		_IOW('f', 20, long)
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index bfda18a..b685c42 100644
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
@@ -198,6 +200,85 @@ journal_err_out:
 	return err;
 }
 
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
+	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_PROJECT))
+		return -EOPNOTSUPP;
+
+	kprojid = make_kprojid(&init_user_ns, (projid_t)projid);
+
+	if (projid_eq(kprojid, EXT4_I(inode)->i_projid))
+		return 0;
+
+	err = mnt_want_write_file(filp);
+	if (err)
+		return err;
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
+	}
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
 long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -618,6 +699,27 @@ resizefs_out:
 	case EXT4_IOC_PRECACHE_EXTENTS:
 		return ext4_ext_precache(inode);
 
+	case EXT4_IOC_GETPROJECT:
+	{
+		__u32 projid;
+
+		if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
+				EXT4_FEATURE_RO_COMPAT_PROJECT))
+			return -EOPNOTSUPP;
+
+		projid = (__u32)from_kprojid(&init_user_ns,
+					     EXT4_I(inode)->i_projid);
+		return put_user(projid, (__u32 __user *) arg);
+	}
+	case EXT4_IOC_SETPROJECT:
+	{
+		__u32 projid;
+
+		if (get_user(projid, (__u32 __user *) arg))
+			return -EFAULT;
+
+		return ext4_ioctl_setproject(filp, projid);
+	}
 	default:
 		return -ENOTTY;
 	}
-- 
1.7.1
