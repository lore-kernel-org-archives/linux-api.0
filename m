From: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 3/5]add metadata_readahead ioctl in vfs
Date: Wed, 19 Jan 2011 09:15:22 +0800
Message-ID: <1295399722.1949.866.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Wu, Fengguang" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Subject: add metadata_readahead ioctl in vfs

Add metadata readahead ioctl in vfs. Filesystem can hook to
super_operations.metadata_readahead to handle filesystem specific task.
Next patch will give an example how btrfs implements it.

Signed-off-by: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 fs/compat_ioctl.c  |    2 ++
 fs/ioctl.c         |   21 +++++++++++++++++++++
 include/linux/fs.h |    8 ++++++++
 3 files changed, 31 insertions(+)

Index: linux/fs/ioctl.c
===================================================================
--- linux.orig/fs/ioctl.c	2011-01-18 10:39:40.000000000 +0800
+++ linux/fs/ioctl.c	2011-01-18 10:41:37.000000000 +0800
@@ -568,6 +568,24 @@ static int ioctl_metadata_incore(struct
 	return 1;
 }
 
+static int ioctl_metadata_readahead(struct file *filp, void __user *argp)
+{
+	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+	struct metadata_readahead_args args;
+
+	if (!sb->s_op->metadata_readahead)
+		return -EINVAL;
+
+	if (copy_from_user(&args, argp, sizeof(args)))
+		return -EFAULT;
+
+	/* readahead in page unit */
+	if ((args.offset & ~PAGE_CACHE_MASK) || (args.size & ~PAGE_CACHE_MASK))
+		return -EINVAL;
+
+	return sb->s_op->metadata_readahead(sb, args.offset, args.size);
+}
+
 /*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
@@ -631,6 +649,9 @@ int do_vfs_ioctl(struct file *filp, unsi
 	case FIMETADATA_INCORE:
 		return ioctl_metadata_incore(filp, argp);
 
+	case FIMETADATA_READAHEAD:
+		return ioctl_metadata_readahead(filp, argp);
+
 	default:
 		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2011-01-18 10:39:40.000000000 +0800
+++ linux/include/linux/fs.h	2011-01-18 10:41:37.000000000 +0800
@@ -60,6 +60,11 @@ struct metadata_incore_args {
 	__u32 unused;
 };
 
+struct metadata_readahead_args {
+	__u64 offset;
+	__u64 size;
+};
+
 #define NR_FILE  8192	/* this can well be larger on a larger system */
 
 #define MAY_EXEC 1
@@ -335,6 +340,7 @@ struct metadata_incore_args {
 #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
 #define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
 #define FIMETADATA_INCORE _IOWR('X', 122, struct metadata_incore_args)
+#define FIMETADATA_READAHEAD _IOW('X', 123, struct metadata_readahead_args)
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -1636,6 +1642,8 @@ struct super_operations {
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
 	int (*metadata_incore)(struct super_block*, loff_t *offset,
 		ssize_t *size);
+	int (*metadata_readahead)(struct super_block*, loff_t offset,
+		ssize_t size);
 };
 
 /*
Index: linux/fs/compat_ioctl.c
===================================================================
--- linux.orig/fs/compat_ioctl.c	2011-01-18 10:39:40.000000000 +0800
+++ linux/fs/compat_ioctl.c	2011-01-18 10:41:37.000000000 +0800
@@ -884,6 +884,7 @@ COMPATIBLE_IOCTL(FIGETBSZ)
 COMPATIBLE_IOCTL(FIFREEZE)
 COMPATIBLE_IOCTL(FITHAW)
 COMPATIBLE_IOCTL(FIMETADATA_INCORE)
+COMPATIBLE_IOCTL(FIMETADATA_READAHEAD)
 COMPATIBLE_IOCTL(KDGETKEYCODE)
 COMPATIBLE_IOCTL(KDSETKEYCODE)
 COMPATIBLE_IOCTL(KDGKBTYPE)
@@ -1580,6 +1581,7 @@ asmlinkage long compat_sys_ioctl(unsigne
 	case FIOASYNC:
 	case FIOQSIZE:
 	case FIMETADATA_INCORE:
+	case FIMETADATA_READAHEAD:
 		break;
 
 #if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
