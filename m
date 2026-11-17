Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794957278;
	b=ZUSvC8Th/g1/ZcLKtHPio+GCzY0DAwQbLy3uHh7qivJFymRPakZSNdMhZXfRGKUua5gW
	 NfFd9JmqjCXuMS34TyIwby+kOCGZQHmF2JatgBncennX2fhyoj1rBO5k+UNHdFqU2osHy
	 AKYc2w0bAv2/vUfS190ASr+SNEez+bq4B236GtBXczrfdPGTN24OQ+H9Sim4PyEml1gxu
	 CsbwWmXG/Z+IS1+1PaF7DIsJbGcLeMjKU3Ny0P8BrItQCGOCGvNPafWsk2sVGUPMgAwCa
	 8XFrfmd7gyL5i3J5AkU4oV5+pe1+oRYNqqE5fUPZBulxiE6N3RSm9736q9d987i6zww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794957278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=W90JlSi/rRvRu4a1rujnuubFz7IsSDtPR8hLiIDF+8k=;
	b=jRQJUboGWjcJy6hwixq8979EPnBCoK5tbDHtZhU6c2M6PvJwoD8dolFA1qjzHK9+9IBB
	 CgxadAkwLhGhI0u605EYOpQXlZZTVM1E2zSfuPCy0GKO1k8Ho49RK6aYbBuyCEOJFTe/w
	 gDoXJiwP2s5RwSSvXWzWiFNz4SWtx7ts6v4f1Vn1+cfV51BkdXzKXmzpy1IFqFUpUysdl
	 O+JHkkOiox9NtuEt3G+nZtHX1sJxH5NYQjgRUCyJqmO72b/CpDi4qHsbG8ZbEiRMUs/t3
	 wl2S9ralc7eZyyfjWJcAK1cYSV9hsykPlFL7h8pvOOXMfxV9kgUkw5agbL6W7aupPew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QIwmfUVY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 35BB1606A32A;
	Tue, 17 Nov 2026 23:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QIwmfUVY
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 20D7E1F000C7;
	Tue, 17 Nov 2026 23:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957277;
	bh=W90JlSi/rRvRu4a1rujnuubFz7IsSDtPR8hLiIDF+8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QIwmfUVYU5IQTDO5BzjDyxoXLrI/H3GCBN+1+Shdo7WL1bhnLxRRVat1j97HFR/Xj
	 5KS2p98rfK6tWv8rny72rSF3jlLWK3LJ9gssXWfv+sgBzAmV6ym2xTU1dVkpYQeI3b
	 SH59yr2jv7xaS7j6FreSbxUdcd9ySHTVhKW68btZts/NmvVM2VqRsqzzgxHOv/ZwGD
	 P0y7J9exQVFd6h+w4CxCS2KU90VEV+QdFhFkne/Rt9uJJ2AohZ0+MtheL/O70lLq31
	 8I1mrEJYyHOr/Ym8hX9wqSGfh6JLOAcsJU0iEEPVlYy0ANRJhFWXeQ9iYJUf2112k/
	 lpKYOBv/JbIlg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v2 07/13] fork: Support CLONE_INTO_ROOTNS in clone3()
Date: Wed, 18 Nov 2026 01:13:46 +0200
Message-ID: <20261117231352.3816603-8-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
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

Add CLONE_INTO_ROOTNS and struct clone_args.rootns (CLONE_ARGS_SIZE_VER3)
to spawn a child process directly into a rootns whose root mount has
been installed. Transition the rootns from ROOTNS_READY through
ROOTNS_FORKING to ROOTNS_RUNNING for the first process so it becomes
PID 1, serialize concurrent entrants on waitq until bootstrap resolves,
and admit subsequent callers into the running PID namespace until
teardown begins.

Require CAP_SYS_ADMIN in the target user namespace, forbid credential
privilege escalation, and require an ancestor active PID namespace so
the caller receives a valid child PID. Restrict companion flags to
CLONE_VFORK, CLONE_VM (with CLONE_VFORK), CLONE_PIDFD,
CLONE_PIDFD_AUTOKILL, CLONE_AUTOREAP, CLONE_CLEAR_SIGHAND,
CLONE_INTO_CGROUP, and CLONE_NNP.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/cred.h       |   4 +-
 include/linux/nsproxy.h    |   4 +-
 include/linux/rootns.h     |  14 ++++
 include/linux/sched/task.h |   8 +++
 include/uapi/linux/sched.h |   5 ++
 kernel/cred.c              |  70 +++++++++++++------
 kernel/fork.c              |  67 +++++++++++++++---
 kernel/nsproxy.c           |  11 ++-
 kernel/rootns.c            | 137 +++++++++++++++++++++++++++++++++++++
 9 files changed, 288 insertions(+), 32 deletions(-)

