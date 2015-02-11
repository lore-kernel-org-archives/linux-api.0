From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC 1/6] fs: new interface and behavior for file project id
Date: Wed, 11 Feb 2015 18:11:46 +0300
Message-ID: <20150211151146.6717.62017.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Linux API <linux-api@vger.kernel.org>, containers@lists.linux-foundation.org, Dave Chinner <david@fromorbit.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>, Dmitry Monakhov <dmonakhov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Li Xi <pkuelelixi@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

For now project id and quotas are implemented only in XFS.
Existing behavior isn't very useful: any unprivileged user can set any
project id for its own files and this way he can bypass project limits.

XFS interface for getting or changing file project is a very XFS-centric:
ioctl XFS_IOC_FSGET/SETXATTR with structure (struct fsxattr) as a argument
which has three unrelated fields and twelve reserved padding bytes.
Idea of keeping XFS-compatible interface seems overpriced. Old tools checks
filesystem name/magic thus without update they anyway will work only for XFS.

This patch defines common interface and new behavior.
Depending on sysctl fs.protected_projects = 0|1 projects works as:

0 = XFS-compatible projects
  - changing project id could be performed only from init user-ns
  - file owner or task with CAP_FOWNER can set any project id
  - changing user-ns project-id mapping allowed for everybody
  - cross-project hardlinks and renaming are forbidden (-EXDEV)
  - new inodes inherits project id from directory if flag
    XFS_DIFLAG_PROJINHERIT is set for directory inode

1 = Protected projects
  - changing project id requires CAP_SYS_RESOURCE in current user-ns
  - changing project id mapping require CAP_SYS_RESOURCE in parent user-ns
  - cross-project hardlinks and renaming are permitted if current task has
    CAP_SYS_RESOURCE in current user-namespace or if directory project is
    mapped to zero in current user-namespace.
  - new inodes always inherits project id from directory

Now project id is more sticky and cross-project sharing is more flexible.
User-namespace project mapping defines set of project ids which could be
used inside, if it's empty then container cannot change project id at all.

CONFIG_PROTECTED_PROJECTS_BY_DEFAULT defines default value for sysctl.

This patch adds two new fcntls:
int fcntl(fd, F_GET_PROJECT, projid_t *);
int fcntl(fd, F_SET_PROJECT, projid_t);

Permissions:
F_GET_PROJECT is permitted for everybody but if file project isn't mapped
into current user-namespace -EACCESS will be returned.

F_SET_PROJECT: depending on state of sysctl fs.protected_projects allowed
either for file owner and CAP_FOWNER or requires capability CAP_SYS_RESOURCE.

Error codes:
EINVAL    - not implemented in this kernel
EPERM     - not permitted/supported by this filesystem type
ENOTSUPP  - not supported for this filesystem instance (no feature at sb)
EACCES    - not enough permissions or project id isn't mapped

Project id is stored in fs-specific inode and exposed via couple super-block
operations: get_projid / set_projid. This have to be sb-operations because
dquot_initialize() could be called before setting inode->i_op.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 Documentation/filesystems/Locking |    4 ++
 Documentation/filesystems/vfs.txt |   10 ++++++
 fs/fcntl.c                        |   65 +++++++++++++++++++++++++++++++++++++
 fs/quota/Kconfig                  |    9 +++++
 include/linux/fs.h                |    4 ++
 include/linux/projid.h            |    4 ++
 include/uapi/linux/fcntl.h        |    6 +++
 kernel/capability.c               |   62 +++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                   |    9 +++++
 kernel/user_namespace.c           |    4 +-
 10 files changed, 175 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index b30753c..649e404 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -125,6 +125,8 @@ prototypes:
 	int (*show_options)(struct seq_file *, struct dentry *);
 	ssize_t (*quota_read)(struct super_block *, int, char *, size_t, loff_t);
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
+	int (*get_projid) (struct inode *, kprojid_t *);
+	int (*set_projid) (struct inode *, kprojid_t);
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
 
 locking rules:
@@ -147,6 +149,8 @@ show_options:		no		(namespace_sem)
 quota_read:		no		(see below)
 quota_write:		no		(see below)
 bdev_try_to_free_page:	no		(see below)
+get_projid		no		(maybe i_mutex)
+set_projid		no		(i_mutex)
 
 ->statfs() has s_umount (shared) when called by ustat(2) (native or
 compat), but that's an accident of bad API; s_umount is used to pin
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 43ce050..c25b3ee 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -228,6 +228,10 @@ struct super_operations {
 
         ssize_t (*quota_read)(struct super_block *, int, char *, size_t, loff_t);
         ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
+
+	int (*get_projid) (struct inode *, kprojid_t *);
+	int (*set_projid) (struct inode *, kprojid_t);
+
 	int (*nr_cached_objects)(struct super_block *);
 	void (*free_cached_objects)(struct super_block *, int);
 };
@@ -319,6 +323,12 @@ or bottom half).
 	implementations will cause holdoff problems due to large scan batch
 	sizes.
 
