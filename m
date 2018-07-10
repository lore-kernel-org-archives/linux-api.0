From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/32] vfs: syscall: Add fspick() to select a superblock for
 reconfiguration [ver #9]
Date: Tue, 10 Jul 2018 23:44:22 +0100
Message-ID: <153126266260.14533.990123242086550252.stgit@warthog.procyon.org.uk>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Provide an fspick() system call that can be used to pick an existing
mountpoint into an fs_context which can thereafter be used to reconfigure a
superblock (equivalent of the superblock side of -o remount).

This looks like:

	int fd = fspick(AT_FDCWD, "/mnt",
			FSPICK_CLOEXEC | FSPICK_NO_AUTOMOUNT);
	write(fd, "o intr");
	write(fd, "o noac");
	write(fd, "x reconfigure");

At the point of fspick being called, the file descriptor referring to the
filesystem context is in exactly the same state as the one that was created
by fsopen() after fsmount() has been successfully called.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-api@vger.kernel.org
---

 arch/x86/entry/syscalls/syscall_32.tbl |    1 +
 arch/x86/entry/syscalls/syscall_64.tbl |    1 +
 fs/fsopen.c                            |   53 ++++++++++++++++++++++++++++++++
 include/linux/syscalls.h               |    1 +
 include/uapi/linux/fs.h                |    5 +++
 5 files changed, 61 insertions(+)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 537572098032..5587bcede253 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -402,3 +402,4 @@
 388	i386	move_mount		sys_move_mount			__ia32_sys_move_mount
 389	i386	fsopen			sys_fsopen			__ia32_sys_fsopen
 390	i386	fsmount			sys_fsmount			__ia32_sys_fsmount
+391	i386	fspick			sys_fspick			__ia32_sys_fspick
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 47abbc2a2bbe..460a464024bf 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -347,6 +347,7 @@
 336	common	move_mount		__x64_sys_move_mount
 337	common	fsopen			__x64_sys_fsopen
 338	common	fsmount			__x64_sys_fsmount
+339	common	fspick			__x64_sys_fspick
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/fsopen.c b/fs/fsopen.c
index 28bb72bda163..35c2a94d0c68 100644
--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -15,6 +15,7 @@
 #include <linux/syscalls.h>
 #include <linux/security.h>
 #include <linux/anon_inodes.h>
+#include <linux/namei.h>
 #include "mount.h"
 
 /*
@@ -207,3 +208,55 @@ SYSCALL_DEFINE2(fsopen, const char __user *, _fs_name, unsigned int, flags)
 	fc->phase = FS_CONTEXT_CREATE_PARAMS;
 	return fscontext_create_fd(fc, flags & FSOPEN_CLOEXEC ? O_CLOEXEC : 0);
 }
+
+/*
+ * Pick a superblock into a context for reconfiguration.
+ */
+SYSCALL_DEFINE3(fspick, int, dfd, const char __user *, path, unsigned int, flags)
+{
+	struct fs_context *fc;
+	struct path target;
+	unsigned int lookup_flags;
+	int ret;
+
+	if (!ns_capable(current->nsproxy->mnt_ns->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if ((flags & ~(FSPICK_CLOEXEC |
+		       FSPICK_SYMLINK_NOFOLLOW |
+		       FSPICK_NO_AUTOMOUNT |
+		       FSPICK_EMPTY_PATH)) != 0)
+		return -EINVAL;
+
+	lookup_flags = LOOKUP_FOLLOW | LOOKUP_AUTOMOUNT;
+	if (flags & FSPICK_SYMLINK_NOFOLLOW)
+		lookup_flags &= ~LOOKUP_FOLLOW;
+	if (flags & FSPICK_NO_AUTOMOUNT)
+		lookup_flags &= ~LOOKUP_AUTOMOUNT;
+	if (flags & FSPICK_EMPTY_PATH)
+		lookup_flags |= LOOKUP_EMPTY;
+	ret = user_path_at(dfd, path, lookup_flags, &target);
+	if (ret < 0)
+		goto err;
+
+	ret = -EOPNOTSUPP;
+	if (!target.dentry->d_sb->s_op->reconfigure)
+		goto err_path;
+
+	fc = vfs_new_fs_context(target.dentry->d_sb->s_type, target.dentry,
+				0, FS_CONTEXT_FOR_RECONFIGURE);
+	if (IS_ERR(fc)) {
+		ret = PTR_ERR(fc);
+		goto err_path;
+	}
+
+	fc->phase = FS_CONTEXT_RECONF_PARAMS;
+
+	path_put(&target);
+	return fscontext_create_fd(fc, flags & FSPICK_CLOEXEC ? O_CLOEXEC : 0);
+
+err_path:
+	path_put(&target);
+err:
+	return ret;
+}
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 917fe10e1030..ac803f5c0822 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -906,6 +906,7 @@ asmlinkage long sys_move_mount(int from_dfd, const char __user *from_path,
 			       unsigned int ms_flags);
 asmlinkage long sys_fsopen(const char __user *fs_name, unsigned int flags);
 asmlinkage long sys_fsmount(int fs_fd, unsigned int flags, unsigned int ms_flags);
+asmlinkage long sys_fspick(int dfd, const char __user *path, unsigned int flags);
 
 /*
  * Architecture-specific system calls
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 30a2fb85c4b7..c27576d471c2 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -351,4 +351,9 @@ typedef int __bitwise __kernel_rwf_t;
 
 #define FSMOUNT_CLOEXEC		0x00000001
 
+#define FSPICK_CLOEXEC		0x00000001
+#define FSPICK_SYMLINK_NOFOLLOW	0x00000002
+#define FSPICK_NO_AUTOMOUNT	0x00000004
+#define FSPICK_EMPTY_PATH	0x00000008
+
 #endif /* _UAPI_LINUX_FS_H */
