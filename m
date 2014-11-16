From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: [PATCH] Add supplementary UIDs, and getusers/setusers system calls
Date: Sat, 15 Nov 2014 23:08:32 -0800
Message-ID: <6b6bef0eb7328d466e8deef3d2c186a79633e0a7.1416121601.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Analogous to the supplementary GID list, the supplementary UID list
provides a set of additional user credentials that a process can act as.
A process with CAP_SETUID can set its UID list arbitrarily; a process
without CAP_SETUID can only reduce its UID list.

This allows each user to have a set of UIDs that they can then use to
further sandbox individual child processes without first escalating to
root to change UIDs.  For instance, a PAM module could give each user a
block of UIDs to work with.

Tested via the following test program:

#include <err.h>
#include <stdio.h>
#include <sys/syscall.h>
#include <unistd.h>

static int getusers(int count, uid_t *uids)
{
    return syscall(322, count, uids);
}

static int setusers(int count, const uid_t *uids)
{
    return syscall(323, count, uids);
}

static void show_users(void)
{
    uid_t uids[65536];
    int i, count = getusers(65536, uids);
    if (count < 0)
        err(1, "getusers");
    printf("UIDs:");
    for (i = 0; i < count; i++)
        printf(" %u", (unsigned)uids[i]);
    printf("\n");
}

int main(void)
{
    uid_t list1[] = { 1, 2, 3, 4, 5 };
    uid_t list2[] = { 1, 2, 3, 4 };
    uid_t list3[] = { 2, 3, 4 };
    show_users();
    if (setusers(5, list1) < 0)
        err(1, "setusers 1");
    show_users();
    if (setresgid(1, 1, 1) < 0)
        err(1, "setresgid");
    if (setresuid(1, 1, 1) < 0)
        err(1, "setresuid");
    if (setusers(4, list2) < 0)
        err(1, "setusers 2");
    show_users();
    if (setusers(3, list3) < 0)
        err(1, "setusers 3");
    show_users();
    if (setusers(4, list2) < 0)
        err(1, "setusers 4");
    show_users();
    if (setresuid(2, 2, 2) < 0)
        err(1, "setresuid 2");
    if (setusers(5, list1) < 0)
        err(1, "setusers 5");
    show_users();

    return 0;
}

In this test, all but the last call to setusers succeeds; the last call
fails with EPERM because the unprivileged process attempts to add UID 5
to the supplementary UID list, which it does not currently have.

Signed-off-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
---
 arch/x86/syscalls/syscall_32.tbl  |   2 +
 arch/x86/syscalls/syscall_64.tbl  |   2 +
 include/linux/cred.h              |  66 +++++++++++++++
 include/linux/syscalls.h          |   2 +
 include/uapi/asm-generic/unistd.h |   6 +-
 include/uapi/linux/limits.h       |   1 +
 init/Kconfig                      |   9 ++
 kernel/cred.c                     |   4 +
 kernel/groups.c                   | 173 ++++++++++++++++++++++++++++++++++++++
 kernel/sys.c                      |  21 +++--
 kernel/sys_ni.c                   |   2 +
 11 files changed, 280 insertions(+), 8 deletions(-)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index 9fe1b5d..55717d7 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -364,3 +364,5 @@
 355	i386	getrandom		sys_getrandom
 356	i386	memfd_create		sys_memfd_create
 357	i386	bpf			sys_bpf
+358	i386	getusers		sys_getusers
+359	i386	setusers		sys_setusers
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 281150b..5572e67 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -328,6 +328,8 @@
 319	common	memfd_create		sys_memfd_create
 320	common	kexec_file_load		sys_kexec_file_load
 321	common	bpf			sys_bpf
+322	common	getusers		sys_getusers
+323	common	setusers		sys_setusers
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/cred.h b/include/linux/cred.h
index b2d0820..31169fe 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -76,6 +76,8 @@ extern int groups_search(const struct group_info *, kgid_t);
 extern int in_group_p(kgid_t);
 extern int in_egroup_p(kgid_t);
 
