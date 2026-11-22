Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795376216;
	b=39yfll7evyfxc3YPkXVEJziW0QAlsf2+vF7x0GeINOeSr+SF0kLiNhrsVU4icXye29yv
	 FPXPcQdW+aGAjNhe+larNzf3JRwDiPEdGTGwU0xH6ijmtAv0Y93LH95S6w2QbzabNBSm3
	 ledpipdFURWN1tOxB1kOwV4ZNPheZJtTSwDVOTso35vfi5adYCk2PdNqVbI1VFeQ5Xw0l
	 PRBjnNn7bicTSI2Lw7SQpWOjlCzLkirH4egSwZO8a5U9xAZy6bh6XtQYwruEV4rI5/wu5
	 lC6dO/Se341hIuEcW+t5ojOS5kJcgV0NcSmw5vntD5Tse21Ca22e8XJOEp+vY6S+ulw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795376216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=M3T9ruqYmyUMm2PturUvOibjyAbGjGhILSaT845gaFc=;
	b=QhjLdOACkCzlojV1Cv/1Eqbs8z2yezPoS08jGLf1L7xl1kbfjDORZYosdufkJZDaleWt
	 fJIBwJ7DEVei1wPZTFrjO4etpmEtwA+K9Jxn83R6nCrdJGAsNwMEpgTVSf5oyc8CnOyPy
	 qgYZu/GySD8pvfugCfnAwwWxStHwU8gLVGxNaYpTXmo7Z2QZJDCBFZB1mwK3LYNvDs1gt
	 wd1C6GmN3h46YjeACPbbclibzYNmzNY3qhcNgTjDPoaITZZac5g1FN8NjSyfsdIEoZxHX
	 e55G9chqHwcLP6yG8UiM2DH9X/oURFsHLmT8D3Hgts6HqcdPZ0MAoDqBZRfRRajXJAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hLXGB7rR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C979D606A31E;
	Sun, 22 Nov 2026 19:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hLXGB7rR
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C66B41F000D3;
	Sun, 22 Nov 2026 19:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376216;
	bh=M3T9ruqYmyUMm2PturUvOibjyAbGjGhILSaT845gaFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hLXGB7rRUoPcsnXokx7eTA9UTxhJink/6OLXJGpNkEFY2vQ5ps/e+pGglAWeRcaZy
	 D69TpTHUFZDEOPfMLaTzDAccup185NJA00nIa8btD/j/K/zihji2qj/Vqjt2BQKDi9
	 FYCn+JcNcPp3veWxbC/LRh3llVICiuCsHqaWjqx19tfPo+rGSqglic/fcJ9MQdqKCF
	 FF4p0vGPssWSmi+bP5G6CU0qfVbppBr8xd1T9UblfWxxS24gRoKkiK1tirJ+HWETmh
	 8sF7LOOQkYd4jwAWNIzSKz7TKlJ+RbYJWtKR2bRLtgyX8zh3eaEwpQx5q0u0aHO/vr
	 FiH7u4+X8bHMw==
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
Subject: [RFC PATCH v7 14/26] userland: Add USERLAND_SHARE_NSFD ioctl
Date: Sun, 22 Nov 2026 21:35:27 +0200
Message-ID: <20261122193539.3334213-15-jarkko@kernel.org>
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

userland_open() isolates every namespace by default rather than relying
on unshare() deny-listing, which prevents workloads such as
host-networked sandboxes or sidecars sharing a network or IPC namespace
from opting into specific existing namespaces.

Add the build-phase USERLAND_SHARE_NSFD ioctl to replace the userland's
cgroup, IPC, UTS, network, or time namespace with a supplied nsfs file
descriptor in-place under userland->lock while the userland is still in
USERLAND_INIT, rejecting calls with -EBUSY once CLONE_INTO_USERLAND
begins. Require CAP_SYS_ADMIN in the userland's user namespace, and
require CAP_SYS_ADMIN in the target namespace's owning user namespace
when the caller is not already a member of that namespace.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/uapi/linux/userland.h | 14 ++++++
 kernel/userland.c             | 90 +++++++++++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)

