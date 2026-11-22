Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795376221;
	b=JSf1EtqC1e0eVe7Rw3wB++6gR/brTlCacyb587X1CYF+lsHXZ98UxPdKxqVT7PA0skJa
	 /d7y2k9UEECSHaBQZSTd9yGR9JR2OMrt3BXBQGWGHvMQNAAe0mmMKT4tFJVTloBC1Po2T
	 +H4yHKIbB8R6TpcW4odNdWohf69CqYX15pVsTTu64kpNEW+PH0DohbTOqI+T976e+YgGo
	 W/PRpKEnjR9u3UFwTZ+gum+MTaUUNxylo6Kwf5EmSzfifKthZ5E1DK24cMYsL/jLQIfFn
	 La4GuFVVVUsC1yu7RgFaXNHOrkn6zyZitvNWLr/xd5tMCQeCP2K3VY5IRsd44n7D2+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795376221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=XwK0kBI5FPDe2Km5ydmIo1Yx+Gsu/7X07W9R+yp2Gk4=;
	b=Il3g8V65l3DEhUgckY3b+m/pul35xzFKiIuNEG5DnO/fAkpW71fkKux+i5No3J81+B26
	 74KqM9SQGBnthvu7rgp9MqYJ09s+4DYxkqIQ65mHFLhJIvFtFkTbfCMM3V720pYkuMOrX
	 zhy33gC+75gPAVnFJEpv2Fx+i+E2tbI/h3YiuoE79KzfOf4i4MEkM3xAFCIYkHzVrtQKi
	 dzVXDgjqrFzS5V6Bdv1IaIoCKDnp80wqTgbUAYkURnhix7yLsZIZ44Yy5Ik6UIu7kJ0Gk
	 7y1SOhOkAEcYTc4buC2RXGLPWvKDYS++c1AZ0pCmSmvOCNnVQoNVtmr43ndHpkdEpCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gF2J+16U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 8F21D606A684;
	Sun, 22 Nov 2026 19:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gF2J+16U
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6000C1F000EE;
	Sun, 22 Nov 2026 19:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376221;
	bh=XwK0kBI5FPDe2Km5ydmIo1Yx+Gsu/7X07W9R+yp2Gk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gF2J+16USDEJ/HoS3CxmYfyZ3+XohOPn6KBqcnalnjfeoKgwCJ0mdeSq4XUpsqVQv
	 JHJwDi2vYYOZYXQ5K35Vg+mX/dPk8YwKeYtIHxhHJuVr23qNc45t5yuSN/jf8R98j7
	 Uv3upEuEiMrvoHiXxYP0BeSk2uk3iKHBclKHFP6mXU74k7521tf1lt9AogXlnGnRmz
	 +U+krMJNlW4DxTf2DQq/R3PR6NLvMwealjlxKekHwWMIr7Wew4cPJEPxHYUgEZSsAH
	 29wXcNeZl25oN/k1s/8woNjUV4AyajyX/1wY5j7GaaYiEwrZGSxzwE29Oj634xjyak
	 thRb7amQqFHBw==
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
Subject: [RFC PATCH v7 15/26] exit: Support P_USERLAND in waitid()
Date: Sun, 22 Nov 2026 21:35:28 +0200
Message-ID: <20261122193539.3334213-16-jarkko@kernel.org>
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
 kernel/userland.c         | 83 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 98 insertions(+)

diff --git a/include/linux/userland.h b/include/linux/userland.h
index a92709957529..16988e10f623 100644
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
 
 /**
  * enum userland_state - Userland lifecycle states
@@ -73,6 +75,8 @@ bool userland_is_file(struct file *file);
 void userland_copy(struct task_struct *tsk, struct pid *pid,
 		   struct userland *userland);
 void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk);
+long userland_waitid(int upid, struct waitid_info *infop, int options,
+		     struct rusage *ru);
 #else
 static inline void userland_put(struct userland *c)
 {
@@ -92,6 +96,12 @@ static inline void userland_exit(struct pid_namespace *pid_ns,
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
index 279b92e7b7f8..3ded663b71af 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -15,6 +15,7 @@
 #include <linux/wait.h>
 #include <uapi/linux/wait.h>
 #include <linux/file.h>
+#include <linux/freezer.h>
 #include <linux/fs.h>
 #include <linux/anon_inodes.h>
 #include <linux/userland.h>
@@ -40,6 +41,8 @@
 #include <linux/idr.h>
 #include <uapi/linux/userland.h>
 
+#include "exit.h"
+
 void userland_put(struct userland *c)
 {
 	if (!c || !refcount_dec_and_test(&c->usage))
@@ -213,6 +216,86 @@ static long userland_share_nsfd(struct userland *c, unsigned long arg)
 	return 0;
 }
 
+/**
+ * DOC: P_USERLAND
+ *
+ * ``waitid(P_USERLAND, userland_fd, infop, options, NULL)`` waits freezably until
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
+	for (;;) {
+		enum userland_state state;
+
+		scoped_guard(spinlock, &userland->lock) {
+			state = userland->state;
+			if (state == USERLAND_INIT)
+				return -ECHILD;
+			if (state == USERLAND_DEAD) {
+				ret = pid_nr_ns(userland->init_pid, pid_ns);
+				if (ret <= 0)
+					return -ECHILD;
+				status = userland->exit_code;
+				uid = userland->init_uid;
+			}
+		}
+		if (state == USERLAND_DEAD)
+			break;
+		if (nonblock)
+			return (options & WNOHANG) ? 0 : -EAGAIN;
+
+		ret = wait_event_freezable(userland->waitq,
+					   READ_ONCE(userland->state) ==
+					   USERLAND_DEAD ||
+					   READ_ONCE(userland->state) ==
+					   USERLAND_INIT);
+		if (ret)
+			return ret;
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

