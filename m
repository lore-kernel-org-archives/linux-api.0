From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [RFC v1 16/17] security/seccomp: Protect against filesystem TOCTOU
Date: Thu, 24 Mar 2016 03:54:01 +0100
Message-ID: <1458788042-26173-8-git-send-email-mic@digikod.net>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
 <1458788042-26173-1-git-send-email-mic@digikod.net>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-2846-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1458788042-26173-1-git-send-email-mic@digikod.net>
To: linux-security-module@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Will Drewry <wad@chromium.org>, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Detect a TOCTOU race condition attack on the filesystem by checking if
the effective syscall (i.e. LSM hooks) see the same files as previously
checked by the seccomp filter.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: David Drysdale <drysdale@google.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <pmoore@redhat.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Will Drewry <wad@chromium.org>
---
 include/linux/seccomp.h       |  27 ++++++++
 kernel/fork.c                 |   2 +
 kernel/seccomp.c              | 103 +++++++++++++++++++++++++++-
 security/seccomp/checker_fs.c | 153 ++++++++++++++++++++++++++++++++++++++++++
 security/seccomp/checker_fs.h |  18 +++++
 security/seccomp/lsm.c        |  48 +++++++++++++
 6 files changed, 350 insertions(+), 1 deletion(-)
 create mode 100644 security/seccomp/checker_fs.h

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 0c5468f78945..8ea63813ca64 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -13,7 +13,9 @@
 
 struct seccomp_filter;
 struct seccomp_filter_checker_group;
+struct seccomp_argeval_checked;
 struct seccomp_argeval_cache;
+struct seccomp_argeval_syscall;
 
 /**
  * struct seccomp - the state of a seccomp'ed process
@@ -38,7 +40,9 @@ struct seccomp {
 	struct seccomp_filter_checker_group *checker_group;
 
 	/* syscall-lifetime data */
+	struct seccomp_argeval_checked *arg_checked;
 	struct seccomp_argeval_cache *arg_cache;
+	struct seccomp_argeval_syscall *orig_syscall;
 #endif
 };
 
@@ -153,6 +157,14 @@ struct seccomp_argeval_cache_fs {
 	u64 hash_len;
 };
 
