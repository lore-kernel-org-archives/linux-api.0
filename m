Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795376229;
	b=uNeGMhi3sfKgVpgSQOtEYH/bHGJIaz8woboDt327Ctt3mMXVeddxSzezoDonIxautgBS
	 xqJP8E7cm5LOvJ201USPgs1pYGVM6aBxIkjgKpdFCtiyKMxe6nAfJ3WOcS25GqJZKuAcn
	 p4VxFKF10+gc3iMBi/kLo+BQ/Gmlqa/2pw+V0rRHpP0BvQo1AQFuuMF/cqJVyU0lZtzko
	 m8DQ0QTD26BYT6yPVlZ4syKcDnp64BHibr6CwYuaWFnsBeHbj8tb8YO3Fskj6W2UvCVxg
	 ZNaKhgMfTdvZZqWczYQ8nH1EIhH1bX94P9uZozxnWMQ0SM0AzpkiJZ/LHzao9yWhFEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795376229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=WbpDZaHnnjHuv0gV/3ertHEHpnm2j+Wl1rDtPX9sAVE=;
	b=RRjeB61CC/y26o8bU3HgezfoTbLiY5xoGjzCj7cF/BuPf2VBEXqmhqzPDPb+k6TFHG9K
	 gOAUUyyIoAdq3HzRCqDY+jVOMcz/n6LyBeUvfew/yzckMgLVYhvYJ1QeNYeXVnKjHd+b/
	 EErdi13SUuvVKqLVFlswTyTCdaFY6deWj5M+yunXJBOXpZ0rcLfXQGykMx7vB5YLbTaPO
	 EzOWksoxrfHCVbiEe6RcXt0DGfAkuMmeRgZ22BMQt3GXfcOkcJ+apyK6O3jUcP8JlbIMe
	 sBFMM6RgXlgYeoq1CzO541GP+WGS9xusPugkygJYqAe1ThVSQHBsYZOz6szntqG2ZMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WqYJWrMV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CAA8160A262F;
	Sun, 22 Nov 2026 19:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WqYJWrMV
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C9A461F000E1;
	Sun, 22 Nov 2026 19:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376229;
	bh=WbpDZaHnnjHuv0gV/3ertHEHpnm2j+Wl1rDtPX9sAVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WqYJWrMVyfrrFpHYDBIeYbZTdkThiLeA0h7xG6SorN1P38Pb/Vo5Nm2CC0UQ/+jYt
	 juNebkrwS3APCUe0n9MntHRtNGbt8BTkyOp62dBAoNcCBJphyTEIrBtBSU0WxHxC2x
	 w6Su1GLrqSMhHXiBrRQhk1lPlC406bGjnNR8Dhe9pxAMdwdySto3SbNqtXlIGZYazB
	 uMIaYgPHC5yx/iw1U5fuHJoOqjcUnBHQQPE40trffiGzDb5/a0D1CVMHPV/oCgBPZZ
	 /Kr1aM1M/5UfhyUgni55gJgOvY0yK6icr25E7+pu2VSBHuINay5oqoCPMofHi/uDuV
	 NS/qdUT6d/0dA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v7 17/26] fork: Support CLONE_INTO_USERLAND in clone3()
Date: Sun, 22 Nov 2026 21:35:30 +0200
Message-ID: <20261122193539.3334213-18-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Multithreaded userspace daemons cannot call setns(CLONE_NEWUSER) or
safely mutate process-wide filesystem state in place before spawning a
child into a target namespace set.

Add CLONE_INTO_USERLAND and struct clone_args.userland
(CLONE_ARGS_SIZE_VER3) to spawn a child process directly into a userland
whose root mount has been installed. Transition the userland from
USERLAND_INIT through USERLAND_FORKING to USERLAND_RUNNING for the first
process so it becomes PID 1, serialize concurrent entrants on waitq
until bootstrap resolves, and admit subsequent callers into the running
PID namespace until teardown begins.

