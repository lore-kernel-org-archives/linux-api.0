From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/4] statx: Add a system call to make enhanced file info
 available [ver #2]
Date: Fri, 18 Nov 2016 16:20:38 +0000
Message-ID: <147948603812.5122.5116851833739815967.stgit@warthog.procyon.org.uk>
References: <147948603103.5122.1043337990092830185.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147948603103.5122.1043337990092830185.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add a system call to make extended file information available, including
file creation and some attribute flags where available through the
underlying filesystem.


========
OVERVIEW
========

The idea was initially proposed as a set of xattrs that could be retrieved
with getxattr(), but the general preferance proved to be for a new syscall
with an extended stat structure.

This has a number of uses:

 (1) Better support for the y2038 problem [Arnd Bergmann].

 (2) Creation time: The SMB protocol carries the creation time, which could
     be exported by Samba, which will in turn help CIFS make use of
     FS-Cache as that can be used for coherency data.

     This is also specified in NFSv4 as a recommended attribute and could
     be exported by NFSD [Steve French].

 (3) Lightweight stat: Ask for just those details of interest, and allow a
     netfs (such as NFS) to approximate anything not of interest, possibly
     without going to the server [Trond Myklebust, Ulrich Drepper, Andreas
     Dilger].

 (4) Heavyweight stat: Force a netfs to go to the server, even if it thinks
     its cached attributes are up to date [Trond Myklebust].

 (5) Data version number: Could be used by userspace NFS servers [Aneesh
     Kumar].

     Can also be used to modify fill_post_wcc() in NFSD which retrieves
     i_version directly, but has just called vfs_getattr().  It could get
     it from the kstat struct if it used vfs_xgetattr() instead.

 (6) BSD stat compatibility: Including more fields from the BSD stat such
     as creation time (st_btime) and inode generation number (st_gen)
     [Jeremy Allison, Bernd Schubert].

 (7) Inode generation number: Useful for FUSE and userspace NFS servers
     [Bernd Schubert].  This was asked for but later deemed unnecessary
     with the open-by-handle capability available

 (8) Extra coherency data may be useful in making backups [Andreas Dilger].

 (9) Allow the filesystem to indicate what it can/cannot provide: A
     filesystem can now say it doesn't support a standard stat feature if
     that isn't available, so if, for instance, inode numbers or UIDs don't
     exist or are fabricated locally...

(10) Make the fields a consistent size on all arches and make them large.

(11) Store a 16-byte volume ID in the superblock that can be returned in
     struct xstat [Steve French].

(12) Include granularity fields in the time data to indicate the
     granularity of each of the times (NFSv4 time_delta) [Steve French].

(13) FS_IOC_GETFLAGS value.  These could be translated to BSD's st_flags.
     Note that the Linux IOC flags are a mess and filesystems such as Ext4
     define flags that aren't in linux/fs.h, so translation in the kernel
     may be a necessity (or, possibly, we provide the filesystem type too).

(14) Mask of features available on file (eg: ACLs, seclabel) [Brad Boyer,
     Michael Kerrisk].

(15) Spare space, request flags and information flags are provided for
     future expansion.

Note that not all of the above are implemented here.


===============
NEW SYSTEM CALL
===============

The new system call is:

	int ret = statx(int dfd,
			const char *filename,
			unsigned int flags,
			unsigned int mask,
			struct statx *buffer);

The dfd, filename and flags parameters indicate the file to query, in a
similar way to fstatat().  There is no equivalent of lstat() as that can be
emulated with statx() by passing AT_SYMLINK_NOFOLLOW in flags.  There is
also no equivalent of fstat() as that can be emulated by passing a NULL
filename to statx() with the fd of interest in dfd.

Whether or not statx() synchronises the attributes with the backing store
can be controlled (this typically only affects network filesystems) can be
set by OR'ing a value into the flags argument:

 (1) AT_STATX_SYNC_AS_STAT tells statx() to behave as stat() does in this
     respect.

 (2) AT_STATX_FORCE_SYNC will require a network filesystem to synchronise
     its attributes with the server - which might require data writeback to
     occur to get the timestamps correct.

 (3) AT_STATX_DONT_SYNC will suppress synchronisation with the server in a
     network filesystem.  The resulting values should be considered
     approximate.

mask is a bitmask indicating the fields in struct statx that are of
interest to the caller.  The user should set this to STATX_BASIC_STATS to
get the basic set returned by stat().  It should be note that asking for
more information may entail extra I/O operations.

buffer points to the destination for the data.  This must be 256 bytes in
size.


======================
MAIN ATTRIBUTES RECORD
======================

The following structures are defined in which to return the main attribute
set:

	struct statx {
		__u32	stx_mask;
		__u32	stx_blksize;
		__u64	stx_attributes;
		__u32	stx_nlink;
		__u32	stx_uid;
		__u32	stx_gid;
		__u16	stx_mode;
		__u16	__spare0[1];
		__u64	stx_ino;
		__u64	stx_size;
		__u64	stx_blocks;
		__u64	__spare1[1];
		__s64	stx_atime;
		__s64	stx_btime;
		__s64	stx_ctime;
		__s64	stx_mtime;
		__s32	stx_atime_ns;
		__s32	stx_btime_ns;
		__s32	stx_ctime_ns;
		__s32	stx_mtime_ns;
		__u32	stx_rdev_major;
		__u32	stx_rdev_minor;
		__u32	stx_dev_major;
		__u32	stx_dev_minor;
		__u64	__spare2[16];
	};

The defined bits in request_mask and stx_mask are:

	STATX_TYPE		Want/got stx_mode & S_IFMT
	STATX_MODE		Want/got stx_mode & ~S_IFMT
	STATX_NLINK		Want/got stx_nlink
	STATX_UID		Want/got stx_uid
	STATX_GID		Want/got stx_gid
	STATX_ATIME		Want/got stx_atime{,_ns}
	STATX_MTIME		Want/got stx_mtime{,_ns}
	STATX_CTIME		Want/got stx_ctime{,_ns}
	STATX_INO		Want/got stx_ino
	STATX_SIZE		Want/got stx_size
	STATX_BLOCKS		Want/got stx_blocks
	STATX_BASIC_STATS	[The stuff in the normal stat struct]
	STATX_BTIME		Want/got stx_btime{,_ns}
	STATX_ALL		[All currently available stuff]

stx_btime is the file creation time, stx_mask is a bitmask indicating the
data provided and __spares*[] are where as-yet undefined fields can be
placed.

Time fields are split into separate seconds and nanoseconds fields to make
packing easier and the granularities can be queried with the filesystem
info system call.  Note that times will be negative if before 1970; in such
a case, the nanosecond fields will also be negative if not zero.

The bits defined in the stx_attributes field convey information about a
file, how it is accessed, where it is and what it does.  The following
attributes map to FS_*_FL flags and are the same numerical value:

	STATX_ATTR_COMPRESSED		File is compressed by the fs
	STATX_ATTR_IMMUTABLE		File is marked immutable
	STATX_ATTR_APPEND		File is append-only
	STATX_ATTR_NODUMP		File is not to be dumped
	STATX_ATTR_ENCRYPTED		File requires key to decrypt in fs

Within the kernel, the supported flags are listed by:

	KSTAT_ATTR_FS_IOC_FLAGS

[Are any other IOC flags of sufficient general interest to be exposed
through this interface?]

New flags include:

	STATX_ATTR_AUTOMOUNT		Object is an automount trigger

These are for the use of GUI tools that might want to mark files specially,
depending on what they are.

Fields in struct statx come in a number of classes:

 (0) stx_dev_*, stx_blksize.

     These are local system information and are always available.

 (1) stx_mode, stx_nlinks, stx_uid, stx_gid, stx_[amc]time*, stx_ino,
     stx_size, stx_blocks.

     These will be returned whether the caller asks for them or not.  The
     corresponding bits in stx_mask will be set to indicate whether they
     actually have valid values.

     If the caller didn't ask for them, then they may be approximated.  For
     example, NFS won't waste any time updating them from the server,
     unless as a byproduct of updating something requested.

     If the values don't actually exist for the underlying object (such as
     UID or GID on a DOS file), then the bit won't be set in the stx_mask,
     even if the caller asked for the value.  In such a case, the returned
     value will be a fabrication.

     Note that there are instances where the type might not be valid, for
     instance Windows reparse points.

 (2) stx_rdev_*.

     This will be set only if stx_mode indicates we're looking at a
     blockdev or a chardev, otherwise will be 0.

 (3) stx_btime*.

     Similar to (1), except this will be set to 0 if it doesn't exist.


