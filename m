Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795128240;
	b=yOQmqPv6Y/G/Bg6bt5dY4nd7NGpbEJenkBTRt/9zlWeq+e7/kANEDjcD0Uz52xj8bUW4
	 ATOYC/IDrySK7kgsEXL5+bAToQdCE12jjubca0kjQFV1YY24FiyVrhnWWnDgP6NSNkDby
	 MabBoxdFbD31A9MweYaGvgNf3eTM9Xqdmr57XRe7q0XQ6kAcd3VE2pvo3+qgXcr5SErQV
	 JFCewAUo/vKD/+RIUb+TXV8Iq9R20YYcacXa9H3gEZo8Fc8lGqvXR7HUab6FvQ9cVrEnL
	 Y+0FqHd8ljs8FCXSi6daF0CLxD/W6VHgaHPIdQCjGRqnEWlUs8bz2hMoGYKMWQmqIVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795128240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/v9IHIQfBFo4cKfBGfZrf+LNHbfeOaf3MnUUufo6luY=;
	b=3EYLBIN675J7Sl4ay8ERqlwglEfGmdWQvClay0TAkMG0MarfUHZXH845v34qcDcV2x6E
	 o4/8eXknz49RVR4Dhd2Lq+rwkK4ewT3mRFsHXopTV2yOuFwjWo+1INa+nyOvIDz2MGTIu
	 DCD1U4f5x9DiQTjHQR3euiPgx5BG4JMuX6tAPtKmtuYD6rG22yzym1SWERnq1Xy9DJDKo
	 kit1/w6pPClWJBZFWawSDpVBScgye/rcCTTjVCeZMlDFRGZOj9urnJXa4VTpyFmiupmma
	 O5Ti8pwkYQs8OIzHaVwWMzNppiuQLshNT+gw3MkoxpBgYT84uEEMNlOqt4YJmB9Rw8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QphYPBjP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 58255606A325;
	Thu, 19 Nov 2026 22:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QphYPBjP
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F1DA11F000CF;
	Thu, 19 Nov 2026 22:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795128239;
	bh=/v9IHIQfBFo4cKfBGfZrf+LNHbfeOaf3MnUUufo6luY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QphYPBjPecjxc8HqyLgYZ6xkp3DDLvhzQ9YSQ3Gv+e1/rGQeKKZlBkJXq8h6Bp4HG
	 FKw8KmZ+OTLztb+jSmAMB1FdXDXMB2eqNBhS5b78Irn2DQjrVfq8BxC/fxzbswZJPf
	 8YO1vBKxU/BNZsCJtIaH8vT2kViDwxpOIG4z4nLaAeWTihR1nCPhYR9EQ5cI5dIyKT
	 raULLIAu6vDfZHO58Fs16aB4l/AkpaEMIoanMN6PIXpfre0MCrGz+P4ams0LQK359u
	 Pt9eOOW5HQL2kMgR6hdqbCQXuu1TOoDVBshAhzddt53CEWMxXbEoxMUWZMJE4Xeamg
	 45Qp0qQkIOKvA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Andy Lutomirski <luto@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Hallgrimur H. Gunnarsson" <halg@google.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Matt Turner <mattst88@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Mel Gorman <mgorman@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Moore <paul@paul-moore.com>,
	Paul Walmsley <pjw@kernel.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Rich Felker <dalias@libc.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Serge Hallyn <sergeh@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v4 07/14] fork: Support CLONE_INTO_ROOTNS in clone3()
Date: Fri, 20 Nov 2026 00:43:05 +0200
Message-ID: <20261119224312.1037966-8-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119224312.1037966-1-jarkko@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
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
been installed. Transition the rootns from ROOTNS_INIT through
ROOTNS_FORKING to ROOTNS_RUNNING for the first process so it becomes
PID 1, serialize concurrent entrants on waitq until bootstrap resolves,
and admit subsequent callers into the running PID namespace until
teardown begins.

