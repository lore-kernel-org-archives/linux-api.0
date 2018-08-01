From: David Howells <dhowells@redhat.com>
Subject: [PATCH 30/33] vfs: syscall: Add fspick() to select a superblock for
 reconfiguration [ver #11]
Date: Wed, 01 Aug 2018 16:27:28 +0100
Message-ID: <153313724861.13253.3837522702693613670.stgit@warthog.procyon.org.uk>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: linux-api@vger.kernel.org, torvalds@linux-foundation.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Provide an fspick() system call that can be used to pick an existing
mountpoint into an fs_context which can thereafter be used to reconfigure a
superblock (equivalent of the superblock side of -o remount).

This looks like:

	int fd = fspick(AT_FDCWD, "/mnt",
			FSPICK_CLOEXEC | FSPICK_NO_AUTOMOUNT);
        fsconfig(fd, FSCONFIG_SET_FLAG, "intr", NULL, 0);
        fsconfig(fd, FSCONFIG_SET_FLAG, "noac", NULL, 0);
        fsconfig(fd, FSCONFIG_CMD_RECONFIGURE, NULL, NULL, 0);

At the point of fspick being called, the file descriptor referring to the
filesystem context is in exactly the same state as the one that was created
by fsopen() after fsmount() has been successfully called.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-api@vger.kernel.org
---

 arch/x86/entry/syscalls/syscall_32.tbl |    1 +
 arch/x86/entry/syscalls/syscall_64.tbl |    1 +
 fs/fsopen.c                            |   58 ++++++++++++++++++++++++++++++++
 include/linux/syscalls.h               |    1 +
 include/uapi/linux/fs.h                |    5 +++
 5 files changed, 66 insertions(+)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index c78b68256f8a..d1eb6c815790 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -403,3 +403,4 @@
 389	i386	fsopen			sys_fsopen			__ia32_sys_fsopen
 390	i386	fsconfig		sys_fsconfig			__ia32_sys_fsconfig
 391	i386	fsmount			sys_fsmount			__ia32_sys_fsmount
+392	i386	fspick			sys_fspick			__ia32_sys_fspick
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index d44ead5d4368..d3ab703c02bb 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -348,6 +348,7 @@
 337	common	fsopen			__x64_sys_fsopen
 338	common	fsconfig		__x64_sys_fsconfig
 339	common	fsmount			__x64_sys_fsmount
+340	common	fspick			__x64_sys_fspick
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/fsopen.c b/fs/fsopen.c
index 5d8560e78ce1..e79bb5b085d6 100644
--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -155,6 +155,64 @@ SYSCALL_DEFINE2(fsopen, const char __user *, _fs_name, unsigned int, flags)
 	return ret;
 }
 
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
+	ret = fscontext_alloc_log(fc);
+	if (ret < 0)
+		goto err_fc;
+
+	path_put(&target);
+	return fscontext_create_fd(fc, flags & FSPICK_CLOEXEC ? O_CLOEXEC : 0);
+
+err_fc:
+	put_fs_context(fc);
+err_path:
+	path_put(&target);
+err:
+	return ret;
+}
+
 /*
  * Check the state and apply the configuration.  Note that this function is
  * allowed to 'steal' the value by setting param->xxx to NULL before returning.
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 65db661cc2da..701522957a12 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -908,6 +908,7 @@ asmlinkage long sys_fsopen(const char __user *fs_name, unsigned int flags);
 asmlinkage long sys_fsconfig(int fs_fd, unsigned int cmd, const char __user *key,
 			     const void __user *value, int aux);
 asmlinkage long sys_fsmount(int fs_fd, unsigned int flags, unsigned int ms_flags);
+asmlinkage long sys_fspick(int dfd, const char __user *path, unsigned int flags);
 
 /*
  * Architecture-specific system calls
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 10281d582e28..7f01503a9e9b 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -351,6 +351,11 @@ typedef int __bitwise __kernel_rwf_t;
 
 #define FSMOUNT_CLOEXEC		0x00000001
 
+#define FSPICK_CLOEXEC		0x00000001
+#define FSPICK_SYMLINK_NOFOLLOW	0x00000002
+#define FSPICK_NO_AUTOMOUNT	0x00000004
+#define FSPICK_EMPTY_PATH	0x00000008
+
 /*
  * The type of fsconfig() call made.
  */