+struct user_info;
+
 /*
  * The security context of a task
  *
@@ -135,6 +137,12 @@ struct cred {
 	struct user_struct *user;	/* real user ID subscription */
 	struct user_namespace *user_ns; /* user_ns the caps and keyrings are relative to. */
 	struct group_info *group_info;	/* supplementary groups for euid/fsgid */
+#ifdef CONFIG_SUPPLEMENTARY_UIDS
+	struct user_info *user_info;	/* supplementary users */
+#define INIT_USER_INFO .user_info = &init_users,
+#else
+#define INIT_USER_INFO
+#endif
 	struct rcu_head	rcu;		/* RCU deletion hook */
 };
 
@@ -381,4 +389,62 @@ do {						\
 	*(_fsgid) = __cred->fsgid;		\
 } while(0)
 
+#ifdef CONFIG_SUPPLEMENTARY_UIDS
+struct user_info {
+	atomic_t	usage;
+	int		nusers;
+	int		nblocks;
+	kuid_t		small_block[NGROUPS_SMALL];
+	kuid_t		*blocks[0];
+};
+
+#define USER_AT(ui, i) GROUP_AT(ui, i)
+extern struct user_info init_users;
+void users_free(struct user_info *);
+bool has_supplementary_uid(kuid_t);
+
+/**
+ * get_user_info - Get a reference to a user_info structure
+ * @user_info: The user_info to reference
+ *
+ * This gets a reference to a set of supplementary users.
+ *
+ * If the caller is accessing a task's credentials, they must hold the RCU read
+ * lock when reading.
+ */
+static inline struct user_info *get_user_info(struct user_info *ui)
+{
+	atomic_inc(&ui->usage);
+	return ui;
+}
+
+static inline void get_cred_user_info(struct cred *cred)
+{
+	get_user_info(cred->user_info);
+}
+
+/**
+ * put_user_info - Release a reference to a user_info structure
+ * @user_info: The user_info to release
+ */
+static inline void put_user_info(struct user_info *ui)
+{
+	if (atomic_dec_and_test(&ui->usage))
+		users_free(ui);
+}
+
+static inline void put_cred_user_info(struct cred *cred)
+{
+	if (cred->user_info)
+		put_user_info(cred->user_info);
+}
+#else /* CONFIG_SUPPLEMENTARY_UIDS */
+static inline bool has_supplementary_uid(kuid_t uid)
+{
+	return false;
+}
+static inline void get_cred_user_info(struct cred *cred) {}
+static inline void put_cred_user_info(struct cred *cred) {}
+#endif
+
 #endif /* _LINUX_CRED_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index bda9b81..3bde665 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -232,6 +232,7 @@ asmlinkage long sys_getpgid(pid_t pid);
 asmlinkage long sys_getpgrp(void);
 asmlinkage long sys_getsid(pid_t pid);
 asmlinkage long sys_getgroups(int gidsetsize, gid_t __user *grouplist);
+asmlinkage long sys_getusers(int uidsetsize, uid_t __user *userlist);
 
 asmlinkage long sys_setregid(gid_t rgid, gid_t egid);
 asmlinkage long sys_setgid(gid_t gid);
@@ -244,6 +245,7 @@ asmlinkage long sys_setfsgid(gid_t gid);
 asmlinkage long sys_setpgid(pid_t pid, pid_t pgid);
 asmlinkage long sys_setsid(void);
 asmlinkage long sys_setgroups(int gidsetsize, gid_t __user *grouplist);
