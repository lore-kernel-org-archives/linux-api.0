From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [RFC v1 07/17] seccomp: Add seccomp object checker evaluation
Date: Thu, 24 Mar 2016 02:46:38 +0100
Message-ID: <1458784008-16277-8-git-send-email-mic@digikod.net>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-2837-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1458784008-16277-1-git-send-email-mic@digikod.net>
To: linux-security-module@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Will Drewry <wad@chromium.org>, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

This brings a new seccomp filters return type named SECCOMP_RET_ARGEVAL.
It is equivalent to SECCOMP_RET_ACCESS except that the next stacked
filters can take a decision regarding a match (e.g. return EACCESS or
emulate a syscall).
SECCOMP_RET_ARGEVAL is a special return value only usable between
filters evaluation and can't reach userland.

Userland can create a seccomp BPF returning SECCOMP_RET_ARGEVAL and two
values in the 16 least significant bits:
* a group ID to use a checker batch against the current syscall;
* a syscall argument bitmask to give specific arguments to the checkers.

The checker group IDs are unique per filter creator (i.e. thread). They
remains private and can only be referenced by the filters created
consecutively to a checker group creation by the same userland thread.

Three fields are added to the struct seccomp_data:
* is_valid_syscall allows seccomp filters to check if the current
  syscall number is known by the kernel.
* arg_group is the checker group ID asked by the previous filter.
* matches[6] consist of one 64-bits mask per matched argument. This
  bitmasks are useful to get the check result of each object from a
  group on a syscall argument.

A path cache is used to protect against time-of-check-time-of-use
(TOCTOU) race conditions attacks on userland addresses. For now, this
cache use the audit framework. It must then be enabled at boot time.

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
 include/linux/seccomp.h       |  77 +++++++++++-
 include/uapi/linux/seccomp.h  |  24 ++++
 kernel/fork.c                 |  11 +-
 kernel/seccomp.c              | 251 ++++++++++++++++++++++++++++++++++++++-
 security/seccomp/checker_fs.c | 269 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 623 insertions(+), 9 deletions(-)

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 78f5861a0328..0c5468f78945 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -13,6 +13,8 @@
 
 struct seccomp_filter;
 struct seccomp_filter_checker_group;
+struct seccomp_argeval_cache;
+
 /**
  * struct seccomp - the state of a seccomp'ed process
  *
@@ -34,6 +36,9 @@ struct seccomp {
 #ifdef CONFIG_SECURITY_SECCOMP
 	/* @checker_group is only used for filter creation and unique per thread */
 	struct seccomp_filter_checker_group *checker_group;
+
+	/* syscall-lifetime data */
+	struct seccomp_argeval_cache *arg_cache;
 #endif
 };
 
@@ -93,10 +98,12 @@ static inline int seccomp_mode(struct seccomp *s)
 #endif /* CONFIG_SECCOMP */
 
 #ifdef CONFIG_SECCOMP_FILTER
-extern void put_seccomp_filter(struct task_struct *tsk);
+extern void put_seccomp(struct task_struct *tsk);
 extern void get_seccomp_filter(struct task_struct *tsk);
 
 #ifdef CONFIG_SECURITY_SECCOMP
+extern void flush_seccomp_cache(struct task_struct *tsk);
+
 struct seccomp_filter_object_path {
 	u32 flags;
 	struct path path;
@@ -112,20 +119,86 @@ struct seccomp_filter_checker {
 	};
 };
 
