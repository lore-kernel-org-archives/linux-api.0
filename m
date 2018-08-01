From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/33] vfs: syscall: Add move_mount(2) to move mounts around
 [ver #11]
Date: Wed, 01 Aug 2018 16:24:18 +0100
Message-ID: <153313705821.13253.15519769348603350410.stgit@warthog.procyon.org.uk>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: linux-api@vger.kernel.org, torvalds@linux-foundation.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add a move_mount() system call that will move a mount from one place to
another and, in the next commit, allow to attach an unattached mount tree.

The new system call looks like the following:

	int move_mount(int from_dfd, const char *from_path,
		       int to_dfd, const char *to_path,
		       unsigned int flags);

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-api@vger.kernel.org
---

 arch/x86/entry/syscalls/syscall_32.tbl |    1 
 arch/x86/entry/syscalls/syscall_64.tbl |    1 
 fs/namespace.c                         |  102 ++++++++++++++++++++++++++------
 include/linux/lsm_hooks.h              |    6 ++
 include/linux/security.h               |    7 ++
 include/linux/syscalls.h               |    3 +
 include/uapi/linux/mount.h             |   11 +++
 security/security.c                    |    5 ++
 8 files changed, 118 insertions(+), 18 deletions(-)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index ea1b413afd47..76d092b7d1b0 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -399,3 +399,4 @@
 385	i386	io_pgetevents		sys_io_pgetevents		__ia32_compat_sys_io_pgetevents
 386	i386	rseq			sys_rseq			__ia32_sys_rseq
 387	i386	open_tree		sys_open_tree			__ia32_sys_open_tree
+388	i386	move_mount		sys_move_mount			__ia32_sys_move_mount
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 0545bed581dc..37ba4e65eee6 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -344,6 +344,7 @@
 333	common	io_pgetevents		__x64_sys_io_pgetevents
 334	common	rseq			__x64_sys_rseq
 335	common	open_tree		__x64_sys_open_tree
+336	common	move_mount		__x64_sys_move_mount
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/namespace.c b/fs/namespace.c
index a4a01ecbcacd..e2934a4f342b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2447,43 +2447,37 @@ static inline int tree_contains_unbindable(struct mount *mnt)
 	return 0;
 }
 
