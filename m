Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794892157;
	b=NXMrTG5gQa9NlEDPNDqwQ55b/ZCWpTs5H8q6LykCLcpudgz0+LMBsqZMUgrff6yLhMsW
	 GNl2TJFhCS6MUYPr4TKcosEKRXRu/WzT/BUqGWPtO06vmM8VwKF9ztQSLfCkpYfeZiFwu
	 cAiZOhvYzvDm1D6rsvsYeaZQ3gLOYotbbb2m908Je58UWHvx2adzAPs7Hr/7SwEN5FVsW
	 iw1QMZ05jNC8aWhu1DadJBpdDrOdY4rrfCdlcOZsvuW+jSut7F2fvr66EI32+YeyUoSzf
	 YfwYqOIo8Dhuk0+Xsjwrezw/w3+ty2AY9cXOrpXPIuh5Pv2hNiLBL75/40CzpSbTW3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794892157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=M4WiZXeWPQ82N84Y9nCYX/jyLTp3H2fM/Z2HLE6k9xc=;
	b=d9IfR4zz8RnXl16Ry4pf1tQ3UXquBTJ2z4yZbI2m6e4ylX7PtWxsLtG16Sf51/mP5NFi
	 OJyRy+wOvDGIDF9kCj+gjmUUFprv+4dPeHiacGb7c9ACGo6rBKx4VRRn17VmUFtHQ34x+
	 l8O6cZjm9IUqnvWfzBVov0imSDDC/n5owTWY+N/w3j363oHgMZwoiRy+PVH66nBZH/VnI
	 cUlB9/RqW2AcioFnQ+vQe0CE9ouQGhvSq2k3r/FtN7cTVeLt6R/8BSpn4hynjKaRxAR2F
	 UG7kjZPWE0GTT1LAtL+9BaTjOOXN2PQlWPFCPAzGdeiz0Rt2YOk2ZyXD5/s9090BIuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PFkmYOpx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 2FF70606A33D;
	Tue, 17 Nov 2026 05:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PFkmYOpx
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0C71F1F000C5;
	Tue, 17 Nov 2026 05:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892156;
	bh=M4WiZXeWPQ82N84Y9nCYX/jyLTp3H2fM/Z2HLE6k9xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PFkmYOpx5IlDGTqSLyBxzl0YGEVuzBQ/YoQ2N5n8lG0o76l/IccpEZ+g9YIKuhUS9
	 1mRRfxoAuMpy5IBKekHBNF3vJBo0pC86ymq4qIcoY7WycPrNT8M6NvRQ5xpJ0LSQUc
	 r+rbWUSCbYsFd7vLHdp8c1Vy7u7DHF1ouqXcswCHYhzUQcXoM9JdTWwi/KtD8SVM9j
	 7k/xBzsWI4gr0hUO5p69q0WWkeqJLRReX5VLQwRjXixV+HCmvrT8bnH1M6pmn5IS6I
	 OrnITKzXqfafipjW4dMenD0trkGdHA6tLrVmkytTo/Zt1TGrK6st50zdqCPFOMu8t9
	 1DoNLssoRLLgg==
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
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH 07/13] rootns: Add rootns_enter() system call
Date: Tue, 17 Nov 2026 07:08:35 +0200
Message-ID: <20261117050841.3289652-8-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
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

Add the rootns_enter() system call to fork a child process directly into
a rootns whose root mount has been installed. Transition the rootns from
ROOTNS_READY through ROOTNS_FORKING to ROOTNS_RUNNING for the first
process so it becomes PID 1, serialize concurrent entrants on waitq
until bootstrap resolves, and admit subsequent callers into the running
PID namespace until teardown begins.

