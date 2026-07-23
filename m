Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0E8471247;
	Thu, 23 Jul 2026 11:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806240; cv=none; b=e0/tcnbw0tOQgbzFb3F986ztdO+IbZFp5ZbjingcDtDO8jtUAcegbUhkhRQ08ATwGkUBlbrSz1rPjOUQ84TTqei9j0p63Oyjo4rQiwRVitEjaHBKOkmnrAxLSAfx757NJZaNE1xI5qF7f54uzsPrB5r89uyjkJMGSZ6ez4VVPOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806240; c=relaxed/simple;
	bh=4d9+/HYmgwPaGOCiJNy5HdkFp7nA85NuXik9e/ndA0U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FKcjoo8AV3LhQew+DbrMbsYDmVc3n6Yy+7p8JcjagLytARnhtrUf/IJjjv0ZHFGsT1eOqi8JSpo8NqFO7DJx97oz0l2OMJOMp0+JqytrDbHVeUWkquGZr6f53fz74J706ejdV6ThBDPHCS7KsUBgZbTHZNOM81eleWnzsTfP1R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ssqs8UUG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ssqs8UUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9753B1F00A3A;
	Thu, 23 Jul 2026 11:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784806238;
	bh=cbonWmvpVjsI4El5Jr1VjZ6RhpNeiBJBx+P1i417Ft0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ssqs8UUGKN/gGi8OwtokndYqNp/Z4869n+4mhA6LC5RZDc+RLRHcI7O4H2ICrazq9
	 Rq5NTrKT1MgWF2Tg8tR2NszOYI6Wpc2Du5IcZ+FLnTeSg68nLV6+/mvsDX7fHvxVQl
	 nIxSXY0S5aiIZ7v1Vt7ZRVO7EXQrv6vPqCaThfPwsL1YVfjXw9QkhSTXerxzFQZtu3
	 fvsHB0L50uF0n0oIrE+j19f9/2tStqDPFPSpKjIZPWA/TWmkCePP+ZJkQZtQ0QeQqN
	 uY91iFhWhpkhS71/6ZBOVYv5iEGOe0jEi5YFccbFbLTI+KXYz8ZCmby4EALbjwkqRh
	 iyYiezzanrfFg==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 23 Jul 2026 13:30:20 +0200
Subject: [PATCH RFC 1/7] fs: add failfs
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-work-failfs-v1-1-3f69b9a9e958@kernel.org>
References: <20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org>
In-Reply-To: <20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org>
To: linux-fsdevel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, 
 Jann Horn <jannh@google.com>
Cc: John Ericson <mail@johnericson.me>, linux-api@vger.kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
 linux-doc@vger.kernel.org
X-Mailer: b4 0.16-dev-0e65f
X-Developer-Signature: v=1; a=openpgp-sha256; l=8589; i=brauner@kernel.org;
 h=from:subject:message-id; bh=4d9+/HYmgwPaGOCiJNy5HdkFp7nA85NuXik9e/ndA0U=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQl/g4P7Th8NeTWvMTk0tzXORW/XTRkpHK8+NM3f5q9d
 XKf3HP9jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImsOMnwV/Aqz41D7wvmnXn6
 um93yzbW0sdb3J+2d2xR+F2lMb27+A3DP4UFx9asa1U8+KOs4I1+6lQF5z2H+E1SSxQqfLaKnfR
 y5wEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

nullfs provides a permanently empty and immutable directory. Lookups
fail with ENOENT. The directory can be opened, read, stat, mounted upon.
It behaves like nothing is there.

Add its counterpart failfs where the semantics are not "there is
nothing here" but "nothing is supported here". Every operation that
reaches the filesystem fails with EOPNOTSUPP. Even statfs()/fstatfs()
fail so the filesystem cannot be discovered through an fd to it.

EOPNOTSUPP rather than a permission errno keeps that coherent. There
is no permission model in which anything could ever be allowed and
EACCES or EPERM would merely suggest that different credentials might
succeed while EIO would suggest corruption. It also makes hitting the
failfs boundary mostly quite dinstinguishable. A task anchoring its
lookups at real directory file descriptors may be able to tell a failfs
refusal from an ordinary permission failure. I wouldn't go so far as
guaranteeing that but it should mostly work.

