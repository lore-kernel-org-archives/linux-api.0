From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [REVIEW][PATCH 1/2] vfs: Commit to never having exectuables on proc and sysfs.
Date: Fri, 10 Jul 2015 11:17:39 -0500
Message-ID: <87h9pcyokc.fsf_-_@x220.int.ebiederm.org>
References: <87381eyz26.fsf@x220.int.ebiederm.org>
	<CA+55aFysKDXr2HEwNzm3z9QOw=E4ZeWcvYQ-xLhy5_k+rGbeRg@mail.gmail.com>
	<87pp4eqktr.fsf@x220.int.ebiederm.org>
	<CA+55aFw-DK-xDC-3HYa=BMX8WNyQgT9O01tihrAS9+-7PPj_jA@mail.gmail.com>
	<20150704231118.GT17109@ZenIV.linux.org.uk>
	<87mvz4yomp.fsf_-_@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87mvz4yomp.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Fri, 10 Jul 2015 11:16:14 -0500")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, "Serge E. Hallyn" <serge@hallyn.com>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, =?utf-8?Q?St=C3=A9phane?= Graber <stgraber@ubuntu.com>, Eric Windisch <ewindisch@docker.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Seth Forshee <seth.forshee@canonical.com>, Omar Sandoval <osandov@osandov.com>, Ivan Delalande <colona@arista.com>, Al Viro <viro@ZenIV.linux.org.uk>
List-Id: linux-api@vger.kernel.org


Today proc and sysfs do not contain any executable files.  Several
applications today mount proc or sysfs without noexec and nosuid and
then depend on there being no exectuables files on proc or sysfs.
Having any executable files show on proc or sysfs would cause
a user space visible regression, and most likely security problems.

Therefore commit to never allowing executables on proc and sysfs by
adding a new flag to mark them as filesystems without executables and
enforce that flag.

Test the flag where MNT_NOEXEC is tested today, so that the only user
visible effect will be that exectuables will be treated as if the
execute bit is cleared.

The filesystems proc and sysfs do not currently incoporate any
executable files so this does not result in any user visible effects.

This makes it unnecessary to vet changes to proc and sysfs tightly for
adding exectuable files or changes to chattr that would modify
existing files, as no matter what the individual file say they will
not be treated as exectuable files by the vfs.

Not having to vet changes to closely is important as without this we
are only one proc_create call (or another goof up in the
implementation of notify_change) from having problematic executables
on proc.  Those mistakes are all too easy to make and would create
a situation where there are security issues or the assumptions of
some program having to be broken (and cause userspace regressions).

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/exec.c           | 10 ++++++++--
 fs/open.c           |  2 +-
 fs/proc/root.c      |  2 ++
 fs/sysfs/mount.c    |  4 ++++
 include/linux/fs.h  |  3 +++
 kernel/sys.c        |  3 +--
 mm/mmap.c           |  4 ++--
 mm/nommu.c          |  2 +-
 security/security.c |  2 +-
 9 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 1977c2a553ac..b06623a9347f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -98,6 +98,12 @@ static inline void put_binfmt(struct linux_binfmt * fmt)
 	module_put(fmt->module);
 }
 
+bool path_noexec(const struct path *path)
+{
+	return (path->mnt->mnt_flags & MNT_NOEXEC) ||
+	       (path->mnt->mnt_sb->s_iflags & SB_I_NOEXEC);
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
index e33dab287fa0..b6f1e96a7c0b 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -377,7 +377,7 @@ retry:
 		 * with the "noexec" flag.
 		 */
 		res = -EACCES;
-		if (path.mnt->mnt_flags & MNT_NOEXEC)
+		if (path_noexec(&path))
 			goto out_path_release;
 	}
 
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 68feb0f70e63..361ab4ee42fc 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -134,6 +134,8 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 		}
 
 		sb->s_flags |= MS_ACTIVE;
+		/* User space would break if executables appear on proc */
+		sb->s_iflags |= SB_I_NOEXEC;
 	}
 
 	return dget(sb->s_root);
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 1c6ac6fcee9f..f3db82071cfb 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -40,6 +40,10 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 				SYSFS_MAGIC, &new_sb, ns);
 	if (IS_ERR(root) || !new_sb)
 		kobj_ns_drop(KOBJ_NS_TYPE_NET, ns);
+	else if (new_sb)
+		/* Userspace would break if executables appear on sysfs */
+		root->d_sb->s_iflags |= SB_I_NOEXEC;
+
 	return root;
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a0653e560c26..42912f8d286e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1244,6 +1244,7 @@ struct mm_struct;
 
 /* sb->s_iflags */
 #define SB_I_CGROUPWB	0x00000001	/* cgroup-aware writeback enabled */
+#define SB_I_NOEXEC	0x00000002	/* Ignore executables on this fs */
 
 /* Possible states of 'frozen' field */
 enum {
@@ -3030,4 +3031,6 @@ static inline bool dir_relax(struct inode *inode)
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
index 58ea3643b9e9..ce17abf087ff 100644
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