Require CAP_SYS_ADMIN in the target user namespace, forbid credential or
PR_SET_NO_NEW_PRIVS privilege escalation, and require an ancestor PID
namespace so the caller receives a valid child PID. Inherit rootns
provenance in __ns_common_init() so intra-rootns clone(), unshare(),
open_tree(), and setns() work while foreign setns() calls fail with
-EPERM.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/cred.h               |   4 +-
 include/linux/ns/ns_common_types.h |   4 +
 include/linux/nsproxy.h            |   3 +-
 include/linux/rootns.h             |   9 ++
 include/linux/sched/task.h         |   4 +
 include/linux/syscalls.h           |   1 +
 kernel/cred.c                      |  70 ++++++++++----
 kernel/fork.c                      |  29 ++++--
 kernel/nscommon.c                  |   8 ++
 kernel/nsproxy.c                   |  15 ++-
 kernel/rootns.c                    | 142 +++++++++++++++++++++++++++++
 kernel/sys_ni.c                    |   1 +
 12 files changed, 260 insertions(+), 30 deletions(-)

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
diff --git a/include/linux/ns/ns_common_types.h b/include/linux/ns/ns_common_types.h
index 47a5cfe2326a..3bfc8f24ea92 100644
--- a/include/linux/ns/ns_common_types.h
+++ b/include/linux/ns/ns_common_types.h
@@ -105,6 +105,7 @@ extern const struct proc_ns_operations utsns_operations;
  * @stashed: cached dentry to be used by the vfs
  * @ops: namespace operations
  * @inum: namespace inode number (quickly recycled for non-initial namespaces)
+ * @rootns_id: rootns provenance tag, if the namespace was created by a rootns
  * @__ns_ref: main reference count (do not use directly)
  * @ns_tree: namespace tree nodes and active reference count
  */
