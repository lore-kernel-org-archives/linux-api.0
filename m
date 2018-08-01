From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/5] vfs: syscall: Add fsinfo() to query filesystem
 information
Date: Wed, 01 Aug 2018 17:14:01 +0100
Message-ID: <153314004147.18964.11925284995448007945.stgit@warthog.procyon.org.uk>
References: <153314002975.18964.1773855756473041897.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153314002975.18964.1773855756473041897.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: linux-api@vger.kernel.org, torvalds@linux-foundation.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add a system call to allow filesystem information to be queried.  A request
value can be given to indicate the desired attribute.  Support is provided
for enumerating multi-value attributes.

===============
NEW SYSTEM CALL
===============

The new system call looks like:

	int ret = fsinfo(int dfd,
			 const char *filename,
			 const struct fsinfo_params *params,
			 void *buffer,
			 size_t buf_size);

The params parameter optionally points to a block of parameters:

	struct fsinfo_params {
		__u32	at_flags;
		__u32	request;
		__u32	Nth;
		__u32	Mth;
		__u32	__reserved[6];
	};

If params is NULL, it is assumed params->request should be
fsinfo_attr_statfs, params->Nth should be 0, params->Mth should be 0 and
params->at_flags should be 0.

If params is given, all of params->__reserved[] must be 0.

dfd, filename and params->at_flags indicate the file to query.  There is no
equivalent of lstat() as that can be emulated with fsinfo() by setting
AT_SYMLINK_NOFOLLOW in params->at_flags.  There is also no equivalent of
fstat() as that can be emulated by passing a NULL filename to fsinfo() with
the fd of interest in dfd.  AT_NO_AUTOMOUNT can also be used to an allow
automount point to be queried without triggering it.

params->request indicates the attribute/attributes to be queried.  This can
be one of:

	FSINFO_ATTR_STATFS		- statfs-style info
	FSINFO_ATTR_FSINFO		- Information about fsinfo()
	FSINFO_ATTR_IDS			- Filesystem IDs
	FSINFO_ATTR_LIMITS		- Filesystem limits
	FSINFO_ATTR_SUPPORTS		- What's supported in statx(), IOC flags
	FSINFO_ATTR_CAPABILITIES	- Filesystem capabilities
	FSINFO_ATTR_TIMESTAMP_INFO	- Inode timestamp info
	FSINFO_ATTR_VOLUME_ID		- Volume ID (string)
	FSINFO_ATTR_VOLUME_UUID		- Volume UUID
	FSINFO_ATTR_VOLUME_NAME		- Volume name (string)
	FSINFO_ATTR_CELL_NAME		- Cell name (string)
	FSINFO_ATTR_DOMAIN_NAME		- Domain name (string)
	FSINFO_ATTR_REALM_NAME		- Realm name (string)
	FSINFO_ATTR_SERVER_NAME		- Name of the Nth server (string)
	FSINFO_ATTR_SERVER_ADDRESS	- Mth address of the Nth server
	FSINFO_ATTR_PARAMETER		- Nth mount parameter (string)
	FSINFO_ATTR_SOURCE		- Nth mount source name (string)
	FSINFO_ATTR_NAME_ENCODING	- Filename encoding (string)
	FSINFO_ATTR_NAME_CODEPAGE	- Filename codepage (string)
	FSINFO_ATTR_IO_SIZE		- I/O size hints

Some attributes (such as the servers backing a network filesystem) can have
multiple values.  These can be enumerated by setting params->Nth and
params->Mth to 0, 1, ... until ENODATA is returned.

buffer and buf_size point to the reply buffer.  The buffer is filled up to
the specified size, even if this means truncating the reply.  The full size
of the reply is returned.  In future versions, this will allow extra fields
to be tacked on to the end of the reply, but anyone not expecting them will
only get the subset they're expecting.  If either buffer of buf_size are 0,
no copy will take place and the data size will be returned.

At the moment, this will only work on x86_64 and i386 as it requires the
system call to be wired up.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-api@vger.kernel.org
---

 arch/x86/entry/syscalls/syscall_32.tbl |    1 
 arch/x86/entry/syscalls/syscall_64.tbl |    1 
 fs/statfs.c                            |  462 +++++++++++++++++++++++++++
 include/linux/fs.h                     |    4 
 include/linux/fsinfo.h                 |   41 ++
 include/linux/syscalls.h               |    4 
 include/uapi/linux/fsinfo.h            |  235 ++++++++++++++
 samples/statx/Makefile                 |    5 
 samples/statx/test-fsinfo.c            |  546 ++++++++++++++++++++++++++++++++
 9 files changed, 1298 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/fsinfo.h
 create mode 100644 include/uapi/linux/fsinfo.h
 create mode 100644 samples/statx/test-fsinfo.c

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index d1eb6c815790..806760188a31 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -404,3 +404,4 @@
 390	i386	fsconfig		sys_fsconfig			__ia32_sys_fsconfig
 391	i386	fsmount			sys_fsmount			__ia32_sys_fsmount
 392	i386	fspick			sys_fspick			__ia32_sys_fspick
+393	i386	fsinfo			sys_fsinfo			__ia32_sys_fsinfo
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index d3ab703c02bb..0823eed2b02e 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -349,6 +349,7 @@
 338	common	fsconfig		__x64_sys_fsconfig
 339	common	fsmount			__x64_sys_fsmount
 340	common	fspick			__x64_sys_fspick
+341	common	fsinfo			__x64_sys_fsinfo
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/statfs.c b/fs/statfs.c
index 5b2a24f0f263..87826933faa0 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -9,6 +9,7 @@
 #include <linux/security.h>
 #include <linux/uaccess.h>
 #include <linux/compat.h>
+#include <linux/fsinfo.h>
 #include "internal.h"
 
 static int flags_by_mnt(int mnt_flags)
@@ -384,3 +385,464 @@ COMPAT_SYSCALL_DEFINE2(ustat, unsigned, dev, struct compat_ustat __user *, u)
 	return 0;
 }
 #endif
