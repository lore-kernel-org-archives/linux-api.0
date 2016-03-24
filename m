From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [RFC v1 06/17] seccomp: Add the SECCOMP_ADD_CHECKER_GROUP command
Date: Thu, 24 Mar 2016 02:46:37 +0100
Message-ID: <1458784008-16277-7-git-send-email-mic@digikod.net>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-2836-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1458784008-16277-1-git-send-email-mic@digikod.net>
To: linux-security-module@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Will Drewry <wad@chromium.org>, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

A new command SECCOMP_ADD_CHECKER_GROUP allows userland seccomp filters
to reference kernel objects with checkers in a batch.

Each checker is autonomous and new ones can easily be added in the
future. There is currently two checkers for path objects:
* SECCOMP_CHECK_FS_LITERAL checks if a string match a defined path;
* SECCOMP_CHECK_FS_BENEATH checks if the path representation of a string
  is equal or equivalent to a file belonging to a defined path.

These checkers can use a bitmask of flags to match a path:
* SECCOMP_OBJFLAG_FS_DENTRY match a unique file;
* SECCOMP_OBJFLAG_FS_INODE only match a file inode (must be used with
  the device flag);
* SECCOMP_OBJFLAG_FS_DEVICE match the device of a file;
* SECCOMP_OBJFLAG_FS_MOUNT match the mount point of a file;
* SECCOMP_OBJFLAG_FS_NOFOLLOW do not follow a symlink for the
  initial checker evaluation.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: David Drysdale <drysdale@google.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michael Kerrisk <mtk@man7.org>
Cc: Paul Moore <pmoore@redhat.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Will Drewry <wad@chromium.org>
---
 include/linux/seccomp.h       |  32 ++++++
 include/uapi/linux/seccomp.h  |  81 ++++++++++++++++
 kernel/seccomp.c              | 221 ++++++++++++++++++++++++++++++++++++++++++
 security/seccomp/Makefile     |   2 +-
 security/seccomp/checker_fs.c | 102 +++++++++++++++++++
 5 files changed, 437 insertions(+), 1 deletion(-)
 create mode 100644 security/seccomp/checker_fs.c

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 2296e6b2f690..78f5861a0328 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -9,8 +9,10 @@
 
 #include <linux/thread_info.h>
 #include <asm/seccomp.h>
+#include <linux/path.h>
 
 struct seccomp_filter;
+struct seccomp_filter_checker_group;
 /**
  * struct seccomp - the state of a seccomp'ed process
  *
@@ -19,12 +21,20 @@ struct seccomp_filter;
  * @filter: must always point to a valid seccomp-filter or NULL as it is
  *          accessed without locking during system call entry.
  *
+ * @checker_group: an append-only list of argument checkers usable by filters
+ *                 created after the last update.
+ *
  *          @filter must only be accessed from the context of current as there
  *          is no read locking.
  */
 struct seccomp {
 	int mode;
 	struct seccomp_filter *filter;
+
+#ifdef CONFIG_SECURITY_SECCOMP
+	/* @checker_group is only used for filter creation and unique per thread */
+	struct seccomp_filter_checker_group *checker_group;
+#endif
 };
 
 #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
@@ -85,6 +95,28 @@ static inline int seccomp_mode(struct seccomp *s)
 #ifdef CONFIG_SECCOMP_FILTER
 extern void put_seccomp_filter(struct task_struct *tsk);
 extern void get_seccomp_filter(struct task_struct *tsk);