+  get_projid: called by the VFS and quota to get project id of a inode.
+	This method is called by fcntl() and project quota management.
+
+  set_projid: called by the VFS to set project if of a inode.
+	This method is called by fcntl() with i_mutex locked.
+
 Whoever sets up the inode is responsible for filling in the "i_op" field. This
 is a pointer to a "struct inode_operations" which describes the methods that
 can be performed on individual inodes.
diff --git a/fs/fcntl.c b/fs/fcntl.c
index ee85cd4..c89df0e 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/file.h>
+#include <linux/mount.h>
 #include <linux/fdtable.h>
 #include <linux/capability.h>
 #include <linux/dnotify.h>
@@ -240,6 +241,62 @@ static int f_getowner_uids(struct file *filp, unsigned long arg)
 }
 #endif
 
+static int fcntl_get_project(struct file *file, projid_t __user *arg)
+{
+	struct inode *inode = file_inode(file);
+	struct super_block *sb = inode->i_sb;
+	kprojid_t kprojid;
+	projid_t projid;
+	int err;
+
+	if (!sb->s_op->get_projid)
+		return -EPERM;
+
+	err = sb->s_op->get_projid(inode, &kprojid);
+	if (err)
+		return err;
+
+	projid = from_kprojid(current_user_ns(), kprojid);
+	if (projid == (projid_t)-1)
+		return -EACCES;
+
+	return put_user(projid, arg);
+}
+
+static int fcntl_set_project(struct file *file, projid_t projid)
+{
+	struct user_namespace *ns = current_user_ns();
+	struct inode *inode = file_inode(file);
+	struct super_block *sb = inode->i_sb;
+	kprojid_t old_kprojid, kprojid;
+	int err;
+
+	if (!sb->s_op->get_projid || !sb->s_op->set_projid)
+		return -EPERM;
+
+	kprojid = make_kprojid(ns, projid);
+	if (!projid_valid(kprojid))
+		return -EACCES;
+
+	err = mnt_want_write_file(file);
+	if (err)
+		return err;
+
+	mutex_lock(&inode->i_mutex);
+	err = sb->s_op->get_projid(inode, &old_kprojid);
+	if (!err) {
+		if (capable_set_inode_project(inode, old_kprojid, kprojid))
+			err = sb->s_op->set_projid(inode, kprojid);
+		else
+			err = -EACCES;
+	}
+	mutex_unlock(&inode->i_mutex);
+
+	mnt_drop_write_file(file);
+
+	return err;
+}
+
 static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		struct file *filp)
 {
@@ -334,6 +391,12 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 	case F_GET_SEALS:
 		err = shmem_fcntl(filp, cmd, arg);
 		break;
+	case F_GET_PROJECT:
+		err = fcntl_get_project(filp, (projid_t __user *) arg);
+		break;
+	case F_SET_PROJECT:
+		err = fcntl_set_project(filp, (projid_t) arg);
+		break;
 	default:
 		break;
 	}
@@ -348,6 +411,8 @@ static int check_fcntl_cmd(unsigned cmd)
 	case F_GETFD:
 	case F_SETFD:
 	case F_GETFL:
+	case F_GET_PROJECT:
+	case F_SET_PROJECT:
 		return 1;
 	}
 	return 0;
diff --git a/fs/quota/Kconfig b/fs/quota/Kconfig
index 4a09975..b38f881 100644
--- a/fs/quota/Kconfig
+++ b/fs/quota/Kconfig
@@ -74,3 +74,12 @@ config QUOTACTL_COMPAT
 	bool
 	depends on QUOTACTL && COMPAT_FOR_U64_ALIGNMENT
 	default y
+
+config PROTECTED_PROJECTS_ENABLED_BY_DEFAULT
+	bool "Protected projects by default"
+	default n
+	help
+	  This option defines default value for sysctl fs.protected_projects.
+	  Say N if you need XFS-compatible mode when file owner could set any
+	  project id. If you need reliable project disk quotas say Y here:
+	  in this mode changing project requires capability CAP_SYS_RESOURCE.
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f125b88..f6faf22 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -27,6 +27,7 @@
 #include <linux/shrinker.h>
 #include <linux/migrate_mode.h>
 #include <linux/uidgid.h>
+#include <linux/projid.h>
 #include <linux/lockdep.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/blk_types.h>
@@ -62,6 +63,7 @@ extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
 extern int sysctl_protected_symlinks;
 extern int sysctl_protected_hardlinks;
+extern int sysctl_protected_projects;
 
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
@@ -1636,6 +1638,8 @@ struct super_operations {
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
 	long (*nr_cached_objects)(struct super_block *, int);
 	long (*free_cached_objects)(struct super_block *, long, int);
+	int (*get_projid)(struct inode *, kprojid_t *);
+	int (*set_projid)(struct inode *, kprojid_t);
 };
 
 /*
diff --git a/include/linux/projid.h b/include/linux/projid.h
index 8c1f2c5..410b509 100644
--- a/include/linux/projid.h
+++ b/include/linux/projid.h
@@ -86,4 +86,8 @@ static inline bool kprojid_has_mapping(struct user_namespace *ns, kprojid_t proj
 
 #endif /* CONFIG_USER_NS */
 
