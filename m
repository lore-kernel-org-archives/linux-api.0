From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [CFT][PATCH 11/10] mnt: Avoid unnecessary regressions in fs_fully_visible (take 2)
Date: Wed, 03 Jun 2015 23:35:30 -0500
Message-ID: <874mmodral.fsf_-_@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
	<87siaxuvik.fsf@x220.int.ebiederm.org>
	<87wq004im1.fsf@x220.int.ebiederm.org>
	<CALCETrUhXBR5WQ6gXr9KzGc4=7tph7kzopY29Hug4g+FhOzEKg@mail.gmail.com>
	<20150528140839.GD28842@ubuntumail>
	<87lhg8pwvz.fsf@x220.int.ebiederm.org>
	<CALCETrXXax28s9kMTQ-zDx0MttQWG4rg2y-oz3bSGiumSL=3sg@mail.gmail.com>
	<CAOP=4wid+N_80iyPpiVMN96_fuHZZRGtYQ6AOPn-HFBj2H6Vgg@mail.gmail.com>
	<87fv6gikfn.fsf@x220.int.ebiederm.org>
	<CALCETrXO21Y7PR=pKqaqJb1YZArNyjAv7Z-J44O53FcfLM_0Tw@mail.gmail.com>
	<87fv6g80g7.fsf@x220.int.ebiederm.org>
	<CALCETrVEA0Ug+3aj5rjupqZub-1tPLw+szzbs4kTyEyVvNs7qg@mail.gmail.com>
	<87k2vkebri.fsf@x220.int.ebiederm.org>
	<87eglseboh.fsf_-_@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87eglseboh.fsf_-_-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Wed, 03 Jun 2015 16:15:10 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Not allowing programs to clear nosuid and noexec on new mounts of
sysfs or proc will cause lxc and libvirt-lxc to fail to start (a
regression).  There are no executables files on sysfs or proc today
which means clearing these flags is harmless today.

Instead of failing the fresh mounts of sysfs and proc emit a warning
when these flags are improprely cleared.  We only reach this point
because lxc and libvirt-lxc clear flags they mount flags had not
intended to.

In a couple of kernel releases when lxc and libvirt-lxc have been
fixed we can start failing fresh mounts proc and sysfs that clear
nosuid and noexec.  Userspace clearly means to enforce those
attributes and enforcing these attributes have historically avoided
bugs in the setattr implementations of proc and sysfs.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---

Now with warning on problematic remounts as well.
nodev is also ignored because it is not currently problematic.

 fs/namespace.c        | 33 +++++++++++++++++++++++++++++++++
 include/linux/mount.h |  5 +++++
 2 files changed, 38 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index eccd925c6e82..3c3f8172c734 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2162,6 +2162,18 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 	    ((mnt->mnt.mnt_flags & MNT_ATIME_MASK) != (mnt_flags & MNT_ATIME_MASK))) {
 		return -EPERM;
 	}
+	if ((mnt->mnt.mnt_flags & MNT_WARN_NOSUID) &&
+	    !(mnt_flags & MNT_NOSUID) && printk_ratelimit()) {
+		printk(KERN_INFO
+		       "warning: process `%s' clears nosuid in remount of %s\n",
+		       current->comm, sb->s_type->name);
+	}
+	if ((mnt->mnt.mnt_flags & MNT_WARN_NOEXEC) &&
+	    !(mnt_flags & MNT_NOEXEC) && printk_ratelimit()) {
+		printk(KERN_INFO
+		       "warning: process `%s' clears noexec in remount of %s\n",
+		       current->comm, sb->s_type->name);
+	}
 
 	err = security_sb_remount(sb, data);
 	if (err)
@@ -3201,12 +3213,14 @@ static bool fs_fully_visible(struct file_system_type *type, int *new_mnt_flags)
 		if ((mnt->mnt.mnt_flags & MNT_LOCK_NODEV) &&
 		    !(new_flags & MNT_NODEV))
 			continue;
+#if 0		/* Avoid unnecessary regressions */
 		if ((mnt->mnt.mnt_flags & MNT_LOCK_NOSUID) &&
 		    !(new_flags & MNT_NOSUID))
 			continue;
 		if ((mnt->mnt.mnt_flags & MNT_LOCK_NOEXEC) &&
 		    !(new_flags & MNT_NOEXEC))
 			continue;
+#endif
 		if ((mnt->mnt.mnt_flags & MNT_LOCK_ATIME) &&
 		    ((mnt->mnt.mnt_flags & MNT_ATIME_MASK) != (new_flags & MNT_ATIME_MASK)))
 			continue;
@@ -3227,9 +3241,28 @@ static bool fs_fully_visible(struct file_system_type *type, int *new_mnt_flags)
 		/* Preserve the locked attributes */
 		*new_mnt_flags |= mnt->mnt.mnt_flags & (MNT_LOCK_READONLY | \
 							MNT_LOCK_NODEV    | \
+						/* Avoid unnecessary regressions \
 							MNT_LOCK_NOSUID   | \
 							MNT_LOCK_NOEXEC   | \
+						 */ \
 							MNT_LOCK_ATIME);
+		/* For now, warn about the "harmless" but invalid mnt flags */
+		if (mnt->mnt.mnt_flags & MNT_LOCK_NOSUID) {
+			*new_mnt_flags |= MNT_WARN_NOSUID;
+			if (!(new_flags & MNT_NOSUID) && printk_ratelimit()) {
+				printk(KERN_INFO
+				       "warning: process `%s' clears nosuid in mount of %s\n",
+				       current->comm, type->name);
+			}
+		}
+		if (mnt->mnt.mnt_flags & MNT_LOCK_NOEXEC) {
+			*new_mnt_flags |= MNT_WARN_NOEXEC;
+			if (!(new_flags & MNT_NOEXEC) && printk_ratelimit()) {
+				printk(KERN_INFO
+				       "warning: process `%s' clears noexec in mount of %s\n",
+				       current->comm, type->name);
+			}
+		}
 		visible = true;
 		goto found;
 	next:	;
diff --git a/include/linux/mount.h b/include/linux/mount.h
index f822c3c11377..a9ac188413fd 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -52,6 +52,11 @@ struct mnt_namespace;
 
 #define MNT_INTERNAL	0x4000
 
+/* These warning options should be removed in a few kernel releases
+ * once userspace has been fixed.
+ */
+#define MNT_WARN_NOSUID		0x010000
+#define MNT_WARN_NOEXEC		0x020000
 #define MNT_LOCK_ATIME		0x040000
 #define MNT_LOCK_NOEXEC		0x080000
 #define MNT_LOCK_NOSUID		0x100000
-- 
2.2.1
