From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [GIT PULL] User namespace related fixes for v4.2
Date: Mon, 29 Jun 2015 16:13:52 -0500
Message-ID: <87pp4eqktr.fsf@x220.int.ebiederm.org>
References: <87381eyz26.fsf@x220.int.ebiederm.org>
	<CA+55aFysKDXr2HEwNzm3z9QOw=E4ZeWcvYQ-xLhy5_k+rGbeRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CA+55aFysKDXr2HEwNzm3z9QOw=E4ZeWcvYQ-xLhy5_k+rGbeRg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Linus Torvalds's message of "Mon, 29 Jun 2015 09:43:09 -0700")
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
Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ivan Delalande <colona-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> writes:

> On Fri, Jun 26, 2015 at 1:50 PM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>
>> Therefore this changeset marks for backporting the attribute enforcement
>> that do not cause regressions in the existing userspace. Implements
>> enforcement of nosuid and noexec.  Then disables that enforcement of
>> nosuid and nosexec and replaces that enforcment with a big fat warning.
>> Userspace should be fixed before 4.2 ships so I do not expect these
>> warnings to fire.
>
> Eric, that is *not* how this works.
>
> If people have old user-space binaries, we do not require them to be
> updated. So it doesn't matter one whit if "Userspace should be fixed
> before 4.2 ships", because it is entirely irrelevant if the upstream
> project stops doing something, when users want to be able to upgrade
> their kernels regardless of whether they've upgraded their system
> apps.
>
> I'm going to hold off on pulling this, because I feel you don't
> understand the regression rules.

That is not the issue.  What happen is I found myself between a rock and
a hard place and I did not possess sufficient creativity to code my way
out.

Fearing regressions I sought out people to test these changes, on the
applications most likely to care.

I reduced the change from breaking userspace to a warning that userspace
is being ludicriously stupid.

I worked with the applications to get their bugs fixed.

> I suggest we instead just always set nosuid and noexec for /proc and
> /sys mounts, and make this whole thing a complete non-issue.

Doing exactly as you suggest will be user visible (mount flags), and
without care is likely to break remount.

Can you live with the patch below and committing to never supporting
executables on proc and sysfs?

With that I can solve all of my concerns, without affecting the existing
userspace programs.

> Instead of this crazy "let's warn about it and plan on breaking old
> existing setups". That's _wrong_. It's so fundamentally wrong that I
> will not pull from people who do not understand this.
>
> The reason we have that "no regression" rule is not so that we fix up
> bugs. It's because peopel should always feel safe upgrading their
> kernel, and basically _know_ that kernel developers consider it
> unacceptable to break user space. It should be a warm fuzzy feeling -
> the feeling that we try our best, and if we ever fail because we
> missed something or really believed that it can't ever matter, we'll
> jump on it and we won't be making any excuses for our bugs. Because
> breaking user space is a bug.
>
> Kernel developers who don't understand "it is unacceptable to break
> user space" shouldn't be kernel developers.

It is not that I do not understand it is that I had a failure of
imagination.  I have been agonizing about this issue since I have
encountered it trying to think of a better way.

Because of another failure of my imagination enabling user namespaces
has introduced a number of security regressions into the kernel, because
primarily I overlooked the effects of fine grained sharing in the mount
namespace and I have been working carefully and dilligent to get those
security regressions fixed.  Because if the user namespace by it's
designed semantics opens up security holes it is a failure.  Crap
happens and we occassionally over look things with the a greater amount
of code exposed to unprivileged users, but that is no excuse for doing
everything in my power to make user namespaces as safe to use as linux
without user namespaces.

Almost the entirety of my pull request is addressing that unfortunate
regression in security.

Until your comments suggested to me that it was acceptable to
permanently bar exectuables from proc and sysfs I did not see a way to
address this security hole (that does not currently appear exploitable),
but has been exploitable in the past, without breaking something.

Breaking two exectuables that will be unsafe to use at some point if I
did not get this fixed seemed the least damage I could do.

Hopefully you can live with permanently (and programatically) barring
exectuables from proc and sysfs and I can then move forward without 
reworking things so I can fix this without breaking anything.

Eric

------------------- cut here --------------------

From: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Date: Mon, 29 Jun 2015 14:42:03 -0500
Subject: [PATCH] vfs: Commit to never having exectuables on proc and sysfs.

Add a new flag to file_system_type for filesystems that are never
exepected to support executables.  Test that flag where MNT_NOEXEC is
tested today, so that user visible changes to mount flags are not
necessary.  The only user visible effect will be that exectuables
will be treated as if the execute bit is cleared, as happens today
when the MNT_NOEXEC flag is set on a mount.

Set the new flag on proc and sysfs.  As proc and sysfs do not implement
executables today there are no differences for userspace to notice.

The point of this exercise is that there are some applications that
due to oversites of their programmers do not set nosid and noexec when
they mount fresh copies of proc and sysfs today, and would become instant
security holes if we implemented exectubles especially suid executables
on proc and sysfs today.

With this change it becomes less necessary to vet each change to
proc and sysfs very carefully to ensure that executable files are
not implemented and to ensure that chattr can not create executable
files on proc and sysfs.

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 fs/exec.c           | 10 ++++++++--
 fs/open.c           |  2 +-
 fs/proc/root.c      |  2 +-
 fs/sysfs/mount.c    |  2 +-
 include/linux/fs.h  |  3 +++
 kernel/sys.c        |  3 +--
 mm/mmap.c           |  4 ++--
 mm/nommu.c          |  2 +-
 security/security.c |  2 +-
 9 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 1977c2a553ac..1e063854571b 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -98,6 +98,12 @@ static inline void put_binfmt(struct linux_binfmt * fmt)
 	module_put(fmt->module);
 }
 
