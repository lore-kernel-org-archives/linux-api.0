From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH bpf-next v8 05/11] seccomp,landlock: Enforce Landlock programs per process hierarchy
Date: Tue, 27 Feb 2018 01:41:15 +0100
Message-ID: <20180227004121.3633-6-mic@digikod.net>
References: <20180227004121.3633-1-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-11975-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20180227004121.3633-1-mic@digikod.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Tycho
List-Id: linux-api@vger.kernel.org

The seccomp(2) syscall can be used by a task to apply a Landlock program
to itself. As a seccomp filter, a Landlock program is enforced for the
current task and all its future children. A program is immutable and a
task can only add new restricting programs to itself, forming a list of
programss.

A Landlock program is tied to a Landlock hook. If the action on a kernel
object is allowed by the other Linux security mechanisms (e.g. DAC,
capabilities, other LSM), then a Landlock hook related to this kind of
object is triggered. The list of programs for this hook is then
evaluated. Each program return a 32-bit value which can deny the action
on a kernel object with a non-zero value. If every programs of the list
return zero, then the action on the object is allowed.

Multiple Landlock programs can be chained to share a 64-bits value for a
call chain (e.g. evaluating multiple elements of a file path).  This
chaining is restricted when a process construct this chain by loading a
program, but additional checks are performed when it requests to apply
this chain of programs to itself.  The restrictions ensure that it is
not possible to call multiple programs in a way that would imply to
handle multiple shared values (i.e. cookies) for one chain.  For now,
only a fs_pick program can be chained to the same type of program,
because it may make sense if they have different triggers (cf. next
commits).  This restrictions still allows to reuse Landlock programs in
a safe way (e.g. use the same loaded fs_walk program with multiple
chains of fs_pick programs).

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Will Drewry <wad@chromium.org>
Link: https://lkml.kernel.org/r/c10a503d-5e35-7785-2f3d-25ed8dd63fab@digikod.net
---

Changes since v7:
* handle and verify program chains
* split and rename providers.c to enforce.c and enforce_seccomp.c
* rename LANDLOCK_SUBTYPE_* to LANDLOCK_*

Changes since v6:
* rename some functions with more accurate names to reflect that an eBPF
  program for Landlock could be used for something else than a rule
* reword rule "appending" to "prepending" and explain it
* remove the superfluous no_new_privs check, only check global
  CAP_SYS_ADMIN when prepending a Landlock rule (needed for containers)
* create and use {get,put}_seccomp_landlock() (suggested by Kees Cook)
* replace ifdef with static inlined function (suggested by Kees Cook)
* use get_user() (suggested by Kees Cook)
* replace atomic_t with refcount_t (requested by Kees Cook)
* move struct landlock_{rule,events} from landlock.h to common.h
* cleanup headers

Changes since v5:
* remove struct landlock_node and use a similar inheritance mechanisme
  as seccomp-bpf (requested by Andy Lutomirski)
* rename SECCOMP_ADD_LANDLOCK_RULE to SECCOMP_APPEND_LANDLOCK_RULE
* rename file manager.c to providers.c
* add comments
* typo and cosmetic fixes

Changes since v4:
* merge manager and seccomp patches
* return -EFAULT in seccomp(2) when user_bpf_fd is null to easely check
  if Landlock is supported
* only allow a process with the global CAP_SYS_ADMIN to use Landlock
  (will be lifted in the future)
* add an early check to exit as soon as possible if the current process
  does not have Landlock rules

Changes since v3:
* remove the hard link with seccomp (suggested by Andy Lutomirski and
  Kees Cook):
  * remove the cookie which could imply multiple evaluation of Landlock
    rules
  * remove the origin field in struct landlock_data
* remove documentation fix (merged upstream)
* rename the new seccomp command to SECCOMP_ADD_LANDLOCK_RULE
* internal renaming
* split commit
* new design to be able to inherit on the fly the parent rules

Changes since v2:
* Landlock programs can now be run without seccomp filter but for any
  syscall (from the process) or interruption
