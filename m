Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310358;
	b=hxWglghyw9rPGwsSJe5HLtrDyLOJsQAUpnwQUq7HAYagz2xDRBicRix5ftjv6d+XPkK2
	 eeZODoBInlZh/a6FLxx70YaycebNtwVVVwiocc7ct/8iZ6NlT54HKSwOBgzpDqaGvjekD
	 zZVyZJQX3aQMwVLMhMWthjSqNe66/GjZbQ3vrT56+gp8/jMAV3Wgf+EJezaYv1u6MNdEr
	 /55R1T3S8fValAKFhrc+jijYJQaZ/AsHvEY5xl5jpNXB5efP2lG8GsWhN0iKY8Mwaytau
	 XwmHC91W3T50AzTDsNc51TMoMMZi/jzu+9X3f8LXeNqh6/gqfGNiHvynH6vZ75WIsHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Bc4KCqTCCvqKRhvZx+lV6nXL57V09zR0YOdKWGFcYhA=;
	b=mz8tZLIL+QJmBh1vLSg7aYphHld3ITX1SLC5Wb+1hHiylBcMm7Dzjtb6FJ3fXfDPwye5
	 e9OJPQQLJiOLwNN9J+l5iHHZ5LgHFVJ3M0a47PjmCQmB8q7KIF70wWR1izIeLM63x55XX
	 L1nB3BmIsBWV63hiLqeJL553PwXV0D+r0K9wx4L3uoMtcci9NyK1rANHqkdz9ZZY0SspG
	 Pg8XJd6jSUt01CDY5e6I9gtBxriIJ36wQtieknMJ1fnQJeg4miV7rYKtWLHaano6AIJ4R
	 dFJ9Jzh0O/CsEkBdnFLApcg1daul7FsZkHs3iFoURMmwAHEaPMtZ2DjEhy85qOoOxTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e2GoX14N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 08DB5606A330;
	Sun, 22 Nov 2026 01:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e2GoX14N
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F09711F000CA;
	Sun, 22 Nov 2026 01:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310357;
	bh=Bc4KCqTCCvqKRhvZx+lV6nXL57V09zR0YOdKWGFcYhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2GoX14NlATm1xCe8kfL8b13V3o4ev026JjDpzRUVhQrAW4ge8mPmgOt0siXlM53b
	 GOCBuE3fvx+EN1DyFout1BBt4pYYKtUBG/u7HDwO8xEx9AwajQcgXyYHooNTFr+894
	 nh5vlspqdYtceJfowBfHcHkr0qq6ytTqL+4PE9Aj0RiQ7h4qJU3JsEMiSPGJ4kFbOy
	 7EpswnvEAO+OhQ/TYe2KgiIU8Mf/OdD3IAdY/5WNty+4i9MqtSdCp0VHRlq+mKuT5v
	 XVkYiSbeufsxkHrL9yM/gJYkBEPaL+cMURtT5/HuKJuvB4QsYmeoxn5CPKYBxCKVUo
	 5KDKoRMg8HVvw==
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
Subject: [RFC PATCH v6 15/26] exit: Support P_USERLAND in waitid()
Date: Sun, 22 Nov 2026 03:17:58 +0200
Message-ID: <20261122011809.2667684-16-jarkko@kernel.org>
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

wait4() and waitid() only allow a parent or subreaper to collect exit
status, so an external manager holding a userland file descriptor cannot
wait on a userland init process forked by another process or observe
exit status multiple times across observers.

Add P_USERLAND to waitid() and wire kernel_waitid() to userland_waitid()
to wait freezably and interruptibly on a userland file descriptor until
the userland reaches USERLAND_DEAD and populate siginfo_t with init's
caller-visible TGID, munged UID, and exit status without consuming it.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/userland.h  | 10 +++++
 include/uapi/linux/wait.h |  1 +
 kernel/exit.c             |  4 ++
 kernel/userland.c         | 79 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 94 insertions(+)

diff --git a/include/linux/userland.h b/include/linux/userland.h
index ec74eed6de1d..1bab10d931b5 100644
--- a/include/linux/userland.h
+++ b/include/linux/userland.h
@@ -16,8 +16,10 @@ struct file;
 struct nsproxy;
 struct pid;
 struct pid_namespace;
+struct rusage;
 struct task_struct;
 struct user_namespace;
+struct waitid_info;
 
 enum userland_state {
 	USERLAND_INIT		= 0,
@@ -45,6 +47,8 @@ bool userland_is_file(struct file *file);
 void userland_copy(struct task_struct *tsk, struct pid *pid,
 		   struct userland *userland);
 void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk);