+bool capable_set_inode_project(const struct inode *inode,
+		kprojid_t old_kprojid, kprojid_t kprojid);
+bool capable_mix_inode_project(kprojid_t dir_kprojid, kprojid_t kprojid);
+
 #endif /* _LINUX_PROJID_H */
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index beed138..92791d0 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -34,6 +34,12 @@
 #define F_GET_SEALS	(F_LINUX_SPECIFIC_BASE + 10)
 
 /*
+ * Get/Set project id
+ */
+#define F_GET_PROJECT	(F_LINUX_SPECIFIC_BASE + 11)
+#define F_SET_PROJECT	(F_LINUX_SPECIFIC_BASE + 12)
+
+/*
  * Types of seals
  */
 #define F_SEAL_SEAL	0x0001	/* prevent further seals from being set */
diff --git a/kernel/capability.c b/kernel/capability.c
index 989f5bf..cd67ef4 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -444,3 +444,65 @@ bool capable_wrt_inode_uidgid(const struct inode *inode, int cap)
 		kgid_has_mapping(ns, inode->i_gid);
 }
 EXPORT_SYMBOL(capable_wrt_inode_uidgid);
+
+int sysctl_protected_projects =
+		IS_ENABLED(CONFIG_PROTECTED_PROJECTS_ENABLED_BY_DEFAULT);
+
+/**
+ * capable_set_inode_project - Check restrictions for changing project id
+ * @inode:		The inode in question
+ * @old_kprojid:	current project id
+ * @kprojid:		target project id
+ *
+ * Returns true if current task can set new project id for inode:
+ * In XFS-compatible mode (sysctl fs.protected_projects = 0) this is permitted
+ * only in init user namespace if current user owns file or task has CAP_FOWNER.
+ * If sysctl fs.protected_projects = 1 then tasks must have CAP_SYS_RESOURCE in
+ * current user-namespace and both projects must be mapped into this namespace.
+ */
+bool capable_set_inode_project(const struct inode *inode,
+			kprojid_t old_kprojid, kprojid_t kprojid)
+{
+	struct user_namespace *ns = current_user_ns();
+
+	/* In XFS-compat mode file owner can set any project id */
+	if (!sysctl_protected_projects)
+		return ns == &init_user_ns && inode_owner_or_capable(inode);
+
+	return ns_capable(ns, CAP_SYS_RESOURCE) &&
+		kprojid_has_mapping(ns, old_kprojid) &&
+		kprojid_has_mapping(ns, kprojid);
+}
+EXPORT_SYMBOL(capable_set_inode_project);
+
+/**
+ * capable_mix_inode_project - Check project id restrictions for link/rename
+ * @kprojid:     inode project id
+ * @dir_kprojid: directory project id
+ *
+ * Returns true if current task can link/rename inode into given directory:
+ * In XFS-compatible mode operation is permitted only if projects are match.
+ * If fs.protected_projects is set then it's permitted also if directory
+ * project is mapped to zero or if task has capability CAP_SYS_RESOURCE.
+ */
+bool capable_mix_inode_project(kprojid_t dir_kprojid, kprojid_t kprojid)
+{
+	struct user_namespace *ns;
+	projid_t dir_projid;
+
+	if (projid_eq(dir_kprojid, kprojid))
+		return true;
+
+	if (!sysctl_protected_projects)
+		return false;
+
+	ns = current_user_ns();
+	if (!kprojid_has_mapping(ns, kprojid))
+		return false;
+
+	dir_projid = from_kprojid(ns, dir_kprojid);
+	return dir_projid == (projid_t)0 ||
+		(dir_projid != (projid_t)-1 &&
+		 ns_capable(ns, CAP_SYS_RESOURCE));
+}
+EXPORT_SYMBOL(capable_mix_inode_project);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 88ea2d6..cb6f9fb 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1649,6 +1649,15 @@ static struct ctl_table fs_table[] = {
 		.extra2		= &one,
 	},
 	{
+		.procname	= "protected_projects",
+		.data		= &sysctl_protected_projects,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+	{
 		.procname	= "suid_dumpable",
 		.data		= &suid_dumpable,
 		.maxlen		= sizeof(int),
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 4109f83..88f6619 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -807,8 +807,8 @@ ssize_t proc_projid_map_write(struct file *file, const char __user *buf,
 	if ((seq_ns != ns) && (seq_ns != ns->parent))
 		return -EPERM;
 
-	/* Anyone can set any valid project id no capability needed */
-	return map_write(file, buf, size, ppos, -1,
+	return map_write(file, buf, size, ppos,
+			 sysctl_protected_projects ? CAP_SYS_RESOURCE : -1,
 			 &ns->projid_map, &ns->parent->projid_map);
 }
 
