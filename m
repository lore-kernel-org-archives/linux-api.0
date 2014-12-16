From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [GIT PULL] User namespace related fixes
Date: Tue, 16 Dec 2014 12:09:53 -0600
Message-ID: <87d27jpitq.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


Linus,

Please pull the for-linus branch from the git tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus

   HEAD: db86da7cb76f797a1a8b445166a15cb922c6ff85 userns: Unbreak the unprivileged remount tests


This set of changes addresses all of the bugs with user namespaces that
I am aware of except for an unfortunate interaction between unprivileged
MNT_DETACH and MNT_LOCKED which can allow you to see under mount points
if you are clever with your use of MNT_DETACH.

As these are bug fixes almost all of thes changes are marked for
backporting to stable.

The first change (implicitly adding MNT_NODEV on remount) addresses a
regression that was created when security issues with unprivileged 
remount were closed.  I go on to update the remount test to make it
easy to detect if this issue reoccurs.

Then there are a handful of mount and umount related fixes.

Then half of the changes deal with the a recently discovered design bug
in the permission checks of gid_map.  Unix since the beginning has
allowed setting group permissions on files to less than the user and
other permissions (aka ---rwx---rwx).  As the unix permission checks
stop as soon as a group matches, and setgroups allows setting groups
that can not later be dropped, results in a situtation where it is
possible to legitimately use a group to assign fewer privileges to a
process.   Which means dropping a group can increase a processes
privileges.

The fix I have adopted is that gid_map is now no longer writable
without privilege unless the new file /proc/self/setgroups has
been set to permanently disable setgroups.

The bulk of user namespace using applications even the applications
using applications using user namespaces without privilege remain
unaffected by this change.  Unfortunately this ix breaks a couple user
space applications, that were relying on the problematic behavior (one
of which was tools/selftests/mount/unprivileged-remount-test.c).

To hopefully prevent needing a regression fix on top of my security fix
I rounded folks who work with the container implementations mostly like
to be affected and encouraged them to test the changes.

> So far nothing broke on my libvirt-lxc test bed. :-)
> Tested with openSUSE 13.2 and libvirt 1.2.9.
> Tested-by: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>

> Tested on Fedora20 with libvirt 1.2.11, works fine.
> Tested-by: Chen Hanxiao <chenhanxiao-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

> Ok, thanks - yes, unprivileged lxc is working fine with your kernels.
> Just to be sure I was testing the right thing I also tested using
> my unprivileged nsexec testcases, and they failed on setgroup/setgid
> as now expected, and succeeded there without your patches.
> Tested-by: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

> I tested this with Sandstorm.  It breaks as is and it works if I add
> the setgroups thing.
> Tested-by: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> # breaks things as designed :(

Eric

Eric W. Biederman (18):
      mnt: Implicitly add MNT_NODEV on remount when it was implicitly added by mount
      mnt: Update unprivileged remount test
      umount: Disallow unprivileged mount force
      umount: Do not allow unmounting rootfs.
      mnt: Move the clear of MNT_LOCKED from copy_tree to it's callers.
      mnt: Carefully set CL_UNPRIVILEGED in clone_mnt
      mnt: Clear mnt_expire during pivot_root
      groups: Consolidate the setgroups permission checks
      userns: Document what the invariant required for safe unprivileged mappings.
      userns: Don't allow setgroups until a gid mapping has been setablished
      userns: Don't allow unprivileged creation of gid mappings
      userns: Check euid no fsuid when establishing an unprivileged uid mapping
      userns: Only allow the creator of the userns unprivileged mappings
      userns: Rename id_map_mutex to userns_state_mutex
      userns: Add a knob to disable setgroups on a per user namespace basis
      userns: Allow setting gid_maps without privilege when setgroups is disabled
      userns; Correct the comment in map_write
      userns: Unbreak the unprivileged remount tests

 arch/s390/kernel/compat_linux.c                    |   2 +-
 fs/namespace.c                                     |  18 +-
 fs/pnode.c                                         |   1 +
 fs/proc/base.c                                     |  53 ++++++
 include/linux/cred.h                               |   1 +
 include/linux/user_namespace.h                     |  12 ++
 kernel/groups.c                                    |  11 +-
 kernel/uid16.c                                     |   2 +-
 kernel/user.c                                      |   1 +
 kernel/user_namespace.c                            | 124 +++++++++++--
 .../selftests/mount/unprivileged-remount-test.c    | 204 +++++++++++++++++----
 11 files changed, 374 insertions(+), 55 deletions(-)


diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index ca38139423ae..437e61159279 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -249,7 +249,7 @@ COMPAT_SYSCALL_DEFINE2(s390_setgroups16, int, gidsetsize, u16 __user *, grouplis
 	struct group_info *group_info;
 	int retval;
 
-	if (!capable(CAP_SETGID))
+	if (!may_setgroups())
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;
diff --git a/fs/namespace.c b/fs/namespace.c
index 5b66b2b3624d..fe1c77145a78 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -963,7 +963,8 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 	}
 
 	/* Don't allow unprivileged users to reveal what is under a mount */
-	if ((flag & CL_UNPRIVILEGED) && list_empty(&old->mnt_expire))
+	if ((flag & CL_UNPRIVILEGED) &&
+	    (!(flag & CL_EXPIRE) || list_empty(&old->mnt_expire)))
 		mnt->mnt.mnt_flags |= MNT_LOCKED;
 
 	atomic_inc(&sb->s_active);
@@ -1544,6 +1545,9 @@ SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
 		goto dput_and_out;
 	if (mnt->mnt.mnt_flags & MNT_LOCKED)
 		goto dput_and_out;
+	retval = -EPERM;
+	if (flags & MNT_FORCE && !capable(CAP_SYS_ADMIN))
+		goto dput_and_out;
 
 	retval = do_umount(mnt, flags);
 dput_and_out:
@@ -1610,7 +1614,6 @@ struct mount *copy_tree(struct mount *mnt, struct dentry *dentry,
 	if (IS_ERR(q))
 		return q;
 
-	q->mnt.mnt_flags &= ~MNT_LOCKED;
 	q->mnt_mountpoint = mnt->mnt_mountpoint;
 
 	p = mnt;
@@ -2098,7 +2101,13 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 	}
 	if ((mnt->mnt.mnt_flags & MNT_LOCK_NODEV) &&
 	    !(mnt_flags & MNT_NODEV)) {
-		return -EPERM;
+		/* Was the nodev implicitly added in mount? */
+		if ((mnt->mnt_ns->user_ns != &init_user_ns) &&
+		    !(sb->s_type->fs_flags & FS_USERNS_DEV_MOUNT)) {
+			mnt_flags |= MNT_NODEV;
+		} else {
+			return -EPERM;
+		}
 	}
 	if ((mnt->mnt.mnt_flags & MNT_LOCK_NOSUID) &&
 	    !(mnt_flags & MNT_NOSUID)) {
@@ -2958,6 +2967,8 @@ SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
 	/* mount new_root on / */
 	attach_mnt(new_mnt, real_mount(root_parent.mnt), root_mp);
 	touch_mnt_namespace(current->nsproxy->mnt_ns);
+	/* A moved mount should not expire automatically */
+	list_del_init(&new_mnt->mnt_expire);
 	unlock_mount_hash();
 	chroot_fs_refs(&root, &new);
 	put_mountpoint(root_mp);
@@ -3002,6 +3013,7 @@ static void __init init_mount_tree(void)
 
 	root.mnt = mnt;
 	root.dentry = mnt->mnt_root;
+	mnt->mnt_flags |= MNT_LOCKED;
 
 	set_fs_pwd(current->fs, &root);
 	set_fs_root(current->fs, &root);
diff --git a/fs/pnode.c b/fs/pnode.c
index aae331a5d03b..260ac8f898a4 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -242,6 +242,7 @@ static int propagate_one(struct mount *m)
 	child = copy_tree(last_source, last_source->mnt.mnt_root, type);
 	if (IS_ERR(child))
 		return PTR_ERR(child);
+	child->mnt.mnt_flags &= ~MNT_LOCKED;
 	mnt_set_mountpoint(m, mp, child);
 	last_dest = m;
 	last_source = child;
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 772efa45a452..7dc3ea89ef1a 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2464,6 +2464,57 @@ static const struct file_operations proc_projid_map_operations = {
 	.llseek		= seq_lseek,
 	.release	= proc_id_map_release,
 };
+
+static int proc_setgroups_open(struct inode *inode, struct file *file)
+{
+	struct user_namespace *ns = NULL;
+	struct task_struct *task;
+	int ret;
+
+	ret = -ESRCH;
+	task = get_proc_task(inode);
+	if (task) {
+		rcu_read_lock();
+		ns = get_user_ns(task_cred_xxx(task, user_ns));
+		rcu_read_unlock();
+		put_task_struct(task);
+	}
+	if (!ns)
+		goto err;
+
+	if (file->f_mode & FMODE_WRITE) {
+		ret = -EACCES;
+		if (!ns_capable(ns, CAP_SYS_ADMIN))
+			goto err_put_ns;
+	}
+
+	ret = single_open(file, &proc_setgroups_show, ns);
+	if (ret)
+		goto err_put_ns;
+
+	return 0;
+err_put_ns:
+	put_user_ns(ns);
+err:
+	return ret;
+}
+
+static int proc_setgroups_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq = file->private_data;
+	struct user_namespace *ns = seq->private;
+	int ret = single_release(inode, file);
+	put_user_ns(ns);
+	return ret;
+}
+
+static const struct file_operations proc_setgroups_operations = {
+	.open		= proc_setgroups_open,
+	.write		= proc_setgroups_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= proc_setgroups_release,
+};
 #endif /* CONFIG_USER_NS */
 
 static int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
