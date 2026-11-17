Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794892141;
	b=1G078sdk7MPFjjyhYGXOW9Gj5JylwJMLxkd0pFFTYMDaHjR7mCWwJtNMfMjLnatWnSSZ
	 WantTM4W48xS2RjAUJMEGZctfs2VSd09SLYTh8sNHBctVzU4XJPni/KWmKbFbcAwFXtWr
	 VH2jiSwycThzEQeO+/HZhCMPjw5GP7ZpzKqc6WmBRm+nx7rKyO+8ceF0041kLXNbei4ul
	 RYclGJTfoDorroUDFqBupCr/VGb5j0tvSuq9T9Tc6DNbZxyRFK7nYDeY69+dUL+F8//tC
	 LeJaWMRpkBvD2XhKrYH6sShURD7hI9atlJXbA4U1eG9M3yzeTklz23i7WTNkpXZCI+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794892141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=vNG+HKNgYzQ2OTreil5lKozs9Q2/l93uy/4zE3pXacs=;
	b=2ft0Si6OjJhd5T09C0YegRJ4zhoTodhYCtsLk+aQnDsK3vcJmE0W2cV12mFoTXeRh7cS
	 IxORyNslj8J7Ma9qG4Y4ytybNv7WOgpAitFpH0Cj+vmrZ/MXZKOBn0ppBkVROPqGybOLn
	 KMOZ81MAyVvOjgwzSvihxodMQfPX5nsndj03B8ab3q/cqIBK7ZMyehDgm4gllEDxZZxMj
	 3JtcbuUxs8AeRoTlsfxS9gItXamG1DiJgM0mb2IutDV4Ifvccr/ghSEu3SImcTBakFPrw
	 HLbY7Hfg1dLSlbb5PKILWdYBZAhihv/InAtSH7aTejQqs4xZ6YBPGXvW25mjp7olucQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LRTVeJOZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 311C9606A32F;
	Tue, 17 Nov 2026 05:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LRTVeJOZ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 255701F000CA;
	Tue, 17 Nov 2026 05:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892140;
	bh=vNG+HKNgYzQ2OTreil5lKozs9Q2/l93uy/4zE3pXacs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRTVeJOZubBlni17eDMR11FhIM6qThAN6ldsJPvhAPnsP21yiOmtyaYZfJKpEVTjS
	 A+VWbIFgxKM1SPwRlzA33iUP5Wdyn8PbdUv2d18N+OrK8SlWdipqzTpVltTaVSXFbH
	 1JMZPM84gMrxrZAn1pBlFrTVplMfSdJgEbR/OwqlFNcnARvxCvk+dWeZ/nh+lamD2h
	 2srb7B25NohMO9+sesXQbcQYD7dA9SE9HI0gRTRYtmh4NuBC9Qsw/4rRxt0LcUeQ5U
	 n+UgwyXn8boc1E0l9M91uzPmKhvbDIN0MQNEC/MNO7s4is+16K5sNGuqrP8gJz4fim
	 KNbf2rOpg00xA==
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
Subject: [RFC PATCH 03/13] rootns: Track init lifecycle via copy_process() and pid_namespace
Date: Tue, 17 Nov 2026 07:08:31 +0200
Message-ID: <20261117050841.3289652-4-jarkko@kernel.org>
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

A root namespace needs to record its init thread group's PID when
bootstrapped and capture its exit status and resource usage once all
processes in the root namespace have terminated, without serializing
normal fork() and exit() paths inside the container.

Represent the initial host context with a NULL nsproxy->rootns pointer,
commit the bootstrap init PID and wake waiters in copy_rootns(), and
invoke exit_rootns() from zap_pid_ns_processes() after the root
namespace's PID namespace has killed and reaped all member tasks.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/nsproxy.h       | 16 ++++++++++++++
 include/linux/pid_namespace.h |  4 ++++
 include/linux/rootns.h        | 12 +++++++++++
 kernel/fork.c                 |  2 ++
 kernel/nsproxy.c              |  4 ++++
 kernel/pid_namespace.c        |  2 ++
 kernel/rootns.c               | 40 +++++++++++++++++++++++++++++++++++
 7 files changed, 80 insertions(+)

diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index 23cbeee6b1e4..7d0b636387c6 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -12,6 +12,7 @@ struct ipc_namespace;
 struct pid_namespace;
 struct cgroup_namespace;
 struct fs_struct;
+struct rootns;
 struct user_namespace;
 
 /*
@@ -40,9 +41,24 @@ struct nsproxy {
 	struct time_namespace *time_ns;
 	struct time_namespace *time_ns_for_children;
 	struct cgroup_namespace *cgroup_ns;
+#ifdef CONFIG_ROOTNS
+	struct rootns *rootns;
+#endif
 };
 extern struct nsproxy init_nsproxy;
 
+#ifdef CONFIG_ROOTNS
+static inline struct rootns *task_rootns(const struct task_struct *tsk)
+{
+	return tsk->nsproxy ? tsk->nsproxy->rootns : NULL;
+}
+#else
+static inline struct rootns *task_rootns(const struct task_struct *tsk)
+{
+	return NULL;
+}
+#endif
+
 /*
  * A structure to encompass all bits needed to install
  * a partial or complete new set of namespaces.
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index b20baaa7e62b..6fd959f4d0d4 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -15,6 +15,7 @@
 #define MAX_PID_NS_LEVEL 32
 
 struct fs_pin;
+struct rootns;
 
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_MEMFD_CREATE)
 /* modes for vm.memfd_noexec sysctl */