+
+#ifdef CONFIG_SECURITY_SECCOMP
+struct seccomp_filter_object_path {
+	u32 flags;
+	struct path path;
+};
+
+struct seccomp_filter_checker {
+	/* e.g. SECCOMP_ARGCHECK_FS_LITERAL */
+	u32 check;
+	/* e.g. SECCOMP_ARGTYPE_PATH */
+	u32 type;
+	union {
+		struct seccomp_filter_object_path object_path;
+	};
+};
+
+
+long seccomp_set_argcheck_fs(const struct seccomp_checker *,
+			     struct seccomp_filter_checker *);
+#endif /* CONFIG_SECURITY_SECCOMP */
+
 #else  /* CONFIG_SECCOMP_FILTER */
 static inline void put_seccomp_filter(struct task_struct *tsk)
 {
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 0f238a43ff1e..ca7e9343f3d7 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -13,6 +13,7 @@
 /* Valid operations for seccomp syscall. */
 #define SECCOMP_SET_MODE_STRICT	0
 #define SECCOMP_SET_MODE_FILTER	1
+#define SECCOMP_ADD_CHECKER_GROUP	2 /* add a group of checkers */
 
 /* Valid flags for SECCOMP_SET_MODE_FILTER */
 #define SECCOMP_FILTER_FLAG_TSYNC	1
@@ -35,6 +36,25 @@
 #define SECCOMP_RET_ACTION	0x7fff0000U
 #define SECCOMP_RET_DATA	0x0000ffffU
 
+/* Object checks */
+#define SECCOMP_CHECK_FS_LITERAL	1
+#define SECCOMP_CHECK_FS_BENEATH	2
+
+/* Object flags */
+#define SECCOMP_OBJFLAG_FS_DENTRY	(1 << 0)
+#define SECCOMP_OBJFLAG_FS_INODE	(1 << 1)
+#define SECCOMP_OBJFLAG_FS_DEVICE	(1 << 2)
+#define SECCOMP_OBJFLAG_FS_MOUNT	(1 << 3)
+/* Do the evaluation follow the argument path? (cf. fs/namei.c)
+ * This flag is only used for the seccomp filter but not by the LSM check to
+ * enforce access control. You need to take care of the different path
+ * interpretation per syscall (e.g. rename(2) or open(2) with O_NOFOLLOW).
+ */
+#define SECCOMP_OBJFLAG_FS_NOFOLLOW	(1 << 4)
+
+/* Argument types */
+#define SECCOMP_OBJTYPE_PATH		1
+
 /**
  * struct seccomp_data - the format the BPF program executes over.
  * @nr: the system call number
@@ -51,4 +71,65 @@ struct seccomp_data {
 	__u64 args[6];
 };
 
+/* TODO: Add a "at" field (default to AT_FDCWD) */
+struct seccomp_object_path {
+	/* e.g. SECCOMP_OBJFLAG_FS_DENTRY */
+	__u32 flags;
+	const char *path;
+};
+
+struct seccomp_checker {
+	__u32 check;
+	__u32 type;
+	/* Must match the checker extra size, if any */
+	unsigned int len;
+	/* Checkers must be pointers to allow futur additions */
+	union {
+		const struct seccomp_object_path *object_path;
+	};
+};
+
+#define SECCOMP_MAKE_PATH_DENTRY(_p)				\
+	{							\
+		.flags = SECCOMP_OBJFLAG_FS_DENTRY,		\
+		.path = _p,					\
+	}
+
+#define SECCOMP_MAKE_PATH_INODE(_p)				\
+	{							\
+		.flags = SECCOMP_OBJFLAG_FS_INODE |		\
+			SECCOMP_OBJFLAG_FS_DEVICE,		\
+		.path = _p,					\
+	}
+
+#define SECCOMP_MAKE_PATH_MOUNT(_p)				\
+	{							\
+		.flags = SECCOMP_OBJFLAG_FS_MOUNT,		\
+		.path = _p,					\
+	}
+
+#define SECCOMP_MAKE_PATH_ALL(_p)				\
+	{							\
+		.flags = SECCOMP_OBJFLAG_FS_DENTRY |		\
+			SECCOMP_OBJFLAG_FS_INODE |		\
+			SECCOMP_OBJFLAG_FS_DEVICE |		\
+			SECCOMP_OBJFLAG_FS_MOUNT,		\
+		.path = _p,					\
+	}
+
+#define SECCOMP_MAKE_OBJ_PATH(_c, _p)				\
+	{							\
+		.check = SECCOMP_CHECK_##_c,			\
+		.type = SECCOMP_OBJTYPE_PATH,			\
+		.len = 0,					\
+		.object_path = _p,				\
+	}
+
+struct seccomp_checker_group {
+	__u8 version;
+	__u8 id;
+	unsigned int len;
+	const struct seccomp_checker (*checkers)[];
+};
+
 #endif /* _UAPI_LINUX_SECCOMP_H */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 2c94693e4163..0e5471d2891c 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -6,6 +6,8 @@
  * Copyright (C) 2012 Google, Inc.
  * Will Drewry <wad@chromium.org>
  *
+ * Copyright (C) 2016  Mickaël Salaün <mic@digikod.net>
+ *
  * This defines a simple but solid secure-computing facility.
  *
  * Mode 1 uses a fixed list of allowed system calls.
@@ -60,6 +62,34 @@ struct seccomp_filter {
 	struct bpf_prog *prog;
 };
 
+/* Argument group attached to seccomp filters
+ *
+ * @usage keep track of the references
+ * @prev link to the previous checker_group
+ * @id is given by userland to easely check a filter statically and not
+ *     leak data from the kernel
+ * @checkers_len is the number of @checkers elements
+ * @checkers contains the checkers
+ *
+ * seccomp_filter_checker_group checkers are organized in a tree linked via the
+ * @prev pointer. For any task, it appears to be a singly-linked list starting
+ * with current->seccomp.filter->checker_group, the most recently added argument
+ * group. All filters created by a process share the argument groups created by
+ * this process until the filter creation but they can not be changed. However,
+ * multiple argument groups may share a @prev node, which results in a
+ * unidirectional tree existing in memory. They are not inherited through
+ * fork().
+ */
+#ifdef CONFIG_SECURITY_SECCOMP
+struct seccomp_filter_checker_group {
+	atomic_t usage;
+	struct seccomp_filter_checker_group *prev;
+	u8 id;
+	unsigned int checkers_len;
+	struct seccomp_filter_checker checkers[];
+};
+#endif /* CONFIG_SECURITY_SECCOMP */
+
 /* Limit any path through the tree to 256KB worth of instructions. */
 #define MAX_INSNS_PER_PATH ((1 << 18) / sizeof(struct sock_filter))
 
@@ -467,6 +497,38 @@ void get_seccomp_filter(struct task_struct *tsk)
 	atomic_inc(&orig->usage);
 }
 