+asmlinkage long sys_setusers(int uidsetsize, uid_t __user *grouplist);
 
 asmlinkage long sys_acct(const char __user *name);
 asmlinkage long sys_capget(cap_user_header_t header,
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 22749c1..d6696cf 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -707,9 +707,13 @@ __SYSCALL(__NR_getrandom, sys_getrandom)
 __SYSCALL(__NR_memfd_create, sys_memfd_create)
 #define __NR_bpf 280
 __SYSCALL(__NR_bpf, sys_bpf)
+#define __NR_getusers 281
+__SYSCALL(__NR_getusers, sys_getusers)
+#define __NR_setusers 282
+__SYSCALL(__NR_setusers, sys_setusers)
 
 #undef __NR_syscalls
-#define __NR_syscalls 281
+#define __NR_syscalls 283
 
 /*
  * All syscalls below here should go away really,
diff --git a/include/uapi/linux/limits.h b/include/uapi/linux/limits.h
index 2d0f941..bae1b4c 100644
--- a/include/uapi/linux/limits.h
+++ b/include/uapi/linux/limits.h
@@ -4,6 +4,7 @@
 #define NR_OPEN	        1024
 
 #define NGROUPS_MAX    65536	/* supplemental group IDs are available */
+#define NUSERS_MAX     65536	/* supplemental user IDs available */
 #define ARG_MAX       131072	/* # bytes of args + environ for exec() */
 #define LINK_MAX         127	/* # links a file may have */
 #define MAX_CANON        255	/* size of the canonical input queue */
diff --git a/init/Kconfig b/init/Kconfig
index 3ee28ae..d85b159 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1358,6 +1358,15 @@ config UID16
 	help
 	  This enables the legacy 16-bit UID syscall wrappers.
 
+config SUPPLEMENTARY_UIDS
+       bool "Enable supplementary UIDs and system calls" if EXPERT
+       default y
+       help
+         This option adds a list of supplementary UIDs to each process, along
+         with system calls to manage that list.  If building an embedded
+         system where no applications use this functionality, you can disable
+         this option to save space.
+
 config SGETMASK_SYSCALL
 	bool "sgetmask/ssetmask syscalls support" if EXPERT
 	def_bool PARISC || MN10300 || BLACKFIN || M68K || PPC || MIPS || X86 || SPARC || CRIS || MICROBLAZE || SUPERH
diff --git a/kernel/cred.c b/kernel/cred.c
index e0573a4..1700a03 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -54,6 +54,7 @@ struct cred init_cred = {
 	.user			= INIT_USER,
 	.user_ns		= &init_user_ns,
 	.group_info		= &init_groups,
+	INIT_USER_INFO
 };
 
 static inline void set_cred_subscribers(struct cred *cred, int n)
@@ -112,6 +113,7 @@ static void put_cred_rcu(struct rcu_head *rcu)
 	key_put(cred->request_key_auth);
 	if (cred->group_info)
 		put_group_info(cred->group_info);
+	put_cred_user_info(cred);
 	free_uid(cred->user);
 	put_user_ns(cred->user_ns);
 	kmem_cache_free(cred_jar, cred);
@@ -252,6 +254,7 @@ struct cred *prepare_creds(void)
 	atomic_set(&new->usage, 1);
 	set_cred_subscribers(new, 0);
 	get_group_info(new->group_info);
+	get_cred_user_info(new);
 	get_uid(new->user);
 	get_user_ns(new->user_ns);
 
@@ -607,6 +610,7 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 	get_uid(new->user);
 	get_user_ns(new->user_ns);
 	get_group_info(new->group_info);
+	get_cred_user_info(new);
 
 #ifdef CONFIG_KEYS
 	new->session_keyring = NULL;
diff --git a/kernel/groups.c b/kernel/groups.c
index 451698f..d5de27d 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -269,3 +269,176 @@ int in_egroup_p(kgid_t grp)
 }
 
 EXPORT_SYMBOL(in_egroup_p);