diff --git a/include/linux/cred.h b/include/linux/cred.h
index 49c26af37349..9849366fd44b 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -19,6 +19,7 @@
 
 struct cred;
 struct inode;
+struct rootns;
 
 extern struct task_struct init_task;
 
@@ -152,7 +153,8 @@ struct cred {
 
 extern void __put_cred(struct cred *);
 extern void exit_creds(struct task_struct *);
-extern int copy_creds(struct task_struct *, u64);
+int copy_creds(struct task_struct *tsk, u64 clone_flags,
+	       struct rootns *rootns);
 extern const struct cred *get_task_cred(struct task_struct *);
 extern struct cred *cred_alloc_blank(void);
 extern struct cred *prepare_creds(void);
diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index cacbbbe3f1ce..26b3b788cc90 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -12,6 +12,7 @@ struct ipc_namespace;
 struct pid_namespace;
 struct cgroup_namespace;
 struct fs_struct;
+struct rootns;
 struct user_namespace;
 
 /*
@@ -97,7 +98,8 @@ struct nsproxy *create_new_namespaces(u64 flags,
 				      struct nsproxy *ns,
 				      struct user_namespace *user_ns,
 				      struct fs_struct *new_fs);
-int copy_namespaces(u64 flags, struct task_struct *tsk);
+int copy_namespaces(u64 flags, struct task_struct *tsk,
+		    struct rootns *rootns);
 void switch_cred_namespaces(const struct cred *old, const struct cred *new);
 void exit_nsproxy_namespaces(struct task_struct *tsk);
 void get_cred_namespaces(struct task_struct *tsk);
diff --git a/include/linux/rootns.h b/include/linux/rootns.h
index b8437bf21830..2077b28e39c7 100644
--- a/include/linux/rootns.h
+++ b/include/linux/rootns.h
@@ -14,6 +14,7 @@
 
 struct cred;
 struct file;
+struct kernel_clone_args;
 struct nsproxy;
 struct pid;
 struct pid_namespace;
@@ -50,6 +51,8 @@ void put_rootns(struct rootns *c);
 bool is_rootns_file(struct file *file);
 void copy_rootns(struct task_struct *tsk, struct rootns *rootns);
 void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk);
+int rootns_prepare_fork(struct kernel_clone_args *args);
+int rootns_finish_fork(struct kernel_clone_args *args, struct task_struct *p);
 #else
 static inline struct rootns *get_rootns(struct rootns *c)
 {
@@ -73,6 +76,17 @@ static inline void exit_rootns(struct pid_namespace *pid_ns,
 			       struct task_struct *tsk)
 {
 }
+
+static inline int rootns_prepare_fork(struct kernel_clone_args *args)
+{
+	return -EINVAL;
+}
+
+static inline int rootns_finish_fork(struct kernel_clone_args *args,
+				     struct task_struct *p)
+{
+	return 0;
+}
 #endif /* CONFIG_ROOTNS */
 
 #endif /* _LINUX_ROOTNS_H */
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 90ed5bc3c7af..e0c4e8ab02f1 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -16,6 +16,8 @@ struct task_struct;
 struct rusage;
 union thread_union;
 struct css_set;
+struct file;
+struct rootns;
 
 /* All the bits taken by the old clone syscall. */
 #define CLONE_LEGACY_FLAGS 0xffffffffULL
@@ -39,11 +41,17 @@ struct kernel_clone_args {
 	/* Number of elements in *set_tid */
 	size_t set_tid_size;
 	int cgroup;
+	int rootns_fd;
 	int idle;
 	int (*fn)(void *);
 	void *fn_arg;
 	struct cgroup *cgrp;
 	struct css_set *cset;
+#ifdef CONFIG_ROOTNS
+	struct file *rootns_file;
+	struct rootns *rootns;
+	bool rootns_bootstrapping;
+#endif
 	unsigned int kill_seq;
 };
 
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 19ffeba89428..405cfc954ae1 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -40,6 +40,7 @@
 #define CLONE_NNP		(1ULL << 35) /* Set no_new_privs on child. */
 #define CLONE_PIDFD_AUTOKILL	(1ULL << 36) /* Kill child when clone pidfd closes. */
 #define CLONE_EMPTY_MNTNS	(1ULL << 37) /* Create an empty mount namespace. */
+#define CLONE_INTO_ROOTNS	(1ULL << 38) /* Clone into a specific root namespace. */
 
 /*
  * cloning flags intersect with CSIGNAL so can be used with unshare and clone3
@@ -94,6 +95,8 @@
  *                kernel's limit of nested PID namespaces.
  * @cgroup:       If CLONE_INTO_CGROUP is specified set this to
  *                a file descriptor for the cgroup.
+ * @rootns:       If CLONE_INTO_ROOTNS is specified set this to
+ *                a file descriptor for the root namespace.
  *
  * The structure is versioned by size and thus extensible.
  * New struct members must go at the end of the struct and
@@ -111,12 +114,14 @@ struct clone_args {
 	__aligned_u64 set_tid;
 	__aligned_u64 set_tid_size;
 	__aligned_u64 cgroup;
+	__aligned_u64 rootns;
 };
 #endif
 
 #define CLONE_ARGS_SIZE_VER0 64 /* sizeof first published struct */
 #define CLONE_ARGS_SIZE_VER1 80 /* sizeof second published struct */
 #define CLONE_ARGS_SIZE_VER2 88 /* sizeof third published struct */
+#define CLONE_ARGS_SIZE_VER3 96 /* sizeof fourth published struct */
 
 /*
  * Scheduling policies
diff --git a/kernel/cred.c b/kernel/cred.c
index d01df40a9a38..afc91eed2656 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -15,10 +15,12 @@
 #include <linux/key.h>
 #include <linux/keyctl.h>
 #include <linux/init_task.h>
+#include <linux/rootns.h>
 #include <linux/security.h>
 #include <linux/binfmts.h>
 #include <linux/cn_proc.h>
 #include <linux/uidgid.h>
+#include <linux/user_namespace.h>
 
 #if 0
 #define kdebug(FMT, ...)						\
@@ -162,24 +164,8 @@ struct cred *cred_alloc_blank(void)
 	return NULL;
 }
 
-/**
- * prepare_creds - Prepare a new set of credentials for modification
- *
- * Prepare a new set of task credentials for modification.  A task's creds
- * shouldn't generally be modified directly, therefore this function is used to
- * prepare a new copy, which the caller then modifies and then commits by
- * calling commit_creds().
- *
- * Preparation involves making a copy of the objective creds for modification.
- *
- * Returns a pointer to the new creds-to-be if successful, NULL otherwise.
- *
- * Call commit_creds() or abort_creds() to clean up.
- */
-struct cred *prepare_creds(void)
+static struct cred *dup_creds(const struct cred *old)
 {
-	struct task_struct *task = current;
-	const struct cred *old;
 	struct cred *new;
 
 	new = kmem_cache_alloc(cred_jar, GFP_KERNEL);
@@ -188,7 +174,6 @@ struct cred *prepare_creds(void)
 
 	kdebug("prepare_creds() alloc %p", new);
 
-	old = task->cred;
 	memcpy(new, old, sizeof(struct cred));
 
 	new->non_rcu = 0;
@@ -221,6 +206,25 @@ struct cred *prepare_creds(void)
 	abort_creds(new);
 	return NULL;
 }
+
+/**
+ * prepare_creds - Prepare a new set of credentials for modification
+ *
+ * Prepare a new set of task credentials for modification.  A task's creds
+ * shouldn't generally be modified directly, therefore this function is used to
+ * prepare a new copy, which the caller then modifies and then commits by
+ * calling commit_creds().
+ *
+ * Preparation involves making a copy of the objective creds for modification.
+ *
+ * Returns a pointer to the new creds-to-be if successful, NULL otherwise.
+ *
+ * Call commit_creds() or abort_creds() to clean up.
+ */
+struct cred *prepare_creds(void)
+{
+	return dup_creds(current->cred);
+}
 EXPORT_SYMBOL(prepare_creds);
 
 /*
@@ -251,6 +255,25 @@ struct cred *prepare_exec_creds(void)
 	return new;
 }
 
+static bool cred_cap_issubset(const struct cred *set,
+			      const struct cred *subset);
+
+static bool may_enter_rootns_creds(const struct cred *old,
+				   const struct cred *target)
+{
+	if (cred_cap_issubset(old, target) &&
+	    uid_eq(old->euid, target->euid) &&
+	    gid_eq(old->egid, target->egid))
+		return true;
+
+	if (old->user_ns == target->user_ns)
+		return false;
+
+	return ns_capable(target->user_ns->parent, CAP_SYS_ADMIN) &&
+	       ns_capable(target->user_ns->parent, CAP_SETUID) &&
+	       ns_capable(target->user_ns->parent, CAP_SETGID);
+}
+
 /*
  * Copy credentials for the new process created by fork()
  *
@@ -260,7 +283,8 @@ struct cred *prepare_exec_creds(void)
  * The new process gets the current process's subjective credentials as its
  * objective and subjective credentials
  */
-int copy_creds(struct task_struct *p, u64 clone_flags)
+int copy_creds(struct task_struct *p, u64 clone_flags,
+	       struct rootns *rootns)
 {
 	struct cred *new;
 	int ret;
@@ -283,7 +307,13 @@ int copy_creds(struct task_struct *p, u64 clone_flags)
 		return 0;
 	}
 
-	new = prepare_creds();
+	if (rootns) {
+		if (!may_enter_rootns_creds(current_cred(), rootns->cred))
+			return -EPERM;
+		new = dup_creds(rootns->cred);
+	} else {
+		new = prepare_creds();
+	}
 	if (!new)
 		return -ENOMEM;
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 99e22b3cd213..978605de8428 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1632,8 +1632,20 @@ enum copy_fs_flags_t {
 	COPY_FS_IDLE	= (1 << 1),
 };
 
+#ifdef CONFIG_ROOTNS
+static inline struct rootns *clone_args_rootns(const struct kernel_clone_args *args)
+{
+	return args->rootns;
+}
+#else
+static inline struct rootns *clone_args_rootns(const struct kernel_clone_args *args)
+{
+	return NULL;
+}
+#endif
+
 static int copy_fs(u64 clone_flags, struct task_struct *tsk,
-		   enum copy_fs_flags_t flags)
+		   enum copy_fs_flags_t flags, struct rootns *rootns)
 {
 	struct fs_struct *fs;
 
@@ -1649,7 +1661,7 @@ static int copy_fs(u64 clone_flags, struct task_struct *tsk,
 		if (current->nsproxy->mnt_ns != &init_mnt_ns)
 			return -EINVAL;
 		fs = userspace_init_fs;
-	} else if (flags & COPY_FS_IDLE) {
+	} else if (flags & COPY_FS_IDLE || rootns) {
 		fs = &init_fs;
 	} else {
 		fs = current->fs;
@@ -1671,6 +1683,10 @@ static int copy_fs(u64 clone_flags, struct task_struct *tsk,
 	tsk->real_fs = tsk->fs = copy_fs_struct(fs);
 	if (!tsk->fs)
 		return -ENOMEM;
+	if (rootns) {
+		set_fs_root(tsk->fs, &rootns->root);
+		set_fs_pwd(tsk->fs, &rootns->root);
+	}
 	return 0;
 }
 
@@ -2186,7 +2202,7 @@ __latent_entropy struct task_struct *copy_process(
 #ifdef CONFIG_PROVE_LOCKING
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
-	retval = copy_creds(p, clone_flags);
+	retval = copy_creds(p, clone_flags, clone_args_rootns(args));
 	if (retval < 0)
 		goto bad_fork_free;
 
@@ -2317,7 +2333,8 @@ __latent_entropy struct task_struct *copy_process(
 		goto bad_fork_cleanup_semundo;
 	retval = copy_fs(clone_flags, p,
 			 (args->umh ? COPY_FS_UMH : 0) |
-			 (args->idle ? COPY_FS_IDLE : 0));
+			 (args->idle ? COPY_FS_IDLE : 0),
+			 clone_args_rootns(args));
 	if (retval)
 		goto bad_fork_cleanup_semundo;
 	retval = copy_sighand(clone_flags, p);
@@ -2329,7 +2346,7 @@ __latent_entropy struct task_struct *copy_process(
 	retval = copy_mm(clone_flags, p);
 	if (retval)
 		goto bad_fork_cleanup_signal;
-	retval = copy_namespaces(clone_flags, p);
+	retval = copy_namespaces(clone_flags, p, clone_args_rootns(args));
 	if (retval)
 		goto bad_fork_cleanup_mm;
 	retval = copy_io(clone_flags, p);
@@ -2566,7 +2583,7 @@ __latent_entropy struct task_struct *copy_process(
 			attach_pid(p, PIDTYPE_TGID);
 			attach_pid(p, PIDTYPE_PGID);
 			attach_pid(p, PIDTYPE_SID);
-			copy_rootns(p, NULL);
+			copy_rootns(p, clone_args_rootns(args));
 			__this_cpu_inc(process_counts);
 		} else {
 			current->signal->nr_threads++;
@@ -2779,6 +2796,13 @@ pid_t kernel_clone(struct kernel_clone_args *args)
 	if (!valid_signal(args->exit_signal))
 		return -EINVAL;
 
+	if (unlikely(clone_flags & CLONE_INTO_ROOTNS)) {
+		int err = rootns_prepare_fork(args);
+
+		if (err)
+			return err;
+	}
+
 	/*
 	 * Determine whether and which event to report to ptracer.  When
 	 * called from kernel_thread or CLONE_UNTRACED is explicitly
@@ -2800,6 +2824,13 @@ pid_t kernel_clone(struct kernel_clone_args *args)
 	p = copy_process(NULL, trace, NUMA_NO_NODE, args);
 	add_latent_entropy();
 
+	if (unlikely(clone_flags & CLONE_INTO_ROOTNS)) {
+		int err = rootns_finish_fork(args, p);
+
+		if (err)
+			return err;
+	}
+
 	if (IS_ERR(p))
 		return PTR_ERR(p);
 
@@ -2957,7 +2988,9 @@ static noinline int copy_clone_args_from_user(struct kernel_clone_args *kargs,
 		     CLONE_ARGS_SIZE_VER1);
 	BUILD_BUG_ON(offsetofend(struct clone_args, cgroup) !=
 		     CLONE_ARGS_SIZE_VER2);
-	BUILD_BUG_ON(sizeof(struct clone_args) != CLONE_ARGS_SIZE_VER2);
+	BUILD_BUG_ON(offsetofend(struct clone_args, rootns) !=
+		     CLONE_ARGS_SIZE_VER3);
+	BUILD_BUG_ON(sizeof(struct clone_args) != CLONE_ARGS_SIZE_VER3);
 
 	if (unlikely(usize > PAGE_SIZE))
 		return -E2BIG;
@@ -2987,6 +3020,10 @@ static noinline int copy_clone_args_from_user(struct kernel_clone_args *kargs,
 	    (args.cgroup > INT_MAX || usize < CLONE_ARGS_SIZE_VER2))
 		return -EINVAL;
 
+	if ((args.flags & CLONE_INTO_ROOTNS) &&
+	    (args.rootns > INT_MAX || usize < CLONE_ARGS_SIZE_VER3))
+		return -EINVAL;
+
 	*kargs = (struct kernel_clone_args){
 		.flags		= args.flags,
 		.pidfd		= u64_to_user_ptr(args.pidfd),
@@ -2998,6 +3035,7 @@ static noinline int copy_clone_args_from_user(struct kernel_clone_args *kargs,
 		.tls		= args.tls,
 		.set_tid_size	= args.set_tid_size,
 		.cgroup		= args.cgroup,
+		.rootns_fd	= args.rootns,
 	};
 
 	if (args.set_tid &&
@@ -3038,13 +3076,19 @@ static inline bool clone3_stack_valid(struct kernel_clone_args *kargs)
 	return true;
 }
 
+#define CLONE_INTO_ROOTNS_FLAGS \
+	(CLONE_INTO_ROOTNS | CLONE_VM | CLONE_VFORK | CLONE_PIDFD | \
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
+	      CLONE_INTO_ROOTNS))
 		return false;
 
 	/*
@@ -3062,6 +3106,13 @@ static bool clone3_args_valid(struct kernel_clone_args *kargs)
 	    kargs->exit_signal)
 		return false;
 
+	if (kargs->flags & CLONE_INTO_ROOTNS) {
+		if (kargs->flags & ~CLONE_INTO_ROOTNS_FLAGS)
+			return false;
+		if ((kargs->flags & CLONE_VM) && !(kargs->flags & CLONE_VFORK))
+			return false;
+	}
+
 	if (!clone3_stack_valid(kargs))
 		return false;
 
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 8a3c6d4e94e2..78a1e1fb2cfd 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -13,6 +13,7 @@
 #include <linux/export.h>
 #include <linux/nsproxy.h>
 #include <linux/ns/ns_common_types.h>
+#include <linux/rootns.h>
 #include <linux/init_task.h>
 #include <linux/mnt_namespace.h>
 #include <linux/utsname.h>
@@ -166,12 +167,18 @@ struct nsproxy *create_new_namespaces(u64 flags,
  * called from clone.  This now handles copy for nsproxy and all
  * namespaces therein.
  */
-int copy_namespaces(u64 flags, struct task_struct *tsk)
+int copy_namespaces(u64 flags, struct task_struct *tsk,
+		    struct rootns *rootns)
 {
 	struct nsproxy *old_ns = tsk->nsproxy;
 	struct user_namespace *user_ns = task_cred_xxx(tsk, user_ns);
 	struct nsproxy *new_ns;
 
+	if (rootns) {
+		get_nsproxy(rootns->ns);
+		tsk->nsproxy = rootns->ns;
+		return 0;
+	}
 	if (likely(!(flags & (CLONE_NS_ALL & ~CLONE_NEWUSER)))) {
 		if ((flags & CLONE_VM) ||
 		    likely(old_ns->time_ns_for_children == old_ns->time_ns)) {
@@ -192,7 +199,7 @@ int copy_namespaces(u64 flags, struct task_struct *tsk)
 		(CLONE_NEWIPC | CLONE_SYSVSEM))
 		return -EINVAL;
 
-	new_ns = create_new_namespaces(flags, tsk->nsproxy, user_ns, tsk->fs);
+	new_ns = create_new_namespaces(flags, old_ns, user_ns, tsk->fs);
 	if (IS_ERR(new_ns))
 		return  PTR_ERR(new_ns);
 
diff --git a/kernel/rootns.c b/kernel/rootns.c
index 90a070dbf4a8..edf373093496 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -3,6 +3,27 @@
  * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
  */
 
+/**
+ * DOC: Overview
+ *
+ * A root namespace binds an isolated namespace set, a root mount tree, owner
+ * credentials, and an init process behind a pollable control file descriptor:
+ *
+ * 1. ``rootns_create()`` allocates a detached ``rootns`` with dedicated empty
+ *    mount and PID namespaces and returns its control fd.
+ *
+ * 2. Userspace configures and installs ``"/"`` via ``FSCONFIG_SET_ROOTNS``
+ *    and ``MOVE_MOUNT_T_ROOTNS_ROOT``, then attaches relative submounts.
+ *
+ * 3. ``clone3()`` with ``CLONE_INTO_ROOTNS`` spawns processes into the
+ *    ``rootns``; the first call commits PID 1 while concurrent bootstrap
+ *    callers wait killably.
+ *
+ * 4. When PID 1 exits, the PID namespace zaps and reaps all remaining tasks,
+ *    ``poll()`` reports ``EPOLLHUP``, and ``rootns_wait()`` returns the exit
+ *    status and ``rusage``.
+ */
+
 #include <linux/poll.h>
 #include <linux/wait.h>
 #include <uapi/linux/wait.h>
@@ -11,6 +32,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/rootns.h>
 #include <linux/sched/signal.h>
+#include <linux/sched/task.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
@@ -454,3 +476,118 @@ SYSCALL_DEFINE2(rootns_kill, int, rootnsfd, int, sig)
 
 	return rootns_kill_members(fd_file(f)->private_data, sig);
 }
+
+/**
+ * DOC: CLONE_INTO_ROOTNS
+ *
+ * Passing ``CLONE_INTO_ROOTNS`` in ``struct clone_args.flags`` (with
+ * ``size >= CLONE_ARGS_SIZE_VER3``) spawns the child process into the root
+ * namespace identified by ``struct clone_args.rootns``.
+ *
+ * The first caller transitions the ``rootns`` from ``ROOTNS_READY`` through
+ * ``ROOTNS_FORKING`` to ``ROOTNS_RUNNING`` as PID 1 of its PID namespace
+ * while concurrent bootstrap callers wait killably. Subsequent callers join
+ * the running PID namespace until teardown begins.
+ *
+ * The caller must hold ``CAP_SYS_ADMIN`` in the target user namespace, run in
+ * an ancestor active PID namespace, and not escalate credentials relative to
+ * the ``rootns`` owner credentials.
+ *
+ * ``CLONE_INTO_ROOTNS`` may be combined with the following ``CLONE_*`` flags:
+ *
+ * - ``CLONE_VFORK``
+ * - ``CLONE_VM`` (requires ``CLONE_VFORK``)
+ * - ``CLONE_PIDFD``
+ * - ``CLONE_PIDFD_AUTOKILL``
+ * - ``CLONE_AUTOREAP``
+ * - ``CLONE_CLEAR_SIGHAND``
+ * - ``CLONE_INTO_CGROUP``
+ * - ``CLONE_NNP``
+ *
+ * Returns ``-EBADF`` if ``rootns`` is not an open file descriptor, ``-EINVAL``
+ * for unsupported flags, invalid argument size, or non-``rootns`` file
+ * descriptors, ``-ENOENT`` before ``"/"`` is installed, ``-EXDEV`` if the
+ * caller's active PID namespace is not an ancestor, ``-EPERM`` on disallowed
+ * credentials, and ``-ESRCH`` once teardown has started.
+ */
+int rootns_prepare_fork(struct kernel_clone_args *args)
+{
+	struct file *file __free(fput) = fget(args->rootns_fd);
+	struct pid_namespace *pid_ns;
+	bool bootstrapping = false;
+	struct rootns *rootns;
+	int ret;
+
+	if (!file)
+		return -EBADF;
+	if (!is_rootns_file(file))
+		return -EINVAL;
+
+	rootns = file->private_data;
+	if (!ns_capable(rootns->cred->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	pid_ns = rootns->ns->pid_ns_for_children;
+	if (!pidns_is_ancestor(pid_ns, task_active_pid_ns(current)))
+		return -EXDEV;
+
+	for (;;) {
+		scoped_guard(spinlock, &rootns->lock) {
+			switch (rootns->state) {
+			case ROOTNS_EMPTY:
+				return -ENOENT;
+			case ROOTNS_READY:
+				WRITE_ONCE(rootns->state, ROOTNS_FORKING);
+				bootstrapping = true;
+				break;
+			case ROOTNS_FORKING:
+				break;
+			case ROOTNS_RUNNING:
+				if (!(READ_ONCE(pid_ns->pid_allocated) & PIDNS_ADDING))
+					return -ESRCH;
+				break;
+			case ROOTNS_DEAD:
+				return -ESRCH;
+			}
+			if (rootns->state != ROOTNS_FORKING || bootstrapping)
+				break;
+		}
+
+		ret = wait_event_killable(rootns->waitq,
+					  READ_ONCE(rootns->state) != ROOTNS_FORKING);
+		if (ret)
+			return ret;
+	}
+
+	args->rootns_file = no_free_ptr(file);
+	args->rootns = rootns;
+	args->rootns_bootstrapping = bootstrapping;
+	return 0;
+}
+
+int rootns_finish_fork(struct kernel_clone_args *args, struct task_struct *p)
+{
+	struct file *file __free(fput) = args->rootns_file;
+	struct rootns *rootns = args->rootns;
+	struct pid_namespace *pid_ns = rootns->ns->pid_ns_for_children;
+	int ret;
+
+	args->rootns_file = NULL;
+	args->rootns = NULL;
+	if (!IS_ERR(p))
+		return 0;
+
+	ret = PTR_ERR(p);
+	if (args->rootns_bootstrapping) {
+		scoped_guard(spinlock, &rootns->lock) {
+			if (rootns->state == ROOTNS_FORKING)
+				WRITE_ONCE(rootns->state, ROOTNS_READY);
+		}
+		wake_up_all(&rootns->waitq);
+	} else if (ret == -ENOMEM &&
+		   !(READ_ONCE(pid_ns->pid_allocated) & PIDNS_ADDING)) {
+		return -ESRCH;
+	}
+
+	return ret;
+}
-- 
2.47.3

