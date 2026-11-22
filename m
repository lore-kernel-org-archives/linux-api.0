Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310350;
	b=kiUf6fHAeNxcOxCCayMjLkugD8BAR/b8qNgneWOwWmspuVrvc4DQsFNaTZCJa+/BL6rs
	 lMB8IhKsjptVyGste0+cFZM3ihhe0iozkqbuY5O7TpiMmNrOTsdXuJk4g5A3vNbn3RcoD
	 0tCFql7k3Ry1E49OKMK4J007pptMxn5NHra5Rn3M27b4ydfAVyC481oPba5aCgX8tfTTu
	 C0YHTEVGuCWvkoihrd3W8vV8EibmE88IeC2PODINeEBnSXHuA9FKyQvDsFJiW2GecMcxi
	 ukj8Hrdwgteby1F2f3JruJkMsDgqrjjy1rl0RNmT+bXA/PsQY8LLj4R5sq80j2Weukg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=p6b5T+T94stNFNvyCUcSUzMMjJryI8LUZHJBCrPXRP0=;
	b=kt70UTRLVez3vAFY4LwmGOX2WOFd8hxSCLIR257FxLoPjXzYTQDlUOV+nPoLXtQ08mJL
	 haro0+FZVNY0Z6OcCsmuZPJ986lJqx1TwTedhOTCrFvatyIc874SRblX4ggmQk8WPhc47
	 pV0rMMh7HN1KPMc6l6s8iO9MKWU7xfLv0LyA8jS22YJwkr2gL4itjVHTNfGiW2YSTyZ+B
	 E6s/xLpvh0RvsEKzq3uNlHSnDmu6oWl9Kd3adJXGQIyVkyLyDQYVLjUu3lGGy7j/wYaY4
	 hpY+tNrWJXN/zdud11K7TsjzmAMSz5uXpGb0i5rdLLLf0lJy4njM64iVf9SLhUYdQvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZICPCjjt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E96D0606A330;
	Sun, 22 Nov 2026 01:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZICPCjjt
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F11F01F000C6;
	Sun, 22 Nov 2026 01:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310349;
	bh=p6b5T+T94stNFNvyCUcSUzMMjJryI8LUZHJBCrPXRP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZICPCjjtDIhyuST6MAGp0a28Xpc4OsFm4twyQqAAYCvdTwSK48Dy5BsQWivGRhXBQ
	 ADJpif3D7CA+HGImQXbdmdGoL15s3nbxJL3mtCxKZQpJ4OL8+U2eMMi7xjVLg72ysw
	 A3qUKxXLhRFSsbVpnv6mrFiir2vNmyrvhewNHug1XB1dJ6lI8H8PEPveLhilQ+OPHF
	 29symbd2cWCahQLAqu2fa+F0qAA00SwAvU069eeWiTDfyhtZ7udBCeS4OBYROoRk8N
	 DWXPJ8pw1nz2m06RBi9jX/uaC4n2Kn3Ufsu9fhHAzDydKkNFG6KLCBlMAsSQJrwt6v
	 38idYYno96dOA==
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
Subject: [RFC PATCH v6 13/26] userland: Add USERLAND_GET_NSFD ioctl
Date: Sun, 22 Nov 2026 03:17:56 +0200
Message-ID: <20261122011809.2667684-14-jarkko@kernel.org>
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
index d99b5d99fcc4..7b44f400dc23 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -16,6 +16,8 @@
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <linux/cgroup_namespace.h>
+#include <linux/ipc_namespace.h>
 #include <linux/mnt_namespace.h>
 #include <linux/nsproxy.h>
 #include <linux/ns_common.h>
@@ -24,6 +26,8 @@
 #include <linux/pid_namespace.h>
 #include <linux/time_namespace.h>
 #include <linux/user_namespace.h>
+#include <linux/uts_namespace.h>
+#include <net/net_namespace.h>
 #include <linux/idr.h>
 #include <uapi/linux/userland.h>
 
@@ -56,6 +60,76 @@ static __poll_t userland_poll(struct file *file, poll_table *wait)
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
@@ -78,6 +152,8 @@ static int userland_release(struct inode *inode, struct file *file)
 
 static const struct file_operations userland_fops = {
 	.poll		= userland_poll,
+	.unlocked_ioctl	= userland_ioctl,
+	.compat_ioctl	= userland_ioctl,
 	.release	= userland_release,
 };
 
-- 
2.47.3