@@ -2572,6 +2623,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
+	REG("setgroups",  S_IRUGO|S_IWUSR, proc_setgroups_operations),
 #endif
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	REG("timers",	  S_IRUGO, proc_timers_operations),
@@ -2913,6 +2965,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
+	REG("setgroups",  S_IRUGO|S_IWUSR, proc_setgroups_operations),
 #endif
 };
 
diff --git a/include/linux/cred.h b/include/linux/cred.h
index b2d0820837c4..2fb2ca2127ed 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -68,6 +68,7 @@ extern void groups_free(struct group_info *);
 extern int set_current_groups(struct group_info *);
 extern void set_groups(struct cred *, struct group_info *);
 extern int groups_search(const struct group_info *, kgid_t);
+extern bool may_setgroups(void);
 
 /* access the groups "array" with this macro */
 #define GROUP_AT(gi, i) \
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index e95372654f09..9f3579ff543d 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -17,6 +17,10 @@ struct uid_gid_map {	/* 64 bytes -- 1 cache line */
 	} extent[UID_GID_MAP_MAX_EXTENTS];
 };
 
+#define USERNS_SETGROUPS_ALLOWED 1UL
+
+#define USERNS_INIT_FLAGS USERNS_SETGROUPS_ALLOWED
+
 struct user_namespace {
 	struct uid_gid_map	uid_map;
 	struct uid_gid_map	gid_map;
@@ -27,6 +31,7 @@ struct user_namespace {
 	kuid_t			owner;
 	kgid_t			group;
 	unsigned int		proc_inum;
+	unsigned long		flags;
 
 	/* Register of per-UID persistent keyrings for this namespace */
 #ifdef CONFIG_PERSISTENT_KEYRINGS
@@ -63,6 +68,9 @@ extern const struct seq_operations proc_projid_seq_operations;
 extern ssize_t proc_uid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_gid_map_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t proc_projid_map_write(struct file *, const char __user *, size_t, loff_t *);
+extern ssize_t proc_setgroups_write(struct file *, const char __user *, size_t, loff_t *);
+extern int proc_setgroups_show(struct seq_file *m, void *v);
+extern bool userns_may_setgroups(const struct user_namespace *ns);
 #else
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
@@ -87,6 +95,10 @@ static inline void put_user_ns(struct user_namespace *ns)
 {
 }
 
+static inline bool userns_may_setgroups(const struct user_namespace *ns)
+{
+	return true;
+}
 #endif
 
 #endif /* _LINUX_USER_H */
diff --git a/kernel/groups.c b/kernel/groups.c
index 451698f86cfa..664411f171b5 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -6,6 +6,7 @@
 #include <linux/slab.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/user_namespace.h>
 #include <asm/uaccess.h>
 
 /* init to 2 - one for init_task, one to ensure it is never freed */
@@ -213,6 +214,14 @@ out:
 	return i;
 }
 
+bool may_setgroups(void)
+{
+	struct user_namespace *user_ns = current_user_ns();
+
+	return ns_capable(user_ns, CAP_SETGID) &&
+		userns_may_setgroups(user_ns);
+}
+
 /*
  *	SMP: Our groups are copy-on-write. We can set them safely
  *	without another task interfering.
@@ -223,7 +232,7 @@ SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
 	struct group_info *group_info;
 	int retval;
 
-	if (!ns_capable(current_user_ns(), CAP_SETGID))
+	if (!may_setgroups())
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;
diff --git a/kernel/uid16.c b/kernel/uid16.c
index 602e5bbbceff..d58cc4d8f0d1 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -176,7 +176,7 @@ SYSCALL_DEFINE2(setgroups16, int, gidsetsize, old_gid_t __user *, grouplist)
 	struct group_info *group_info;
 	int retval;
 
-	if (!ns_capable(current_user_ns(), CAP_SETGID))
+	if (!may_setgroups())
 		return -EPERM;
 	if ((unsigned)gidsetsize > NGROUPS_MAX)
 		return -EINVAL;
diff --git a/kernel/user.c b/kernel/user.c
index 4efa39350e44..2d09940c9632 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -51,6 +51,7 @@ struct user_namespace init_user_ns = {
 	.owner = GLOBAL_ROOT_UID,
 	.group = GLOBAL_ROOT_GID,
 	.proc_inum = PROC_USER_INIT_INO,
+	.flags = USERNS_INIT_FLAGS,
 #ifdef CONFIG_PERSISTENT_KEYRINGS
 	.persistent_keyring_register_sem =
 	__RWSEM_INITIALIZER(init_user_ns.persistent_keyring_register_sem),
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index aa312b0dc3ec..ad419b04c146 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -24,6 +24,7 @@
 #include <linux/fs_struct.h>
 
 static struct kmem_cache *user_ns_cachep __read_mostly;
+static DEFINE_MUTEX(userns_state_mutex);
 
 static bool new_idmap_permitted(const struct file *file,
 				struct user_namespace *ns, int cap_setid,
@@ -99,6 +100,11 @@ int create_user_ns(struct cred *new)
 	ns->owner = owner;
 	ns->group = group;
 
+	/* Inherit USERNS_SETGROUPS_ALLOWED from our parent */
+	mutex_lock(&userns_state_mutex);
+	ns->flags = parent_ns->flags;
+	mutex_unlock(&userns_state_mutex);
+
 	set_cred_user_ns(new, ns);
 
 #ifdef CONFIG_PERSISTENT_KEYRINGS
@@ -583,9 +589,6 @@ static bool mappings_overlap(struct uid_gid_map *new_map,
 	return false;
 }
 
-
-static DEFINE_MUTEX(id_map_mutex);
-
 static ssize_t map_write(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos,
 			 int cap_setid,
@@ -602,7 +605,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	ssize_t ret = -EINVAL;
 
 	/*
-	 * The id_map_mutex serializes all writes to any given map.
+	 * The userns_state_mutex serializes all writes to any given map.
 	 *
 	 * Any map is only ever written once.
 	 *
@@ -620,7 +623,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	 * order and smp_rmb() is guaranteed that we don't have crazy
 	 * architectures returning stale data.
 	 */
-	mutex_lock(&id_map_mutex);
+	mutex_lock(&userns_state_mutex);
 
 	ret = -EPERM;
 	/* Only allow one successful write to the map */
@@ -640,7 +643,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	if (!page)
 		goto out;
 
-	/* Only allow <= page size writes at the beginning of the file */
+	/* Only allow < page size writes at the beginning of the file */
 	ret = -EINVAL;
 	if ((*ppos != 0) || (count >= PAGE_SIZE))
 		goto out;
@@ -750,7 +753,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	*ppos = count;
 	ret = count;
 out:
-	mutex_unlock(&id_map_mutex);
+	mutex_unlock(&userns_state_mutex);
 	if (page)
 		free_page(page);
 	return ret;
@@ -812,16 +815,21 @@ static bool new_idmap_permitted(const struct file *file,
 				struct user_namespace *ns, int cap_setid,
 				struct uid_gid_map *new_map)
 {
-	/* Allow mapping to your own filesystem ids */
-	if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1)) {
+	const struct cred *cred = file->f_cred;
+	/* Don't allow mappings that would allow anything that wouldn't
+	 * be allowed without the establishment of unprivileged mappings.
+	 */
+	if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1) &&
+	    uid_eq(ns->owner, cred->euid)) {
 		u32 id = new_map->extent[0].lower_first;
 		if (cap_setid == CAP_SETUID) {
 			kuid_t uid = make_kuid(ns->parent, id);
-			if (uid_eq(uid, file->f_cred->fsuid))
+			if (uid_eq(uid, cred->euid))
 				return true;
 		} else if (cap_setid == CAP_SETGID) {
 			kgid_t gid = make_kgid(ns->parent, id);
-			if (gid_eq(gid, file->f_cred->fsgid))
+			if (!(ns->flags & USERNS_SETGROUPS_ALLOWED) &&
+			    gid_eq(gid, cred->egid))
 				return true;
 		}
 	}
