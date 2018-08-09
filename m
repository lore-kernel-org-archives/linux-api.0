From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 28/33] vfs: syscall: Add fsconfig() for configuring and managing a context [ver #11]
Date: Thu, 09 Aug 2018 15:14:06 +0100
Message-ID: <26034.1533824046@warthog.procyon.org.uk>
References: <87in4n9zg0.fsf@xmission.com> <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk> <153313723557.13253.9055982745313603422.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87in4n9zg0.fsf@xmission.com>
Content-ID: <26033.1533824046.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Eric W. Biederman <ebiederm@xmission.com> wrote:

> First let me thank you for adding both FSCONFIG_CMD_CREATE and
> FSCONFIG_CMD_RECONFIGURE.  Unfortunately the implementation is currently
> broken.  So this patch gets my:
> 
> This is broken in two specific ways.
> 1) FSCONFIG_CMD_RECONFIGURE always returns -EOPNOTSUPPORTED.
>    So it is useless.

This isn't broken, just not completely implemented.  I would like to get the
core VFS framework upstream so that filesystems can start being converted.

However, since you asked nicely, here's a patch that adds the reconfiguration
bit.

David
---
vfs: Use fs_context for reconfig and implement FSCONFIG_CMD_RECONFIGURE

Implement fs_context-based reconfiguration by the following means:

 (1) Provide two more internal fs_context purposes: umount that actually
     reconfigures to R/O and emergency reconfiguration to R/O.  This tells
     the filesystem if it the context hasn't been fully initialised.

 (2) Track which bits in sb_mask have been changed in addition to what
     they've been changed to.

 (3) Move ->reconfigure() from the superblock ops to the fs_context ops.
     This makes (4) possible.  The ->remount_fs() superblock op is
     obsolete.

 (4) Provide a legacy wrapper for ->reconfigure().

 (5) Make a do_umount() that's unmounting a root allocate an fs_context on
     the stack and use that to reconfigure to R/O.

 (6) Make do_emergency_remount_callback() allocate an fs_context on the
     stack and use that to reconfigurate to R/O.

 (6) Make do_remount() unconditionally use an fs_context to invoke
     do_remount_sb().

 (7) Only pass in a filesystem context to do_remount_sb().  This, along
     with (4), allows the function to be simplified.

 (8) Pass errors back from mount_single() if reconfiguration fails.  We
     might want this behaviour to be conditional, depending on which mount
     API was used.

 (9) Delete security_sb_remount().

(10) Rename do_remount_sb() to reconfigure_super().

Notes:

 (1) do_remount() can't make use of vfs_reconfigure_sb() if the former
     changes the mount attributes atomically or if the latter doesn't do so
     at all.

     However, since I think Al wants us to move towards separating
     superblock reconfiguration from mountpoint reconfiguration, there may
     not be a need to do this atomically.

 (2) mount_single() probably shouldn't reconfigure an already existing
     superblock if it's supposed to be creating a new one, but rather it
     (or, rather, the filesystem) should compare the parameters and either
     return the live superblock if the params are the same or return an
     error if not.

     However, this probably needs to be contingent on the mount API or
     something so as not to break userspace.

 (3) I should add something like an FSOPEN_EXCL flag to tell sget_fc() to
     fail if the superblock already exists at all and an
     FSOPEN_FAIL_ON_MISMATCH flag to explicitly say that we *don't* want a
     superblock with different parameters.  The implication of providing
     neither flag is that we are happy to accept a superblock from the same
     source but with different parameters.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 Documentation/filesystems/mount_api.txt |   56 +++++++-------
 fs/afs/mntpt.c                          |    2 
 fs/afs/super.c                          |    2 
 fs/fs_context.c                         |   46 ++++++-----
 fs/fsopen.c                             |   84 +++++++++++++++++++--
 fs/hugetlbfs/inode.c                    |    2 
 fs/internal.h                           |    9 +-
 fs/kernfs/mount.c                       |    5 -
 fs/libfs.c                              |    3 
 fs/namespace.c                          |   87 +++++++++-------------
 fs/nfs/super.c                          |    2 
 fs/proc/inode.c                         |    1 
 fs/proc/internal.h                      |    1 
 fs/proc/root.c                          |    6 +
 fs/super.c                              |  125 ++++++++++++++++++++------------
 include/linux/fs.h                      |    1 
 include/linux/fs_context.h              |    8 +-
 include/linux/kernfs.h                  |    1 
 include/linux/lsm_hooks.h               |    9 --
 include/linux/security.h                |    6 -
 ipc/mqueue.c                            |    2 
 kernel/cgroup/cgroup.c                  |    2 
 kernel/cgroup/cpuset.c                  |    3 
 security/security.c                     |    5 -
 security/selinux/hooks.c                |    1 
 25 files changed, 283 insertions(+), 186 deletions(-)

diff --git a/Documentation/filesystems/mount_api.txt b/Documentation/filesystems/mount_api.txt
index 5fec78eed4f4..35cc5c7a5008 100644
--- a/Documentation/filesystems/mount_api.txt
+++ b/Documentation/filesystems/mount_api.txt
@@ -55,16 +55,6 @@ purposes - otherwise it will be NULL.
 Note that security initialisation is done *after* the filesystem is called so
 that the namespaces may be adjusted first.
 
-And the super_operations struct gains one field:
-
-	int (*reconfigure)(struct super_block *, struct fs_context *);
-
-This shadows the ->reconfigure() operation and takes a prepared filesystem
-context instead of the mount flags and data page.  It may modify the sb_flags
-in the context for the caller to pick up.
-
-[NOTE] reconfigure is intended as a replacement for remount_fs.
-
 
 ======================
 THE FILESYSTEM CONTEXT
@@ -86,6 +76,7 @@ context.  This is represented by the fs_context structure:
 		void			*security;
 		void			*s_fs_info;
 		unsigned int		sb_flags;
+		unsigned int		sb_flags_mask;
 		enum fs_context_purpose	purpose:8;
 		bool			sloppy:1;
 		bool			silent:1;
@@ -150,8 +141,9 @@ The fs_context fields are as follows:
      sget_fc().  This can be used to distinguish superblocks.
 
  (*) unsigned int sb_flags
