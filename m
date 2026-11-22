Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795376212;
	b=IUFmoby1ny62tSWX4FtpXbk0Vrir+nIYGsVypAJ/Zvka5mXqriNwTksJP9BNj5uM73/m
	 AeTTdrAtX0gLCC5VprPBND8xIQwWXhqc7AW2hNFseoiv6H9bCP71LDV3pFJNrZW+qDJZY
	 wrZ9NTfwCpvNRQcZ5QwCeamYbKlfpoxiLq7qR+i0huWYzu45mXnrnfY8Ql+tfpT7QzEFi
	 VNsOfQ1WNPyZUn/uMxi9RR1iOU/3E51NcVLKZRg41m9HASD54LCTw1mmYFweFadM/L719
	 /TAOw87r19UgwXFdB0SxX2p5eNjzF1PRb17xDSsaQIssIzqnkVMaLwYK/fwGlxrzwjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795376212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=QgUTYSoeBbicoM/Ctv8wuw6txQmYFirn0xuo3QUM9bE=;
	b=GEXCoSzFyjdjKJfPpitb6QYx//nh2cTG5pslTcce+8Zh0S2WJoYxSsGc7ZkfE2oGYQku
	 jr8nMNh0V8mZeHp/6Y4UXhY7ttQCqNKdP4S65TeA8h7mPlbbmJXO33mXUKoGowgGEr3c1
	 5fVu+JDc1+Tw4aV1h4CJTwl5wianwW3PpSOeMIAFPaNrxHaSqgRsemyzN2j5DC0VBDqrw
	 w+5VOoUKF2zso0AyQqgrwqxJ/7UWX10yPnkrvaBUQnUasiS3g17y/5kdNVB8m2jZPz6Hr
	 PRVbIhJlNd9vJhU45SyeOiWH9YkdCSPTQrivznMd1aKN1HVeTQwG07KCJXmX76HLFvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h++5CFR1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id BC3B9606A690;
	Sun, 22 Nov 2026 19:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h++5CFR1
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 96DEE1F000E6;
	Sun, 22 Nov 2026 19:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376212;
	bh=QgUTYSoeBbicoM/Ctv8wuw6txQmYFirn0xuo3QUM9bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h++5CFR1P60aN6bCiiNMePpNEGsSZ4HlKZo8lWB6f4wdhTNz6/tSkMTg8xEpHbRxI
	 GlwySIf772FfNejL8QOE7DS9Aizp0uVQ7OkmwxoH40uYofSQqCzfMJ58pVkImG6RIZ
	 K4AMH4F5lVhyQeJnnZn7QVG98lo9L40YECd9yjtIprIs1WGapBRgEZTAUwpA1D/vse
	 9AnVSn/pA6MDVVk9wdaaUy3HQ3N4ZDFectxotNoTvOE88ZsWBmeAVyX1TQJ6xY8ovy
	 Svslni2eYDTNSN8Tttx+qsHPiF94D8NrmsIIFhHGYdKRWN+DSQF0ejgfAakQavvOKS
	 d7uWpKN6e7POQ==
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
Subject: [RFC PATCH v7 13/26] userland: Add USERLAND_GET_NSFD ioctl
Date: Sun, 22 Nov 2026 21:35:26 +0200
Message-ID: <20261122193539.3334213-14-jarkko@kernel.org>
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

Standalone namespace operations such as userns_set_idmap() and
move_mount(..., MOVE_MOUNT_T_MNTNS) operate on nsfs file descriptors,
requiring a way to obtain member namespace fds from a userland file
descriptor before any process has entered it.

Add the USERLAND_GET_NSFD ioctl to open an O_CLOEXEC nsfs file
descriptor for a requested member namespace when the caller holds
CAP_SYS_ADMIN in the userland's user namespace, additionally requiring
an ancestor active PID namespace and a running init process for
CLONE_NEWPID.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/internal.h                 |  1 -
 include/linux/nsfs.h          |  1 +
 include/uapi/linux/userland.h | 19 +++++++++
 kernel/userland.c             | 76 +++++++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/fs/internal.h b/fs/internal.h
index 3f2fbac40f8e..ee3f796241ac 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -250,7 +250,6 @@ extern void mnt_pin_kill(struct mount *m);
  * fs/nsfs.c
  */
 extern const struct dentry_operations ns_dentry_operations;