+
+/*
+ * Get basic filesystem stats from statfs.
+ */
+static int fsinfo_generic_statfs(struct dentry *dentry,
+				 struct fsinfo_statfs *p)
+{
+	struct super_block *sb;
+	struct kstatfs buf;
+	int ret;
+
+	ret = statfs_by_dentry(dentry, &buf);
+	if (ret < 0)
+		return ret;
+
+	sb = dentry->d_sb;
+	p->f_blocks	= buf.f_blocks;
+	p->f_bfree	= buf.f_bfree;
+	p->f_bavail	= buf.f_bavail;
+	p->f_files	= buf.f_files;
+	p->f_ffree	= buf.f_ffree;
+	p->f_favail	= buf.f_ffree;
+	p->f_bsize	= buf.f_bsize;
+	p->f_frsize	= buf.f_frsize;
+	return sizeof(*p);
+}
+
+static int fsinfo_generic_ids(struct dentry *dentry,
+			      struct fsinfo_ids *p)
+{
+	struct super_block *sb;
+	struct kstatfs buf;
+	int ret;
+
+	ret = statfs_by_dentry(dentry, &buf);
+	if (ret < 0)
+		return ret;
+
+	sb = dentry->d_sb;
+	p->f_fstype	= sb->s_magic;
+	p->f_dev_major	= MAJOR(sb->s_dev);
+	p->f_dev_minor	= MINOR(sb->s_dev);
+	p->f_flags	= ST_VALID | flags_by_sb(sb->s_flags);
+
+	memcpy(&p->f_fsid, &buf.f_fsid, sizeof(p->f_fsid));
+	strlcpy(p->f_fs_name, dentry->d_sb->s_type->name, sizeof(p->f_fs_name));
+	return sizeof(*p);
+}
+
+static int fsinfo_generic_limits(struct dentry *dentry,
+				 struct fsinfo_limits *lim)
+{
+	struct super_block *sb = dentry->d_sb;
+
+	lim->max_file_size = sb->s_maxbytes;
+	lim->max_hard_links = sb->s_max_links;
+	lim->max_uid = UINT_MAX;
+	lim->max_gid = UINT_MAX;
+	lim->max_projid = UINT_MAX;
+	lim->max_filename_len = NAME_MAX;
+	lim->max_symlink_len = PAGE_SIZE;
+	lim->max_xattr_name_len = XATTR_NAME_MAX;
+	lim->max_xattr_body_len = XATTR_SIZE_MAX;
+	lim->max_dev_major = 0xffffff;
+	lim->max_dev_minor = 0xff;
+	return sizeof(*lim);
+}
+
+static int fsinfo_generic_supports(struct dentry *dentry,
+				   struct fsinfo_supports *c)
+{
+	struct super_block *sb = dentry->d_sb;
+
+	c->stx_mask = STATX_BASIC_STATS;
+	if (sb->s_d_op && sb->s_d_op->d_automount)
+		c->stx_attributes |= STATX_ATTR_AUTOMOUNT;
+	return sizeof(*c);
+}
+
+static int fsinfo_generic_capabilities(struct dentry *dentry,
+				       struct fsinfo_capabilities *c)
+{
+	struct super_block *sb = dentry->d_sb;
+
+	if (sb->s_mtd)
+		fsinfo_set_cap(c, FSINFO_CAP_IS_FLASH_FS);
+	else if (sb->s_bdev)
+		fsinfo_set_cap(c, FSINFO_CAP_IS_BLOCK_FS);
+
+	if (sb->s_quota_types & QTYPE_MASK_USR)
+		fsinfo_set_cap(c, FSINFO_CAP_USER_QUOTAS);
+	if (sb->s_quota_types & QTYPE_MASK_GRP)
+		fsinfo_set_cap(c, FSINFO_CAP_GROUP_QUOTAS);
+	if (sb->s_quota_types & QTYPE_MASK_PRJ)
+		fsinfo_set_cap(c, FSINFO_CAP_PROJECT_QUOTAS);
+	if (sb->s_d_op && sb->s_d_op->d_automount)
+		fsinfo_set_cap(c, FSINFO_CAP_AUTOMOUNTS);
+	if (sb->s_id[0])
+		fsinfo_set_cap(c, FSINFO_CAP_VOLUME_ID);
+
+	fsinfo_set_cap(c, FSINFO_CAP_HAS_ATIME);
+	fsinfo_set_cap(c, FSINFO_CAP_HAS_CTIME);
+	fsinfo_set_cap(c, FSINFO_CAP_HAS_MTIME);
+	return sizeof(*c);
+}
+
+static int fsinfo_generic_timestamp_info(struct dentry *dentry,
+					 struct fsinfo_timestamp_info *ts)
+{
+	struct super_block *sb = dentry->d_sb;
+
+	/* If unset, assume 1s granularity */
+	u16 mantissa = 1;
+	s8 exponent = 0;
+
+	ts->minimum_timestamp = S64_MIN;
+	ts->maximum_timestamp = S64_MAX;
+	if (sb->s_time_gran < 1000000000) {
+		if (sb->s_time_gran < 1000)
+			exponent = -9;
+		else if (sb->s_time_gran < 1000000)
+			exponent = -6;
+		else
+			exponent = -3;
+	}
+#define set_gran(x)				\
+	do {					\
+		ts->x##_mantissa = mantissa;	\
+		ts->x##_exponent = exponent;	\
+	} while (0)
+	set_gran(atime_gran);
+	set_gran(btime_gran);
+	set_gran(ctime_gran);
+	set_gran(mtime_gran);
+	return sizeof(*ts);
+}
+
+static int fsinfo_generic_volume_uuid(struct dentry *dentry,
+				      struct fsinfo_volume_uuid *vu)
+{
+	struct super_block *sb = dentry->d_sb;
+
+	memcpy(vu, &sb->s_uuid, sizeof(*vu));
+	return sizeof(*vu);
+}
+
+static int fsinfo_generic_volume_id(struct dentry *dentry, char *buf)
+{
+	struct super_block *sb = dentry->d_sb;
+	size_t len = strlen(sb->s_id);
+
+	memcpy(buf, sb->s_id, len + 1);
+	return len;
+}
+
+static int fsinfo_generic_name_encoding(struct dentry *dentry, char *buf)
+{
+	static const char encoding[] = "utf8";
+
+	memcpy(buf, encoding, sizeof(encoding) - 1);
+	return sizeof(encoding) - 1;
+}
+
+static int fsinfo_generic_io_size(struct dentry *dentry,
+				  struct fsinfo_io_size *c)
+{
+	struct super_block *sb = dentry->d_sb;
+	struct kstatfs buf;
+	int ret;
+
+	if (sb->s_op->statfs == simple_statfs) {
+		c->dio_size_gran = 1;
+		c->dio_mem_align = 1;
+	} else {
+		ret = statfs_by_dentry(dentry, &buf);
+		if (ret < 0)
+			return ret;
+		c->dio_size_gran = buf.f_bsize;
+		c->dio_mem_align = buf.f_bsize;
+	}
+	return sizeof(*c);
+}
+
+/*
+ * Implement some queries generically from stuff in the superblock.
+ */
+int generic_fsinfo(struct dentry *dentry, struct fsinfo_kparams *params)
+{
+#define _gen(X, Y) FSINFO_ATTR_##X: return fsinfo_generic_##Y(dentry, params->buffer)
+
+	switch (params->request) {
+	case _gen(STATFS,		statfs);
+	case _gen(IDS,			ids);
+	case _gen(LIMITS,		limits);
+	case _gen(SUPPORTS,		supports);
+	case _gen(CAPABILITIES,		capabilities);
+	case _gen(TIMESTAMP_INFO,	timestamp_info);
+	case _gen(VOLUME_UUID,		volume_uuid);
+	case _gen(VOLUME_ID,		volume_id);
+	case _gen(NAME_ENCODING,	name_encoding);
+	case _gen(IO_SIZE,		io_size);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL(generic_fsinfo);
+
+/*
+ * Retrieve the filesystem info.  We make some stuff up if the operation is not
+ * supported.
+ */
+int vfs_fsinfo(const struct path *path, struct fsinfo_kparams *params)
+{
+	struct dentry *dentry = path->dentry;
+	int (*get_fsinfo)(struct dentry *, struct fsinfo_kparams *);
+	int ret;
+
+	if (params->request == FSINFO_ATTR_FSINFO) {
+		struct fsinfo_fsinfo *info = params->buffer;
+
+		info->max_attr	= FSINFO_ATTR__NR;
+		info->max_cap	= FSINFO_CAP__NR;
+		return sizeof(*info);
+	}
+
+	get_fsinfo = dentry->d_sb->s_op->get_fsinfo;
+	if (!get_fsinfo) {
+		if (!dentry->d_sb->s_op->statfs)
+			return -EOPNOTSUPP;
+		get_fsinfo = generic_fsinfo;
+	}
+
+	ret = security_sb_statfs(dentry);
+	if (ret)
+		return ret;
+
+	ret = get_fsinfo(dentry, params);
+	if (ret < 0)
+		return ret;
+
+	if (params->request == FSINFO_ATTR_IDS &&
+	    params->buffer) {
+		struct fsinfo_ids *p = params->buffer;
+
+		p->f_flags |= flags_by_mnt(path->mnt->mnt_flags);
+	}
+	return ret;
+}
+
+static int vfs_fsinfo_path(int dfd, const char __user *filename,
+			   struct fsinfo_kparams *params)
+{
+	struct path path;
+	unsigned lookup_flags = LOOKUP_FOLLOW | LOOKUP_AUTOMOUNT;
+	int ret = -EINVAL;
+
+	if ((params->at_flags & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT |
+				 AT_EMPTY_PATH)) != 0)
+		return -EINVAL;
+
+	if (params->at_flags & AT_SYMLINK_NOFOLLOW)
+		lookup_flags &= ~LOOKUP_FOLLOW;
+	if (params->at_flags & AT_NO_AUTOMOUNT)
+		lookup_flags &= ~LOOKUP_AUTOMOUNT;
+	if (params->at_flags & AT_EMPTY_PATH)
+		lookup_flags |= LOOKUP_EMPTY;
+
+retry:
+	ret = user_path_at(dfd, filename, lookup_flags, &path);
+	if (ret)
+		goto out;
+
+	ret = vfs_fsinfo(&path, params);
+	path_put(&path);
+	if (retry_estale(ret, lookup_flags)) {
+		lookup_flags |= LOOKUP_REVAL;
+		goto retry;
+	}
+out:
+	return ret;
+}
+
+static int vfs_fsinfo_fd(unsigned int fd, struct fsinfo_kparams *params)
+{
+	struct fd f = fdget_raw(fd);
+	int ret = -EBADF;
+
+	if (f.file) {
+		ret = vfs_fsinfo(&f.file->f_path, params);
+		fdput(f);
+	}
+	return ret;
+}
+
+/*
+ * Return buffer information by requestable attribute.
+ *
+ * STRUCT indicates a fixed-size structure with only one instance.
+ * STRUCT_N indicates a 1D array of STRUCT, indexed by Nth
+ * STRUCT_NM indicates a 2D-array of STRUCT, indexed by Nth, Mth
+ * STRING indicates a string with only one instance.
+ * STRING_N indicates a 1D array of STRING, indexed by Nth
+ * STRING_NM indicates a 2D-array of STRING, indexed by Nth, Mth
+ *
+ * If an entry is marked STRUCT, STRUCT_N or STRUCT_NM then if no buffer is
+ * supplied to sys_fsinfo(), sys_fsinfo() will handle returning the buffer size
+ * without calling vfs_fsinfo() and the filesystem.
+ *
+ * No struct may have more than 252 bytes (ie. 0x3f * 4)
+ */
+#define FSINFO_STRING(X,Y)	 [FSINFO_ATTR_##X] = 0x0000
+#define FSINFO_STRUCT(X,Y)	 [FSINFO_ATTR_##X] = sizeof(struct fsinfo_##Y)
+#define FSINFO_STRING_N(X,Y)	 [FSINFO_ATTR_##X] = 0x4000
+#define FSINFO_STRUCT_N(X,Y)	 [FSINFO_ATTR_##X] = 0x4000 | sizeof(struct fsinfo_##Y)
+#define FSINFO_STRUCT_NM(X,Y)	 [FSINFO_ATTR_##X] = 0x8000 | sizeof(struct fsinfo_##Y)
+#define FSINFO_STRING_NM(X,Y)	 [FSINFO_ATTR_##X] = 0x8000
+static const u16 fsinfo_buffer_sizes[FSINFO_ATTR__NR] = {
+	FSINFO_STRUCT		(STATFS,		statfs),
+	FSINFO_STRUCT		(FSINFO,		fsinfo),
+	FSINFO_STRUCT		(IDS,			ids),
+	FSINFO_STRUCT		(LIMITS,		limits),
+	FSINFO_STRUCT		(CAPABILITIES,		capabilities),
+	FSINFO_STRUCT		(SUPPORTS,		supports),
+	FSINFO_STRUCT		(TIMESTAMP_INFO,	timestamp_info),
+	FSINFO_STRING		(VOLUME_ID,		volume_id),
+	FSINFO_STRUCT		(VOLUME_UUID,		volume_uuid),
+	FSINFO_STRING		(VOLUME_NAME,		volume_name),
+	FSINFO_STRING		(CELL_NAME,		cell_name),
+	FSINFO_STRING		(DOMAIN_NAME,		domain_name),
+	FSINFO_STRING		(REALM_NAME,		realm_name),
+	FSINFO_STRING_N		(SERVER_NAME,		server_name),
+	FSINFO_STRUCT_NM	(SERVER_ADDRESS,	server_address),
+	FSINFO_STRING_NM	(PARAMETER,		parameter),
+	FSINFO_STRING_N		(SOURCE,		source),
+	FSINFO_STRING		(NAME_ENCODING,		name_encoding),
+	FSINFO_STRING		(NAME_CODEPAGE,		name_codepage),
+	FSINFO_STRUCT		(IO_SIZE,		io_size),
+};
+
+/**
+ * sys_fsinfo - System call to get filesystem information
+ * @dfd: Base directory to pathwalk from or fd referring to filesystem.
+ * @filename: Filesystem to query or NULL.
+ * @_params: Parameters to define request (or NULL for enhanced statfs).
+ * @_buffer: Result buffer.
+ * @buf_size: Size of result buffer.
+ *
+ * Get information on a filesystem.  The filesystem attribute to be queried is
+ * indicated by @_params->request, and some of the attributes can have multiple
+ * values, indexed by @_params->Nth and @_params->Mth.  If @_params is NULL,
+ * then the 0th fsinfo_attr_statfs attribute is queried.  If an attribute does
+ * not exist, EOPNOTSUPP is returned; if the Nth,Mth value does not exist,
+ * ENODATA is returned.
+ *
+ * On success, the size of the attribute's value is returned.  If @buf_size is
+ * 0 or @_buffer is NULL, only the size is returned.  If the size of the value
+ * is larger than @buf_size, it will be truncated by the copy.  If the size of
+ * the value is smaller than @buf_size then the excess buffer space will be
+ * cleared.  The full size of the value will be returned, irrespective of how
+ * much data is actually placed in the buffer.
+ */
+SYSCALL_DEFINE5(fsinfo,
+		int, dfd, const char __user *, filename,
+		struct fsinfo_params __user *, _params,
+		void __user *, _buffer, size_t, buf_size)
+{
+	struct fsinfo_params user_params;
+	struct fsinfo_kparams params;
+	size_t size, n;
+	int ret;
+
+	if (_params) {
+		if (copy_from_user(&user_params, _params, sizeof(user_params)))
+			return -EFAULT;
+		if (user_params.__reserved[0] ||
+		    user_params.__reserved[1] ||
+		    user_params.__reserved[2] ||
+		    user_params.__reserved[3] ||
+		    user_params.__reserved[4] ||
+		    user_params.__reserved[5])
+			return -EINVAL;
+		if (user_params.request >= FSINFO_ATTR__NR)
+			return -EOPNOTSUPP;
+		params.at_flags = user_params.at_flags;
+		params.request = user_params.request;
+		params.Nth = user_params.Nth;
+		params.Mth = user_params.Mth;
+	} else {
+		params.at_flags = 0;
+		params.request = FSINFO_ATTR_STATFS;
+		params.Nth = 0;
+		params.Mth = 0;
+	}
+
+	if (!_buffer || !buf_size) {
+		buf_size = 0;
+		_buffer = NULL;
+	}
+
+	/* Allocate an appropriately-sized buffer.  We will truncate the
+	 * contents when we write the contents back to userspace.
+	 */
+	size = fsinfo_buffer_sizes[params.request];
+	switch (size & 0xc000) {
+	case 0x0000:
+		if (params.Nth != 0)
+			return -ENODATA;
+		/* Fall through */
+	case 0x4000:
+		if (params.Mth != 0)
+			return -ENODATA;
+		/* Fall through */
+	case 0x8000:
+		break;
+	case 0xc000:
+		return -ENOBUFS;
+	}
+
+	size &= ~0xc000;
+	if (size == 0) {
+		params.string_val = true;
+		params.buf_size = 4096;
+	} else {
+		params.string_val = false;
+		params.buf_size = size;
+		if (buf_size == 0)
+			return size; /* We know how big the buffer should be */
+	}
+
+	/* We always allocate a buffer for a string, even if buf_size == 0 and
+	 * we're not going to return any data.  This means that the filesystem
+	 * code needn't care about whether the buffer actually exists or not.
+	 */
+	params.buffer = kzalloc(params.buf_size, GFP_KERNEL);
+	if (!params.buffer)
+		return -ENOMEM;
+
+	if (filename)
+		ret = vfs_fsinfo_path(dfd, filename, &params);
+	else
+		ret = vfs_fsinfo_fd(dfd, &params);
+	if (ret < 0)
+		goto error;
+
+	n = ret;
+	if (n > buf_size)
+		n = buf_size;
+
+	if (n > 0 && copy_to_user(_buffer, params.buffer, buf_size))
+		ret = -EFAULT;
+
+	/* Clear any part of the buffer that we won't fill if we're putting a
+	 * struct in there rather than a string.
+	 */
+	if (buf_size > n && !params.string_val &&
+	    clear_user(_buffer + n, buf_size - n) != 0)
+		return -EFAULT;
+error:
+	kfree(params.buffer);
+	return ret;
+}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3e661d033163..053d53861995 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -64,6 +64,8 @@ struct fscrypt_operations;
 struct fs_context;
 struct fsconfig_parser;
 struct fsconfig_param;
+struct fsinfo_kparams;
+enum fsinfo_attribute;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -1849,6 +1851,7 @@ struct super_operations {
 	int (*thaw_super) (struct super_block *);
 	int (*unfreeze_fs) (struct super_block *);
 	int (*statfs) (struct dentry *, struct kstatfs *);
+	int (*get_fsinfo) (struct dentry *, struct fsinfo_kparams *);
 	int (*remount_fs) (struct super_block *, int *, char *, size_t);
 	int (*reconfigure) (struct super_block *, struct fs_context *);
 	void (*umount_begin) (struct super_block *);
@@ -2226,6 +2229,7 @@ extern int iterate_mounts(int (*)(struct vfsmount *, void *), void *,
 extern int vfs_statfs(const struct path *, struct kstatfs *);
 extern int user_statfs(const char __user *, struct kstatfs *);
 extern int fd_statfs(int, struct kstatfs *);
+extern int vfs_fsinfo(const struct path *, struct fsinfo_kparams *);
 extern int freeze_super(struct super_block *super);
 extern int thaw_super(struct super_block *super);
 extern bool our_mnt(struct vfsmount *mnt);
diff --git a/include/linux/fsinfo.h b/include/linux/fsinfo.h
new file mode 100644
index 000000000000..f2d25b898d48
--- /dev/null
+++ b/include/linux/fsinfo.h
@@ -0,0 +1,41 @@
+/* Filesystem information query
+ *
+ * Copyright (C) 2018 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _LINUX_FSINFO_H
+#define _LINUX_FSINFO_H
+
+#include <uapi/linux/fsinfo.h>
+
+struct fsinfo_kparams {
+	__u32			at_flags;	/* AT_SYMLINK_NOFOLLOW and similar */
+	enum fsinfo_attribute	request;	/* What is being asking for */
+	__u32			Nth;		/* Instance of it (some may have multiple) */
+	__u32			Mth;		/* Subinstance */
+	bool			string_val;	/* T if variable-length string value */
+	void			*buffer;	/* Where to place the reply */
+	size_t			buf_size;	/* Size of the buffer */
+};
+
+extern int generic_fsinfo(struct dentry *, struct fsinfo_kparams *);
+
+static inline void fsinfo_set_cap(struct fsinfo_capabilities *c,
+				  enum fsinfo_capability cap)
+{
+	c->capabilities[cap / 8] |= 1 << (cap % 8);
+}
+
+static inline void fsinfo_clear_cap(struct fsinfo_capabilities *c,
+				    enum fsinfo_capability cap)
+{
+	c->capabilities[cap / 8] &= ~(1 << (cap % 8));
+}
+
+#endif /* _LINUX_FSINFO_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 701522957a12..bc7173c09f4d 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -49,6 +49,7 @@ struct stat64;
 struct statfs;
 struct statfs64;
 struct statx;
+struct fsinfo_params;
 struct __sysctl_args;
 struct sysinfo;
 struct timespec;
@@ -909,6 +910,9 @@ asmlinkage long sys_fsconfig(int fs_fd, unsigned int cmd, const char __user *key
 			     const void __user *value, int aux);
 asmlinkage long sys_fsmount(int fs_fd, unsigned int flags, unsigned int ms_flags);
 asmlinkage long sys_fspick(int dfd, const char __user *path, unsigned int flags);
+asmlinkage long sys_fsinfo(int dfd, const char __user *path,
+			   struct fsinfo_params __user *params,
+			   void __user *buffer, size_t buf_size);
 
 /*
  * Architecture-specific system calls
diff --git a/include/uapi/linux/fsinfo.h b/include/uapi/linux/fsinfo.h
new file mode 100644
index 000000000000..ca82cfb5f38a
--- /dev/null
+++ b/include/uapi/linux/fsinfo.h
@@ -0,0 +1,235 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* fsinfo() definitions.
+ *
+ * Copyright (C) 2018 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ */
+#ifndef _UAPI_LINUX_FSINFO_H
+#define _UAPI_LINUX_FSINFO_H
+
+#include <linux/types.h>
+#include <linux/socket.h>
+
+/*
+ * The filesystem attributes that can be requested.  Note that some attributes
+ * may have multiple instances which can be switched in the parameter block.
+ */
+enum fsinfo_attribute {
+	FSINFO_ATTR_STATFS		= 0,	/* statfs()-style state */
+	FSINFO_ATTR_FSINFO		= 1,	/* Information about fsinfo() */
+	FSINFO_ATTR_IDS			= 2,	/* Filesystem IDs */
+	FSINFO_ATTR_LIMITS		= 3,	/* Filesystem limits */
+	FSINFO_ATTR_SUPPORTS		= 4,	/* What's supported in statx, iocflags, ... */
+	FSINFO_ATTR_CAPABILITIES	= 5,	/* Filesystem capabilities (bits) */
+	FSINFO_ATTR_TIMESTAMP_INFO	= 6,	/* Inode timestamp info */
+	FSINFO_ATTR_VOLUME_ID		= 7,	/* Volume ID (string) */
+	FSINFO_ATTR_VOLUME_UUID		= 8,	/* Volume UUID (LE uuid) */
+	FSINFO_ATTR_VOLUME_NAME		= 9,	/* Volume name (string) */
+	FSINFO_ATTR_CELL_NAME		= 10,	/* Cell name (string) */
+	FSINFO_ATTR_DOMAIN_NAME		= 11,	/* Domain name (string) */
+	FSINFO_ATTR_REALM_NAME		= 12,	/* Realm name (string) */
+	FSINFO_ATTR_SERVER_NAME		= 13,	/* Name of the Nth server */
+	FSINFO_ATTR_SERVER_ADDRESS	= 14,	/* Mth address of the Nth server */
+	FSINFO_ATTR_PARAMETER		= 15,	/* Nth mount parameter (string) */
+	FSINFO_ATTR_SOURCE		= 16,	/* Nth mount source name (string) */
+	FSINFO_ATTR_NAME_ENCODING	= 17,	/* Filename encoding (string) */
+	FSINFO_ATTR_NAME_CODEPAGE	= 18,	/* Filename codepage (string) */
+	FSINFO_ATTR_IO_SIZE		= 19,	/* Optimal I/O sizes */
+	FSINFO_ATTR__NR
+};
+
+/*
+ * Optional fsinfo() parameter structure.
+ *
+ * If this is not given, it is assumed that fsinfo_attr_statfs instance 0,0 is
+ * desired.
+ */
+struct fsinfo_params {
+	__u32	at_flags;	/* AT_SYMLINK_NOFOLLOW and similar flags */
+	__u32	request;	/* What is being asking for (enum fsinfo_attribute) */
+	__u32	Nth;		/* Instance of it (some may have multiple) */
+	__u32	Mth;		/* Subinstance of Nth instance */
+	__u32	__reserved[6];	/* Reserved params; all must be 0 */
+};
+
+/*
+ * Information struct for fsinfo(fsinfo_attr_statfs).
+ * - This gives extended filesystem information.
+ */
+struct fsinfo_statfs {
+	__u64	f_blocks;	/* Total number of blocks in fs */
+	__u64	f_bfree;	/* Total number of free blocks */
+	__u64	f_bavail;	/* Number of free blocks available to ordinary user */
+	__u64	f_files;	/* Total number of file nodes in fs */
+	__u64	f_ffree;	/* Number of free file nodes */
+	__u64	f_favail;	/* Number of free file nodes available to ordinary user */
+	__u32	f_bsize;	/* Optimal block size */
+	__u32	f_frsize;	/* Fragment size */
+};
+
+/*
+ * Information struct for fsinfo(fsinfo_attr_ids).
+ *
+ * List of basic identifiers as is normally found in statfs().
+ */
+struct fsinfo_ids {
+	char	f_fs_name[15 + 1];
+	__u64	f_flags;	/* Filesystem mount flags (MS_*) */
+	__u64	f_fsid;		/* Short 64-bit Filesystem ID (as statfs) */
+	__u64	f_sb_id;	/* Internal superblock ID for sbnotify()/mntnotify() */
+	__u32	f_fstype;	/* Filesystem type from linux/magic.h [uncond] */
+	__u32	f_dev_major;	/* As st_dev_* from struct statx [uncond] */
+	__u32	f_dev_minor;
+	__u32	__reserved[1];
+};
+
+/*
+ * Information struct for fsinfo(fsinfo_attr_limits).
+ *
+ * List of supported filesystem limits.
+ */
+struct fsinfo_limits {
+	__u64	max_file_size;			/* Maximum file size */
+	__u64	max_uid;			/* Maximum UID supported */
+	__u64	max_gid;			/* Maximum GID supported */
+	__u64	max_projid;			/* Maximum project ID supported */
+	__u32	max_dev_major;			/* Maximum device major representable */
+	__u32	max_dev_minor;			/* Maximum device minor representable */
+	__u32	max_hard_links;			/* Maximum number of hard links on a file */
+	__u32	max_xattr_body_len;		/* Maximum xattr content length */
+	__u32	max_xattr_name_len;		/* Maximum xattr name length */
+	__u32	max_filename_len;		/* Maximum filename length */
+	__u32	max_symlink_len;		/* Maximum symlink content length */
+	__u32	__reserved[1];
+};
+
+/*
+ * Information struct for fsinfo(fsinfo_attr_supports).
+ *
+ * What's supported in various masks, such as statx() attribute and mask bits
+ * and IOC flags.
+ */
+struct fsinfo_supports {
+	__u64	stx_attributes;		/* What statx::stx_attributes are supported */
+	__u32	stx_mask;		/* What statx::stx_mask bits are supported */
+	__u32	ioc_flags;		/* What FS_IOC_* flags are supported */
+	__u32	win_file_attrs;		/* What DOS/Windows FILE_* attributes are supported */
+	__u32	__reserved[1];
+};
+
+/*
+ * Information struct for fsinfo(fsinfo_attr_capabilities).
+ *
+ * Bitmask indicating filesystem capabilities where renderable as single bits.
+ */
+enum fsinfo_capability {
+	FSINFO_CAP_IS_KERNEL_FS		= 0,	/* fs is kernel-special filesystem */
+	FSINFO_CAP_IS_BLOCK_FS		= 1,	/* fs is block-based filesystem */
+	FSINFO_CAP_IS_FLASH_FS		= 2,	/* fs is flash filesystem */
+	FSINFO_CAP_IS_NETWORK_FS	= 3,	/* fs is network filesystem */
+	FSINFO_CAP_IS_AUTOMOUNTER_FS	= 4,	/* fs is automounter special filesystem */
+	FSINFO_CAP_AUTOMOUNTS		= 5,	/* fs supports automounts */
+	FSINFO_CAP_ADV_LOCKS		= 6,	/* fs supports advisory file locking */
+	FSINFO_CAP_MAND_LOCKS		= 7,	/* fs supports mandatory file locking */
+	FSINFO_CAP_LEASES		= 8,	/* fs supports file leases */
+	FSINFO_CAP_UIDS			= 9,	/* fs supports numeric uids */
+	FSINFO_CAP_GIDS			= 10,	/* fs supports numeric gids */
+	FSINFO_CAP_PROJIDS		= 11,	/* fs supports numeric project ids */
+	FSINFO_CAP_ID_NAMES		= 12,	/* fs supports user names */
+	FSINFO_CAP_ID_GUIDS		= 13,	/* fs supports user guids */
+	FSINFO_CAP_WINDOWS_ATTRS	= 14,	/* fs has windows attributes */
+	FSINFO_CAP_USER_QUOTAS		= 15,	/* fs has per-user quotas */
+	FSINFO_CAP_GROUP_QUOTAS		= 16,	/* fs has per-group quotas */
+	FSINFO_CAP_PROJECT_QUOTAS	= 17,	/* fs has per-project quotas */
+	FSINFO_CAP_XATTRS		= 18,	/* fs has xattrs */
+	FSINFO_CAP_JOURNAL		= 19,	/* fs has a journal */
+	FSINFO_CAP_DATA_IS_JOURNALLED	= 20,	/* fs is using data journalling */
+	FSINFO_CAP_O_SYNC		= 21,	/* fs supports O_SYNC */
+	FSINFO_CAP_O_DIRECT		= 22,	/* fs supports O_DIRECT */
+	FSINFO_CAP_VOLUME_ID		= 23,	/* fs has a volume ID */
+	FSINFO_CAP_VOLUME_UUID		= 24,	/* fs has a volume UUID */
+	FSINFO_CAP_VOLUME_NAME		= 25,	/* fs has a volume name */
+	FSINFO_CAP_VOLUME_FSID		= 26,	/* fs has a volume FSID */
+	FSINFO_CAP_CELL_NAME		= 27,	/* fs has a cell name */
+	FSINFO_CAP_DOMAIN_NAME		= 28,	/* fs has a domain name */
+	FSINFO_CAP_REALM_NAME		= 29,	/* fs has a realm name */
+	FSINFO_CAP_IVER_ALL_CHANGE	= 30,	/* i_version represents data + meta changes */
+	FSINFO_CAP_IVER_DATA_CHANGE	= 31,	/* i_version represents data changes only */
+	FSINFO_CAP_IVER_MONO_INCR	= 32,	/* i_version incremented monotonically */
+	FSINFO_CAP_SYMLINKS		= 33,	/* fs supports symlinks */
+	FSINFO_CAP_HARD_LINKS		= 34,	/* fs supports hard links */
+	FSINFO_CAP_HARD_LINKS_1DIR	= 35,	/* fs supports hard links in same dir only */
+	FSINFO_CAP_DEVICE_FILES		= 36,	/* fs supports bdev, cdev */
+	FSINFO_CAP_UNIX_SPECIALS	= 37,	/* fs supports pipe, fifo, socket */
+	FSINFO_CAP_RESOURCE_FORKS	= 38,	/* fs supports resource forks/streams */
+	FSINFO_CAP_NAME_CASE_INDEP	= 39,	/* Filename case independence is mandatory */
+	FSINFO_CAP_NAME_NON_UTF8	= 40,	/* fs has non-utf8 names */
+	FSINFO_CAP_NAME_HAS_CODEPAGE	= 41,	/* fs has a filename codepage */
+	FSINFO_CAP_SPARSE		= 42,	/* fs supports sparse files */
+	FSINFO_CAP_NOT_PERSISTENT	= 43,	/* fs is not persistent */
+	FSINFO_CAP_NO_UNIX_MODE		= 44,	/* fs does not support unix mode bits */
+	FSINFO_CAP_HAS_ATIME		= 45,	/* fs supports access time */
+	FSINFO_CAP_HAS_BTIME		= 46,	/* fs supports birth/creation time */
+	FSINFO_CAP_HAS_CTIME		= 47,	/* fs supports change time */
+	FSINFO_CAP_HAS_MTIME		= 48,	/* fs supports modification time */
+	FSINFO_CAP__NR
+};
+
+struct fsinfo_capabilities {
+	__u8	capabilities[(FSINFO_CAP__NR + 7) / 8];
+};
+
+/*
+ * Information struct for fsinfo(fsinfo_attr_timestamp_info).
+ */
+struct fsinfo_timestamp_info {
+	__s64	minimum_timestamp;	/* Minimum timestamp value in seconds */
+	__s64	maximum_timestamp;	/* Maximum timestamp value in seconds */
+	__u16	atime_gran_mantissa;	/* Granularity(secs) = mant * 10^exp */
+	__u16	btime_gran_mantissa;
+	__u16	ctime_gran_mantissa;
+	__u16	mtime_gran_mantissa;
+	__s8	atime_gran_exponent;
+	__s8	btime_gran_exponent;
+	__s8	ctime_gran_exponent;
+	__s8	mtime_gran_exponent;
+	__u32	__reserved[1];
+};
+
+/*
+ * Information struct for fsinfo(fsinfo_attr_volume_uuid).
+ */
+struct fsinfo_volume_uuid {
+	__u8	uuid[16];
+};
+
+/*
+ * Information struct for fsinfo(fsinfo_attr_server_addresses).
+ *
+ * Find the Mth address of the Nth server for a network mount.
+ */
+struct fsinfo_server_address {
+	struct __kernel_sockaddr_storage address;
+};
+
+/*
+ * Information struct for fsinfo(fsinfo_attr_io_size).
+ *
+ * Retrieve I/O size hints for a filesystem.
+ */
+struct fsinfo_io_size {
+	__u32		dio_size_gran;	/* Size granularity for O_DIRECT */
+	__u32		dio_mem_align;	/* Memory alignment for O_DIRECT */
+};
+
+/*
+ * Information struct for fsinfo(fsinfo_attr_fsinfo).
+ *
+ * This gives information about fsinfo() itself.
+ */
+struct fsinfo_fsinfo {
+	__u32	max_attr;	/* Number of supported attributes (fsinfo_attr__nr) */
+	__u32	max_cap;	/* Number of supported capabilities (fsinfo_cap__nr) */
+};
+
+#endif /* _UAPI_LINUX_FSINFO_H */
diff --git a/samples/statx/Makefile b/samples/statx/Makefile
index 59df7c25a9d1..9cb9a88e3a10 100644
--- a/samples/statx/Makefile
+++ b/samples/statx/Makefile
@@ -1,7 +1,10 @@
 # List of programs to build
-hostprogs-$(CONFIG_SAMPLE_STATX) := test-statx
+hostprogs-$(CONFIG_SAMPLE_STATX) := test-statx test-fsinfo
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
 
 HOSTCFLAGS_test-statx.o += -I$(objtree)/usr/include
+
+HOSTCFLAGS_test-fsinfo.o += -I$(objtree)/usr/include
+HOSTLOADLIBES_test-fsinfo += -lm
diff --git a/samples/statx/test-fsinfo.c b/samples/statx/test-fsinfo.c
new file mode 100644
index 000000000000..5fb3dcccff26
--- /dev/null
+++ b/samples/statx/test-fsinfo.c
@@ -0,0 +1,546 @@
+/* Test the fsinfo() system call
+ *
+ * Copyright (C) 2018 Red Hat, Inc. All Rights Reserved.
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
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <string.h>
+#include <unistd.h>
+#include <ctype.h>
+#include <errno.h>
+#include <time.h>
+#include <math.h>
+#include <fcntl.h>
+#include <sys/syscall.h>
+#include <linux/fsinfo.h>
+#include <linux/socket.h>
+#include <sys/stat.h>
+
+static bool debug = 0;
+
+static __attribute__((unused))
+ssize_t fsinfo(int dfd, const char *filename, struct fsinfo_params *params,
+	       void *buffer, size_t buf_size)
+{
+	return syscall(__NR_fsinfo, dfd, filename, params, buffer, buf_size);
+}
+
+#define FSINFO_STRING(X,Y)	 [FSINFO_ATTR_##X] = 0x0000
+#define FSINFO_STRUCT(X,Y)	 [FSINFO_ATTR_##X] = sizeof(struct fsinfo_##Y)
+#define FSINFO_STRING_N(X,Y)	 [FSINFO_ATTR_##X] = 0x4000
+#define FSINFO_STRUCT_N(X,Y)	 [FSINFO_ATTR_##X] = 0x4000 | sizeof(struct fsinfo_##Y)
+#define FSINFO_STRUCT_NM(X,Y)	 [FSINFO_ATTR_##X] = 0x8000 | sizeof(struct fsinfo_##Y)
+#define FSINFO_STRING_NM(X,Y)	 [FSINFO_ATTR_##X] = 0x8000
+static const __u16 fsinfo_buffer_sizes[FSINFO_ATTR__NR] = {
+	FSINFO_STRUCT		(STATFS,		statfs),
+	FSINFO_STRUCT		(FSINFO,		fsinfo),
+	FSINFO_STRUCT		(IDS,			ids),
+	FSINFO_STRUCT		(LIMITS,		limits),
+	FSINFO_STRUCT		(CAPABILITIES,		capabilities),
+	FSINFO_STRUCT		(SUPPORTS,		supports),
+	FSINFO_STRUCT		(TIMESTAMP_INFO,	timestamp_info),
+	FSINFO_STRING		(VOLUME_ID,		volume_id),
+	FSINFO_STRUCT		(VOLUME_UUID,		volume_uuid),
+	FSINFO_STRING		(VOLUME_NAME,		volume_name),
+	FSINFO_STRING		(CELL_NAME,		cell_name),
+	FSINFO_STRING		(DOMAIN_NAME,		domain_name),
+	FSINFO_STRING		(REALM_NAME,		realm_name),
+	FSINFO_STRING_N		(SERVER_NAME,		server_name),
+	FSINFO_STRUCT_NM	(SERVER_ADDRESS,	server_address),
+	FSINFO_STRING_NM	(PARAMETER,		parameter),
+	FSINFO_STRING_N		(SOURCE,		source),
+	FSINFO_STRING		(NAME_ENCODING,		name_encoding),
+	FSINFO_STRING		(NAME_CODEPAGE,		name_codepage),
+	FSINFO_STRUCT		(IO_SIZE,		io_size),
+};
+
+#define FSINFO_NAME(X,Y) [FSINFO_ATTR_##X] = #Y
+static const char *fsinfo_attr_names[FSINFO_ATTR__NR] = {
+	FSINFO_NAME		(STATFS,		statfs),
+	FSINFO_NAME		(FSINFO,		fsinfo),
+	FSINFO_NAME		(IDS,			ids),
+	FSINFO_NAME		(LIMITS,		limits),
+	FSINFO_NAME		(CAPABILITIES,		capabilities),
+	FSINFO_NAME		(SUPPORTS,		supports),
+	FSINFO_NAME		(TIMESTAMP_INFO,	timestamp_info),
+	FSINFO_NAME		(VOLUME_ID,		volume_id),
+	FSINFO_NAME		(VOLUME_UUID,		volume_uuid),
+	FSINFO_NAME		(VOLUME_NAME,		volume_name),
+	FSINFO_NAME		(CELL_NAME,		cell_name),
+	FSINFO_NAME		(DOMAIN_NAME,		domain_name),
+	FSINFO_NAME		(REALM_NAME,		realm_name),
+	FSINFO_NAME		(SERVER_NAME,		server_name),
+	FSINFO_NAME		(SERVER_ADDRESS,	server_address),
+	FSINFO_NAME		(PARAMETER,		parameter),
+	FSINFO_NAME		(SOURCE,		source),
+	FSINFO_NAME		(NAME_ENCODING,		name_encoding),
+	FSINFO_NAME		(NAME_CODEPAGE,		name_codepage),
+	FSINFO_NAME		(IO_SIZE,		io_size),
+};
+
+union reply {
+	char buffer[4096];
+	struct fsinfo_statfs statfs;
+	struct fsinfo_fsinfo fsinfo;
+	struct fsinfo_ids ids;
+	struct fsinfo_limits limits;
+	struct fsinfo_supports supports;
+	struct fsinfo_capabilities caps;
+	struct fsinfo_timestamp_info timestamps;
+	struct fsinfo_volume_uuid uuid;
+	struct fsinfo_server_address srv_addr;
+	struct fsinfo_io_size io_size;
+};
+
+static void dump_hex(unsigned int *data, int from, int to)
+{
+	unsigned offset, print_offset = 1, col = 0;
+
+	from /= 4;
+	to = (to + 3) / 4;
+
+	for (offset = from; offset < to; offset++) {
+		if (print_offset) {
+			printf("%04x: ", offset * 8);
+			print_offset = 0;
+		}
+		printf("%08x", data[offset]);
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
+static void dump_attr_STATFS(union reply *r, int size)
+{
+	struct fsinfo_statfs *f = &r->statfs;
+
+	printf("\n");
+	printf("\tblocks: n=%llu fr=%llu av=%llu\n",
+	       (unsigned long long)f->f_blocks,
+	       (unsigned long long)f->f_bfree,
+	       (unsigned long long)f->f_bavail);
+
+	printf("\tfiles : n=%llu fr=%llu av=%llu\n",
+	       (unsigned long long)f->f_files,
+	       (unsigned long long)f->f_ffree,
+	       (unsigned long long)f->f_favail);
+	printf("\tbsize : %u\n", f->f_bsize);
+	printf("\tfrsize: %u\n", f->f_frsize);
+}
+
+static void dump_attr_FSINFO(union reply *r, int size)
+{
+	struct fsinfo_fsinfo *f = &r->fsinfo;
+
+	printf("max_attr=%u max_cap=%u\n", f->max_attr, f->max_cap);
+}
+
+static void dump_attr_IDS(union reply *r, int size)
+{
+	struct fsinfo_ids *f = &r->ids;
+
+	printf("\n");
+	printf("\tdev   : %02x:%02x\n", f->f_dev_major, f->f_dev_minor);
+	printf("\tfs    : type=%x name=%s\n", f->f_fstype, f->f_fs_name);
+	printf("\tflags : %llx\n", (unsigned long long)f->f_flags);
+	printf("\tfsid  : %llx\n", (unsigned long long)f->f_fsid);
+}
+
+static void dump_attr_LIMITS(union reply *r, int size)
+{
+	struct fsinfo_limits *f = &r->limits;
+
+	printf("\n");
+	printf("\tmax file size: %llx\n", f->max_file_size);
+	printf("\tmax ids      : u=%llx g=%llx p=%llx\n",
+	       f->max_uid, f->max_gid, f->max_projid);
+	printf("\tmax dev      : maj=%x min=%x\n",
+	       f->max_dev_major, f->max_dev_minor);
+	printf("\tmax links    : %x\n", f->max_hard_links);
+	printf("\tmax xattr    : n=%x b=%x\n",
+	       f->max_xattr_name_len, f->max_xattr_body_len);
+	printf("\tmax len      : file=%x sym=%x\n",
+	       f->max_filename_len, f->max_symlink_len);
+}
+
+static void dump_attr_SUPPORTS(union reply *r, int size)
+{
+	struct fsinfo_supports *f = &r->supports;
+
+	printf("\n");
+	printf("\tstx_attr=%llx\n", f->stx_attributes);
+	printf("\tstx_mask=%x\n", f->stx_mask);
+	printf("\tioc_flags=%x\n", f->ioc_flags);
+	printf("\twin_fattrs=%x\n", f->win_file_attrs);
+}
+
+#define FSINFO_CAP_NAME(C) [FSINFO_CAP_##C] = #C
+static const char *fsinfo_cap_names[FSINFO_CAP__NR] = {
+	FSINFO_CAP_NAME(IS_KERNEL_FS),
+	FSINFO_CAP_NAME(IS_BLOCK_FS),
+	FSINFO_CAP_NAME(IS_FLASH_FS),
+	FSINFO_CAP_NAME(IS_NETWORK_FS),
+	FSINFO_CAP_NAME(IS_AUTOMOUNTER_FS),
+	FSINFO_CAP_NAME(AUTOMOUNTS),
+	FSINFO_CAP_NAME(ADV_LOCKS),
+	FSINFO_CAP_NAME(MAND_LOCKS),
+	FSINFO_CAP_NAME(LEASES),
+	FSINFO_CAP_NAME(UIDS),
+	FSINFO_CAP_NAME(GIDS),
+	FSINFO_CAP_NAME(PROJIDS),
+	FSINFO_CAP_NAME(ID_NAMES),
+	FSINFO_CAP_NAME(ID_GUIDS),
+	FSINFO_CAP_NAME(WINDOWS_ATTRS),
+	FSINFO_CAP_NAME(USER_QUOTAS),
+	FSINFO_CAP_NAME(GROUP_QUOTAS),
+	FSINFO_CAP_NAME(PROJECT_QUOTAS),
+	FSINFO_CAP_NAME(XATTRS),
+	FSINFO_CAP_NAME(JOURNAL),
+	FSINFO_CAP_NAME(DATA_IS_JOURNALLED),
+	FSINFO_CAP_NAME(O_SYNC),
+	FSINFO_CAP_NAME(O_DIRECT),
+	FSINFO_CAP_NAME(VOLUME_ID),
+	FSINFO_CAP_NAME(VOLUME_UUID),
+	FSINFO_CAP_NAME(VOLUME_NAME),
+	FSINFO_CAP_NAME(VOLUME_FSID),
+	FSINFO_CAP_NAME(CELL_NAME),
+	FSINFO_CAP_NAME(DOMAIN_NAME),
+	FSINFO_CAP_NAME(REALM_NAME),
+	FSINFO_CAP_NAME(IVER_ALL_CHANGE),
+	FSINFO_CAP_NAME(IVER_DATA_CHANGE),
+	FSINFO_CAP_NAME(IVER_MONO_INCR),
+	FSINFO_CAP_NAME(SYMLINKS),
+	FSINFO_CAP_NAME(HARD_LINKS),
+	FSINFO_CAP_NAME(HARD_LINKS_1DIR),
+	FSINFO_CAP_NAME(DEVICE_FILES),
+	FSINFO_CAP_NAME(UNIX_SPECIALS),
+	FSINFO_CAP_NAME(RESOURCE_FORKS),
+	FSINFO_CAP_NAME(NAME_CASE_INDEP),
+	FSINFO_CAP_NAME(NAME_NON_UTF8),
+	FSINFO_CAP_NAME(NAME_HAS_CODEPAGE),
+	FSINFO_CAP_NAME(SPARSE),
+	FSINFO_CAP_NAME(NOT_PERSISTENT),
+	FSINFO_CAP_NAME(NO_UNIX_MODE),
+	FSINFO_CAP_NAME(HAS_ATIME),
+	FSINFO_CAP_NAME(HAS_BTIME),
+	FSINFO_CAP_NAME(HAS_CTIME),
+	FSINFO_CAP_NAME(HAS_MTIME),
+};
+
+static void dump_attr_CAPABILITIES(union reply *r, int size)
+{
+	struct fsinfo_capabilities *f = &r->caps;
+	int i;
+
+	for (i = 0; i < sizeof(f->capabilities); i++)
+		printf("%02x", f->capabilities[i]);
+	printf("\n");
+	for (i = 0; i < FSINFO_CAP__NR; i++)
+		if (f->capabilities[i / 8] & (1 << (i % 8)))
+			printf("\t- %s\n", fsinfo_cap_names[i]);
+}
+
+static void dump_attr_TIMESTAMP_INFO(union reply *r, int size)
+{
+	struct fsinfo_timestamp_info *f = &r->timestamps;
+
+	printf("range=%llx-%llx\n",
+	       (unsigned long long)f->minimum_timestamp,
+	       (unsigned long long)f->maximum_timestamp);
+
+#define print_time(G) \
+	printf("\t"#G"time : gran=%gs\n",			\
+	       (f->G##time_gran_mantissa *		\
+		pow(10., f->G##time_gran_exponent)))
+	print_time(a);
+	print_time(b);
+	print_time(c);
+	print_time(m);
+}
+
+static void dump_attr_VOLUME_UUID(union reply *r, int size)
+{
+	struct fsinfo_volume_uuid *f = &r->uuid;
+
+	printf("%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x"
+	       "-%02x%02x%02x%02x%02x%02x\n",
+	       f->uuid[ 0], f->uuid[ 1],
+	       f->uuid[ 2], f->uuid[ 3],
+	       f->uuid[ 4], f->uuid[ 5],
+	       f->uuid[ 6], f->uuid[ 7],
+	       f->uuid[ 8], f->uuid[ 9],
+	       f->uuid[10], f->uuid[11],
+	       f->uuid[12], f->uuid[13],
+	       f->uuid[14], f->uuid[15]);
+}
+
+static void dump_attr_SERVER_ADDRESS(union reply *r, int size)
+{
+	struct fsinfo_server_address *f = &r->srv_addr;
+
+	printf("family=%u\n", f->address.ss_family);
+}
+
+static void dump_attr_IO_SIZE(union reply *r, int size)
+{
+	struct fsinfo_io_size *f = &r->io_size;
+
+	printf("dio_size=%u\n", f->dio_size_gran);
+}
+
+/*
+ *
+ */
+typedef void (*dumper_t)(union reply *r, int size);
+
+#define FSINFO_DUMPER(N) [FSINFO_ATTR_##N] = dump_attr_##N
+static const dumper_t fsinfo_attr_dumper[FSINFO_ATTR__NR] = {
+	FSINFO_DUMPER(STATFS),
+	FSINFO_DUMPER(FSINFO),
+	FSINFO_DUMPER(IDS),
+	FSINFO_DUMPER(LIMITS),
+	FSINFO_DUMPER(SUPPORTS),
+	FSINFO_DUMPER(CAPABILITIES),
+	FSINFO_DUMPER(TIMESTAMP_INFO),
+	FSINFO_DUMPER(VOLUME_UUID),
+	FSINFO_DUMPER(SERVER_ADDRESS),
+	FSINFO_DUMPER(IO_SIZE),
+};
+
+static void dump_fsinfo(enum fsinfo_attribute attr, __u8 about,
+			union reply *r, int size)
+{
+	dumper_t dumper = fsinfo_attr_dumper[attr];
+	unsigned int len;
+
+	if (!dumper) {
+		printf("<no dumper>\n");
+		return;
+	}
+
+	len = about & 0x3fff;
+	if (size < len) {
+		printf("<short data %u/%u>\n", size, len);
+		return;
+	}
+
+	dumper(r, size);
+}
+
+/*
+ * Try one subinstance of an attribute.
+ */
+static int try_one(const char *file, struct fsinfo_params *params, bool raw)
+{
+	union reply r;
+	char *p;
+	int ret;
+	__u16 about;
+
+	memset(&r.buffer, 0xbd, sizeof(r.buffer));
+
+	errno = 0;
+	ret = fsinfo(AT_FDCWD, file, params, r.buffer, sizeof(r.buffer));
+	if (params->request >= FSINFO_ATTR__NR) {
+		if (ret == -1 && errno == EOPNOTSUPP)
+			exit(0);
+		fprintf(stderr, "Unexpected error for too-large command %u: %m\n",
+			params->request);
+		exit(1);
+	}
+
+	if (debug)
+		printf("fsinfo(%s,%s,%u,%u) = %d: %m\n",
+		       file, fsinfo_attr_names[params->request],
+		       params->Nth, params->Mth, ret);
+
+	about = fsinfo_buffer_sizes[params->request];
+	if (ret == -1) {
+		if (errno == ENODATA) {
+			switch (about & 0xc000) {
+			case 0x0000:
+				if (params->Nth == 0 && params->Mth == 0) {
+					fprintf(stderr,
+						"Unexpected ENODATA1 (%u[%u][%u])\n",
+						params->request, params->Nth, params->Mth);
+					exit(1);
+				}
+				break;
+			case 0x4000:
+				if (params->Nth == 0 && params->Mth == 0) {
+					fprintf(stderr,
+						"Unexpected ENODATA2 (%u[%u][%u])\n",
+						params->request, params->Nth, params->Mth);
+					exit(1);
+				}
+				break;
+			}
+			return (params->Mth == 0) ? 2 : 1;
+		}
+		if (errno == EOPNOTSUPP) {
+			if (params->Nth > 0 || params->Mth > 0) {
+				fprintf(stderr,
+					"Should return -ENODATA (%u[%u][%u])\n",
+					params->request, params->Nth, params->Mth);
+				exit(1);
+			}
+			//printf("\e[33m%s\e[m: <not supported>\n",
+			//       fsinfo_attr_names[attr]);
+			return 2;
+		}
+		perror(file);
+		exit(1);
+	}
+
+	if (raw) {
+		if (ret > 4096)
+			ret = 4096;
+		dump_hex((unsigned int *)&r.buffer, 0, ret);
+		return 0;
+	}
+
+	switch (about & 0xc000) {
+	case 0x0000:
+		printf("\e[33m%s\e[m: ",
+		       fsinfo_attr_names[params->request]);
+		break;
+	case 0x4000:
+		printf("\e[33m%s[%u]\e[m: ",
+		       fsinfo_attr_names[params->request],
+		       params->Nth);
+		break;
+	case 0x8000:
+		printf("\e[33m%s[%u][%u]\e[m: ",
+		       fsinfo_attr_names[params->request],
+		       params->Nth, params->Mth);
+		break;
+	}
+
+	switch (about) {
+		/* Struct */
+	case 0x0001 ... 0x3fff:
+	case 0x4001 ... 0x7fff:
+	case 0x8001 ... 0xbfff:
+		dump_fsinfo(params->request, about, &r, ret);
+		return 0;
+
+		/* String */
+	case 0x0000:
+	case 0x4000:
+	case 0x8000:
+		if (ret >= 4096) {
+			ret = 4096;
+			r.buffer[4092] = '.';
+			r.buffer[4093] = '.';
+			r.buffer[4094] = '.';
+			r.buffer[4095] = 0;
+		} else {
+			r.buffer[ret] = 0;
+		}
+		for (p = r.buffer; *p; p++) {
+			if (!isprint(*p)) {
+				printf("<non-printable>\n");
+				continue;
+			}
+		}
+		printf("%s\n", r.buffer);
+		return 0;
+
+	default:
+		fprintf(stderr, "Fishy about %u %02x\n", params->request, about);
+		exit(1);
+	}
+}
+
+/*
+ *
+ */
+int main(int argc, char **argv)
+{
+	struct fsinfo_params params = {
+		.at_flags = AT_SYMLINK_NOFOLLOW,
+	};
+	unsigned int attr;
+	int raw = 0, opt, Nth, Mth;
+
+	while ((opt = getopt(argc, argv, "adlr"))) {
+		switch (opt) {
+		case 'a':
+			params.at_flags |= AT_NO_AUTOMOUNT;
+			continue;
+		case 'd':
+			debug = true;
+			continue;
+		case 'l':
+			params.at_flags &= ~AT_SYMLINK_NOFOLLOW;
+			continue;
+		case 'r':
+			raw = 1;
+			continue;
+		}
+		break;
+	}
+
+	argc -= optind;
+	argv += optind;
+
+	if (argc != 1) {
+		printf("Format: test-fsinfo [-alr] <file>\n");
+		exit(2);
+	}
+
+	for (attr = 0; attr <= FSINFO_ATTR__NR; attr++) {
+		Nth = 0;
+		do {
+			Mth = 0;
+			do {
+				params.request = attr;
+				params.Nth = Nth;
+				params.Mth = Mth;
+
+				switch (try_one(argv[0], &params, raw)) {
+				case 0:
+					continue;
+				case 1:
+					goto done_M;
+				case 2:
+					goto done_N;
+				}
+			} while (++Mth < 100);
+
+		done_M:
+			if (Mth >= 100) {
+				fprintf(stderr, "Fishy: Mth == %u\n", Mth);
+				break;
+			}
+
+		} while (++Nth < 100);
+
+	done_N:
+		if (Nth >= 100) {
+			fprintf(stderr, "Fishy: Nth == %u\n", Nth);
+			break;
+		}
+	}
+
+	return 0;
+}