+bool path_noexec(const struct path *path)
+{
+	return (path->mnt->mnt_flags & MNT_NOEXEC) ||
+	       (path->mnt->mnt_sb->s_type->fs_flags & FS_NOEXEC);
+}
+
 #ifdef CONFIG_USELIB
 /*
  * Note that a shared library must be both readable and executable due to
@@ -132,7 +138,7 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
 		goto exit;
 
 	error = -EACCES;
-	if (file->f_path.mnt->mnt_flags & MNT_NOEXEC)
+	if (path_noexec(&file->f_path))
 		goto exit;
 
 	fsnotify_open(file);
@@ -777,7 +783,7 @@ static struct file *do_open_execat(int fd, struct filename *name, int flags)
 	if (!S_ISREG(file_inode(file)->i_mode))
 		goto exit;
 
-	if (file->f_path.mnt->mnt_flags & MNT_NOEXEC)
+	if (path_noexec(&file->f_path))
 		goto exit;
 
 	err = deny_write_access(file);
diff --git a/fs/open.c b/fs/open.c
index e0250bdcc440..9fbdb1bae049 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -375,7 +375,7 @@ retry:
 		 * with the "noexec" flag.
 		 */
 		res = -EACCES;
-		if (path.mnt->mnt_flags & MNT_NOEXEC)
+		if (path_noexec(&path))
 			goto out_path_release;
 	}
 
diff --git a/fs/proc/root.c b/fs/proc/root.c
index b7fa4bfe896a..7e39312580d4 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -159,7 +159,7 @@ static struct file_system_type proc_fs_type = {
 	.name		= "proc",
 	.mount		= proc_mount,
 	.kill_sb	= proc_kill_sb,
-	.fs_flags	= FS_USERNS_MOUNT,
+	.fs_flags	= FS_NOEXEC | FS_USERNS_MOUNT,
 };
 
 void __init proc_root_init(void)
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 8a49486bf30c..9cd8667feb94 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -58,7 +58,7 @@ static struct file_system_type sysfs_fs_type = {
 	.name		= "sysfs",
 	.mount		= sysfs_mount,
 	.kill_sb	= sysfs_kill_sb,
-	.fs_flags	= FS_USERNS_MOUNT,
+	.fs_flags	= FS_NOEXEC | FS_USERNS_MOUNT,
 };
 
 int __init sysfs_init(void)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e351da4a934f..9e44c6d81bb2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1916,6 +1916,7 @@ struct file_system_type {
 #define FS_HAS_SUBTYPE		4
 #define FS_USERNS_MOUNT		8	/* Can be mounted by userns root */
 #define FS_USERNS_DEV_MOUNT	16 /* A userns mount does not imply MNT_NODEV */
+#define FS_NOEXEC		32 /* FS will not support executables */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
@@ -3018,4 +3019,6 @@ static inline bool dir_relax(struct inode *inode)
 	return !IS_DEADDIR(inode);
 }
 
+extern bool path_noexec(const struct path *path);
+
 #endif /* _LINUX_FS_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 259fda25eb6b..fa2f2f671a5c 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1668,8 +1668,7 @@ static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
 	 * overall picture.
 	 */
 	err = -EACCES;
-	if (!S_ISREG(inode->i_mode)	||
-	    exe.file->f_path.mnt->mnt_flags & MNT_NOEXEC)
+	if (!S_ISREG(inode->i_mode) || path_noexec(&exe.file->f_path))
 		goto exit;
 
 	err = inode_permission(inode, MAY_EXEC);
diff --git a/mm/mmap.c b/mm/mmap.c
index aa632ade2be7..f126923ce683 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1268,7 +1268,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 	 *  mounted, in which case we dont add PROT_EXEC.)
 	 */
 	if ((prot & PROT_READ) && (current->personality & READ_IMPLIES_EXEC))
-		if (!(file && (file->f_path.mnt->mnt_flags & MNT_NOEXEC)))
+		if (!(file && path_noexec(&file->f_path)))
 			prot |= PROT_EXEC;
 
 	if (!(flags & MAP_FIXED))
@@ -1337,7 +1337,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 		case MAP_PRIVATE:
 			if (!(file->f_mode & FMODE_READ))
 				return -EACCES;
-			if (file->f_path.mnt->mnt_flags & MNT_NOEXEC) {
+			if (path_noexec(&file->f_path)) {
 				if (vm_flags & VM_EXEC)
 					return -EPERM;
 				vm_flags &= ~VM_MAYEXEC;
diff --git a/mm/nommu.c b/mm/nommu.c
index 05e7447d960b..5fdec8885256 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1035,7 +1035,7 @@ static int validate_mmap_request(struct file *file,
 
 		/* handle executable mappings and implied executable
 		 * mappings */
-		if (file->f_path.mnt->mnt_flags & MNT_NOEXEC) {
+		if (path_noexec(&file->f_path)) {
 			if (prot & PROT_EXEC)
 				return -EPERM;
 		} else if ((prot & PROT_READ) && !(prot & PROT_EXEC)) {
diff --git a/security/security.c b/security/security.c
index 595fffab48b0..062f3c997fdc 100644
--- a/security/security.c
+++ b/security/security.c
@@ -776,7 +776,7 @@ static inline unsigned long mmap_prot(struct file *file, unsigned long prot)
 	 * ditto if it's not on noexec mount, except that on !MMU we need
 	 * NOMMU_MAP_EXEC (== VM_MAYEXEC) in this case
 	 */
-	if (!(file->f_path.mnt->mnt_flags & MNT_NOEXEC)) {
+	if (!path_noexec(&file->f_path)) {
 #ifndef CONFIG_MMU
 		if (file->f_op->mmap_capabilities) {
 			unsigned caps = file->f_op->mmap_capabilities(file);
-- 
2.2.1