+/** seccomp_argrule_t - Argument rule matcher
+ * e.g. seccomp_argrule_path_literal()
+ * This prototype get the whole syscall argument picture to be able to get the
+ * sementic from multiple arguments (e.g. pointer plus size of the pointed
+ * data, which can indicated by @argrule).
+ *
+ * Return which arguments match @argdesc.
+ *
+ * @argdesc: Pointer to the argument type description.
+ * @args: Pointer to an array of the (max) six arguments. Can use them thanks
+ *	to @argdesc.
+ * @to_check: Which arguments are asked to check; should at least have one to
+ *	make sense.
+ * @argrule: The rule to check on @args.
+ */
+typedef u8 seccomp_argrule_t(const u8(*argdesc)[6],
+			     const u64(*args)[6], u8 to_check,
+			     const struct seccomp_filter_checker *checker);
+
+/* seccomp LSM */
+
+seccomp_argrule_t *get_argrule_checker(u32 check);
+struct syscall_argdesc *syscall_nr_to_argdesc(int nr);
+
+/**
+ * struct seccomp_argeval_cache_fs
+ *
+ * @hash_len: refer to the hashlen field from struct qstr.
+ */
+struct seccomp_argeval_cache_fs {
+	struct path *path;
+	u64 hash_len;
+};
+
+/**
+ * struct seccomp_argeval_cache_entry
+ *
+ * To be consistent with the filters checks, we only check the original
+ * arguments but not those put by a tracer process, if any.
+ *
+ * Because the cache is uptr-oriented, it is possible to have the same dentry
+ * in multiple cache entries (but with different uptr).
+ */
+struct seccomp_argeval_cache_entry {
+	const void __user *uptr;
+	u8 args;
+	union {
+		struct seccomp_argeval_cache_fs fs;
+	};
+	struct seccomp_argeval_cache_entry *next;
+};
+
+struct seccomp_argeval_cache {
+	/* e.g. SECCOMP_ARGTYPE_PATH */
+	u32 type;
+	struct seccomp_argeval_cache_entry *entry;
+	struct seccomp_argeval_cache *next;
+};
+
+void put_seccomp_filter_checker(struct seccomp_filter_checker *);
+
+u8 seccomp_argrule_path(const u8(*)[6], const u64(*)[6], u8,
+			const struct seccomp_filter_checker *);
 
 long seccomp_set_argcheck_fs(const struct seccomp_checker *,
 			     struct seccomp_filter_checker *);
+
 #endif /* CONFIG_SECURITY_SECCOMP */
 
 #else  /* CONFIG_SECCOMP_FILTER */
-static inline void put_seccomp_filter(struct task_struct *tsk)
+static inline void put_seccomp(struct task_struct *tsk)
 {
 	return;
 }
+
 static inline void get_seccomp_filter(struct task_struct *tsk)
 {
 	return;
 }
+
 #endif /* CONFIG_SECCOMP_FILTER */
 
 #if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_CHECKPOINT_RESTORE)
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index ca7e9343f3d7..36d9be535249 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -32,9 +32,15 @@
 #define SECCOMP_RET_TRACE	0x7ff00000U /* pass to a tracer or disallow */
 #define SECCOMP_RET_ALLOW	0x7fff0000U /* allow */
 
+/* Intermediate return values */
+#define SECCOMP_RET_ARGEVAL	0x80ff0000U /* trigger argument evaluation */
+
 /* Masks for the return value sections. */
+#define SECCOMP_RET_INTER	0xffff0000U
 #define SECCOMP_RET_ACTION	0x7fff0000U
 #define SECCOMP_RET_DATA	0x0000ffffU
+#define SECCOMP_RET_CHECKER_GROUP	0x000000ffU
+#define SECCOMP_RET_ARG_MATCHES	0x00003f00U
 
 /* Object checks */
 #define SECCOMP_CHECK_FS_LITERAL	1
@@ -57,20 +63,38 @@
 
 /**
  * struct seccomp_data - the format the BPF program executes over.
+ *
+ * Userland can find the seccomp_data version with the struct length (i.e.
+ * BPF_LEN) and offsetof(struct seccomp_data, <field>) + sizeof(<field-type>).
+
  * @nr: the system call number
  * @arch: indicates system call convention as an AUDIT_ARCH_* value
  *        as defined in <linux/audit.h>.
  * @instruction_pointer: at the time of the system call.
  * @args: up to 6 system call arguments always stored as 64-bit values
  *        regardless of the architecture.
+ * @is_valid_syscall: set to 1 if the syscall exists and was found or 0
+ *                    otherwise (needed for argument type resolution).
+ * @checker_group: checker group selected by the previously executed filter
+ *                 (only the 8 least significant bits are used).
+ * @arg_matches: 6 bitmasks indicating which argument checkers matched the
+ *               system call arguments.
  */
 struct seccomp_data {
 	int nr;
 	__u32 arch;
 	__u64 instruction_pointer;
 	__u64 args[6];
+	__u32 is_valid_syscall; /* SECCOMP_DATA_VALIDSYS_PRESENT */
+	__u32 checker_group; /* SECCOMP_DATA_ARGEVAL_PRESENT */
+	__u64 arg_matches[6]; /* SECCOMP_DATA_ARGEVAL_PRESENT */
 };
 