Derive child credentials from current, require CAP_SYS_ADMIN and
CAP_SYS_CHROOT in the target user namespace and an ancestor active PID
namespace, preserve caller umask, reset dumpability across user
namespace transitions, commit time namespace vvar mappings after
copy_process() succeeds, and look up the live mount namespace root.
Restrict companion flags to CLONE_VFORK, CLONE_PIDFD,
CLONE_PIDFD_AUTOKILL, CLONE_AUTOREAP, CLONE_CLEAR_SIGHAND,
CLONE_INTO_CGROUP, and CLONE_NNP.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/cred.h       |   4 +-
 include/linux/nsproxy.h    |   4 +-
 include/linux/sched/task.h |   6 ++
 include/linux/userland.h   |  15 ++++
 include/uapi/linux/sched.h |   5 ++
 kernel/cred.c              |  27 ++++++-
 kernel/fork.c              |  70 ++++++++++++++++---
 kernel/nsproxy.c           |   9 ++-
 kernel/userland.c          | 139 +++++++++++++++++++++++++++++++++++++
 9 files changed, 266 insertions(+), 13 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 49c26af37349..e0bb4d3eab17 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -19,6 +19,7 @@
 
 struct cred;
 struct inode;
+struct userland;
 
 extern struct task_struct init_task;
 