The root cannot be opened at all not even with O_PATH. It is never
reached by a lookup in a parent directory. The only way to a path-walk
terminal at the root is a jump through a /proc/<pid>/{root,cwd} magic
link or by mountpoint traversal. The root also refuses
->d_weak_revalidate() which the VFS calls for jumped terminals. That
closes every remaining way to reference it. An O_PATH
open is refused and name_to_handle_at() cannot encode it into a file
handle, and following a magic link into it fails. A plain readlink() of
such a link still works and shows "/".

There is a single instance of failfs mounted during early boot via
kern_mount() making it logically distinct from every mount namespace.

Since the mount is a member of no mount namespace mounting onto it
fails. So nothing can ever be mounted on top of it. It cannot be cloned
via OPEN_TREE_CLONE and it does not show up in statmount()/listmount()
or /proc/<pid>/mountinfo. The filesystem is not registered so it is
not visible in /proc/filesystems and cannot be mounted from userspace.

This lets tasks shed their filesystem state completely. A process with
its root directory or working directory in failfs must anchor every path
lookup at an explicit file descriptor or is doomed to fail any lookup.
Absolute paths, absolute symlinks, and AT_FDCWD-relative lookups
simply fail. Followup patches will expose it via a new FD_FAILFS_ROOT
file descriptor sentinel understood by fchdir() and the new fchroot()
system call.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/Makefile                |   2 +-
 fs/failfs.c                | 144 +++++++++++++++++++++++++++++++++++++++++++++
 fs/internal.h              |   2 +
 fs/namespace.c             |   1 +
 include/uapi/linux/magic.h |   1 +
 5 files changed, 149 insertions(+), 1 deletion(-)

diff --git a/fs/Makefile b/fs/Makefile
index 89a8a9d207d1..73b6cab7738e 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -16,7 +16,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		stack.o fs_struct.o statfs.o fs_pin.o nsfs.o \
 		fs_dirent.o fs_context.o fs_parser.o fsopen.o init.o \
 		kernel_read_file.o mnt_idmapping.o remap_range.o pidfs.o \
-		file_attr.o fserror.o nullfs.o
+		file_attr.o fserror.o nullfs.o failfs.o
 
 obj-$(CONFIG_BUFFER_HEAD)	+= buffer.o mpage.o
 obj-$(CONFIG_PROC_FS)		+= proc_namespace.o
