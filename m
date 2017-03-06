From: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC] Add option to mount only a pids subset
Date: Tue, 7 Mar 2017 00:05:16 +0100
Message-ID: <20170306230515.GA3453@comp-core-i7-2640m-0182e6>
References: <20170221145746.GA31914@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170221145746.GA31914-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Vasiliy Kulikov <segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-Id: linux-api@vger.kernel.org


After discussion with Oleg Nesterov I reimplement my patch as an additional
option for /proc. This option affects the mountpoint. It means that in one
pid namespace it possible to have both the whole traditional /proc and
/proc with only pids subset.

However, it remains an open question about overlayfs support in the /proc.

== Overview ==

Some of the container virtualization systems are mounted /proc inside
the container. This is done in most cases to operate with information
about the processes. Knowing that /proc filesystem is not fully
virtualized they are mounted on top of dangerous places empty files or
directories (for exmaple /proc/sys, /proc/kcore, /sys/firmware, etc.).

The structure of this filesystem is dynamic and any module can create a
new object which will not necessarily be virtualized. There are
proprietary modules that aren't in the mainline whose work we can not
verify.

This opens up a potential threat to the system. The developers of the
virtualization system can't predict all dangerous places in /proc by
definition.

A more effective solution would be to mount into the container only what
is necessary and ignore the rest.

Right now there is the opportunity to pass in the container any port of
the /proc filesystem using mount --bind expect the pids.

This patch allows to mount only the part of /proc related to pids
without rest objects. Since this is an option for /proc, flags applied to
/proc have an effect on this subset of filesystem.

Originally the idea was that the container will be mounted only pid sunset
and additional required files will be mounted on top using the overlayfs.
But I found out that /proc does not support overlayfs and does not allow
to mount anything on top or under it.

== TODO ==

There is still work to do:

 * Show pidonly via proc_show_options.
 * Add overlayfs support.

---
 fs/internal.h         |  1 +
 fs/namespace.c        |  9 ++++++++
 fs/proc/generic.c     |  4 ++++
 fs/proc/inode.c       |  7 +++++-
 fs/proc/internal.h    |  8 +++++++
 fs/proc/root.c        | 62 +++++++++++++++++++++++++++++++++++++++++++++++----
 fs/stat.c             |  4 ++++
 fs/super.c            | 20 +++++++++++++++++
 include/linux/fs.h    |  2 ++
 include/linux/mount.h |  1 +
 10 files changed, 113 insertions(+), 5 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 4fcf517..cb44ca7 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -88,6 +88,7 @@ extern struct file *get_empty_filp(void);
  * super.c
  */
 extern int do_remount_sb(struct super_block *, int, void *, int);
+extern int do_mount_sb(struct vfsmount *mnt, int flags, void *data);
 extern bool trylock_super(struct super_block *sb);
 extern struct dentry *mount_fs(struct file_system_type *,
 			       int, const char *, void *);
diff --git a/fs/namespace.c b/fs/namespace.c
index e6c234b..6cb2bcb 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -938,6 +938,7 @@ static struct mount *skip_mnt_tree(struct mount *p)
 struct vfsmount *
 vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void *data)
 {
+	int err;
 	struct mount *mnt;
 	struct dentry *root;
 
@@ -962,6 +963,14 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
 	mnt->mnt.mnt_sb = root->d_sb;
 	mnt->mnt_mountpoint = mnt->mnt.mnt_root;
 	mnt->mnt_parent = mnt;
+
+	err = do_mount_sb(&mnt->mnt, flags, data);
+	if(err) {
+		mnt_free_id(mnt);
+		free_vfsmnt(mnt);
+		return ERR_PTR(err);
+	}
+
 	lock_mount_hash();
 	list_add_tail(&mnt->mnt_instance, &root->d_sb->s_mounts);
 	unlock_mount_hash();
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 7eb3cef..dd3da60 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -306,6 +306,10 @@ int proc_readdir_de(struct proc_dir_entry *de, struct file *file,
 int proc_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct inode *inode = file_inode(file);
+	struct proc_options *opts = file->f_path.mnt->fs_data;
+
+	if (opts && opts->pid_only)
+		return 1;
 
 	return proc_readdir_de(PDE(inode), file, ctx);
 }
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 783bc19..51b1712 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -108,7 +108,6 @@ static int proc_show_options(struct seq_file *seq, struct dentry *root)
 		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, pid->pid_gid));
 	if (pid->hide_pid != 0)
 		seq_printf(seq, ",hidepid=%u", pid->hide_pid);