Derive child credentials from current, require CAP_SYS_ADMIN and
CAP_SYS_CHROOT in the target user namespace and an ancestor active PID
namespace, preserve caller umask, reset dumpability across user namespace
transitions, commit time namespace vvar mappings after copy_process()
succeeds, and look up the live mount namespace root. Restrict companion
flags to CLONE_VFORK, CLONE_PIDFD, CLONE_PIDFD_AUTOKILL, CLONE_AUTOREAP,
CLONE_CLEAR_SIGHAND, CLONE_INTO_CGROUP, and CLONE_NNP.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/namespace.c                 |  16 ++++
 include/linux/cred.h           |   4 +-
 include/linux/mnt_namespace.h  |   2 +
 include/linux/nsproxy.h        |   4 +-
 include/linux/rootns.h         |  14 ++++
 include/linux/sched/task.h     |   8 ++
 include/linux/user_namespace.h |   7 ++
 include/uapi/linux/sched.h     |   5 ++
 kernel/cred.c                  |  32 +++++++-
 kernel/fork.c                  |  94 ++++++++++++++++++++---
 kernel/nsproxy.c               |  11 ++-
 kernel/rootns.c                | 136 +++++++++++++++++++++++++++++++++
 kernel/user_namespace.c        |  12 ++-
 13 files changed, 327 insertions(+), 18 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index aecd05ac0170..781380945d78 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -6708,6 +6708,22 @@ static void mntns_put(struct ns_common *ns)
 	put_mnt_ns(to_mnt_ns(ns));
 }
 
+int mnt_ns_get_root(struct mnt_namespace *mnt_ns, struct path *root)
+{
+	int err;
+
+	err = vfs_path_lookup(mnt_ns->root->mnt.mnt_root, &mnt_ns->root->mnt,
+			      "/", LOOKUP_DOWN, root);
+	if (err)
+		return err;
+	if (root->mnt == &mnt_ns->root->mnt) {
+		path_put(root);
+		*root = (struct path){};
+		return -ENOENT;
+	}
+	return 0;
+}
+
 static int mntns_install(struct nsset *nsset, struct ns_common *ns)
 {
 	struct nsproxy *nsproxy = nsset->nsproxy;
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
diff --git a/include/linux/mnt_namespace.h b/include/linux/mnt_namespace.h
index 0acd1089d149..98188d1f7428 100644
--- a/include/linux/mnt_namespace.h
+++ b/include/linux/mnt_namespace.h
@@ -8,6 +8,7 @@
 
 struct mnt_namespace;
 struct fs_struct;
+struct path;
 struct user_namespace;
 struct ns_common;
 
@@ -15,6 +16,7 @@ extern struct mnt_namespace init_mnt_ns;
 
 extern struct mnt_namespace *copy_mnt_ns(u64, struct mnt_namespace *,
 		struct user_namespace *, struct fs_struct *);
+int mnt_ns_get_root(struct mnt_namespace *mnt_ns, struct path *root);
 extern void put_mnt_ns(struct mnt_namespace *ns);
 DEFINE_FREE(put_mnt_ns, struct mnt_namespace *, if (!IS_ERR_OR_NULL(_T)) put_mnt_ns(_T))
 extern struct ns_common *from_mnt_ns(struct mnt_namespace *);
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
index 0557ce75195d..802fc76bb66e 100644
--- a/include/linux/rootns.h
+++ b/include/linux/rootns.h
@@ -11,6 +11,7 @@
 #include <linux/wait.h>
 
 struct file;
+struct kernel_clone_args;
 struct nsproxy;
 struct pid;
 struct pid_namespace;
@@ -46,6 +47,8 @@ bool is_rootns_file(struct file *file);
 void copy_rootns(struct task_struct *tsk, struct pid *pid,
 		 struct rootns *rootns);
 void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk);
+int rootns_prepare_fork(struct kernel_clone_args *args);
+int rootns_finish_fork(struct kernel_clone_args *args, struct task_struct *p);
 #else
 static inline struct rootns *get_rootns(struct rootns *c)
 {
@@ -70,6 +73,17 @@ static inline void exit_rootns(struct pid_namespace *pid_ns,
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
 
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 91232053775d..3600a903442e 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -184,6 +184,7 @@ static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 }
 
 extern int create_user_ns(struct cred *new);
+int install_user_ns_cred(struct cred *cred, struct user_namespace *user_ns);
 extern int unshare_userns(unsigned long unshare_flags, struct cred **new_cred);
 extern void __put_user_ns(struct user_namespace *ns);
 
@@ -226,6 +227,12 @@ static inline int create_user_ns(struct cred *new)
 	return -EINVAL;
 }
 
