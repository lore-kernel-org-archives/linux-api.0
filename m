From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH 1/4] statx: Add a system call to make enhanced file info available [ver #3]
Date: Wed, 23 Nov 2016 15:57:08 -0700
Message-ID: <19284F6D-73B9-4A1A-8227-2B2B87F29FE9@dilger.ca>
References: <147986254484.19139.8038609825799670925.stgit@warthog.procyon.org.uk> <147986255194.19139.9583434946564699577.stgit@warthog.procyon.org.uk> <768343b5-e9b4-a86c-53de-2929bc290342@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_0FD01408-5544-478D-9C4B-044550E58904"; protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <768343b5-e9b4-a86c-53de-2929bc290342-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_0FD01408-5544-478D-9C4B-044550E58904
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 23, 2016, at 1:37 AM, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
>=20
> Hi David,
>=20
> On 11/23/2016 01:55 AM, David Howells wrote:
>> Add a system call to make extended file information available, =
including
>> file creation and some attribute flags where available through the
>> underlying filesystem.
>>=20
>>=20
>> =3D=3D=3D=3D=3D=3D=3D=3D
>> OVERVIEW
>> =3D=3D=3D=3D=3D=3D=3D=3D
>>=20
>> The idea was initially proposed as a set of xattrs that could be =
retrieved
>> with getxattr(), but the general preferance proved to be for a new =
syscall
>=20
> s/preferance/preference/
>=20
>> with an extended stat structure.
>>=20
>> This can feasibly be used to support a number of things, not all of =
which
>> are added here:
>=20
> It would be very useful if this overview distinguishes which of the =
features
> below are supported in the initial implementation, versus which =
features
> (e.g., femtosecond timestamps) are simply allowed for in a future
> implementation.
>=20
>> (1) Better support for the y2038 problem [Arnd Bergmann].
>>=20
>> (2) Creation time: The SMB protocol carries the creation time, which =
could
>>     be exported by Samba, which will in turn help CIFS make use of
>>     FS-Cache as that can be used for coherency data.
>>=20
>>     This is also specified in NFSv4 as a recommended attribute and =
could
>>     be exported by NFSD [Steve French].
>>=20
>> (3) Lightweight stat: Ask for just those details of interest, and =
allow a
>>     netfs (such as NFS) to approximate anything not of interest, =
possibly
>>     without going to the server [Trond Myklebust, Ulrich Drepper, =
Andreas
>>     Dilger].
>>=20
>> (4) Heavyweight stat: Force a netfs to go to the server, even if it =
thinks
>>     its cached attributes are up to date [Trond Myklebust].
>>=20
>> (5) Data version number: Could be used by userspace NFS servers =
[Aneesh
>>     Kumar].
>>=20
>>     Can also be used to modify fill_post_wcc() in NFSD which =
retrieves
>>     i_version directly, but has just called vfs_getattr().  It could =
get
>>     it from the kstat struct if it used vfs_xgetattr() instead.
>>=20
>> (6) BSD stat compatibility: Including more fields from the BSD stat =
such
>>     as creation time (st_btime) and inode generation number (st_gen)
>>     [Jeremy Allison, Bernd Schubert].
>>=20
>> (7) Inode generation number: Useful for FUSE and userspace NFS =
servers
>>     [Bernd Schubert].  This was asked for but later deemed =
unnecessary
>>     with the open-by-handle capability available
>>=20
>> (8) Extra coherency data may be useful in making backups [Andreas =
Dilger].
>=20
> Can you elaborate on the point [8] in this commit message. It's not =
clear
> to me at least what this is about.
>>=20
>> (9) Allow the filesystem to indicate what it can/cannot provide: A
>>     filesystem can now say it doesn't support a standard stat feature =
if
>>     that isn't available, so if, for instance, inode numbers or UIDs =
don't
>>     exist or are fabricated locally...
>>=20
>> (10) Make the fields a consistent size on all arches and make them =
large.
>>=20
>> (11) Store a 16-byte volume ID in the superblock that can be returned =
in
>>     struct xstat [Steve French].
>>=20
>> (12) Include granularity fields in the time data to indicate the
>>     granularity of each of the times (NFSv4 time_delta) [Steve =
French].
>>=20
>> (13) FS_IOC_GETFLAGS value.  These could be translated to BSD's =
st_flags.
>>     Note that the Linux IOC flags are a mess and filesystems such as =
Ext4
>>     define flags that aren't in linux/fs.h, so translation in the =
kernel
>>     may be a necessity (or, possibly, we provide the filesystem type =
too).
>>=20
>> (14) Mask of features available on file (eg: ACLs, seclabel) [Brad =
Boyer,
>>     Michael Kerrisk].
>>=20
>> (15) Spare space, request flags and information flags are provided =
for
>>     future expansion.
>>=20
>> (16) Femtosecond-resolution timestamps [Dave Chinner].
>>=20
>>=20
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> NEW SYSTEM CALL
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>=20
>> The new system call is:
>>=20
>> 	int ret =3D statx(int dfd,
>> 			const char *filename,
>> 			unsigned int flags,
>=20
> In the 0/4 of this patch series, this argument is called 'atflags'.
> These should be consistent. 'flags' seems correct to me.

Given that there are a number of different flags and masks in use for
this syscall, naming this field "atflags" makes it more clear what it
is used for.

>> 			unsigned int mask,

Similarly, naming this field "request_mask" would also be more clear,
and matches what is used elsewhere in the code.

That said, I don't care enough about this detail to request a patch =
refresh,
but it would be useful for the man pages.

Cheers, Andreas

>> 			struct statx *buffer);
>>=20
>> The dfd, filename and flags parameters indicate the file to query, in =
a
>> similar way to fstatat().  There is no equivalent of lstat() as that =
can be
>> emulated with statx() by passing AT_SYMLINK_NOFOLLOW in flags.  There =
is
>> also no equivalent of fstat() as that can be emulated by passing a =
NULL
>> filename to statx() with the fd of interest in dfd.
>>=20
>> Whether or not statx() synchronises the attributes with the backing =
store
>> can be controlled (this typically only affects network filesystems) =
can be
>> set by OR'ing a value into the flags argument:
>=20
> s/can be set//
>=20
>>=20
>> (1) AT_STATX_SYNC_AS_STAT tells statx() to behave as stat() does in =
this
>>     respect.
>>=20
>> (2) AT_STATX_FORCE_SYNC will require a network filesystem to =
synchronise
>>     its attributes with the server - which might require data =
writeback to
>>     occur to get the timestamps correct.
>>=20
>> (3) AT_STATX_DONT_SYNC will suppress synchronisation with the server =
in a
>>     network filesystem.  The resulting values should be considered
>>     approximate.
>>=20
>> mask is a bitmask indicating the fields in struct statx that are of
>> interest to the caller.  The user should set this to =
STATX_BASIC_STATS to
>> get the basic set returned by stat().  It should be note that asking =
for
>=20
> s/note/noted/
>=20
>> more information may entail extra I/O operations.
>>=20
>> buffer points to the destination for the data.  This must be 256 =
bytes in
>> size.
>>=20
>>=20
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> MAIN ATTRIBUTES RECORD
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>=20
>> The following structures are defined in which to return the main =
attribute
>> set:
>>=20
>> 	struct statx_timestamp {
>> 		__s64	tv_sec;
>> 		__s32	tv_nsec;
>> 		__s32	__reserved;
>> 	};
>>=20
>> 	struct statx {
>> 		__u32	stx_mask;
>> 		__u32	stx_blksize;
>> 		__u64	stx_attributes;
>> 		__u32	stx_nlink;
>> 		__u32	stx_uid;
>> 		__u32	stx_gid;
>> 		__u16	stx_mode;
>> 		__u16	__spare0[1];
>> 		__u64	stx_ino;
>> 		__u64	stx_size;
>> 		__u64	stx_blocks;
>> 		__u64	__spare1[1];
>> 		struct statx_timestamp	stx_atime;
>> 		struct statx_timestamp	stx_btime;
>> 		struct statx_timestamp	stx_ctime;
>> 		struct statx_timestamp	stx_mtime;
>> 		__u32	stx_rdev_major;
>> 		__u32	stx_rdev_minor;
>> 		__u32	stx_dev_major;
>> 		__u32	stx_dev_minor;
>> 		__u64	__spare2[14];
>> 	};
>>=20
>> The defined bits in request_mask and stx_mask are:
>>=20
>> 	STATX_TYPE		Want/got stx_mode & S_IFMT
>> 	STATX_MODE		Want/got stx_mode & ~S_IFMT
>> 	STATX_NLINK		Want/got stx_nlink
>> 	STATX_UID		Want/got stx_uid
>> 	STATX_GID		Want/got stx_gid
>> 	STATX_ATIME		Want/got stx_atime{,_ns}
>> 	STATX_MTIME		Want/got stx_mtime{,_ns}
>> 	STATX_CTIME		Want/got stx_ctime{,_ns}
>> 	STATX_INO		Want/got stx_ino
>> 	STATX_SIZE		Want/got stx_size
>> 	STATX_BLOCKS		Want/got stx_blocks
>> 	STATX_BASIC_STATS	[The stuff in the normal stat struct]
>> 	STATX_BTIME		Want/got stx_btime{,_ns}
>> 	STATX_ALL		[All currently available stuff]
>>=20
>> stx_btime is the file creation time, stx_mask is a bitmask indicating =
the
>> data provided and __spares*[] are where as-yet undefined fields can =
be
>> placed.
>>=20
>> Time fields are structures with separate seconds and nanoseconds =
fields
>> plus a reserved field in case we want to add even finer resolution.  =
Note
>> that times will be negative if before 1970; in such a case, the =
nanosecond
>> fields will also be negative if not zero.
>>=20
>> The bits defined in the stx_attributes field convey information about =
a
>> file, how it is accessed, where it is and what it does.  The =
following
>> attributes map to FS_*_FL flags and are the same numerical value:
>>=20
>> 	STATX_ATTR_COMPRESSED		File is compressed by the fs
>> 	STATX_ATTR_IMMUTABLE		File is marked immutable
>> 	STATX_ATTR_APPEND		File is append-only
>> 	STATX_ATTR_NODUMP		File is not to be dumped
>> 	STATX_ATTR_ENCRYPTED		File requires key to decrypt in =
fs
>>=20
>> Within the kernel, the supported flags are listed by:
>>=20
>> 	KSTAT_ATTR_FS_IOC_FLAGS
>>=20
>> [Are any other IOC flags of sufficient general interest to be exposed
>> through this interface?]
>>=20
>> New flags include:
>>=20
>> 	STATX_ATTR_AUTOMOUNT		Object is an automount trigger
>>=20
>> These are for the use of GUI tools that might want to mark files =
specially,
>> depending on what they are.
>>=20
>> Fields in struct statx come in a number of classes:
>>=20
>> (0) stx_dev_*, stx_blksize.
>>=20
>>     These are local system information and are always available.
>>=20
>> (1) stx_mode, stx_nlinks, stx_uid, stx_gid, stx_[amc]time, stx_ino,
>>     stx_size, stx_blocks.
>>=20
>>     These will be returned whether the caller asks for them or not.  =
The
>>     corresponding bits in stx_mask will be set to indicate whether =
they
>>     actually have valid values.
>>=20
>>     If the caller didn't ask for them, then they may be approximated. =
 For
>>     example, NFS won't waste any time updating them from the server,
>>     unless as a byproduct of updating something requested.
>>=20
>>     If the values don't actually exist for the underlying object =
(such as
>>     UID or GID on a DOS file), then the bit won't be set in the =
stx_mask,
>>     even if the caller asked for the value.  In such a case, the =
returned
>>     value will be a fabrication.
>>=20
>>     Note that there are instances where the type might not be valid, =
for
>>     instance Windows reparse points.
>>=20
>> (2) stx_rdev_*.
>>=20
>>     This will be set only if stx_mode indicates we're looking at a
>>     blockdev or a chardev, otherwise will be 0.
>>=20
>> (3) stx_btime.
>>=20
>>     Similar to (1), except this will be set to 0 if it doesn't exist.
>>=20
>>=20
>> =3D=3D=3D=3D=3D=3D=3D
>> TESTING
>> =3D=3D=3D=3D=3D=3D=3D
>>=20
>> The following test program can be used to test the statx system call:
>>=20
>> 	samples/statx/test-statx.c
>>=20
>> Just compile and run, passing it paths to the files you want to =
examine.
>> The file is built automatically if CONFIG_SAMPLES is enabled.
>>=20
>> Here's some example output.  Firstly, an NFS directory that crosses =
to
>> another FSID.  Note that the AUTOMOUNT attribute is set because =
transiting
>> this directory will cause d_automount to be invoked by the VFS.
>>=20
>> 	[root@andromeda tmp]# ./samples/statx/test-statx -A =
/warthog/data
>> 	statx(/warthog/data) =3D 0
>> 	results=3D17ff
>> 	  Size: 4096            Blocks: 8          IO Block: 1048576  =
directory
>> 	Device: 00:26           Inode: 1703937     Links: 124
>> 	Access: (3777/drwxrwxrwx)  Uid:     0   Gid:  4041
>> 	Access: 2016-11-10 15:52:11.219935864+0000
>> 	Modify: 2016-11-10 08:07:32.482314928+0000
>> 	Change: 2016-11-10 08:07:32.482314928+0000
>> 	Attributes: 0000000000001000 (-------- -------- -------- =
-------- -------- -------- ---m---- --------)
>> 	IO-blocksize: blksize=3D1048576
>>=20
>> Secondly, the result of automounting on that directory.
>>=20
>> 	[root@andromeda tmp]# ./samples/statx/test-statx /warthog/data
>> 	statx(/warthog/data) =3D 0
>> 	results=3D17ff
>> 	  Size: 4096            Blocks: 8          IO Block: 1048576  =
directory
>> 	Device: 00:27           Inode: 2           Links: 124
>> 	Access: (3777/drwxrwxrwx)  Uid:     0   Gid:  4041
>> 	Access: 2016-11-10 15:52:11.219935864+0000
>> 	Modify: 2016-11-10 08:07:32.482314928+0000
>> 	Change: 2016-11-10 08:07:32.482314928+0000
>> 	IO-blocksize: blksize=3D1048576
>>=20
>> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>=20
>> arch/x86/entry/syscalls/syscall_32.tbl |    1
>> arch/x86/entry/syscalls/syscall_64.tbl |    1
>> fs/exportfs/expfs.c                    |    4
>> fs/stat.c                              |  297 =
+++++++++++++++++++++++++++++---
>> include/linux/fs.h                     |    5 -
>> include/linux/stat.h                   |   19 +-
>> include/linux/syscalls.h               |    3
>> include/uapi/linux/fcntl.h             |    5 +
>> include/uapi/linux/stat.h              |  120 +++++++++++++
>> samples/Kconfig                        |    5 +
>> samples/Makefile                       |    3
>> samples/statx/Makefile                 |   10 +
>> samples/statx/test-statx.c             |  248 =
+++++++++++++++++++++++++++
>> 13 files changed, 681 insertions(+), 40 deletions(-)
>> create mode 100644 samples/statx/Makefile
>> create mode 100644 samples/statx/test-statx.c
>>=20
>> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl =
b/arch/x86/entry/syscalls/syscall_32.tbl
>> index 2b3618542544..9ba050fe47f3 100644
>> --- a/arch/x86/entry/syscalls/syscall_32.tbl
>> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
>> @@ -389,3 +389,4 @@
>> 380	i386	pkey_mprotect		sys_pkey_mprotect
>> 381	i386	pkey_alloc		sys_pkey_alloc
>> 382	i386	pkey_free		sys_pkey_free
>> +383	i386	statx			sys_statx
>> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl =
b/arch/x86/entry/syscalls/syscall_64.tbl
>> index e93ef0b38db8..5aef183e2f85 100644
>> --- a/arch/x86/entry/syscalls/syscall_64.tbl
>> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
>> @@ -338,6 +338,7 @@
>> 329	common	pkey_mprotect		sys_pkey_mprotect
>> 330	common	pkey_alloc		sys_pkey_alloc
>> 331	common	pkey_free		sys_pkey_free
>> +332	common	statx			sys_statx
>>=20
>> #
>> # x32-specific system call numbers start at 512 to avoid cache impact
>> diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
>> index a4b531be9168..2acc31751248 100644
>> --- a/fs/exportfs/expfs.c
>> +++ b/fs/exportfs/expfs.c
>> @@ -299,7 +299,9 @@ static int get_name(const struct path *path, char =
*name, struct dentry *child)
>> 	 * filesystem supports 64-bit inode numbers.  So we need to
>> 	 * actually call ->getattr, not just read i_ino:
>> 	 */
>> -	error =3D vfs_getattr_nosec(&child_path, &stat);
>> +	stat.query_flags =3D 0;
>> +	stat.request_mask =3D STATX_BASIC_STATS;
>> +	error =3D vfs_xgetattr_nosec(&child_path, &stat);
>> 	if (error)
>> 		return error;
>> 	buffer.ino =3D stat.ino;
>> diff --git a/fs/stat.c b/fs/stat.c
>> index bc045c7994e1..82e656c42157 100644
>> --- a/fs/stat.c
>> +++ b/fs/stat.c
>> @@ -18,6 +18,15 @@
>> #include <asm/uaccess.h>
>> #include <asm/unistd.h>
>>=20
>> +/**
>> + * generic_fillattr - Fill in the basic attributes from the inode =
struct
>> + * @inode: Inode to use as the source
>> + * @stat: Where to fill in the attributes
>> + *
>> + * Fill in the basic attributes in the kstat structure from data =
that's to be
>> + * found on the VFS inode structure.  This is the default if no =
getattr inode
>> + * operation is supplied.
>> + */
>> void generic_fillattr(struct inode *inode, struct kstat *stat)
>> {
>> 	stat->dev =3D inode->i_sb->s_dev;
>> @@ -27,87 +36,189 @@ void generic_fillattr(struct inode *inode, =
struct kstat *stat)
>> 	stat->uid =3D inode->i_uid;
>> 	stat->gid =3D inode->i_gid;
>> 	stat->rdev =3D inode->i_rdev;
>> -	stat->size =3D i_size_read(inode);
>> -	stat->atime =3D inode->i_atime;
>> 	stat->mtime =3D inode->i_mtime;
>> 	stat->ctime =3D inode->i_ctime;
>> -	stat->blksize =3D (1 << inode->i_blkbits);
>> +	stat->size =3D i_size_read(inode);
>> 	stat->blocks =3D inode->i_blocks;
>> -}
>> +	stat->blksize =3D 1 << inode->i_blkbits;
>>=20
>> +	stat->result_mask |=3D STATX_BASIC_STATS;
>> +	if (IS_NOATIME(inode))
>> +		stat->result_mask &=3D ~STATX_ATIME;
>> +	else
>> +		stat->atime =3D inode->i_atime;
>> +
>> +	if (IS_AUTOMOUNT(inode))
>> +		stat->attributes |=3D STATX_ATTR_AUTOMOUNT;
>> +}
>> EXPORT_SYMBOL(generic_fillattr);
>>=20
>> /**
>> - * vfs_getattr_nosec - getattr without security checks
>> + * vfs_xgetattr_nosec - getattr without security checks
>>  * @path: file to get attributes from
>>  * @stat: structure to return attributes in
>>  *
>>  * Get attributes without calling security_inode_getattr.
>>  *
>> - * Currently the only caller other than vfs_getattr is internal to =
the
>> - * filehandle lookup code, which uses only the inode number and =
returns
>> - * no attributes to any user.  Any other code probably wants
>> - * vfs_getattr.
>> + * Currently the only caller other than vfs_xgetattr is internal to =
the
>> + * filehandle lookup code, which uses only the inode number and =
returns no
>> + * attributes to any user.  Any other code probably wants =
vfs_xgetattr.
>> + *
>> + * The caller must set stat->request_mask to indicate what they want =
and
>> + * stat->query_flags to indicate whether the server should be =
queried.
>>  */
>> -int vfs_getattr_nosec(struct path *path, struct kstat *stat)
>> +int vfs_xgetattr_nosec(struct path *path, struct kstat *stat)
>> {
>> 	struct inode *inode =3D d_backing_inode(path->dentry);
>>=20
>> +	stat->query_flags &=3D ~KSTAT_QUERY_FLAGS;
>> +
>> +	stat->result_mask =3D 0;
>> +	stat->attributes =3D 0;
>> 	if (inode->i_op->getattr)
>> 		return inode->i_op->getattr(path->mnt, path->dentry, =
stat);
>>=20
>> 	generic_fillattr(inode, stat);
>> 	return 0;
>> }
>> +EXPORT_SYMBOL(vfs_xgetattr_nosec);
>>=20
>> -EXPORT_SYMBOL(vfs_getattr_nosec);
>> -
>> -int vfs_getattr(struct path *path, struct kstat *stat)
>> +/*
>> + * vfs_xgetattr - Get the enhanced basic attributes of a file
>> + * @path: The file of interest
>> + * @stat: Where to return the statistics
>> + *
>> + * Ask the filesystem for a file's attributes.  The caller must have =
preset
>> + * stat->request_mask and stat->query_flags to indicate what they =
want.
>> + *
>> + * If the file is remote, the filesystem can be forced to update the =
attributes
>> + * from the backing store by passing AT_FORCE_ATTR_SYNC in =
query_flags or can
>> + * suppress the update by passing AT_NO_ATTR_SYNC.
>> + *
>> + * Bits must have been set in stat->request_mask to indicate which =
attributes
>> + * the caller wants retrieving.  Any such attribute not requested =
may be
>> + * returned anyway, but the value may be approximate, and, if =
remote, may not
>> + * have been synchronised with the server.
>> + *
>> + * 0 will be returned on success, and a -ve error code if =
unsuccessful.
>> + */
>> +int vfs_xgetattr(struct path *path, struct kstat *stat)
>> {
>> 	int retval;
>>=20
>> 	retval =3D security_inode_getattr(path);
>> 	if (retval)
>> 		return retval;
>> -	return vfs_getattr_nosec(path, stat);
>> +	return vfs_xgetattr_nosec(path, stat);
>> }
>> +EXPORT_SYMBOL(vfs_xgetattr);
>>=20
>> +/**
>> + * vfs_getattr - Get the basic attributes of a file
>> + * @path: The file of interest
>> + * @stat: Where to return the statistics
>> + *
>> + * Ask the filesystem for a file's attributes.  If remote, the =
filesystem isn't
>> + * forced to update its files from the backing store.  Only the =
basic set of
>> + * attributes will be retrieved; anyone wanting more must use =
vfs_xgetattr(),
>> + * as must anyone who wants to force attributes to be sync'd with =
the server.
>> + *
>> + * 0 will be returned on success, and a -ve error code if =
unsuccessful.
>> + */
>> +int vfs_getattr(struct path *path, struct kstat *stat)
>> +{
>> +	stat->query_flags =3D 0;
>> +	stat->request_mask =3D STATX_BASIC_STATS;
>> +	return vfs_xgetattr(path, stat);
>> +}
>> EXPORT_SYMBOL(vfs_getattr);
>>=20
>> -int vfs_fstat(unsigned int fd, struct kstat *stat)
>> +/**
>> + * vfs_fstatx - Get the enhanced basic attributes by file descriptor
>> + * @fd: The file descriptor referring to the file of interest
>> + * @stat: The result structure to fill in.
>> + *
>> + * This function is a wrapper around vfs_xgetattr().  The main =
difference is
>> + * that it uses a file descriptor to determine the file location.
>> + *
>> + * The caller must have preset stat->query_flags and =
stat->request_mask as for
>> + * vfs_xgetattr().
>> + *
>> + * 0 will be returned on success, and a -ve error code if =
unsuccessful.
>> + */
>> +int vfs_fstatx(unsigned int fd, struct kstat *stat)
>> {
>> 	struct fd f =3D fdget_raw(fd);
>> 	int error =3D -EBADF;
>>=20
>> 	if (f.file) {
>> -		error =3D vfs_getattr(&f.file->f_path, stat);
>> +		error =3D vfs_xgetattr(&f.file->f_path, stat);
>> 		fdput(f);
>> 	}
>> 	return error;
>> }
>> +EXPORT_SYMBOL(vfs_fstatx);
>> +
>> +/**
>> + * vfs_fstat - Get basic attributes by file descriptor
>> + * @fd: The file descriptor referring to the file of interest
>> + * @stat: The result structure to fill in.
>> + *
>> + * This function is a wrapper around vfs_getattr().  The main =
difference is
>> + * that it uses a file descriptor to determine the file location.
>> + *
>> + * 0 will be returned on success, and a -ve error code if =
unsuccessful.
>> + */
>> +int vfs_fstat(unsigned int fd, struct kstat *stat)
>> +{
>> +	stat->query_flags =3D 0;
>> +	stat->request_mask =3D STATX_BASIC_STATS;
>> +	return vfs_fstatx(fd, stat);
>> +}
>> EXPORT_SYMBOL(vfs_fstat);
>>=20
>> -int vfs_fstatat(int dfd, const char __user *filename, struct kstat =
*stat,
>> -		int flag)
>> +/**
>> + * vfs_statx - Get basic and extra attributes by filename
>> + * @dfd: A file descriptor representing the base dir for a relative =
filename
>> + * @filename: The name of the file of interest
>> + * @flags: Flags to control the query
>> + * @stat: The result structure to fill in.
>> + *
>> + * This function is a wrapper around vfs_xgetattr().  The main =
difference is
>> + * that it uses a filename and base directory to determine the file =
location.
>> + * Additionally, the addition of AT_SYMLINK_NOFOLLOW to flags will =
prevent a
>=20
> s/the addition of AT_SYMLINK_NOFOLLOW to/the use of =
AT_SYMLINK_NOFOLLOW in/
>=20
>=20
>> + * symlink at the given name from being referenced.
>> + *
>> + * The caller must have preset stat->request_mask as for =
vfs_xgetattr().  The
>> + * flags are also used to load up stat->query_flags.
>> + *
>> + * 0 will be returned on success, and a -ve error code if =
unsuccessful.
>> + */
>> +int vfs_statx(int dfd, const char __user *filename, int flags,
>> +	      struct kstat *stat)
>> {
>> 	struct path path;
>> 	int error =3D -EINVAL;
>> -	unsigned int lookup_flags =3D 0;
>> +	unsigned int lookup_flags =3D LOOKUP_FOLLOW | LOOKUP_AUTOMOUNT;
>>=20
>> -	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT |
>> -		      AT_EMPTY_PATH)) !=3D 0)
>> -		goto out;
>> +	if ((flags & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT |
>> +		       AT_EMPTY_PATH | KSTAT_QUERY_FLAGS)) !=3D 0)
>> +		return -EINVAL;
>>=20
>> -	if (!(flag & AT_SYMLINK_NOFOLLOW))
>> -		lookup_flags |=3D LOOKUP_FOLLOW;
>> -	if (flag & AT_EMPTY_PATH)
>> +	if (flags & AT_SYMLINK_NOFOLLOW)
>> +		lookup_flags &=3D ~LOOKUP_FOLLOW;
>> +	if (flags & AT_NO_AUTOMOUNT)
>> +		lookup_flags &=3D ~LOOKUP_AUTOMOUNT;
>> +	if (flags & AT_EMPTY_PATH)
>> 		lookup_flags |=3D LOOKUP_EMPTY;
>> +	stat->query_flags =3D flags;
>> +
>> retry:
>> 	error =3D user_path_at(dfd, filename, lookup_flags, &path);
>> 	if (error)
>> 		goto out;
>>=20
>> -	error =3D vfs_getattr(&path, stat);
>> +	error =3D vfs_xgetattr(&path, stat);
>> 	path_put(&path);
>> 	if (retry_estale(error, lookup_flags)) {
>> 		lookup_flags |=3D LOOKUP_REVAL;
>> @@ -116,17 +227,65 @@ int vfs_fstatat(int dfd, const char __user =
*filename, struct kstat *stat,
>> out:
>> 	return error;
>> }
>> +EXPORT_SYMBOL(vfs_statx);
>> +
>> +/**
>> + * vfs_fstatat - Get basic attributes by filename
>> + * @dfd: A file descriptor representing the base dir for a relative =
filename
>> + * @filename: The name of the file of interest
>> + * @flags: Flags to control the query
>> + * @stat: The result structure to fill in.
>> + *
>> + * This function is a wrapper around vfs_statx().  The difference is =
that it
>> + * preselects basic stats only.  The flags are used to load up
>> + * stat->query_flags in addition to indicating symlink handling =
during path
>> + * resolution.
>> + *
>> + * 0 will be returned on success, and a -ve error code if =
unsuccessful.
>> + */
>> +int vfs_fstatat(int dfd, const char __user *filename, struct kstat =
*stat,
>> +		int flags)
>> +{
>> +	stat->request_mask =3D STATX_BASIC_STATS;
>> +	return vfs_statx(dfd, filename, flags, stat);
>> +}
>> EXPORT_SYMBOL(vfs_fstatat);
>>=20
>> -int vfs_stat(const char __user *name, struct kstat *stat)
>> +/**
>> + * vfs_stat - Get basic attributes by filename
>> + * @filename: The name of the file of interest
>> + * @stat: The result structure to fill in.
>> + *
>> + * This function is a wrapper around vfs_statx().  The difference is =
that it
>> + * preselects basic stats only, terminal symlinks are followed =
regardless and a
>=20
> s/terminal symlinks/symlinks in the basename/
>=20
>> + * remote filesystem can't be forced to query the server.  If such =
is desired,
>> + * vfs_statx() should be used instead.
>> + *
>> + * 0 will be returned on success, and a -ve error code if =
unsuccessful.
>> + */
>> +int vfs_stat(const char __user *filename, struct kstat *stat)
>> {
>> -	return vfs_fstatat(AT_FDCWD, name, stat, 0);
>> +	stat->request_mask =3D STATX_BASIC_STATS;
>> +	return vfs_statx(AT_FDCWD, filename, 0, stat);
>> }
>> EXPORT_SYMBOL(vfs_stat);
>>=20
>> +/**
>> + * vfs_lstat - Get basic attrs by filename, without following =
terminal symlink
>> + * @filename: The name of the file of interest
>> + * @stat: The result structure to fill in.
>> + *
>> + * This function is a wrapper around vfs_statx().  The difference is =
that it
>> + * preselects basic stats only, terminal symlinks are note followed =
regardless
>=20
> s/terminal symlinks/symlinks in the basename/
> s/note/not/
>=20
>=20
>> + * and a remote filesystem can't be forced to query the server.  If =
such is
>> + * desired, vfs_statx() should be used instead.
>> + *
>> + * 0 will be returned on success, and a -ve error code if =
unsuccessful.
>> + */
>> int vfs_lstat(const char __user *name, struct kstat *stat)
>> {
>> -	return vfs_fstatat(AT_FDCWD, name, stat, AT_SYMLINK_NOFOLLOW);
>> +	stat->request_mask =3D STATX_BASIC_STATS;
>> +	return vfs_statx(AT_FDCWD, name, AT_SYMLINK_NOFOLLOW, stat);
>> }
>> EXPORT_SYMBOL(vfs_lstat);
>>=20
>> @@ -141,7 +300,7 @@ static int cp_old_stat(struct kstat *stat, struct =
__old_kernel_stat __user * sta
>> {
>> 	static int warncount =3D 5;
>> 	struct __old_kernel_stat tmp;
>> -
>> +
>> 	if (warncount > 0) {
>> 		warncount--;
>> 		printk(KERN_WARNING "VFS: Warning: %s using old stat() =
call. Recompile your binary.\n",
>> @@ -166,7 +325,7 @@ static int cp_old_stat(struct kstat *stat, struct =
__old_kernel_stat __user * sta
>> #if BITS_PER_LONG =3D=3D 32
>> 	if (stat->size > MAX_NON_LFS)
>> 		return -EOVERFLOW;
>> -#endif
>> +#endif
>> 	tmp.st_size =3D stat->size;
>> 	tmp.st_atime =3D stat->atime.tv_sec;
>> 	tmp.st_mtime =3D stat->mtime.tv_sec;
>> @@ -443,6 +602,82 @@ SYSCALL_DEFINE4(fstatat64, int, dfd, const char =
__user *, filename,
>> }
>> #endif /* __ARCH_WANT_STAT64 || __ARCH_WANT_COMPAT_STAT64 */
>>=20
>> +/*
>> + * Set the statx results.
>> + */
>> +static long statx_set_result(struct kstat *stat, struct statx __user =
*buffer)
>> +{
>> +	uid_t uid =3D from_kuid_munged(current_user_ns(), stat->uid);
>> +	gid_t gid =3D from_kgid_munged(current_user_ns(), stat->gid);
>> +
>> +#define __put_timestamp(kts, uts) (				\
>> +		__put_user(kts.tv_sec,	uts.tv_sec	) ||	\
>> +		__put_user(kts.tv_nsec,	uts.tv_nsec	) ||		=
\
>> +		__put_user(0,		uts.__reserved	))
>> +
>> +	if (__put_user(stat->result_mask,	&buffer->stx_mask	=
) ||
>> +	    __put_user(stat->mode,		&buffer->stx_mode	=
) ||
>> +	    __clear_user(&buffer->__spare0, sizeof(buffer->__spare0))	 =
 ||
>> +	    __put_user(stat->nlink,		&buffer->stx_nlink	=
) ||
>> +	    __put_user(uid,			&buffer->stx_uid	=
) ||
>> +	    __put_user(gid,			&buffer->stx_gid	=
) ||
>> +	    __put_user(stat->attributes,	&buffer->stx_attributes	=
) ||
>> +	    __put_user(stat->blksize,		&buffer->stx_blksize	=
) ||
>> +	    __put_user(MAJOR(stat->rdev),	&buffer->stx_rdev_major	=
) ||
>> +	    __put_user(MINOR(stat->rdev),	&buffer->stx_rdev_minor	=
) ||
>> +	    __put_user(MAJOR(stat->dev),	&buffer->stx_dev_major	=
) ||
>> +	    __put_user(MINOR(stat->dev),	&buffer->stx_dev_minor	=
) ||
>> +	    __put_timestamp(stat->atime,	&buffer->stx_atime	=
) ||
>> +	    __put_timestamp(stat->btime,	&buffer->stx_btime	=
) ||
>> +	    __put_timestamp(stat->ctime,	&buffer->stx_ctime	=
) ||
>> +	    __put_timestamp(stat->mtime,	&buffer->stx_mtime	=
) ||
>> +	    __put_user(stat->ino,		&buffer->stx_ino	=
) ||
>> +	    __put_user(stat->size,		&buffer->stx_size	=
) ||
>> +	    __put_user(stat->blocks,		&buffer->stx_blocks	=
) ||
>> +	    __clear_user(&buffer->__spare1, sizeof(buffer->__spare1))	 =
 ||
>> +	    __clear_user(&buffer->__spare2, sizeof(buffer->__spare2)))
>> +		return -EFAULT;
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + * sys_statx - System call to get enhanced stats
>> + * @dfd: Base directory to pathwalk from *or* fd to stat.
>> + * @filename: File to stat *or* NULL.
>> + * @flags: AT_* flags to control pathwalk.
>> + * @mask: Parts of statx struct actually required.
>> + * @buffer: Result buffer.
>> + *
>> + * Note that if filename is NULL, then it does the equivalent of =
fstat() using
>> + * dfd to indicate the file of interest.
>> + */
>> +SYSCALL_DEFINE5(statx,
>> +		int, dfd, const char __user *, filename, unsigned, =
flags,
>> +		unsigned int, mask,
>> +		struct statx __user *, buffer)
>> +{
>> +	struct kstat stat;
>> +	int error;
>> +
>> +	if ((flags & AT_STATX_SYNC_TYPE) =3D=3D AT_STATX_SYNC_TYPE)
>> +		return -EINVAL;
>> +	if (!access_ok(VERIFY_WRITE, buffer, sizeof(*buffer)))
>> +		return -EFAULT;
>> +
>> +	memset(&stat, 0, sizeof(stat));
>> +	stat.query_flags =3D flags;
>> +	stat.request_mask =3D mask & STATX_ALL;
>> +
>> +	if (filename)
>> +		error =3D vfs_statx(dfd, filename, flags, &stat);
>> +	else
>> +		error =3D vfs_fstatx(dfd, &stat);
>> +	if (error)
>> +		return error;
>> +	return statx_set_result(&stat, buffer);
>> +}
>> +
>> /* Caller is here responsible for sufficient locking (ie. =
inode->i_lock) */
>> void __inode_add_bytes(struct inode *inode, loff_t bytes)
>> {
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 16d2b6e874d6..f153199566b4 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -2916,8 +2916,9 @@ extern const struct inode_operations =
page_symlink_inode_operations;
>> extern void kfree_link(void *);
>> extern int generic_readlink(struct dentry *, char __user *, int);
>> extern void generic_fillattr(struct inode *, struct kstat *);
>> -int vfs_getattr_nosec(struct path *path, struct kstat *stat);
>> +extern int vfs_xgetattr_nosec(struct path *path, struct kstat =
*stat);
>> extern int vfs_getattr(struct path *, struct kstat *);
>> +extern int vfs_xgetattr(struct path *, struct kstat *);
>> void __inode_add_bytes(struct inode *inode, loff_t bytes);
>> void inode_add_bytes(struct inode *inode, loff_t bytes);
>> void __inode_sub_bytes(struct inode *inode, loff_t bytes);
>> @@ -2935,6 +2936,8 @@ extern int vfs_lstat(const char __user *, =
struct kstat *);
>> extern int vfs_fstat(unsigned int, struct kstat *);
>> extern int vfs_fstatat(int , const char __user *, struct kstat *, =
int);
>> extern const char *vfs_get_link(struct dentry *, struct delayed_call =
*);
>> +extern int vfs_xstat(int, const char __user *, int, struct kstat *);
>> +extern int vfs_xfstat(unsigned int, struct kstat *);
>>=20
>> extern int __generic_block_fiemap(struct inode *inode,
>> 				  struct fiemap_extent_info *fieinfo,
>> diff --git a/include/linux/stat.h b/include/linux/stat.h
>> index 075cb0c7eb2a..9b81dfcbb57a 100644
>> --- a/include/linux/stat.h
>> +++ b/include/linux/stat.h
>> @@ -19,19 +19,26 @@
>> #include <linux/uidgid.h>
>>=20
>> struct kstat {
>> -	u64		ino;
>> -	dev_t		dev;
>> +	u32		query_flags;	/* Operational flags */
>> +#define KSTAT_QUERY_FLAGS (AT_STATX_SYNC_TYPE)
>> +	u32		request_mask;	/* What fields the user asked =
for */
>> +	u32		result_mask;	/* What fields the user got */
>> 	umode_t		mode;
>> 	unsigned int	nlink;
>> +	uint32_t	blksize;	/* Preferred I/O size */
>> +	u64		attributes;
>> +#define KSTAT_ATTR_FS_IOC_FLAGS		0x00000874 /* Attrs =
corresponding to FS_*_FL flags */
>> +	u64		ino;
>> +	dev_t		dev;
>> +	dev_t		rdev;
>> 	kuid_t		uid;
>> 	kgid_t		gid;
>> -	dev_t		rdev;
>> 	loff_t		size;
>> -	struct timespec  atime;
>> +	struct timespec	atime;
>> 	struct timespec	mtime;
>> 	struct timespec	ctime;
>> -	unsigned long	blksize;
>> -	unsigned long long	blocks;
>> +	struct timespec	btime;			/* File creation time */
>> +	u64		blocks;
>> };
>>=20
>> #endif
>> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
>> index 91a740f6b884..980c3c9b06f8 100644
>> --- a/include/linux/syscalls.h
>> +++ b/include/linux/syscalls.h
>> @@ -48,6 +48,7 @@ struct stat;
>> struct stat64;
>> struct statfs;
>> struct statfs64;
>> +struct statx;
>> struct __sysctl_args;
>> struct sysinfo;
>> struct timespec;
>> @@ -902,5 +903,7 @@ asmlinkage long sys_pkey_mprotect(unsigned long =
start, size_t len,
>> 				  unsigned long prot, int pkey);
>> asmlinkage long sys_pkey_alloc(unsigned long flags, unsigned long =
init_val);
>> asmlinkage long sys_pkey_free(int pkey);
>> +asmlinkage long sys_statx(int dfd, const char __user *path, unsigned =
flags,
>> +			  unsigned mask, struct statx __user *buffer);
>>=20
>> #endif
>> diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
>> index beed138bd359..813afd6eee71 100644
>> --- a/include/uapi/linux/fcntl.h
>> +++ b/include/uapi/linux/fcntl.h
>> @@ -63,5 +63,10 @@
>> #define AT_NO_AUTOMOUNT		0x800	/* Suppress terminal =
automount traversal */
>> #define AT_EMPTY_PATH		0x1000	/* Allow empty relative =
pathname */
>>=20
>> +#define AT_STATX_SYNC_TYPE	0x6000	/* Type of synchronisation =
required from statx() */
>> +#define AT_STATX_SYNC_AS_STAT	0x0000	/* - Do whatever stat() =
does */
>> +#define AT_STATX_FORCE_SYNC	0x2000	/* - Force the attributes to be =
sync'd with the server */
>> +#define AT_STATX_DONT_SYNC	0x4000	/* - Don't sync attributes with =
the server */
>> +
>>=20
>> #endif /* _UAPI_LINUX_FCNTL_H */
>> diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
>> index 7fec7e36d921..995e82fe019c 100644
>> --- a/include/uapi/linux/stat.h
>> +++ b/include/uapi/linux/stat.h
>> @@ -1,6 +1,7 @@
>> #ifndef _UAPI_LINUX_STAT_H
>> #define _UAPI_LINUX_STAT_H
>>=20
>> +#include <linux/types.h>
>>=20
>> #if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
>>=20
>> @@ -41,5 +42,124 @@
>>=20
>> #endif
>>=20
>> +/*
>> + * Timestamp structure for the timestamps in struct statx.
>> + */
>> +struct statx_timestamp {
>> +	__s64	tv_sec;		/* Number of seconds before or after =
midnight 1st Jan 1970 */
>> +	__s32	tv_nsec;	/* Number of nanoseconds before or after =
sec (0-999,999,999) */
>=20
> Here, add a note in the comment: "Will be a negative value (if =
nonzero) if tv_sec is negative"
>=20
> [...]
>=20
> Cheers,
>=20
> Michael
>=20
>=20
>=20
> --
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_0FD01408-5544-478D-9C4B-044550E58904
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWDYexHKl2rkXzB/gAQiT/Q//UpJI4rqg9oV6qvJmSu8E1wtZ77ud5q8R
vYlsa1neXylwL0AwQT1eJ4d4DHliuI1ywKXCS3nhzAxPTegrB0lW/lxN9uAU7F/K
jbpRrahSYqUB1dwDfeon0eHhU2ZacrNf1zb6Jpq9PHsv5jsPdTgGLhwqeD0PtoD8
NVJpw7jm/Uf0ec3tVXXD7XdnoyJwccLmLc3J2mQq1LTNg+IQ77Bkne1D+FT/mBrq
+XAWGytQF9CU0XRhc2+O98KF9v5WEdE9LMxhMNMcgbvhLWl4IaUYhYYHkrnqQxVM
AvVS5zJhPREVhR9qc9mb7ECavsT4pSZqCTYbtofn6Fk3XCSlRhV9oqZIMPKTg+D9
NguXUbBEbXoNcdvcoUqCJ1CPRj/Tgv9u/fMUjneiEv3b571h9PSlZWXX44vhmz4O
iqHeu4SCUbc5fBikFbqb+V+caL9fBlQi+SaDYlRqFeKRq4C3kQ0tuGOMs0W9ncpr
IznemDNdS0nft0JTLsnJu1pSUfswE0VggfEjv/Z0J8rr4ZzLGG6HNP3jZJhavCrW
+RZWd6tlNgn2bIAQ+n/kIbpDOg1jCOUPLIPhwLZpBq9zXALxiUmYSyJXiZUtgLJR
7HT14pgf51mbn1nPHMGHsCPrsZbkDWDLsIDLwfduf9afUHkrWjv7OcGqXrfPP0jZ
RyIM4vFSYKw=
=69XP
-----END PGP SIGNATURE-----

--Apple-Mail=_0FD01408-5544-478D-9C4B-044550E58904--