@@ -118,6 +119,9 @@ struct ns_common {
 	unsigned int inum;
 #ifdef CONFIG_SECURITY
 	void *ns_security;
+#endif
+#ifdef CONFIG_ROOTNS
+	u64 rootns_id;
 #endif
 	struct ns_tree;
 	struct rcu_head ns_rcu;
diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index 7d0b636387c6..3724d6ba238c 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -116,7 +116,8 @@ struct nsproxy *create_new_namespaces(u64 flags,
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
index b8437bf21830..eab49d025c93 100644
--- a/include/linux/rootns.h
+++ b/include/linux/rootns.h
@@ -14,6 +14,7 @@
 
 struct cred;
 struct file;
+struct ns_common;
 struct nsproxy;
 struct pid;
 struct pid_namespace;
@@ -32,6 +33,7 @@ enum rootns_state {
  */
 struct rootns {
 	refcount_t		usage;
+	u64			id;
 	int			exit_code;	/* The exit code of 'init' */
 	struct rusage		rusage;		/* Resource usage of 'init' */
 	const struct cred	*cred;		/* Creds for this rootns, including userns */
@@ -50,6 +52,7 @@ void put_rootns(struct rootns *c);
 bool is_rootns_file(struct file *file);
 void copy_rootns(struct task_struct *tsk, struct rootns *rootns);
 void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk);
+bool rootns_may_setns(struct rootns *rootns, struct ns_common *ns);
 #else
 static inline struct rootns *get_rootns(struct rootns *c)
 {
@@ -73,6 +76,12 @@ static inline void exit_rootns(struct pid_namespace *pid_ns,
 			       struct task_struct *tsk)
 {
 }
+
+static inline bool rootns_may_setns(struct rootns *rootns,
+				    struct ns_common *ns)
+{
+	return true;
+}
 #endif /* CONFIG_ROOTNS */
 
 #endif /* _LINUX_ROOTNS_H */
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 90ed5bc3c7af..a3401e726a82 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -16,6 +16,7 @@ struct task_struct;
 struct rusage;
 union thread_union;
 struct css_set;
+struct rootns;
 
 /* All the bits taken by the old clone syscall. */
 #define CLONE_LEGACY_FLAGS 0xffffffffULL
@@ -44,6 +45,9 @@ struct kernel_clone_args {
 	void *fn_arg;
 	struct cgroup *cgrp;
 	struct css_set *cset;
+#ifdef CONFIG_ROOTNS
+	struct rootns *rootns;
+#endif
 	unsigned int kill_seq;
 };
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a854d248c8a3..f361dcc74a39 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1010,6 +1010,7 @@ asmlinkage long sys_rootns_create(unsigned int flags);
 asmlinkage long sys_rootns_wait(int rootnsfd, int __user *status,
 				unsigned int options, struct rusage __user *ru);
 asmlinkage long sys_rootns_kill(int rootnsfd, int sig);
+asmlinkage long sys_rootns_enter(int rootnsfd);
 
 /*
  * Architecture-specific system calls
diff --git a/kernel/cred.c b/kernel/cred.c
index d01df40a9a38..97d334db7758 100644
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
+	if (task_no_new_privs(current) || old->user_ns == target->user_ns)
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
index 99e22b3cd213..5e23d36b7ac3 100644
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
diff --git a/kernel/nscommon.c b/kernel/nscommon.c
index 4438c6b663f9..d7e857a417f7 100644
--- a/kernel/nscommon.c
+++ b/kernel/nscommon.c
@@ -2,8 +2,10 @@
 /* Copyright (c) 2025 Christian Brauner <brauner@kernel.org> */
 
 #include <linux/ns_common.h>
+#include <linux/nsproxy.h>
 #include <linux/nstree.h>
 #include <linux/proc_ns.h>
+#include <linux/rootns.h>
 #include <linux/security.h>
 #include <linux/user_namespace.h>
 #include <linux/vfsdebug.h>
@@ -57,6 +59,9 @@ static void ns_debug(struct ns_common *ns, const struct proc_ns_operations *ops)
 int __ns_common_init(struct ns_common *ns, u32 ns_type, const struct proc_ns_operations *ops,
 		     int inum, u64 ns_id)
 {
+#ifdef CONFIG_ROOTNS
+	struct rootns *rootns = task_rootns(current);
+#endif
 	int ret = 0;
 
 	refcount_set(&ns->__ns_ref, 1);
@@ -66,6 +71,9 @@ int __ns_common_init(struct ns_common *ns, u32 ns_type, const struct proc_ns_ope
 #endif
 	ns->ops = ops;
 	ns->ns_type = ns_type;
+#ifdef CONFIG_ROOTNS
+	ns->rootns_id = rootns ? rootns->id : 0;
+#endif
 	ns_tree_node_init(&ns->ns_tree_node);
 	ns_tree_node_init(&ns->ns_unified_node);
 	ns_tree_node_init(&ns->ns_owner_node);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index a76837b3ee33..0c6407757d89 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -169,13 +169,21 @@ struct nsproxy *create_new_namespaces(u64 flags,
 /*
  * called from clone.  This now handles copy for nsproxy and all
  * namespaces therein.
+ *
+ * Namespaces derived from a rootns member inherit the same rootns domain.
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
@@ -196,7 +204,7 @@ int copy_namespaces(u64 flags, struct task_struct *tsk)
 		(CLONE_NEWIPC | CLONE_SYSVSEM))
 		return -EINVAL;
 
-	new_ns = create_new_namespaces(flags, tsk->nsproxy, user_ns, tsk->fs);
+	new_ns = create_new_namespaces(flags, old_ns, user_ns, tsk->fs);
 	if (IS_ERR(new_ns))
 		return  PTR_ERR(new_ns);
 
@@ -391,6 +399,9 @@ static inline int validate_ns(struct nsset *nsset, struct ns_common *ns)
 {
 	int ret;
 
+	if (!rootns_may_setns(task_rootns(current), ns))
+		return -EPERM;
+
 	ret = security_namespace_install(nsset, ns);
 	if (ret)
 		return ret;
diff --git a/kernel/rootns.c b/kernel/rootns.c
index f59b2fe9910d..e286c1e753b7 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -3,6 +3,28 @@
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
+ * 2. Userspace configures and installs ``"/"`` via ``FSCONFIG_SET_ROOTNS``
+ *    and ``MOVE_MOUNT_T_ROOTNS_ROOT``, then attaches relative submounts.
+ * 3. ``rootns_enter()`` forks processes into the ``rootns``; the first call
+ *    commits PID 1 while concurrent bootstrap callers wait killably.
+ * 4. When PID 1 exits, the PID namespace zaps and reaps all remaining tasks,
+ *    ``poll()`` reports ``EPOLLHUP``, and ``rootns_wait()`` returns the exit
+ *    status and ``rusage``.
+ *
+ * Every namespace allocated by a member task inherits the ``rootns``
+ * provenance ID in ``__ns_common_init()``. ``setns()`` permits joining
+ * namespaces carrying the same provenance ID (or already attached to the
+ * caller) and rejects foreign namespaces with ``-EPERM``.
+ */
+
 #include <linux/poll.h>
 #include <linux/wait.h>
 #include <uapi/linux/wait.h>
@@ -14,6 +36,10 @@
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <linux/mnt_namespace.h>
+#include <linux/utsname.h>
+#include <linux/ipc_namespace.h>
+#include <linux/cgroup_namespace.h>
 #include <linux/nsproxy.h>
 #include <linux/ns_common.h>
 #include <linux/nsfs.h>
@@ -22,8 +48,40 @@
 #include <linux/user_namespace.h>
 #include <linux/compat.h>
 #include <linux/idr.h>
+#include <linux/atomic.h>
+#include <net/net_namespace.h>
 #include <uapi/linux/rootns.h>
 
+static atomic64_t rootns_id = ATOMIC64_INIT(0);
+
+static void rootns_tag_namespaces(struct rootns *c, const struct nsproxy *old)
+{
+	struct nsproxy *ns = c->ns;
+
+	if (c->cred->user_ns != current_user_ns())
+		c->cred->user_ns->ns.rootns_id = c->id;
+	from_mnt_ns(ns->mnt_ns)->rootns_id = c->id;
+	ns->pid_ns_for_children->ns.rootns_id = c->id;
+	if (ns->uts_ns != old->uts_ns)
+		ns->uts_ns->ns.rootns_id = c->id;
+	if (ns->ipc_ns != old->ipc_ns)
+		ns->ipc_ns->ns.rootns_id = c->id;
+	if (ns->cgroup_ns != old->cgroup_ns)
+		ns->cgroup_ns->ns.rootns_id = c->id;
+	if (ns->net_ns != old->net_ns)
+		ns->net_ns->ns.rootns_id = c->id;
+}
+
+bool rootns_may_setns(struct rootns *rootns, struct ns_common *ns)
+{
+	if (!ns)
+		return false;
+	if (!rootns || is_current_namespace(ns))
+		return true;
+
+	return ns->rootns_id == rootns->id;
+}
+
 /*
  * Get a reference to a rootns.
  */
@@ -216,6 +274,7 @@ static struct rootns *create_rootns(unsigned int flags)
 	spin_lock_init(&c->lock);
 	refcount_set(&c->usage, 1);
 	c->flags = flags;
+	c->id = atomic64_inc_return(&rootns_id);
 
 	cred = create_rootns_creds(flags);
 	if (IS_ERR(cred)) {
@@ -249,6 +308,7 @@ static struct rootns *create_rootns(unsigned int flags)
 	c->ns = ns;
 	ns->rootns = c;
 	ns->pid_ns_for_children->rootns = c;
+	rootns_tag_namespaces(c, current->nsproxy);
 	nsproxy_ns_active_get(ns);
 
 	return c;
@@ -455,3 +515,85 @@ SYSCALL_DEFINE2(rootns_kill, int, rootnsfd, int, sig)
 
 	return rootns_kill_members(fd_file(f)->private_data, sig);
 }
+
+/**
+ * sys_rootns_enter - Fork a child process into an existing root namespace
+ * @rootnsfd: Root namespace control file descriptor
+ *
+ * Fork the calling process into @rootnsfd. The first caller bootstraps PID 1
+ * of the rootns PID namespace while concurrent bootstrap callers wait
+ * killably; subsequent callers join the running PID namespace until teardown
+ * begins. Requires %CAP_SYS_ADMIN in the target user namespace, an ancestor
+ * active PID namespace, and no credential or %PR_SET_NO_NEW_PRIVS escalation.
+ *
+ * Return: Caller-visible child PID in the parent, 0 in the child, %-ENOENT
+ * before ``"/"`` is installed, %-EXDEV if the caller's active PID namespace is
+ * not an ancestor, %-EPERM on disallowed credentials, or %-ESRCH on teardown.
+ */
+SYSCALL_DEFINE1(rootns_enter, int, rootnsfd)
+{
+	CLASS(fd, f)(rootnsfd);
+	struct kernel_clone_args args = {
+		.exit_signal = SIGCHLD,
+	};
+	struct pid_namespace *pid_ns;
+	bool bootstrapping = false;
+	struct rootns *rootns;
+	pid_t ret;
+
+	if (fd_empty(f))
+		return -EBADF;
+	if (!is_rootns_file(fd_file(f)))
+		return -EINVAL;
+
+	rootns = fd_file(f)->private_data;
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
+	args.rootns = rootns;
+	ret = kernel_clone(&args);
+	if (ret < 0 && bootstrapping) {
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
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index fba44c49ddbb..3fd6376ddbe7 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -404,3 +404,4 @@ COND_SYSCALL(rootns_create);
 COND_SYSCALL(rootns_wait);
 COND_SYSCALL_COMPAT(rootns_wait);
 COND_SYSCALL(rootns_kill);
+COND_SYSCALL(rootns_enter);
-- 
2.47.3