-static int do_move_mount(struct path *path, const char *old_name)
+static int do_move_mount(struct path *old_path, struct path *new_path)
 {
-	struct path old_path, parent_path;
+	struct path parent_path = {.mnt = NULL, .dentry = NULL};
 	struct mount *p;
 	struct mount *old;
 	struct mountpoint *mp;
 	int err;
-	if (!old_name || !*old_name)
-		return -EINVAL;
-	err = kern_path(old_name, LOOKUP_FOLLOW, &old_path);
-	if (err)
-		return err;
 
-	mp = lock_mount(path);
+	mp = lock_mount(new_path);
 	err = PTR_ERR(mp);
 	if (IS_ERR(mp))
 		goto out;
 
-	old = real_mount(old_path.mnt);
-	p = real_mount(path->mnt);
+	old = real_mount(old_path->mnt);
+	p = real_mount(new_path->mnt);
 
 	err = -EINVAL;
 	if (!check_mnt(p) || !check_mnt(old))
 		goto out1;
 
-	if (old->mnt.mnt_flags & MNT_LOCKED)
+	if (!mnt_has_parent(old))
 		goto out1;
 
-	err = -EINVAL;
-	if (old_path.dentry != old_path.mnt->mnt_root)
+	if (old->mnt.mnt_flags & MNT_LOCKED)
 		goto out1;
 
-	if (!mnt_has_parent(old))
+	if (old_path->dentry != old_path->mnt->mnt_root)
 		goto out1;
 
-	if (d_is_dir(path->dentry) !=
-	      d_is_dir(old_path.dentry))
+	if (d_is_dir(new_path->dentry) !=
+	    d_is_dir(old_path->dentry))
 		goto out1;
 	/*
 	 * Don't move a mount residing in a shared parent.
@@ -2501,7 +2495,8 @@ static int do_move_mount(struct path *path, const char *old_name)
 		if (p == old)
 			goto out1;
 
-	err = attach_recursive_mnt(old, real_mount(path->mnt), mp, &parent_path);
+	err = attach_recursive_mnt(old, real_mount(new_path->mnt), mp,
+				   &parent_path);
 	if (err)
 		goto out1;
 
@@ -2513,6 +2508,22 @@ static int do_move_mount(struct path *path, const char *old_name)
 out:
 	if (!err)
 		path_put(&parent_path);
+	return err;
+}
+
+static int do_move_mount_old(struct path *path, const char *old_name)
+{
+	struct path old_path;
+	int err;
+
+	if (!old_name || !*old_name)
+		return -EINVAL;
+
+	err = kern_path(old_name, LOOKUP_FOLLOW, &old_path);
+	if (err)
+		return err;
+
+	err = do_move_mount(&old_path, path);
 	path_put(&old_path);
 	return err;
 }
@@ -2934,7 +2945,7 @@ long do_mount(const char *dev_name, const char __user *dir_name,
 	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
 		retval = do_change_type(&path, flags);
 	else if (flags & MS_MOVE)
-		retval = do_move_mount(&path, dev_name);
+		retval = do_move_mount_old(&path, dev_name);
 	else
 		retval = do_new_mount(&path, type_page, sb_flags, mnt_flags,
 				      dev_name, data_page, data_size);
@@ -3169,6 +3180,61 @@ SYSCALL_DEFINE5(mount, char __user *, dev_name, char __user *, dir_name,
 	return ksys_mount(dev_name, dir_name, type, flags, data);
 }
 
+/*
+ * Move a mount from one place to another.
+ *
+ * Note the flags value is a combination of MOVE_MOUNT_* flags.
+ */
+SYSCALL_DEFINE5(move_mount,
+		int, from_dfd, const char *, from_pathname,
+		int, to_dfd, const char *, to_pathname,
+		unsigned int, flags)
+{
+	struct path from_path, to_path;
+	unsigned int lflags;
+	int ret = 0;
+
+	if (!may_mount())
+		return -EPERM;
+
+	if (flags & ~MOVE_MOUNT__MASK)
+		return -EINVAL;
+
+	/* If someone gives a pathname, they aren't permitted to move
+	 * from an fd that requires unmount as we can't get at the flag
+	 * to clear it afterwards.
+	 */
+	lflags = 0;
+	if (flags & MOVE_MOUNT_F_SYMLINKS)	lflags |= LOOKUP_FOLLOW;
+	if (flags & MOVE_MOUNT_F_AUTOMOUNTS)	lflags |= LOOKUP_AUTOMOUNT;
+	if (flags & MOVE_MOUNT_F_EMPTY_PATH)	lflags |= LOOKUP_EMPTY;
+
+	ret = user_path_at(from_dfd, from_pathname, lflags, &from_path);
+	if (ret < 0)
+		return ret;
+
+	lflags = 0;
+	if (flags & MOVE_MOUNT_T_SYMLINKS)	lflags |= LOOKUP_FOLLOW;
+	if (flags & MOVE_MOUNT_T_AUTOMOUNTS)	lflags |= LOOKUP_AUTOMOUNT;
+	if (flags & MOVE_MOUNT_T_EMPTY_PATH)	lflags |= LOOKUP_EMPTY;
+
+	ret = user_path_at(to_dfd, to_pathname, lflags, &to_path);
+	if (ret < 0)
+		goto out_from;
+
+	ret = security_move_mount(&from_path, &to_path);
+	if (ret < 0)
+		goto out_to;
+
+	ret = do_move_mount(&from_path, &to_path);
+
+out_to:
+	path_put(&to_path);
+out_from:
+	path_put(&from_path);
+	return ret;
+}
+
 /*
  * Return true if path is reachable from root
  *
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index b43bbc893074..924424e7be8f 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -147,6 +147,10 @@
  *	Parse a string of security data filling in the opts structure
  *	@options string containing all mount options known by the LSM
  *	@opts binary data structure usable by the LSM
+ * @move_mount:
+ *	Check permission before a mount is moved.
+ *	@from_path indicates the mount that is going to be moved.
+ *	@to_path indicates the mountpoint that will be mounted upon.
  * @dentry_init_security:
  *	Compute a context for a dentry as the inode is not yet available
  *	since NFSv4 has no label backed by an EA anyway.
@@ -1480,6 +1484,7 @@ union security_list_options {
 					unsigned long kern_flags,
 					unsigned long *set_kern_flags);
 	int (*sb_parse_opts_str)(char *options, struct security_mnt_opts *opts);
+	int (*move_mount)(const struct path *from_path, const struct path *to_path);
 	int (*dentry_init_security)(struct dentry *dentry, int mode,
 					const struct qstr *name, void **ctx,
 					u32 *ctxlen);
@@ -1811,6 +1816,7 @@ struct security_hook_heads {
 	struct hlist_head sb_set_mnt_opts;
 	struct hlist_head sb_clone_mnt_opts;
 	struct hlist_head sb_parse_opts_str;
+	struct hlist_head move_mount;
 	struct hlist_head dentry_init_security;
 	struct hlist_head dentry_create_files_as;
 #ifdef CONFIG_SECURITY_PATH
diff --git a/include/linux/security.h b/include/linux/security.h
index 1498b9e0539b..9bb5bc6d596c 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -245,6 +245,7 @@ int security_sb_clone_mnt_opts(const struct super_block *oldsb,
 				unsigned long kern_flags,
 				unsigned long *set_kern_flags);
 int security_sb_parse_opts_str(char *options, struct security_mnt_opts *opts);
+int security_move_mount(const struct path *from_path, const struct path *to_path);
 int security_dentry_init_security(struct dentry *dentry, int mode,
 					const struct qstr *name, void **ctx,
 					u32 *ctxlen);
@@ -599,6 +600,12 @@ static inline int security_sb_parse_opts_str(char *options, struct security_mnt_
 	return 0;
 }
 
+static inline int security_move_mount(const struct path *from_path,
+				      const struct path *to_path)
+{
+	return 0;
+}
+
 static inline int security_inode_alloc(struct inode *inode)
 {
 	return 0;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 3cc6b8f8bd2f..3c0855d9b105 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -901,6 +901,9 @@ asmlinkage long sys_statx(int dfd, const char __user *path, unsigned flags,
 asmlinkage long sys_rseq(struct rseq __user *rseq, uint32_t rseq_len,
 			 int flags, uint32_t sig);
 asmlinkage long sys_open_tree(int dfd, const char __user *path, unsigned flags);
+asmlinkage long sys_move_mount(int from_dfd, const char __user *from_path,
+			       int to_dfd, const char __user *to_path,
+			       unsigned int ms_flags);
 
 /*
  * Architecture-specific system calls
diff --git a/include/uapi/linux/mount.h b/include/uapi/linux/mount.h
index e8db2911adca..89adf0d731ab 100644
--- a/include/uapi/linux/mount.h
+++ b/include/uapi/linux/mount.h
@@ -7,4 +7,15 @@
 #define OPEN_TREE_CLONE		1		/* Clone the target tree and attach the clone */
 #define OPEN_TREE_CLOEXEC	O_CLOEXEC	/* Close the file on execve() */
 
+/*
+ * move_mount() flags.
+ */
+#define MOVE_MOUNT_F_SYMLINKS		0x00000001 /* Follow symlinks on from path */
+#define MOVE_MOUNT_F_AUTOMOUNTS		0x00000002 /* Follow automounts on from path */
+#define MOVE_MOUNT_F_EMPTY_PATH		0x00000004 /* Empty from path permitted */
+#define MOVE_MOUNT_T_SYMLINKS		0x00000010 /* Follow symlinks on to path */
+#define MOVE_MOUNT_T_AUTOMOUNTS		0x00000020 /* Follow automounts on to path */
+#define MOVE_MOUNT_T_EMPTY_PATH		0x00000040 /* Empty to path permitted */
+#define MOVE_MOUNT__MASK		0x00000077
+
 #endif /* _UAPI_LINUX_MOUNT_H */
diff --git a/security/security.c b/security/security.c
index 7cafc1c90d16..5149c2cbe8a7 100644
--- a/security/security.c
+++ b/security/security.c
@@ -439,6 +439,11 @@ int security_sb_parse_opts_str(char *options, struct security_mnt_opts *opts)
 }
 EXPORT_SYMBOL(security_sb_parse_opts_str);
 
+int security_move_mount(const struct path *from_path, const struct path *to_path)
+{
+	return call_int_hook(move_mount, 0, from_path, to_path);
+}
+
 int security_inode_alloc(struct inode *inode)
 {
 	inode->i_security = NULL;