+#ifdef CONFIG_SECURITY_SECCOMP
+/* Do not free @checker */
+static void put_seccomp_obj(struct seccomp_filter_checker *checker)
+{
+	switch (checker->type) {
+	case SECCOMP_OBJTYPE_PATH:
+		/* Pointer checks done in path_put() */
+		path_put(&checker->object_path.path);
+		break;
+	default:
+		WARN_ON(1);
+	}
+}
+
+/* Free @checker_group */
+static void put_seccomp_checker_group(struct seccomp_filter_checker_group *checker_group)
+{
+	int i;
+	struct seccomp_filter_checker_group *orig = checker_group;
+
+	/* Clean up single-reference branches iteratively. */
+	while (orig && atomic_dec_and_test(&orig->usage)) {
+		struct seccomp_filter_checker_group *freeme = orig;
+
+		for (i = 0; i < freeme->checkers_len; i++)
+			put_seccomp_obj(&freeme->checkers[i]);
+		orig = orig->prev;
+		kfree(freeme);
+	}
+}
+#endif /* CONFIG_SECURITY_SECCOMP */
+
 static inline void seccomp_filter_free(struct seccomp_filter *filter)
 {
 	if (filter) {
@@ -485,6 +547,9 @@ void put_seccomp_filter(struct task_struct *tsk)
 		orig = orig->prev;
 		seccomp_filter_free(freeme);
 	}
+#ifdef CONFIG_SECURITY_SECCOMP
+	put_seccomp_checker_group(tsk->seccomp.checker_group);
+#endif
 }
 
 /**
@@ -813,6 +878,158 @@ static inline long seccomp_set_mode_filter(unsigned int flags,
 }
 #endif
 
+#ifdef CONFIG_SECURITY_SECCOMP
+
+/* Limit checkers number to 64 to be able to show matches with a bitmask. */
+#define SECCOMP_CHECKERS_MAX 64
+
+/* Limit arg group list and their checkers to 256KB. */
+#define SECCOMP_GROUP_CHECKERS_MAX_SIZE (1 << 18)
+
+static long seccomp_add_checker_group(unsigned int flags, const char __user *group)
+{
+	struct seccomp_checker_group kgroup;
+	struct seccomp_checker (*kcheckers)[], *user_checker;
+	struct seccomp_filter_checker_group *filter_group, *walker;
+	struct seccomp_filter_checker *kernel_obj;
+	unsigned int i;
+	unsigned long group_size, kcheckers_size, full_group_size;
+	long result;
+
+	if (!task_no_new_privs(current) &&
+	    security_capable_noaudit(current_cred(),
+				     current_user_ns(), CAP_SYS_ADMIN) != 0)
+		return -EACCES;
+	if (flags != 0 || !group)
+		return -EINVAL;
+
+#ifdef CONFIG_COMPAT
+	if (is_compat_task()) {
+		struct compat_seccomp_checker_group kgroup32;
+
+		if (copy_from_user(&kgroup32, group, sizeof(kgroup32)))
+			return -EFAULT;
+		kgroup.version = kgroup32.version;
+		kgroup.id = kgroup32.id;
+		kgroup.len = kgroup32.len;
+		kgroup.checkers = compat_ptr(kgroup32.checkers);
+	} else			/* Falls through to the if below */
+#endif /* CONFIG_COMPAT */
+	if (copy_from_user(&kgroup, group, sizeof(kgroup)))
+		return -EFAULT;
+
+	if (kgroup.version != 1)
+		return -EINVAL;
+	/* The group ID 0 means no evaluated checkers */
+	if (kgroup.id == 0)
+		return -EINVAL;
+	if (kgroup.len == 0)
+		return -EINVAL;
+	if (kgroup.len > SECCOMP_CHECKERS_MAX)
+		return -E2BIG;
+
+	/* Validate resulting checker_group ID and length. */
+	group_size = sizeof(*filter_group) +
+		kgroup.len * sizeof(filter_group->checkers[0]);
+	full_group_size = group_size;
+	for (walker = current->seccomp.checker_group;
+			walker; walker = walker->prev) {
+		if (walker->id == kgroup.id)
+			return -EINVAL;
+		/* TODO: add penalty? */
+		full_group_size += sizeof(*walker) +
+			walker->checkers_len * sizeof(walker->checkers[0]);
+	}
+	if (full_group_size > SECCOMP_GROUP_CHECKERS_MAX_SIZE)
+		return -ENOMEM;
+
+	kcheckers_size = kgroup.len * sizeof((*kcheckers)[0]);
+	kcheckers = kmalloc(kcheckers_size, GFP_KERNEL);
+	if (!kcheckers)
+		return -ENOMEM;
+
+#ifdef CONFIG_COMPAT
+	if (is_compat_task()) {
+		unsigned int i, kcheckers32_size;
+		struct compat_seccomp_checker (*kcheckers32)[];
+
+		kcheckers32_size = kgroup.len * sizeof((*kcheckers32)[0]);
+		kcheckers32 = kmalloc(kcheckers32_size, GFP_KERNEL);
+		if (!kcheckers32) {
+			result = -ENOMEM;
+			goto free_kcheckers;
+		}
+		if (copy_from_user(kcheckers32, kgroup.checkers, kcheckers32_size)) {
+			kfree(kcheckers32);
+			result = -EFAULT;
+			goto free_kcheckers;
+		}
+		for (i = 0; i < kgroup.len; i++) {
+			(*kcheckers)[i].check = (*kcheckers32)[i].check;
+			(*kcheckers)[i].type = (*kcheckers32)[i].type;
+			(*kcheckers)[i].len = (*kcheckers32)[i].len;
+			(*kcheckers)[i].object_path = compat_ptr((*kcheckers32)[i].checker);
+		}
+		kfree(kcheckers32);
+	} else			/* Falls through to the if below */
+#endif /* CONFIG_COMPAT */
+	if (copy_from_user(kcheckers, kgroup.checkers, kcheckers_size)) {
+		result = -EFAULT;
+		goto free_kcheckers;
+	}
+
+	/* filter_group->checkers must be zeroed to correctly be freed on error */
+	filter_group = kzalloc(group_size, GFP_KERNEL);
+	if (!filter_group) {
+		result = -ENOMEM;
+		goto free_kcheckers;
+	}
+	filter_group->prev = NULL;
+	filter_group->id = kgroup.id;
+	filter_group->checkers_len = kgroup.len;
+	for (i = 0; i < filter_group->checkers_len; i++) {
+		user_checker = &(*kcheckers)[i];
+		kernel_obj = &filter_group->checkers[i];
+		switch (user_checker->check) {
+		case SECCOMP_CHECK_FS_LITERAL:
+		case SECCOMP_CHECK_FS_BENEATH:
+			kernel_obj->check = user_checker->check;
+			result =
+			    seccomp_set_argcheck_fs(user_checker, kernel_obj);
+			if (result)
+				goto free_group;
+			break;
+		default:
+			result = -EINVAL;
+			goto free_group;
+		}
+	}
+
+	atomic_set(&filter_group->usage, 1);
+	filter_group->prev = current->seccomp.checker_group;
+	/* No need to update filter_group->prev->usage because it get one
+	 * reference from this filter but lose one from
+	 * current->seccomp.checker_group.
+	 */
+	current->seccomp.checker_group = filter_group;
+	/* XXX: Return the number of groups? */
+	result = 0;
+	goto free_kcheckers;
+
+free_group:
+	for (i = 0; i < filter_group->checkers_len; i++) {
+		kernel_obj = &filter_group->checkers[i];
+		if (kernel_obj->type)
+			put_seccomp_obj(kernel_obj);
+	}
+	kfree(filter_group);
+
+free_kcheckers:
+	kfree(kcheckers);
+	return result;
+}
+#endif /* CONFIG_SECURITY_SECCOMP */
+
 /* Common entry point for both prctl and syscall. */
 static long do_seccomp(unsigned int op, unsigned int flags,
 		       const char __user *uargs)