+
+#ifdef CONFIG_SUPPLEMENTARY_UIDS
+/* init to 2 - one for init_task, one to ensure it is never freed */
+struct user_info init_users = { .usage = ATOMIC_INIT(2) };
+
+static struct user_info *users_alloc(int uidsetsize)
+{
+	return (struct user_info *)groups_alloc(uidsetsize);
+}
+
+void users_free(struct user_info *user_info)
+{
+	groups_free((struct group_info *)user_info);
+}
+
+/* export the user_info to a user-space array */
+static int users_to_user(uid_t __user *userlist,
+			 const struct user_info *user_info)
+{
+	struct user_namespace *user_ns = current_user_ns();
+	int i;
+	unsigned int count = user_info->nusers;
+
+	for (i = 0; i < count; i++) {
+		uid_t uid;
+		uid = from_kuid_munged(user_ns, USER_AT(user_info, i));
+		if (put_user(uid, userlist+i))
+			return -EFAULT;
+	}
+	return 0;
+}
+
+/* fill a user_info from a user-space array - it must be allocated already */
+static int users_from_user(struct user_info *user_info, uid_t __user *userlist)
+{
+	struct user_namespace *user_ns = current_user_ns();
+	int i;
+	unsigned int count = user_info->nusers;
+
+	for (i = 0; i < count; i++) {
+		uid_t uid;
+		kuid_t kuid;
+		if (get_user(uid, userlist+i))
+			return -EFAULT;
+
+		kuid = make_kuid(user_ns, uid);
+		if (!uid_valid(kuid))
+			return -EINVAL;
+
+		USER_AT(user_info, i) = kuid;
+	}
+	return 0;
+}
+
+static void users_sort(struct user_info *user_info)
+{
+	groups_sort((struct group_info *)user_info);
+}
+
+static bool users_search(const struct user_info *user_info, kuid_t uid)
+{
+	return groups_search((const struct group_info *)user_info, *(kgid_t *)&uid);
+}
+
+/* Return true if the user_info is a subset of the user_info of the specified
+ * credentials.  Also allow the first user_info to contain the uid, euid, or
+ * suid of the credentials.
+ */
+static bool user_subset(const struct user_info *u1, const struct cred *cred2)
+{
+	const struct user_info *u2 = cred2->user_info;
+	unsigned int i, j;
+
+	for (i = 0, j = 0; i < u1->nusers; i++) {
+		kuid_t uid1 = USER_AT(u1, i);
+		kuid_t uid2;
+		for (; j < u2->nusers; j++) {
+			uid2 = USER_AT(u2, j);
+			if (uid_lte(uid1, uid2))
+				break;
+		}
+		if (j >= u2->nusers || !uid_eq(uid1, uid2)) {
+			if (!uid_eq(uid1, cred2->uid)
+			    && !uid_eq(uid1, cred2->euid)
+			    && !uid_eq(uid1, cred2->suid))
+				return false;
+		} else {
+			j++;
+		}
+	}
+
+	return true;
+}
+
+/**
+ * set_current_users - Change current's supplementary user list
+ * @user_info: The user list to impose
+ *
+ * Validate a user list and, if valid, impose it upon current's task
+ * security record.
+ */
+int set_current_users(struct user_info *user_info)
+{
+	struct cred *new;
+
+	users_sort(user_info);
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+	if (!(ns_capable(current_user_ns(), CAP_SETUID)
+	      || user_subset(user_info, new))) {
+		abort_creds(new);
+		return -EPERM;
+	}
+
+	put_user_info(new->user_info);
+	get_user_info(user_info);
+	new->user_info = user_info;
+	return commit_creds(new);
+}
+
+SYSCALL_DEFINE2(getusers, int, uidsetsize, uid_t __user *, userlist)
+{
+	const struct cred *cred = current_cred();
+	int i;
+
+	if (uidsetsize < 0)
+		return -EINVAL;
+
+	/* no need to grab task_lock here; it cannot change */
+	i = cred->user_info->nusers;
+	if (uidsetsize) {
+		if (i > uidsetsize) {
+			i = -EINVAL;
+			goto out;
+		}
+		if (users_to_user(userlist, cred->user_info)) {
+			i = -EFAULT;
+			goto out;
+		}
+	}
+out:
+	return i;
+}
+
+SYSCALL_DEFINE2(setusers, int, uidsetsize, uid_t __user *, userlist)
+{
+	struct user_info *user_info;
+	int retval;
+
+	if ((unsigned)uidsetsize > NUSERS_MAX)
+		return -EINVAL;
+
+	user_info = users_alloc(uidsetsize);
+	if (!user_info)
+		return -ENOMEM;
+	retval = users_from_user(user_info, userlist);
+	if (retval) {
+		put_user_info(user_info);
+		return retval;
+	}
+
+	retval = set_current_users(user_info);
+	put_user_info(user_info);
+
+	return retval;
+}
+
+bool has_supplementary_uid(kuid_t uid)
+{
+	return users_search(current_cred()->user_info, uid);
+}
+#endif /* CONFIG_SUPPLEMENTARY_UIDS */
diff --git a/kernel/sys.c b/kernel/sys.c
index 1eaa2f0..412dda9 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -472,7 +472,8 @@ SYSCALL_DEFINE2(setreuid, uid_t, ruid, uid_t, euid)
 		new->uid = kruid;
 		if (!uid_eq(old->uid, kruid) &&
 		    !uid_eq(old->euid, kruid) &&
-		    !ns_capable(old->user_ns, CAP_SETUID))
+		    !ns_capable(old->user_ns, CAP_SETUID) &&
+		    !has_supplementary_uid(kruid))
 			goto error;
 	}
 
