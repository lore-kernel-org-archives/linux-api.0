Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030561;
	b=Naw1lHrQafAWLTKYvD9g34IYX08km4xVwHnpeQuCxDuy+93b3W+XNlcpXCG8tGJ2bXqM
	 xovxDcmyKsTxE0LL4CEpQuFqbIFL/s29H+JTgHMPJu//tgVDWApnpSuLUjqXjHQ+D3+9g
	 gUao1Esl3ouTwiyMpi4vW0w4V4RNtswqLpWPo+kH/OXUMDfhO0G8rvRDjM29x+faMrJFj
	 oMAB3bUUyVB7sbkVvFm3xN85r8zDvBs+UogYiKsviJF2iFR5f/98brLquTVBD+105RLdP
	 4ONbEqTDBLL8SsnptpwG8Dgwh619RZ2tVjM4LY76hjdxIMNLlY+IinKf6ZtRiCxPiog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=0ctpsmhbyotylAB6OOcib6fh861mOu3WKscyAmfRUVA=;
	b=eNo5tBT4fTSsksaNs64QUq1IVrXx/qdZQKuEzwpptE2PrB6Xq3m2pPwz6ejnR3zd8Ow2
	 jSW1FYdpucp6eee5ARtJwbQE58kftRNn05R4DbxrHF/Rk1l73jFcHcyIorRvAnzpieghy
	 bgoFqT3crhUcgmIYaj0AYiNeGnuhQ4GeqV3cZuY+i5o14W687wWXEi7n0FNmM8MEOa3bF
	 KTbXo56s55EUWnaliwGSdu8p4eDIwpBlAuEa+zs1sYZFDCehkk67wuwGh3Zj3BpC3pBBv
	 BEcjtvyqmFrf2BeKkvMoCqZVZ2vw+W3zIqKxwDZzF5Ha1Lzp7YsGxc0m1pDdkXKY1IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h2zOkQqV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 01F58606D373;
	Wed, 18 Nov 2026 19:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h2zOkQqV
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1CBE11F000C5;
	Wed, 18 Nov 2026 19:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795030560;
	bh=0ctpsmhbyotylAB6OOcib6fh861mOu3WKscyAmfRUVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2zOkQqVHmHg8iLGsx+lhodz/2uGa4/pQ/+IWwTzHOXv/pIQEtrEW/+HDUrw8fkrz
	 aPNNXp3lQL/6iCKyi2k/hn3e7lmabJKG9vpto7CYqhUFUp1Z7KZQSkc/iTMpVJZH2W
	 CGWhf6XPYtgb9O/6q95TDrbn9wnuASgTJrWT9jzTZYvyeK5MZ/rL3R8cDllZcdg/Ug
	 M/EF/NVVPNa8jNdtBQn8ZehMQgIATNmIZ7Oj0xl60dCm7sbnBWiREOzw/SL7sPTFLm
	 cZOyp6FOY6JXcJtvgg+HjVKlogYjjB6xYZCFL32UvqSjKyKfwawshRBLjXBub4/8lW
	 m0DjyT8fFOp0A==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
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
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v3 03/13] rootns: Track init lifecycle via copy_process() and pid_namespace
Date: Wed, 18 Nov 2026 21:35:29 +0200
Message-ID: <20261118193539.240065-4-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118193539.240065-1-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
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

Commit the bootstrap child reaper, bind pid_ns->rootns, and wake waiters
in copy_rootns() after attach_pid(PIDTYPE_PID), and invoke exit_rootns()
from zap_pid_ns_processes() after the root namespace's PID namespace has
killed and reaped all member tasks.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/pid_namespace.h |  4 ++++
 include/linux/rootns.h        | 15 +++++++++++++
 kernel/fork.c                 |  3 +++
 kernel/pid_namespace.c        |  2 ++
 kernel/rootns.c               | 41 +++++++++++++++++++++++++++++++++++
 5 files changed, 65 insertions(+)

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
index a1b2c3f8958b..2c34d6cd211a 100644
--- a/include/linux/rootns.h
+++ b/include/linux/rootns.h
@@ -14,6 +14,8 @@
 struct file;
 struct nsproxy;
 struct pid;
+struct pid_namespace;
+struct task_struct;
 struct user_namespace;
 
 enum rootns_state {
@@ -43,6 +45,9 @@ struct rootns {
 struct rootns *get_rootns(struct rootns *c);
 void put_rootns(struct rootns *c);
 bool is_rootns_file(struct file *file);
+void copy_rootns(struct task_struct *tsk, struct pid *pid,
+		 struct rootns *rootns);
+void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk);
 #else
 static inline struct rootns *get_rootns(struct rootns *c)
 {
@@ -57,6 +62,16 @@ static inline bool is_rootns_file(struct file *file)
 {
 	return false;
 }
+
+static inline void copy_rootns(struct task_struct *tsk, struct pid *pid,
+			       struct rootns *rootns)
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
index 5efceb8d58a7..08fc28ad1eed 100644
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
@@ -2576,6 +2577,8 @@ __latent_entropy struct task_struct *copy_process(
 					  &p->signal->thread_head);
 		}
 		attach_pid(p, PIDTYPE_PID);
+		if (thread_group_leader(p))
+			copy_rootns(p, pid, NULL);
 		nr_threads++;
 	}
 	total_forks++;
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
index 4c08ac575f6c..4f40dac4225f 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -158,3 +158,44 @@ bool is_rootns_file(struct file *file)
 {
 	return file->f_op == &rootns_fops;
 }
+
+void copy_rootns(struct task_struct *tsk, struct pid *pid, struct rootns *c)
+{
+	if (likely(!c || !is_child_reaper(pid)))
+		return;
+
+	scoped_guard(spinlock, &c->lock) {
+		if (c->state != ROOTNS_FORKING)
+			return;
+		ns_of_pid(pid)->rootns = get_rootns(c);
+		WRITE_ONCE(c->init_pid, get_pid(pid));
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