@@ -841,6 +849,100 @@ static bool new_idmap_permitted(const struct file *file,
 	return false;
 }
 
+int proc_setgroups_show(struct seq_file *seq, void *v)
+{
+	struct user_namespace *ns = seq->private;
+	unsigned long userns_flags = ACCESS_ONCE(ns->flags);
+
+	seq_printf(seq, "%s\n",
+		   (userns_flags & USERNS_SETGROUPS_ALLOWED) ?
+		   "allow" : "deny");
+	return 0;
+}
+
+ssize_t proc_setgroups_write(struct file *file, const char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	struct seq_file *seq = file->private_data;
+	struct user_namespace *ns = seq->private;
+	char kbuf[8], *pos;
+	bool setgroups_allowed;
+	ssize_t ret;
+
+	/* Only allow a very narrow range of strings to be written */
+	ret = -EINVAL;
+	if ((*ppos != 0) || (count >= sizeof(kbuf)))
+		goto out;
+
+	/* What was written? */
+	ret = -EFAULT;
+	if (copy_from_user(kbuf, buf, count))
+		goto out;
+	kbuf[count] = '\0';
+	pos = kbuf;
+
+	/* What is being requested? */
+	ret = -EINVAL;
+	if (strncmp(pos, "allow", 5) == 0) {
+		pos += 5;
+		setgroups_allowed = true;
+	}
+	else if (strncmp(pos, "deny", 4) == 0) {
+		pos += 4;
+		setgroups_allowed = false;
+	}
+	else
+		goto out;
+
+	/* Verify there is not trailing junk on the line */
+	pos = skip_spaces(pos);
+	if (*pos != '\0')
+		goto out;
+
+	ret = -EPERM;
+	mutex_lock(&userns_state_mutex);
+	if (setgroups_allowed) {
+		/* Enabling setgroups after setgroups has been disabled
+		 * is not allowed.
+		 */
+		if (!(ns->flags & USERNS_SETGROUPS_ALLOWED))
+			goto out_unlock;
+	} else {
+		/* Permanently disabling setgroups after setgroups has
+		 * been enabled by writing the gid_map is not allowed.
+		 */
+		if (ns->gid_map.nr_extents != 0)
+			goto out_unlock;
+		ns->flags &= ~USERNS_SETGROUPS_ALLOWED;
+	}
+	mutex_unlock(&userns_state_mutex);
+
+	/* Report a successful write */
+	*ppos = count;
+	ret = count;
+out:
+	return ret;
+out_unlock:
+	mutex_unlock(&userns_state_mutex);
+	goto out;
+}
+
+bool userns_may_setgroups(const struct user_namespace *ns)
+{
+	bool allowed;
+
+	mutex_lock(&userns_state_mutex);
+	/* It is not safe to use setgroups until a gid mapping in
+	 * the user namespace has been established.
+	 */
+	allowed = ns->gid_map.nr_extents != 0;
+	/* Is setgroups allowed? */
+	allowed = allowed && (ns->flags & USERNS_SETGROUPS_ALLOWED);
+	mutex_unlock(&userns_state_mutex);
+
+	return allowed;
+}
+
 static void *userns_get(struct task_struct *task)
 {
 	struct user_namespace *user_ns;
diff --git a/tools/testing/selftests/mount/unprivileged-remount-test.c b/tools/testing/selftests/mount/unprivileged-remount-test.c
index 1b3ff2fda4d0..517785052f1c 100644
--- a/tools/testing/selftests/mount/unprivileged-remount-test.c
+++ b/tools/testing/selftests/mount/unprivileged-remount-test.c
@@ -6,6 +6,8 @@
 #include <sys/types.h>
 #include <sys/mount.h>
 #include <sys/wait.h>
+#include <sys/vfs.h>
+#include <sys/statvfs.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <fcntl.h>
@@ -32,11 +34,14 @@
 # define CLONE_NEWPID 0x20000000
 #endif
 
+#ifndef MS_REC
+# define MS_REC 16384
+#endif
 #ifndef MS_RELATIME
-#define MS_RELATIME (1 << 21)
+# define MS_RELATIME (1 << 21)
 #endif
 #ifndef MS_STRICTATIME
-#define MS_STRICTATIME (1 << 24)
+# define MS_STRICTATIME (1 << 24)
 #endif
 
 static void die(char *fmt, ...)
@@ -48,17 +53,14 @@ static void die(char *fmt, ...)
 	exit(EXIT_FAILURE);
 }
 