=======
TESTING
=======

The following test program can be used to test the statx system call:

	samples/statx/test-statx.c

Just compile and run, passing it paths to the files you want to examine.
The file is built automatically if CONFIG_SAMPLES is enabled.

Here's some example output.  Firstly, an NFS directory that crosses to
another FSID.  Note that the AUTOMOUNT attribute is set because transiting
this directory will cause d_automount to be invoked by the VFS.

	[root@andromeda tmp]# ./samples/statx/test-statx -A /warthog/data
	statx(/warthog/data) = 0
	results=17ff
	  Size: 4096            Blocks: 8          IO Block: 1048576  directory
	Device: 00:26           Inode: 1703937     Links: 124
	Access: (3777/drwxrwxrwx)  Uid:     0   Gid:  4041
	Access: 2016-11-10 15:52:11.219935864+0000
	Modify: 2016-11-10 08:07:32.482314928+0000
	Change: 2016-11-10 08:07:32.482314928+0000
	Attributes: 0000000000001000 (-------- -------- -------- -------- -------- -------- ---m---- --------)
	IO-blocksize: blksize=1048576

Secondly, the result of automounting on that directory.

	[root@andromeda tmp]# ./samples/statx/test-statx /warthog/data
	statx(/warthog/data) = 0
	results=17ff
	  Size: 4096            Blocks: 8          IO Block: 1048576  directory
	Device: 00:27           Inode: 2           Links: 124
	Access: (3777/drwxrwxrwx)  Uid:     0   Gid:  4041
	Access: 2016-11-10 15:52:11.219935864+0000
	Modify: 2016-11-10 08:07:32.482314928+0000
	Change: 2016-11-10 08:07:32.482314928+0000
	IO-blocksize: blksize=1048576

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/entry/syscalls/syscall_32.tbl |    1 
 arch/x86/entry/syscalls/syscall_64.tbl |    1 
 fs/exportfs/expfs.c                    |    4 
 fs/stat.c                              |  296 +++++++++++++++++++++++++++++---
 include/linux/fs.h                     |    5 -
 include/linux/stat.h                   |   19 +-
 include/linux/syscalls.h               |    3 
 include/uapi/linux/fcntl.h             |    5 +
 include/uapi/linux/stat.h              |  116 +++++++++++++
 samples/Kconfig                        |    5 +
 samples/Makefile                       |    3 
 samples/statx/Makefile                 |   10 +
 samples/statx/test-statx.c             |  248 +++++++++++++++++++++++++++
 13 files changed, 676 insertions(+), 40 deletions(-)
 create mode 100644 samples/statx/Makefile
 create mode 100644 samples/statx/test-statx.c

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 2b3618542544..9ba050fe47f3 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -389,3 +389,4 @@
 380	i386	pkey_mprotect		sys_pkey_mprotect
 381	i386	pkey_alloc		sys_pkey_alloc
 382	i386	pkey_free		sys_pkey_free
+383	i386	statx			sys_statx
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index e93ef0b38db8..5aef183e2f85 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -338,6 +338,7 @@
 329	common	pkey_mprotect		sys_pkey_mprotect
 330	common	pkey_alloc		sys_pkey_alloc
 331	common	pkey_free		sys_pkey_free
+332	common	statx			sys_statx
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index a4b531be9168..2acc31751248 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -299,7 +299,9 @@ static int get_name(const struct path *path, char *name, struct dentry *child)
 	 * filesystem supports 64-bit inode numbers.  So we need to
 	 * actually call ->getattr, not just read i_ino:
 	 */
-	error = vfs_getattr_nosec(&child_path, &stat);
+	stat.query_flags = 0;
+	stat.request_mask = STATX_BASIC_STATS;
+	error = vfs_xgetattr_nosec(&child_path, &stat);
 	if (error)
 		return error;
 	buffer.ino = stat.ino;