+/* Up to seccomp_data.is_valid_syscall */
+#define SECCOMP_DATA_VALIDSYS_PRESENT	1
+/* Up to seccomp_data.arg_matches[6] */
+#define SECCOMP_DATA_ARGEVAL_PRESENT	1
+
 /* TODO: Add a "at" field (default to AT_FDCWD) */
 struct seccomp_object_path {
 	/* e.g. SECCOMP_OBJFLAG_FS_DENTRY */
diff --git a/kernel/fork.c b/kernel/fork.c
index 2e391c754ae7..b8155ebdd308 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -226,7 +226,7 @@ void free_task(struct task_struct *tsk)
 	free_thread_info(tsk->stack);
 	rt_mutex_debug_task_free(tsk);
 	ftrace_graph_exit_task(tsk);
-	put_seccomp_filter(tsk);
+	put_seccomp(tsk);
 	arch_release_task_struct(tsk);
 	free_task_struct(tsk);
 }
@@ -359,7 +359,11 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	 * the usage counts on the error path calling free_task.
 	 */
 	tsk->seccomp.filter = NULL;
-#endif
+#ifdef CONFIG_SECURITY_SECCOMP
+	tsk->seccomp.checker_group = NULL;
+	tsk->seccomp.arg_cache = NULL;
+#endif /* CONFIG_SECURITY_SECCOMP */
+#endif /* CONFIG_SECCOMP */
 
 	setup_thread_stack(tsk, orig);
 	clear_user_return_notifier(tsk);
@@ -1175,7 +1179,8 @@ static void copy_seccomp(struct task_struct *p)
 
 	/* Ref-count the new filter user, and assign it. */
 	get_seccomp_filter(current);
-	p->seccomp = current->seccomp;
+	p->seccomp.mode = current->seccomp.mode;
+	p->seccomp.filter = current->seccomp.filter;
 
 	/*
 	 * Explicitly enable no_new_privs here in case it got set
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 0e5471d2891c..60e11863857e 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -23,6 +23,13 @@
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 
+#include <linux/bitops.h>	/* BIT_ULL() */
+#include <linux/fs.h>
+#include <linux/fs_struct.h>
+#include <linux/mount.h>
+#include <linux/namei.h>	/* user_lpath*() path_put() */
+#include <linux/path.h>
+
 #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
 #include <asm/syscall.h>
 #endif
@@ -34,6 +41,33 @@
 #include <linux/security.h>
 #include <linux/tracehook.h>
 #include <linux/uaccess.h>
+#include <linux/ftrace.h>	/* for arch_syscall_match_sym_name() overload */
+
+#ifdef CONFIG_SECURITY_SECCOMP
+#include <linux/kernel.h>	/* FIELD_SIZEOF() */
+
+#ifdef CONFIG_COMPAT
+/* struct seccomp_checker_group */
+struct compat_seccomp_checker_group {
+	__u8 version;
+	__u8 id;
+	unsigned int len;
+	compat_uptr_t checkers;	/* const struct seccomp_checker (*)[] */
+};
+
+/* struct seccomp_checker */
+struct compat_seccomp_checker {
+	__u32 check;
+	__u32 type;
+	unsigned int len;
+	compat_uptr_t checker;	/* const struct seccomp_object_path * */
+};
+
+extern struct syscall_argdesc (*compat_seccomp_syscalls_argdesc)[];
+#endif /* CONFIG_COMPAT */
+
+extern struct syscall_argdesc (*seccomp_syscalls_argdesc)[];
+#endif /* CONFIG_SECURITY_SECCOMP */
 
 /**
  * struct seccomp_filter - container for seccomp BPF programs
@@ -46,6 +80,8 @@
  * @len: the number of instructions in the program
  * @insnsi: the BPF program instructions to evaluate
  *
+ * @checker_group: the list of argument checkers usable by a filter
+ *
  * seccomp_filter objects are organized in a tree linked via the @prev
  * pointer.  For any task, it appears to be a singly-linked list starting
  * with current->seccomp.filter, the most recently attached or inherited filter.
@@ -60,6 +96,9 @@ struct seccomp_filter {
 	atomic_t usage;
 	struct seccomp_filter *prev;
 	struct bpf_prog *prog;
+#ifdef CONFIG_SECURITY_SECCOMP
+	struct seccomp_filter_checker_group *checker_group;
+#endif
 };
 
 /* Argument group attached to seccomp filters
@@ -93,6 +132,18 @@ struct seccomp_filter_checker_group {
 /* Limit any path through the tree to 256KB worth of instructions. */
 #define MAX_INSNS_PER_PATH ((1 << 18) / sizeof(struct sock_filter))
 
