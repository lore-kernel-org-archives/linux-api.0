Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310361;
	b=DBrEY/wPoAH+eZmiMgGreNt6nwn35MToJaNxGv0JX3o4IHh5oAfDAYNHOXZNYQ+/Jiln
	 oh9LL9W4oceOQCcM2RbxnuQ/gs/o8gsnHDPGAQNLq06bKUNHRYZzhM0NNx9dP4l1ttPfs
	 AKw2kCVLqsUiiNVtWqFYelDTgIjVe2nJ/HhpUBE7suI9WdfmwY6KucSAIiodCgBFhyiDO
	 fjeoRDaByNjNht0uRJEoCrL7cMn8jZ7aakoRyh2Cb0aJxXxOi961QOeqa8I4dXY8iXr7c
	 X0gwAx96IFWXWPB+7EONhen8aseKnyLN6AhUimSMUd21gaMHPTnRwCxjj3wDuSXw3Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=RAXPLGk4ldTVweRjtypyvQWpm01HWBNWEtkTkkZV0Ks=;
	b=MK0tqp1mGqX+HF/RhNTCwQfw3+SGiWrkuvYiKIkJYZcAC8MUErt8mrLXbIjS9a+298r2
	 OFihYl501B1AoVkmFPZy2IuHC7zBcyp+hXipE6x3eb+TJWb8VO+xCUY7W/9FodSA1gJbR
	 h9BHUNszFgyJQKhZOizLDPt32Y20xZdPmLeg9QXP7rRNblq0CsMcYycrvCCTVh/EJyf2O
	 6nb1lQQgJdf1Vrjfrll0+vYUBG7gxqZGXQQkgniJT5giCsVcJ5ayxHFPTWOgmDjMLz+R2
	 0nLB4pDMEQoIC8uYUnfO30eHPrgZ7LRQNvnrVW/zAKJXGS51wV4snmrg8+OPGMFj6yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Dz/4YhIh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A5087606A68E;
	Sun, 22 Nov 2026 01:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dz/4YhIh
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C9AE81F000C4;
	Sun, 22 Nov 2026 01:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310361;
	bh=RAXPLGk4ldTVweRjtypyvQWpm01HWBNWEtkTkkZV0Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dz/4YhIhwbfL7TBgpLOYcylHoSeC+EfOHizQxdnsHkkOkMt8dmQPqoFCuUqkozR/D
	 Ms9eeSCO9jU09brnBXTvHR8rTFC+YaPSbPtaS0Fp3UD0xZpDqjlYwLFsZVvI7cJogJ
	 zP54NVWr2/eJab+dPmKx2QKMmua8/q3GNiHGjOqHHETgHjx1gJ03D5+3Rg/37LSUgH
	 o3rzBgmcblZ5FaJs8T+Kku3WVSB/72I7DwwvZ2jaqT9n2mrLElXIG9YzMMrl/GsZnY
	 0k0iaQ7jc3K4+WNUvL9r/kw2Fh4CYRr8g9YB+JqSIj9hG3B2SzE1tkWIt9FNRIQ8XB
	 QgSw7hVxu2wQw==
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
Subject: [RFC PATCH v6 16/26] signal: Support userland fds in pidfd_send_signal()
Date: Sun, 22 Nov 2026 03:17:59 +0200
Message-ID: <20261122011809.2667684-17-jarkko@kernel.org>
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

Signaling every process inside a userland from userspace via /proc is
racy against concurrent fork() calls.

Teach pidfd_send_signal() to dispatch userland file descriptors to
userland_send_signal() when info is NULL and flags is 0. Require an
ancestor active PID namespace, walk the userland's PID namespace IDR
under tasklist_lock, and deliver a validated signal once to each thread
group including in-flight forks, aggregating per-process delivery
results.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/userland.h | 10 +++++++
 kernel/signal.c          |  4 +++
 kernel/userland.c        | 59 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+)

diff --git a/include/linux/userland.h b/include/linux/userland.h
index 1bab10d931b5..173c22c27ae9 100644
--- a/include/linux/userland.h
+++ b/include/linux/userland.h
@@ -17,6 +17,7 @@ struct nsproxy;
 struct pid;
 struct pid_namespace;
 struct rusage;
