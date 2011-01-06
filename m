From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH v2 3/5]add metadata_readahead ioctl in vfs
Date: Thu, 06 Jan 2011 15:45:09 +0800
Message-ID: <1294299909.1949.583.camel@sli10-conroe>
References: <1294119637.1949.368.camel@sli10-conroe>
	 <1294193496.1949.378.camel@sli10-conroe> <201101051009.20591.arnd@arndb.de>
	 <201101051026.15391.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <201101051026.15391.arnd@arndb.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Arjan van de Ven <arjan@infradead.org>, "Yan, Zheng" <zheng.z.yan@linux.intel.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, 2011-01-05 at 17:26 +0800, Arnd Bergmann wrote:
> On Wednesday 05 January 2011 10:09:20 Arnd Bergmann wrote:
> > > Thanks, fixed them.
> > 
after the patch 1/5 is changed, this patch can still apply but has
hunks. below is the latest refresh patch.

Subject: add metadata_readahead ioctl in vfs

Add metadata readahead ioctl in vfs. Filesystem can hook to
super_operations.metadata_readahead to handle filesystem specific task.
Next patch will give an example how btrfs implements it.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 fs/compat_ioctl.c  |    2 ++
 fs/ioctl.c         |   21 +++++++++++++++++++++
 include/linux/fs.h |    8 ++++++++
 3 files changed, 31 insertions(+)

Index: linux/fs/ioctl.c
===================================================================
--- linux.orig/fs/ioctl.c	2011-01-06 09:35:12.000000000 +0800
+++ linux/fs/ioctl.c	2011-01-06 09:35:22.000000000 +0800
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
--- linux.orig/include/linux/fs.h	2011-01-06 09:31:36.000000000 +0800
+++ linux/include/linux/fs.h	2011-01-06 09:35:22.000000000 +0800
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
@@ -333,6 +338,7 @@ struct metadata_incore_args {
 #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
 #define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
 #define FIMETADATA_INCORE _IOWR('X', 122, struct metadata_incore_args)
+#define FIMETADATA_READAHEAD _IOW('X', 123, struct metadata_readahead_args)
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -1623,6 +1629,8 @@ struct super_operations {
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
 	int (*metadata_incore)(struct super_block*, loff_t *offset,
 		ssize_t *size);
+	int (*metadata_readahead)(struct super_block*, loff_t offset,
+		ssize_t size);
 };
 
 /*
Index: linux/fs/compat_ioctl.c
===================================================================
--- linux.orig/fs/compat_ioctl.c	2011-01-06 09:15:24.000000000 +0800
+++ linux/fs/compat_ioctl.c	2011-01-06 09:35:22.000000000 +0800
@@ -883,6 +883,7 @@ COMPATIBLE_IOCTL(FIGETBSZ)
 COMPATIBLE_IOCTL(FIFREEZE)
 COMPATIBLE_IOCTL(FITHAW)
 COMPATIBLE_IOCTL(FIMETADATA_INCORE)
+COMPATIBLE_IOCTL(FIMETADATA_READAHEAD)
 COMPATIBLE_IOCTL(KDGETKEYCODE)
 COMPATIBLE_IOCTL(KDSETKEYCODE)
 COMPATIBLE_IOCTL(KDGKBTYPE)
@@ -1579,6 +1580,7 @@ asmlinkage long compat_sys_ioctl(unsigne
 	case FIOASYNC:
 	case FIOQSIZE:
 	case FIMETADATA_INCORE:
+	case FIMETADATA_READAHEAD:
 		break;
 
 #if defined(CONFIG_IA64) || defined(CONFIG_X86_64)