diff --git a/fs/stat.c b/fs/stat.c
index bc045c7994e1..2a4dc106b4b6 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -18,6 +18,15 @@
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 
+/**
+ * generic_fillattr - Fill in the basic attributes from the inode struct
+ * @inode: Inode to use as the source
+ * @stat: Where to fill in the attributes
+ *
+ * Fill in the basic attributes in the kstat structure from data that's to be
+ * found on the VFS inode structure.  This is the default if no getattr inode
+ * operation is supplied.
+ */
 void generic_fillattr(struct inode *inode, struct kstat *stat)
 {
 	stat->dev = inode->i_sb->s_dev;
@@ -27,87 +36,189 @@ void generic_fillattr(struct inode *inode, struct kstat *stat)
 	stat->uid = inode->i_uid;
 	stat->gid = inode->i_gid;
 	stat->rdev = inode->i_rdev;
-	stat->size = i_size_read(inode);
-	stat->atime = inode->i_atime;
 	stat->mtime = inode->i_mtime;
 	stat->ctime = inode->i_ctime;
-	stat->blksize = (1 << inode->i_blkbits);
+	stat->size = i_size_read(inode);
 	stat->blocks = inode->i_blocks;
-}
+	stat->blksize = 1 << inode->i_blkbits;
 
+	stat->result_mask |= STATX_BASIC_STATS;
+	if (IS_NOATIME(inode))
+		stat->result_mask &= ~STATX_ATIME;
+	else
+		stat->atime = inode->i_atime;
+
+	if (IS_AUTOMOUNT(inode))
+		stat->attributes |= STATX_ATTR_AUTOMOUNT;
+}
 EXPORT_SYMBOL(generic_fillattr);
 
 /**
- * vfs_getattr_nosec - getattr without security checks
+ * vfs_xgetattr_nosec - getattr without security checks
  * @path: file to get attributes from
  * @stat: structure to return attributes in
  *
  * Get attributes without calling security_inode_getattr.
  *
- * Currently the only caller other than vfs_getattr is internal to the
- * filehandle lookup code, which uses only the inode number and returns
- * no attributes to any user.  Any other code probably wants
- * vfs_getattr.
+ * Currently the only caller other than vfs_xgetattr is internal to the
+ * filehandle lookup code, which uses only the inode number and returns no
+ * attributes to any user.  Any other code probably wants vfs_xgetattr.
+ *
+ * The caller must set stat->request_mask to indicate what they want and
+ * stat->query_flags to indicate whether the server should be queried.
  */
-int vfs_getattr_nosec(struct path *path, struct kstat *stat)
+int vfs_xgetattr_nosec(struct path *path, struct kstat *stat)
 {
 	struct inode *inode = d_backing_inode(path->dentry);
 
+	stat->query_flags &= ~KSTAT_QUERY_FLAGS;
+
+	stat->result_mask = 0;
+	stat->attributes = 0;
 	if (inode->i_op->getattr)
 		return inode->i_op->getattr(path->mnt, path->dentry, stat);
 
 	generic_fillattr(inode, stat);
 	return 0;
 }
+EXPORT_SYMBOL(vfs_xgetattr_nosec);
 