-static void write_file(char *filename, char *fmt, ...)
+static void vmaybe_write_file(bool enoent_ok, char *filename, char *fmt, va_list ap)
 {
 	char buf[4096];
 	int fd;
 	ssize_t written;
 	int buf_len;
-	va_list ap;
 
-	va_start(ap, fmt);
 	buf_len = vsnprintf(buf, sizeof(buf), fmt, ap);
-	va_end(ap);
 	if (buf_len < 0) {
 		die("vsnprintf failed: %s\n",
 		    strerror(errno));
@@ -69,6 +71,8 @@ static void write_file(char *filename, char *fmt, ...)
 
 	fd = open(filename, O_WRONLY);
 	if (fd < 0) {
+		if ((errno == ENOENT) && enoent_ok)
+			return;
 		die("open of %s failed: %s\n",
 		    filename, strerror(errno));
 	}
@@ -87,6 +91,65 @@ static void write_file(char *filename, char *fmt, ...)
 	}
 }
 
+static void maybe_write_file(char *filename, char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	vmaybe_write_file(true, filename, fmt, ap);
+	va_end(ap);
+
+}
+
+static void write_file(char *filename, char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	vmaybe_write_file(false, filename, fmt, ap);
+	va_end(ap);
+
+}
+
+static int read_mnt_flags(const char *path)
+{
+	int ret;
+	struct statvfs stat;
+	int mnt_flags;
+
+	ret = statvfs(path, &stat);
+	if (ret != 0) {
+		die("statvfs of %s failed: %s\n",
+			path, strerror(errno));
+	}
+	if (stat.f_flag & ~(ST_RDONLY | ST_NOSUID | ST_NODEV | \
+			ST_NOEXEC | ST_NOATIME | ST_NODIRATIME | ST_RELATIME | \
+			ST_SYNCHRONOUS | ST_MANDLOCK)) {
+		die("Unrecognized mount flags\n");
+	}
+	mnt_flags = 0;
+	if (stat.f_flag & ST_RDONLY)
+		mnt_flags |= MS_RDONLY;
+	if (stat.f_flag & ST_NOSUID)
+		mnt_flags |= MS_NOSUID;
+	if (stat.f_flag & ST_NODEV)
+		mnt_flags |= MS_NODEV;
+	if (stat.f_flag & ST_NOEXEC)
+		mnt_flags |= MS_NOEXEC;
+	if (stat.f_flag & ST_NOATIME)
+		mnt_flags |= MS_NOATIME;
+	if (stat.f_flag & ST_NODIRATIME)
+		mnt_flags |= MS_NODIRATIME;
+	if (stat.f_flag & ST_RELATIME)
+		mnt_flags |= MS_RELATIME;
+	if (stat.f_flag & ST_SYNCHRONOUS)
+		mnt_flags |= MS_SYNCHRONOUS;
+	if (stat.f_flag & ST_MANDLOCK)
+		mnt_flags |= ST_MANDLOCK;
+
+	return mnt_flags;
+}
+
 static void create_and_enter_userns(void)
 {
 	uid_t uid;
@@ -100,13 +163,10 @@ static void create_and_enter_userns(void)
 			strerror(errno));
 	}
 
