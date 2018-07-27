From: David Howells <dhowells@redhat.com>
Subject: [PATCH 29/38] vfs: syscall: Add fsconfig() for configuring and
 managing a context [ver #10]
Date: Fri, 27 Jul 2018 18:34:35 +0100
Message-ID: <153271287586.9458.6001928723332685410.stgit@warthog.procyon.org.uk>
References: <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: linux-api@vger.kernel.org, torvalds@linux-foundation.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add a syscall for configuring a filesystem creation context and triggering
actions upon it, to be used in conjunction with fsopen, fspick and fsmount.

    long fsconfig(int fs_fd, unsigned int cmd, const char *key,
		  const void *value, int aux);

Where fs_fd indicates the context, cmd indicates the action to take, key
indicates the parameter name for parameter-setting actions and, if needed,
value points to a buffer containing the value and aux can give more
information for the value.

The following command IDs are proposed:

 (*) fsconfig_set_flag: No value is specified.  The parameter must be
     boolean in nature.  The key may be prefixed with "no" to invert the
     setting. value must be NULL and aux must be 0.

 (*) fsconfig_set_string: A string value is specified.  The parameter can
     be expecting boolean, integer, string or take a path.  A conversion to
     an appropriate type will be attempted (which may include looking up as
     a path).  value points to a NUL-terminated string and aux must be 0.

 (*) fsconfig_set_binary: A binary blob is specified.  value points to
     the blob and aux indicates its size.  The parameter must be expecting
     a blob.

 (*) fsconfig_set_path: A non-empty path is specified.  The parameter must
     be expecting a path object.  value points to a NUL-terminated string
     that is the path and aux is a file descriptor at which to start a
     relative lookup or AT_FDCWD.

 (*) fsconfig_set_path_empty: As fsconfig_set_path, but with AT_EMPTY_PATH
     implied.

 (*) fsconfig_set_fd: An open file descriptor is specified.  value must
     be NULL and aux indicates the file descriptor.

 (*) fsconfig_cmd_create: Trigger superblock creation.

 (*) fsconfig_cmd_reconfigure: Trigger superblock reconfiguration.

For the "set" command IDs, the idea is that the file_system_type will point
to a list of parameters and the types of value that those parameters expect
to take.  The core code can then do the parse and argument conversion and
then give the LSM and FS a cooked option or array of options to use.

Source specification is also done the same way same way, using special keys
"source", "source1", "source2", etc..

[!] Note that, for the moment, the key and value are just glued back
together and handed to the filesystem.  Every filesystem that uses options
uses match_token() and co. to do this, and this will need to be changed -
but not all at once.

Example usage:

    fd = fsopen("ext4", FSOPEN_CLOEXEC);
    fsconfig(fd, fsconfig_set_path, "source", "/dev/sda1", AT_FDCWD);
    fsconfig(fd, fsconfig_set_path_empty, "journal_path", "", journal_fd);
    fsconfig(fd, fsconfig_set_fd, "journal_fd", "", journal_fd);
    fsconfig(fd, fsconfig_set_flag, "user_xattr", NULL, 0);
    fsconfig(fd, fsconfig_set_flag, "noacl", NULL, 0);
    fsconfig(fd, fsconfig_set_string, "sb", "1", 0);
    fsconfig(fd, fsconfig_set_string, "errors", "continue", 0);
    fsconfig(fd, fsconfig_set_string, "data", "journal", 0);
    fsconfig(fd, fsconfig_set_string, "context", "unconfined_u:...", 0);
    fsconfig(fd, fsconfig_cmd_create, NULL, NULL, 0);
    mfd = fsmount(fd, FSMOUNT_CLOEXEC, MS_NOEXEC);

or:

    fd = fsopen("ext4", FSOPEN_CLOEXEC);
    fsconfig(fd, fsconfig_set_string, "source", "/dev/sda1", 0);
    fsconfig(fd, fsconfig_cmd_create, NULL, NULL, 0);
    mfd = fsmount(fd, FSMOUNT_CLOEXEC, MS_NOEXEC);

or:

    fd = fsopen("afs", FSOPEN_CLOEXEC);
    fsconfig(fd, fsconfig_set_string, "source", "#grand.central.org:root.cell", 0);
    fsconfig(fd, fsconfig_cmd_create, NULL, NULL, 0);
    mfd = fsmount(fd, FSMOUNT_CLOEXEC, MS_NOEXEC);

or:

    fd = fsopen("jffs2", FSOPEN_CLOEXEC);
    fsconfig(fd, fsconfig_set_string, "source", "mtd0", 0);
    fsconfig(fd, fsconfig_cmd_create, NULL, NULL, 0);
    mfd = fsmount(fd, FSMOUNT_CLOEXEC, MS_NOEXEC);

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-api@vger.kernel.org
---

 arch/x86/entry/syscalls/syscall_32.tbl |    1 
 arch/x86/entry/syscalls/syscall_64.tbl |    1 
 fs/fsopen.c                            |  278 ++++++++++++++++++++++++++++++++
 include/linux/syscalls.h               |    2 
 include/uapi/linux/fs.h                |   14 ++
 5 files changed, 296 insertions(+)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 1647fefd2969..f9970310c126 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -401,3 +401,4 @@
 387	i386	open_tree		sys_open_tree			__ia32_sys_open_tree
 388	i386	move_mount		sys_move_mount			__ia32_sys_move_mount
 389	i386	fsopen			sys_fsopen			__ia32_sys_fsopen
+390	i386	fsconfig		sys_fsconfig			__ia32_sys_fsconfig
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 235d33dbccb2..4185d36e03bb 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -346,6 +346,7 @@
 335	common	open_tree		__x64_sys_open_tree
 336	common	move_mount		__x64_sys_move_mount
 337	common	fsopen			__x64_sys_fsopen
+338	common	fsconfig		__x64_sys_fsconfig
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/fsopen.c b/fs/fsopen.c
index 7a25b4c3bc18..d2d23c02839a 100644
--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/fs_context.h>
+#include <linux/fs_parser.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/syscalls.h>
@@ -17,6 +18,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/namei.h>
 #include <linux/file.h>
+#include "internal.h"
 #include "mount.h"
 
 /*
@@ -152,3 +154,279 @@ SYSCALL_DEFINE2(fsopen, const char __user *, _fs_name, unsigned int, flags)
 	put_fs_context(fc);
 	return ret;
 }
+
+/*
+ * Check the state and apply the configuration.  Note that this function is
+ * allowed to 'steal' the value by setting param->xxx to NULL before returning.
+ */
+static int vfs_fsconfig(struct fs_context *fc, struct fs_parameter *param)
+{
+	int ret;
+
+	/* We need to reinitialise the context if we have reconfiguration
+	 * pending after creation or a previous reconfiguration.
+	 */
+	if (fc->phase == FS_CONTEXT_AWAITING_RECONF) {
+		if (fc->fs_type->init_fs_context) {
+			ret = fc->fs_type->init_fs_context(fc, fc->root);
+			if (ret < 0) {
+				fc->phase = FS_CONTEXT_FAILED;
+				return ret;
+			}
+		} else {
+			/* Leave legacy context ops in place */
+		}
+
+		/* Do the security check last because ->init_fs_context may
+		 * change the namespace subscriptions.
+		 */
+		ret = security_fs_context_alloc(fc, fc->root);
+		if (ret < 0) {
+			fc->phase = FS_CONTEXT_FAILED;
+			return ret;
+		}
+
+		fc->phase = FS_CONTEXT_RECONF_PARAMS;
+	}
+
+	if (fc->phase != FS_CONTEXT_CREATE_PARAMS &&
+	    fc->phase != FS_CONTEXT_RECONF_PARAMS)
+		return -EBUSY;
+
+	return vfs_parse_fs_param(fc, param);
+}
+
+/*
+ * Perform an action on a context.
+ */
+static int vfs_fsconfig_action(struct fs_context *fc, enum fsconfig_command cmd)
+{
+	int ret = -EINVAL;
+
+	switch (cmd) {
+	case fsconfig_cmd_create:
+		if (fc->phase != FS_CONTEXT_CREATE_PARAMS)
+			return -EBUSY;
+		fc->phase = FS_CONTEXT_CREATING;
+		ret = vfs_get_tree(fc);
+		if (ret == 0)
+			fc->phase = FS_CONTEXT_AWAITING_MOUNT;
+		else
+			fc->phase = FS_CONTEXT_FAILED;
+		return ret;
+
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+/**
+ * sys_fsconfig - Set parameters and trigger actions on a context
+ * @fd: The filesystem context to act upon
+ * @cmd: The action to take
+ * @_key: Where appropriate, the parameter key to set
+ * @_value: Where appropriate, the parameter value to set
+ * @aux: Additional information for the value
+ *
+ * This system call is used to set parameters on a context, including
+ * superblock settings, data source and security labelling.
+ *
+ * Actions include triggering the creation of a superblock and the
+ * reconfiguration of the superblock attached to the specified context.
+ *
+ * When setting a parameter, @cmd indicates the type of value being proposed
+ * and @_key indicates the parameter to be altered.
+ *
+ * @_value and @aux are used to specify the value, should a value be required:
+ *
+ * (*) fsconfig_set_flag: No value is specified.  The parameter must be boolean
+ *     in nature.  The key may be prefixed with "no" to invert the
+ *     setting. @_value must be NULL and @aux must be 0.
+ *
+ * (*) fsconfig_set_string: A string value is specified.  The parameter can be
+ *     expecting boolean, integer, string or take a path.  A conversion to an
+ *     appropriate type will be attempted (which may include looking up as a
+ *     path).  @_value points to a NUL-terminated string and @aux must be 0.
+ *
+ * (*) fsconfig_set_binary: A binary blob is specified.  @_value points to the
+ *     blob and @aux indicates its size.  The parameter must be expecting a
+ *     blob.
+ *
+ * (*) fsconfig_set_path: A non-empty path is specified.  The parameter must be
+ *     expecting a path object.  @_value points to a NUL-terminated string that
+ *     is the path and @aux is a file descriptor at which to start a relative
+ *     lookup or AT_FDCWD.
+ *
+ * (*) fsconfig_set_path_empty: As fsconfig_set_path, but with AT_EMPTY_PATH
+ *     implied.
+ *
+ * (*) fsconfig_set_fd: An open file descriptor is specified.  @_value must be
+ *     NULL and @aux indicates the file descriptor.
+ */
+SYSCALL_DEFINE5(fsconfig,
+		int, fd,
+		unsigned int, cmd,
+		const char __user *, _key,
+		const void __user *, _value,
+		int, aux)
+{
+	struct fs_context *fc;
+	struct fd f;
+	int ret;
+
+	struct fs_parameter param = {
+		.type	= fs_value_is_undefined,
+	};
+
+	if (fd < 0)
+		return -EINVAL;
+
+	switch (cmd) {
+	case fsconfig_set_flag:
+		if (!_key || _value || aux)
+			return -EINVAL;
+		break;
+	case fsconfig_set_string:
+		if (!_key || !_value || aux)
+			return -EINVAL;
+		break;
+	case fsconfig_set_binary:
+		if (!_key || !_value || aux <= 0 || aux > 1024 * 1024)
+			return -EINVAL;
+		break;
+	case fsconfig_set_path:
+	case fsconfig_set_path_empty:
+		if (!_key || !_value || (aux != AT_FDCWD && aux < 0))
+			return -EINVAL;
+		break;
+	case fsconfig_set_fd:
+		if (!_key || _value || aux < 0)
+			return -EINVAL;
+		break;
+	case fsconfig_cmd_create:
+	case fsconfig_cmd_reconfigure:
+		if (_key || _value || aux)
+			return -EINVAL;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+	ret = -EINVAL;
+	if (f.file->f_op != &fscontext_fops)
+		goto out_f;
+
+	fc = f.file->private_data;
+	if (fc->ops == &legacy_fs_context_ops) {
+		switch (cmd) {
+		case fsconfig_set_binary:
+		case fsconfig_set_path:
+		case fsconfig_set_path_empty:
+		case fsconfig_set_fd:
+			ret = -EOPNOTSUPP;
+			goto out_f;
+		}
+	}
+
+	if (_key) {
+		param.key = strndup_user(_key, 256);
+		if (IS_ERR(param.key)) {
+			ret = PTR_ERR(param.key);
+			goto out_f;
+		}
+	}
+
+	switch (cmd) {
+	case fsconfig_set_string:
+		param.type = fs_value_is_string;
+		param.string = strndup_user(_value, 256);
+		if (IS_ERR(param.string)) {
+			ret = PTR_ERR(param.string);
+			goto out_key;
+		}
+		param.size = strlen(param.string);
+		break;
+	case fsconfig_set_binary:
+		param.type = fs_value_is_blob;
+		param.size = aux;
+		param.blob = memdup_user_nul(_value, aux);
+		if (IS_ERR(param.blob)) {
+			ret = PTR_ERR(param.blob);
+			goto out_key;
+		}
+		break;
+	case fsconfig_set_path:
+		param.type = fs_value_is_filename;
+		param.name = getname_flags(_value, 0, NULL);
+		if (IS_ERR(param.name)) {
+			ret = PTR_ERR(param.name);
+			goto out_key;
+		}
+		param.dirfd = aux;
+		param.size = strlen(param.name->name);
+		break;
+	case fsconfig_set_path_empty:
+		param.type = fs_value_is_filename_empty;
+		param.name = getname_flags(_value, LOOKUP_EMPTY, NULL);
+		if (IS_ERR(param.name)) {
+			ret = PTR_ERR(param.name);
+			goto out_key;
+		}
+		param.dirfd = aux;
+		param.size = strlen(param.name->name);
+		break;
+	case fsconfig_set_fd:
+		param.type = fs_value_is_file;
+		ret = -EBADF;
+		param.file = fget(aux);
+		if (!param.file)
+			goto out_key;
+		break;
+	default:
+		break;
+	}
+
+	ret = mutex_lock_interruptible(&fc->uapi_mutex);
+	if (ret == 0) {
+		switch (cmd) {
+		case fsconfig_cmd_create:
+		case fsconfig_cmd_reconfigure:
+			ret = vfs_fsconfig_action(fc, cmd);
+			break;
+		default:
+			ret = vfs_fsconfig(fc, &param);
+			break;
+		}
+		mutex_unlock(&fc->uapi_mutex);
+	}
+
+	/* Clean up the our record of any value that we obtained from
+	 * userspace.  Note that the value may have been stolen by the LSM or
+	 * filesystem, in which case the value pointer will have been cleared.
+	 */
+	switch (cmd) {
+	case fsconfig_set_string:
+	case fsconfig_set_binary:
+		kfree(param.string);
+		break;
+	case fsconfig_set_path:
+	case fsconfig_set_path_empty:
+		if (param.name)
+			putname(param.name);
+		break;
+	case fsconfig_set_fd:
+		if (param.file)
+			fput(param.file);
+		break;
+	default:
+		break;
+	}
+out_key:
+	kfree(param.key);
+out_f:
+	fdput(f);
+	return ret;
+}
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index ad6c7ff33c01..9628d14a7ede 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -905,6 +905,8 @@ asmlinkage long sys_move_mount(int from_dfd, const char __user *from_path,
 			       int to_dfd, const char __user *to_path,
 			       unsigned int ms_flags);
 asmlinkage long sys_fsopen(const char __user *fs_name, unsigned int flags);
+asmlinkage long sys_fsconfig(int fs_fd, unsigned int cmd, const char __user *key,
+			     const void __user *value, int aux);
 
 /*
  * Architecture-specific system calls
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index f8818e6cddd6..7c9e165e8689 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -349,4 +349,18 @@ typedef int __bitwise __kernel_rwf_t;
  */
 #define FSOPEN_CLOEXEC		0x00000001
 
+/*
+ * The type of fsconfig() call made.
+ */
+enum fsconfig_command {
+	fsconfig_set_flag,		/* Set parameter, supplying no value */
+	fsconfig_set_string,		/* Set parameter, supplying a string value */
+	fsconfig_set_binary,		/* Set parameter, supplying a binary blob value */
+	fsconfig_set_path,		/* Set parameter, supplying an object by path */
+	fsconfig_set_path_empty,	/* Set parameter, supplying an object by (empty) path */
+	fsconfig_set_fd,		/* Set parameter, supplying an object by fd */
+	fsconfig_cmd_create,		/* Invoke superblock creation */
+	fsconfig_cmd_reconfigure,	/* Invoke superblock reconfiguration */
+};
+
 #endif /* _UAPI_LINUX_FS_H */
