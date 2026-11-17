Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794957258;
	b=5PfxyajuOLPywr5ZaFBN4dchhVgAPjgfhfo+9vQDA80grZSF0g7Jar8Hpi3Z4zlOYVet
	 hfSB582/moBNpcbOqRLpk5MFayuAENm49QGEnM8qOyfZpR6uEpYjTuBtxzdTr2+8GGz0L
	 H5f805NfdYpYAOGqmBWqgur8p7WZXFvbl5VII3QvfZtFWdPq5E3qsQyBLOIRE0lhOV2o8
	 UiMhfTSYDafDJZDViQefGdgbDxS1eh8ByXI4zpOSQHE0+YoHgOdlLbYPbsT+CKFSvN84Z
	 JEEm3m6b2CA4yGAAEYRGcI8RbBG97AEk7JpycNgsIKJaTYV3pC1Hj8OjqvFki+T7Vuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794957258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=0bBz9NFzTwB4gk5OkP+idn1ksFpESN+Xj8dQdU7cjCk=;
	b=1WhEWJWHBJ7ImKlXkiYpzXLDZOaIUmSohwDUhMoi9z9p/8pSE3rqAMFOwJ2fi0t3dWvD
	 1bn7RRO+iES53HhFDW/gmX02naEMf3OaOWKr7uFGrWgdzlTzwCDhIdL50ycegW++ROtmJ
	 aoHMIjWIVX84Rc3YmmVfLnaOFzQgaZQgequQNqHlcRNMaGwyVOHOpc9s5W4uDa1GemGzj
	 OzXVKmCGk4N87L0weKuBBqtLOrDkqiwjKLaV++EMj4SMwJiAalEgVYqokOiuHkDyj6dAR
	 AkAFSgGU6rUSOfzz5IJN4yVg86nZqDoTd9jw9HsEcOcZOxpYWqtTbZ6JuqzkTTVZQLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lJjNi4q4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id AE3DB606A887;
	Tue, 17 Nov 2026 23:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lJjNi4q4
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DE7CA1F000CA;
	Tue, 17 Nov 2026 23:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957258;
	bh=0bBz9NFzTwB4gk5OkP+idn1ksFpESN+Xj8dQdU7cjCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJjNi4q4D0nA+9QKNBpfJf+7F80vYEvWgcKV86Bfizu/iwDbOUXW5u3xk3iUrT7aX
	 S3dLJjdnLZlj/F8SXKv71H2RzNgpbgCVk9vVN+B/MgkVkW1hp7CWCMaaOfhySj2Pqc
	 JH9s7GDXcsDJ1C8kP2OYyfRtOBWwvR8gmbQj9+bhhkDFiAQfkB4sg97lyOT/S2p2RR
	 oVAjudKJ0foItXlAlZbLBgI8vL6lWBRtRqWDrjLTjjs5QSLl3+D5t1L8hHC0pijUBU
	 aXk5QNC85uYmD1NREr+mbDnz8ff+N7TTF+khfJsWcB/M8Y5JIlJfKhZt8ORaErUah/
	 u8wqdPUFdlvrA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v2 02/13] rootns: Add core infrastructure for root namespaces
Date: Wed, 18 Nov 2026 01:13:41 +0200
Message-ID: <20261117231352.3816603-3-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
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
orchestrators lack a single kernel object that binds a namespace set, a
root mount, and an init process behind a pollable file descriptor.

Add struct rootns, its lifecycle states, reference counting, uAPI
creation flags, and anonymous inode file operations under CONFIG_ROOTNS.
Drop active and passive namespace references on final release, send
SIGKILL to the rootns init thread group on close when
ROOTNS_KILL_ON_CLOSE is set, and report EPOLLHUP from poll() once the
rootns reaches ROOTNS_DEAD.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/rootns.h      |  66 ++++++++++++++++++++++
 include/uapi/linux/rootns.h |  38 +++++++++++++
 init/Kconfig                |   9 +++
 kernel/Makefile             |   2 +
 kernel/rootns.c             | 107 ++++++++++++++++++++++++++++++++++++
 5 files changed, 222 insertions(+)
 create mode 100644 include/linux/rootns.h
 create mode 100644 include/uapi/linux/rootns.h
 create mode 100644 kernel/rootns.c

