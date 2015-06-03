From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [CFT][PATCH 11/10] mnt: Avoid unnecessary regressions in
	fs_fully_visible
Date: Wed, 03 Jun 2015 16:15:10 -0500
Message-ID: <87eglseboh.fsf_-_@x220.int.ebiederm.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87k2vkebri.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org> (Eric W. Biederman's
	message of "Wed, 03 Jun 2015 16:13:21 -0500")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Not allowing programs to clear nosuid, nodev, and noexec on new mounts
of sysfs or proc will cause lxc and libvirt-lxc to fail to start (a
regression).  There are no device nodes or executables on sysfs or
proc today which means clearing these flags is harmless today.

Instead of failing the fresh mounts of sysfs and proc emit a warning
when these flags are improprely cleared.  We only reach this point
because lxc and libvirt-lxc clear flags they mount flags had not
intended to.

In a couple of kernel releases when lxc and libvirt-lxc have been
fixed we can start failing fresh mounts proc and sysfs that clear
nosuid, nodev and noexec.  Userspace clearly means to enforce those
attributes and historically they have avoided bugs.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/namespace.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index eccd925c6e82..eaa49b628d28 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3198,6 +3198,7 @@ static bool fs_fully_visible(struct file_system_type *type, int *new_mnt_flags)
 		if ((mnt->mnt.mnt_flags & MNT_LOCK_READONLY) &&
 		    !(new_flags & MNT_READONLY))
 			continue;
+#if 0		/* Avoid unnecessary regressions */
 		if ((mnt->mnt.mnt_flags & MNT_LOCK_NODEV) &&
 		    !(new_flags & MNT_NODEV))
 			continue;
@@ -3207,6 +3208,7 @@ static bool fs_fully_visible(struct file_system_type *type, int *new_mnt_flags)
 		if ((mnt->mnt.mnt_flags & MNT_LOCK_NOEXEC) &&
 		    !(new_flags & MNT_NOEXEC))
 			continue;
+#endif
 		if ((mnt->mnt.mnt_flags & MNT_LOCK_ATIME) &&
 		    ((mnt->mnt.mnt_flags & MNT_ATIME_MASK) != (new_flags & MNT_ATIME_MASK)))
 			continue;
@@ -3226,10 +3228,35 @@ static bool fs_fully_visible(struct file_system_type *type, int *new_mnt_flags)
 		}
 		/* Preserve the locked attributes */
 		*new_mnt_flags |= mnt->mnt.mnt_flags & (MNT_LOCK_READONLY | \
+						/* Avoid unnecessary regressions \
 							MNT_LOCK_NODEV    | \
 							MNT_LOCK_NOSUID   | \
 							MNT_LOCK_NOEXEC   | \
+						 */ \
 							MNT_LOCK_ATIME);
+		/* For now, warn about the "harmless" but invalid mnt flags */
+		{
+			bool nodev = false, nosuid = false, noexec = false;
+			if ((mnt->mnt.mnt_flags & MNT_LOCK_NODEV) &&
+			    !(new_flags & MNT_NODEV))
+				nodev = true;
+			if ((mnt->mnt.mnt_flags & MNT_LOCK_NOSUID) &&
+			    !(new_flags & MNT_NOSUID))
+				nosuid = true;
+			if ((mnt->mnt.mnt_flags & MNT_LOCK_NOEXEC) &&
+			    !(new_flags & MNT_NOEXEC))
+				noexec = true;
+
+			if ((nodev || nosuid || noexec) && printk_ratelimit()) {
+				printk(KERN_INFO
+				       "warning: process `%s' clears %s%s%sin mount of %s\n",
+				       current->comm,
+				       nodev ? "nodev ":"",
+				       nosuid ? "nosuid ":"",
+				       noexec ? "noexec ":"",
+				       type->name);
+			}
+		}
 		visible = true;
 		goto found;
 	next:	;
-- 
2.2.1