@@ -824,6 +1041,10 @@ static long do_seccomp(unsigned int op, unsigned int flags,
 		return seccomp_set_mode_strict();
 	case SECCOMP_SET_MODE_FILTER:
 		return seccomp_set_mode_filter(flags, uargs);
+#ifdef CONFIG_SECURITY_SECCOMP
+	case SECCOMP_ADD_CHECKER_GROUP:
+		return seccomp_add_checker_group(flags, uargs);
+#endif /* CONFIG_SECURITY_SECCOMP */
 	default:
 		return -EINVAL;
 	}
diff --git a/security/seccomp/Makefile b/security/seccomp/Makefile
index f2e848d81138..1ed68b23a922 100644
--- a/security/seccomp/Makefile
+++ b/security/seccomp/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_SECURITY_SECCOMP) := seccomp.o
 
-seccomp-y := lsm.o
+seccomp-y := lsm.o checker_fs.o
diff --git a/security/seccomp/checker_fs.c b/security/seccomp/checker_fs.c
new file mode 100644
index 000000000000..c11efc892de5
--- /dev/null
+++ b/security/seccomp/checker_fs.c
@@ -0,0 +1,102 @@
+/*
+ * Seccomp Linux Security Module - File System Checkers
+ *
+ * Copyright (C) 2016  Mickaël Salaün <mic@digikod.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/compat.h>
+#include <linux/namei.h>	/* user_lpath() */
+#include <linux/path.h>
+#include <linux/seccomp.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>	/* copy_from_user() */
+
+#ifdef CONFIG_COMPAT
+/* struct seccomp_object_path */
+struct compat_seccomp_object_path {
+	__u32 flags;
+	compat_uptr_t path;	/* const char * */
+};
+#endif
+
+static const u32 path_flags_mask_literal =
+	SECCOMP_OBJFLAG_FS_DENTRY |
+	SECCOMP_OBJFLAG_FS_INODE |
+	SECCOMP_OBJFLAG_FS_DEVICE |
+	SECCOMP_OBJFLAG_FS_MOUNT |
+	SECCOMP_OBJFLAG_FS_NOFOLLOW;
+
+static const u32 path_flags_mask_beneath =
+	SECCOMP_OBJFLAG_FS_DENTRY |
+	SECCOMP_OBJFLAG_FS_INODE |
+	SECCOMP_OBJFLAG_FS_NOFOLLOW;
+
+/* Return true for any error, or false if flags are OK. */
+static bool wrong_check_flags(u32 check, u32 flags)
+{
+	u32 path_flags_mask;
+
+	/* Do not allow insecure check: inode without device */
+	if ((flags & SECCOMP_OBJFLAG_FS_INODE) &&
+	    !(flags & SECCOMP_OBJFLAG_FS_DEVICE))
+		return true;
+
+	switch (check) {
+	case SECCOMP_CHECK_FS_LITERAL:
+		path_flags_mask = path_flags_mask_literal;
+		break;
+	case SECCOMP_CHECK_FS_BENEATH:
+		path_flags_mask = path_flags_mask_beneath;
+		break;
+	default:
+		WARN_ON(1);
+		return true;
+	}
+	/* Need at least one flag, but only in the allowed mask */
+	return !(flags & path_flags_mask) ||
+		((flags | path_flags_mask) != path_flags_mask);
+}
+
+static long set_argtype_path(const struct seccomp_checker *user_checker,
+			     struct seccomp_filter_checker *kernel_checker)
+{
+	struct seccomp_object_path user_cp;
+
+	/* @len is not used for @object_path */
+	if (user_checker->len != 0)
+		return -EINVAL;
+
+#ifdef CONFIG_COMPAT
+	if (is_compat_task()) {
+		struct compat_seccomp_object_path user_cp32;
+
+		if (copy_from_user(&user_cp32, user_checker->object_path, sizeof(user_cp32)))
+			return -EFAULT;
+		user_cp.flags = user_cp32.flags;
+		user_cp.path = compat_ptr(user_cp32.path);
+	} else			/* Falls through to the if below */
+#endif
+	if (copy_from_user(&user_cp, user_checker->object_path, sizeof(user_cp)))
+		return -EFAULT;
+
+	if (wrong_check_flags(kernel_checker->check, user_cp.flags))
+		return -EINVAL;
+	kernel_checker->object_path.flags = user_cp.flags;
+	/* Do not follow symlinks for objects */
+	return user_lpath(user_cp.path, &kernel_checker->object_path.path);
+}
+
+long seccomp_set_argcheck_fs(const struct seccomp_checker *user_checker,
+			     struct seccomp_filter_checker *kernel_checker)
+{
+	switch (user_checker->type) {
+	case SECCOMP_OBJTYPE_PATH:
+		kernel_checker->type = user_checker->type;
+		return set_argtype_path(user_checker, kernel_checker);
+	}
+	return -EINVAL;
+}
-- 
2.8.0.rc3
