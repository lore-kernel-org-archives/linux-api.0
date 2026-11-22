Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310338;
	b=RE8KCpMPytj3c42dSppA9ZoIbBxgJK7p0Nt52QTzCrTPHgUXqQDNS7JIjdu5qWWrh6x6
	 guyamDKZWRVJJN+tGp3fglKqNqvFLT+2f5q1jUMQf3Ley7Tk6PYUzK1W64fziocgUMDh9
	 EoXKILOpwljIX69xE+Mu0yR5zfp4AAYE0S8bURiipsyLhdeYKD2c0PIAE1XG+sL/gk6Zw
	 4UZGScpI850SaGpyDT0QTOBhy/+iof5lX6ILRSvUpgYb6ha0LS0fR3a/ekE+9GFmbskps
	 fs/iyE68A5ZYAuuiF1sD6l4EP6BvnwOQgvEkpxmU1zYWvbARikNx3SUjE8KNckkKkLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=HKprgmkjSYGWcH+Y3MB3bIUsbQoCDkhJSH7Kfm9Ki7I=;
	b=2VGcPV9nl/x5FeA6Vb+P/gsBwxUPYxwAMsA1cuUdPMXHNo3K1dDWa5FucgQwtyouKwF4
	 ikfz6bwdY5o7N4FG8as3sZE8pON4al3HiKufBgEX7auBF11IYyxvgGRQ1HYFHAsgnoXe6
	 cL7m7EOkP1horgelPBR13AFbgFXZ6ALVI0cnP4cXrzN5Jz4wb6THvR30OYZuV1jrjfDc+
	 qJUID7R/kEvUvA49xxD8ruTRIg4AF/UUARAIn0arccB+WIZZsyfUYGM85P+WwqbRc5ECT
	 xCegKHMY2Q+22N0byskzgJwkUUFgulxQZdr8IM+4DnGJx7FsvNSiBVefETDMOBfRBFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="O0q/ePxI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 91D54606A32C;
	Sun, 22 Nov 2026 01:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O0q/ePxI
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7C9571F000E6;
	Sun, 22 Nov 2026 01:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310338;
	bh=HKprgmkjSYGWcH+Y3MB3bIUsbQoCDkhJSH7Kfm9Ki7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0q/ePxI+fYhjqjtfIYdA+w5/cm60BXmN0XB+eHr4C3tpnH705pFmKIVbP3zO+PW8
	 Rvqqfcf+fBo90Oi4MKO+9FnzHpyqYVIbeJ/Gu3mjitsTAoahzIvuV4e/6L5CA9lhCh
	 /55Rr3fewsAEHbkRRNWsAh/SgQLYrR+juURkrNwYtGXHZ6H7GKFQx3EFiuR95F4QRP
	 FlEks8ZGj3MB6PdvUncnQQT7B/CWUYPEfzXDFqW8+2UQDNgWkyTSU8FU9XSrkupN7b
	 GCAehQJj4KXuZw03OpSi8o3N6GU96qQvLP77XD8c48cqHCrteFmc3zc6j5pE0Bhcmp
	 vFNxlxAFHdNHw==
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
Subject: [RFC PATCH v6 10/26] userland: Add core infrastructure
Date: Sun, 22 Nov 2026 03:17:53 +0200
Message-ID: <20261122011809.2667684-11-jarkko@kernel.org>
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

Linux namespaces can be created and entered individually, but userspace
orchestrators lack a single control object that binds a full detached
namespace set and an init process lifecycle behind a pollable file
descriptor. Because this object manages process lifecycle, wait and
signal delivery, VFS mount delegation, and LSM state rather than
representing an nsfs namespace entity, model it as a distinct userland
abstraction.

Add struct userland, its lifecycle states, reference counting, uAPI
flags, and anonymous inode file operations under CONFIG_USERLAND. Drop
active and passive namespace references on final release, send SIGKILL
to the userland init thread group on close when USERLAND_KILL_ON_CLOSE
is set, and report EPOLLHUP from poll() once the userland reaches
USERLAND_DEAD.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/userland.h      | 52 +++++++++++++++++++++
 include/uapi/linux/userland.h | 25 ++++++++++
 init/Kconfig                  | 10 ++++
 kernel/Makefile               |  2 +
 kernel/userland.c             | 87 +++++++++++++++++++++++++++++++++++
 5 files changed, 176 insertions(+)
 create mode 100644 include/linux/userland.h
 create mode 100644 include/uapi/linux/userland.h
 create mode 100644 kernel/userland.c

