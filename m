Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795376203;
	b=jcUAd/lRQigHorTLsdkigNL6xr89phZdxuBXoE8pkGD2iGg1i5bNqsEbggHGR9ubl1Xp
	 DMJx21+F8urMLX7RhVedK2hcGw+lCyyb2J+7rhjOAtyP2nD5Eyqg1gGsVZnYu3ScAthxv
	 PRte7VEzo7RGgntdkVRm4y+OgsOMdfLmyIYoI+E+NnFbNp+mcRhtDjFdXXXjhJcGhcou7
	 zcmqGiLVLT/UY4LPgffK6oAHA0KaFHqE8MHputN7w0GFFptZw7U+huS61v9EuV0VgMZey
	 K2yC9lN303JQdRt9ToJpEwPRBt4kCzzoHKjESDk8HXA0kXDrJXD7+BnVxMs1BLvvWUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795376203;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=IjAX6Mgusa/02dTL9k5B5iNWMUDytzyYEuLarDCWpNc=;
	b=LGb4Dvhc01NhMeG1VVtaILAe1ddO4ez9iGcWDMLjP5YbKVSYanA9EtykAk2pb9Bx4tmy
	 HqtUXea84Tvnou7+rDXz03w0NR3tNFSySP8/2F3CL7E4ivF+rNfEywNz8pE1BlDDwCWq1
	 cXK3jyzRC8wf2wLZ3Cj+vg1UetwcJpWMJ+P7+Wncc+zfg/NjVYIKIGlW4FezCNt6PAEeC
	 6Tem6FKooT4FTLLcfneCdN11G0ysG6vm/MX3e05ew1QadGsZEB0K8+Y4Y7oyvk7pF7A7W
	 WpsZWYMj4VcCUEDwLvO2ZrZabKgY8eDhNFoJTzSn8Z04HTAwJZFaATg0wJoSfRgVPbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=czFAln2I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A3F7A606A333;
	Sun, 22 Nov 2026 19:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=czFAln2I
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8C2F81F000D4;
	Sun, 22 Nov 2026 19:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376203;
	bh=IjAX6Mgusa/02dTL9k5B5iNWMUDytzyYEuLarDCWpNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=czFAln2I6+sZq5DeFOwio4VktCbvoePYK6YNR+jqX5L7t1kVE1E6i4UOoC/+6YODO
	 As9Q2tdND2gTuJbgeUqygX+MOX158TyJEEyEO9tX6+1iLSif2X8rebKCba0J2MRXkA
	 hyV2Lp/6hTGUgmVrRz6OhP36LXJKHLFLd33LCxox+NfXtTjjBI2BBq1JERLBLnFhE+
	 B0V0aS/b1TK8XaRsnTnugpynFGEewuW9jXjC3mCfE+JYajLi93UElxeRhmK7auNl44
	 AyWflxSKkh4/Fqv+9i1D17R6n0QfmX+jFtO+uNeGSvJnVNXeM+YBDHEFBtAFoB05G9
	 eRtvVy4l0DpeQ==
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
Subject: [RFC PATCH v7 11/26] userland: Track init lifecycle via copy_process() and pid_namespace
Date: Sun, 22 Nov 2026 21:35:24 +0200
Message-ID: <20261122193539.3334213-12-jarkko@kernel.org>
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

A userland needs to record its init thread group's PID when bootstrapped
and capture its exit status and UID once all processes in the userland
have terminated, without serializing normal fork() and exit() paths
inside the userland.

Commit the bootstrap child reaper and bind pid_ns->userland in
userland_copy() after copy_process() attaches PIDs and drops
tasklist_lock, and invoke userland_exit() from zap_pid_ns_processes()
after the userland's PID namespace has killed and reaped all member
tasks.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/pid_namespace.h |  4 ++++
 include/linux/userland.h      | 17 ++++++++++++++
 kernel/fork.c                 |  4 ++++
 kernel/pid_namespace.c        |  2 ++
 kernel/userland.c             | 43 +++++++++++++++++++++++++++++++++++
 5 files changed, 70 insertions(+)

diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index b20baaa7e62b..ef703a3b8ed5 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -15,6 +15,7 @@
 #define MAX_PID_NS_LEVEL 32
 
 struct fs_pin;
+struct userland;
 
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_MEMFD_CREATE)
 /* modes for vm.memfd_noexec sysctl */
@@ -45,6 +46,9 @@ struct pid_namespace {
 	struct user_namespace *user_ns;
 	struct ucounts *ucounts;
 	int reboot;	/* group exit code if this pidns was rebooted */
+#ifdef CONFIG_USERLAND
+	struct userland *userland;
+#endif
 	struct ns_common ns;
 	struct work_struct	work;
 } __randomize_layout;