* move Landlock related functions and structs into security/landlock/*
  (to manage cgroups as well)
* fix seccomp filter handling: run Landlock programs for each of their
  legitimate seccomp filter
* properly clean up all seccomp results
* cosmetic changes to ease the understanding
* fix some ifdef
---
 include/linux/landlock.h            |  37 ++++
 include/linux/seccomp.h             |   5 +
 include/uapi/linux/seccomp.h        |   1 +
 kernel/fork.c                       |   8 +-
 kernel/seccomp.c                    |   4 +
 security/landlock/Makefile          |   3 +-
 security/landlock/chain.c           |  39 ++++
 security/landlock/chain.h           |  35 ++++
 security/landlock/common.h          |  53 +++++
 security/landlock/enforce.c         | 386 ++++++++++++++++++++++++++++++++++++
 security/landlock/enforce.h         |  21 ++
 security/landlock/enforce_seccomp.c | 102 ++++++++++
 12 files changed, 692 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/landlock.h
 create mode 100644 security/landlock/chain.c
 create mode 100644 security/landlock/chain.h
 create mode 100644 security/landlock/enforce.c
 create mode 100644 security/landlock/enforce.h
 create mode 100644 security/landlock/enforce_seccomp.c

diff --git a/include/linux/landlock.h b/include/linux/landlock.h
new file mode 100644
index 000000000000..933d65c00075
--- /dev/null
+++ b/include/linux/landlock.h
@@ -0,0 +1,37 @@
+/*
+ * Landlock LSM - public kernel headers
+ *
+ * Copyright © 2016-2018 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018 ANSSI
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _LINUX_LANDLOCK_H
+#define _LINUX_LANDLOCK_H
+
+#include <linux/errno.h>
+#include <linux/sched.h> /* task_struct */
+
+#if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_SECURITY_LANDLOCK)
+extern int landlock_seccomp_prepend_prog(unsigned int flags,
+		const int __user *user_bpf_fd);
+extern void put_seccomp_landlock(struct task_struct *tsk);
+extern void get_seccomp_landlock(struct task_struct *tsk);
+#else /* CONFIG_SECCOMP_FILTER && CONFIG_SECURITY_LANDLOCK */
+static inline int landlock_seccomp_prepend_prog(unsigned int flags,
+		const int __user *user_bpf_fd)
+{
+		return -EINVAL;
+}
+static inline void put_seccomp_landlock(struct task_struct *tsk)
+{
+}
+static inline void get_seccomp_landlock(struct task_struct *tsk)
+{
+}
+#endif /* CONFIG_SECCOMP_FILTER && CONFIG_SECURITY_LANDLOCK */
+
+#endif /* _LINUX_LANDLOCK_H */
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index c723a5c4e3ff..dedad0d5b664 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -9,6 +9,7 @@
 
 #ifdef CONFIG_SECCOMP
 
+#include <linux/landlock.h>
 #include <linux/thread_info.h>
 #include <asm/seccomp.h>
 
@@ -20,6 +21,7 @@ struct seccomp_filter;
  *         system calls available to a process.
  * @filter: must always point to a valid seccomp-filter or NULL as it is
  *          accessed without locking during system call entry.
+ * @landlock_prog_set: contains a set of Landlock programs.
  *
  *          @filter must only be accessed from the context of current as there
  *          is no read locking.
@@ -27,6 +29,9 @@ struct seccomp_filter;
 struct seccomp {
 	int mode;
 	struct seccomp_filter *filter;
+#if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_SECURITY_LANDLOCK)
+	struct landlock_prog_set *landlock_prog_set;
+#endif /* CONFIG_SECCOMP_FILTER && CONFIG_SECURITY_LANDLOCK */
 };
 
 #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 2a0bd9dd104d..a4927638be82 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -15,6 +15,7 @@
 #define SECCOMP_SET_MODE_STRICT		0
 #define SECCOMP_SET_MODE_FILTER		1
 #define SECCOMP_GET_ACTION_AVAIL	2
+#define SECCOMP_PREPEND_LANDLOCK_PROG	3
 
 /* Valid flags for SECCOMP_SET_MODE_FILTER */
 #define SECCOMP_FILTER_FLAG_TSYNC	1
diff --git a/kernel/fork.c b/kernel/fork.c
index be8aa5b98666..5a5f8cbbfcb9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -48,6 +48,7 @@
 #include <linux/security.h>
 #include <linux/hugetlb.h>
 #include <linux/seccomp.h>
+#include <linux/landlock.h>
 #include <linux/swap.h>
 #include <linux/syscalls.h>
 #include <linux/jiffies.h>