+struct seccomp_argeval_history {
+	/* @checker point to current.seccomp->checker_group->checkers[] */
+	struct seccomp_filter_checker *checker;
+	u8 asked;
+	u8 result;
+	struct seccomp_argeval_history *next;
+};
+
 /**
  * struct seccomp_argeval_cache_entry
  *
@@ -178,6 +190,13 @@ struct seccomp_argeval_cache {
 	struct seccomp_argeval_cache *next;
 };
 
+/* Use get_argrule_checker() */
+struct seccomp_argeval_checked {
+	u32 check;
+	struct seccomp_argeval_history *history;
+	struct seccomp_argeval_checked *next;
+};
+
 void put_seccomp_filter_checker(struct seccomp_filter_checker *);
 
 u8 seccomp_argrule_path(const u8(*)[6], const u64(*)[6], u8,
@@ -186,6 +205,14 @@ u8 seccomp_argrule_path(const u8(*)[6], const u64(*)[6], u8,
 long seccomp_set_argcheck_fs(const struct seccomp_checker *,
 			     struct seccomp_filter_checker *);
 
+/* Need to save syscall properties to be able to properly recheck the filters
+ * even if the syscall and its arguments has been tampered by a tracer process.
+ */
+struct seccomp_argeval_syscall {
+	int nr;
+	u64 args[6];
+};
+
 #endif /* CONFIG_SECURITY_SECCOMP */
 
 #else  /* CONFIG_SECCOMP_FILTER */
diff --git a/kernel/fork.c b/kernel/fork.c
index b8155ebdd308..f41912acd755 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -361,7 +361,9 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	tsk->seccomp.filter = NULL;
 #ifdef CONFIG_SECURITY_SECCOMP
 	tsk->seccomp.checker_group = NULL;
+	tsk->seccomp.arg_checked = NULL;
 	tsk->seccomp.arg_cache = NULL;
+	tsk->seccomp.orig_syscall = NULL;
 #endif /* CONFIG_SECURITY_SECCOMP */
 #endif /* CONFIG_SECCOMP */
 
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index a8a6ba31ecc4..735b7caf4e06 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -286,6 +286,40 @@ struct syscall_argdesc *syscall_nr_to_argdesc(int nr)
 	return &(*seccomp_sa)[nr];
 }
 
+/* Return a new empty history entry for the check type or NULL if ENOMEM */
+static struct seccomp_argeval_history *new_argeval_history(u32 check)
+{
+	struct seccomp_argeval_checked **arg_checked;
+	struct seccomp_argeval_history **history;
+	bool found = false;
+
+	/* Find the check type */
+	arg_checked = &current->seccomp.arg_checked;
+	while (*arg_checked) {
+		if ((*arg_checked)->check == check) {
+			found = true;
+			break;
+		}
+		arg_checked = &(*arg_checked)->next;
+	}
+	if (!found) {
+		*arg_checked = kmalloc(sizeof(**arg_checked), GFP_KERNEL);
+		if (!*arg_checked)
+			return NULL;
+		(*arg_checked)->check = check;
+		(*arg_checked)->history = NULL;
+		(*arg_checked)->next = NULL;
+	}
+
+	/* Append to history */
+	history = &(*arg_checked)->history;
+	while (*history)
+		history = &(*history)->next;
+	*history = kzalloc(sizeof(**history), GFP_KERNEL);
+
+	return *history;
+}
+
 /* Return the argument group address that match the group ID, or NULL
  * otherwise.
  */
@@ -299,6 +333,7 @@ static struct seccomp_filter_checker_group *seccomp_update_argrule_data(
 	const struct syscall_argdesc *argdesc;
 	struct seccomp_filter_checker *checker;
 	seccomp_argrule_t *engine;
+	struct seccomp_argeval_history *history;
 
 	const u8 group_id = ret_data & SECCOMP_RET_CHECKER_GROUP;
 	const u8 to_check = (ret_data & SECCOMP_RET_ARG_MATCHES) >> 8;
@@ -327,6 +362,17 @@ static struct seccomp_filter_checker_group *seccomp_update_argrule_data(
 		if (engine) {
 			match = (*engine)(&argdesc->args, &sd->args, to_check, checker);
 
+			/* Append the results to be able to replay the checks */
+			history = new_argeval_history(checker->check);
+			if (!history) {
+				/* XXX: return -ENOMEM somehow? */
+				break;
+			}
+			history->checker = checker;
+			history->asked = to_check;
+			history->result = match;
+
+			/* Store the matches after the history record */
 			for (j = 0; j < 6; j++) {
 				sd->arg_matches[j] |=
 				    ((BIT_ULL(j) & match) >> j) << i;
@@ -375,6 +421,39 @@ void flush_seccomp_cache(struct task_struct *tsk)
 	free_seccomp_argeval_cache(tsk->seccomp.arg_cache);
 	tsk->seccomp.arg_cache = NULL;
 }
+
+static void free_seccomp_argeval_history(struct seccomp_argeval_history *history)
+{
+	struct seccomp_argeval_history *walker = history;
+
+	while (walker) {
+		struct seccomp_argeval_history *freeme = walker;
+
+		/* Must not free history->checker owned by
+		 * current.seccomp->checker_group->checkers[]
+		 */
+		walker = walker->next;
+		kfree(freeme);
+	}
+}
+
+static void free_seccomp_argeval_checked(struct seccomp_argeval_checked *checked)
+{
+	struct seccomp_argeval_checked *walker = checked;
+
+	while (walker) {
+		struct seccomp_argeval_checked *freeme = walker;
+
+		free_seccomp_argeval_history(walker->history);
+		walker = walker->next;
+		kfree(freeme);
+	}
+}
+
+static inline void free_seccomp_argeval_syscall(struct seccomp_argeval_syscall *orig_syscall)
+{
+	kfree(orig_syscall);
+}
 #endif /* CONFIG_SECURITY_SECCOMP */
 
 static void put_seccomp_filter(struct task_struct *tsk);
@@ -405,7 +484,27 @@ static u32 seccomp_run_filters(struct seccomp_data *sd)
 		sd = &sd_local;
 	}
 #ifdef CONFIG_SECURITY_SECCOMP
-	/* Cleanup old (syscall-lifetime) cache */
+	/* Backup the current syscall and its arguments (used by the filters),
+	 * to not be misled in the LSM checks by a potential ptrace setregs
+	 * command.
+	 */
+	if (!current->seccomp.orig_syscall) {
+		current->seccomp.orig_syscall =
+		    kmalloc(sizeof(*current->seccomp.orig_syscall), GFP_KERNEL);
+		if (!current->seccomp.orig_syscall)
+			return SECCOMP_RET_KILL;
+	}
+	current->seccomp.orig_syscall->nr = sd->nr;
+	current->seccomp.orig_syscall->args[0] = sd->args[0];
+	current->seccomp.orig_syscall->args[1] = sd->args[1];
+	current->seccomp.orig_syscall->args[2] = sd->args[2];
+	current->seccomp.orig_syscall->args[3] = sd->args[3];
+	current->seccomp.orig_syscall->args[4] = sd->args[4];
+	current->seccomp.orig_syscall->args[5] = sd->args[5];
+
+	/* Cleanup old (syscall-lifetime) history and cache */
+	free_seccomp_argeval_checked(current->seccomp.arg_checked);
+	current->seccomp.arg_checked = NULL;
 	flush_seccomp_cache(current);
 #endif
 
@@ -786,7 +885,9 @@ void put_seccomp(struct task_struct *tsk)
 	put_seccomp_filter(tsk);
 #ifdef CONFIG_SECURITY_SECCOMP
 	/* Free in that order because of referenced checkers */
+	free_seccomp_argeval_checked(tsk->seccomp.arg_checked);
 	free_seccomp_argeval_cache(tsk->seccomp.arg_cache);
+	free_seccomp_argeval_syscall(tsk->seccomp.orig_syscall);
 	put_seccomp_checker_group(tsk->seccomp.checker_group);
 #endif
 }
diff --git a/security/seccomp/checker_fs.c b/security/seccomp/checker_fs.c
index 0a5ec3a204e7..994d889b0334 100644
--- a/security/seccomp/checker_fs.c
+++ b/security/seccomp/checker_fs.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <asm/syscall.h>	/* syscall_get_nr() */
 #include <linux/bitops.h>	/* BIT() */
 #include <linux/compat.h>
 #include <linux/namei.h>	/* user_lpath() */
@@ -17,6 +18,8 @@
 #include <linux/syscalls.h>	/* __SACT__CONST_CHAR_PTR */
 #include <linux/uaccess.h>	/* copy_from_user() */
 
+#include "checker_fs.h"
+
 #ifdef CONFIG_COMPAT
 /* struct seccomp_object_path */
 struct compat_seccomp_object_path {
@@ -330,6 +333,156 @@ out:
 	return ret;
 }
 
+/* argeval_find_args_file - return a bitmask of the syscall arguments matching
+ * a struct file and that have changed since the filter checks
+ *
+ * To match a file with a syscall argument, we get its path and deduce the
+ * corresponding user address (uptr). Then, if a match is found, the file's
+ * inode must match the cached inode, otherwise the access is denied if a
+ * second filter check doesn't match exactly the first one. This ensure the
+ * seccomp filter results are still the sames but a tracer process can still
+ * change the tracee syscall arguments.
+ *
+ * If the syscall take multiple paths and the same address is used but only one
+ * argument is checked by the filter, the inode will be checked for all paths
+ * with this same address, detecting a TOCTOU for all of them even if they were
+ * not evaluated by the filter.
+ */
+static u8 argeval_find_args_file(const struct file *file)
+{
+	const struct syscall_argdesc *argdesc;
+	struct dentry *dentry;
+	u8 result = 0;
+	struct seccomp_argeval_cache *arg_cache = current->seccomp.arg_cache;
+
+	if (unlikely(!file)) {
+		WARN_ON(1);
+		return 0;
+	}
+
+	/* Create the argument mask matching the uptr.
+	 * The syscall arguments may have been changed by a tracer.
+	 */
+	argdesc = syscall_nr_to_argdesc(syscall_get_nr(current,
+				task_pt_regs(current)));
+	if (unlikely(!argdesc)) {
+		WARN_ON(1);
+		return 0;
+	}
+	dentry = file->f_path.dentry;
+
+	/* Look in the cache for this path */
+	for (; arg_cache; arg_cache = arg_cache->next) {
+		struct seccomp_argeval_cache_entry *entry = arg_cache->entry;
+
+		switch (arg_cache->type) {
+		case SECCOMP_OBJTYPE_PATH:
+			/* Ignore the mount point to not be fooled by a
+			 * malicious one. Only look for a previously
+			 * seen dentry.
+			 */
+			for (; entry; entry = entry->next) {
+				/* Check for the same filename/argument.
+				 * If the hash and the length are the same
+				 * but the path is different we treat it
+				 * as a race-condition.
+				 */
+				if (entry->fs.hash_len !=
+				    dentry->d_name.hash_len)
+					continue;
+				/* Ignore exact match (i.e. pointed file didn't
+				 * change)
+				 */
+				if (entry->fs.path
+				    && entry->fs.path->dentry == dentry)
+					continue;
+				/* TODO: Add process info/audit */
+				pr_warn("seccomp: TOCTOU race-condition detected!\n");
+				result |= entry->args;
+			}
+			break;
+		default:
+			WARN_ON(1);
+		}
+	}
+	return result;
+}
+
+/**
+ * argeval_history_recheck_file - recheck with the seccomp filters if needed
+ */
+static bool argeval_history_recheck_file(const struct seccomp_argeval_history
+					 *history, seccomp_argrule_t *engine,
+					 const struct syscall_argdesc *argdesc,
+					 const u64(*args)[6], u8 arg_matches)
+{
+	/* Flush the cache to not rely on the first seccomp filter check
+	 * results
+	 */
+	flush_seccomp_cache(current);
+
+	while (history) {
+		/* Only check the changed arguments */
+		if (history->asked & arg_matches) {
+			u8 match = (*engine)(&argdesc->args, args,
+					history->asked, history->checker);
+
+			if (match != history->result)
+				return true;
+		}
+		history = history->next;
+	}
+	return false;
+}
+
+int seccomp_check_file(const struct file *file)
+{
+	int result = -EPERM;
+	const struct syscall_argdesc *argdesc;
+	struct seccomp_argeval_syscall *orig_syscall;
+	struct seccomp_argeval_checked *arg_checked;
+	seccomp_argrule_t *engine;
+	u8 arg_matches;
+
+	/* @file may be null (e.g. security_mmap_file) */
+	if (!file)
+		return 0;
+	/* Early check to exit quickly if no history */
+	arg_checked = current->seccomp.arg_checked;
+	if (!arg_checked)
+		return 0;
+	orig_syscall = current->seccomp.orig_syscall;
+	if (unlikely(!orig_syscall)) {
+		WARN_ON(1);
+		return 0;
+	}
+	/* Check if anything changed from the cache */
+	arg_matches = argeval_find_args_file(file);
+	if (!arg_matches)
+		return 0;
+	/* The syscall may have been changed by the tracer process */
+	argdesc = syscall_nr_to_argdesc(orig_syscall->nr);
+	if (!argdesc) {
+		WARN_ON(1);
+		goto out;
+	}
+	do {
+		engine = get_argrule_checker(arg_checked->check);
+		/* The syscall arguments may have been changed by the tracer
+		 * process
+		 */
+		/* FIXME: Adapt the checker to "struct file *" to avoid races */
+		result =
+		    argeval_history_recheck_file(arg_checked->history, engine,
+						 argdesc, &orig_syscall->args,
+						 arg_matches) ? -EPERM : 0;
+		arg_checked = arg_checked->next;
+	} while (arg_checked);
+
+out:
+	return result;
+}
+
 static long set_argtype_path(const struct seccomp_checker *user_checker,
 			     struct seccomp_filter_checker *kernel_checker)
 {
diff --git a/security/seccomp/checker_fs.h b/security/seccomp/checker_fs.h
new file mode 100644
index 000000000000..7ac102b510ec
--- /dev/null
+++ b/security/seccomp/checker_fs.h
@@ -0,0 +1,18 @@
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
+#ifndef _SECURITY_SECCOMP_CHECKER_FS_H
+#define _SECURITY_SECCOMP_CHECKER_FS_H
+
+#include <linux/fs.h>
+
+int seccomp_check_file(const struct file *);
+
+#endif /* _SECURITY_SECCOMP_CHECKER_FS_H */
diff --git a/security/seccomp/lsm.c b/security/seccomp/lsm.c
index 93c881724341..7bde63505dbd 100644
--- a/security/seccomp/lsm.c
+++ b/security/seccomp/lsm.c
@@ -10,9 +10,13 @@
 
 #include <asm/syscall.h>	/* sys_call_table */
 #include <linux/compat.h>
+#include <linux/cred.h>
+#include <linux/fs.h>
+#include <linux/lsm_hooks.h>
 #include <linux/slab.h>	/* kcalloc() */
 #include <linux/syscalls.h>	/* syscall_argdesc */
 
+#include "checker_fs.h"
 #include "lsm.h"
 
 /* TODO: Remove the need for CONFIG_SYSFS dependency */
@@ -22,6 +26,49 @@ struct syscall_argdesc (*seccomp_syscalls_argdesc)[] = NULL;
 struct syscall_argdesc (*compat_seccomp_syscalls_argdesc)[] = NULL;
 #endif	/* CONFIG_COMPAT */
 
+#define SECCOMP_HOOK(CHECK, NAME, ...)				\
+	static inline int seccomp_hook_##NAME(__VA_ARGS__)	\
+	{ 							\
+		return seccomp_check_##CHECK(CHECK);		\
+	}
+
+#define SECCOMP_HOOK_INIT(NAME) LSM_HOOK_INIT(NAME, seccomp_hook_##NAME)
+
+/* TODO: file_set_fowner, file_alloc_security? */
+
+SECCOMP_HOOK(file, binder_transfer_file, struct task_struct *from, struct task_struct *to, struct file *file)
+SECCOMP_HOOK(file, file_permission, struct file *file, int mask)
+SECCOMP_HOOK(file, file_ioctl, struct file *file, unsigned int cmd, unsigned long arg)
+SECCOMP_HOOK(file, mmap_file, struct file *file, unsigned long reqprot, unsigned long prot, unsigned long flags)
+SECCOMP_HOOK(file, file_lock, struct file *file, unsigned int cmd)
+SECCOMP_HOOK(file, file_fcntl, struct file *file, unsigned int cmd, unsigned long arg)
+SECCOMP_HOOK(file, file_receive, struct file *file)
+SECCOMP_HOOK(file, file_open, struct file *file, const struct cred *cred)
+SECCOMP_HOOK(file, kernel_fw_from_file, struct file *file, char *buf, size_t size)
+SECCOMP_HOOK(file, kernel_module_from_file, struct file *file)
+
+/* TODO: Add hooks with:
+ * - struct dentry *
+ * - struct path *
+ * - struct inode *
+ * ...
+ */
+
+
+static struct security_hook_list seccomp_hooks[] = {
+	SECCOMP_HOOK_INIT(binder_transfer_file),
+	SECCOMP_HOOK_INIT(file_permission),
+	SECCOMP_HOOK_INIT(file_ioctl),
+	SECCOMP_HOOK_INIT(mmap_file),
+	SECCOMP_HOOK_INIT(file_lock),
+	SECCOMP_HOOK_INIT(file_fcntl),
+	SECCOMP_HOOK_INIT(file_receive),
+	SECCOMP_HOOK_INIT(file_open),
+	SECCOMP_HOOK_INIT(kernel_fw_from_file),
+	SECCOMP_HOOK_INIT(kernel_module_from_file),
+};
+
+
 static const struct syscall_argdesc *__init
 find_syscall_argdesc(const struct syscall_argdesc *start,
 		const struct syscall_argdesc *stop, const void *addr)
@@ -84,4 +131,5 @@ void __init seccomp_init(void)
 {
 	pr_info("seccomp: Becoming ready for sandboxing\n");
 	init_argdesc();
+	security_add_hooks(seccomp_hooks, ARRAY_SIZE(seccomp_hooks));
 }
-- 
2.8.0.rc3