-EXPORT_SYMBOL(vfs_getattr_nosec);
-
-int vfs_getattr(struct path *path, struct kstat *stat)
+/*
+ * vfs_xgetattr - Get the enhanced basic attributes of a file
+ * @path: The file of interest
+ * @stat: Where to return the statistics
+ *
+ * Ask the filesystem for a file's attributes.  The caller must have preset
+ * stat->request_mask and stat->query_flags to indicate what they want.
+ *
+ * If the file is remote, the filesystem can be forced to update the attributes
+ * from the backing store by passing AT_FORCE_ATTR_SYNC in query_flags or can
+ * suppress the update by passing AT_NO_ATTR_SYNC.
+ *
+ * Bits must have been set in stat->request_mask to indicate which attributes
+ * the caller wants retrieving.  Any such attribute not requested may be
+ * returned anyway, but the value may be approximate, and, if remote, may not
+ * have been synchronised with the server.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_xgetattr(struct path *path, struct kstat *stat)
 {
 	int retval;
 
 	retval = security_inode_getattr(path);
 	if (retval)
 		return retval;
-	return vfs_getattr_nosec(path, stat);
+	return vfs_xgetattr_nosec(path, stat);
 }
+EXPORT_SYMBOL(vfs_xgetattr);
 
+/**
+ * vfs_getattr - Get the basic attributes of a file
+ * @path: The file of interest
+ * @stat: Where to return the statistics
+ *
+ * Ask the filesystem for a file's attributes.  If remote, the filesystem isn't
+ * forced to update its files from the backing store.  Only the basic set of
+ * attributes will be retrieved; anyone wanting more must use vfs_xgetattr(),
+ * as must anyone who wants to force attributes to be sync'd with the server.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_getattr(struct path *path, struct kstat *stat)
+{
+	stat->query_flags = 0;
+	stat->request_mask = STATX_BASIC_STATS;
+	return vfs_xgetattr(path, stat);
+}
 EXPORT_SYMBOL(vfs_getattr);
 
-int vfs_fstat(unsigned int fd, struct kstat *stat)
+/**
+ * vfs_fstatx - Get the enhanced basic attributes by file descriptor
+ * @fd: The file descriptor referring to the file of interest
+ * @stat: The result structure to fill in.
+ *
+ * This function is a wrapper around vfs_xgetattr().  The main difference is
+ * that it uses a file descriptor to determine the file location.
+ *
+ * The caller must have preset stat->query_flags and stat->request_mask as for
+ * vfs_xgetattr().
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_fstatx(unsigned int fd, struct kstat *stat)
 {
 	struct fd f = fdget_raw(fd);
 	int error = -EBADF;
 
 	if (f.file) {
-		error = vfs_getattr(&f.file->f_path, stat);
+		error = vfs_xgetattr(&f.file->f_path, stat);
 		fdput(f);
 	}
 	return error;
 }
+EXPORT_SYMBOL(vfs_fstatx);
+
+/**
+ * vfs_fstat - Get basic attributes by file descriptor
+ * @fd: The file descriptor referring to the file of interest
+ * @stat: The result structure to fill in.
+ *
+ * This function is a wrapper around vfs_getattr().  The main difference is
+ * that it uses a file descriptor to determine the file location.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_fstat(unsigned int fd, struct kstat *stat)
+{
+	stat->query_flags = 0;
+	stat->request_mask = STATX_BASIC_STATS;
+	return vfs_fstatx(fd, stat);
+}
 EXPORT_SYMBOL(vfs_fstat);
 
-int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
-		int flag)
+/**
+ * vfs_statx - Get basic and extra attributes by filename
+ * @dfd: A file descriptor representing the base dir for a relative filename
+ * @filename: The name of the file of interest
+ * @flags: Flags to control the query
+ * @stat: The result structure to fill in.
+ *
+ * This function is a wrapper around vfs_xgetattr().  The main difference is
+ * that it uses a filename and base directory to determine the file location.
+ * Additionally, the addition of AT_SYMLINK_NOFOLLOW to flags will prevent a
+ * symlink at the given name from being referenced.
+ *
+ * The caller must have preset stat->request_mask as for vfs_xgetattr().  The
+ * flags are also used to load up stat->query_flags.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_statx(int dfd, const char __user *filename, int flags,
+	      struct kstat *stat)
 {
 	struct path path;
 	int error = -EINVAL;
-	unsigned int lookup_flags = 0;
+	unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_AUTOMOUNT;
 
-	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT |
-		      AT_EMPTY_PATH)) != 0)
-		goto out;
+	if ((flags & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT |
+		       AT_EMPTY_PATH | KSTAT_QUERY_FLAGS)) != 0)
+		return -EINVAL;
 
-	if (!(flag & AT_SYMLINK_NOFOLLOW))
-		lookup_flags |= LOOKUP_FOLLOW;
-	if (flag & AT_EMPTY_PATH)
+	if (flags & AT_SYMLINK_NOFOLLOW)
+		lookup_flags &= ~LOOKUP_FOLLOW;
+	if (flags & AT_NO_AUTOMOUNT)
+		lookup_flags &= ~LOOKUP_AUTOMOUNT;
+	if (flags & AT_EMPTY_PATH)
 		lookup_flags |= LOOKUP_EMPTY;
+	stat->query_flags = flags;
+
 retry:
 	error = user_path_at(dfd, filename, lookup_flags, &path);
 	if (error)
 		goto out;
 
-	error = vfs_getattr(&path, stat);
+	error = vfs_xgetattr(&path, stat);
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
@@ -116,17 +227,65 @@ int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
 out:
 	return error;
 }
+EXPORT_SYMBOL(vfs_statx);
+
+/**
+ * vfs_fstatat - Get basic attributes by filename
+ * @dfd: A file descriptor representing the base dir for a relative filename
+ * @filename: The name of the file of interest
+ * @flags: Flags to control the query
+ * @stat: The result structure to fill in.
+ *
+ * This function is a wrapper around vfs_statx().  The difference is that it
+ * preselects basic stats only.  The flags are used to load up
+ * stat->query_flags in addition to indicating symlink handling during path
+ * resolution.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
+		int flags)
+{
+	stat->request_mask = STATX_BASIC_STATS;
+	return vfs_statx(dfd, filename, flags, stat);
+}
 EXPORT_SYMBOL(vfs_fstatat);
 
-int vfs_stat(const char __user *name, struct kstat *stat)
+/**
+ * vfs_stat - Get basic attributes by filename
+ * @filename: The name of the file of interest
+ * @stat: The result structure to fill in.
+ *
+ * This function is a wrapper around vfs_statx().  The difference is that it
+ * preselects basic stats only, terminal symlinks are followed regardless and a
+ * remote filesystem can't be forced to query the server.  If such is desired,
+ * vfs_statx() should be used instead.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_stat(const char __user *filename, struct kstat *stat)
 {
-	return vfs_fstatat(AT_FDCWD, name, stat, 0);
+	stat->request_mask = STATX_BASIC_STATS;
+	return vfs_statx(AT_FDCWD, filename, 0, stat);
 }
 EXPORT_SYMBOL(vfs_stat);
 
+/**
+ * vfs_lstat - Get basic attrs by filename, without following terminal symlink
+ * @filename: The name of the file of interest
+ * @stat: The result structure to fill in.
+ *
+ * This function is a wrapper around vfs_statx().  The difference is that it
+ * preselects basic stats only, terminal symlinks are note followed regardless
+ * and a remote filesystem can't be forced to query the server.  If such is
+ * desired, vfs_statx() should be used instead.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
 int vfs_lstat(const char __user *name, struct kstat *stat)
 {
-	return vfs_fstatat(AT_FDCWD, name, stat, AT_SYMLINK_NOFOLLOW);
+	stat->request_mask = STATX_BASIC_STATS;
+	return vfs_statx(AT_FDCWD, name, AT_SYMLINK_NOFOLLOW, stat);
 }
 EXPORT_SYMBOL(vfs_lstat);
 
@@ -141,7 +300,7 @@ static int cp_old_stat(struct kstat *stat, struct __old_kernel_stat __user * sta
 {
 	static int warncount = 5;
 	struct __old_kernel_stat tmp;
-	
+
 	if (warncount > 0) {
 		warncount--;
 		printk(KERN_WARNING "VFS: Warning: %s using old stat() call. Recompile your binary.\n",
@@ -166,7 +325,7 @@ static int cp_old_stat(struct kstat *stat, struct __old_kernel_stat __user * sta
 #if BITS_PER_LONG == 32
 	if (stat->size > MAX_NON_LFS)
 		return -EOVERFLOW;
-#endif	
+#endif
 	tmp.st_size = stat->size;
 	tmp.st_atime = stat->atime.tv_sec;
 	tmp.st_mtime = stat->mtime.tv_sec;
@@ -443,6 +602,81 @@ SYSCALL_DEFINE4(fstatat64, int, dfd, const char __user *, filename,
 }
 #endif /* __ARCH_WANT_STAT64 || __ARCH_WANT_COMPAT_STAT64 */
 