diff --git a/include/linux/userland.h b/include/linux/userland.h
index 9b9fefed63ac..a92709957529 100644
--- a/include/linux/userland.h
+++ b/include/linux/userland.h
@@ -9,11 +9,14 @@
 
 #include <linux/refcount.h>
 #include <linux/spinlock.h>
+#include <linux/uidgid.h>
 #include <linux/wait.h>
 
 struct file;
 struct nsproxy;
 struct pid;
+struct pid_namespace;
+struct task_struct;
 struct user_namespace;
 
 /**
@@ -57,6 +60,7 @@ struct userland {
 	struct user_namespace	*user_ns;
 	struct nsproxy		*ns;
 	struct pid		*init_pid;
+	kuid_t			init_uid;
 	spinlock_t		lock;		/* Guards userland lifecycle state */
 	wait_queue_head_t	waitq;
 	unsigned int		flags;
@@ -66,6 +70,9 @@ struct userland {
 #ifdef CONFIG_USERLAND
 void userland_put(struct userland *c);
 bool userland_is_file(struct file *file);
+void userland_copy(struct task_struct *tsk, struct pid *pid,
+		   struct userland *userland);
+void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk);
 #else
 static inline void userland_put(struct userland *c)
 {
@@ -75,6 +82,16 @@ static inline bool userland_is_file(struct file *file)
 {
 	return false;
 }
+
+static inline void userland_copy(struct task_struct *tsk, struct pid *pid,
+				 struct userland *userland)
+{
+}
+
+static inline void userland_exit(struct pid_namespace *pid_ns,
+				 struct task_struct *tsk)
+{
+}
 #endif /* CONFIG_USERLAND */
 
 #endif /* _LINUX_USERLAND_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8d58a7..d87ab7cbad5e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -83,6 +83,7 @@
 #include <linux/fs_struct.h>
 #include <linux/magic.h>
 #include <linux/perf_event.h>
+#include <linux/userland.h>
 #include <linux/posix-timers.h>
 #include <linux/user-return-notifier.h>
 #include <linux/oom.h>
@@ -2584,6 +2585,9 @@ __latent_entropy struct task_struct *copy_process(
 	syscall_tracepoint_update(p);
 	write_unlock_irq(&tasklist_lock);
 
+	if (likely(p->pid) && thread_group_leader(p))
+		userland_copy(p, pid, NULL);
+
 	if (pidfile)
 		fd_install(pidfd, pidfile);
 
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 127a5fd23e70..70606d9c5b52 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -24,6 +24,7 @@
 #include <linux/sched/signal.h>
 #include <linux/idr.h>
 #include <linux/nstree.h>
+#include <linux/userland.h>
 #include <uapi/linux/wait.h>
 #include "pid_sysctl.h"
 
@@ -280,6 +281,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 		current->signal->group_exit_code = pid_ns->reboot;
 
 	acct_exit_ns(pid_ns);
+	userland_exit(pid_ns, me);
 	return;
 }
 
diff --git a/kernel/userland.c b/kernel/userland.c
index 7be0c4b5385b..44a1976f97c2 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -92,3 +92,46 @@ bool userland_is_file(struct file *file)
 {
 	return file->f_op == &userland_fops;
 }
+
+void userland_copy(struct task_struct *tsk, struct pid *pid, struct userland *c)
+{
+	if (likely(!c || !is_child_reaper(pid)))
+		return;
+
+	scoped_guard(spinlock, &c->lock) {
+		if (c->state != USERLAND_FORKING)
+			return;
+		refcount_inc(&c->usage);
+		ns_of_pid(pid)->userland = c;
+		WRITE_ONCE(c->init_pid, get_pid(pid));
+		WRITE_ONCE(c->state, USERLAND_RUNNING);
+	}
+}
+
+void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk)
+{
+	struct userland *c = pid_ns->userland;
+	struct task_struct *leader;
+	kuid_t uid;
+	int status;
+
+	if (!c)
+		return;
+
+	leader = tsk->group_leader;
+	rcu_read_lock();
+	uid = task_uid(leader);
+	rcu_read_unlock();
+	status = (tsk->signal->flags & SIGNAL_GROUP_EXIT) ?
+		 tsk->signal->group_exit_code : leader->exit_code;
+
+	scoped_guard(spinlock, &c->lock) {
+		c->exit_code = status;
+		c->init_uid = uid;
+		WRITE_ONCE(c->state, USERLAND_DEAD);
+	}
+
+	pid_ns->userland = NULL;
+	__wake_up(&c->waitq, TASK_NORMAL, 0, poll_to_key(EPOLLHUP));
+	userland_put(c);
+}
-- 
2.47.3

