From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH v4 71/79] include/uapi/linux/fuse.h: use linux/types.h
 also in userspace
Date: Fri, 16 Oct 2015 00:03:29 +0300
Message-ID: <20151015210329.GF6104@lakka.kapsi.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
 <20151015174154.GZ6104@lakka.kapsi.fi>
 <CAJfpegtSK-ttDXN+vz+yzsU9P1m7fDCn2VwXfHyJuWL6-O-g3g@mail.gmail.com>
 <9560422.ZpOrhsmRxt@wuerfel>
 <CAJfpegtYhwMW7vBPXG02fuijfsv3cGCwe9z=LWE56jKqvJwDMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegtYhwMW7vBPXG02fuijfsv3cGCwe9z=LWE56jKqvJwDMw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 15, 2015 at 09:25:30PM +0200, Miklos Szeredi wrote:
> On Thu, Oct 15, 2015 at 8:59 PM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> > On Thursday 15 October 2015 20:32:45 Miklos Szeredi wrote:
> >> > In my other patches I got review comments that kernel headers should not
> >> > use <stdint.h> and also Documentation/CodingStyle section 5 says:
> >> >
> >> >  (e) Types safe for use in userspace.
> >> >
> >> >      In certain structures which are visible to userspace, we cannot
> >> >      require C99 types and cannot use the 'u32' form above. Thus, we
> >> >      use __u32 and similar types in all structures which are shared
> >> >      with userspace.
> >>
> >> Ok, if you cannot require C99, then the __uXX types are the way to go.
> >> But for the fuse API we *can* use C99 types, nothing preventing us
> >> from doing it.
> >
> > What the sentence above means is that you should not rely on the
> > user including <stdint.h> before including a kernel header, and
> > that kernel headers are not allowed to include <stdint.h> themselves,
> > because that would break any pre-C99 user space that defines types
> > with the same names in their own headers and that relies on that
> > header not to be included implicitly.
> >
> > It's possible that it has never been a problem for the fuse headers,
> > but it has been a problem for other headers in the past and what
> > Mikko is trying to achieve is to ensure that none of the kernel
> > headers do this so we can make it an error in 'make headers_install'.
> 
> "in some cases including <stdint.h> might be a problem" is not a very
> strong argument in favour of making it an error.  And since it would
> be a step backwards for the fuse header I object to making it an
> error.
> 
> If this is really such a big issue, then why not make it a warning
> (and add a mechanism to silence that warning)?

I tried compiling fuse userspace library with this patch applied and
it compiles without any problems:

$ make
Making all in include
make[1]: Entering directory '/home/mcfrisk/src/fuse-fuse/include'
make  all-am
make[2]: Entering directory '/home/mcfrisk/src/fuse-fuse/include'
make[2]: Leaving directory '/home/mcfrisk/src/fuse-fuse/include'
make[1]: Leaving directory '/home/mcfrisk/src/fuse-fuse/include'
Making all in lib
make[1]: Entering directory '/home/mcfrisk/src/fuse-fuse/lib'
  CC       fuse.lo
  CC       fuse_loop_mt.lo
  CC       fuse_lowlevel.lo
  CC       cuse_lowlevel.lo
  CCLD     libfuse3.la
ar: `u' modifier ignored since `D' is the default (see `U')
make[1]: Leaving directory '/home/mcfrisk/src/fuse-fuse/lib'
Making all in util
make[1]: Entering directory '/home/mcfrisk/src/fuse-fuse/util'
make  all-am
make[2]: Entering directory '/home/mcfrisk/src/fuse-fuse/util'
make[2]: Nothing to be done for 'all-am'.
make[2]: Leaving directory '/home/mcfrisk/src/fuse-fuse/util'
make[1]: Leaving directory '/home/mcfrisk/src/fuse-fuse/util'
Making all in example
make[1]: Entering directory '/home/mcfrisk/src/fuse-fuse/example'
  CCLD     fusexmp
  CCLD     fusexmp_fh
  CCLD     null
  CCLD     hello
  CCLD     hello_ll
  CCLD     fioc
  CCLD     fsel
  CCLD     cusexmp
  CCLD     fuse_lo-plus
make[1]: Leaving directory '/home/mcfrisk/src/fuse-fuse/example'
Making all in doc
make[1]: Entering directory '/home/mcfrisk/src/fuse-fuse/doc'
make[1]: Nothing to be done for 'all'.
make[1]: Leaving directory '/home/mcfrisk/src/fuse-fuse/doc'
make[1]: Entering directory '/home/mcfrisk/src/fuse-fuse'
make[1]: Nothing to be done for 'all-am'.
make[1]: Leaving directory '/home/mcfrisk/src/fuse-fuse'