diff --git a/include/linux/userland.h b/include/linux/userland.h
new file mode 100644
index 000000000000..fa8628e1b89c
--- /dev/null
+++ b/include/linux/userland.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2026 Opinsys Oy
+ */
+
+#ifndef _LINUX_USERLAND_H
+#define _LINUX_USERLAND_H
+
+#include <linux/refcount.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+
+struct file;
+struct nsproxy;
+struct pid;
+struct user_namespace;
+
+enum userland_state {
+	USERLAND_INIT		= 0,
+	USERLAND_FORKING	= 1,
+	USERLAND_RUNNING	= 2,
+	USERLAND_DEAD		= 3,
+};
+
+struct userland {
+	refcount_t		usage;
+	int			exit_code;
+	struct user_namespace	*user_ns;
+	struct nsproxy		*ns;
+	struct pid		*init_pid;
+	spinlock_t		lock;		/* Guards userland lifecycle state */
+	wait_queue_head_t	waitq;
+	unsigned int		flags;
+	enum userland_state	state;
+};
+
+#ifdef CONFIG_USERLAND
+void userland_put(struct userland *c);
+bool userland_is_file(struct file *file);
+#else
+static inline void userland_put(struct userland *c)
+{
+}
+
+static inline bool userland_is_file(struct file *file)
+{
+	return false;
+}
+#endif /* CONFIG_USERLAND */
+
+#endif /* _LINUX_USERLAND_H */
diff --git a/include/uapi/linux/userland.h b/include/uapi/linux/userland.h
new file mode 100644
index 000000000000..4a9031f81dda
--- /dev/null
+++ b/include/uapi/linux/userland.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2026 Opinsys Oy
+ */
+
+#ifndef _UAPI_LINUX_USERLAND_H
+#define _UAPI_LINUX_USERLAND_H
+
+/**
+ * enum userland_flags - Flags for userland_open()
+ * @USERLAND_KILL_ON_CLOSE: Send %SIGKILL to userland init on final fd release.
+ * @USERLAND_CLOSE_ON_EXEC: Set %O_CLOEXEC on the returned control fd.
+ * @USERLAND_ALL_FLAGS: Mask of all valid flags accepted by userland_open().
+ *
+ * Every userland created by userland_open() allocates a full set of
+ * detached namespaces owned by a fresh user namespace.
+ */
+enum userland_flags {
+	USERLAND_KILL_ON_CLOSE	= 0x00000001,
+	USERLAND_CLOSE_ON_EXEC	= 0x00000002,
+	USERLAND_ALL_FLAGS	= 0x00000003,
+};
+
+#endif /* _UAPI_LINUX_USERLAND_H */
diff --git a/init/Kconfig b/init/Kconfig
index c8a7cfa60a6e..0c5fada1ba88 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1283,6 +1283,16 @@ config NET_NS
 
 endif # NAMESPACES
 
+config USERLAND
+	bool "Userland support"
+	depends on NAMESPACES && USER_NS && PID_NS && UTS_NS && IPC_NS && NET_NS && CGROUPS
+	help
+	  Allow user space to open and manage isolated userlands and their init
+	  process lifecycle through an anonymous-inode control file descriptor
+	  via userland_open(), waitid(P_USERLAND), pidfd_send_signal(),
+	  USERLAND_GET_NSFD, USERLAND_SHARE_NSFD, FSCONFIG_SET_USERLAND, and
+	  clone3() with CLONE_INTO_USERLAND.
+
 config CHECKPOINT_RESTORE
 	bool "Checkpoint/restore support"
 	depends on PROC_FS
diff --git a/kernel/Makefile b/kernel/Makefile
index 4ff92e24680c..80eb26639776 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -152,6 +152,8 @@ KCOV_INSTRUMENT_kstack_erase.o := n
 
 obj-$(CONFIG_SCF_TORTURE_TEST) += scftorture.o
 
+obj-$(CONFIG_USERLAND) += userland.o
+
 $(obj)/configs.o: $(obj)/config_data.gz
 
 # .config is small, so it is compressed with gzip rather than the image compressor.
diff --git a/kernel/userland.c b/kernel/userland.c
new file mode 100644
index 000000000000..b339aa2103e1
--- /dev/null
+++ b/kernel/userland.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2026 Opinsys Oy
+ */
+
+#include <linux/poll.h>
+#include <linux/wait.h>
+#include <uapi/linux/wait.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/anon_inodes.h>
+#include <linux/userland.h>
+#include <linux/sched/signal.h>
+#include <linux/sched/task.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+#include <linux/mnt_namespace.h>
+#include <linux/nsproxy.h>
+#include <linux/ns_common.h>
+#include <linux/nsfs.h>
+#include <linux/pid.h>
+#include <linux/pid_namespace.h>
+#include <linux/time_namespace.h>
+#include <linux/user_namespace.h>
+#include <linux/idr.h>
+#include <uapi/linux/userland.h>
+
+void userland_put(struct userland *c)
+{
+	if (!c || !refcount_dec_and_test(&c->usage))
+		return;
+
+	if (c->ns)
+		put_nsproxy(c->ns);
+	if (c->init_pid)
+		put_pid(c->init_pid);
+	if (c->user_ns) {
+		ns_ref_active_put(c->user_ns);
+		put_user_ns(c->user_ns);
+	}
+	kfree(c);
+}
+
+static __poll_t userland_poll(struct file *file, poll_table *wait)
+{
+	struct userland *userland = file->private_data;
+	__poll_t mask = 0;
+
+	poll_wait(file, &userland->waitq, wait);
+
+	if (READ_ONCE(userland->state) == USERLAND_DEAD)
+		mask |= EPOLLHUP;
+
+	return mask;
+}
+
+static int userland_release(struct inode *inode, struct file *file)
+{
+	struct userland *userland = file->private_data;
+
+	if (userland->flags & USERLAND_KILL_ON_CLOSE) {
+		struct pid *pid = NULL;
+
+		scoped_guard(spinlock, &userland->lock) {
+			if (userland->state == USERLAND_RUNNING)
+				pid = get_pid(userland->init_pid);
+		}
+		if (pid) {
+			kill_pid(pid, SIGKILL, true);
+			put_pid(pid);
+		}
+	}
+	userland_put(userland);
+	return 0;
+}
+
+static const struct file_operations userland_fops = {
+	.poll		= userland_poll,
+	.release	= userland_release,
+};
+
+bool userland_is_file(struct file *file)
+{
+	return file->f_op == &userland_fops;
+}
-- 
2.47.3