diff --git a/fs/failfs.c b/fs/failfs.c
new file mode 100644
index 000000000000..f9d4ba791928
--- /dev/null
+++ b/fs/failfs.c
@@ -0,0 +1,144 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2026 Christian Brauner <brauner@kernel.org> */
+#include <linux/fs.h>
+#include <linux/fs/super_types.h>
+#include <linux/fs_context.h>
+#include <linux/magic.h>
+#include <linux/mount.h>
+
+#include "internal.h"
+
+static struct path failfs_root_path = {};
+
+void failfs_get_root(struct path *path)
+{
+	*path = failfs_root_path;
+	path_get(path);
+}
+
+static int failfs_permission(struct mnt_idmap *idmap, struct inode *inode,
+			     int mask)
+{
+	return -EOPNOTSUPP;
+}
+
+static struct dentry *failfs_lookup(struct inode *dir, struct dentry *dentry,
+				    unsigned int flags)
+{
+	/* Unreachable: ->permission() already failed the walk. */
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static int failfs_getattr(struct mnt_idmap *idmap, const struct path *path,
+			  struct kstat *stat, u32 request_mask,
+			  unsigned int query_flags)
+{
+	return -EOPNOTSUPP;
+}
+
+static const struct inode_operations failfs_dir_inode_operations = {
+	.permission	= failfs_permission,
+	.lookup		= failfs_lookup,
+	.getattr	= failfs_getattr,
+};
+
+static const struct file_operations failfs_dir_operations = {};
+
+static int failfs_d_weak_revalidate(struct dentry *dentry, unsigned int flags)
+{
+	/*
+	 * The root is only ever reached as a path-walk terminal by jumping
+	 * to it: as "/" when it is the caller's root, or through a
+	 * /proc/<pid>/{root,cwd} magic link. ->permission() already fails
+	 * every walk of a component, but a jump lands on the root without
+	 * one. Refuse here too so the root cannot be pinned by an O_PATH
+	 * open or encoded into a file handle.
+	 */
+	return -EOPNOTSUPP;
+}
+
+static const struct dentry_operations failfs_dentry_operations = {
+	.d_weak_revalidate	= failfs_d_weak_revalidate,
+};
+
+static int failfs_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	return -EOPNOTSUPP;
+}
+
+static const struct super_operations failfs_super_operations = {
+	.statfs	= failfs_statfs,
+};
+
+static int failfs_fill_super(struct super_block *s, struct fs_context *fc)
+{
+	struct inode *inode;
+
+	s->s_maxbytes		= MAX_LFS_FILESIZE;
+	s->s_blocksize		= PAGE_SIZE;
+	s->s_blocksize_bits	= PAGE_SHIFT;
+	s->s_magic		= FAIL_FS_MAGIC;
+	s->s_op			= &failfs_super_operations;
+	s->s_export_op		= NULL;
+	s->s_xattr		= NULL;
+	s->s_time_gran		= 1;
+	s->s_d_flags		= 0;
+
+	inode = new_inode(s);
+	if (!inode)
+		return -ENOMEM;
+
+	/* failfs supports no operations... */
+	inode->i_mode	= S_IFDIR;
+	set_nlink(inode, 2);
+	inode->i_op	= &failfs_dir_inode_operations;
+	inode->i_fop	= &failfs_dir_operations;
+	simple_inode_init_ts(inode);
+	inode->i_ino	= 1;
+	/* ... and is immutable. */
+	inode->i_flags |= S_IMMUTABLE;
+
+	set_default_d_op(s, &failfs_dentry_operations);
+	s->s_root = d_make_root(inode);
+	if (!s->s_root)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int failfs_get_tree(struct fs_context *fc)
+{
+	return get_tree_single(fc, failfs_fill_super);
+}
+
+static const struct fs_context_operations failfs_context_ops = {
+	.get_tree	= failfs_get_tree,
+};
+
+static int failfs_init_fs_context(struct fs_context *fc)
+{
+	fc->ops		= &failfs_context_ops;
+	fc->global	= true;
+	fc->sb_flags	|= SB_NOUSER;
+	fc->s_iflags	|= SB_I_NOEXEC | SB_I_NODEV;
+	return 0;
+}
+
+static struct file_system_type failfs_fs_type = {
+	.name			= "failfs",
+	.init_fs_context	= failfs_init_fs_context,
+	.kill_sb		= kill_anon_super,
+};
+
+void __init failfs_init(void)
+{
+	struct vfsmount *mnt;
+
+	/* A single instance that is member of no mount namespace. */
+	mnt = kern_mount(&failfs_fs_type);
+	if (IS_ERR(mnt))
+		panic("VFS: Failed to create failfs");
+
+	failfs_root_path.mnt	= mnt;
+	failfs_root_path.dentry	= mnt->mnt_root;
+}
diff --git a/fs/internal.h b/fs/internal.h
index 355d93f92208..b6d38a5794eb 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -362,3 +362,5 @@ int anon_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		       struct iattr *attr);
 void pidfs_get_root(struct path *path);
 void nsfs_get_root(struct path *path);
+void failfs_get_root(struct path *path);
+void __init failfs_init(void);
diff --git a/fs/namespace.c b/fs/namespace.c
index 3d5cd5bf3b05..87c365f2f82b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -6274,6 +6274,7 @@ void __init mnt_init(void)
 	shmem_init();
 	init_rootfs();
 	init_mount_tree();
+	failfs_init();
 }
 
 void put_mnt_ns(struct mnt_namespace *ns)
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 4f2da935a76c..fd5f0e95648e 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -105,5 +105,6 @@
 #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
 #define GUEST_MEMFD_MAGIC	0x474d454d	/* "GMEM" */
 #define NULL_FS_MAGIC		0x4E554C4C	/* "NULL" */
+#define FAIL_FS_MAGIC		0x4641494C	/* "FAIL" */
 
 #endif /* __LINUX_MAGIC_H__ */

-- 
2.53.0

