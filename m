From: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/5] add metadata_incore ioctl in vfs
Date: Thu, 06 Jan 2011 15:45:07 +0800
Message-ID: <1294299907.1949.582.camel@sli10-conroe>
References: <1294119632.1949.366.camel@sli10-conroe>
	 <201101051042.37181.arnd@arndb.de> <1294276437.1949.578.camel@sli10-conroe>
	 <201101060838.49359.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201101060838.49359.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2011-01-06 at 15:38 +0800, Arnd Bergmann wrote:
> On Thursday 06 January 2011, Shaohua Li wrote:
> > I don't understand. adding a case statement in compat_sys_ioctl, so we will do
> > compat_ioctl_check_table(). If I add COMPATIBLE_IOCTL(), then the check
> > will success, we will go to the found_handler code path and execute
> > do_vfs_ioctl, which is what we want. if not adding COMPATIBLE_IOCTL(),
> > the check will fail, and in any case, we will go to the out_fput code
> > path, so our ioctl does nothing.
> 
> You are correct, I misremembered the code and did not check properly.
> 
> > > Two more general comments:
> > > 
> > > - You probably want to add the ioctls to file_ioctl instead of do_vfs_ioctl,
> > >   so you don't add another case statement to the common path.
> > > 
> > > - I don't know if there are any rules for what should be an ioctl or an
> > >   fcntl, we're rather inconsistent about this. If you have found a good
> > >   reason for making it an ioctl, just put that into the changelog so we
> > >   can refer to it next time.
> > it can be applied to a directory too. I thought file_ioctl or fcntl is
> > for file.
> 
> Right again, good point!
ok, below is my latest patch after adopting your comments.

Subject: add metadata_incore ioctl in vfs

Add an ioctl to dump filesystem's metadata in memory in vfs. Userspace collects
such info and uses it to do metadata readahead.
Filesystem can hook to super_operations.metadata_incore to get metadata in
specific approach. Next patch will give an example how to implement
.metadata_incore in btrfs.

Signed-off-by: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
 fs/compat_ioctl.c  |    2 ++
 fs/ioctl.c         |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |   10 ++++++++++
 3 files changed, 54 insertions(+)

Index: linux/fs/ioctl.c
===================================================================
--- linux.orig/fs/ioctl.c	2011-01-06 09:15:22.000000000 +0800
+++ linux/fs/ioctl.c	2011-01-06 09:35:12.000000000 +0800
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
--- linux.orig/include/linux/fs.h	2011-01-06 09:15:22.000000000 +0800
+++ linux/include/linux/fs.h	2011-01-06 09:31:36.000000000 +0800
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
@@ -325,6 +332,7 @@ struct inodes_stat_t {
 #define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
 #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
 #define FITRIM		_IOWR('X', 121, struct fstrim_range)	/* Trim */
+#define FIMETADATA_INCORE _IOWR('X', 122, struct metadata_incore_args)
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -1613,6 +1621,8 @@ struct super_operations {
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
+	int (*metadata_incore)(struct super_block*, loff_t *offset,
+		ssize_t *size);
 };
 
 /*
Index: linux/fs/compat_ioctl.c
===================================================================
--- linux.orig/fs/compat_ioctl.c	2011-01-06 09:15:22.000000000 +0800
+++ linux/fs/compat_ioctl.c	2011-01-06 09:15:24.000000000 +0800
@@ -882,6 +882,7 @@ COMPATIBLE_IOCTL(FIGETBSZ)
 /* 'X' - originally XFS but some now in the VFS */
 COMPATIBLE_IOCTL(FIFREEZE)
 COMPATIBLE_IOCTL(FITHAW)
+COMPATIBLE_IOCTL(FIMETADATA_INCORE)
 COMPATIBLE_IOCTL(KDGETKEYCODE)
 COMPATIBLE_IOCTL(KDSETKEYCODE)
 COMPATIBLE_IOCTL(KDGKBTYPE)
@@ -1577,6 +1578,7 @@ asmlinkage long compat_sys_ioctl(unsigne
 	case FIONBIO:
 	case FIOASYNC:
 	case FIOQSIZE:
+	case FIMETADATA_INCORE:
 		break;
 
 #if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