@@ -385,6 +386,7 @@ void free_task(struct task_struct *tsk)
 	rt_mutex_debug_task_free(tsk);
 	ftrace_graph_exit_task(tsk);
 	put_seccomp_filter(tsk);
+	put_seccomp_landlock(tsk);
 	arch_release_task_struct(tsk);
 	if (tsk->flags & PF_KTHREAD)
 		free_kthread_struct(tsk);
@@ -814,7 +816,10 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 	 * the usage counts on the error path calling free_task.
 	 */
 	tsk->seccomp.filter = NULL;
-#endif
+#ifdef CONFIG_SECURITY_LANDLOCK
+	tsk->seccomp.landlock_prog_set = NULL;
+#endif /* CONFIG_SECURITY_LANDLOCK */
+#endif /* CONFIG_SECCOMP */
 
 	setup_thread_stack(tsk, orig);
 	clear_user_return_notifier(tsk);
@@ -1496,6 +1501,7 @@ static void copy_seccomp(struct task_struct *p)
 
 	/* Ref-count the new filter user, and assign it. */
 	get_seccomp_filter(current);
+	get_seccomp_landlock(current);
 	p->seccomp = current->seccomp;
 
 	/*
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 940fa408a288..47a37f6c0dcd 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -37,6 +37,7 @@
 #include <linux/security.h>
 #include <linux/tracehook.h>
 #include <linux/uaccess.h>
+#include <linux/landlock.h>
 
 /**
  * struct seccomp_filter - container for seccomp BPF programs
@@ -932,6 +933,9 @@ static long do_seccomp(unsigned int op, unsigned int flags,
 			return -EINVAL;
 
 		return seccomp_get_action_avail(uargs);
+	case SECCOMP_PREPEND_LANDLOCK_PROG:
+		return landlock_seccomp_prepend_prog(flags,
+				(const int __user *)uargs);
 	default:
 		return -EINVAL;
 	}
diff --git a/security/landlock/Makefile b/security/landlock/Makefile
index 7205f9a7a2ee..05fce359028e 100644
--- a/security/landlock/Makefile
+++ b/security/landlock/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
 
-landlock-y := init.o
+landlock-y := init.o chain.o \
+	enforce.o enforce_seccomp.o
diff --git a/security/landlock/chain.c b/security/landlock/chain.c
new file mode 100644
index 000000000000..805f4cb60e7e
--- /dev/null
+++ b/security/landlock/chain.c
@@ -0,0 +1,39 @@
+/*
+ * Landlock LSM - chain helpers
+ *
+ * Copyright © 2018 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018 ANSSI
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/refcount.h>
+#include <linux/slab.h>
+
+#include "chain.h"
+
+/* TODO: use a dedicated kmem_cache_alloc() instead of k*alloc() */
+
+/* never return NULL */
+struct landlock_chain *landlock_new_chain(u8 index)
+{
+	struct landlock_chain *chain;
+
+	chain = kzalloc(sizeof(*chain), GFP_KERNEL);
+	if (!chain)
+		return ERR_PTR(-ENOMEM);
+	chain->index = index;
+	refcount_set(&chain->usage, 1);
+	return chain;
+}
+
+void landlock_put_chain(struct landlock_chain *chain)
+{
+	if (!chain)
+		return;
+	if (!refcount_dec_and_test(&chain->usage))
+		return;
+	kfree(chain);
+}
diff --git a/security/landlock/chain.h b/security/landlock/chain.h
new file mode 100644
index 000000000000..a1497ee779a6
--- /dev/null
+++ b/security/landlock/chain.h
@@ -0,0 +1,35 @@
+/*
+ * Landlock LSM - chain headers
+ *
+ * Copyright © 2018 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018 ANSSI
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _SECURITY_LANDLOCK_CHAIN_H
+#define _SECURITY_LANDLOCK_CHAIN_H
+
+#include <linux/landlock.h> /* struct landlock_chain */
+#include <linux/refcount.h>
+
+/*
+ * @chain_index: index of the chain (defined by the user, different from a
+ *		 program list)
+ * @next: point to the next sibling in the same prog_set (used to match a chain
+ *	  against the current process)
+ * @index: index in the array dedicated to store data for a chain instance
+ */
+struct landlock_chain {
+	struct landlock_chain *next;
+	refcount_t usage;
+	u8 index;
+	u8 shared:1;
+};
+
+struct landlock_chain *landlock_new_chain(u8 index);
+void landlock_put_chain(struct landlock_chain *chain);
+
+#endif /* _SECURITY_LANDLOCK_CHAIN_H */
diff --git a/security/landlock/common.h b/security/landlock/common.h
index 0906678c0ed0..245e4ccafcf2 100644
--- a/security/landlock/common.h
+++ b/security/landlock/common.h
@@ -29,4 +29,57 @@
 #define _LANDLOCK_TRIGGER_FS_PICK_LAST	LANDLOCK_TRIGGER_FS_PICK_WRITE
 #define _LANDLOCK_TRIGGER_FS_PICK_MASK	((_LANDLOCK_TRIGGER_FS_PICK_LAST << 1ULL) - 1)
 