+static void clean_seccomp_data(struct seccomp_data *sd)
+{
+	sd->is_valid_syscall = 0;
+	sd->checker_group = 0;
+	sd->arg_matches[0] = 0ULL;
+	sd->arg_matches[1] = 0ULL;
+	sd->arg_matches[2] = 0ULL;
+	sd->arg_matches[3] = 0ULL;
+	sd->arg_matches[4] = 0ULL;
+	sd->arg_matches[5] = 0ULL;
+}
+
 /*
  * Endianness is explicitly ignored and left for BPF program authors to manage
  * as per the specific architecture.
@@ -113,6 +164,7 @@ static void populate_seccomp_data(struct seccomp_data *sd)
 	sd->args[4] = args[4];
 	sd->args[5] = args[5];
 	sd->instruction_pointer = KSTK_EIP(task);
+	clean_seccomp_data(sd);
 }
 
 /**
@@ -197,6 +249,136 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
 	return 0;
 }
 
+#ifdef CONFIG_SECURITY_SECCOMP
+seccomp_argrule_t *get_argrule_checker(u32 check)
+{
+	switch (check) {
+	case SECCOMP_CHECK_FS_LITERAL:
+	case SECCOMP_CHECK_FS_BENEATH:
+		return seccomp_argrule_path;
+	}
+	return NULL;
+}
+
+struct syscall_argdesc *syscall_nr_to_argdesc(int nr)
+{
+	unsigned int nr_syscalls;
+	struct syscall_argdesc (*seccomp_sa)[];
+
+#ifdef CONFIG_COMPAT
+	if (is_compat_task()) {
+		nr_syscalls = IA32_NR_syscalls;
+		seccomp_sa = compat_seccomp_syscalls_argdesc;
+	} else /* falls below */
+#endif	/* CONFIG_COMPAT */
+	{
+		nr_syscalls = NR_syscalls;
+		seccomp_sa = seccomp_syscalls_argdesc;
+	}
+
+	if (nr >= nr_syscalls || nr < 0)
+		return NULL;
+	if (unlikely(!seccomp_sa)) {
+		WARN_ON(1);
+		return NULL;
+	}
+
+	return &(*seccomp_sa)[nr];
+}
+
+/* Return the argument group address that match the group ID, or NULL
+ * otherwise.
+ */
+static struct seccomp_filter_checker_group *seccomp_update_argrule_data(
+		struct seccomp_filter *filter,
+		struct seccomp_data *sd, u16 ret_data)
+{
+	int i, j;
+	u8 match;
+	struct seccomp_filter_checker_group *walker, *checker_group = NULL;
+	const struct syscall_argdesc *argdesc;
+	struct seccomp_filter_checker *checker;
+	seccomp_argrule_t *engine;
+
+	const u8 group_id = ret_data & SECCOMP_RET_CHECKER_GROUP;
+	const u8 to_check = (ret_data & SECCOMP_RET_ARG_MATCHES) >> 8;
+
+	clean_seccomp_data(sd);
+
+	/* Find the matching group in those accessible to this filter */
+	for (walker = filter->checker_group; walker; walker = walker->prev) {
+		if (walker->id == group_id) {
+			checker_group = walker;
+			break;
+		}
+	}
+	if (!checker_group)
+		return NULL;
+	sd->checker_group = checker_group->id;
+
+	argdesc = syscall_nr_to_argdesc(sd->nr);
+	if (!argdesc)
+		return checker_group;
+	sd->is_valid_syscall = 1;
+
+	for (i = 0; i < checker_group->checkers_len; i++) {
+		checker = &checker_group->checkers[i];
+		engine = get_argrule_checker(checker->check);
+		if (engine) {
+			match = (*engine)(&argdesc->args, &sd->args, to_check, checker);
+
+			for (j = 0; j < 6; j++) {
+				sd->arg_matches[j] |=
+				    ((BIT_ULL(j) & match) >> j) << i;
+			}
+		}
+	}
+	return checker_group;
+}
+
+static void free_seccomp_argeval_cache_entry(u32 type,
+					     struct seccomp_argeval_cache_entry
+					     *entry)
+{
+	while (entry) {
+		struct seccomp_argeval_cache_entry *freeme = entry;
+
+		switch (type) {
+		case SECCOMP_OBJTYPE_PATH:
+			if (entry->fs.path) {
+				/* Pointer checks done in path_put() */
+				path_put(entry->fs.path);
+				kfree(entry->fs.path);
+			}
+			break;
+		default:
+			WARN_ON(1);
+		}
+		entry = entry->next;
+		kfree(freeme);
+	}
+}
+
+static void free_seccomp_argeval_cache(struct seccomp_argeval_cache *arg_cache)
+{
+	while (arg_cache) {
+		struct seccomp_argeval_cache *freeme = arg_cache;
+
+		free_seccomp_argeval_cache_entry(arg_cache->type, arg_cache->entry);
+		arg_cache = arg_cache->next;
+		kfree(freeme);
+	}
+}
+
+void flush_seccomp_cache(struct task_struct *tsk)
+{
+	free_seccomp_argeval_cache(tsk->seccomp.arg_cache);
+	tsk->seccomp.arg_cache = NULL;
+}
+#endif /* CONFIG_SECURITY_SECCOMP */
+
+static void put_seccomp_filter(struct task_struct *tsk);
+
 /**
  * seccomp_run_filters - evaluates all seccomp filters against @syscall
  * @syscall: number of the current system call
@@ -205,6 +387,9 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
  */
 static u32 seccomp_run_filters(struct seccomp_data *sd)
 {
+#ifdef CONFIG_SECURITY_SECCOMP
+	struct seccomp_filter_checker_group *walker, *arg_match = NULL;
+#endif
 	struct seccomp_data sd_local;
 	u32 ret = SECCOMP_RET_ALLOW;
 	/* Make sure cross-thread synced filter points somewhere sane. */
@@ -219,17 +404,54 @@ static u32 seccomp_run_filters(struct seccomp_data *sd)
 		populate_seccomp_data(&sd_local);
 		sd = &sd_local;
 	}