+/*
+ * Set the statx results.
+ */
+static long statx_set_result(struct kstat *stat, struct statx __user *buffer)
+{
+	uid_t uid = from_kuid_munged(current_user_ns(), stat->uid);
+	gid_t gid = from_kgid_munged(current_user_ns(), stat->gid);
+
+#define __put_timestamp(kts, uts) (				\
+		__put_user(kts.tv_sec,	uts##_s		) ||	\
+		__put_user(kts.tv_nsec,	uts##_ns	))
+
+	if (__put_user(stat->result_mask,	&buffer->stx_mask	) ||
+	    __put_user(stat->mode,		&buffer->stx_mode	) ||
+	    __clear_user(&buffer->__spare0, sizeof(buffer->__spare0))	  ||
+	    __put_user(stat->nlink,		&buffer->stx_nlink	) ||
+	    __put_user(uid,			&buffer->stx_uid	) ||
+	    __put_user(gid,			&buffer->stx_gid	) ||
+	    __put_user(stat->attributes,	&buffer->stx_attributes	) ||
+	    __put_user(stat->blksize,		&buffer->stx_blksize	) ||
+	    __put_user(MAJOR(stat->rdev),	&buffer->stx_rdev_major	) ||
+	    __put_user(MINOR(stat->rdev),	&buffer->stx_rdev_minor	) ||
+	    __put_user(MAJOR(stat->dev),	&buffer->stx_dev_major	) ||
+	    __put_user(MINOR(stat->dev),	&buffer->stx_dev_minor	) ||
+	    __put_timestamp(stat->atime,	&buffer->stx_atime	) ||
+	    __put_timestamp(stat->btime,	&buffer->stx_btime	) ||
+	    __put_timestamp(stat->ctime,	&buffer->stx_ctime	) ||
+	    __put_timestamp(stat->mtime,	&buffer->stx_mtime	) ||
+	    __put_user(stat->ino,		&buffer->stx_ino	) ||
+	    __put_user(stat->size,		&buffer->stx_size	) ||
+	    __put_user(stat->blocks,		&buffer->stx_blocks	) ||
+	    __clear_user(&buffer->__spare1, sizeof(buffer->__spare1))	  ||
+	    __clear_user(&buffer->__spare2, sizeof(buffer->__spare2)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/**
+ * sys_statx - System call to get enhanced stats
+ * @dfd: Base directory to pathwalk from *or* fd to stat.
+ * @filename: File to stat *or* NULL.
+ * @flags: AT_* flags to control pathwalk.
+ * @mask: Parts of statx struct actually required.
+ * @buffer: Result buffer.
+ *
+ * Note that if filename is NULL, then it does the equivalent of fstat() using
+ * dfd to indicate the file of interest.
+ */
+SYSCALL_DEFINE5(statx,
+		int, dfd, const char __user *, filename, unsigned, flags,
+		unsigned int, mask,
+		struct statx __user *, buffer)
+{
+	struct kstat stat;
+	int error;
+
+	if ((flags & AT_STATX_SYNC_TYPE) == AT_STATX_SYNC_TYPE)
+		return -EINVAL;
+	if (!access_ok(VERIFY_WRITE, buffer, sizeof(*buffer)))
+		return -EFAULT;
+
+	memset(&stat, 0, sizeof(stat));
+	stat.query_flags = flags;
+	stat.request_mask = mask & STATX_ALL;
+
+	if (filename)
+		error = vfs_statx(dfd, filename, flags, &stat);
+	else
+		error = vfs_fstatx(dfd, &stat);
+	if (error)
+		return error;
+	return statx_set_result(&stat, buffer);
+}
+
 /* Caller is here responsible for sufficient locking (ie. inode->i_lock) */
 void __inode_add_bytes(struct inode *inode, loff_t bytes)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 16d2b6e874d6..f153199566b4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2916,8 +2916,9 @@ extern const struct inode_operations page_symlink_inode_operations;
 extern void kfree_link(void *);
 extern int generic_readlink(struct dentry *, char __user *, int);
 extern void generic_fillattr(struct inode *, struct kstat *);
-int vfs_getattr_nosec(struct path *path, struct kstat *stat);
+extern int vfs_xgetattr_nosec(struct path *path, struct kstat *stat);
 extern int vfs_getattr(struct path *, struct kstat *);
+extern int vfs_xgetattr(struct path *, struct kstat *);
 void __inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_add_bytes(struct inode *inode, loff_t bytes);
 void __inode_sub_bytes(struct inode *inode, loff_t bytes);
@@ -2935,6 +2936,8 @@ extern int vfs_lstat(const char __user *, struct kstat *);
 extern int vfs_fstat(unsigned int, struct kstat *);
 extern int vfs_fstatat(int , const char __user *, struct kstat *, int);
 extern const char *vfs_get_link(struct dentry *, struct delayed_call *);
+extern int vfs_xstat(int, const char __user *, int, struct kstat *);
+extern int vfs_xfstat(unsigned int, struct kstat *);
 
 extern int __generic_block_fiemap(struct inode *inode,
 				  struct fiemap_extent_info *fieinfo,
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 075cb0c7eb2a..9b81dfcbb57a 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -19,19 +19,26 @@
 #include <linux/uidgid.h>
 
 struct kstat {
-	u64		ino;
-	dev_t		dev;
+	u32		query_flags;	/* Operational flags */
+#define KSTAT_QUERY_FLAGS (AT_STATX_SYNC_TYPE)
+	u32		request_mask;	/* What fields the user asked for */
+	u32		result_mask;	/* What fields the user got */
 	umode_t		mode;
 	unsigned int	nlink;
+	uint32_t	blksize;	/* Preferred I/O size */
+	u64		attributes;
+#define KSTAT_ATTR_FS_IOC_FLAGS		0x00000874 /* Attrs corresponding to FS_*_FL flags */
+	u64		ino;
+	dev_t		dev;
+	dev_t		rdev;
 	kuid_t		uid;
 	kgid_t		gid;
-	dev_t		rdev;
 	loff_t		size;
-	struct timespec  atime;
+	struct timespec	atime;
 	struct timespec	mtime;
 	struct timespec	ctime;
-	unsigned long	blksize;
-	unsigned long long	blocks;
+	struct timespec	btime;			/* File creation time */
+	u64		blocks;
 };
 
 #endif
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 91a740f6b884..980c3c9b06f8 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -48,6 +48,7 @@ struct stat;
 struct stat64;
 struct statfs;
 struct statfs64;
+struct statx;
 struct __sysctl_args;
 struct sysinfo;
 struct timespec;
@@ -902,5 +903,7 @@ asmlinkage long sys_pkey_mprotect(unsigned long start, size_t len,
 				  unsigned long prot, int pkey);
 asmlinkage long sys_pkey_alloc(unsigned long flags, unsigned long init_val);
 asmlinkage long sys_pkey_free(int pkey);
+asmlinkage long sys_statx(int dfd, const char __user *path, unsigned flags,
+			  unsigned mask, struct statx __user *buffer);
 
 #endif
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index beed138bd359..813afd6eee71 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -63,5 +63,10 @@
 #define AT_NO_AUTOMOUNT		0x800	/* Suppress terminal automount traversal */
 #define AT_EMPTY_PATH		0x1000	/* Allow empty relative pathname */
 
+#define AT_STATX_SYNC_TYPE	0x6000	/* Type of synchronisation required from statx() */
+#define AT_STATX_SYNC_AS_STAT	0x0000	/* - Do whatever stat() does */
+#define AT_STATX_FORCE_SYNC	0x2000	/* - Force the attributes to be sync'd with the server */
+#define AT_STATX_DONT_SYNC	0x4000	/* - Don't sync attributes with the server */
+
 
 #endif /* _UAPI_LINUX_FCNTL_H */
diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index 7fec7e36d921..2d4041518d22 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -1,6 +1,7 @@
 #ifndef _UAPI_LINUX_STAT_H
 #define _UAPI_LINUX_STAT_H
 
+#include <linux/types.h>
 
 #if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
 
@@ -41,5 +42,120 @@
 
 #endif
 
+/*
+ * Structures for the extended file attribute retrieval system call
+ * (statx()).
+ *
+ * The caller passes a mask of what they're specifically interested in as a
+ * parameter to statx().  What statx() actually got will be indicated in
+ * st_mask upon return.
+ *
+ * For each bit in the mask argument:
+ *
+ * - if the datum is not supported:
+ *
+ *   - the bit will be cleared, and
+ *
+ *   - the datum will be set to an appropriate fabricated value if one is
+ *     available (eg. CIFS can take a default uid and gid), otherwise
+ *
+ *   - the field will be cleared;
+ *
+ * - otherwise, if explicitly requested:
+ *
+ *   - the datum will be synchronised to the server if AT_STATX_FORCE_SYNC is
+ *     set or if the datum is considered out of date, and
+ *
+ *   - the field will be filled in and the bit will be set;
+ *
+ * - otherwise, if not requested, but available in approximate form without any
+ *   effort, it will be filled in anyway, and the bit will be set upon return
+ *   (it might not be up to date, however, and no attempt will be made to
+ *   synchronise the internal state first);
+ *
+ * - otherwise the field and the bit will be cleared before returning.
+ *
+ * Items in STATX_BASIC_STATS may be marked unavailable on return, but they
+ * will have values installed for compatibility purposes so that stat() and
+ * co. can be emulated in userspace.
+ */
+struct statx {
+	/* 0x00 */
+	__u32	stx_mask;	/* What results were written [uncond] */
+	__u32	stx_blksize;	/* Preferred general I/O size [uncond] */
+	__u64	stx_attributes;	/* Flags conveying information about the file [uncond] */
+	/* 0x10 */
+	__u32	stx_nlink;	/* Number of hard links */
+	__u32	stx_uid;	/* User ID of owner */
+	__u32	stx_gid;	/* Group ID of owner */
+	__u16	stx_mode;	/* File mode */
+	__u16	__spare0[1];
+	/* 0x20 */
+	__u64	stx_ino;	/* Inode number */
+	__u64	stx_size;	/* File size */
+	__u64	stx_blocks;	/* Number of 512-byte blocks allocated */
+	__u64	__spare1[1];
+	/* 0x40 */
+	__s64	stx_atime_s;	/* Last access time */
+	__s64	stx_btime_s;	/* File creation time */
+	__s64	stx_ctime_s;	/* Last attribute change time */
+	__s64	stx_mtime_s;	/* Last data modification time */
+	/* 0x60 */
+	__s32	stx_atime_ns;	/* Last access time (ns part) */
+	__s32	stx_btime_ns;	/* File creation time (ns part) */
+	__s32	stx_ctime_ns;	/* Last attribute change time (ns part) */
+	__s32	stx_mtime_ns;	/* Last data modification time (ns part) */
+	/* 0x70 */
+	__u32	stx_rdev_major;	/* Device ID of special file [if bdev/cdev] */
+	__u32	stx_rdev_minor;
+	__u32	stx_dev_major;	/* ID of device containing file [uncond] */
+	__u32	stx_dev_minor;
+	/* 0x80 */
+	__u64	__spare2[16];	/* Spare space for future expansion */
+	/* 0x100 */
+};
+
+/*
+ * Flags to be stx_mask
+ *
+ * Query request/result mask for statx() and struct statx::stx_mask.
+ *
+ * These bits should be set in the mask argument of statx() to request
+ * particular items when calling statx().
+ */
+#define STATX_TYPE		0x00000001U	/* Want/got stx_mode & S_IFMT */
+#define STATX_MODE		0x00000002U	/* Want/got stx_mode & ~S_IFMT */
+#define STATX_NLINK		0x00000004U	/* Want/got stx_nlink */
+#define STATX_UID		0x00000008U	/* Want/got stx_uid */
+#define STATX_GID		0x00000010U	/* Want/got stx_gid */
+#define STATX_ATIME		0x00000020U	/* Want/got stx_atime */
+#define STATX_MTIME		0x00000040U	/* Want/got stx_mtime */
+#define STATX_CTIME		0x00000080U	/* Want/got stx_ctime */
+#define STATX_INO		0x00000100U	/* Want/got stx_ino */
+#define STATX_SIZE		0x00000200U	/* Want/got stx_size */
+#define STATX_BLOCKS		0x00000400U	/* Want/got stx_blocks */
+#define STATX_BASIC_STATS	0x000007ffU	/* The stuff in the normal stat struct */
+#define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
+#define STATX_ALL		0x00000fffU	/* All currently supported flags */
+
+/*
+ * Attributes to be found in stx_attributes
+ *
+ * These give information about the features or the state of a file that might
+ * be of use to ordinary userspace programs such as GUIs or ls rather than
+ * specialised tools.
+ *
+ * Note that the flags marked [I] correspond to generic FS_IOC_FLAGS
+ * semantically.  Where possible, the numerical value is picked to correspond
+ * also.
+ */
+#define STATX_ATTR_COMPRESSED		0x00000004 /* [I] File is compressed by the fs */
+#define STATX_ATTR_IMMUTABLE		0x00000010 /* [I] File is marked immutable */
+#define STATX_ATTR_APPEND		0x00000020 /* [I] File is append-only */
+#define STATX_ATTR_NODUMP		0x00000040 /* [I] File is not to be dumped */
+#define STATX_ATTR_ENCRYPTED		0x00000800 /* [I] File requires key to decrypt in fs */
+
+#define STATX_ATTR_AUTOMOUNT		0x00001000 /* Dir: Automount trigger */
+
 
 #endif /* _UAPI_LINUX_STAT_H */
diff --git a/samples/Kconfig b/samples/Kconfig
index a6d2a43bbf2e..94a7488f14ae 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -105,4 +105,9 @@ config SAMPLE_BLACKFIN_GPTIMERS
 	help
 	  Build samples of blackfin gptimers sample module.
 
+config SAMPLE_STATX
+	bool "Build example extended-stat using code"
+	help
+	  Build example userspace program to use the new extended-stat syscall.
+
 endif # SAMPLES
diff --git a/samples/Makefile b/samples/Makefile
index e17d66d77f09..8eeb15e13413 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -2,4 +2,5 @@
 
 obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ trace_events/ livepatch/ \
 			   hw_breakpoint/ kfifo/ kdb/ hidraw/ rpmsg/ seccomp/ \
-			   configfs/ connector/ v4l/ trace_printk/ blackfin/
+			   configfs/ connector/ v4l/ trace_printk/ blackfin/ \
+			   statx/
diff --git a/samples/statx/Makefile b/samples/statx/Makefile
new file mode 100644
index 000000000000..1f80a3d8cf45
--- /dev/null
+++ b/samples/statx/Makefile
@@ -0,0 +1,10 @@
+# kbuild trick to avoid linker error. Can be omitted if a module is built.
+obj- := dummy.o
+
+# List of programs to build
+hostprogs-$(CONFIG_SAMPLE_STATX) := test-statx
+
+# Tell kbuild to always build the programs
+always := $(hostprogs-y)
+
+HOSTCFLAGS_test-statx.o += -I$(objtree)/usr/include
diff --git a/samples/statx/test-statx.c b/samples/statx/test-statx.c
new file mode 100644
index 000000000000..24f90a72ef55
--- /dev/null
+++ b/samples/statx/test-statx.c
@@ -0,0 +1,248 @@
+/* Test the statx() system call
+ *
+ * Copyright (C) 2015 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#define _GNU_SOURCE
+#define _ATFILE_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <ctype.h>
+#include <errno.h>
+#include <time.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <linux/stat.h>
+#include <linux/fcntl.h>
+#include <sys/stat.h>
+
+#define AT_STATX_SYNC_TYPE	0x6000
+#define AT_STATX_SYNC_AS_STAT	0x0000
+#define AT_STATX_FORCE_SYNC	0x2000
+#define AT_STATX_DONT_SYNC	0x4000
+
+static __attribute__((unused))
+ssize_t statx(int dfd, const char *filename, unsigned flags,
+	      unsigned int mask, struct statx *buffer)
+{
+	return syscall(__NR_statx, dfd, filename, flags, mask, buffer);
+}
+
+static void print_time(const char *field, __s64 tv_sec, __s32 tv_nsec)
+{
+	struct tm tm;
+	time_t tim;
+	char buffer[100];
+	int len;
+
+	tim = tv_sec;
+	if (!localtime_r(&tim, &tm)) {
+		perror("localtime_r");
+		exit(1);
+	}
+	len = strftime(buffer, 100, "%F %T", &tm);
+	if (len == 0) {
+		perror("strftime");
+		exit(1);
+	}
+	printf("%s", field);
+	fwrite(buffer, 1, len, stdout);
+	printf(".%09u", tv_nsec);
+	len = strftime(buffer, 100, "%z", &tm);
+	if (len == 0) {
+		perror("strftime2");
+		exit(1);
+	}
+	fwrite(buffer, 1, len, stdout);
+	printf("\n");
+}
+
+static void dump_statx(struct statx *stx)
+{
+	char buffer[256], ft = '?';
+
+	printf("results=%x\n", stx->stx_mask);
+
+	printf(" ");
+	if (stx->stx_mask & STATX_SIZE)
+		printf(" Size: %-15llu", (unsigned long long)stx->stx_size);
+	if (stx->stx_mask & STATX_BLOCKS)
+		printf(" Blocks: %-10llu", (unsigned long long)stx->stx_blocks);
+	printf(" IO Block: %-6llu ", (unsigned long long)stx->stx_blksize);
+	if (stx->stx_mask & STATX_MODE) {
+		switch (stx->stx_mode & S_IFMT) {
+		case S_IFIFO:	printf(" FIFO\n");			ft = 'p'; break;
+		case S_IFCHR:	printf(" character special file\n");	ft = 'c'; break;
+		case S_IFDIR:	printf(" directory\n");			ft = 'd'; break;
+		case S_IFBLK:	printf(" block special file\n");	ft = 'b'; break;
+		case S_IFREG:	printf(" regular file\n");		ft = '-'; break;
+		case S_IFLNK:	printf(" symbolic link\n");		ft = 'l'; break;
+		case S_IFSOCK:	printf(" socket\n");			ft = 's'; break;
+		default:
+			printf("unknown type (%o)\n", stx->stx_mode & S_IFMT);
+			break;
+		}
+	}
+
+	sprintf(buffer, "%02x:%02x", stx->stx_dev_major, stx->stx_dev_minor);
+	printf("Device: %-15s", buffer);
+	if (stx->stx_mask & STATX_INO)
+		printf(" Inode: %-11llu", (unsigned long long) stx->stx_ino);
+	if (stx->stx_mask & STATX_SIZE)
+		printf(" Links: %-5u", stx->stx_nlink);
+	switch (stx->stx_mask & STATX_MODE) {
+	case S_IFBLK:
+	case S_IFCHR:
+		printf(" Device type: %u,%u", stx->stx_rdev_major, stx->stx_rdev_minor);
+		break;
+	}
+	printf("\n");
+
+	if (stx->stx_mask & STATX_MODE)
+		printf("Access: (%04o/%c%c%c%c%c%c%c%c%c%c)  ",
+		       stx->stx_mode & 07777,
+		       ft,
+		       stx->stx_mode & S_IRUSR ? 'r' : '-',
+		       stx->stx_mode & S_IWUSR ? 'w' : '-',
+		       stx->stx_mode & S_IXUSR ? 'x' : '-',
+		       stx->stx_mode & S_IRGRP ? 'r' : '-',
+		       stx->stx_mode & S_IWGRP ? 'w' : '-',
+		       stx->stx_mode & S_IXGRP ? 'x' : '-',
+		       stx->stx_mode & S_IROTH ? 'r' : '-',
+		       stx->stx_mode & S_IWOTH ? 'w' : '-',
+		       stx->stx_mode & S_IXOTH ? 'x' : '-');
+	if (stx->stx_mask & STATX_UID)
+		printf("Uid: %5d   ", stx->stx_uid);
+	if (stx->stx_mask & STATX_GID)
+		printf("Gid: %5d\n", stx->stx_gid);
+
+	if (stx->stx_mask & STATX_ATIME)
+		print_time("Access: ", stx->stx_atime_s, stx->stx_atime_ns);
+	if (stx->stx_mask & STATX_MTIME)
+		print_time("Modify: ", stx->stx_mtime_s, stx->stx_mtime_ns);
+	if (stx->stx_mask & STATX_CTIME)
+		print_time("Change: ", stx->stx_ctime_s, stx->stx_ctime_ns);
+	if (stx->stx_mask & STATX_BTIME)
+		print_time(" Birth: ", stx->stx_btime_s, stx->stx_btime_ns);
+
+	if (stx->stx_attributes) {
+		unsigned char bits;
+		int loop, byte;
+
+		static char attr_representation[64 + 1] =
+			/* STATX_ATTR_ flags: */
+			"????????"	/* 63-56 */
+			"????????"	/* 55-48 */
+			"????????"	/* 47-40 */
+			"????????"	/* 39-32 */
+			"????????"	/* 31-24	0x00000000-ff000000 */
+			"????????"	/* 23-16	0x00000000-00ff0000 */
+			"???me???"	/* 15- 8	0x00000000-0000ff00 */
+			"?dai?c??"	/*  7- 0	0x00000000-000000ff */
+			;
+
+		printf("Attributes: %016llx (", stx->stx_attributes);
+		for (byte = 64 - 8; byte >= 0; byte -= 8) {
+			bits = stx->stx_attributes >> byte;
+			for (loop = 7; loop >= 0; loop--) {
+				int bit = byte + loop;
+
+				if (bits & 0x80)
+					putchar(attr_representation[63 - bit]);
+				else
+					putchar('-');
+				bits <<= 1;
+			}
+			if (byte)
+				putchar(' ');
+		}
+		printf(")\n");
+	}
+
+	printf("IO-blocksize: blksize=%u\n", stx->stx_blksize);
+}
+
+static void dump_hex(unsigned long long *data, int from, int to)
+{
+	unsigned offset, print_offset = 1, col = 0;
+
+	from /= 8;
+	to = (to + 7) / 8;
+
+	for (offset = from; offset < to; offset++) {
+		if (print_offset) {
+			printf("%04x: ", offset * 8);
+			print_offset = 0;
+		}
+		printf("%016llx", data[offset]);
+		col++;
+		if ((col & 3) == 0) {
+			printf("\n");
+			print_offset = 1;
+		} else {
+			printf(" ");
+		}
+	}
+
+	if (!print_offset)
+		printf("\n");
+}
+
+int main(int argc, char **argv)
+{
+	struct statx stx;
+	int ret, raw = 0, atflag = AT_SYMLINK_NOFOLLOW;
+
+	unsigned int mask = STATX_ALL;
+
+	for (argv++; *argv; argv++) {
+		if (strcmp(*argv, "-F") == 0) {
+			atflag &= ~AT_STATX_SYNC_TYPE;
+			atflag |= AT_STATX_FORCE_SYNC;
+			continue;
+		}
+		if (strcmp(*argv, "-D") == 0) {
+			atflag &= ~AT_STATX_SYNC_TYPE;
+			atflag |= AT_STATX_DONT_SYNC;
+			continue;
+		}
+		if (strcmp(*argv, "-L") == 0) {
+			atflag &= ~AT_SYMLINK_NOFOLLOW;
+			continue;
+		}
+		if (strcmp(*argv, "-O") == 0) {
+			mask &= ~STATX_BASIC_STATS;
+			continue;
+		}
+		if (strcmp(*argv, "-A") == 0) {
+			atflag |= AT_NO_AUTOMOUNT;
+			continue;
+		}
+		if (strcmp(*argv, "-R") == 0) {
+			raw = 1;
+			continue;
+		}
+
+		memset(&stx, 0xbf, sizeof(stx));
+		ret = statx(AT_FDCWD, *argv, atflag, mask, &stx);
+		printf("statx(%s) = %d\n", *argv, ret);
+		if (ret < 0) {
+			perror(*argv);
+			exit(1);
+		}
+
+		if (raw)
+			dump_hex((unsigned long long *)&stx, 0, sizeof(stx));
+
+		dump_statx(&stx);
+	}
+	return 0;
+}
