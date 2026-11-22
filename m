Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795376225;
	b=ke3/25PRNRG7b9KDfHdudwdWsGWnr51R4bXbSb0lNLSsYUhu5IqSGlRh/e2uS5w+TYX6
	 YwgQf3uvgP6ijtLmYuRXHzAjTUDelCnZHbrCf4ZkUq6dpAubYtYN9YVmbLvYWIQq9q/n9
	 q4Alv8T8vtmWT41arG1VWc085M4sklDJTvtCpICGHPrN1xgxqtvdsnbzZ+R/HhhH1i4K4
	 GTPFack3FdFSuGognzWrDJYp6PNmH5y6OVN/0FZ7eABQWZ81dcGmb/N/JMwjEMF7oxwpY
	 gZH+egptmNnEI2fwbDUxP3/jDbiuS3HQjgEy26ILoj0FloSbGahZjIlNiHiYbT9PeoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795376225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=aVGgI7D53IZyEOdiIQgJZT0cYrc34vgpwt54f5ogQLw=;
	b=onzSBtNyrh+fZmFSYClCNd0GaFNlopQLIYH4KCR3dASre+D2KhLNgzv7yrgqsV/vjLFu
	 SrGrE9fKRVp1r3vhXML/G2G5L1TvU9qsbf1cfarJhykr5iuO3mG8E8HRmBz/LcoNt9Flb
	 MuISUCNh7gOVXQme2DdKyydqocKHlPurkOSFmQLWI0OmiDkSXdInsuUtmxF2Gx7HrIpKO
	 P0nCV9vyHQEWJ6GVK1yJC0peUhTkXYFi3q5Q4o+4h+MLtzfEgeMEtVcTC7q8mnDdo9bAr
	 KRR8n9Sqxdt12Reh6ZPWWFeXooZkCnffw+XfsGJLN0lysuxnEnJsqtdHXOFXA1eo3dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TxeiH5mi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id CD76A606A31D;
	Sun, 22 Nov 2026 19:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TxeiH5mi
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A5F861F000E0;
	Sun, 22 Nov 2026 19:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376225;
	bh=aVGgI7D53IZyEOdiIQgJZT0cYrc34vgpwt54f5ogQLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TxeiH5migMxtxLZVPutyjQ6/J7QKqoSFH/e1HcOJIJSoDF1AA8CxhtTITwMigbaeb
	 I9yS9g21CpCn5IIvX186gax7JrXaTQBSO3ytBizEP9b1mmNiOvd6LF7PXsEu+Pc1b8
	 HUjIkMPk0nbBRdDYSnLBo07GsUKETFbxFuQLsLkf9MvtM04bWUSk8OXqQVBjxoBPds
	 ncy7NCV3vxBxbV21mOz7yth9bNwCBbMdoXiISOaGDkM/Dj+IxpDGfzNucXbWlBzCHT
	 jJAjknZhWjnuCc2ZXFoM2hJr9/b8Jpm0XKBGdFCBO9W5/nM4ALcdEReyW3sCbliMy6
	 L0ZYYKufVT4QA==
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
Subject: [RFC PATCH v7 16/26] signal: Support userland fds in pidfd_send_signal()
Date: Sun, 22 Nov 2026 21:35:29 +0200
Message-ID: <20261122193539.3334213-17-jarkko@kernel.org>
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

Signaling every process inside a userland from userspace via /proc is
racy against concurrent fork() calls.

Teach pidfd_send_signal() to dispatch userland file descriptors to
userland_send_signal() when info is NULL and flags is 0. Require an
ancestor active PID namespace, walk the userland's PID namespace IDR
under tasklist_lock, and deliver a validated signal once to each thread
group including in-flight forks by member processes, aggregating
per-process delivery results.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/userland.h | 10 +++++++
 kernel/signal.c          |  4 +++
 kernel/userland.c        | 59 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+)

diff --git a/include/linux/userland.h b/include/linux/userland.h
index 16988e10f623..da0978db54dd 100644
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
@@ -77,6 +78,8 @@ void userland_copy(struct task_struct *tsk, struct pid *pid,
 void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk);
 long userland_waitid(int upid, struct waitid_info *infop, int options,
 		     struct rusage *ru);
+int userland_send_signal(struct file *file, int sig,
+			 struct siginfo __user *info, unsigned int flags);
 #else
 static inline void userland_put(struct userland *c)
 {
@@ -102,6 +105,13 @@ static inline long userland_waitid(int upid, struct waitid_info *infop,
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
index 3ded663b71af..f449e2ff9152 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -296,6 +296,65 @@ long userland_waitid(int upid, struct waitid_info *infop, int options,
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