+	maybe_write_file("/proc/self/setgroups", "deny");
 	write_file("/proc/self/uid_map", "0 %d 1", uid);
 	write_file("/proc/self/gid_map", "0 %d 1", gid);
 
-	if (setgroups(0, NULL) != 0) {
-		die("setgroups failed: %s\n",
-			strerror(errno));
-	}
 	if (setgid(0) != 0) {
 		die ("setgid(0) failed %s\n",
 			strerror(errno));
@@ -118,7 +178,8 @@ static void create_and_enter_userns(void)
 }
 
 static
-bool test_unpriv_remount(int mount_flags, int remount_flags, int invalid_flags)
+bool test_unpriv_remount(const char *fstype, const char *mount_options,
+			 int mount_flags, int remount_flags, int invalid_flags)
 {
 	pid_t child;
 
@@ -151,9 +212,11 @@ bool test_unpriv_remount(int mount_flags, int remount_flags, int invalid_flags)
 			strerror(errno));
 	}
 
-	if (mount("testing", "/tmp", "ramfs", mount_flags, NULL) != 0) {
-		die("mount of /tmp failed: %s\n",
-			strerror(errno));
+	if (mount("testing", "/tmp", fstype, mount_flags, mount_options) != 0) {
+		die("mount of %s with options '%s' on /tmp failed: %s\n",
+		    fstype,
+		    mount_options? mount_options : "",
+		    strerror(errno));
 	}
 
 	create_and_enter_userns();
@@ -181,62 +244,127 @@ bool test_unpriv_remount(int mount_flags, int remount_flags, int invalid_flags)
 
 static bool test_unpriv_remount_simple(int mount_flags)
 {
-	return test_unpriv_remount(mount_flags, mount_flags, 0);
+	return test_unpriv_remount("ramfs", NULL, mount_flags, mount_flags, 0);
 }
 
 static bool test_unpriv_remount_atime(int mount_flags, int invalid_flags)
 {
-	return test_unpriv_remount(mount_flags, mount_flags, invalid_flags);
+	return test_unpriv_remount("ramfs", NULL, mount_flags, mount_flags,
+				   invalid_flags);
+}
+
+static bool test_priv_mount_unpriv_remount(void)
+{
+	pid_t child;
+	int ret;
+	const char *orig_path = "/dev";
+	const char *dest_path = "/tmp";
+	int orig_mnt_flags, remount_mnt_flags;
+
+	child = fork();
+	if (child == -1) {
+		die("fork failed: %s\n",
+			strerror(errno));
+	}
+	if (child != 0) { /* parent */
+		pid_t pid;
+		int status;
+		pid = waitpid(child, &status, 0);
+		if (pid == -1) {
+			die("waitpid failed: %s\n",
+				strerror(errno));
+		}
+		if (pid != child) {
+			die("waited for %d got %d\n",
+				child, pid);
+		}
+		if (!WIFEXITED(status)) {
+			die("child did not terminate cleanly\n");
+		}
+		return WEXITSTATUS(status) == EXIT_SUCCESS ? true : false;
+	}
+
+	orig_mnt_flags = read_mnt_flags(orig_path);
+
+	create_and_enter_userns();
+	ret = unshare(CLONE_NEWNS);
+	if (ret != 0) {
+		die("unshare(CLONE_NEWNS) failed: %s\n",
+			strerror(errno));
+	}
+
+	ret = mount(orig_path, dest_path, "bind", MS_BIND | MS_REC, NULL);
+	if (ret != 0) {
+		die("recursive bind mount of %s onto %s failed: %s\n",
+			orig_path, dest_path, strerror(errno));
+	}
+
+	ret = mount(dest_path, dest_path, "none",
+		    MS_REMOUNT | MS_BIND | orig_mnt_flags , NULL);
+	if (ret != 0) {
+		/* system("cat /proc/self/mounts"); */
+		die("remount of /tmp failed: %s\n",
+		    strerror(errno));
+	}
+
+	remount_mnt_flags = read_mnt_flags(dest_path);
+	if (orig_mnt_flags != remount_mnt_flags) {
+		die("Mount flags unexpectedly changed during remount of %s originally mounted on %s\n",
+			dest_path, orig_path);
+	}
+	exit(EXIT_SUCCESS);
 }
 
 int main(int argc, char **argv)
 {
-	if (!test_unpriv_remount_simple(MS_RDONLY|MS_NODEV)) {
+	if (!test_unpriv_remount_simple(MS_RDONLY)) {
 		die("MS_RDONLY malfunctions\n");
 	}
-	if (!test_unpriv_remount_simple(MS_NODEV)) {
+	if (!test_unpriv_remount("devpts", "newinstance", MS_NODEV, MS_NODEV, 0)) {
 		die("MS_NODEV malfunctions\n");
 	}
-	if (!test_unpriv_remount_simple(MS_NOSUID|MS_NODEV)) {
+	if (!test_unpriv_remount_simple(MS_NOSUID)) {
 		die("MS_NOSUID malfunctions\n");
 	}
-	if (!test_unpriv_remount_simple(MS_NOEXEC|MS_NODEV)) {
+	if (!test_unpriv_remount_simple(MS_NOEXEC)) {
 		die("MS_NOEXEC malfunctions\n");
 	}
-	if (!test_unpriv_remount_atime(MS_RELATIME|MS_NODEV,
-				       MS_NOATIME|MS_NODEV))
+	if (!test_unpriv_remount_atime(MS_RELATIME,
+				       MS_NOATIME))
 	{
 		die("MS_RELATIME malfunctions\n");
 	}
-	if (!test_unpriv_remount_atime(MS_STRICTATIME|MS_NODEV,
-				       MS_NOATIME|MS_NODEV))
+	if (!test_unpriv_remount_atime(MS_STRICTATIME,
+				       MS_NOATIME))
 	{
 		die("MS_STRICTATIME malfunctions\n");
 	}
-	if (!test_unpriv_remount_atime(MS_NOATIME|MS_NODEV,
-				       MS_STRICTATIME|MS_NODEV))
+	if (!test_unpriv_remount_atime(MS_NOATIME,
+				       MS_STRICTATIME))
 	{
-		die("MS_RELATIME malfunctions\n");
+		die("MS_NOATIME malfunctions\n");
 	}
-	if (!test_unpriv_remount_atime(MS_RELATIME|MS_NODIRATIME|MS_NODEV,
-				       MS_NOATIME|MS_NODEV))
+	if (!test_unpriv_remount_atime(MS_RELATIME|MS_NODIRATIME,
+				       MS_NOATIME))
 	{
-		die("MS_RELATIME malfunctions\n");
+		die("MS_RELATIME|MS_NODIRATIME malfunctions\n");
 	}
-	if (!test_unpriv_remount_atime(MS_STRICTATIME|MS_NODIRATIME|MS_NODEV,
-				       MS_NOATIME|MS_NODEV))
+	if (!test_unpriv_remount_atime(MS_STRICTATIME|MS_NODIRATIME,
+				       MS_NOATIME))
 	{
-		die("MS_RELATIME malfunctions\n");
+		die("MS_STRICTATIME|MS_NODIRATIME malfunctions\n");
 	}
-	if (!test_unpriv_remount_atime(MS_NOATIME|MS_NODIRATIME|MS_NODEV,
-				       MS_STRICTATIME|MS_NODEV))
+	if (!test_unpriv_remount_atime(MS_NOATIME|MS_NODIRATIME,
+				       MS_STRICTATIME))
 	{
-		die("MS_RELATIME malfunctions\n");
+		die("MS_NOATIME|MS_DIRATIME malfunctions\n");
 	}
-	if (!test_unpriv_remount(MS_STRICTATIME|MS_NODEV, MS_NODEV,
-				 MS_NOATIME|MS_NODEV))
+	if (!test_unpriv_remount("ramfs", NULL, MS_STRICTATIME, 0, MS_NOATIME))
 	{
 		die("Default atime malfunctions\n");
 	}
+	if (!test_priv_mount_unpriv_remount()) {
+		die("Mount flags unexpectedly changed after remount\n");
+	}
 	return EXIT_SUCCESS;
 }
