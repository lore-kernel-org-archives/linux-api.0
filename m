From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [CFT][PATCH 01/10] mnt: Refactor the logic for mounting sysfs and proc in a user namespace
Date: Fri, 15 May 2015 21:06:14 -0500
Message-ID: <87mw15uvhl.fsf_-_@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
	<87siaxuvik.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87siaxuvik.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Fri, 15 May 2015 21:05:39 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?utf-8?Q?St=C3=A9phane?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Eric Windisch <ewindisch-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Fresh mounts of proc and sysfs are a very special case that works very
much like a bind mount.  Unfortunately the current structure can not
preserve the MNT_LOCK... mount flags.  Therefore refactor the logic
into a form that can be modified to preserve those lock bits.

Add a new filesystem flag FS_USERNS_VISIBLE that requires some mount
of the filesystem be fully visible in the current mount namespace,
before the filesystem may be mounted.

Move the logic for calling fs_fully_visible from proc and sysfs into
fs/namespace.c where it has greater access to mount namespace state.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/namespace.c     | 8 +++++++-
 fs/proc/root.c     | 5 +----
 fs/sysfs/mount.c   | 5 +----
 include/linux/fs.h | 2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 1b9e11167bae..8e7edaf60fe1 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2332,6 +2332,8 @@ unlock:
 	return err;
 }
 
+static bool fs_fully_visible(struct file_system_type *fs_type);
+
 /*
  * create a new mount for userspace and request it to be added into the
  * namespace's tree
@@ -2363,6 +2365,10 @@ static int do_new_mount(struct path *path, const char *fstype, int flags,
 			flags |= MS_NODEV;
 			mnt_flags |= MNT_NODEV | MNT_LOCK_NODEV;
 		}
+		if (type->fs_flags & FS_USERNS_VISIBLE) {
+			if (!fs_fully_visible(type))
+				return -EPERM;
+		}
 	}
 
 	mnt = vfs_kern_mount(type, flags, name, data);
@@ -3164,7 +3170,7 @@ bool current_chrooted(void)
 	return chrooted;
 }
 
-bool fs_fully_visible(struct file_system_type *type)
+static bool fs_fully_visible(struct file_system_type *type)
 {
 	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
 	struct mount *mnt;
diff --git a/fs/proc/root.c b/fs/proc/root.c
index b7fa4bfe896a..64e1ab64bde6 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -112,9 +112,6 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 		ns = task_active_pid_ns(current);
 		options = data;
 
-		if (!capable(CAP_SYS_ADMIN) && !fs_fully_visible(fs_type))
-			return ERR_PTR(-EPERM);
-
 		/* Does the mounter have privilege over the pid namespace? */
 		if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN))
 			return ERR_PTR(-EPERM);
@@ -159,7 +156,7 @@ static struct file_system_type proc_fs_type = {
 	.name		= "proc",
 	.mount		= proc_mount,
 	.kill_sb	= proc_kill_sb,
-	.fs_flags	= FS_USERNS_MOUNT,
+	.fs_flags	= FS_USERNS_VISIBLE | FS_USERNS_MOUNT,
 };
 
 void __init proc_root_init(void)
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 8a49486bf30c..1c6ac6fcee9f 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -31,9 +31,6 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 	bool new_sb;
 
 	if (!(flags & MS_KERNMOUNT)) {
-		if (!capable(CAP_SYS_ADMIN) && !fs_fully_visible(fs_type))
-			return ERR_PTR(-EPERM);
-
 		if (!kobj_ns_current_may_mount(KOBJ_NS_TYPE_NET))
 			return ERR_PTR(-EPERM);
 	}
@@ -58,7 +55,7 @@ static struct file_system_type sysfs_fs_type = {
 	.name		= "sysfs",
 	.mount		= sysfs_mount,
 	.kill_sb	= sysfs_kill_sb,
-	.fs_flags	= FS_USERNS_MOUNT,
+	.fs_flags	= FS_USERNS_VISIBLE | FS_USERNS_MOUNT,
 };
 
 int __init sysfs_init(void)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 35ec87e490b1..2d24eeb8e59c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1897,6 +1897,7 @@ struct file_system_type {
 #define FS_HAS_SUBTYPE		4
 #define FS_USERNS_MOUNT		8	/* Can be mounted by userns root */
 #define FS_USERNS_DEV_MOUNT	16 /* A userns mount does not imply MNT_NODEV */
+#define FS_USERNS_VISIBLE	32	/* FS must already be visible */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
@@ -1984,7 +1985,6 @@ extern int vfs_ustat(dev_t, struct kstatfs *);
 extern int freeze_super(struct super_block *super);
 extern int thaw_super(struct super_block *super);
 extern bool our_mnt(struct vfsmount *mnt);
-extern bool fs_fully_visible(struct file_system_type *);
 
 extern int current_umask(void);
 
-- 
2.2.1