$ git diff
diff --git a/include/fuse_kernel.h b/include/fuse_kernel.h
index c9aca04..a25e329 100644
--- a/include/fuse_kernel.h
+++ b/include/fuse_kernel.h
@@ -107,11 +107,7 @@
 #ifndef _LINUX_FUSE_H
 #define _LINUX_FUSE_H
 
-#ifdef __KERNEL__
 #include <linux/types.h>
-#else
-#include <stdint.h>
-#endif
 
 /*
  * Version negotiation:
@@ -146,42 +142,42 @@
    userspace works under 64bit kernels */
 
 struct fuse_attr {
-	uint64_t	ino;
-	uint64_t	size;
-	uint64_t	blocks;
-	uint64_t	atime;
-	uint64_t	mtime;
-	uint64_t	ctime;
-	uint32_t	atimensec;
-	uint32_t	mtimensec;
-	uint32_t	ctimensec;
-	uint32_t	mode;
-	uint32_t	nlink;
-	uint32_t	uid;
-	uint32_t	gid;
-	uint32_t	rdev;
-	uint32_t	blksize;
-	uint32_t	padding;
+	__u64	ino;
+	__u64	size;
+	__u64	blocks;
+	__u64	atime;
+	__u64	mtime;
+	__u64	ctime;
+	__u32	atimensec;
+	__u32	mtimensec;
+	__u32	ctimensec;
+	__u32	mode;
+	__u32	nlink;
+	__u32	uid;
+	__u32	gid;
+	__u32	rdev;
+	__u32	blksize;
+	__u32	padding;
 };
 
 struct fuse_kstatfs {
-	uint64_t	blocks;
-	uint64_t	bfree;
-	uint64_t	bavail;
-	uint64_t	files;
-	uint64_t	ffree;
-	uint32_t	bsize;
-	uint32_t	namelen;
-	uint32_t	frsize;
-	uint32_t	padding;
-	uint32_t	spare[6];
+	__u64	blocks;
+	__u64	bfree;
+	__u64	bavail;
+	__u64	files;
+	__u64	ffree;
+	__u32	bsize;
+	__u32	namelen;
+	__u32	frsize;
+	__u32	padding;
+	__u32	spare[6];
 };
 
 struct fuse_file_lock {
-	uint64_t	start;
-	uint64_t	end;
-	uint32_t	type;
-	uint32_t	pid; /* tgid */
+	__u64	start;
+	__u64	end;
+	__u32	type;
+	__u32	pid; /* tgid */
 };
 
 /**
@@ -379,149 +375,149 @@ enum fuse_notify_code {
 #define FUSE_COMPAT_ENTRY_OUT_SIZE 120
 
 struct fuse_entry_out {
-	uint64_t	nodeid;		/* Inode ID */
-	uint64_t	generation;	/* Inode generation: nodeid:gen must
+	__u64	nodeid;		/* Inode ID */
+	__u64	generation;	/* Inode generation: nodeid:gen must
 					   be unique for the fs's lifetime */