+struct siginfo;
 struct task_struct;
 struct user_namespace;
 struct waitid_info;
@@ -49,6 +50,8 @@ void userland_copy(struct task_struct *tsk, struct pid *pid,
 void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk);
 long userland_waitid(int upid, struct waitid_info *infop, int options,
 		     struct rusage *ru);
+int userland_send_signal(struct file *file, int sig,
+			 struct siginfo __user *info, unsigned int flags);
 #else
 static inline void userland_put(struct userland *c)
 {
@@ -74,6 +77,13 @@ static inline long userland_waitid(int upid, struct waitid_info *infop,
 {
 	return -EINVAL;
 }
+
+static inline int userland_send_signal(struct file *file, int sig,
+				       struct siginfo __user *info,
+				       unsigned int flags)
+{
+	return -EBADF;
+}
 #endif /* CONFIG_USERLAND */
 
 #endif /* _LINUX_USERLAND_H */
diff --git a/kernel/signal.c b/kernel/signal.c
index dd770e68faee..5b11e67dc98a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -37,6 +37,7 @@
 #include <linux/capability.h>
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
+#include <linux/userland.h>
 #include <linux/nsproxy.h>
 #include <linux/user_namespace.h>
 #include <linux/uprobes.h>
@@ -4181,6 +4182,9 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, int, sig,
 		if (fd_empty(f))
 			return -EBADF;
 
+		if (userland_is_file(fd_file(f)))
+			return userland_send_signal(fd_file(f), sig, info, flags);
+
 		/* Is this a pidfd? */
 		pid = pidfd_to_pid(fd_file(f));
 		if (IS_ERR(pid))
diff --git a/kernel/userland.c b/kernel/userland.c
index c118defcff01..739f6b98c103 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -287,6 +287,65 @@ long userland_waitid(int upid, struct waitid_info *infop, int options,
 	return ret;
 }
 
+/**
+ * DOC: pidfd_send_signal
+ *
+ * ``pidfd_send_signal(userland_fd, sig, NULL, 0)`` delivers ``sig`` (or ``0`` for
+ * a permission and existence probe) once to each member thread group in a
+ * running userland. ``info`` must be ``NULL``, ``flags`` must be ``0``, and the
+ * caller must run in an ancestor active PID namespace.
+ */
+int userland_send_signal(struct file *file, int sig,
+			 struct siginfo __user *info, unsigned int flags)
+{
+	struct userland *userland = file->private_data;
+	struct pid_namespace *pid_ns = userland->ns->pid_ns_for_children;
+	bool any_success = false;
+	bool any_other = false;
+	bool any_perm = false;
+	int other_err = 0;
+	struct pid *pid;
+	int nr;
+
+	if (info || flags || sig < 0 || !valid_signal(sig))
+		return -EINVAL;
+	if (!pidns_is_ancestor(pid_ns, task_active_pid_ns(current)))
+		return -EXDEV;
+	if (READ_ONCE(userland->state) != USERLAND_RUNNING)
+		return -ESRCH;
+
+	scoped_guard(rcu) {
+		read_lock(&tasklist_lock);
+		idr_for_each_entry(&pid_ns->idr, pid, nr) {
+			struct task_struct *task = pid_task(pid, PIDTYPE_TGID);
+			int err;
+
+			if (!task)
+				continue;
+
+			err = group_send_sig_info(sig, SEND_SIG_NOINFO, task,
+						  PIDTYPE_MAX);
+			if (!err) {
+				any_success = true;
+			} else if (err == -EPERM) {
+				any_perm = true;
+			} else if (err != -ESRCH && !any_other) {
+				any_other = true;
+				other_err = err;
+			}
+		}
+		read_unlock(&tasklist_lock);
+	}
+
+	if (any_success)
+		return 0;
+	if (any_other)
+		return other_err;
+	if (any_perm)
+		return -EPERM;
+	return -ESRCH;
+}
+
 static long userland_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct userland *userland = file->private_data;
-- 
2.47.3

