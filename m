Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310354;
	b=BMSc4Ie4i7A2EXMqXDQhR0LHx1HHO19SVu+esP8Bl3it/I7GNbdVpDGZmLPwh+6Chf7n
	 3Ao3Dtx08cLMW9G4t4QCVsWnzwZpsFtyBJWlmeYeyJrSgCoMaQ54mEYJNgoy3WHRTbbb6
	 wUkDnRsAGxRJ7InwLZyaPqtoRbOASX5rAW8V6yo87M6C1rp4av8Tz2xTi6tThP7nmjAuV
	 +KPJkew0wIQJAB/g8AsWJNxLUnmfl8ko3grK3H7JoX+BeyV/wjxxvMUT3JC/JZFBC5nKe
	 Gb5QqpOBymIg2vOYpntAO3px2bwm8Dq0PbhbeGPumQxb2tBDJR658jlklJWPwJ8UCxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=qsah9M7foXNK9QvRUXT+CrvXBmg+yydBay4Gf38+YR0=;
	b=2wdRcsH0CoKv8PCacN7yuYVx5asgUJI89iu4DksDInsbZ0+ynSwnuUmUNiY/PZx75HFU
	 HAgyAgtzCPtr9/zoFHhN0Hy+dKzkdld2I/C8sc0XZsFsrXPB5Jtjlw9/oFtzDjmsZwQtT
	 3VV0brXuOc0Es7HIT2pSuv3vi/99G7hXvNtoGs7T9elIQdjMBys/o6rYTTyxDa37778Mv
	 /iEX2d0C8h3/LwRoY9r74FTU+Pz6duk0T/5sJVcT9g9rRoT+FkxcGez0DVUtEweqoMi1b
	 +xRHmoaPy01uaJnY6Wl0fHn3ppIUb99lJTj0Ug61wo1OHmbUwEv7G9D2ue91sYdW1Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="OKCYL9/h";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3BF0A606A33B;
	Sun, 22 Nov 2026 01:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OKCYL9/h
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 207481F000C4;
	Sun, 22 Nov 2026 01:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310353;
	bh=qsah9M7foXNK9QvRUXT+CrvXBmg+yydBay4Gf38+YR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OKCYL9/hTzizf7XZIcDjFqE8r5O8mbskYQYtjjuu5GOLp14M71COOK3RHwALYj0zC
	 2RcfvSObeAms8ncoscoqC2z3l/cX6+XCThwhswtfIakGCjHB9B/l4tOAbOJVSd/9Wy
	 GmWvSV+SBiY2b0lnG/GquMH+L79c2Ix9ouvmPuWjh82MtuPSI5HuI79hiWAlfFS5aa
	 YkPBvWYNwDT3bVKWsdM/Ne051P4jMdIUmIHa8yYxCP8FW6+KH9yHXwlOg9nnCJvuUo
	 rMKtkpeWfKdn+0VoaIgnRNPBBMnZz9OkDB9y5s62sj29tnDZHgFB1XPzM8LWaEmcRu
	 oChN4176hN/8Q==
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
Subject: [RFC PATCH v6 14/26] userland: Add USERLAND_SHARE_NSFD ioctl
Date: Sun, 22 Nov 2026 03:17:57 +0200
Message-ID: <20261122011809.2667684-15-jarkko@kernel.org>
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
 kernel/userland.c             | 92 +++++++++++++++++++++++++++++++++++
 2 files changed, 106 insertions(+)

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
index 7b44f400dc23..efac9e4f2fa5 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -24,6 +24,8 @@
 #include <linux/nsfs.h>
 #include <linux/pid.h>
 #include <linux/pid_namespace.h>
+#include <linux/proc_fs.h>
+#include <linux/proc_ns.h>
 #include <linux/time_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/uts_namespace.h>
@@ -118,6 +120,94 @@ static long userland_get_nsfd(struct userland *userland, unsigned long nstype)
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
+	if (unlikely(!current->nsproxy))
+		return -EOPNOTSUPP;
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
@@ -125,6 +215,8 @@ static long userland_ioctl(struct file *file, unsigned int cmd, unsigned long ar
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