+static inline int install_user_ns_cred(struct cred *cred,
+				       struct user_namespace *user_ns)
+{
+	return -EINVAL;
+}
+
 static inline int unshare_userns(unsigned long unshare_flags,
 				 struct cred **new_cred)
 {
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
index d01df40a9a38..48a8852dab4a 100644
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
+#include <linux/rootns.h>
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
+	       struct rootns *rootns)
 {
 	struct cred *new;
 	int ret;
@@ -287,6 +294,29 @@ int copy_creds(struct task_struct *p, u64 clone_flags)
 	if (!new)
 		return -ENOMEM;
 
+	if (rootns) {
+		const struct cred *old = current_cred();
+
+		if (!ns_capable(rootns->user_ns, CAP_SYS_ADMIN) ||
+		    !ns_capable(rootns->user_ns, CAP_SYS_CHROOT)) {
+			ret = -EPERM;
+			goto error_put;
+		}
+		if (new->user_ns != rootns->user_ns) {
+			ret = install_user_ns_cred(new, rootns->user_ns);
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
index 08fc28ad1eed..ac0497ff410c 100644
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
+	if ((clone_flags & (CLONE_VM | CLONE_INTO_ROOTNS)) == CLONE_VM) {
 		exec_state = rcu_dereference_protected(current->exec_state, true);
 		refcount_inc(&exec_state->count);
 		rcu_assign_pointer(tsk->exec_state, exec_state);
@@ -1632,8 +1633,30 @@ enum copy_fs_flags_t {
 	COPY_FS_IDLE	= (1 << 1),
 };
 
+#ifdef CONFIG_ROOTNS
+static inline struct rootns *clone_args_rootns(const struct kernel_clone_args *args)
+{
+	return args->rootns;
+}
+
+static inline bool clone_args_rootns_bootstrapping(const struct kernel_clone_args *args)
+{
+	return args->rootns_bootstrapping;
+}
+#else
+static inline struct rootns *clone_args_rootns(const struct kernel_clone_args *args)
+{
+	return NULL;
+}
+
+static inline bool clone_args_rootns_bootstrapping(const struct kernel_clone_args *args)
+{
+	return false;
+}
+#endif
+
 static int copy_fs(u64 clone_flags, struct task_struct *tsk,
-		   enum copy_fs_flags_t flags)
+		   enum copy_fs_flags_t flags, struct rootns *rootns)
 {
 	struct fs_struct *fs;
 
@@ -1649,7 +1672,7 @@ static int copy_fs(u64 clone_flags, struct task_struct *tsk,
 		if (current->nsproxy->mnt_ns != &init_mnt_ns)
 			return -EINVAL;
 		fs = userspace_init_fs;
-	} else if (flags & COPY_FS_IDLE) {
+	} else if (flags & COPY_FS_IDLE || rootns) {
 		fs = &init_fs;
 	} else {
 		fs = current->fs;
@@ -1671,6 +1694,21 @@ static int copy_fs(u64 clone_flags, struct task_struct *tsk,
 	tsk->real_fs = tsk->fs = copy_fs_struct(fs);
 	if (!tsk->fs)
 		return -ENOMEM;
+	if (rootns) {
+		struct path root __free(path_put) = {};
+		int err;
+
+		err = mnt_ns_get_root(rootns->ns->mnt_ns, &root);
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
 
@@ -2186,7 +2224,7 @@ __latent_entropy struct task_struct *copy_process(
 #ifdef CONFIG_PROVE_LOCKING
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
-	retval = copy_creds(p, clone_flags);
+	retval = copy_creds(p, clone_flags, clone_args_rootns(args));
 	if (retval < 0)
 		goto bad_fork_free;
 
@@ -2317,7 +2355,8 @@ __latent_entropy struct task_struct *copy_process(
 		goto bad_fork_cleanup_semundo;
 	retval = copy_fs(clone_flags, p,
 			 (args->umh ? COPY_FS_UMH : 0) |
-			 (args->idle ? COPY_FS_IDLE : 0));
+			 (args->idle ? COPY_FS_IDLE : 0),
+			 clone_args_rootns(args));
 	if (retval)
 		goto bad_fork_cleanup_semundo;
 	retval = copy_sighand(clone_flags, p);
@@ -2329,7 +2368,7 @@ __latent_entropy struct task_struct *copy_process(
 	retval = copy_mm(clone_flags, p);
 	if (retval)
 		goto bad_fork_cleanup_signal;
-	retval = copy_namespaces(clone_flags, p);
+	retval = copy_namespaces(clone_flags, p, clone_args_rootns(args));
 	if (retval)
 		goto bad_fork_cleanup_mm;
 	retval = copy_io(clone_flags, p);
@@ -2510,6 +2549,12 @@ __latent_entropy struct task_struct *copy_process(
 		goto bad_fork_core_free;
 	}
 
+	if (unlikely(clone_args_rootns_bootstrapping(args) &&
+		     !is_child_reaper(pid))) {
+		retval = -EBUSY;
+		goto bad_fork_core_free;
+	}
+
 	/* Let kill terminate clone/fork in the middle */
 	if (fatal_signal_pending(current)) {
 		retval = -EINTR;
@@ -2578,7 +2623,7 @@ __latent_entropy struct task_struct *copy_process(
 		}
 		attach_pid(p, PIDTYPE_PID);
 		if (thread_group_leader(p))
-			copy_rootns(p, pid, NULL);
+			copy_rootns(p, pid, clone_args_rootns(args));
 		nr_threads++;
 	}
 	total_forks++;
@@ -2780,6 +2825,13 @@ pid_t kernel_clone(struct kernel_clone_args *args)
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
@@ -2801,6 +2853,13 @@ pid_t kernel_clone(struct kernel_clone_args *args)
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
 
@@ -2958,7 +3017,9 @@ static noinline int copy_clone_args_from_user(struct kernel_clone_args *kargs,
 		     CLONE_ARGS_SIZE_VER1);
 	BUILD_BUG_ON(offsetofend(struct clone_args, cgroup) !=
 		     CLONE_ARGS_SIZE_VER2);
-	BUILD_BUG_ON(sizeof(struct clone_args) != CLONE_ARGS_SIZE_VER2);
+	BUILD_BUG_ON(offsetofend(struct clone_args, rootns) !=
+		     CLONE_ARGS_SIZE_VER3);
+	BUILD_BUG_ON(sizeof(struct clone_args) != CLONE_ARGS_SIZE_VER3);
 
 	if (unlikely(usize > PAGE_SIZE))
 		return -E2BIG;
@@ -2988,6 +3049,10 @@ static noinline int copy_clone_args_from_user(struct kernel_clone_args *kargs,
 	    (args.cgroup > INT_MAX || usize < CLONE_ARGS_SIZE_VER2))
 		return -EINVAL;
 
+	if ((args.flags & CLONE_INTO_ROOTNS) &&
+	    (args.rootns > INT_MAX || usize < CLONE_ARGS_SIZE_VER3))
+		return -EINVAL;
+
 	*kargs = (struct kernel_clone_args){
 		.flags		= args.flags,
 		.pidfd		= u64_to_user_ptr(args.pidfd),
@@ -2999,6 +3064,7 @@ static noinline int copy_clone_args_from_user(struct kernel_clone_args *kargs,
 		.tls		= args.tls,
 		.set_tid_size	= args.set_tid_size,
 		.cgroup		= args.cgroup,
+		.rootns_fd	= args.rootns,
 	};
 
 	if (args.set_tid &&
@@ -3039,13 +3105,19 @@ static inline bool clone3_stack_valid(struct kernel_clone_args *kargs)
 	return true;
 }
 
+#define CLONE_INTO_ROOTNS_FLAGS \
+	(CLONE_INTO_ROOTNS | CLONE_VFORK | CLONE_PIDFD | \
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
@@ -3063,6 +3135,10 @@ static bool clone3_args_valid(struct kernel_clone_args *kargs)
 	    kargs->exit_signal)
 		return false;
 
+	if ((kargs->flags & CLONE_INTO_ROOTNS) &&
+	    (kargs->flags & ~CLONE_INTO_ROOTNS_FLAGS))
+		return false;
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
index ce012a07e982..865689eed69c 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -34,6 +34,7 @@
 #include <uapi/linux/wait.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/fs_struct.h>
 #include <linux/anon_inodes.h>
 #include <linux/rootns.h>
 #include <linux/sched/signal.h>
@@ -423,3 +424,138 @@ SYSCALL_DEFINE1(rootns, unsigned int, flags)
 	return fd;
 }
 
+/**
+ * DOC: CLONE_INTO_ROOTNS
+ *
+ * Passing ``CLONE_INTO_ROOTNS`` in ``struct clone_args.flags`` (with
+ * ``size >= CLONE_ARGS_SIZE_VER3``) spawns the child process into the root
+ * namespace identified by ``struct clone_args.rootns``.
+ *
+ * Once ``"/"`` is mounted in the root namespace's mount namespace, the first
+ * caller transitions the ``rootns`` from ``ROOTNS_INIT`` through
+ * ``ROOTNS_FORKING`` to ``ROOTNS_RUNNING`` as PID 1 of its PID namespace
+ * while concurrent bootstrap callers wait killably. Subsequent callers join
+ * the running PID namespace until teardown begins.
+ *
+ * The caller must hold ``CAP_SYS_ADMIN`` and ``CAP_SYS_CHROOT`` in the target
+ * user namespace (and ``CAP_SYS_CHROOT`` in its current user namespace when
+ * chrooted) and run in an ancestor active PID namespace. The child inherits
+ * the caller's credentials and switches to the target user namespace.
+ *
+ * ``CLONE_INTO_ROOTNS`` may be combined with the following ``CLONE_*`` flags:
+ *
+ * - ``CLONE_VFORK``
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
+ * caller's active PID namespace is not an ancestor, ``-EPERM`` without
+ * required capabilities, ``-EBUSY`` if the PID
+ * namespace already has an external init process, and ``-ESRCH`` once teardown
+ * has started.
+ */
+int rootns_prepare_fork(struct kernel_clone_args *args)
+{
+	struct file *file __free(fput) = fget(args->rootns_fd);
+	struct path root __free(path_put) = {};
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
+	if (!ns_capable(rootns->user_ns, CAP_SYS_ADMIN) ||
+	    !ns_capable(rootns->user_ns, CAP_SYS_CHROOT))
+		return -EPERM;
+	if (current_chrooted() && !ns_capable(current_user_ns(), CAP_SYS_CHROOT))
+		return -EPERM;
+
+	pid_ns = rootns->ns->pid_ns_for_children;
+	if (!pidns_is_ancestor(pid_ns, task_active_pid_ns(current)))
+		return -EXDEV;
+
+	ret = mnt_ns_get_root(rootns->ns->mnt_ns, &root);
+	if (ret)
+		return ret;
+
+	for (;;) {
+		bool wait = false;
+
+		scoped_guard(spinlock, &rootns->lock) {
+			switch (rootns->state) {
+			case ROOTNS_INIT:
+				if (READ_ONCE(pid_ns->child_reaper))
+					return -EBUSY;
+				if (!(READ_ONCE(pid_ns->pid_allocated) & PIDNS_ADDING))
+					return -ESRCH;
+				WRITE_ONCE(rootns->state, ROOTNS_FORKING);
+				bootstrapping = true;
+				break;
+			case ROOTNS_FORKING:
+				wait = true;
+				break;
+			case ROOTNS_RUNNING:
+				if (!(READ_ONCE(pid_ns->pid_allocated) & PIDNS_ADDING))
+					return -ESRCH;
+				break;
+			case ROOTNS_DEAD:
+				return -ESRCH;
+			}
+		}
+		if (!wait)
+			break;
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
+	if (!IS_ERR(p)) {
+		if (current->nsproxy->time_ns != rootns->ns->time_ns)
+			timens_commit(p, rootns->ns->time_ns);
+		return 0;
+	}
+
+	ret = PTR_ERR(p);
+	if (args->rootns_bootstrapping) {
+		scoped_guard(spinlock, &rootns->lock) {
+			if (rootns->state == ROOTNS_FORKING)
+				WRITE_ONCE(rootns->state, ROOTNS_INIT);
+		}
+		wake_up_all(&rootns->waitq);
+		if (ret == -EINVAL && !args->set_tid_size)
+			ret = -EBUSY;
+	}
+	if ((ret == -ENOMEM || ret == -EBUSY) &&
+	    !(READ_ONCE(pid_ns->pid_allocated) & PIDNS_ADDING))
+		return -ESRCH;
+
+	return ret;
+}
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index cd748e1cbace..3bea86647191 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -1372,6 +1372,13 @@ static void userns_put(struct ns_common *ns)
 	put_user_ns(to_user_ns(ns));
 }
 
+int install_user_ns_cred(struct cred *cred, struct user_namespace *user_ns)
+{
+	put_user_ns(cred->user_ns);
+	set_cred_user_ns(cred, get_user_ns(user_ns));
+	return set_cred_ucounts(cred);
+}
+
 static int userns_install(struct nsset *nsset, struct ns_common *ns)
 {
 	struct user_namespace *user_ns = to_user_ns(ns);
@@ -1397,10 +1404,7 @@ static int userns_install(struct nsset *nsset, struct ns_common *ns)
 	if (!cred)
 		return -EINVAL;
 
-	put_user_ns(cred->user_ns);
-	set_cred_user_ns(cred, get_user_ns(user_ns));
-
-	if (set_cred_ucounts(cred) < 0)
+	if (install_user_ns_cred(cred, user_ns) < 0)
 		return -EINVAL;
 
 	return 0;
-- 
2.47.3

