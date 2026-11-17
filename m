Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794957262;
	b=SR+x4U4eeyU8algUJ29v1eOvGFSALNOm887BsS9TuE0BA9k9g+YSoZMrveqyTM1F7cRk
	 uPbtTKX8N0c9L2wfFkHENuT9P0lJQX5uysI/8cvlb/s6Lxmd1cmcI8rcFpR0tcOPgKE0x
	 IFkw2jfkH7c8a4dfJ2xVZrYVW1Nzy39Ja5ScSGFGqzEGIt4NRiIks0Fi6DMwNzmIXp/x5
	 WEwSx6lAh+Y5tfxxDpFTXh3Ap6F2O8DXajYK3JOEiq9TyxBNAjem/Os4C/xZg5QIW96W8
	 Euhy/vWl5W2HqJj2s7u/EpAUNAo3YsFBeLHIRzxMVA9Y9zD3PRn7N53SdplzZWO8Vdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794957262;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Z4UcpSJwQBQuoHR5qdUhHXpoXN8IDliu0g7bZUNHj/c=;
	b=15Hk/gYzo+OO9vdGfkv7pDyIi3nyztdphJur8Xrclf+8Xp7GxX6z+m++w/+in914ZEul
	 I3JbA+zxAp6kbTFwkqTUfdMvyISIHT0yhQwBsG+rZNJIah+Lou/xuN92h+AMJyjSP3+0m
	 ThAZXuGOndN6buzMhwamh1HuPkoQewrMSyDdapmNLF3B1h5N32JGEuAQ0IHsrYn1YNoO1
	 2bH07tj5THWE2yiGVlXXf7xiQoYOJRGOdeOQAA+piMk9qEvXM1dz/t4w81a1pIQ5Fy8mu
	 9tVXMXrHsUGnmw3xZlNxVkUhE3zVU+B7xzgwacSKXYW7qaRJjkFFBaCahRdQ9Qf8XXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mgn7xx4n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C6153606A332;
	Tue, 17 Nov 2026 23:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mgn7xx4n
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B0ECD1F000C7;
	Tue, 17 Nov 2026 23:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957262;
	bh=Z4UcpSJwQBQuoHR5qdUhHXpoXN8IDliu0g7bZUNHj/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mgn7xx4nVzrINzAXPpNzP9V0SHtVBa+xtqQCzQZd01NST6UieqjbA5obv2laBEeCr
	 XE+vNTzweH1saiAo0GjZvY+EJI3s/tWrMSSu9BGRoWseZGYIGD0bl7K9YyIsJFfLqq
	 vwZciFmBMd181d7tGi9OjvhallGCVF3dmvRwydsTHdRXj4wWbRoSo3jweVgHoUjLZP
	 VqMyw1R6u+YxlpI+bfPrk6ANvV0Pd/3lfrA/LTCmicouq6/QVYZyAB8rHvSEO74kb0
	 h6+fguwFj3N6cQe/IybuBICp7rtuvtgtGFUngXM5gTKPaIyFIEbLl1yurXNHh3A948
	 UTYFJpGqgOcQQ==
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
Subject: [RFC PATCH v2 03/13] rootns: Track init lifecycle via copy_process() and pid_namespace
Date: Wed, 18 Nov 2026 01:13:42 +0200
Message-ID: <20261117231352.3816603-4-jarkko@kernel.org>
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

A root namespace needs to record its init thread group's PID when
bootstrapped and capture its exit status and resource usage once all
processes in the root namespace have terminated, without serializing
normal fork() and exit() paths inside the container.

Commit the bootstrap init PID and wake waiters in copy_rootns(), and
invoke exit_rootns() from zap_pid_ns_processes() after the root
namespace's PID namespace has killed and reaped all member tasks.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/pid_namespace.h |  4 ++++
 include/linux/rootns.h        | 12 +++++++++++
 kernel/fork.c                 |  2 ++
 kernel/pid_namespace.c        |  2 ++
 kernel/rootns.c               | 40 +++++++++++++++++++++++++++++++++++
 5 files changed, 60 insertions(+)

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