@@ -152,7 +153,8 @@ struct cred {
 
 extern void __put_cred(struct cred *);
 extern void exit_creds(struct task_struct *);
-extern int copy_creds(struct task_struct *, u64);
+int copy_creds(struct task_struct *tsk, u64 clone_flags,
+	       struct userland *userland);
 extern const struct cred *get_task_cred(struct task_struct *);
 extern struct cred *cred_alloc_blank(void);
 extern struct cred *prepare_creds(void);
diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index d611c40cb4ce..17bd48433bba 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -12,6 +12,7 @@ struct ipc_namespace;
 struct pid_namespace;
 struct cgroup_namespace;
 struct fs_struct;
+struct userland;
 struct user_namespace;
 
 /*
@@ -96,7 +97,8 @@ static inline struct cred *nsset_cred(struct nsset *set)
 struct nsproxy *create_new_namespaces(u64 flags, struct task_struct *tsk,
 				      struct user_namespace *user_ns,
 				      struct fs_struct *new_fs);
-int copy_namespaces(u64 flags, struct task_struct *tsk);
+int copy_namespaces(u64 flags, struct task_struct *tsk,
+		    struct userland *userland);
 void switch_cred_namespaces(const struct cred *old, const struct cred *new);
 void exit_nsproxy_namespaces(struct task_struct *tsk);
 void get_cred_namespaces(struct task_struct *tsk);
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 90ed5bc3c7af..c21ac74d7b72 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -16,6 +16,8 @@ struct task_struct;
 struct rusage;
 union thread_union;
 struct css_set;
+struct file;
+struct userland;
 
 /* All the bits taken by the old clone syscall. */
 #define CLONE_LEGACY_FLAGS 0xffffffffULL
@@ -39,11 +41,15 @@ struct kernel_clone_args {
 	/* Number of elements in *set_tid */
 	size_t set_tid_size;
 	int cgroup;
+	int userland_fd;
 	int idle;
 	int (*fn)(void *);
 	void *fn_arg;
 	struct cgroup *cgrp;
 	struct css_set *cset;
+	struct file *userland_file;
+	struct userland *userland;
+	bool userland_bootstrapping;
 	unsigned int kill_seq;
 };
 
diff --git a/include/linux/userland.h b/include/linux/userland.h
index da0978db54dd..a9b99642c46e 100644
--- a/include/linux/userland.h
+++ b/include/linux/userland.h
@@ -13,6 +13,7 @@
 #include <linux/wait.h>
 
 struct file;
+struct kernel_clone_args;
 struct nsproxy;
 struct pid;
 struct pid_namespace;
@@ -80,6 +81,9 @@ long userland_waitid(int upid, struct waitid_info *infop, int options,
 		     struct rusage *ru);
 int userland_send_signal(struct file *file, int sig,
 			 struct siginfo __user *info, unsigned int flags);
+int userland_prepare_fork(struct kernel_clone_args *args);
+int userland_finish_fork(struct kernel_clone_args *args,
+			 struct task_struct *p);
 #else
 static inline void userland_put(struct userland *c)
 {
@@ -112,6 +116,17 @@ static inline int userland_send_signal(struct file *file, int sig,
 {
 	return -EBADF;
 }
+
+static inline int userland_prepare_fork(struct kernel_clone_args *args)
+{
+	return -EINVAL;
+}
+
+static inline int userland_finish_fork(struct kernel_clone_args *args,
+				       struct task_struct *p)
+{
+	return 0;
+}
 #endif /* CONFIG_USERLAND */
 
 #endif /* _LINUX_USERLAND_H */
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 19ffeba89428..30551f4cdedb 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -40,6 +40,7 @@
 #define CLONE_NNP		(1ULL << 35) /* Set no_new_privs on child. */
 #define CLONE_PIDFD_AUTOKILL	(1ULL << 36) /* Kill child when clone pidfd closes. */
 #define CLONE_EMPTY_MNTNS	(1ULL << 37) /* Create an empty mount namespace. */
+#define CLONE_INTO_USERLAND	(1ULL << 38) /* Clone into a userland. */
 
 /*
  * cloning flags intersect with CSIGNAL so can be used with unshare and clone3
@@ -94,6 +95,8 @@
  *                kernel's limit of nested PID namespaces.
  * @cgroup:       If CLONE_INTO_CGROUP is specified set this to
  *                a file descriptor for the cgroup.
+ * @userland:     If CLONE_INTO_USERLAND is specified set this to
+ *                a file descriptor for the userland.
  *
  * The structure is versioned by size and thus extensible.
  * New struct members must go at the end of the struct and
@@ -111,12 +114,14 @@ struct clone_args {
 	__aligned_u64 set_tid;
 	__aligned_u64 set_tid_size;
 	__aligned_u64 cgroup;
+	__aligned_u64 userland;
 };
 #endif
 
 #define CLONE_ARGS_SIZE_VER0 64 /* sizeof first published struct */
 #define CLONE_ARGS_SIZE_VER1 80 /* sizeof second published struct */
 #define CLONE_ARGS_SIZE_VER2 88 /* sizeof third published struct */
+#define CLONE_ARGS_SIZE_VER3 96 /* sizeof fourth published struct */
 
 /*
  * Scheduling policies
diff --git a/kernel/cred.c b/kernel/cred.c
index d01df40a9a38..6bb83edd22b5 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -12,13 +12,16 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/sched/coredump.h>
+#include <linux/sched/exec_state.h>
 #include <linux/key.h>
 #include <linux/keyctl.h>
 #include <linux/init_task.h>
+#include <linux/userland.h>
 #include <linux/security.h>
 #include <linux/binfmts.h>
 #include <linux/cn_proc.h>
 #include <linux/uidgid.h>
+#include <linux/user_namespace.h>
 
 #if 0
 #define kdebug(FMT, ...)						\
@@ -251,6 +254,9 @@ struct cred *prepare_exec_creds(void)
 	return new;
 }
 
+static bool cred_cap_issubset(const struct cred *set,
+			      const struct cred *subset);
+
 /*
  * Copy credentials for the new process created by fork()
  *
@@ -260,7 +266,8 @@ struct cred *prepare_exec_creds(void)
  * The new process gets the current process's subjective credentials as its
  * objective and subjective credentials
  */
-int copy_creds(struct task_struct *p, u64 clone_flags)
+int copy_creds(struct task_struct *p, u64 clone_flags,
+	       struct userland *userland)
 {
 	struct cred *new;
 	int ret;
@@ -287,6 +294,24 @@ int copy_creds(struct task_struct *p, u64 clone_flags)
 	if (!new)
 		return -ENOMEM;
 
+	if (userland) {
+		const struct cred *old = current_cred();
+
+		if (new->user_ns != userland->user_ns) {
+			ret = install_user_ns_cred(new, userland->user_ns);
+			if (ret < 0)
+				goto error_put;
+		}
+		if (!cred_cap_issubset(old, new) ||
+		    old->user_ns != new->user_ns) {
+			struct task_exec_state *exec_state;
+
+			exec_state = rcu_dereference_protected(p->exec_state, true);
+			if (exec_state != &init_task_exec_state)
+				WRITE_ONCE(exec_state->dumpable, suid_dumpable);
+		}
+	}
+
 	if (clone_flags & CLONE_NEWUSER) {
 		ret = create_user_ns(new);
 		if (ret < 0)
diff --git a/kernel/fork.c b/kernel/fork.c
index d87ab7cbad5e..d8fc18a9af22 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -65,6 +65,7 @@
 #include <linux/rcupdate.h>
 #include <linux/ptrace.h>
 #include <linux/mount.h>
+#include <linux/mnt_namespace.h>
 #include <linux/audit.h>
 #include <linux/memcontrol.h>
 #include <linux/ftrace.h>
@@ -1616,7 +1617,7 @@ static int copy_exec_state(u64 clone_flags, struct task_struct *tsk)
 	struct task_exec_state *exec_state;
 
 	/* CLONE_VM siblings refcount-share the parent's exec_state. */
-	if (clone_flags & CLONE_VM) {
+	if ((clone_flags & (CLONE_VM | CLONE_INTO_USERLAND)) == CLONE_VM) {
 		exec_state = rcu_dereference_protected(current->exec_state, true);
 		refcount_inc(&exec_state->count);
 		rcu_assign_pointer(tsk->exec_state, exec_state);
@@ -1633,7 +1634,7 @@ enum copy_fs_flags_t {
 };
 
 static int copy_fs(u64 clone_flags, struct task_struct *tsk,
-		   enum copy_fs_flags_t flags)
+		   enum copy_fs_flags_t flags, struct userland *userland)
 {
 	struct fs_struct *fs;
 
@@ -1649,7 +1650,7 @@ static int copy_fs(u64 clone_flags, struct task_struct *tsk,
 		if (current->nsproxy->mnt_ns != &init_mnt_ns)
 			return -EINVAL;
 		fs = userspace_init_fs;
-	} else if (flags & COPY_FS_IDLE) {
+	} else if (flags & COPY_FS_IDLE || userland) {
 		fs = &init_fs;
 	} else {
 		fs = current->fs;
@@ -1671,6 +1672,21 @@ static int copy_fs(u64 clone_flags, struct task_struct *tsk,
 	tsk->real_fs = tsk->fs = copy_fs_struct(fs);
 	if (!tsk->fs)
 		return -ENOMEM;
+	if (userland) {
+		struct path root __free(path_put) = {};
+		int err;
+
+		err = mnt_ns_get_root(userland->ns->mnt_ns, &root);
+		if (err) {
+			free_fs_struct(tsk->fs);
+			tsk->real_fs = NULL;
+			tsk->fs = NULL;
+			return err;
+		}
+		tsk->fs->umask = READ_ONCE(current->fs->umask);
+		set_fs_root(tsk->fs, &root);
+		set_fs_pwd(tsk->fs, &root);
+	}
 	return 0;
 }
 
@@ -2186,7 +2202,7 @@ __latent_entropy struct task_struct *copy_process(
 #ifdef CONFIG_PROVE_LOCKING
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
-	retval = copy_creds(p, clone_flags);
+	retval = copy_creds(p, clone_flags, args->userland);
 	if (retval < 0)
 		goto bad_fork_free;
 
@@ -2317,7 +2333,7 @@ __latent_entropy struct task_struct *copy_process(
 		goto bad_fork_cleanup_semundo;
 	retval = copy_fs(clone_flags, p,
 			 (args->umh ? COPY_FS_UMH : 0) |
-			 (args->idle ? COPY_FS_IDLE : 0));
+			 (args->idle ? COPY_FS_IDLE : 0), args->userland);
 	if (retval)
 		goto bad_fork_cleanup_semundo;
 	retval = copy_sighand(clone_flags, p);
@@ -2329,7 +2345,7 @@ __latent_entropy struct task_struct *copy_process(
 	retval = copy_mm(clone_flags, p);
 	if (retval)
 		goto bad_fork_cleanup_signal;
-	retval = copy_namespaces(clone_flags, p);
+	retval = copy_namespaces(clone_flags, p, args->userland);
 	if (retval)
 		goto bad_fork_cleanup_mm;
 	retval = copy_io(clone_flags, p);
@@ -2510,6 +2526,11 @@ __latent_entropy struct task_struct *copy_process(
 		goto bad_fork_core_free;
 	}
 
+	if (unlikely(args->userland_bootstrapping && !is_child_reaper(pid))) {
+		retval = -EBUSY;
+		goto bad_fork_core_free;
+	}
+
 	/* Let kill terminate clone/fork in the middle */
 	if (fatal_signal_pending(current)) {
 		retval = -EINTR;
@@ -2586,7 +2607,7 @@ __latent_entropy struct task_struct *copy_process(
 	write_unlock_irq(&tasklist_lock);
 
 	if (likely(p->pid) && thread_group_leader(p))
-		userland_copy(p, pid, NULL);
+		userland_copy(p, pid, args->userland);
 
 	if (pidfile)
 		fd_install(pidfd, pidfile);
@@ -2781,6 +2802,13 @@ pid_t kernel_clone(struct kernel_clone_args *args)
 	if (!valid_signal(args->exit_signal))
 		return -EINVAL;
 
+	if (unlikely(clone_flags & CLONE_INTO_USERLAND)) {
+		int err = userland_prepare_fork(args);
+
+		if (err)
+			return err;
+	}
+
 	/*
 	 * Determine whether and which event to report to ptracer.  When
 	 * called from kernel_thread or CLONE_UNTRACED is explicitly
@@ -2802,6 +2830,13 @@ pid_t kernel_clone(struct kernel_clone_args *args)
 	p = copy_process(NULL, trace, NUMA_NO_NODE, args);
 	add_latent_entropy();
 
+	if (unlikely(clone_flags & CLONE_INTO_USERLAND)) {
+		int err = userland_finish_fork(args, p);
+
+		if (err)
+			return err;
+	}
+
 	if (IS_ERR(p))
 		return PTR_ERR(p);
 
@@ -2959,7 +2994,9 @@ static noinline int copy_clone_args_from_user(struct kernel_clone_args *kargs,
 		     CLONE_ARGS_SIZE_VER1);
 	BUILD_BUG_ON(offsetofend(struct clone_args, cgroup) !=
 		     CLONE_ARGS_SIZE_VER2);
-	BUILD_BUG_ON(sizeof(struct clone_args) != CLONE_ARGS_SIZE_VER2);
+	BUILD_BUG_ON(offsetofend(struct clone_args, userland) !=
+		     CLONE_ARGS_SIZE_VER3);
+	BUILD_BUG_ON(sizeof(struct clone_args) != CLONE_ARGS_SIZE_VER3);
 
 	if (unlikely(usize > PAGE_SIZE))
 		return -E2BIG;
@@ -2989,6 +3026,10 @@ static noinline int copy_clone_args_from_user(struct kernel_clone_args *kargs,
 	    (args.cgroup > INT_MAX || usize < CLONE_ARGS_SIZE_VER2))
 		return -EINVAL;
 
+	if ((args.flags & CLONE_INTO_USERLAND) &&
+	    (args.userland > INT_MAX || usize < CLONE_ARGS_SIZE_VER3))
+		return -EINVAL;
+
 	*kargs = (struct kernel_clone_args){
 		.flags		= args.flags,
 		.pidfd		= u64_to_user_ptr(args.pidfd),
@@ -3000,6 +3041,7 @@ static noinline int copy_clone_args_from_user(struct kernel_clone_args *kargs,
 		.tls		= args.tls,
 		.set_tid_size	= args.set_tid_size,
 		.cgroup		= args.cgroup,
+		.userland_fd	= args.userland,
 	};
 
 	if (args.set_tid &&
@@ -3040,13 +3082,19 @@ static inline bool clone3_stack_valid(struct kernel_clone_args *kargs)
 	return true;
 }
 
+#define CLONE_INTO_USERLAND_FLAGS \
+	(CLONE_INTO_USERLAND | CLONE_VFORK | CLONE_PIDFD | \
+	 CLONE_CLEAR_SIGHAND | CLONE_INTO_CGROUP | CLONE_AUTOREAP | \
+	 CLONE_NNP | CLONE_PIDFD_AUTOKILL)
+
 static bool clone3_args_valid(struct kernel_clone_args *kargs)
 {
 	/* Verify that no unknown flags are passed along. */
 	if (kargs->flags &
 	    ~(CLONE_LEGACY_FLAGS | CLONE_CLEAR_SIGHAND |
 	      CLONE_INTO_CGROUP | CLONE_AUTOREAP | CLONE_NNP |
-	      CLONE_PIDFD_AUTOKILL | CLONE_EMPTY_MNTNS))
+	      CLONE_PIDFD_AUTOKILL | CLONE_EMPTY_MNTNS |
+	      CLONE_INTO_USERLAND))
 		return false;
 
 	/*
@@ -3064,6 +3112,10 @@ static bool clone3_args_valid(struct kernel_clone_args *kargs)
 	    kargs->exit_signal)
 		return false;
 
+	if ((kargs->flags & CLONE_INTO_USERLAND) &&
+	    (kargs->flags & ~CLONE_INTO_USERLAND_FLAGS))
+		return false;
+
 	if (!clone3_stack_valid(kargs))
 		return false;
 
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 3c4161515c3c..90cf3c799152 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -13,6 +13,7 @@
 #include <linux/export.h>
 #include <linux/nsproxy.h>
 #include <linux/ns/ns_common_types.h>
+#include <linux/userland.h>
 #include <linux/init_task.h>
 #include <linux/mnt_namespace.h>
 #include <linux/utsname.h>
@@ -166,12 +167,18 @@ struct nsproxy *create_new_namespaces(u64 flags, struct task_struct *tsk,
  * called from clone.  This now handles copy for nsproxy and all
  * namespaces therein.
  */
-int copy_namespaces(u64 flags, struct task_struct *tsk)
+int copy_namespaces(u64 flags, struct task_struct *tsk,
+		    struct userland *userland)
 {
 	struct nsproxy *old_ns = tsk->nsproxy;
 	struct user_namespace *user_ns = task_cred_xxx(tsk, user_ns);
 	struct nsproxy *new_ns;
 
+	if (userland) {
+		get_nsproxy(userland->ns);
+		tsk->nsproxy = userland->ns;
+		return 0;
+	}
 	if (likely(!(flags & (CLONE_NS_ALL & ~CLONE_NEWUSER)))) {
 		if ((flags & CLONE_VM) ||
 		    likely(old_ns->time_ns_for_children == old_ns->time_ns)) {
diff --git a/kernel/userland.c b/kernel/userland.c
index f449e2ff9152..2375442733b6 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -17,6 +17,7 @@
 #include <linux/file.h>
 #include <linux/freezer.h>
 #include <linux/fs.h>
+#include <linux/fs_struct.h>
 #include <linux/anon_inodes.h>
 #include <linux/userland.h>
 #include <linux/sched/signal.h>
@@ -551,3 +552,141 @@ SYSCALL_DEFINE1(userland_open, unsigned int, flags)
 
 	return fd;
 }
+
+/**
+ * DOC: CLONE_INTO_USERLAND
+ *
+ * Passing ``CLONE_INTO_USERLAND`` in ``struct clone_args.flags`` (with
+ * ``size >= CLONE_ARGS_SIZE_VER3``) spawns the child into the userland identified
+ * by ``struct clone_args.userland`` once ``"/"`` is mounted in its mount
+ * namespace. The first caller bootstraps PID 1 while concurrent bootstrap
+ * callers wait killably; subsequent callers join the running PID namespace
+ * until teardown begins.
+ *
+ * Requires ``CAP_SYS_ADMIN`` and ``CAP_SYS_CHROOT`` in the target user
+ * namespace (plus ``CAP_SYS_CHROOT`` in the caller's user namespace when
+ * chrooted) and an ancestor active PID namespace. May be combined with
+ * ``CLONE_VFORK``, ``CLONE_PIDFD``, ``CLONE_PIDFD_AUTOKILL``,
+ * ``CLONE_AUTOREAP``, ``CLONE_CLEAR_SIGHAND``, ``CLONE_INTO_CGROUP``, and
+ * ``CLONE_NNP``.
+ *
+ * When spawning from outside the userland's user namespace, the child's
+ * credentials are copied from ``current`` and installed into the userland's
+ * user namespace with capabilities recomputed as in ``setns(CLONE_NEWUSER)``
+ * and dumpability reset to ``suid_dumpable``, retaining ``current``'s kernel
+ * UID, GID, and supplementary groups as mapped there.
+ */
+static bool userland_pidns_alive(struct pid_namespace *pid_ns)
+{
+	for (; pid_ns != &init_pid_ns; pid_ns = pid_ns->parent) {
+		if (!(READ_ONCE(pid_ns->pid_allocated) & PIDNS_ADDING))
+			return false;
+	}
+	return true;
+}
+
+int userland_prepare_fork(struct kernel_clone_args *args)
+{
+	struct file *file __free(fput) = fget(args->userland_fd);
+	struct path root __free(path_put) = {};
+	struct pid_namespace *pid_ns;
+	bool bootstrapping = false;
+	struct userland *userland;
+	int ret;
+
+	if (!file)
+		return -EBADF;
+	if (!userland_is_file(file))
+		return -EINVAL;
+
+	userland = file->private_data;
+	if (!ns_capable(userland->user_ns, CAP_SYS_ADMIN) ||
+	    !ns_capable(userland->user_ns, CAP_SYS_CHROOT))
+		return -EPERM;
+	if (current_chrooted() && !ns_capable(current_user_ns(), CAP_SYS_CHROOT))
+		return -EPERM;
+
+	pid_ns = userland->ns->pid_ns_for_children;
+	if (!pidns_is_ancestor(pid_ns, task_active_pid_ns(current)))
+		return -EXDEV;
+
+	ret = mnt_ns_get_root(userland->ns->mnt_ns, &root);
+	if (ret)
+		return ret;
+
+	for (;;) {
+		bool wait = false;
+
+		scoped_guard(spinlock, &userland->lock) {
+			switch (userland->state) {
+			case USERLAND_INIT:
+				if (!userland_pidns_alive(pid_ns))
+					return -ESRCH;
+				if (READ_ONCE(pid_ns->child_reaper))
+					return -EBUSY;
+				WRITE_ONCE(userland->state, USERLAND_FORKING);
+				bootstrapping = true;
+				break;
+			case USERLAND_FORKING:
+				wait = true;
+				break;
+			case USERLAND_RUNNING:
+				if (!userland_pidns_alive(pid_ns))
+					return -ESRCH;
+				break;
+			case USERLAND_DEAD:
+				return -ESRCH;
+			}
+		}
+		if (!wait)
+			break;
+
+		ret = wait_event_killable(userland->waitq,
+					  READ_ONCE(userland->state) !=
+					  USERLAND_FORKING);
+		if (ret)
+			return ret;
+	}
+
+	args->userland_file = no_free_ptr(file);
+	args->userland = userland;
+	args->userland_bootstrapping = bootstrapping;
+	return 0;
+}
+
+int userland_finish_fork(struct kernel_clone_args *args,
+			 struct task_struct *p)
+{
+	struct file *file __free(fput) = args->userland_file;
+	struct userland *userland = args->userland;
+	struct pid_namespace *pid_ns = userland->ns->pid_ns_for_children;
+	int ret;
+
+	args->userland_file = NULL;
+	args->userland = NULL;
+	if (!IS_ERR(p)) {
+		if (args->userland_bootstrapping)
+			wake_up_all(&userland->waitq);
+		if (current->nsproxy->time_ns != userland->ns->time_ns)
+			timens_commit(p, userland->ns->time_ns);
+		return 0;
+	}
+
+	ret = PTR_ERR(p);
+	if (args->userland_bootstrapping) {
+		scoped_guard(spinlock, &userland->lock) {
+			if (userland->state == USERLAND_FORKING)
+				WRITE_ONCE(userland->state, USERLAND_INIT);
+		}
+		wake_up_all(&userland->waitq);
+		if (ret == -EINVAL && !args->set_tid_size &&
+		    (READ_ONCE(pid_ns->child_reaper) ||
+		     (READ_ONCE(pid_ns->pid_allocated) & ~PIDNS_ADDING)))
+			ret = -EBUSY;
+	}
+	if ((ret == -ENOMEM || ret == -EBUSY) &&
+	    !userland_pidns_alive(pid_ns))
+		return -ESRCH;
+
+	return ret;
+}
-- 
2.47.3