+struct landlock_chain;
+
+/*
+ * @is_last_of_type: in a chain of programs, it marks if this program is the
+ *		     last of its type
+ */
+struct landlock_prog_list {
+	struct landlock_prog_list *prev;
+	struct bpf_prog *prog;
+	struct landlock_chain *chain;
+	refcount_t usage;
+	u8 is_last_of_type:1;
+};
+
+/**
+ * struct landlock_prog_set - Landlock programs enforced on a thread
+ *
+ * This is used for low performance impact when forking a process. Instead of
+ * copying the full array and incrementing the usage of each entries, only
+ * create a pointer to &struct landlock_prog_set and increments its usage. When
+ * prepending a new program, if &struct landlock_prog_set is shared with other
+ * tasks, then duplicate it and prepend the program to this new &struct
+ * landlock_prog_set.
+ *
+ * @usage: reference count to manage the object lifetime. When a thread need to
+ *	   add Landlock programs and if @usage is greater than 1, then the
+ *	   thread must duplicate &struct landlock_prog_set to not change the
+ *	   children's programs as well.
+ * @chain_last: chain of the last prepended program
+ * @programs: array of non-NULL &struct landlock_prog_list pointers
+ */
+struct landlock_prog_set {
+	struct landlock_chain *chain_last;
+	struct landlock_prog_list *programs[_LANDLOCK_HOOK_LAST];
+	refcount_t usage;
+};
+
+/**
+ * get_index - get an index for the programs of struct landlock_prog_set
+ *
+ * @type: a Landlock hook type
+ */
+static inline int get_index(enum landlock_hook_type type)
+{
+	/* type ID > 0 for loaded programs */
+	return type - 1;
+}
+
+static inline enum landlock_hook_type get_type(struct bpf_prog *prog)
+{
+	return prog->aux->extra->subtype.landlock_hook.type;
+}
+
 #endif /* _SECURITY_LANDLOCK_COMMON_H */
