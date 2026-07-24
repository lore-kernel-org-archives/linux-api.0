Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062813F1AC5;
	Fri, 24 Jul 2026 13:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784900492; cv=none; b=heRswAviKSXTMV3XvIJG8olKdTAl7Ogi5yU/wi1U1lHGMBEZ4UgmKcC1CCzQzcotViQAEt9xs53rUMC1yoU37KIShKq6F7avqJ8sIg3P9lVDwIYpB1Yp1JsvLXbz+0gUQ9UDkeMvNWdbiyaobVJtY3Q5VZPLTDC7Toa+N9A/L04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784900492; c=relaxed/simple;
	bh=yIu0I1zNWOxg62L3UqwMfUk2/IO+cPuqLo+Pb+5lt2o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=du4A79QRf0GGVZQymYhb+GcEcrCi9XESKQm1k5PZe0i1lSrC++tWW6JMINXlB19dA0Vrks7lMtXejz/N/i+Htq3WC9ZD3oJBsx6Pto0Xy9NKZx5V1ciFzOQrkQ1KHeTF8pYLN9l/+NKhS38w4Lf3XrS6wukhV0SrbEC74J3r3mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LHkC+Zp3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LHkC+Zp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E141F00A3A;
	Fri, 24 Jul 2026 13:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784900490;
	bh=h/FPJKjvEfLCtBp06sGmT7ICNUBOeJ9CZ91o23d9slw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LHkC+Zp328u2Ksc445qvxgArNONTQjXTncfXhwMABXcRULueenkr07v5cTFaGAvyX
	 XSfGUjmWYm/NYB/n7znHbbiNK1bbg4RwjVFGgmZ9LBkYOaezdB1fEP+nfXqUpsqIhl
	 tp/jx5adlaNJzcL77dHFDPjffy8aQeJ5sJimiYFY0ctPeEgk+bG3mNcCW+/7aeniec
	 hzfJNPVpgabv0d4JmyBDzEP4JPWANbKkiC91+tXUKz7I0Y7qLs5WJhaeu48rqTwYBZ
	 WzOzu4JyICzI2sAKL+o+Fni/t79wS1jxo6LWxzvWRmp5I8oMJ11vr574OHXXpjg7ZD
	 2p1sdOv5NmOVA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 24 Jul 2026 15:41:17 +0200
Subject: [PATCH v2 1/7] fs: add failfs
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260724-work-failfs-v2-1-485dabbae185@kernel.org>
References: <20260724-work-failfs-v2-0-485dabbae185@kernel.org>
In-Reply-To: <20260724-work-failfs-v2-0-485dabbae185@kernel.org>
To: linux-fsdevel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, 
 Jann Horn <jannh@google.com>
Cc: John Ericson <mail@johnericson.me>, linux-api@vger.kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
 linux-doc@vger.kernel.org
X-Mailer: b4 0.16-dev-401aa
X-Developer-Signature: v=1; a=openpgp-sha256; l=9546; i=brauner@kernel.org;
 h=from:subject:message-id; bh=yIu0I1zNWOxg62L3UqwMfUk2/IO+cPuqLo+Pb+5lt2o=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlZzc3L5dwfXDka+pBsSVnFq0qfsLv3KhiGzJlWurN6
 reqnTXHO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACaiNZuR4V2XUIP1mYAbgtbH
 V81nlHjEFSDyqVYtf+7OZ/OvHin6f4ORYeKb2cu3z/FfNn/fzg+6iVY2vGYX134XLG0pKvl7y9P
 wERcA
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

No path lookup can open the root, not even with O_PATH. It is never
reached by a lookup in a parent directory. The only way to a path-walk
terminal at the root is a jump through a /proc/<pid>/{root,cwd} magic
link or by mountpoint traversal. The root also refuses
->d_weak_revalidate() which the VFS calls for jumped terminals. That
covers the jump-based references too: an O_PATH open is refused,
name_to_handle_at() cannot encode it into a file handle, and following a
magic link into it fails. A plain readlink() of such a link still works
and shows "failfs:/".

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
 fs/d_path.c                |   3 +-
 fs/failfs.c                | 155 +++++++++++++++++++++++++++++++++++++++++++++
 fs/internal.h              |   3 +
 fs/namespace.c             |   1 +
 include/uapi/linux/magic.h |   1 +
 6 files changed, 163 insertions(+), 2 deletions(-)

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
diff --git a/fs/d_path.c b/fs/d_path.c
index a48957c0971e..c25309006d5d 100644
--- a/fs/d_path.c
+++ b/fs/d_path.c
@@ -279,7 +279,8 @@ char *d_path(const struct path *path, char *buf, int buflen)
 	 * and instead have d_path return the mounted path.
 	 */
 	if (path->dentry->d_op && path->dentry->d_op->d_dname &&
-	    (!IS_ROOT(path->dentry) || path->dentry != path->mnt->mnt_root))
+	    (!IS_ROOT(path->dentry) || path->dentry != path->mnt->mnt_root ||
+	     failfs_mnt(path->mnt)))
 		return path->dentry->d_op->d_dname(path->dentry, buf, buflen);
 
 	rcu_read_lock();
diff --git a/fs/failfs.c b/fs/failfs.c
new file mode 100644
index 000000000000..d0ca1fc6c459
--- /dev/null
+++ b/fs/failfs.c
@@ -0,0 +1,155 @@
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
+bool failfs_mnt(const struct vfsmount *mnt)
+{
+	return mnt->mnt_sb == failfs_root_path.mnt->mnt_sb;
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
+static char *failfs_dname(struct dentry *dentry, char *buffer, int buflen)
+{
+	return dynamic_dname(buffer, buflen, "failfs:/");
+}
+
+static const struct dentry_operations failfs_dentry_operations = {
+	.d_dname		= failfs_dname,
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
index 355d93f92208..ce7f12c5a65b 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -362,3 +362,6 @@ int anon_inode_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		       struct iattr *attr);
 void pidfs_get_root(struct path *path);
 void nsfs_get_root(struct path *path);
+void failfs_get_root(struct path *path);
+void __init failfs_init(void);
+bool failfs_mnt(const struct vfsmount *mnt);
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