diff --git a/include/uapi/linux/userland.h b/include/uapi/linux/userland.h
index e81a06d6e9eb..addb84e996f5 100644
--- a/include/uapi/linux/userland.h
+++ b/include/uapi/linux/userland.h
@@ -41,4 +41,18 @@ enum userland_flags {
  */
 #define USERLAND_GET_NSFD	_IO(USERLAND_IOCTL_MAGIC, 0x01)
 
+/**
+ * DOC: USERLAND_SHARE_NSFD
+ *
+ * ``ioctl(userland_fd, USERLAND_SHARE_NSFD, ns_fd)`` replaces the corresponding
+ * member namespace of ``userland_fd`` with ``ns_fd`` (``CLONE_NEWCGROUP``,
+ * ``CLONE_NEWIPC``, ``CLONE_NEWUTS``, ``CLONE_NEWNET``, or ``CLONE_NEWTIME``)
+ * while ``userland_fd`` is in ``USERLAND_INIT``.
+ *
+ * Requires ``CAP_SYS_ADMIN`` in the userland's user namespace, plus
+ * ``CAP_SYS_ADMIN`` in ``ns_fd``'s owning user namespace when the caller is
+ * not already a member of ``ns_fd``.
+ */
+#define USERLAND_SHARE_NSFD	_IO(USERLAND_IOCTL_MAGIC, 0x02)
+
 #endif /* _UAPI_LINUX_USERLAND_H */
diff --git a/kernel/userland.c b/kernel/userland.c
index fd5f67c0245e..279b92e7b7f8 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -31,6 +31,8 @@
 #include <linux/nsfs.h>
 #include <linux/pid.h>
 #include <linux/pid_namespace.h>
+#include <linux/proc_fs.h>
+#include <linux/proc_ns.h>
 #include <linux/time_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/uts_namespace.h>
@@ -125,6 +127,92 @@ static long userland_get_nsfd(struct userland *userland, unsigned long nstype)
 	return open_namespace(ns);
 }
 
+static long userland_share_nsfd(struct userland *c, unsigned long arg)
+{
+	struct ns_common *old_time_children = NULL;
+	struct ns_common *old_ns = NULL;
+	struct ns_common *ns;
+
+	if (arg > INT_MAX)
+		return -EBADF;
+
+	CLASS(fd, f)((int)arg);
+	if (fd_empty(f))
+		return -EBADF;
+	if (!proc_ns_file(fd_file(f)))
+		return -EINVAL;
+
+	ns = get_proc_ns(file_inode(fd_file(f)));
+	switch (ns->ns_type) {
+	case CLONE_NEWCGROUP:
+	case CLONE_NEWIPC:
+	case CLONE_NEWUTS:
+	case CLONE_NEWNET:
+		break;
+	case CLONE_NEWTIME:
+		if (!IS_ENABLED(CONFIG_TIME_NS))
+			return -EOPNOTSUPP;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (!ns_capable(c->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+	if (!is_current_namespace(ns) &&
+	    !ns_capable(ns->ops->owner(ns), CAP_SYS_ADMIN))
+		return -EPERM;
+
+	scoped_guard(spinlock, &c->lock) {
+		if (c->state != USERLAND_INIT)
+			return -EBUSY;
+
+		__ns_ref_inc(ns);
+		__ns_ref_active_get(ns);
+
+		switch (ns->ns_type) {
+		case CLONE_NEWCGROUP:
+			old_ns = to_ns_common(c->ns->cgroup_ns);
+			c->ns->cgroup_ns = to_cg_ns(ns);
+			break;
+		case CLONE_NEWIPC:
+			old_ns = to_ns_common(c->ns->ipc_ns);
+			c->ns->ipc_ns = to_ipc_ns(ns);
+			break;
+		case CLONE_NEWUTS:
+			old_ns = to_ns_common(c->ns->uts_ns);
+			c->ns->uts_ns = to_uts_ns(ns);
+			break;
+		case CLONE_NEWNET:
+			old_ns = to_ns_common(c->ns->net_ns);
+			c->ns->net_ns = to_net_ns(ns);
+			break;
+#ifdef CONFIG_TIME_NS
+		case CLONE_NEWTIME:
+			__ns_ref_inc(ns);
+			__ns_ref_active_get(ns);
+			old_ns = to_ns_common(c->ns->time_ns);
+			old_time_children =
+				to_ns_common(c->ns->time_ns_for_children);
+			c->ns->time_ns = to_time_ns(ns);
+			c->ns->time_ns_for_children = to_time_ns(ns);
+			break;
+#endif
+		default:
+			WARN_ON_ONCE(1);
+			break;
+		}
+	}
+
+	__ns_ref_active_put(old_ns);
+	old_ns->ops->put(old_ns);
+	if (old_time_children) {
+		__ns_ref_active_put(old_time_children);
+		old_time_children->ops->put(old_time_children);
+	}
+	return 0;
+}
+
 static long userland_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct userland *userland = file->private_data;
@@ -132,6 +220,8 @@ static long userland_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	switch (cmd) {
 	case USERLAND_GET_NSFD:
 		return userland_get_nsfd(userland, arg);
+	case USERLAND_SHARE_NSFD:
+		return userland_share_nsfd(userland, arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
-- 
2.47.3