diff --git a/include/linux/rootns.h b/include/linux/rootns.h
new file mode 100644
index 000000000000..8464c90863ac
--- /dev/null
+++ b/include/linux/rootns.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ */
+
+#ifndef _LINUX_ROOTNS_H
+#define _LINUX_ROOTNS_H
+
+#include <linux/refcount.h>
+#include <linux/resource.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <linux/path.h>
+
+struct cred;
+struct file;
+struct nsproxy;
+struct pid;
+struct task_struct;
+
+enum rootns_state {
+	ROOTNS_EMPTY	= 0,
+	ROOTNS_READY	= 1,
+	ROOTNS_FORKING	= 2,
+	ROOTNS_RUNNING	= 3,
+	ROOTNS_DEAD	= 4,
+};
+
+/*
+ * The rootns object.
+ */
+struct rootns {
+	refcount_t		usage;
+	int			exit_code;	/* The exit code of 'init' */
+	struct rusage		rusage;		/* Resource usage of 'init' */
+	const struct cred	*cred;		/* Creds for this rootns, including userns */
+	struct nsproxy		*ns;		/* This rootns's namespaces */
+	struct path		root;		/* The root of the rootns's fs namespace */
+	struct pid		*init_pid;	/* The 'init' task's TGID (pid ref) */
+	spinlock_t		lock;		/* Guards rootns lifecycle state */
+	wait_queue_head_t	waitq;		/* Someone waiting for init to exit waits here */
+	unsigned int		flags;		/* Validated rootns_create() flags */
+	enum rootns_state	state;		/* Root namespace lifecycle state */
+};
+
+#ifdef CONFIG_ROOTNS
+struct rootns *get_rootns(struct rootns *c);
+void put_rootns(struct rootns *c);
+bool is_rootns_file(struct file *file);
+#else
+static inline struct rootns *get_rootns(struct rootns *c)
+{
+	return NULL;
+}
+
+static inline void put_rootns(struct rootns *c)
+{
+}
+
+static inline bool is_rootns_file(struct file *file)
+{
+	return false;
+}
+#endif /* CONFIG_ROOTNS */
+
+#endif /* _LINUX_ROOTNS_H */
diff --git a/include/uapi/linux/rootns.h b/include/uapi/linux/rootns.h
new file mode 100644
index 000000000000..bde89d183578
--- /dev/null
+++ b/include/uapi/linux/rootns.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2026 Opinsys Oy
+ */
+
+#ifndef _UAPI_LINUX_ROOTNS_H
+#define _UAPI_LINUX_ROOTNS_H
+
+/**
+ * enum rootns_flags - Flags for rootns_create()
+ * @ROOTNS_CGROUP: Create a fresh cgroup namespace instead of inheriting.
+ * @ROOTNS_UTS: Create a fresh UTS namespace instead of inheriting.
+ * @ROOTNS_IPC: Create a fresh IPC namespace instead of inheriting.
+ * @ROOTNS_USER: Create a fresh user namespace owned by the caller.
+ * @ROOTNS_NET: Create a fresh network namespace instead of inheriting.
+ * @ROOTNS_KILL_ON_CLOSE: Send %SIGKILL to rootns init on final fd release.
+ * @ROOTNS_CLOSE_ON_EXEC: Set %O_CLOEXEC on the returned control fd.
+ * @ROOTNS_ALL_NAMESPACES: Mask of all optional namespace selection flags.
+ * @ROOTNS_ALL_FLAGS: Mask of all valid flags accepted by rootns_create().
+ *
+ * Every root namespace unconditionally owns dedicated mount and PID
+ * namespaces. Optional namespace flags allocate fresh instances of the
+ * remaining namespaces instead of inheriting them from the caller.
+ */
+enum rootns_flags {
+	ROOTNS_CGROUP		= 0x00000001,
+	ROOTNS_UTS		= 0x00000002,
+	ROOTNS_IPC		= 0x00000004,
+	ROOTNS_USER		= 0x00000008,
+	ROOTNS_NET		= 0x00000010,
+	ROOTNS_KILL_ON_CLOSE	= 0x00000100,
+	ROOTNS_CLOSE_ON_EXEC	= 0x00000200,
+	ROOTNS_ALL_NAMESPACES	= 0x0000001f,
+	ROOTNS_ALL_FLAGS	= 0x0000031f,
+};
+
+#endif /* _UAPI_LINUX_ROOTNS_H */
diff --git a/init/Kconfig b/init/Kconfig
index c8a7cfa60a6e..4e9483d3b0a9 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1281,6 +1281,15 @@ config NET_NS
 	  Allow user space to create what appear to be multiple instances
 	  of the network stack.
 