+long userland_waitid(int upid, struct waitid_info *infop, int options,
+		     struct rusage *ru);
 #else
 static inline void userland_put(struct userland *c)
 {
@@ -64,6 +68,12 @@ static inline void userland_exit(struct pid_namespace *pid_ns,
 				 struct task_struct *tsk)
 {
 }
+
+static inline long userland_waitid(int upid, struct waitid_info *infop,
+				   int options, struct rusage *ru)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_USERLAND */
 
 #endif /* _LINUX_USERLAND_H */
diff --git a/include/uapi/linux/wait.h b/include/uapi/linux/wait.h
index 85b809fc9f11..edd39c2cab96 100644
--- a/include/uapi/linux/wait.h
+++ b/include/uapi/linux/wait.h
@@ -18,6 +18,7 @@
 #define P_PID		1
 #define P_PGID		2
 #define P_PIDFD		3
+#define P_USERLAND	4
 
 
 #endif /* _UAPI_LINUX_WAIT_H */
diff --git a/kernel/exit.c b/kernel/exit.c
index d5e7bc2af804..5b0bd3a9187c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -71,6 +71,7 @@
 #include <linux/unwind_deferred.h>
 #include <linux/uaccess.h>
 #include <linux/pidfs.h>
+#include <linux/userland.h>
 
 #include <uapi/linux/wait.h>
 
@@ -1803,6 +1804,9 @@ static long kernel_waitid(int which, pid_t upid, struct waitid_info *infop,
 	struct wait_opts wo;
 	long ret;
 
+	if (which == P_USERLAND)
+		return userland_waitid(upid, infop, options, ru);
+
 	ret = kernel_waitid_prepare(&wo, which, upid, infop, options, ru);
 	if (ret)
 		return ret;
diff --git a/kernel/userland.c b/kernel/userland.c
index efac9e4f2fa5..c118defcff01 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -8,6 +8,7 @@
 #include <linux/wait.h>
 #include <uapi/linux/wait.h>
 #include <linux/file.h>
+#include <linux/freezer.h>
 #include <linux/fs.h>
 #include <linux/anon_inodes.h>
 #include <linux/userland.h>
@@ -33,6 +34,8 @@
 #include <linux/idr.h>
 #include <uapi/linux/userland.h>
 
+#include "exit.h"
+
 void userland_put(struct userland *c)
 {
 	if (!c || !refcount_dec_and_test(&c->usage))
@@ -208,6 +211,82 @@ static long userland_share_nsfd(struct userland *c, unsigned long arg)
 	return 0;
 }
 
+/**
+ * DOC: P_USERLAND
+ *
+ * ``waitid(P_USERLAND, userland_fd, &infop, options, NULL)`` waits freezably until
+ * ``userland_fd`` reaches ``USERLAND_DEAD`` (unless ``WNOHANG`` or ``O_NONBLOCK`` is
+ * set) and writes init's exit information into ``infop`` without consuming it.
+ * ``options`` must include ``WEXITED`` and may include ``WNOHANG`` and
+ * ``WNOWAIT``; ``rusage`` must be ``NULL``, and the caller must run in an
+ * ancestor active PID namespace.
+ */
+long userland_waitid(int upid, struct waitid_info *infop, int options,
+		     struct rusage *ru)
+{
+	struct pid_namespace *pid_ns;
+	unsigned int f_flags;
+	struct userland *userland;
+	bool nonblock;
+	int status;
+	kuid_t uid;
+	long ret;
+
+	if (upid < 0 || ru)
+		return -EINVAL;
+	if (options & ~(WEXITED | WNOHANG | WNOWAIT))
+		return -EINVAL;
+	if (!(options & WEXITED))
+		return -EINVAL;
+
+	CLASS(fd, f)(upid);
+	if (fd_empty(f) || !userland_is_file(fd_file(f)))
+		return -EBADF;
+
+	f_flags = READ_ONCE(fd_file(f)->f_flags);
+	nonblock = (options & WNOHANG) || (f_flags & O_NONBLOCK);
+	userland = fd_file(f)->private_data;
+	pid_ns = task_active_pid_ns(current);
+
+	if (!pidns_is_ancestor(userland->ns->pid_ns_for_children, pid_ns))
+		return -ECHILD;
+	if (READ_ONCE(userland->state) == USERLAND_INIT)
+		return -ECHILD;
+
+	if (!nonblock) {
+		ret = wait_event_freezable(userland->waitq,
+					   READ_ONCE(userland->state) ==
+					   USERLAND_DEAD ||
+					   READ_ONCE(userland->state) ==
+					   USERLAND_INIT);
+		if (ret)
+			return ret;
+	}
+
+	scoped_guard(spinlock, &userland->lock) {
+		if (userland->state == USERLAND_INIT)
+			return -ECHILD;
+		if (userland->state != USERLAND_DEAD)
+			return (options & WNOHANG) ? 0 : -EAGAIN;
+		ret = pid_nr_ns(userland->init_pid, pid_ns);
+		if (ret <= 0)
+			return -ECHILD;
+		status = userland->exit_code;
+		uid = userland->init_uid;
+	}
+
+	if ((status & 0x7f) == 0) {
+		infop->cause = CLD_EXITED;
+		infop->status = status >> 8;
+	} else {
+		infop->cause = (status & 0x80) ? CLD_DUMPED : CLD_KILLED;
+		infop->status = status & 0x7f;
+	}
+	infop->pid = ret;
+	infop->uid = from_kuid_munged(current_user_ns(), uid);
+	return ret;
+}
+
 static long userland_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct userland *userland = file->private_data;
-- 
2.47.3