-	uint64_t	entry_valid;	/* Cache timeout for the name */
-	uint64_t	attr_valid;	/* Cache timeout for the attributes */
-	uint32_t	entry_valid_nsec;
-	uint32_t	attr_valid_nsec;
+	__u64	entry_valid;	/* Cache timeout for the name */
+	__u64	attr_valid;	/* Cache timeout for the attributes */
+	__u32	entry_valid_nsec;
+	__u32	attr_valid_nsec;
 	struct fuse_attr attr;
 };
 
 struct fuse_forget_in {
-	uint64_t	nlookup;
+	__u64	nlookup;
 };
 
 struct fuse_forget_one {
-	uint64_t	nodeid;
-	uint64_t	nlookup;
+	__u64	nodeid;
+	__u64	nlookup;
 };
 
 struct fuse_batch_forget_in {
-	uint32_t	count;
-	uint32_t	dummy;
+	__u32	count;
+	__u32	dummy;
 };
 
 struct fuse_getattr_in {
-	uint32_t	getattr_flags;
-	uint32_t	dummy;
-	uint64_t	fh;
+	__u32	getattr_flags;
+	__u32	dummy;
+	__u64	fh;
 };
 
 #define FUSE_COMPAT_ATTR_OUT_SIZE 96
 
 struct fuse_attr_out {
-	uint64_t	attr_valid;	/* Cache timeout for the attributes */
-	uint32_t	attr_valid_nsec;
-	uint32_t	dummy;
+	__u64	attr_valid;	/* Cache timeout for the attributes */
+	__u32	attr_valid_nsec;
+	__u32	dummy;
 	struct fuse_attr attr;
 };
 
 #define FUSE_COMPAT_MKNOD_IN_SIZE 8
 
 struct fuse_mknod_in {
-	uint32_t	mode;
-	uint32_t	rdev;
-	uint32_t	umask;
-	uint32_t	padding;
+	__u32	mode;
+	__u32	rdev;
+	__u32	umask;
+	__u32	padding;
 };
 
 struct fuse_mkdir_in {
-	uint32_t	mode;
-	uint32_t	umask;
+	__u32	mode;
+	__u32	umask;
 };
 
 struct fuse_rename_in {
-	uint64_t	newdir;
+	__u64	newdir;
 };
 
 struct fuse_rename2_in {
-	uint64_t	newdir;
-	uint32_t	flags;
-	uint32_t	padding;
+	__u64	newdir;
+	__u32	flags;
+	__u32	padding;
 };
 
 struct fuse_link_in {
-	uint64_t	oldnodeid;
+	__u64	oldnodeid;
 };
 
 struct fuse_setattr_in {
-	uint32_t	valid;
-	uint32_t	padding;
-	uint64_t	fh;
-	uint64_t	size;
-	uint64_t	lock_owner;
-	uint64_t	atime;
-	uint64_t	mtime;
-	uint64_t	ctime;
-	uint32_t	atimensec;
-	uint32_t	mtimensec;
-	uint32_t	ctimensec;
-	uint32_t	mode;
-	uint32_t	unused4;
-	uint32_t	uid;
-	uint32_t	gid;
-	uint32_t	unused5;
+	__u32	valid;
+	__u32	padding;
+	__u64	fh;
+	__u64	size;
+	__u64	lock_owner;
+	__u64	atime;
+	__u64	mtime;
+	__u64	ctime;
+	__u32	atimensec;
+	__u32	mtimensec;
+	__u32	ctimensec;
+	__u32	mode;
+	__u32	unused4;
+	__u32	uid;
+	__u32	gid;
+	__u32	unused5;
 };
 
 struct fuse_open_in {
-	uint32_t	flags;
-	uint32_t	unused;
+	__u32	flags;
+	__u32	unused;
 };
 
 struct fuse_create_in {
-	uint32_t	flags;
-	uint32_t	mode;
-	uint32_t	umask;
-	uint32_t	padding;
+	__u32	flags;
+	__u32	mode;
+	__u32	umask;
+	__u32	padding;
 };
 
 struct fuse_open_out {
-	uint64_t	fh;
-	uint32_t	open_flags;
-	uint32_t	padding;
+	__u64	fh;
+	__u32	open_flags;
+	__u32	padding;
 };
 
 struct fuse_release_in {
-	uint64_t	fh;
-	uint32_t	flags;
-	uint32_t	release_flags;
-	uint64_t	lock_owner;
+	__u64	fh;
+	__u32	flags;
+	__u32	release_flags;
+	__u64	lock_owner;
 };
 
 struct fuse_flush_in {
-	uint64_t	fh;
-	uint32_t	unused;
-	uint32_t	padding;
-	uint64_t	lock_owner;
+	__u64	fh;
+	__u32	unused;
+	__u32	padding;
+	__u64	lock_owner;
 };
 
 struct fuse_read_in {
-	uint64_t	fh;
-	uint64_t	offset;
-	uint32_t	size;
-	uint32_t	read_flags;
-	uint64_t	lock_owner;
-	uint32_t	flags;
-	uint32_t	padding;
+	__u64	fh;
+	__u64	offset;
+	__u32	size;
+	__u32	read_flags;
+	__u64	lock_owner;
+	__u32	flags;
+	__u32	padding;
 };
 
 #define FUSE_COMPAT_WRITE_IN_SIZE 24
 
 struct fuse_write_in {
-	uint64_t	fh;
-	uint64_t	offset;
-	uint32_t	size;
-	uint32_t	write_flags;
-	uint64_t	lock_owner;
-	uint32_t	flags;
-	uint32_t	padding;
+	__u64	fh;
+	__u64	offset;
+	__u32	size;
+	__u32	write_flags;
+	__u64	lock_owner;
+	__u32	flags;
+	__u32	padding;
 };
 
 struct fuse_write_out {
-	uint32_t	size;
-	uint32_t	padding;
+	__u32	size;
+	__u32	padding;
 };
 
 #define FUSE_COMPAT_STATFS_SIZE 48