+ (*) unsigned int sb_flags_mask
 
-     This holds the SB_* flags to be set in super_block::s_flags.
+     Which bits SB_* flags are to be set/cleared in super_block::s_flags.
 
  (*) enum fs_context_purpose
 
@@ -162,6 +154,10 @@ The fs_context fields are as follows:
 	FS_CONTEXT_FOR_KERNEL_MOUNT,	-- New superblock for kernel-internal mount
 	FS_CONTEXT_FOR_SUBMOUNT		-- New automatic submount of extant mount
 	FS_CONTEXT_FOR_RECONFIGURE	-- Change an existing mount
+	FS_CONTEXT_FOR_UMOUNT		-- Reconfigure to R/O for umount()
+	FS_CONTEXT_FOR_EMERGENCY_RO	-- Emergency reconfigure to R/O
+
+     In the last two cases, ->init_fs_context() will not have been called.
 
  (*) bool sloppy
  (*) bool silent
@@ -174,8 +170,8 @@ The fs_context fields are as follows:
 
      [NOTE] silent is probably redundant with sb_flags & SB_SILENT.
 
-The mount context is created by calling vfs_new_fs_context(), vfs_sb_reconfig()
-or vfs_dup_fs_context() and is destroyed with put_fs_context().  Note that the
+The mount context is created by calling vfs_new_fs_context() or
+vfs_dup_fs_context() and is destroyed with put_fs_context().  Note that the
 structure is not refcounted.
 
 VFS, security and filesystem mount options are set individually with
@@ -206,6 +202,7 @@ The filesystem context points to a table of operations:
 					size_t data_size);
 		int (*validate)(struct fs_context *fc);
 		int (*get_tree)(struct fs_context *fc);
+		int (*reconfigure)(struct fs_context *fc);
 	};
 
 These operations are invoked by the various stages of the mount procedure to
@@ -278,6 +275,18 @@ manage the filesystem context.  They are as follows:
      The phase on a userspace-driven context will be set to only allow this to
      be called once on any particular context.
 
+ (*) int (*reconfigure)(struct fs_context *fc);
+
+     Called to effect reconfiguration of a superblock using information stored
+     in the filesystem context.  It may detach any resources it desires from
+     the filesystem context and transfer them to the superblock.  The
+     superblock can be found from fc->root->d_sb.
+
+     On success it should return 0.  In the case of an error, it should return
+     a negative error code.
+
+     [NOTE] reconfigure is intended as a replacement for remount_fs.
+
 
 ===========================
 FILESYSTEM CONTEXT SECURITY
@@ -358,24 +367,19 @@ one for destroying a context:
  (*) struct fs_context *vfs_new_fs_context(struct file_system_type *fs_type,
 					   struct dentry *reference,
 					   unsigned int sb_flags,
+					   unsigned int sb_flags_mask,
 					   enum fs_context_purpose purpose);
 
      Create a filesystem context for a given filesystem type and purpose.  This
-     allocates the filesystem context, sets the flags, initialises the security
-     and calls fs_type->init_fs_context() to initialise the filesystem private
-     data.
+     allocates the filesystem context, sets the superblock flags, initialises
+     the security and calls fs_type->init_fs_context() to initialise the
+     filesystem private data.
 
      reference can be NULL or it may indicate the root dentry of a superblock
-     that is going to be reconfigured (FS_CONTEXT_FOR_RECONFIGURE) or the
-     automount point that triggered a submount (FS_CONTEXT_FOR_SUBMOUNT).  This
-     is provided as a source of namespace information.
-
- (*) struct fs_context *vfs_sb_reconfig(struct vfsmount *mnt,
-					unsigned int sb_flags);
-
-     Create a filesystem context from the same filesystem as an extant mount
-     and initialise the mount parameters from the superblock underlying that
-     mount.  This is for use by superblock parameter reconfiguration.
+     that is going to be reconfigured (FS_CONTEXT_FOR_RECONFIGURE,
+     FS_CONTEXT_FOR_UMOUNT or FS_CONTEXT_FOR_EMERGENCY_RO) or the automount
+     point that triggered a submount (FS_CONTEXT_FOR_SUBMOUNT).  This is
+     provided as a source of namespace information.
 
  (*) struct fs_context *vfs_dup_fs_context(struct fs_context *src_fc);
 
diff --git a/fs/afs/mntpt.c b/fs/afs/mntpt.c
index c8a7f05b9f12..16ee515b51c9 100644
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -147,7 +147,7 @@ static struct vfsmount *afs_mntpt_do_automount(struct dentry *mntpt)
 
 	BUG_ON(!d_inode(mntpt));
 
-	fc = vfs_new_fs_context(&afs_fs_type, mntpt, 0,
+	fc = vfs_new_fs_context(&afs_fs_type, mntpt, 0, 0,
 				FS_CONTEXT_FOR_SUBMOUNT);
 	if (IS_ERR(fc))
 		return ERR_CAST(fc);
diff --git a/fs/afs/super.c b/fs/afs/super.c
index 7c97836e7937..43cf1a6a4bf7 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -634,7 +634,7 @@ static int afs_init_fs_context(struct fs_context *fc, struct dentry *reference)
 		}
 		break;
 
-	case FS_CONTEXT_FOR_RECONFIGURE:
+	default:
 		break;
 	}
 
diff --git a/fs/fs_context.c b/fs/fs_context.c
index a6597a2fbf2b..2e9a88f41071 100644
--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -106,12 +106,14 @@ static int vfs_parse_sb_flag(struct fs_context *fc, const char *key)
 	token = lookup_constant(common_set_sb_flag, key, 0);
 	if (token) {
 		fc->sb_flags |= token;
+		fc->sb_flags_mask |= token;
 		return 1;
 	}
 
 	token = lookup_constant(common_clear_sb_flag, key, 0);
 	if (token) {
 		fc->sb_flags &= ~token;
+		fc->sb_flags_mask |= token;
 		return 1;
 	}
 
@@ -240,6 +242,7 @@ EXPORT_SYMBOL(generic_parse_monolithic);
  * @fs_type: The filesystem type.
  * @reference: The dentry from which this one derives (or NULL)
  * @sb_flags: Filesystem/superblock flags (SB_*)