+config ROOTNS
+	bool "Root namespace"
+	depends on USER_NS && PID_NS && UTS_NS && IPC_NS && NET_NS && CGROUPS
+	help
+	  Allow user space to create and manage isolated root namespaces
+	  with their own mount tree, credentials, namespace set, and init
+	  process lifecycle via rootns_create(), rootns_wait(),
+	  rootns_kill(), and clone3() with CLONE_INTO_ROOTNS.
+
 endif # NAMESPACES
 
 config CHECKPOINT_RESTORE
diff --git a/kernel/Makefile b/kernel/Makefile
index 4ff92e24680c..7074d2664ce7 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -152,6 +152,8 @@ KCOV_INSTRUMENT_kstack_erase.o := n
 
 obj-$(CONFIG_SCF_TORTURE_TEST) += scftorture.o
 
+obj-$(CONFIG_ROOTNS) += rootns.o
+
 $(obj)/configs.o: $(obj)/config_data.gz
 
 # .config is small, so it is compressed with gzip rather than the image compressor.
diff --git a/kernel/rootns.c b/kernel/rootns.c
new file mode 100644
index 000000000000..e75d918b93ec
--- /dev/null
+++ b/kernel/rootns.c
@@ -0,0 +1,107 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ */
+
+#include <linux/poll.h>
+#include <linux/wait.h>
+#include <linux/fs.h>
+#include <linux/anon_inodes.h>
+#include <linux/rootns.h>
+#include <linux/sched/signal.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+#include <linux/nsproxy.h>
+#include <linux/ns_common.h>
+#include <linux/nsfs.h>
+#include <linux/pid.h>
+#include <linux/user_namespace.h>
+#include <linux/compat.h>
+#include <uapi/linux/rootns.h>
+
+/*
+ * Get a reference to a rootns.
+ */
+struct rootns *get_rootns(struct rootns *c)
+{
+	refcount_inc(&c->usage);
+	return c;
+}
+
+/*
+ * Drop a reference on a rootns and clear it if it is no longer in use.
+ */
+void put_rootns(struct rootns *c)
+{
+	if (!c || !refcount_dec_and_test(&c->usage))
+		return;
+
+	if (c->ns)
+		put_nsproxy(c->ns);
+	path_put(&c->root);
+
+	if (c->init_pid)
+		put_pid(c->init_pid);
+	if (c->cred) {
+		ns_ref_active_put(c->cred->user_ns);
+		put_cred(c->cred);
+	}
+	kfree(c);
+}
+
+/*
+ * Allow the user to poll for the rootns dying.
+ */
+static __poll_t rootns_poll(struct file *file, poll_table *wait)
+{
+	struct rootns *rootns = file->private_data;
+	__poll_t mask = 0;
+
+	poll_wait(file, &rootns->waitq, wait);
+
+	if (READ_ONCE(rootns->state) == ROOTNS_DEAD)
+		mask |= EPOLLHUP;
+
+	return mask;
+}
+
+static int __rootns_kill(struct rootns *rootns, int sig, bool priv)
+{
+	struct pid *pid = NULL;
+	int ret;
+
+	scoped_guard(spinlock, &rootns->lock) {
+		if (rootns->state == ROOTNS_RUNNING)
+			pid = get_pid(rootns->init_pid);
+	}
+	if (!pid)
+		return -ESRCH;
+
+	ret = kill_pid(pid, sig, priv);
+	put_pid(pid);
+	return ret;
+}
+
+static int rootns_release(struct inode *inode, struct file *file)
+{
+	struct rootns *rootns = file->private_data;
+
+	if (rootns->flags & ROOTNS_KILL_ON_CLOSE)
+		__rootns_kill(rootns, SIGKILL, true);
+	put_rootns(rootns);
+	return 0;
+}
+
+static const struct file_operations rootns_fops = {
+	.poll		= rootns_poll,
+	.release	= rootns_release,
+};
+
+/*
+ * Returns true if the file is a rootns.
+ */
+bool is_rootns_file(struct file *file)
+{
+	return file->f_op == &rootns_fops;
+}
-- 
2.47.3

