Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794892137;
	b=aVHbAM/GHXXYMEwlUIHvrSbb5W1kGztz6/NR1vpRL5iv97EdzOV9TTK+WezZqYdboyda
	 lGHmTHUWrkEhRkF+kqROz1Q+E+mDZ0+u3mErsqHSMyL55Z+2OmrZherteLOSOivkWm3rZ
	 /RTh9rsG0rlmqSkKXgU90j1c79FnFNWvM86X5NMhcD4zlJq5QvKBkkz8TO3FrLhKzOq+p
	 T68BFPLWc47jV5h+xmF4D2/A0fh/3qLJL5RwF3cseI3nP4QpVWnXRZvYGDWT9lfqnwHa7
	 0opHUQKlkMAQ8+ayJDmCT7agwiNUQkXsznQZmsb5lo8VGyncaFqnTxUVg6/o/Xziw9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794892137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=bv2QgkekAZHri0du5cNVMwQZ376oxKPFckZSa1qEYh4=;
	b=xtB4FOuWeSTu7VU2HIplzIe4ZBev6Jg5BWEgRGKgGU9SBM6HBQkkodOffDwX2TWd4tN1
	 CJTrHVMFgn7qP+vw0qCEaX3MScwip77Efr01hzGMxfcnlSZXIm/fO48P34LAP6XBvAd98
	 Q64DIBE74phNyFAXyPmPkY18SZQhqVVnujcsBNzDhRPR4ZlvWwOfqmnKPdhMxF4QcRcp/
	 lhXBMm8ORJcT6kt/vt4L4+4oUlvX9yP4QL4EAXC0tc5sSbZUqkJpatkMXDtRMsisTmWiM
	 r8AnYAr/nA4Xagwe2IXNgNYQXrULsxkBoYhdFSj1s6cvimKNMSZBROYhVeTYPi7R19Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F5DnV+SS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 61C25606A32C;
	Tue, 17 Nov 2026 05:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F5DnV+SS
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5274E1F000C5;
	Tue, 17 Nov 2026 05:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892137;
	bh=bv2QgkekAZHri0du5cNVMwQZ376oxKPFckZSa1qEYh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F5DnV+SSZR/dJPz2WPFWJrBRuhthRzW6qjCSFYPyL+sjFbnKNgff3YzfJr0y7nsvr
	 F/jsWu1l4x2kimvpSTxDj0Bhz2tNxblZS60EP7bKTz9kEI70CU9cAWEEzMmhTdAQnM
	 yaaOArX1tuR8Xu2hkPEFHB9wg0R4QsFc2K+V9VBwkPge/aP2r4qr9VzaEpFmUy2KWj
	 ImkaBIPRShx1PkrXC3pVZaUDxzjBaff6nqE2z0NMX9bmDTamt3IaloDVbwLH/c9jGU
	 ZrgafIzv097nHHJ6EgojcI8eMJDPxHrW5osbSctJXzVIeedscniQF7rWz9ed4HRp4o
	 skyIb+n9Wxd5g==
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
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH 02/13] rootns: Add core infrastructure for root namespaces
Date: Tue, 17 Nov 2026 07:08:30 +0200
Message-ID: <20261117050841.3289652-3-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
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
 include/linux/nsproxy.h     |   3 +
 include/linux/rootns.h      |  66 ++++++++++++++++++++++
 include/uapi/linux/rootns.h |  38 +++++++++++++
 init/Kconfig                |   9 +++
 kernel/Makefile             |   2 +
 kernel/rootns.c             | 107 ++++++++++++++++++++++++++++++++++++
 6 files changed, 225 insertions(+)
 create mode 100644 include/linux/rootns.h
 create mode 100644 include/uapi/linux/rootns.h
 create mode 100644 kernel/rootns.c

diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index cacbbbe3f1ce..23cbeee6b1e4 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -91,6 +91,9 @@ static inline struct cred *nsset_cred(struct nsset *set)
  *         * /
  *     task_unlock(task);
  *
+ *  4. Root namespace membership is carried by nsproxy and inherited by
+ *     namespaces derived from it.
+ *
  */
 
 struct nsproxy *create_new_namespaces(u64 flags,
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
index 4013781e0a02..f1f3a6d1755c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1280,6 +1280,15 @@ config NET_NS
 	  Allow user space to create what appear to be multiple instances
 	  of the network stack.
 
+config ROOTNS
+	bool "Root namespace"
+	depends on USER_NS && PID_NS && UTS_NS && IPC_NS && NET_NS && CGROUPS
+	help
+	  Allow user space to create and manage isolated root namespaces
+	  with their own mount tree, credentials, namespace set, and init
+	  process lifecycle via the rootns_create(), rootns_enter(),
+	  rootns_wait(), and rootns_kill() system calls.
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