diff --git a/security/landlock/enforce.c b/security/landlock/enforce.c
new file mode 100644
index 000000000000..8846cfd9aff7
--- /dev/null
+++ b/security/landlock/enforce.c
@@ -0,0 +1,386 @@
+/*
+ * Landlock LSM - enforcing helpers
+ *
+ * Copyright © 2016-2018 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018 ANSSI
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/barrier.h> /* smp_store_release() */
+#include <asm/page.h> /* PAGE_SIZE */
+#include <linux/bpf.h> /* bpf_prog_put() */
+#include <linux/compiler.h> /* READ_ONCE() */
+#include <linux/err.h> /* PTR_ERR() */
+#include <linux/errno.h>
+#include <linux/filter.h> /* struct bpf_prog */
+#include <linux/refcount.h>
+#include <linux/slab.h> /* alloc(), kfree() */
+
+#include "chain.h"
+#include "common.h" /* struct landlock_prog_list */
+
+/* TODO: use a dedicated kmem_cache_alloc() instead of k*alloc() */
+
+static void put_landlock_prog_list(struct landlock_prog_list *prog_list)
+{
+	struct landlock_prog_list *orig = prog_list;
+
+	/* clean up single-reference branches iteratively */
+	while (orig && refcount_dec_and_test(&orig->usage)) {
+		struct landlock_prog_list *freeme = orig;
+
+		if (orig->prog)
+			bpf_prog_put(orig->prog);
+		landlock_put_chain(orig->chain);
+		orig = orig->prev;
+		kfree(freeme);
+	}
+}
+
+void landlock_put_prog_set(struct landlock_prog_set *prog_set)
+{
+	if (prog_set && refcount_dec_and_test(&prog_set->usage)) {
+		size_t i;
+
+		for (i = 0; i < ARRAY_SIZE(prog_set->programs); i++)
+			put_landlock_prog_list(prog_set->programs[i]);
+		landlock_put_chain(prog_set->chain_last);
+		kfree(prog_set);
+	}
+}
+
+void landlock_get_prog_set(struct landlock_prog_set *prog_set)
+{
+	struct landlock_chain *chain;
+
+	if (!prog_set)
+		return;
+	refcount_inc(&prog_set->usage);
+	chain = prog_set->chain_last;
+	/* mark all inherited chains as (potentially) shared */
+	while (chain && !chain->shared) {
+		chain->shared = 1;
+		chain = chain->next;
+	}
+}
+
+static struct landlock_prog_set *new_landlock_prog_set(void)
+{
+	struct landlock_prog_set *ret;
+
+	/* array filled with NULL values */
+	ret = kzalloc(sizeof(*ret), GFP_KERNEL);
+	if (!ret)
+		return ERR_PTR(-ENOMEM);
+	refcount_set(&ret->usage, 1);
+	return ret;
+}
+
+/*
+ * If a program type is able to fork, this means that there is one amongst
+ * multiple programs (types) that may be called after, depending on the action
+ * type. This means that if a (sub)type has a "triggers" field (e.g. fs_pick),
+ * then it is forkable.
+ *
+ * Keep in sync with init.c:good_previous_prog().
+ */
+static bool is_hook_type_forkable(enum landlock_hook_type hook_type)
+{
+	switch (hook_type) {
+	case LANDLOCK_HOOK_FS_WALK:
+		return false;
+	case LANDLOCK_HOOK_FS_PICK:
+		/* can fork to fs_get or fs_ioctl... */
+		return true;
+	case LANDLOCK_HOOK_FS_GET:
+		return false;
+	}
+	WARN_ON(1);
+	return false;
+}
+
+/**
+ * store_landlock_prog - prepend and deduplicate a Landlock prog_list
+ *
+ * Prepend @prog to @init_prog_set while ignoring @prog and its chained programs
+ * if they are already in @ref_prog_set.  Whatever is the result of this
+ * function call, you can call bpf_prog_put(@prog) after.
+ *
+ * @init_prog_set: empty prog_set to prepend to
+ * @ref_prog_set: prog_set to check for duplicate programs
+ * @prog: program chain to prepend
+ *
+ * Return -errno on error or 0 if @prog was successfully stored.
+ */
+static int store_landlock_prog(struct landlock_prog_set *init_prog_set,
+		const struct landlock_prog_set *ref_prog_set,
+		struct bpf_prog *prog)
+{
+	struct landlock_prog_list *tmp_list = NULL;
+	int err;
+	u32 hook_idx;
+	bool new_is_last_of_type;
+	bool first = true;
+	struct landlock_chain *chain = NULL;
+	enum landlock_hook_type last_type;
+	struct bpf_prog *new = prog;
+
+	/* allocate all the memory we need */
+	for (; new; new = new->aux->extra->landlock_hook.previous) {
+		bool ignore = false;
+		struct landlock_prog_list *new_list;
+
+		new_is_last_of_type = first || (last_type != get_type(new));
+		last_type = get_type(new);
+		first = false;
+		/* ignore duplicate programs */
+		if (ref_prog_set) {
+			struct landlock_prog_list *ref;
+			struct bpf_prog *new_prev;
+
+			/*
+			 * The subtype verifier has already checked the
+			 * coherency of the program types chained in @new (cf.
+			 * good_previous_prog).
+			 *
+			 * Here we only allow linking to a chain if the common
+			 * program's type is able to fork (e.g. fs_pick) and
+			 * come from the same task (i.e. not shared).  This
+			 * program must also be the last one of its type in
+			 * both the @ref and the @new chains.  Finally, two
+			 * programs with the same parent must be of different
+			 * type.
+			 */
+			if (WARN_ON(!new->aux->extra))
+				continue;
+			new_prev = new->aux->extra->landlock_hook.previous;
+			hook_idx = get_index(get_type(new));
+			for (ref = ref_prog_set->programs[hook_idx];
+					ref; ref = ref->prev) {
+				struct bpf_prog *ref_prev;
+
+				ignore = (ref->prog == new);
+				if (ignore)
+					break;
+				ref_prev = ref->prog->aux->extra->
+					landlock_hook.previous;
+				/* deny fork to the same types */
+				if (new_prev && new_prev == ref_prev) {
+					err = -EINVAL;
+					goto put_tmp_list;
+				}
+			}
+			/* remaining programs are already in ref_prog_set */
+			if (ignore) {
+				bool is_forkable =
+					is_hook_type_forkable(get_type(new));
+
+				if (ref->chain->shared || !is_forkable ||
+						!new_is_last_of_type ||
+						!ref->is_last_of_type) {
+					err = -EINVAL;
+					goto put_tmp_list;
+				}
+				/* use the same session (i.e. cookie state) */
+				chain = ref->chain;
+				/* will increment the usage counter later */
+				break;
+			}
+		}
+
+		new = bpf_prog_inc(new);
+		if (IS_ERR(new)) {
+			err = PTR_ERR(new);
+			goto put_tmp_list;
+		}
+		new_list = kzalloc(sizeof(*new_list), GFP_KERNEL);
+		if (!new_list) {
+			bpf_prog_put(new);
+			err = -ENOMEM;
+			goto put_tmp_list;
+		}
+		/* ignore Landlock types in this tmp_list */
+		new_list->is_last_of_type = new_is_last_of_type;
+		new_list->prog = new;
+		new_list->prev = tmp_list;
+		refcount_set(&new_list->usage, 1);
+		tmp_list = new_list;
+	}
+
+	if (!tmp_list)
+		/* inform user space that this program was already added */
+		return -EEXIST;
+
+	if (!chain) {
+		u8 chain_index;
+
+		if (ref_prog_set) {
+			/* this is a new independent chain */
+			chain_index = ref_prog_set->chain_last->index + 1;
+			/* check for integer overflow */
+			if (chain_index < ref_prog_set->chain_last->index) {
+				err = -E2BIG;
+				goto put_tmp_list;
+			}
+		} else {
+			chain_index = 0;
+		}
+		chain = landlock_new_chain(chain_index);
+		if (IS_ERR(chain)) {
+			err = PTR_ERR(chain);
+			goto put_tmp_list;
+		}
+		/* no need to refcount_dec(&init_prog_set->chain_last) */
+	}
+	init_prog_set->chain_last = chain;
+
+	/* properly store the list (without error cases) */
+	while (tmp_list) {
+		struct landlock_prog_list *new_list;
+
+		new_list = tmp_list;
+		tmp_list = tmp_list->prev;
+		/* do not increment the previous prog list usage */
+		hook_idx = get_index(get_type(new_list->prog));
+		new_list->prev = init_prog_set->programs[hook_idx];
+		new_list->chain = chain;
+		refcount_inc(&chain->usage);
+		/* no need to add from the last program to the first because
+		 * each of them are a different Landlock type */
+		smp_store_release(&init_prog_set->programs[hook_idx], new_list);
+	}
+	return 0;
+
+put_tmp_list:
+	put_landlock_prog_list(tmp_list);
+	return err;
+}
+
+/* limit Landlock programs set to 256KB */
+#define LANDLOCK_PROGRAMS_MAX_PAGES (1 << 6)
+
+/**
+ * landlock_prepend_prog - attach a Landlock prog_list to @current_prog_set
+ *
+ * Whatever is the result of this function call, you can call
+ * bpf_prog_put(@prog) after.
+ *
+ * @current_prog_set: landlock_prog_set pointer, must be locked (if needed) to
+ *                    prevent a concurrent put/free. This pointer must not be
+ *                    freed after the call.
+ * @prog: non-NULL Landlock prog_list to prepend to @current_prog_set. @prog
+ *	  will be owned by landlock_prepend_prog() and freed if an error
+ *	  happened.
+ *
+ * Return @current_prog_set or a new pointer when OK. Return a pointer error
+ * otherwise.
+ */
+struct landlock_prog_set *landlock_prepend_prog(
+		struct landlock_prog_set *current_prog_set,
+		struct bpf_prog *prog)
+{
+	struct landlock_prog_set *new_prog_set = current_prog_set;
+	unsigned long pages;
+	int err;
+	size_t i;
+	struct landlock_prog_set tmp_prog_set = {};
+
+	if (prog->type != BPF_PROG_TYPE_LANDLOCK_HOOK)
+		return ERR_PTR(-EINVAL);
+
+	/* validate memory size allocation */
+	pages = prog->pages;
+	if (current_prog_set) {
+		size_t i;
+
+		for (i = 0; i < ARRAY_SIZE(current_prog_set->programs); i++) {
+			struct landlock_prog_list *walker_p;
+
+			for (walker_p = current_prog_set->programs[i];
+					walker_p; walker_p = walker_p->prev)
+				pages += walker_p->prog->pages;
+		}
+		/* count a struct landlock_prog_set if we need to allocate one */
+		if (refcount_read(&current_prog_set->usage) != 1)
+			pages += round_up(sizeof(*current_prog_set), PAGE_SIZE)
+				/ PAGE_SIZE;
+	}
+	if (pages > LANDLOCK_PROGRAMS_MAX_PAGES)
+		return ERR_PTR(-E2BIG);
+
+	/* ensure early that we can allocate enough memory for the new
+	 * prog_lists */
+	err = store_landlock_prog(&tmp_prog_set, current_prog_set, prog);
+	if (err)
+		return ERR_PTR(err);
+
+	/*
+	 * Each task_struct points to an array of prog list pointers.  These
+	 * tables are duplicated when additions are made (which means each
+	 * table needs to be refcounted for the processes using it). When a new
+	 * table is created, all the refcounters on the prog_list are bumped (to
+	 * track each table that references the prog). When a new prog is
+	 * added, it's just prepended to the list for the new table to point
+	 * at.
+	 *
+	 * Manage all the possible errors before this step to not uselessly
+	 * duplicate current_prog_set and avoid a rollback.
+	 */
+	if (!new_prog_set) {
+		/*
+		 * If there is no Landlock program set used by the current task,
+		 * then create a new one.
+		 */
+		new_prog_set = new_landlock_prog_set();
+		if (IS_ERR(new_prog_set))
+			goto put_tmp_lists;
+	} else if (refcount_read(&current_prog_set->usage) > 1) {
+		/*
+		 * If the current task is not the sole user of its Landlock
+		 * program set, then duplicate them.
+		 */
+		new_prog_set = new_landlock_prog_set();
+		if (IS_ERR(new_prog_set))
+			goto put_tmp_lists;
+		for (i = 0; i < ARRAY_SIZE(new_prog_set->programs); i++) {
+			new_prog_set->programs[i] =
+				READ_ONCE(current_prog_set->programs[i]);
+			if (new_prog_set->programs[i])
+				refcount_inc(&new_prog_set->programs[i]->usage);
+		}
+
+		/*
+		 * Landlock program set from the current task will not be freed
+		 * here because the usage is strictly greater than 1. It is
+		 * only prevented to be freed by another task thanks to the
+		 * caller of landlock_prepend_prog() which should be locked if
+		 * needed.
+		 */
+		landlock_put_prog_set(current_prog_set);
+	}
+
+	/* prepend tmp_prog_set to new_prog_set */
+	for (i = 0; i < ARRAY_SIZE(tmp_prog_set.programs); i++) {
+		/* get the last new list */
+		struct landlock_prog_list *last_list =
+			tmp_prog_set.programs[i];
+
+		if (last_list) {
+			while (last_list->prev)
+				last_list = last_list->prev;
+			/* no need to increment usage (pointer replacement) */
+			last_list->prev = new_prog_set->programs[i];
+			new_prog_set->programs[i] = tmp_prog_set.programs[i];
+		}
+	}
+	new_prog_set->chain_last = tmp_prog_set.chain_last;
+	return new_prog_set;
+
+put_tmp_lists:
+	for (i = 0; i < ARRAY_SIZE(tmp_prog_set.programs); i++)
+		put_landlock_prog_list(tmp_prog_set.programs[i]);
+	return new_prog_set;
+}
diff --git a/security/landlock/enforce.h b/security/landlock/enforce.h
new file mode 100644
index 000000000000..27de15d4ca3e
--- /dev/null
+++ b/security/landlock/enforce.h
@@ -0,0 +1,21 @@
+/*
+ * Landlock LSM - enforcing helpers headers
+ *
+ * Copyright © 2016-2018 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018 ANSSI
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _SECURITY_LANDLOCK_ENFORCE_H
+#define _SECURITY_LANDLOCK_ENFORCE_H
+
+struct landlock_prog_set *landlock_prepend_prog(
+		struct landlock_prog_set *current_prog_set,
+		struct bpf_prog *prog);
+void landlock_put_prog_set(struct landlock_prog_set *prog_set);
+void landlock_get_prog_set(struct landlock_prog_set *prog_set);
+
+#endif /* _SECURITY_LANDLOCK_ENFORCE_H */
diff --git a/security/landlock/enforce_seccomp.c b/security/landlock/enforce_seccomp.c
new file mode 100644
index 000000000000..8da72e868422
--- /dev/null
+++ b/security/landlock/enforce_seccomp.c
@@ -0,0 +1,102 @@
+/*
+ * Landlock LSM - enforcing with seccomp
+ *
+ * Copyright © 2016-2018 Mickaël Salaün <mic@digikod.net>
+ * Copyright © 2018 ANSSI
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#ifdef CONFIG_SECCOMP_FILTER
+
+#include <linux/bpf.h> /* bpf_prog_put() */
+#include <linux/capability.h>
+#include <linux/err.h> /* PTR_ERR() */
+#include <linux/errno.h>
+#include <linux/filter.h> /* struct bpf_prog */
+#include <linux/landlock.h>
+#include <linux/refcount.h>
+#include <linux/sched.h> /* current */
+#include <linux/uaccess.h> /* get_user() */
+
+#include "enforce.h"
+
+/* headers in include/linux/landlock.h */
+
+/**
+ * landlock_seccomp_prepend_prog - attach a Landlock program to the current
+ *                                 process
+ *
+ * current->seccomp.landlock_state->prog_set is lazily allocated. When a
+ * process fork, only a pointer is copied.  When a new program is added by a
+ * process, if there is other references to this process' prog_set, then a new
+ * allocation is made to contain an array pointing to Landlock program lists.
+ * This design enable low-performance impact and is memory efficient while
+ * keeping the property of prepend-only programs.
+ *
+ * For now, installing a Landlock prog requires that the requesting task has
+ * the global CAP_SYS_ADMIN. We cannot force the use of no_new_privs to not
+ * exclude containers where a process may legitimately acquire more privileges
+ * thanks to an SUID binary.
+ *
+ * @flags: not used for now, but could be used for TSYNC
+ * @user_bpf_fd: file descriptor pointing to a loaded Landlock prog
+ */
+int landlock_seccomp_prepend_prog(unsigned int flags,
+		const int __user *user_bpf_fd)
+{
+	struct landlock_prog_set *new_prog_set;
+	struct bpf_prog *prog;
+	int bpf_fd, err;
+
+	/* planned to be replaced with a no_new_privs check to allow
+	 * unprivileged tasks */
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	/* enable to check if Landlock is supported with early EFAULT */
+	if (!user_bpf_fd)
+		return -EFAULT;
+	if (flags)
+		return -EINVAL;
+	err = get_user(bpf_fd, user_bpf_fd);
+	if (err)
+		return err;
+
+	prog = bpf_prog_get(bpf_fd);
+	if (IS_ERR(prog)) {
+		err = PTR_ERR(prog);
+		goto free_task;
+	}
+
+	/*
+	 * We don't need to lock anything for the current process hierarchy,
+	 * everything is guarded by the atomic counters.
+	 */
+	new_prog_set = landlock_prepend_prog(
+			current->seccomp.landlock_prog_set, prog);
+	bpf_prog_put(prog);
+	/* @prog is managed/freed by landlock_prepend_prog() */
+	if (IS_ERR(new_prog_set)) {
+		err = PTR_ERR(new_prog_set);
+		goto free_task;
+	}
+	current->seccomp.landlock_prog_set = new_prog_set;
+	return 0;
+
+free_task:
+	return err;
+}
+
+void put_seccomp_landlock(struct task_struct *tsk)
+{
+	landlock_put_prog_set(tsk->seccomp.landlock_prog_set);
+}
+
+void get_seccomp_landlock(struct task_struct *tsk)
+{
+	landlock_get_prog_set(tsk->seccomp.landlock_prog_set);
+}
+
+#endif /* CONFIG_SECCOMP_FILTER */
-- 
2.16.2