@@ -531,32 +527,32 @@ struct fuse_statfs_out {
 };
 
 struct fuse_fsync_in {
-	uint64_t	fh;
-	uint32_t	fsync_flags;
-	uint32_t	padding;
+	__u64	fh;
+	__u32	fsync_flags;
+	__u32	padding;
 };
 
 struct fuse_setxattr_in {
-	uint32_t	size;
-	uint32_t	flags;
+	__u32	size;
+	__u32	flags;
 };
 
 struct fuse_getxattr_in {
-	uint32_t	size;
-	uint32_t	padding;
+	__u32	size;
+	__u32	padding;
 };
 
 struct fuse_getxattr_out {
-	uint32_t	size;
-	uint32_t	padding;
+	__u32	size;
+	__u32	padding;
 };
 
 struct fuse_lk_in {
-	uint64_t	fh;
-	uint64_t	owner;
+	__u64	fh;
+	__u64	owner;
 	struct fuse_file_lock lk;
-	uint32_t	lk_flags;
-	uint32_t	padding;
+	__u32	lk_flags;
+	__u32	padding;
 };
 
 struct fuse_lk_out {
@@ -564,140 +560,140 @@ struct fuse_lk_out {
 };
 
 struct fuse_access_in {
-	uint32_t	mask;
-	uint32_t	padding;
+	__u32	mask;
+	__u32	padding;
 };
 
 struct fuse_init_in {
-	uint32_t	major;
-	uint32_t	minor;
-	uint32_t	max_readahead;
-	uint32_t	flags;
+	__u32	major;
+	__u32	minor;
+	__u32	max_readahead;
+	__u32	flags;
 };
 
 #define FUSE_COMPAT_INIT_OUT_SIZE 8
 #define FUSE_COMPAT_22_INIT_OUT_SIZE 24
 
 struct fuse_init_out {
-	uint32_t	major;
-	uint32_t	minor;
-	uint32_t	max_readahead;
-	uint32_t	flags;
-	uint16_t	max_background;
-	uint16_t	congestion_threshold;
-	uint32_t	max_write;
-	uint32_t	time_gran;
-	uint32_t	unused[9];
+	__u32	major;
+	__u32	minor;
+	__u32	max_readahead;
+	__u32	flags;
+	__u16	max_background;
+	__u16	congestion_threshold;
+	__u32	max_write;
+	__u32	time_gran;
+	__u32	unused[9];
 };
 
 #define CUSE_INIT_INFO_MAX 4096
 
 struct cuse_init_in {
-	uint32_t	major;
-	uint32_t	minor;
-	uint32_t	unused;
-	uint32_t	flags;
+	__u32	major;
+	__u32	minor;
+	__u32	unused;
+	__u32	flags;
 };
 
 struct cuse_init_out {
-	uint32_t	major;
-	uint32_t	minor;
-	uint32_t	unused;
-	uint32_t	flags;
-	uint32_t	max_read;
-	uint32_t	max_write;
-	uint32_t	dev_major;		/* chardev major */
-	uint32_t	dev_minor;		/* chardev minor */
-	uint32_t	spare[10];
+	__u32	major;
+	__u32	minor;
+	__u32	unused;
+	__u32	flags;
+	__u32	max_read;
+	__u32	max_write;
+	__u32	dev_major;		/* chardev major */
+	__u32	dev_minor;		/* chardev minor */
+	__u32	spare[10];
 };
 
 struct fuse_interrupt_in {
-	uint64_t	unique;
+	__u64	unique;
 };
 
 struct fuse_bmap_in {
-	uint64_t	block;
-	uint32_t	blocksize;
-	uint32_t	padding;
+	__u64	block;
+	__u32	blocksize;
+	__u32	padding;
 };
 
 struct fuse_bmap_out {
-	uint64_t	block;
+	__u64	block;
 };
 
 struct fuse_ioctl_in {
-	uint64_t	fh;
-	uint32_t	flags;
-	uint32_t	cmd;
-	uint64_t	arg;
-	uint32_t	in_size;
-	uint32_t	out_size;
+	__u64	fh;
+	__u32	flags;
+	__u32	cmd;
+	__u64	arg;
+	__u32	in_size;
+	__u32	out_size;
 };
 
 struct fuse_ioctl_iovec {
-	uint64_t	base;
-	uint64_t	len;
+	__u64	base;
+	__u64	len;
 };
 
 struct fuse_ioctl_out {
-	int32_t		result;
-	uint32_t	flags;
-	uint32_t	in_iovs;
-	uint32_t	out_iovs;
+	__s32		result;
+	__u32	flags;
+	__u32	in_iovs;
+	__u32	out_iovs;
 };
 
 struct fuse_poll_in {
-	uint64_t	fh;
-	uint64_t	kh;
-	uint32_t	flags;
-	uint32_t	events;
+	__u64	fh;
+	__u64	kh;
+	__u32	flags;
+	__u32	events;
 };
 
 struct fuse_poll_out {
-	uint32_t	revents;
-	uint32_t	padding;
+	__u32	revents;
+	__u32	padding;
 };
 
 struct fuse_notify_poll_wakeup_out {
-	uint64_t	kh;
+	__u64	kh;
 };
 
 struct fuse_fallocate_in {
-	uint64_t	fh;
-	uint64_t	offset;
-	uint64_t	length;
-	uint32_t	mode;
-	uint32_t	padding;
+	__u64	fh;
+	__u64	offset;
+	__u64	length;
+	__u32	mode;
+	__u32	padding;
 };
 
 struct fuse_in_header {
-	uint32_t	len;
-	uint32_t	opcode;
-	uint64_t	unique;
-	uint64_t	nodeid;
-	uint32_t	uid;
-	uint32_t	gid;
-	uint32_t	pid;
-	uint32_t	padding;
+	__u32	len;
+	__u32	opcode;
+	__u64	unique;
+	__u64	nodeid;
+	__u32	uid;
+	__u32	gid;
+	__u32	pid;
+	__u32	padding;
 };
 
 struct fuse_out_header {
-	uint32_t	len;
-	int32_t		error;
-	uint64_t	unique;
+	__u32	len;
+	__s32		error;
+	__u64	unique;
 };
 
 struct fuse_dirent {
-	uint64_t	ino;
-	uint64_t	off;
-	uint32_t	namelen;
-	uint32_t	type;
+	__u64	ino;
+	__u64	off;
+	__u32	namelen;
+	__u32	type;
 	char name[];
 };
 
 #define FUSE_NAME_OFFSET offsetof(struct fuse_dirent, name)
 #define FUSE_DIRENT_ALIGN(x) \
-	(((x) + sizeof(uint64_t) - 1) & ~(sizeof(uint64_t) - 1))
+	(((x) + sizeof(__u64) - 1) & ~(sizeof(__u64) - 1))
 #define FUSE_DIRENT_SIZE(d) \
 	FUSE_DIRENT_ALIGN(FUSE_NAME_OFFSET + (d)->namelen)
 
@@ -712,47 +708,47 @@ struct fuse_direntplus {
 	FUSE_DIRENT_ALIGN(FUSE_NAME_OFFSET_DIRENTPLUS + (d)->dirent.namelen)
 
 struct fuse_notify_inval_inode_out {
-	uint64_t	ino;
-	int64_t		off;
-	int64_t		len;
+	__u64	ino;
+	__s64		off;
+	__s64		len;
 };
 
 struct fuse_notify_inval_entry_out {
-	uint64_t	parent;
-	uint32_t	namelen;
-	uint32_t	padding;
+	__u64	parent;
+	__u32	namelen;
+	__u32	padding;
 };
 
 struct fuse_notify_delete_out {
-	uint64_t	parent;
-	uint64_t	child;
-	uint32_t	namelen;
-	uint32_t	padding;
+	__u64	parent;
+	__u64	child;
+	__u32	namelen;
+	__u32	padding;
 };
 
 struct fuse_notify_store_out {
-	uint64_t	nodeid;
-	uint64_t	offset;
-	uint32_t	size;
-	uint32_t	padding;
+	__u64	nodeid;
+	__u64	offset;
+	__u32	size;
+	__u32	padding;
 };
 
 struct fuse_notify_retrieve_out {
-	uint64_t	notify_unique;
-	uint64_t	nodeid;
-	uint64_t	offset;
-	uint32_t	size;
-	uint32_t	padding;
+	__u64	notify_unique;
+	__u64	nodeid;
+	__u64	offset;
+	__u32	size;
+	__u32	padding;
 };
 
 /* Matches the size of fuse_write_in */
 struct fuse_notify_retrieve_in {
-	uint64_t	dummy1;
-	uint64_t	offset;
-	uint32_t	size;
-	uint32_t	dummy2;
-	uint64_t	dummy3;
-	uint64_t	dummy4;
+	__u64	dummy1;
+	__u64	offset;
+	__u32	size;
+	__u32	dummy2;
+	__u64	dummy3;
+	__u64	dummy4;
 };
 
 /* Device ioctls: */

-Mikko
