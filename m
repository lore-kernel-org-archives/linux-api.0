From: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/5] add metadata_incore ioctl in vfs
Date: Wed, 05 Jan 2011 10:17:16 +0800
Message-ID: <1294193836.1949.384.camel@sli10-conroe>
References: <1294119632.1949.366.camel@sli10-conroe>
	 <201101041040.31482.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201101041040.31482.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2011-01-04 at 17:40 +0800, Arnd Bergmann wrote:
> On Tuesday 04 January 2011 06:40:32 Shaohua Li wrote:
> 
> > +static int ioctl_metadata_incore(struct file *filp, void __user *argp)
> > +{
> > +       struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
> > +       struct metadata_incore_args args;
> > +       struct metadata_incore_ent ent;
> > +       loff_t offset, last_offset = 0;
> > +       ssize_t size, last_size = 0;
> > +       __u64 __user vec_addr;
> 
> __user only makes sense on pointers. Just make this a "struct
> metadata_incore_ent __user *", which will also take care of the
> "sparse" warnings you get from the copy_to_user lines below.
thanks for your comments.
ok, fixed it.

> >  
> > +struct metadata_incore_ent {
> > +       __u64 offset;
> > +       __u32 size;
> > +       __u32 unused;
> > +};
> > +
> > +struct metadata_incore_args {
> > +       __u64 offset; /* offset in meta address */
> > +       __u64 __user vec_addr; /* vector's address */
> > +       __u32 vec_size; /* vector's size */
> > +       __u32 unused;
> > +};
> 
> We usually try hard to avoid ioctls with indirect pointers
> in them. The implementation is correct (most people
> get this wrong), besides the extraneous __user keyword in
> there.
fixed the extraneous __user.

> Have you tried passing just a single metadata_incore_ent
> at the ioctl and looping in user space? I would guess the
> extra overhead of that would be small enough, but that might
> need to be measured.
metadata usually isn't continuous, so this means we have a lot of
metadata_incore_ent entries. And this is called at boot time and I want
to make the overhead as low as possible to not impact boot. Unless there
are certain reasons we can't use indirect pointers, I'd like to make
kernel return a vector of entries.
updated patch follows.

Thanks,
Shaohua


Subject: add metadata_incore ioctl in vfs

Add an ioctl to dump filesystem's metadata in memory in vfs. Userspace collects
such info and uses it to do metadata readahead.
Filesystem can hook to super_operations.metadata_incore to get metadata in
specific approach. Next patch will give an example how to implement
.metadata_incore in btrfs.

Signed-off-by: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
 fs/compat_ioctl.c  |    2 +
 fs/ioctl.c         |   77 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |   15 ++++++++++
 3 files changed, 94 insertions(+)

Index: linux/fs/ioctl.c
===================================================================
--- linux.orig/fs/ioctl.c	2011-01-04 10:25:11.000000000 +0800
+++ linux/fs/ioctl.c	2011-01-05 09:53:09.000000000 +0800
@@ -530,6 +530,80 @@ static int ioctl_fsthaw(struct file *fil
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
+	__u64 vec_addr;
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
+		if (copy_to_user((void __user *)(long)vec_addr, &ent,
+				sizeof(ent)))
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
+		if (copy_to_user((void __user *)(long)vec_addr, &ent,
+				sizeof(ent)))
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
@@ -589,6 +663,9 @@ int do_vfs_ioctl(struct file *filp, unsi
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
--- linux.orig/include/linux/fs.h	2011-01-04 10:25:11.000000000 +0800
+++ linux/include/linux/fs.h	2011-01-05 09:10:12.000000000 +0800
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
+	__u64 vec_addr; /* vector's address */
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
--- linux.orig/fs/compat_ioctl.c	2011-01-04 10:25:11.000000000 +0800
+++ linux/fs/compat_ioctl.c	2011-01-05 08:58:06.000000000 +0800
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
