Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310342;
	b=XC/belr492qvKzCIo3CVtbM71RT4r8SlzLfwMJxcv0cjGiLYn+JLDxYP8a0EqCnz3DAx
	 O0JnZZW6K/Us2LWogG5tdMRG9ZQga3wvY6FZ7dhRKHMQBFY1QcwF0H6qv8N6PNUSQdpad
	 PNIAvof/oKSzH49FGXOaXrsJn/eoxhZ38xVOFZ+FesYKMuJ21IdTPOEtZ+iF+K0DNdcLU
	 L1/FihjSCl07hcTRBCn7rHTsg89Ul6LqJ3cjrcMPyhFCOXIXSp8TlOdCbcRK9pn15ttYQ
	 H4fcGW7V00eHKncHJYVjrHxaGw5lC+RzEEWitBWH8k3KghBE05rAq/UubEAiDU2VNqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=YAN/hIhGbLif51uDHJWEreVc/FgOTWv2rNXCLUKagZ8=;
	b=24rTDl1PBee3aigCq0qZVP94FS1cGpdSWINRTdJGg+GB/yfcgYonNwoX52cWGyKyfYcE
	 4Enn86/FYolVzbMsRNLRQQ98CTRKa1ZW7tqetF/GX7bPvYvI4AFM4FBwcwhp5g/DtKyI/
	 /vpBdXZGxJB+qOZrpTZYoPvM9DX7yPj1qJc5yyALmiLA+1Kt8Ftj+YzHE/F0a9UGrGJYp
	 sN6aUmx+/yD7KIO1195iMRHaElXBnQxcjnp/y7GRQMfQKzjGyi1joEDFRa0amOTdCXiy8
	 DBvAD1konzt3L7nXlWYmOZp4VOWsLeJ/XRGlxJg1vvhCiVt+VFOPbA6QbOsE/WU0Wmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FgzGRfYK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 6B76B606A335;
	Sun, 22 Nov 2026 01:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FgzGRfYK
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 45E7A1F000D8;
	Sun, 22 Nov 2026 01:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310342;
	bh=YAN/hIhGbLif51uDHJWEreVc/FgOTWv2rNXCLUKagZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FgzGRfYKw+DvTaxI/TJkS3XWpgcgNwC1efsrf0owiy14/cSZNn12put4iBUSIKCrs
	 zZhnP7PNqOXEbq04gIYPVPLQiwTJEmhJpNK+SdBh2Fj3seSPoVDt6Hr0ig+LrYauJI
	 L3XdKbIZGT2ApiLhefbVuRArglqkOp3aY2Tlp1hc7lxot7it4c2aJhUvdbW3yTWFIy
	 WgxivBKqGTBb3cz/uCx/mH3SkN5FYjrtvDK5ZFeuDVbYbJSXsdqkQTOJoobW0kaT00
	 h5pi07pfKUNoB6LMsYlgyYROiHMdkaxjiOKePjU3ad5pi3h9uqnpfP0cd6uJQChr/0
	 eeQLvrTw8x/tQ==
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
Subject: [RFC PATCH v6 11/26] userland: Track init lifecycle via copy_process() and pid_namespace
Date: Sun, 22 Nov 2026 03:17:54 +0200
Message-ID: <20261122011809.2667684-12-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
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
userland_copy() after attach_pid(PIDTYPE_PID), and invoke
userland_exit() from zap_pid_ns_processes() after the userland's PID
namespace has killed and reaped all member tasks.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/pid_namespace.h |  4 ++++
 include/linux/userland.h      | 17 ++++++++++++++
 kernel/fork.c                 |  3 +++
 kernel/pid_namespace.c        |  2 ++
 kernel/userland.c             | 43 +++++++++++++++++++++++++++++++++++
 5 files changed, 69 insertions(+)

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
index fa8628e1b89c..ec74eed6de1d 100644
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
 
 enum userland_state {
@@ -29,6 +32,7 @@ struct userland {
 	struct user_namespace	*user_ns;
 	struct nsproxy		*ns;
 	struct pid		*init_pid;
+	kuid_t			init_uid;
 	spinlock_t		lock;		/* Guards userland lifecycle state */
 	wait_queue_head_t	waitq;
 	unsigned int		flags;
@@ -38,6 +42,9 @@ struct userland {
 #ifdef CONFIG_USERLAND
 void userland_put(struct userland *c);
 bool userland_is_file(struct file *file);
+void userland_copy(struct task_struct *tsk, struct pid *pid,
+		   struct userland *userland);
+void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk);
 #else
 static inline void userland_put(struct userland *c)
 {
@@ -47,6 +54,16 @@ static inline bool userland_is_file(struct file *file)
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
index 5efceb8d58a7..2fceacc17e8a 100644
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
@@ -2576,6 +2577,8 @@ __latent_entropy struct task_struct *copy_process(
 					  &p->signal->thread_head);
 		}
 		attach_pid(p, PIDTYPE_PID);
+		if (thread_group_leader(p))
+			userland_copy(p, pid, NULL);
 		nr_threads++;
 	}
 	total_forks++;
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
index b339aa2103e1..e117b00cb8a2 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -85,3 +85,46 @@ bool userland_is_file(struct file *file)
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