@@ -45,6 +46,9 @@ struct pid_namespace {
 	struct user_namespace *user_ns;
 	struct ucounts *ucounts;
 	int reboot;	/* group exit code if this pidns was rebooted */
+#ifdef CONFIG_ROOTNS
+	struct rootns *rootns;
+#endif
 	struct ns_common ns;
 	struct work_struct	work;
 } __randomize_layout;
diff --git a/include/linux/rootns.h b/include/linux/rootns.h
index 8464c90863ac..b8437bf21830 100644
--- a/include/linux/rootns.h
+++ b/include/linux/rootns.h
@@ -16,6 +16,7 @@ struct cred;
 struct file;
 struct nsproxy;
 struct pid;
+struct pid_namespace;
 struct task_struct;
 
 enum rootns_state {
@@ -47,6 +48,8 @@ struct rootns {
 struct rootns *get_rootns(struct rootns *c);
 void put_rootns(struct rootns *c);
 bool is_rootns_file(struct file *file);
+void copy_rootns(struct task_struct *tsk, struct rootns *rootns);
+void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk);
 #else
 static inline struct rootns *get_rootns(struct rootns *c)
 {
@@ -61,6 +64,15 @@ static inline bool is_rootns_file(struct file *file)
 {
 	return false;
 }
+
+static inline void copy_rootns(struct task_struct *tsk, struct rootns *rootns)
+{
+}
+
+static inline void exit_rootns(struct pid_namespace *pid_ns,
+			       struct task_struct *tsk)
+{
+}
 #endif /* CONFIG_ROOTNS */
 
 #endif /* _LINUX_ROOTNS_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8d58a7..99e22b3cd213 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -83,6 +83,7 @@
 #include <linux/fs_struct.h>
 #include <linux/magic.h>
 #include <linux/perf_event.h>
+#include <linux/rootns.h>
 #include <linux/posix-timers.h>
 #include <linux/user-return-notifier.h>
 #include <linux/oom.h>
@@ -2565,6 +2566,7 @@ __latent_entropy struct task_struct *copy_process(
 			attach_pid(p, PIDTYPE_TGID);
 			attach_pid(p, PIDTYPE_PGID);
 			attach_pid(p, PIDTYPE_SID);
+			copy_rootns(p, NULL);
 			__this_cpu_inc(process_counts);
 		} else {
 			current->signal->nr_threads++;
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 8a3c6d4e94e2..a76837b3ee33 100644
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
@@ -142,6 +143,9 @@ struct nsproxy *create_new_namespaces(u64 flags,
 		goto out_time;
 	}
 	new_nsp->time_ns = get_time_ns(ns->time_ns);
+#ifdef CONFIG_ROOTNS
+	new_nsp->rootns = ns->rootns;
+#endif
 
 	return new_nsp;
 
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 127a5fd23e70..081c27aa85bd 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -24,6 +24,7 @@
 #include <linux/sched/signal.h>
 #include <linux/idr.h>
 #include <linux/nstree.h>
+#include <linux/rootns.h>
 #include <uapi/linux/wait.h>
 #include "pid_sysctl.h"
 
@@ -280,6 +281,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 		current->signal->group_exit_code = pid_ns->reboot;
 
 	acct_exit_ns(pid_ns);
+	exit_rootns(pid_ns, me);
 	return;
 }
 
diff --git a/kernel/rootns.c b/kernel/rootns.c
index e75d918b93ec..e3b203322ae2 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -16,6 +16,7 @@
 #include <linux/ns_common.h>
 #include <linux/nsfs.h>
 #include <linux/pid.h>
+#include <linux/pid_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/compat.h>
 #include <uapi/linux/rootns.h>
@@ -105,3 +106,42 @@ bool is_rootns_file(struct file *file)
 {
 	return file->f_op == &rootns_fops;
 }
+
+void copy_rootns(struct task_struct *tsk, struct rootns *c)
+{
+	if (likely(!c || READ_ONCE(c->state) != ROOTNS_FORKING))
+		return;
+
+	scoped_guard(spinlock, &c->lock) {
+		get_rootns(c);
+		WRITE_ONCE(c->init_pid, get_task_pid(tsk, PIDTYPE_TGID));
+		WRITE_ONCE(c->state, ROOTNS_RUNNING);
+	}
+	wake_up_all(&c->waitq);
+}
+
+void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk)
+{
+	struct rootns *c = pid_ns->rootns;
+	struct task_struct *leader;
+	struct rusage rusage;
+	int status;
+
+	if (!c)
+		return;
+
+	leader = tsk->group_leader;
+	status = (tsk->signal->flags & SIGNAL_GROUP_EXIT) ?
+		 tsk->signal->group_exit_code : leader->exit_code;
+	getrusage(leader, RUSAGE_BOTH, &rusage);
+
+	scoped_guard(spinlock, &c->lock) {
+		c->exit_code = status;
+		c->rusage = rusage;
+		WRITE_ONCE(c->state, ROOTNS_DEAD);
+	}
+
+	pid_ns->rootns = NULL;
+	wake_up_poll(&c->waitq, EPOLLHUP);
+	put_rootns(c);
+}
-- 
2.47.3