+#ifdef CONFIG_SECURITY_SECCOMP
+	/* Cleanup old (syscall-lifetime) cache */
+	flush_seccomp_cache(current);
+#endif
 
 	/*
 	 * All filters in the list are evaluated and the lowest BPF return
 	 * value always takes priority (ignoring the DATA).
 	 */
 	for (; f; f = f->prev) {
-		u32 cur_ret = BPF_PROG_RUN(f->prog, (void *)sd);
+		u32 cur_ret;
+
+#ifdef CONFIG_SECURITY_SECCOMP
+		if (arg_match) {
+			bool found = false;
+
+			/* Find if the argument group is accessible from this filter */
+			for (walker = f->checker_group; walker; walker = walker->prev) {
+				if (walker == arg_match) {
+					found = true;
+					break;
+				}
+			}
+			if (!found)
+				clean_seccomp_data(sd);
+		}
+#endif /* CONFIG_SECURITY_SECCOMP */
+		cur_ret = BPF_PROG_RUN(f->prog, (void *)sd);
 
-		if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION))
+#ifdef CONFIG_SECURITY_SECCOMP
+		/* Intermediate return values */
+		if ((cur_ret & SECCOMP_RET_INTER) == SECCOMP_RET_ARGEVAL) {
+			/* XXX: sd modification /!\ */
+			arg_match = seccomp_update_argrule_data(f, sd,
+					(cur_ret & SECCOMP_RET_DATA));
+		} else if (arg_match) {
+			clean_seccomp_data(sd);
+			arg_match = NULL;
+		}
+#endif /* CONFIG_SECURITY_SECCOMP */
+
+		if ((cur_ret & SECCOMP_RET_INTER) < (ret & SECCOMP_RET_ACTION))
 			ret = cur_ret;
 	}
+#ifdef CONFIG_SECURITY_SECCOMP
+	if (arg_match && sd != &sd_local)
+		clean_seccomp_data(sd);
+#endif /* CONFIG_SECURITY_SECCOMP */
 	return ret;
 }
 #endif /* CONFIG_SECCOMP_FILTER */
@@ -407,6 +629,13 @@ static struct seccomp_filter *seccomp_prepare_filter(struct sock_fprog *fprog)
 		return ERR_PTR(ret);
 	}
 