-
 	return 0;
 }
 
@@ -118,6 +117,8 @@ static const struct super_operations proc_sops = {
 	.drop_inode	= generic_delete_inode,
 	.evict_inode	= proc_evict_inode,
 	.statfs		= simple_statfs,
+	.getattr_fs	= proc_getattrfs,
+	.mount_fs	= proc_mount_cb,
 	.remount_fs	= proc_remount,
 	.show_options	= proc_show_options,
 };
@@ -323,6 +324,10 @@ static int proc_reg_open(struct inode *inode, struct file *file)
 	int (*open)(struct inode *, struct file *);
 	int (*release)(struct inode *, struct file *);
 	struct pde_opener *pdeo;
+	struct proc_options *opts = file->f_path.mnt->fs_data;
+
+	if (opts && opts->pid_only)
+		return -ENOENT;
 
 	/*
 	 * Ensure that
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 2de5194..7fdbfee 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -267,11 +267,19 @@ static inline void proc_tty_init(void) {}
 /*
  * root.c
  */
+struct proc_options {
+	kgid_t pid_gid;
+	int hide_pid;
+	int pid_only;
+};
+
 extern struct proc_dir_entry proc_root;
 extern int proc_parse_options(char *options, struct pid_namespace *pid);
 
 extern void proc_self_init(void);
 extern int proc_remount(struct super_block *, int *, char *);