@@ -481,7 +482,8 @@ SYSCALL_DEFINE2(setreuid, uid_t, ruid, uid_t, euid)
 		if (!uid_eq(old->uid, keuid) &&
 		    !uid_eq(old->euid, keuid) &&
 		    !uid_eq(old->suid, keuid) &&
-		    !ns_capable(old->user_ns, CAP_SETUID))
+		    !ns_capable(old->user_ns, CAP_SETUID) &&
+		    !has_supplementary_uid(keuid))
 			goto error;
 	}
 
@@ -542,7 +544,8 @@ SYSCALL_DEFINE1(setuid, uid_t, uid)
 			if (retval < 0)
 				goto error;
 		}
-	} else if (!uid_eq(kuid, old->uid) && !uid_eq(kuid, new->suid)) {
+	} else if (!uid_eq(kuid, old->uid) && !uid_eq(kuid, new->suid) &&
+		   !has_supplementary_uid(kuid)) {
 		goto error;
 	}
 
@@ -594,13 +597,16 @@ SYSCALL_DEFINE3(setresuid, uid_t, ruid, uid_t, euid, uid_t, suid)
 	retval = -EPERM;
 	if (!ns_capable(old->user_ns, CAP_SETUID)) {
 		if (ruid != (uid_t) -1        && !uid_eq(kruid, old->uid) &&
-		    !uid_eq(kruid, old->euid) && !uid_eq(kruid, old->suid))
+		    !uid_eq(kruid, old->euid) && !uid_eq(kruid, old->suid) &&
+		    !has_supplementary_uid(kruid))
 			goto error;
 		if (euid != (uid_t) -1        && !uid_eq(keuid, old->uid) &&
-		    !uid_eq(keuid, old->euid) && !uid_eq(keuid, old->suid))
+		    !uid_eq(keuid, old->euid) && !uid_eq(keuid, old->suid) &&
+		    !has_supplementary_uid(keuid))
 			goto error;
 		if (suid != (uid_t) -1        && !uid_eq(ksuid, old->uid) &&
-		    !uid_eq(ksuid, old->euid) && !uid_eq(ksuid, old->suid))
+		    !uid_eq(ksuid, old->euid) && !uid_eq(ksuid, old->suid) &&
+		    !has_supplementary_uid(ksuid))
 			goto error;
 	}
 
@@ -750,7 +756,8 @@ SYSCALL_DEFINE1(setfsuid, uid_t, uid)
 
 	if (uid_eq(kuid, old->uid)  || uid_eq(kuid, old->euid)  ||
 	    uid_eq(kuid, old->suid) || uid_eq(kuid, old->fsuid) ||
-	    ns_capable(old->user_ns, CAP_SETUID)) {
+	    ns_capable(old->user_ns, CAP_SETUID) ||
+	    has_supplementary_uid(kuid)) {
 		if (!uid_eq(kuid, old->fsuid)) {
 			new->fsuid = kuid;
 			if (security_task_fix_setuid(new, old, LSM_SETID_FS) == 0)
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 02aa418..a8a8f02 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -159,6 +159,8 @@ cond_syscall(sys_uselib);
 cond_syscall(sys_fadvise64);
 cond_syscall(sys_fadvise64_64);
 cond_syscall(sys_madvise);
+cond_syscall(sys_getusers);
+cond_syscall(sys_setusers);
 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);
-- 
2.1.3