+#ifdef CONFIG_SECURITY_SECCOMP
+	sfilter->checker_group =
+		lockless_dereference(current->seccomp.checker_group);
+	if (sfilter->checker_group)
+		atomic_inc(&sfilter->checker_group->usage);
+#endif /* CONFIG_SECURITY_SECCOMP */
+
 	atomic_set(&sfilter->usage, 1);
 
 	return sfilter;
@@ -532,13 +761,16 @@ static void put_seccomp_checker_group(struct seccomp_filter_checker_group *check
 static inline void seccomp_filter_free(struct seccomp_filter *filter)
 {
 	if (filter) {
+#ifdef CONFIG_SECURITY_SECCOMP
+		put_seccomp_checker_group(filter->checker_group);
+#endif /* CONFIG_SECURITY_SECCOMP */
 		bpf_prog_destroy(filter->prog);
 		kfree(filter);
 	}
 }
 
 /* put_seccomp_filter - decrements the ref count of tsk->seccomp.filter */
-void put_seccomp_filter(struct task_struct *tsk)
+static void put_seccomp_filter(struct task_struct *tsk)
 {
 	struct seccomp_filter *orig = tsk->seccomp.filter;
 	/* Clean up single-reference branches iteratively. */
@@ -547,7 +779,14 @@ void put_seccomp_filter(struct task_struct *tsk)
 		orig = orig->prev;
 		seccomp_filter_free(freeme);
 	}
+}
+
+void put_seccomp(struct task_struct *tsk)
+{
+	put_seccomp_filter(tsk);
 #ifdef CONFIG_SECURITY_SECCOMP
+	/* Free in that order because of referenced checkers */
+	free_seccomp_argeval_cache(tsk->seccomp.arg_cache);
 	put_seccomp_checker_group(tsk->seccomp.checker_group);
 #endif
 }
@@ -673,6 +912,9 @@ static u32 __seccomp_phase1_filter(int this_syscall, struct seccomp_data *sd)
 	case SECCOMP_RET_TRACE:
 		return filter_ret;  /* Save the rest for phase 2. */
 
+	case SECCOMP_RET_ARGEVAL:
+		/* Handled in seccomp_run_filters() */
+		BUG();
 	case SECCOMP_RET_ALLOW:
 		return SECCOMP_PHASE1_OK;
 
@@ -881,7 +1123,8 @@ static inline long seccomp_set_mode_filter(unsigned int flags,
 #ifdef CONFIG_SECURITY_SECCOMP
 
 /* Limit checkers number to 64 to be able to show matches with a bitmask. */
-#define SECCOMP_CHECKERS_MAX 64
+#define SECCOMP_CHECKERS_MAX \
+	(FIELD_SIZEOF(struct seccomp_data, arg_matches[0]) * BITS_PER_BYTE)
 
 /* Limit arg group list and their checkers to 256KB. */
 #define SECCOMP_GROUP_CHECKERS_MAX_SIZE (1 << 18)
diff --git a/security/seccomp/checker_fs.c b/security/seccomp/checker_fs.c
index c11efc892de5..0a5ec3a204e7 100644
--- a/security/seccomp/checker_fs.c
+++ b/security/seccomp/checker_fs.c
@@ -8,11 +8,13 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/bitops.h>	/* BIT() */
 #include <linux/compat.h>
 #include <linux/namei.h>	/* user_lpath() */
 #include <linux/path.h>
 #include <linux/seccomp.h>
 #include <linux/slab.h>
+#include <linux/syscalls.h>	/* __SACT__CONST_CHAR_PTR */
 #include <linux/uaccess.h>	/* copy_from_user() */
 
 #ifdef CONFIG_COMPAT
@@ -61,6 +63,273 @@ static bool wrong_check_flags(u32 check, u32 flags)
 		((flags | path_flags_mask) != path_flags_mask);
 }
 