+extern int proc_mount_cb(struct vfsmount *mnt, int *flags, char *data);
+extern int proc_getattrfs(struct vfsmount *, struct dentry *, struct kstat *);
 
 /*
  * task_[no]mmu.c
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 4bd0373..e07f37a 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -14,6 +14,7 @@
 #include <linux/stat.h>
 #include <linux/init.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
 #include <linux/user_namespace.h>
@@ -24,16 +25,17 @@
 #include "internal.h"
 
 enum {
-	Opt_gid, Opt_hidepid, Opt_err,
+	Opt_gid, Opt_hidepid, Opt_pidonly, Opt_err,
 };
 
 static const match_table_t tokens = {
 	{Opt_hidepid, "hidepid=%u"},
 	{Opt_gid, "gid=%u"},
+	{Opt_pidonly, "pidonly"},
 	{Opt_err, NULL},
 };
 
-int proc_parse_options(char *options, struct pid_namespace *pid)
+static int proc_fill_options(char *options, struct proc_options *fs_opts)
 {
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
@@ -53,7 +55,7 @@ int proc_parse_options(char *options, struct pid_namespace *pid)
 		case Opt_gid:
 			if (match_int(&args[0], &option))
 				return 0;
-			pid->pid_gid = make_kgid(current_user_ns(), option);
+			fs_opts->pid_gid = make_kgid(current_user_ns(), option);
 			break;
 		case Opt_hidepid:
 			if (match_int(&args[0], &option))
@@ -62,7 +64,10 @@ int proc_parse_options(char *options, struct pid_namespace *pid)
 				pr_err("proc: hidepid value must be between 0 and 2.\n");
 				return 0;
 			}
-			pid->hide_pid = option;
+			fs_opts->hide_pid = option;
+			break;
+		case Opt_pidonly:
+			fs_opts->pid_only = 1;
 			break;
 		default:
 			pr_err("proc: unrecognized mount option \"%s\" "
@@ -74,6 +79,19 @@ int proc_parse_options(char *options, struct pid_namespace *pid)
 	return 1;
 }
 
+int proc_parse_options(char *options, struct pid_namespace *pid)
+{
+	struct proc_options opts;
+
+	if (!proc_fill_options(options, &opts))
+		return 0;
+
+	pid->pid_gid = opts.pid_gid;
+	pid->hide_pid = opts.hide_pid;
+
+	return 1;
+}
+
 int proc_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct pid_namespace *pid = sb->s_fs_info;
@@ -82,6 +100,42 @@ int proc_remount(struct super_block *sb, int *flags, char *data)
 	return !proc_parse_options(data, pid);
 }
 
+int proc_getattrfs(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+{
+	struct inode *inode = d_inode(dentry);
+	struct pid *pid = proc_pid(dentry->d_inode);
+	struct proc_options *opts = mnt->fs_data;
+
+	if (opts && opts->pid_only && mnt->mnt_root != dentry && !pid)
+		return -ENOENT;
+
+	if (!inode->i_op->getattr) {
+		generic_fillattr(inode, stat);
+		return 0;
+	}
+
+	return inode->i_op->getattr(mnt, dentry, stat);
+}
+
+int proc_mount_cb(struct vfsmount *mnt, int *flags, char *data)
+{
+	struct proc_options *opts;
+
+	if (!data || *flags & MS_KERNMOUNT)
+		return 0;
+
+	opts = kzalloc(sizeof(struct proc_options), GFP_KERNEL);
+	if (!opts)
+		return -ENOMEM;
+
+	if (!proc_fill_options(data, opts))
+		return -EINVAL;
+
+	mnt->fs_data = opts;
+
+	return 0;
+}
+
 static struct dentry *proc_mount(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
diff --git a/fs/stat.c b/fs/stat.c
index bc045c7..1e26308 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -10,6 +10,7 @@
 #include <linux/file.h>
 #include <linux/highuid.h>
 #include <linux/fs.h>
+#include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
@@ -53,6 +54,9 @@ int vfs_getattr_nosec(struct path *path, struct kstat *stat)
 {
 	struct inode *inode = d_backing_inode(path->dentry);
 
+	if (path->mnt->mnt_sb->s_op->getattr_fs)
+		return path->mnt->mnt_sb->s_op->getattr_fs(path->mnt, path->dentry, stat);
+
 	if (inode->i_op->getattr)
 		return inode->i_op->getattr(path->mnt, path->dentry, stat);
 
diff --git a/fs/super.c b/fs/super.c
index c183835..478dd5b 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -832,6 +832,26 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 	return retval;
 }
 
+/**
+ *	do_mount_sb - asks filesystem to finish mount with options.
+ *	@mnt:	vfsmount in question
+ *	@flags:	numeric part of options
+ *	@data:	the rest of options
+ *
+ *	Alters the mount options of a mounted filesystem.
+ */
+int do_mount_sb(struct vfsmount *mnt, int flags, void *data)
+{
+	if (mnt->mnt_sb->s_writers.frozen != SB_UNFROZEN)
+		return -EBUSY;
+
+	if (mnt->mnt_sb->s_op->mount_fs) {
+		return mnt->mnt_sb->s_op->mount_fs(mnt, &flags, data);
+	}
+
+	return 0;
+}
+
 static void do_emergency_remount(struct work_struct *work)
 {
 	struct super_block *sb, *p = NULL;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 83de8b6..5bd1b84 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1759,6 +1759,8 @@ struct super_operations {
 	int (*thaw_super) (struct super_block *);
 	int (*unfreeze_fs) (struct super_block *);
 	int (*statfs) (struct dentry *, struct kstatfs *);
+	int (*getattr_fs) (struct vfsmount *, struct dentry *, struct kstat *);
+	int (*mount_fs) (struct vfsmount *, int *, char *);
 	int (*remount_fs) (struct super_block *, int *, char *);
 	void (*umount_begin) (struct super_block *);
 
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 1172cce..4bd364e 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -67,6 +67,7 @@ struct vfsmount {
 	struct dentry *mnt_root;	/* root of the mounted tree */
 	struct super_block *mnt_sb;	/* pointer to superblock */
 	int mnt_flags;
+	void *fs_data;			/* fs-specific data */
 };
 
 struct file; /* forward dec */
-- 
2.10.2
