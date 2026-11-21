Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219786;
	b=L7D461S6bBBBMq8PheL1VyqyDRgIIIExgGZ6hmaOEnGDYYq+lNtOQcd2a4pJLJGfOx8t
	 e2/4YvqKmSW9TBIGcQXUoHv/yjEqpwi4I75JLjTEQaqu5O6beWV6NAqdaybDKru60BM3g
	 PZov4n9foQw8c5LkG/Z1KLR5fj3E+qw74tsSxDYlGBuJYiFM5Oc0v385iDj6BCcB6nUd3
	 SllkK784sD3RNV/YZc0juRc84GmILZuAhguVxpp9U07/vIVNZxLZnhrDdhYzLNn2vDaZJ
	 Yr7pF2V/SijTo0997VBSPlX5Y1501WhamJG6qhupcT1WkvHqQ7VQayMmk19GS9+vpTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=GSFAa5q4pk8rKycfd2l1otknxN4x1Z6rfvdlMGDR0Hw=;
	b=qHYu3CVLOMe1WReXk4L3ruNZuaox0BbqxOb6fjrVkOGzfnwYhmOBI6qaXn9VpcL3Kfa6
	 1of5GsxBUybYWMD9Q6IpYeKhnm8MhYL7bp/tcNHc7W9IxPQ/uZ+Mfx0zF29FcHD8CnOfd
	 wwPKUEypeEO37mXHVFURvSgarfeNoAtLkEe+eunwtUrhHjHyNPmyzJZXvxQGxyl7kfVFi
	 JCY8mBTXk9JSZ5RqVaeVcqugVUuukkcrwY4vCDNP56hFQ4PUg4+XvQZOe8URgtnBqdIgH
	 /dw99UdEgPROVJgUXLgAdOU6avw7b0OnW7/Rfzntn/cuUHy4NTrObSGxHYHlbn71SuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=exg0p9Fu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D0BBA60A2635;
	Sat, 21 Nov 2026 00:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=exg0p9Fu
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2E03C1F000E6;
	Sat, 21 Nov 2026 00:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219786;
	bh=GSFAa5q4pk8rKycfd2l1otknxN4x1Z6rfvdlMGDR0Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=exg0p9FuhSRg96Fa0UI64RNFn7ZEmCFC7qxHAngayMUiSbtTQnH76nPFzFtOAL7A7
	 zPAZ2vovIXviQ4eu51V97EakgNUc5vWOvMRXXDEkabUKRj58n+KVe4FA1AcoNBXtpW
	 HS5u7uspHEPetwIAqadQoDvIL8M1dqh7pieUdprMOYDKGWqpuAGTQ+PKcwXIoboaTJ
	 JnoorEnBPLvkPlx9FqqIKfeVf2Fsu9uxfM+eJmOLf+ZFT5kDPBg7tS+jOmAPShcwyl
	 oReAllMY36Tfc4KqCMgKO14KgoAkMK/zsyFQTBL9osh2Ksj4A4yQkOMnC97h5sz0p5
	 yzM8okWgI4SFA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 12/25] rootns: Track init lifecycle via copy_process() and pid_namespace
Date: Sat, 21 Nov 2026 02:08:31 +0200
Message-ID: <20261121000844.1863324-13-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
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
bootstrapped and capture its exit status once all processes in the root
namespace have terminated, without serializing normal fork() and exit()
paths inside the container.

Commit the bootstrap child reaper and bind pid_ns->rootns in
copy_rootns() after attach_pid(PIDTYPE_PID), and invoke exit_rootns()
from zap_pid_ns_processes() after the root namespace's PID namespace has
killed and reaped all member tasks.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/pid_namespace.h |  4 ++++
 include/linux/rootns.h        | 15 ++++++++++++++
 kernel/fork.c                 |  3 +++
 kernel/pid_namespace.c        |  2 ++
 kernel/rootns.c               | 37 +++++++++++++++++++++++++++++++++++
 5 files changed, 61 insertions(+)

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
index dcdba08cfaeb..6add4dd55550 100644
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
@@ -42,6 +44,9 @@ struct rootns {
 struct rootns *get_rootns(struct rootns *c);
 void put_rootns(struct rootns *c);
 bool is_rootns_file(struct file *file);
+void copy_rootns(struct task_struct *tsk, struct pid *pid,
+		 struct rootns *rootns);
+void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk);
 #else
 static inline struct rootns *get_rootns(struct rootns *c)
 {
@@ -56,6 +61,16 @@ static inline bool is_rootns_file(struct file *file)
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
index 033e0aae386f..fd8ce59de61a 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -185,3 +185,40 @@ bool is_rootns_file(struct file *file)
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
+}
+
+void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk)
+{
+	struct rootns *c = pid_ns->rootns;
+	struct task_struct *leader;
+	int status;
+
+	if (!c)
+		return;
+
+	leader = tsk->group_leader;
+	status = (tsk->signal->flags & SIGNAL_GROUP_EXIT) ?
+		 tsk->signal->group_exit_code : leader->exit_code;
+
+	scoped_guard(spinlock, &c->lock) {
+		c->exit_code = status;
+		WRITE_ONCE(c->state, ROOTNS_DEAD);
+	}
+
+	pid_ns->rootns = NULL;
+	__wake_up(&c->waitq, TASK_NORMAL, 0, poll_to_key(EPOLLHUP));
+	put_rootns(c);
+}
-- 
2.47.3