+/* This cache prohibit TOCTOU race conditions between seccomp filter checks and
+ * LSM hooks checks, i.e. the dereferenced data is kept in cache and only
+ * dereferenced once for the whole syscall lifetime.
+ *
+ * Ignore @follow_symlink if @str_path match a cache entry (i.e. do not store
+ * @follow_symlink in the cache).
+ */
+static const struct path *get_cache_path(const char __user *str_path,
+					 bool follow_symlink, u8 arg_nr)
+{
+	struct path *path = NULL;
+	u64 hash_len = 0;
+	struct filename *name;
+	struct seccomp_argeval_cache_entry **entry = NULL;
+	struct seccomp_argeval_cache **arg_cache = &current->seccomp.arg_cache;
+	bool new_cache = false;
+
+	/* Find a cache entry matching @str_path */
+	while (*arg_cache) {
+		if ((*arg_cache)->type == SECCOMP_OBJTYPE_PATH) {
+			entry = &(*arg_cache)->entry;
+			while (*entry) {
+				if ((*entry)->uptr == str_path) {
+					/* Add this argument to the cache */
+					(*entry)->args |= BIT(arg_nr);
+					return (*entry)->fs.path;
+				}
+				entry = &(*entry)->next;
+			}
+			break;
+		}
+		arg_cache = &(*arg_cache)->next;
+	}
+
+	/* Save @str_path to avoid syscall argument TOCTOU race condition
+	 * thanks to the audit_names list for the current audit context (cf.
+	 * __audit_reusename).
+	 * @name will be freed with audit_syscall_exit(), audit_free() or
+	 * audit_seccomp_exit().
+	 */
+	name = getname(str_path);
+	if (IS_ERR(name))
+		return NULL;
+
+	path = kmalloc(sizeof(*path), GFP_KERNEL);
+	if (path) {
+		int ret;
+
+		/* @follow_symlink is only evaluated for the first cache entry */
+		if (follow_symlink)
+			ret = user_path(str_path, path);
+		else
+			ret = user_lpath(str_path, path);
+		if (ret) {
+			/* Store invalid path entry as well */
+			kfree(path);
+			path = NULL;
+		} else {
+			/* FIXME: How not to make this racy because of possible
+			 * concurrent dentry update by other task?
+			 */
+			hash_len = path->dentry->d_name.hash_len;
+		}
+	} else {
+		return NULL;
+	}
+
+	/* Append a new cache entry for @str_path */
+	if (!*arg_cache) {
+		*arg_cache = kmalloc(sizeof(**arg_cache), GFP_KERNEL);
+		if (!*arg_cache)
+			goto free_path;
+		new_cache = true;
+		(*arg_cache)->type = SECCOMP_OBJTYPE_PATH;
+		(*arg_cache)->next = NULL;
+		entry = &(*arg_cache)->entry;
+	}
+	*entry = kmalloc(sizeof(**entry), GFP_KERNEL);
+	if (!*entry)
+		goto free_cache;
+	(*entry)->uptr = str_path;
+	(*entry)->args = BIT(arg_nr);
+	(*entry)->fs.path = path;
+	(*entry)->fs.hash_len = hash_len;
+	(*entry)->next = NULL;
+	return (*entry)->fs.path;
+
+free_cache:
+	if (new_cache) {
+		/* It is not mandatory to free the cache because it is linked */
+		kfree(*arg_cache);
+		*arg_cache = NULL;
+	}
+
+free_path:
+	kfree(path);
+	return NULL;
+}
+
+#define EQUAL_NOT_NULL(a, b) (a && a == b)
+
+static bool check_path_literal(const struct path *p1, const struct path *p2,
+			       u32 flags)
+{
+	bool result_dentry = !(flags & SECCOMP_OBJFLAG_FS_DENTRY);
+	bool result_inode = !(flags & SECCOMP_OBJFLAG_FS_INODE);
+	bool result_device = !(flags & SECCOMP_OBJFLAG_FS_DEVICE);
+	bool result_mount = !(flags & SECCOMP_OBJFLAG_FS_MOUNT);
+
+	if (unlikely(!p1 || !p2)) {
+		WARN_ON(1);
+		return false;
+	}
+
+	if (!result_dentry && p1->dentry == p2->dentry)
+		result_dentry = true;
+	/* XXX: Use d_inode_rcu() instead? */
+	if (!result_inode
+	    && EQUAL_NOT_NULL(d_inode(p1->dentry)->i_ino,
+			      d_inode(p2->dentry)->i_ino))
+		result_inode = true;
+	/* Check superblock instead of device major/minor */
+	if (!result_device
+	    && EQUAL_NOT_NULL(d_inode(p1->dentry)->i_sb,
+			      d_inode(p2->dentry)->i_sb))
+		result_device = true;
+	if (!result_mount && EQUAL_NOT_NULL(p1->mnt, p2->mnt))
+		result_mount = true;
+
+	return result_dentry && result_inode && result_device && result_mount;
+}
+
+static bool check_path_beneath(const struct path *p1, const struct path *p2,
+			       u32 flags)
+{
+	struct path walker = {
+		/* Mount can't be checked here */
+		.mnt = NULL,
+		.dentry = NULL,
+	};
+
+	if (unlikely(!p1 || !p2)) {
+		WARN_ON(1);
+		return false;
+	}
+
+	/* Meanigless mount and device checks are not in flags thanks to
+	 * previous call to wrong_check_flags().
+	 */
+	if (unlikely((flags | path_flags_mask_beneath)
+				!= path_flags_mask_beneath)) {
+		WARN_ON(1);
+		return false;
+	}
+
+	for (walker.dentry = p2->dentry; !IS_ROOT(walker.dentry);
+			walker.dentry = walker.dentry->d_parent) {
+		if (check_path_literal(p1, &walker, flags))
+			return true;
+	}
+	return false;
+}
+
+/* Must be called with a locked path->dentry */
+static bool argrule_match_path(const struct seccomp_filter_checker *checker,
+			       const struct path *arg)
+{
+	const struct seccomp_filter_object_path *object_path;
+
+	if (unlikely(!checker || !arg)) {
+		WARN_ON(1);
+		return false;
+	}
+
+	switch (checker->type) {
+	case SECCOMP_OBJTYPE_PATH:
+		object_path = &checker->object_path;
+		if (unlikely(!object_path->path.dentry)) {
+			WARN_ON(1);
+			return false;
+		}
+
+		/* Comparing mnt+pathname is not enough because pivot_root can
+		 * remove a path prefix; could be used to allow access to a
+		 * subdirectory with bind mounting and pivot-rooting to
+		 * simulate the initial mnt+pathname configuration.
+		 *
+		 * The check should allow to compare bind-mounted files and
+		 * keep the user's path semantic.
+		 */
+		switch (checker->check) {
+		case SECCOMP_CHECK_FS_LITERAL:
+			return check_path_literal(&object_path->path, arg,
+						  object_path->flags);
+		case SECCOMP_CHECK_FS_BENEATH:
+			return check_path_beneath(&object_path->path, arg,
+						  object_path->flags);
+		default:
+			WARN_ON(1);
+			return false;
+		}
+	default:
+		WARN_ON(1);
+	}
+	return false;
+}
+
+/* Return matched checks. */
+u8 seccomp_argrule_path(const u8(*argdesc)[6], const u64(*args)[6],
+			u8 to_check,
+			const struct seccomp_filter_checker *checker)
+{
+	int i;
+	const char __user *str_path;
+	const struct path *path;
+	u8 ret = 0;
+	bool follow_symlink;
+
+	if (unlikely(!argdesc || !args || !checker)) {
+		WARN_ON(1);
+		goto out;
+	}
+	switch (checker->check) {
+	case SECCOMP_CHECK_FS_LITERAL:
+	case SECCOMP_CHECK_FS_BENEATH:
+		break;
+	default:
+		WARN_ON(1);
+		goto out;
+	}
+
+	if (wrong_check_flags(checker->check, checker->object_path.flags)) {
+		WARN_ON(1);
+		goto out;
+	}
+	follow_symlink = !(checker->object_path.flags & SECCOMP_OBJFLAG_FS_NOFOLLOW);
+
+	/* XXX: Add a whole cache lock? */
+	for (i = 0; i < 6; i++) {
+		if (!(BIT(i) & to_check))
+			continue;
+		if ((*argdesc)[i] != __SACT__CONST_CHAR_PTR)
+			continue;
+#ifdef CONFIG_COMPAT
+		if (is_compat_task()) {
+			str_path = compat_ptr((*args)[i]);
+		} else	/* Falls below */
+#endif
+		str_path = (const char __user *)((unsigned long)(*args)[i]);
+		/* Path are interpreted differently according to each syscall:
+		 * some follow symlinks whereas other don't (cf.
+		 * linux/namei.h:user_*path*).
+		 */
+		/* XXX: Do we need to check mnt/namespace? */
+		path = get_cache_path(str_path, follow_symlink, i);
+		if (!path)
+			continue;
+		spin_lock(&path->dentry->d_lock);
+		if (argrule_match_path(checker, path))
+			ret |= BIT(i);
+		spin_unlock(&path->dentry->d_lock);
+	}
+
+out:
+	return ret;
+}
+
 static long set_argtype_path(const struct seccomp_checker *user_checker,
 			     struct seccomp_filter_checker *kernel_checker)
 {
-- 
2.8.0.rc3