+ * @sb_flags_mask: Applicable members of @sb_flags
  * @purpose: The purpose that this configuration shall be used for.
  *
  * Open a filesystem and create a mount context.  The mount context is
@@ -250,6 +253,7 @@ EXPORT_SYMBOL(generic_parse_monolithic);
 struct fs_context *vfs_new_fs_context(struct file_system_type *fs_type,
 				      struct dentry *reference,
 				      unsigned int sb_flags,
+				      unsigned int sb_flags_mask,
 				      enum fs_context_purpose purpose)
 {
 	int (*init_fs_context)(struct fs_context *, struct dentry *);
@@ -262,6 +266,7 @@ struct fs_context *vfs_new_fs_context(struct file_system_type *fs_type,
 
 	fc->purpose	= purpose;
 	fc->sb_flags	= sb_flags;
+	fc->sb_flags_mask = sb_flags_mask;
 	fc->fs_type	= get_filesystem(fs_type);
 	fc->cred	= get_current_cred();
 
@@ -280,6 +285,8 @@ struct fs_context *vfs_new_fs_context(struct file_system_type *fs_type,
 		fc->net_ns = get_net(current->nsproxy->net_ns);
 		break;
 	case FS_CONTEXT_FOR_RECONFIGURE:
+	case FS_CONTEXT_FOR_UMOUNT:
+	case FS_CONTEXT_FOR_EMERGENCY_RO:
 		/* We don't pin any namespaces as the superblock's
 		 * subscriptions cannot be changed at this point.
 		 */
@@ -314,28 +321,6 @@ struct fs_context *vfs_new_fs_context(struct file_system_type *fs_type,
 }
 EXPORT_SYMBOL(vfs_new_fs_context);
 
-/**
- * vfs_sb_reconfig - Create a filesystem context for remount/reconfiguration
- * @mountpoint: The mountpoint to open
- * @sb_flags: Filesystem/superblock flags (SB_*)
- *
- * Open a mounted filesystem and create a filesystem context such that a
- * remount can be effected.
- */
-struct fs_context *vfs_sb_reconfig(struct path *mountpoint,
-				   unsigned int sb_flags)
-{
-	struct fs_context *fc;
-
-	fc = vfs_new_fs_context(mountpoint->dentry->d_sb->s_type,
-				mountpoint->dentry,
-				sb_flags, FS_CONTEXT_FOR_RECONFIGURE);
-	if (IS_ERR(fc))
-		return fc;
-
-	return fc;
-}
-
 /**
  * vfs_dup_fc_config: Duplicate a filesytem context.
  * @src_fc: The context to copy.
@@ -754,6 +739,22 @@ static int legacy_get_tree(struct fs_context *fc)
 	return ret;
 }
 
+/*
+ * Handle remount.
+ */
+static int legacy_reconfigure(struct fs_context *fc)
+{
+	struct legacy_fs_context *ctx = fc->fs_private;
+	struct super_block *sb = fc->root->d_sb;
+
+	if (!sb->s_op->remount_fs)
+		return 0;
+
+	return sb->s_op->remount_fs(sb, &fc->sb_flags,
+				    ctx ? ctx->legacy_data : NULL,
+				    ctx ? ctx->data_size : 0);
+}
+
 const struct fs_context_operations legacy_fs_context_ops = {
 	.free			= legacy_fs_context_free,
 	.dup			= legacy_fs_context_dup,
@@ -761,6 +762,7 @@ const struct fs_context_operations legacy_fs_context_ops = {
 	.parse_monolithic	= legacy_parse_monolithic,
 	.validate		= legacy_validate,
 	.get_tree		= legacy_get_tree,
+	.reconfigure		= legacy_reconfigure,
 };
 
 /*
diff --git a/fs/fsopen.c b/fs/fsopen.c
index e79bb5b085d6..9ead9220e2cb 100644
--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -137,7 +137,7 @@ SYSCALL_DEFINE2(fsopen, const char __user *, _fs_name, unsigned int, flags)
 	if (!fs_type)
 		return -ENODEV;
 
-	fc = vfs_new_fs_context(fs_type, NULL, 0, FS_CONTEXT_FOR_USER_MOUNT);
+	fc = vfs_new_fs_context(fs_type, NULL, 0, 0, FS_CONTEXT_FOR_USER_MOUNT);
 	put_filesystem(fs_type);
 	if (IS_ERR(fc))
 		return PTR_ERR(fc);
@@ -185,12 +185,8 @@ SYSCALL_DEFINE3(fspick, int, dfd, const char __user *, path, unsigned int, flags
 	if (ret < 0)
 		goto err;
 
-	ret = -EOPNOTSUPP;
-	if (!target.dentry->d_sb->s_op->reconfigure)
-		goto err_path;
-
 	fc = vfs_new_fs_context(target.dentry->d_sb->s_type, target.dentry,
-				0, FS_CONTEXT_FOR_RECONFIGURE);
+				0, 0, FS_CONTEXT_FOR_RECONFIGURE);
 	if (IS_ERR(fc)) {
 		ret = PTR_ERR(fc);
 		goto err_path;
@@ -255,6 +251,58 @@ static int vfs_fsconfig(struct fs_context *fc, struct fs_parameter *param)
 	return vfs_parse_fs_param(fc, param);
 }
 
+/*
+ * Reconfigure a superblock.
+ */
+int vfs_reconfigure_sb(struct fs_context *fc)
+{
+	struct super_block *sb = fc->root->d_sb;
+	int ret;
+
+	if (fc->ops->validate) {
+		ret = fc->ops->validate(fc);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = security_fs_context_validate(fc);
+	if (ret)
+		return ret;
+
+	if (!ns_capable(sb->s_user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	down_write(&sb->s_umount);
+	ret = reconfigure_super(fc);
+	up_write(&sb->s_umount);
+	return ret;
+}
+
+/*
+ * Clean up a context after performing an action on it and put it into a state
+ * from where it can be used to reconfigure a superblock.
+ */
+void vfs_clean_context(struct fs_context *fc)
+{
+	if (fc->ops && fc->ops->free)
+		fc->ops->free(fc);
+	fc->need_free = false;
+	fc->fs_private = NULL;
+	fc->s_fs_info = NULL;
+	fc->sb_flags = 0;
+	fc->sloppy = false;
+	fc->silent = false;
+	security_fs_context_free(fc);
+	fc->security = NULL;
+	kfree(fc->subtype);
+	fc->subtype = NULL;
+	kfree(fc->source);
+	fc->source = NULL;
+
+	fc->purpose = FS_CONTEXT_FOR_RECONFIGURE;
+	fc->phase = FS_CONTEXT_AWAITING_RECONF;
+}
+
 /*
  * Perform an action on a context.
  */
@@ -274,6 +322,30 @@ static int vfs_fsconfig_action(struct fs_context *fc, enum fsconfig_command cmd)
 			fc->phase = FS_CONTEXT_FAILED;
 		return ret;
 
+	case FSCONFIG_CMD_RECONFIGURE:
+		if (fc->phase == FS_CONTEXT_AWAITING_RECONF) {
+			/* This is probably pointless, since no changes have
+			 * been proposed.
+			 */
+			if (fc->fs_type->init_fs_context) {
+				ret = fc->fs_type->init_fs_context(fc, fc->root);
+				if (ret < 0) {
+					fc->phase = FS_CONTEXT_FAILED;
+					return ret;
+				}
+				fc->need_free = true;
+			}
+			fc->phase = FS_CONTEXT_RECONF_PARAMS;
+		}
+
+		fc->phase = FS_CONTEXT_RECONFIGURING;
+		ret = vfs_reconfigure_sb(fc);
+		if (ret == 0)
+			vfs_clean_context(fc);
+		else
+			fc->phase = FS_CONTEXT_FAILED;
+		return ret;
+
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index e2378c8ce7e0..c09a1cd4fa5a 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1510,7 +1510,7 @@ static struct vfsmount *__init mount_one_hugetlbfs(struct hstate *h)
 	struct vfsmount *mnt;
 	int ret;
 
-	fc = vfs_new_fs_context(&hugetlbfs_fs_type, NULL, 0,
+	fc = vfs_new_fs_context(&hugetlbfs_fs_type, NULL, 0, 0,
 				FS_CONTEXT_FOR_KERNEL_MOUNT);
 	if (IS_ERR(fc)) {
 		ret = PTR_ERR(fc);
diff --git a/fs/internal.h b/fs/internal.h
index e5bdfc52b9a1..9c7dd6f12f35 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -54,6 +54,11 @@ extern void __init chrdev_init(void);
  */
 extern const struct fs_context_operations legacy_fs_context_ops;
 
+/*
+ * fsopen.c
+ */
+extern void vfs_clean_context(struct fs_context *fc);
+
 /*
  * namei.c
  */
@@ -77,6 +82,7 @@ int do_linkat(int olddfd, const char __user *oldname, int newdfd,
  */
 extern void *copy_mount_options(const void __user *);
 extern char *copy_mount_string(const void __user *);
+extern int parse_monolithic_mount_data(struct fs_context *, void *, size_t);
 
 extern struct vfsmount *lookup_mnt(const struct path *);
 extern int finish_automount(struct vfsmount *, struct path *);
@@ -106,8 +112,7 @@ extern struct file *get_empty_filp(void);
 /*
  * super.c
  */
-extern int do_remount_sb(struct super_block *, int, void *, size_t, int,
-			 struct fs_context *);
+extern int reconfigure_super(struct fs_context *);
 extern bool trylock_super(struct super_block *sb);
 extern struct super_block *user_get_super(dev_t);
 
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index b568e6c5e063..ec14dc76fe89 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -23,9 +23,9 @@
 
 struct kmem_cache *kernfs_node_cache;
 
-static int kernfs_sop_reconfigure(struct super_block *sb, struct fs_context *fc)
+int kernfs_reconfigure(struct fs_context *fc)
 {
-	struct kernfs_root *root = kernfs_info(sb)->root;
+	struct kernfs_root *root = kernfs_info(fc->root->d_sb)->root;
 	struct kernfs_syscall_ops *scops = root->syscall_ops;
 
 	if (scops && scops->reconfigure)
@@ -75,7 +75,6 @@ const struct super_operations kernfs_sops = {
 	.drop_inode	= generic_delete_inode,
 	.evict_inode	= kernfs_evict_inode,
 
-	.reconfigure	= kernfs_sop_reconfigure,
 	.show_options	= kernfs_sop_show_options,
 	.show_path	= kernfs_sop_show_path,
 	.get_fsinfo	= kernfs_sop_get_fsinfo,
diff --git a/fs/libfs.c b/fs/libfs.c
index d9a5d883dc3f..b1744c071ab0 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -583,7 +583,8 @@ int simple_pin_fs(struct file_system_type *type, struct vfsmount **mount, int *c
 	if (unlikely(!*mount)) {
 		spin_unlock(&pin_fs_lock);
 
-		fc = vfs_new_fs_context(type, NULL, 0, FS_CONTEXT_FOR_KERNEL_MOUNT);
+		fc = vfs_new_fs_context(type, NULL, 0, 0,
+					FS_CONTEXT_FOR_KERNEL_MOUNT);
 		if (IS_ERR(fc))
 			return PTR_ERR(fc);
 
diff --git a/fs/namespace.c b/fs/namespace.c
index e34e3fd064b0..47aea9542bf1 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1479,6 +1479,25 @@ static void umount_tree(struct mount *mnt, enum umount_tree_flags how)
 
 static void shrink_submounts(struct mount *mnt);
 
+static int do_umount_root(struct super_block *sb)
+{
+	int ret = 0;
+	struct fs_context fc = {
+		.purpose	= FS_CONTEXT_FOR_UMOUNT,
+		.fs_type	= sb->s_type,
+		.root		= sb->s_root,
+		.sb_flags	= SB_RDONLY,
+		.sb_flags_mask	= SB_RDONLY,
+	};
+
+	down_write(&sb->s_umount);
+	if (!sb_rdonly(sb))
+		/* Might want to call ->init_fs_context(). */
+		ret = reconfigure_super(&fc);
+	up_write(&sb->s_umount);
+	return ret;
+}
+
 static int do_umount(struct mount *mnt, int flags)
 {
 	struct super_block *sb = mnt->mnt.mnt_sb;
@@ -1544,11 +1563,7 @@ static int do_umount(struct mount *mnt, int flags)
 		 */
 		if (!ns_capable(sb->s_user_ns, CAP_SYS_ADMIN))
 			return -EPERM;
-		down_write(&sb->s_umount);
-		if (!sb_rdonly(sb))
-			retval = do_remount_sb(sb, SB_RDONLY, NULL, 0, 0, NULL);
-		up_write(&sb->s_umount);
-		return retval;
+		return do_umount_root(sb);
 	}
 
 	namespace_lock();
@@ -2394,7 +2409,7 @@ static int do_reconfigure_mnt(struct path *path, unsigned int mnt_flags)
 /*
  * Parse the monolithic page of mount data given to sys_mount().
  */
-static int parse_monolithic_mount_data(struct fs_context *fc, void *data, size_t data_size)
+int parse_monolithic_mount_data(struct fs_context *fc, void *data, size_t data_size)
 {
 	int (*monolithic_mount_data)(struct fs_context *, void *, size_t);
 
@@ -2417,7 +2432,6 @@ static int do_remount(struct path *path, int ms_flags, int sb_flags,
 	int err;
 	struct super_block *sb = path->mnt->mnt_sb;
 	struct mount *mnt = real_mount(path->mnt);
-	struct file_system_type *type = sb->s_type;
 
 	if (!check_mnt(mnt))
 		return -EINVAL;
@@ -2428,41 +2442,34 @@ static int do_remount(struct path *path, int ms_flags, int sb_flags,
 	if (!can_change_locked_flags(mnt, mnt_flags))
 		return -EPERM;
 
-	if (type->init_fs_context) {
-		fc = vfs_sb_reconfig(path, sb_flags);
-		if (IS_ERR(fc))
-			return PTR_ERR(fc);
+	fc = vfs_new_fs_context(path->dentry->d_sb->s_type,
+				path->dentry, sb_flags, MS_RMT_MASK,
+				FS_CONTEXT_FOR_RECONFIGURE);
 
-		err = parse_monolithic_mount_data(fc, data, data_size);
+	err = parse_monolithic_mount_data(fc, data, data_size);
+	if (err < 0)
+		goto err_fc;
+
+	if (fc->ops->validate) {
+		err = fc->ops->validate(fc);
 		if (err < 0)
 			goto err_fc;
-
-		if (fc->ops->validate) {
-			err = fc->ops->validate(fc);
-			if (err < 0)
-				goto err_fc;
-		}
-
-		err = security_fs_context_validate(fc);
-		if (err)
-			return err;
-	} else {
-		err = security_sb_remount(sb, data, data_size);
-		if (err)
-			return err;
 	}
 
+	err = security_fs_context_validate(fc);
+	if (err)
+		return err;
+
 	down_write(&sb->s_umount);
 	err = -EPERM;
 	if (ns_capable(sb->s_user_ns, CAP_SYS_ADMIN)) {
-		err = do_remount_sb(sb, sb_flags, data, data_size, 0, fc);
+		err = reconfigure_super(fc);
 		if (!err)
 			set_mount_attributes(mnt, mnt_flags);
 	}
 	up_write(&sb->s_umount);
 err_fc:
-	if (fc)
-		put_fs_context(fc);
+	put_fs_context(fc);
 	return err;
 }
 
@@ -2667,7 +2674,7 @@ static int do_new_mount(struct path *mountpoint, const char *fstype,
 	if (!fs_type)
 		goto out;
 
-	fc = vfs_new_fs_context(fs_type, NULL, sb_flags,
+	fc = vfs_new_fs_context(fs_type, NULL, sb_flags, sb_flags,
 				FS_CONTEXT_FOR_USER_MOUNT);
 	put_filesystem(fs_type);
 	if (IS_ERR(fc)) {
@@ -3294,7 +3301,7 @@ struct vfsmount *vfs_kern_mount(struct file_system_type *type,
 	if (!type)
 		return ERR_PTR(-EINVAL);
 
-	fc = vfs_new_fs_context(type, NULL, sb_flags,
+	fc = vfs_new_fs_context(type, NULL, sb_flags, sb_flags,
 				sb_flags & SB_KERNMOUNT ?
 				FS_CONTEXT_FOR_KERNEL_MOUNT :
 				FS_CONTEXT_FOR_USER_MOUNT);
@@ -3436,23 +3443,7 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags, unsigned int, ms_flags
 	 * do any memory allocation or anything like that at this point as we
 	 * don't want to have to handle any errors incurred.
 	 */
-	if (fc->ops && fc->ops->free)
-		fc->ops->free(fc);
-	fc->need_free = false;
-	fc->fs_private = NULL;
-	fc->s_fs_info = NULL;
-	fc->sb_flags = 0;
-	fc->sloppy = false;
-	fc->silent = false;
-	security_fs_context_free(fc);
-	fc->security = NULL;
-	kfree(fc->subtype);
-	fc->subtype = NULL;
-	kfree(fc->source);
-	fc->source = NULL;
-
-	fc->purpose = FS_CONTEXT_FOR_RECONFIGURE;
-	fc->phase = FS_CONTEXT_AWAITING_RECONF;
+	vfs_clean_context(fc);
 
 	/* Attach to an apparent O_PATH fd with a note that we need to unmount
 	 * it, not just simply put it.
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index b5f27d6999e5..9a4eec0ef20a 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2296,7 +2296,7 @@ nfs_remount(struct super_block *sb, int *flags, char *raw_data, size_t data_size
 
 	/*
 	 * noac is a special case. It implies -o sync, but that's not
-	 * necessarily reflected in the mtab options. do_remount_sb
+	 * necessarily reflected in the mtab options. reconfigure_super
 	 * will clear SB_SYNCHRONOUS if -o sync wasn't specified in the
 	 * remount options, so we have to explicitly reset it.
 	 */
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 38155bec4a54..8d6f46558fa4 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -127,7 +127,6 @@ const struct super_operations proc_sops = {
 	.drop_inode	= generic_delete_inode,
 	.evict_inode	= proc_evict_inode,
 	.statfs		= simple_statfs,
-	.reconfigure	= proc_reconfigure,
 	.show_options	= proc_show_options,
 };
 
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index ea8c5468eafc..75a225688a4c 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -273,7 +273,6 @@ static inline void proc_tty_init(void) {}
 extern struct proc_dir_entry proc_root;
 
 extern void proc_self_init(void);
-extern int proc_reconfigure(struct super_block *, struct fs_context *);
 
 /*
  * task_[no]mmu.c
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 1d6e5bfa30cc..64aa32155432 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -148,8 +148,9 @@ static int proc_fill_super(struct super_block *s, struct fs_context *fc)
 	return proc_setup_thread_self(s);
 }
 
-int proc_reconfigure(struct super_block *sb, struct fs_context *fc)
+static int proc_reconfigure(struct fs_context *fc)
 {
+	struct super_block *sb = fc->root->d_sb;
 	struct pid_namespace *pid = sb->s_fs_info;
 
 	sync_filesystem(sb);
@@ -180,6 +181,7 @@ static const struct fs_context_operations proc_fs_context_ops = {
 	.free		= proc_fs_context_free,
 	.parse_param	= proc_parse_param,
 	.get_tree	= proc_get_tree,
+	.reconfigure	= proc_reconfigure,
 };
 
 static int proc_init_fs_context(struct fs_context *fc, struct dentry *reference)
@@ -310,7 +312,7 @@ int pid_ns_prepare_proc(struct pid_namespace *ns)
 	struct vfsmount *mnt;
 	int ret;
 
-	fc = vfs_new_fs_context(&proc_fs_type, NULL, 0,
+	fc = vfs_new_fs_context(&proc_fs_type, NULL, 0, 0,
 				FS_CONTEXT_FOR_KERNEL_MOUNT);
 	if (IS_ERR(fc))
 		return PTR_ERR(fc);
diff --git a/fs/super.c b/fs/super.c
index 321fbc244570..3f3389e94344 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -920,32 +920,30 @@ struct super_block *user_get_super(dev_t dev)
 }
 
 /**
- *	do_remount_sb - asks filesystem to change mount options.
- *	@sb:	superblock in question
- *	@sb_flags: revised superblock flags
- *	@data:	the rest of options
- *	@data_size: The size of the data
- *      @force: whether or not to force the change
- *	@fc:	the superblock config for filesystems that support it
- *		(NULL if called from emergency or umount)
+ * reconfigure_super - asks filesystem to change superblock parameters
+ * @fc:	the superblock and configuration
  *
- *	Alters the mount options of a mounted file system.
+ * Alters the configuration parameters of a live superblock.
  */
-int do_remount_sb(struct super_block *sb, int sb_flags, void *data,
-		  size_t data_size, int force, struct fs_context *fc)
+int reconfigure_super(struct fs_context *fc)
 {
+	struct super_block *sb = fc->root->d_sb;
 	int retval;
-	int remount_ro;
+	int remount_ro = false;
 
+	if (fc->sb_flags_mask & ~MS_RMT_MASK)
+		return -EINVAL;
 	if (sb->s_writers.frozen != SB_UNFROZEN)
 		return -EBUSY;
 
+	if (fc->sb_flags_mask & SB_RDONLY) {
 #ifdef CONFIG_BLOCK
-	if (!(sb_flags & SB_RDONLY) && bdev_read_only(sb->s_bdev))
-		return -EACCES;
+		if (!(fc->sb_flags & SB_RDONLY) && bdev_read_only(sb->s_bdev))
+			return -EACCES;
 #endif
 
-	remount_ro = (sb_flags & SB_RDONLY) && !sb_rdonly(sb);
+		remount_ro = (fc->sb_flags & SB_RDONLY) && !sb_rdonly(sb);
+	}
 
 	if (remount_ro) {
 		if (!hlist_empty(&sb->s_pins)) {
@@ -956,15 +954,16 @@ int do_remount_sb(struct super_block *sb, int sb_flags, void *data,
 				return 0;
 			if (sb->s_writers.frozen != SB_UNFROZEN)
 				return -EBUSY;
-			remount_ro = (sb_flags & SB_RDONLY) && !sb_rdonly(sb);
+			remount_ro = !sb_rdonly(sb);
 		}
 	}
 	shrink_dcache_sb(sb);
 
-	/* If we are remounting RDONLY and current sb is read/write,
-	   make sure there are no rw files opened */
+	/* If we are reconfiguring to RDONLY and current sb is read/write,
+	 * make sure there are no files open for writing.
+	 */
 	if (remount_ro) {
-		if (force) {
+		if (fc->purpose == FS_CONTEXT_FOR_EMERGENCY_RO) {
 			sb->s_readonly_remount = 1;
 			smp_wmb();
 		} else {
@@ -974,29 +973,21 @@ int do_remount_sb(struct super_block *sb, int sb_flags, void *data,
 		}
 	}
 
-	if (sb->s_op->reconfigure ||
-	    sb->s_op->remount_fs) {
-		if (sb->s_op->reconfigure) {
-			retval = sb->s_op->reconfigure(sb, fc);
-			if (fc)
-				sb_flags = fc->sb_flags;
-			else
-				sb_flags = sb->s_flags;
-			if (retval == 0)
-				security_sb_reconfigure(fc);
+	if (fc->ops->reconfigure) {
+		retval = fc->ops->reconfigure(fc);
+		if (retval == 0) {
+			security_sb_reconfigure(fc);
 		} else {
-			retval = sb->s_op->remount_fs(sb, &sb_flags,
-						      data, data_size);
-		}
-		if (retval) {
-			if (!force)
+			if (fc->purpose != FS_CONTEXT_FOR_EMERGENCY_RO)
 				goto cancel_readonly;
 			/* If forced remount, go ahead despite any errors */
 			WARN(1, "forced remount of a %s fs returned %i\n",
 			     sb->s_type->name, retval);
 		}
 	}
-	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (sb_flags & MS_RMT_MASK);
+
+	WRITE_ONCE(sb->s_flags, ((sb->s_flags & ~fc->sb_flags_mask) |
+				 (fc->sb_flags & fc->sb_flags_mask)));
 	/* Needs to be ordered wrt mnt_is_readonly() */
 	smp_wmb();
 	sb->s_readonly_remount = 0;
@@ -1020,14 +1011,22 @@ int do_remount_sb(struct super_block *sb, int sb_flags, void *data,
 
 static void do_emergency_remount_callback(struct super_block *sb)
 {
+	struct fs_context fc = {
+		.purpose	= FS_CONTEXT_FOR_EMERGENCY_RO,
+		.fs_type	= sb->s_type,
+		.root		= sb->s_root,
+		.sb_flags	= SB_RDONLY,
+		.sb_flags_mask	= SB_RDONLY,
+	};
+
 	down_write(&sb->s_umount);
 	if (sb->s_root && sb->s_bdev && (sb->s_flags & SB_BORN) &&
-	    !sb_rdonly(sb)) {
+	    !sb_rdonly(sb))
+		/* Might want to call ->init_fs_context(). */
 		/*
 		 * What lock protects sb->s_flags??
 		 */
-		do_remount_sb(sb, SB_RDONLY, NULL, 0, 1, NULL);
-	}
+		reconfigure_super(&fc);
 	up_write(&sb->s_umount);
 }
 
@@ -1416,6 +1415,42 @@ struct dentry *mount_nodev(struct file_system_type *fs_type,
 }
 EXPORT_SYMBOL(mount_nodev);
 
+static int reconfigure_single(struct super_block *s,
+			      int flags, void *data, size_t data_size)
+{
+	struct fs_context *fc;
+	int ret;
+
+	/* The caller really need to be passing fc down into mount_single(),
+	 * then a chunk of this can be removed.  Better yet, reconfiguration
+	 * shouldn't happen, but rather the second mount should be rejected if
+	 * the parameters are not compatible.
+	 */
+	fc = vfs_new_fs_context(s->s_type, s->s_root, flags, MS_RMT_MASK,
+				FS_CONTEXT_FOR_RECONFIGURE);
+	if (IS_ERR(fc))
+		return PTR_ERR(fc);
+
+	ret = parse_monolithic_mount_data(fc, data, data_size);
+	if (ret < 0)
+		goto out;
+	
+	if (fc->ops->validate) {
+		ret = fc->ops->validate(fc);
+		if (ret < 0)
+			goto out;
+	}
+
+	ret = security_fs_context_validate(fc);
+	if (ret)
+		goto out;
+
+	ret = reconfigure_super(fc);
+out:
+	put_fs_context(fc);
+	return ret;
+}
+
 static int compare_single(struct super_block *s, void *p)
 {
 	return 1;
@@ -1433,15 +1468,19 @@ struct dentry *mount_single(struct file_system_type *fs_type,
 		return ERR_CAST(s);
 	if (!s->s_root) {
 		error = fill_super(s, data, data_size, flags & SB_SILENT ? 1 : 0);
-		if (error) {
-			deactivate_locked_super(s);
-			return ERR_PTR(error);
-		}
+		if (error)
+			goto error;
 		s->s_flags |= SB_ACTIVE;
 	} else {
-		do_remount_sb(s, flags, data, data_size, 0, NULL);
+		error = reconfigure_single(s, flags, data, data_size);
+		if (error)
+			goto error;
 	}
 	return dget(s->s_root);
+
+error:
+	deactivate_locked_super(s);
+	return ERR_PTR(error);
 }
 EXPORT_SYMBOL(mount_single);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 053d53861995..1300d77efe96 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1853,7 +1853,6 @@ struct super_operations {
 	int (*statfs) (struct dentry *, struct kstatfs *);
 	int (*get_fsinfo) (struct dentry *, struct fsinfo_kparams *);
 	int (*remount_fs) (struct super_block *, int *, char *, size_t);
-	int (*reconfigure) (struct super_block *, struct fs_context *);
 	void (*umount_begin) (struct super_block *);
 
 	int (*show_options)(struct seq_file *, struct dentry *);
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index 9a6aa6bcf745..5e79c33ade7d 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -34,6 +34,8 @@ enum fs_context_purpose {
 	FS_CONTEXT_FOR_KERNEL_MOUNT,	/* New superblock for kernel-internal mount */
 	FS_CONTEXT_FOR_SUBMOUNT,	/* New superblock for automatic submount */
 	FS_CONTEXT_FOR_RECONFIGURE,	/* Superblock reconfiguration (remount) */
+	FS_CONTEXT_FOR_UMOUNT,		/* Reconfiguration to R/O for unmount */
+	FS_CONTEXT_FOR_EMERGENCY_RO,	/* Emergency reconfiguration to R/O */
 };
 
 /*
@@ -102,6 +104,7 @@ struct fs_context {
 	void			*security;	/* The LSM context */
 	void			*s_fs_info;	/* Proposed s_fs_info */
 	unsigned int		sb_flags;	/* Proposed superblock flags (SB_*) */
+	unsigned int		sb_flags_mask;	/* Superblock flags that were changed */
 	enum fs_context_purpose	purpose:8;
 	enum fs_context_phase	phase:8;	/* The phase the context is in */
 	bool			sloppy:1;	/* T if unrecognised options are okay */
@@ -116,6 +119,7 @@ struct fs_context_operations {
 	int (*parse_monolithic)(struct fs_context *fc, void *data, size_t data_size);
 	int (*validate)(struct fs_context *fc);
 	int (*get_tree)(struct fs_context *fc);
+	int (*reconfigure)(struct fs_context *fc);
 };
 
 /*
@@ -123,9 +127,9 @@ struct fs_context_operations {
  */
 extern struct fs_context *vfs_new_fs_context(struct file_system_type *fs_type,
 					     struct dentry *reference,
-					     unsigned int ms_flags,
+					     unsigned int sb_flags,
+					     unsigned int sb_flags_mask,
 					     enum fs_context_purpose purpose);
-extern struct fs_context *vfs_sb_reconfig(struct path *path, unsigned int ms_flags);
 extern struct fs_context *vfs_dup_fs_context(struct fs_context *src);
 extern int vfs_parse_fs_param(struct fs_context *fc, struct fs_parameter *param);
 extern int vfs_parse_fs_string(struct fs_context *fc, const char *key,
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 9fdcdbbb67e9..a6da692792a3 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -370,6 +370,7 @@ int kernfs_get_tree(struct fs_context *fc);
 void kernfs_free_fs_context(struct fs_context *fc);
 void kernfs_kill_sb(struct super_block *sb);
 struct super_block *kernfs_pin_sb(struct kernfs_root *root, const void *ns);
+int kernfs_reconfigure(struct fs_context *fc);
 
 void kernfs_init(void);
 
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index b1a62dc0b8d9..3cfa89f41bad 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -160,13 +160,6 @@
  *	@orig_data is the size of the original data
  *	@copy copied data which will be passed to the security module.
  *	Returns 0 if the copy was successful.
- * @sb_remount:
- *	Extracts security system specific mount options and verifies no changes
- *	are being made to those options.
- *	@sb superblock being remounted
- *	@data contains the filesystem-specific data.
- *	@data_size contains the size of the data.
- *	Return 0 if permission is granted.
  * @sb_umount:
  *	Check permission before the @mnt file system is unmounted.
  *	@mnt contains the mounted file system.
@@ -1518,7 +1511,6 @@ union security_list_options {
 	int (*sb_alloc_security)(struct super_block *sb);
 	void (*sb_free_security)(struct super_block *sb);
 	int (*sb_copy_data)(char *orig, size_t orig_size, char *copy);
-	int (*sb_remount)(struct super_block *sb, void *data, size_t data_size);
 	int (*sb_show_options)(struct seq_file *m, struct super_block *sb);
 	int (*sb_statfs)(struct dentry *dentry);
 	int (*sb_mount)(const char *dev_name, const struct path *path,
@@ -1865,7 +1857,6 @@ struct security_hook_heads {
 	struct hlist_head sb_alloc_security;
 	struct hlist_head sb_free_security;
 	struct hlist_head sb_copy_data;
-	struct hlist_head sb_remount;
 	struct hlist_head sb_show_options;
 	struct hlist_head sb_statfs;
 	struct hlist_head sb_mount;
diff --git a/include/linux/security.h b/include/linux/security.h
index c73d9ba863bc..047b2cff1209 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -240,7 +240,6 @@ int security_sb_mountpoint(struct fs_context *fc, struct path *mountpoint,
 int security_sb_alloc(struct super_block *sb);
 void security_sb_free(struct super_block *sb);
 int security_sb_copy_data(char *orig, size_t orig_size, char *copy);
-int security_sb_remount(struct super_block *sb, void *data, size_t data_size);
 int security_sb_show_options(struct seq_file *m, struct super_block *sb);
 int security_sb_statfs(struct dentry *dentry);
 int security_sb_mount(const char *dev_name, const struct path *path,
@@ -585,11 +584,6 @@ static inline int security_sb_copy_data(char *orig, size_t orig_size, char *copy
 	return 0;
 }
 
-static inline int security_sb_remount(struct super_block *sb, void *data, size_t data_size)
-{
-	return 0;
-}
-
 static inline int security_sb_show_options(struct seq_file *m,
 					   struct super_block *sb)
 {
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 0f102210f89e..0ac430f48800 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -403,7 +403,7 @@ static struct vfsmount *mq_create_mount(struct ipc_namespace *ns)
 	struct vfsmount *mnt;
 	int ret;
 
-	fc = vfs_new_fs_context(&mqueue_fs_type, NULL, 0,
+	fc = vfs_new_fs_context(&mqueue_fs_type, NULL, 0, 0,
 				FS_CONTEXT_FOR_KERNEL_MOUNT);
 	if (IS_ERR(fc))
 		return ERR_CAST(fc);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 958b3fd81c56..6542c0c3e32f 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2150,6 +2150,7 @@ static const struct fs_context_operations cgroup_fs_context_ops = {
 	.parse_param	= cgroup_parse_param,
 	.validate	= cgroup_validate,
 	.get_tree	= cgroup_get_tree,
+	.reconfigure	= kernfs_reconfigure,
 };
 
 /*
@@ -5281,7 +5282,6 @@ int cgroup_rmdir(struct kernfs_node *kn)
 static struct kernfs_syscall_ops cgroup_kf_syscall_ops = {
 	.show_options		= cgroup_show_options,
 	.fsinfo			= cgroup_fsinfo,
-	.reconfigure		= cgroup_reconfigure,
 	.mkdir			= cgroup_mkdir,
 	.rmdir			= cgroup_rmdir,
 	.show_path		= cgroup_show_path,
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b02161a41d5a..b4ad1a52f006 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -327,7 +327,8 @@ static int cpuset_get_tree(struct fs_context *fc)
 	if (!cgroup_fs)
 		goto out;
 
-	cg_fc = vfs_new_fs_context(cgroup_fs, NULL, fc->sb_flags, fc->purpose);
+	cg_fc = vfs_new_fs_context(cgroup_fs, NULL, fc->sb_flags, fc->sb_flags,
+				   fc->purpose);
 	put_filesystem(cgroup_fs);
 	if (IS_ERR(cg_fc)) {
 		ret = PTR_ERR(cg_fc);
diff --git a/security/security.c b/security/security.c
index 2439a5613813..95b348484c5a 100644
--- a/security/security.c
+++ b/security/security.c
@@ -415,11 +415,6 @@ int security_sb_copy_data(char *orig, size_t data_size, char *copy)
 }
 EXPORT_SYMBOL(security_sb_copy_data);
 
-int security_sb_remount(struct super_block *sb, void *data, size_t data_size)
-{
-	return call_int_hook(sb_remount, 0, sb, data, data_size);
-}
-
 int security_sb_show_options(struct seq_file *m, struct super_block *sb)
 {
 	return call_int_hook(sb_show_options, 0, m, sb);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 3d5b09c256c1..d9cfb8b2fca4 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -7180,7 +7180,6 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(sb_alloc_security, selinux_sb_alloc_security),
 	LSM_HOOK_INIT(sb_free_security, selinux_sb_free_security),
 	LSM_HOOK_INIT(sb_copy_data, selinux_sb_copy_data),
-	LSM_HOOK_INIT(sb_remount, selinux_sb_remount),
 	LSM_HOOK_INIT(sb_show_options, selinux_sb_show_options),
 	LSM_HOOK_INIT(sb_statfs, selinux_sb_statfs),
 	LSM_HOOK_INIT(sb_mount, selinux_mount),
