From: Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH v3 1/5] add metadata_incore ioctl in vfs
Date: Wed, 19 Jan 2011 09:15:18 +0800
Message-ID: <1295399718.1949.864.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Arjan van de Ven <arjan@infradead.org>, "Yan, Zheng" <zheng.z.yan@linux.intel.com>, "Wu, Fengguang" <fengguang.wu@intel.com>, linux-api <linux-api@vger.kernel.org>, manpages <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

Subject: add metadata_incore ioctl in vfs

Add an ioctl to dump filesystem's metadata in memory in vfs. Userspace collects
such info and uses it to do metadata readahead.
Filesystem can hook to super_operations.metadata_incore to get metadata in
specific approach. Next patch will give an example how to implement
.metadata_incore in btrfs.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/compat_ioctl.c  |    2 ++
 fs/ioctl.c         |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |   10 ++++++++++
 3 files changed, 54 insertions(+)

Index: linux/fs/ioctl.c
===================================================================
--- linux.orig/fs/ioctl.c	2011-01-18 10:15:17.000000000 +0800
+++ linux/fs/ioctl.c	2011-01-18 10:39:40.000000000 +0800
@@ -530,6 +530,45 @@ static int ioctl_fsthaw(struct file *fil
 }
 
 /*
+ * Copy info about metadata in memory to userspace
+ * Returns:
+ * = 1, one metadata range copied to userspace
+ * = 0, no more metadata
+ * < 0, error
+ */
+static int ioctl_metadata_incore(struct file *filp, void __user *argp)
+{
+	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+	struct metadata_incore_args args;
+	loff_t offset;
+	ssize_t size;
+
+	if (!sb->s_op->metadata_incore)
+		return -EINVAL;
+
+	if (copy_from_user(&args, argp, sizeof(args)))
+		return -EFAULT;
+
+	/* we check metadata info in page unit */
+	if (args.offset & ~PAGE_CACHE_MASK)
+		return -EINVAL;
+
+	offset = args.offset;
+
+	if (sb->s_op->metadata_incore(sb, &offset, &size) < 0)
+		return 0;
+
+	args.address = offset;
+	args.size = size;
+	args.unused = 0;
+
+	if (copy_to_user(argp, &args, sizeof(args)))
+		return -EFAULT;
+
+	return 1;
+}
+
+/*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
  *
@@ -589,6 +628,9 @@ int do_vfs_ioctl(struct file *filp, unsi
 		return put_user(inode->i_sb->s_blocksize, p);
 	}
 
+	case FIMETADATA_INCORE:
+		return ioctl_metadata_incore(filp, argp);
+
 	default:
 		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2011-01-18 10:15:17.000000000 +0800
+++ linux/include/linux/fs.h	2011-01-18 10:39:40.000000000 +0800
@@ -53,6 +53,13 @@ struct inodes_stat_t {
 };
 
 
+struct metadata_incore_args {
+	__u64 offset; /* offset in metadata address */
+	__u64 address; /* returned address of metadata in memory */
+	__u32 size; /* size of the metadata */
+	__u32 unused;
+};
+
 #define NR_FILE  8192	/* this can well be larger on a larger system */
 
 #define MAY_EXEC 1
@@ -327,6 +334,7 @@ struct inodes_stat_t {
 #define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
 #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
 #define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
+#define FIMETADATA_INCORE _IOWR('X', 122, struct metadata_incore_args)
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -1626,6 +1634,8 @@ struct super_operations {
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
+	int (*metadata_incore)(struct super_block*, loff_t *offset,
+		ssize_t *size);
 };
 
 /*
Index: linux/fs/compat_ioctl.c
===================================================================
--- linux.orig/fs/compat_ioctl.c	2011-01-18 09:38:03.000000000 +0800
+++ linux/fs/compat_ioctl.c	2011-01-18 10:39:40.000000000 +0800
@@ -883,6 +883,7 @@ COMPATIBLE_IOCTL(FIGETBSZ)
 /* 'X' - originally XFS but some now in the VFS */
 COMPATIBLE_IOCTL(FIFREEZE)
 COMPATIBLE_IOCTL(FITHAW)
+COMPATIBLE_IOCTL(FIMETADATA_INCORE)
 COMPATIBLE_IOCTL(KDGETKEYCODE)
 COMPATIBLE_IOCTL(KDSETKEYCODE)
 COMPATIBLE_IOCTL(KDGKBTYPE)
@@ -1578,6 +1579,7 @@ asmlinkage long compat_sys_ioctl(unsigne
 	case FIONBIO:
 	case FIOASYNC:
 	case FIOQSIZE:
+	case FIMETADATA_INCORE:
 		break;
 
 #if defined(CONFIG_IA64) || defined(CONFIG_X86_64)


