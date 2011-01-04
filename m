From: Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH v2 1/5] add metadata_incore ioctl in vfs
Date: Tue, 04 Jan 2011 13:40:32 +0800
Message-ID: <1294119632.1949.366.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Arjan van de Ven <arjan@infradead.org>, "Yan, Zheng" <zheng.z.yan@linux.intel.com>, linux-api@vger.kernel.org, mtk.manpages@gmail.com
List-Id: linux-api@vger.kernel.org

Add an ioctl to dump filesystem's metadata in memory in vfs. Userspace collects
such info and uses it to do metadata readahead.
Filesystem can hook to super_operations.metadata_incore to get metadata in
specific approach. Next patch will give an example how to implement
.metadata_incore in btrfs.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 fs/compat_ioctl.c  |    1 
 fs/ioctl.c         |   75 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |   15 ++++++++++
 3 files changed, 91 insertions(+)

Index: linux/fs/ioctl.c
===================================================================
--- linux.orig/fs/ioctl.c	2010-12-31 08:52:00.000000000 +0800
+++ linux/fs/ioctl.c	2011-01-03 21:15:48.000000000 +0800
@@ -530,6 +530,78 @@ static int ioctl_fsthaw(struct file *fil
 }
 
 /*
+ * Copy info about metadata in memory to userspace
+ * Returns:
+ * > 0, number of metadata_incore_ent entries copied to userspace
+ * = 0, no more metadata
+ * < 0, error
+ */
+static int ioctl_metadata_incore(struct file *filp, void __user *argp)
+{
+	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+	struct metadata_incore_args args;
+	struct metadata_incore_ent ent;
+	loff_t offset, last_offset = 0;
+	ssize_t size, last_size = 0;
+	__u64 __user vec_addr;
+	int entries = 0;
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
+	if ((args.vec_size % sizeof(struct metadata_incore_ent)) != 0)
+		return -EINVAL;
+
+	offset = args.offset;
+
+	ent.unused = 0;
+	vec_addr = args.vec_addr;
+
+	while (vec_addr < args.vec_addr + args.vec_size) {
+		if (signal_pending(current))
+			return -EINTR;
+		cond_resched();
+
+		if (sb->s_op->metadata_incore(sb, &offset, &size) < 0)
+			break;
+		/* A merge or offset == 0 */
+		if (offset == last_offset + last_size) {
+			last_size += size;
+			offset = offset + size;
+			continue;
+		}
+		ent.offset = last_offset;
+		ent.size = last_size;
+		if (copy_to_user((void *)(long)vec_addr, &ent, sizeof(ent)))
+			return -EFAULT;
+		vec_addr += sizeof(ent);
+		entries++;
+
+		last_offset = offset;
+		last_size = size;
+		ent.unused = 0;
+		offset = offset + size;
+	}
+
+	if (last_size > 0 && vec_addr < args.vec_addr + args.vec_size) {
+		ent.offset = last_offset;
+		ent.size = last_size;
+		if (copy_to_user((void *)(long)vec_addr, &ent, sizeof(ent)))
+			return -EFAULT;
+		entries++;
+	}
+
+	return entries;
+}
+
+/*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
  *
@@ -589,6 +661,9 @@ int do_vfs_ioctl(struct file *filp, unsi
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
--- linux.orig/include/linux/fs.h	2010-12-31 08:51:35.000000000 +0800
+++ linux/include/linux/fs.h	2011-01-03 21:15:48.000000000 +0800
@@ -52,6 +52,18 @@ struct inodes_stat_t {
 	int dummy[5];		/* padding for sysctl ABI compatibility */
 };
 
+struct metadata_incore_ent {
+	__u64 offset;
+	__u32 size;
+	__u32 unused;
+};
+
+struct metadata_incore_args {
+	__u64 offset; /* offset in meta address */
+	__u64 __user vec_addr; /* vector's address */
+	__u32 vec_size; /* vector's size */
+	__u32 unused;
+};
 
 #define NR_FILE  8192	/* this can well be larger on a larger system */
 
@@ -325,6 +337,7 @@ struct inodes_stat_t {
 #define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
 #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
 #define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
+#define FIMETADATA_INCORE _IOWR('X', 122, struct metadata_incore_args)
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -1613,6 +1626,8 @@ struct super_operations {
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
+	int (*metadata_incore)(struct super_block*, loff_t *offset,
+		ssize_t *size);
 };
 
 /*
Index: linux/fs/compat_ioctl.c
===================================================================
--- linux.orig/fs/compat_ioctl.c	2010-12-31 08:52:00.000000000 +0800
+++ linux/fs/compat_ioctl.c	2011-01-03 21:15:48.000000000 +0800
@@ -882,6 +882,7 @@ COMPATIBLE_IOCTL(FIGETBSZ)
 /* 'X' - originally XFS but some now in the VFS */
 COMPATIBLE_IOCTL(FIFREEZE)
 COMPATIBLE_IOCTL(FITHAW)
+COMPATIBLE_IOCTL(FIMETADATA_INCORE)
 COMPATIBLE_IOCTL(KDGETKEYCODE)
 COMPATIBLE_IOCTL(KDSETKEYCODE)
 COMPATIBLE_IOCTL(KDGKBTYPE)