-int open_namespace(struct ns_common *ns);
 struct file *open_namespace_file(struct ns_common *ns);
 
 /*
diff --git a/include/linux/nsfs.h b/include/linux/nsfs.h
index 731b67fc2fec..40912c1eb5ff 100644
--- a/include/linux/nsfs.h
+++ b/include/linux/nsfs.h
@@ -23,6 +23,7 @@ bool ns_match(const struct ns_common *ns, dev_t dev, ino_t ino);
 int ns_get_name(char *buf, size_t size, struct task_struct *task,
 			const struct proc_ns_operations *ns_ops);
 void nsfs_init(void);
+int open_namespace(struct ns_common *ns);
 
 #define __current_namespace_from_type(__ns)				\
 	_Generic((__ns),						\
diff --git a/include/uapi/linux/userland.h b/include/uapi/linux/userland.h
index 4a9031f81dda..e81a06d6e9eb 100644
--- a/include/uapi/linux/userland.h
+++ b/include/uapi/linux/userland.h
@@ -7,6 +7,8 @@
 #ifndef _UAPI_LINUX_USERLAND_H
 #define _UAPI_LINUX_USERLAND_H
 
+#include <linux/ioctl.h>
+
 /**
  * enum userland_flags - Flags for userland_open()
  * @USERLAND_KILL_ON_CLOSE: Send %SIGKILL to userland init on final fd release.
@@ -22,4 +24,21 @@ enum userland_flags {
 	USERLAND_ALL_FLAGS	= 0x00000003,
 };
 
+#define USERLAND_IOCTL_MAGIC	0xB9
+
+/**
+ * DOC: USERLAND_GET_NSFD
+ *
+ * ``ioctl(userland_fd, USERLAND_GET_NSFD, nstype)`` opens an ``nsfs`` file
+ * descriptor (with ``O_CLOEXEC``) for the member namespace identified by
+ * ``nstype`` (one of ``CLONE_NEWNS``, ``CLONE_NEWCGROUP``,
+ * ``CLONE_NEWUTS``, ``CLONE_NEWIPC``, ``CLONE_NEWUSER``, ``CLONE_NEWPID``,
+ * ``CLONE_NEWNET``, or ``CLONE_NEWTIME``).
+ *
+ * Requires ``CAP_SYS_ADMIN`` in the userland's user namespace.
+ * Opening ``CLONE_NEWPID`` additionally requires running in an ancestor
+ * active PID namespace and that userland init is running.
+ */
+#define USERLAND_GET_NSFD	_IO(USERLAND_IOCTL_MAGIC, 0x01)
+
 #endif /* _UAPI_LINUX_USERLAND_H */
diff --git a/kernel/userland.c b/kernel/userland.c
index 472d75423b95..fd5f67c0245e 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -23,6 +23,8 @@
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <linux/cgroup_namespace.h>
+#include <linux/ipc_namespace.h>
 #include <linux/mnt_namespace.h>
 #include <linux/nsproxy.h>
 #include <linux/ns_common.h>
@@ -31,6 +33,8 @@
 #include <linux/pid_namespace.h>
 #include <linux/time_namespace.h>
 #include <linux/user_namespace.h>
+#include <linux/uts_namespace.h>
+#include <net/net_namespace.h>
 #include <linux/idr.h>
 #include <uapi/linux/userland.h>
 
@@ -63,6 +67,76 @@ static __poll_t userland_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
+static long userland_get_nsfd(struct userland *userland, unsigned long nstype)
+{
+	struct ns_common *ns = NULL;
+
+	if (nstype > UINT_MAX)
+		return -EINVAL;
+	if (!ns_capable(userland->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (nstype == CLONE_NEWPID) {
+		if (!pidns_is_ancestor(userland->ns->pid_ns_for_children,
+				       task_active_pid_ns(current)))
+			return -EXDEV;
+		if (READ_ONCE(userland->state) != USERLAND_RUNNING)
+			return -ESRCH;
+	}
+
+	scoped_guard(spinlock, &userland->lock) {
+		switch (nstype) {
+		case CLONE_NEWNS:
+			ns = from_mnt_ns(userland->ns->mnt_ns);
+			break;
+		case CLONE_NEWCGROUP:
+			ns = to_ns_common(userland->ns->cgroup_ns);
+			break;
+		case CLONE_NEWUTS:
+			ns = to_ns_common(userland->ns->uts_ns);
+			break;
+		case CLONE_NEWIPC:
+			ns = to_ns_common(userland->ns->ipc_ns);
+			break;
+		case CLONE_NEWUSER:
+			ns = to_ns_common(userland->user_ns);
+			break;
+		case CLONE_NEWPID:
+			ns = to_ns_common(userland->ns->pid_ns_for_children);
+			break;
+		case CLONE_NEWNET:
+			ns = to_ns_common(userland->ns->net_ns);
+			break;
+		case CLONE_NEWTIME:
+#ifdef CONFIG_TIME_NS
+			ns = to_ns_common(userland->ns->time_ns);
+			break;
+#else
+			return -EOPNOTSUPP;
+#endif
+		default:
+			return -EINVAL;
+		}
+
+		if (!__ns_ref_get(ns))
+			return -ESRCH;
+	}
+
+	return open_namespace(ns);
+}
+
+static long userland_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct userland *userland = file->private_data;
+
+	switch (cmd) {
+	case USERLAND_GET_NSFD:
+		return userland_get_nsfd(userland, arg);
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
 static int userland_release(struct inode *inode, struct file *file)
 {
 	struct userland *userland = file->private_data;
@@ -85,6 +159,8 @@ static int userland_release(struct inode *inode, struct file *file)
 
 static const struct file_operations userland_fops = {
 	.poll		= userland_poll,
+	.unlocked_ioctl	= userland_ioctl,
+	.compat_ioctl	= userland_ioctl,
 	.release	= userland_release,
 };
 
-- 
2.47.3

