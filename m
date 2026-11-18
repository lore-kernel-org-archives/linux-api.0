Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030557;
	b=v+b1fwc0DThTjhotw1KHFVm5YHU6ImVPDEJgGa+P9MKwYH/D9XXVmt1w644lpB5Sds51
	 jCcFfhg3fDNo/hIR5BL0LH1TGfSPuoEPevwL+gfy9UV1+4wLgPo3b5UKrp/r/ziS8UvK6
	 wpPY7rcaJS6hYfv6fYmihnqFet+TBusYLrsuAhISUerT4StiYBI1mvhE1a15E+F+AIcXH
	 QXbi6ziuwnwEFjxF4PCbx9VSn4OFuoSjfX5rEEaVuwIRkvZjXNsMj6UUsCbWW0460fzDb
	 f4IniRQtkbr+D8EhtajoiMAkSM3x2cbMzLQXG6AiVSBoxyV2IdE/Ha4Rrc2W0LPnvIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Ro1gMFPd5ZpXZoFMmycl9LlZjZ8OYb3tXJ188n4YS84=;
	b=BH/kltiQJ6+SVYb+Wr3ZLzZCri4gMPcxAanNbL71EJ9rDBACV3eijn1V/rV2vpZ1scw6
	 dBAmP327vXH0b2VOBiBJ/5HBhonreQMTFwyhoTakl5EaC+AEllpuPcyQECgDRsDY4xuGi
	 JKQgq28B36V24rUK9Cw1/wuyjZDr+I6dPOXavuo0FWgtsIRmaNfr5OJoawAswVVAkKOpN
	 KTzu0SrB0wI8QIRt3RaF5Y+cWIDj5gq4ZR1nUwfWmeFFGhr2aF7S8gsCc0zGiyp/n+3FC
	 IwkLO2PvdQ4CRi4q+2leXzv9wgFdc+kH8f8BEZhOCsc3aivBSB+9Nx6DzBJ5wCMAqJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oBiDr7R9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 125B5606C733;
	Wed, 18 Nov 2026 19:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oBiDr7R9
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3E2201F000C5;
	Wed, 18 Nov 2026 19:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795030556;
	bh=Ro1gMFPd5ZpXZoFMmycl9LlZjZ8OYb3tXJ188n4YS84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oBiDr7R9tTrysdf7b9dh0JYj2qspV68AX8IQUf6ykRJZBjXSro1FzuIoWJb23XOCJ
	 SdhMKbhlB86+DUSVCMv6W8VhiDDCN8iVCBWbgkoMSukAJd/uZwvetyNJKqJANPxJAl
	 txayytYtbhtENyebV32l5h7go/fBz5yrqBbVKwVn69dpP2nU+9Ctk3Ze33/+jD6Yrq
	 3B052+UmuyYDchjNisHP/0mqwXkfuWneARNiFtvRV5+cslh15a3SjHDewicTzEz/3Y
	 E2X/GdqwuQW2DcNPq6+/v54mIhtaCBzZifag5cx7ddnAB7s1WacWgHYJ7vmeGYZC9R
	 MKDL4awCoUtrw==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
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
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v3 02/13] rootns: Add core infrastructure for root namespaces
Date: Wed, 18 Nov 2026 21:35:28 +0200
Message-ID: <20261118193539.240065-3-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118193539.240065-1-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
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
orchestrators lack a single kernel object that binds a full detached
namespace set and an init process behind a pollable file descriptor.

Add struct rootns, its lifecycle states, reference counting, uAPI
creation flags, ROOTNS_GET_NSFD ioctl, and anonymous inode file
operations under CONFIG_ROOTNS. Drop active and passive namespace
references on final release, send SIGKILL to the rootns init thread
group on close when ROOTNS_KILL_ON_CLOSE is set, report EPOLLHUP from
poll() once the rootns reaches ROOTNS_DEAD, and allow holders with
CAP_SYS_ADMIN in the rootns user namespace to open member nsfs fds.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/nsfs.c                   |  64 +++++++++++++++
 include/linux/nsfs.h        |   2 +
 include/linux/rootns.h      |  62 ++++++++++++++
 include/uapi/linux/rootns.h |  44 ++++++++++
 init/Kconfig                |   9 ++
 kernel/Makefile             |   2 +
 kernel/rootns.c             | 160 ++++++++++++++++++++++++++++++++++++
 7 files changed, 343 insertions(+)
 create mode 100644 include/linux/rootns.h
 create mode 100644 include/uapi/linux/rootns.h
 create mode 100644 kernel/rootns.c

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 8179d69da038..1de51cd47508 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -711,3 +711,67 @@ void nsproxy_ns_active_put(struct nsproxy *ns)
 	ns_ref_active_put(ns->time_ns);
 	ns_ref_active_put(ns->time_ns_for_children);
 }
+
+int nsproxy_open_namespace(struct nsproxy *nsp, struct user_namespace *user_ns,
+			   unsigned long nstype)
+{
+	struct ns_common *ns = NULL;
+
+	switch (nstype) {
+	case CLONE_NEWNS:
+		if (ns_ref_get(nsp->mnt_ns))
+			ns = to_ns_common(nsp->mnt_ns);
+		break;
+#ifdef CONFIG_CGROUPS
+	case CLONE_NEWCGROUP:
+		if (ns_ref_get(nsp->cgroup_ns))
+			ns = to_ns_common(nsp->cgroup_ns);
+		break;
+#endif
+#ifdef CONFIG_UTS_NS
+	case CLONE_NEWUTS:
+		if (ns_ref_get(nsp->uts_ns))
+			ns = to_ns_common(nsp->uts_ns);
+		break;
+#endif
+#ifdef CONFIG_IPC_NS
+	case CLONE_NEWIPC:
+		if (ns_ref_get(nsp->ipc_ns))
+			ns = to_ns_common(nsp->ipc_ns);
+		break;
+#endif
+#ifdef CONFIG_USER_NS
+	case CLONE_NEWUSER:
+		if (ns_ref_get(user_ns))
+			ns = to_ns_common(user_ns);
+		break;
+#endif
+#ifdef CONFIG_PID_NS
+	case CLONE_NEWPID:
+		if (ns_ref_get(nsp->pid_ns_for_children))
+			ns = to_ns_common(nsp->pid_ns_for_children);
+		break;
+#endif
+#ifdef CONFIG_NET_NS
+	case CLONE_NEWNET:
+		if (ns_ref_get(nsp->net_ns))
+			ns = to_ns_common(nsp->net_ns);
+		break;
+#endif
+	case CLONE_NEWTIME:
+#ifdef CONFIG_TIME_NS
+		if (ns_ref_get(nsp->time_ns))
+			ns = to_ns_common(nsp->time_ns);
+		break;
+#else
+		return -EOPNOTSUPP;
+#endif
+	default:
+		return -EINVAL;
+	}
+
+	if (!ns)
+		return -ESRCH;
+
+	return open_namespace(ns);
+}
diff --git a/include/linux/nsfs.h b/include/linux/nsfs.h
index 731b67fc2fec..bfba790ee1a7 100644
--- a/include/linux/nsfs.h
+++ b/include/linux/nsfs.h
@@ -39,5 +39,7 @@ void nsfs_init(void);
 
 void nsproxy_ns_active_get(struct nsproxy *ns);
 void nsproxy_ns_active_put(struct nsproxy *ns);
+int nsproxy_open_namespace(struct nsproxy *nsp, struct user_namespace *user_ns,
+			   unsigned long nstype);
 
 #endif /* _LINUX_NSFS_H */
diff --git a/include/linux/rootns.h b/include/linux/rootns.h
new file mode 100644
index 000000000000..a1b2c3f8958b
--- /dev/null
+++ b/include/linux/rootns.h
@@ -0,0 +1,62 @@
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
+
+struct file;
+struct nsproxy;
+struct pid;
+struct user_namespace;
+
+enum rootns_state {
+	ROOTNS_INIT	= 0,
+	ROOTNS_FORKING	= 1,
+	ROOTNS_RUNNING	= 2,
+	ROOTNS_DEAD	= 3,
+};
+
+/*
+ * The rootns object.
+ */
+struct rootns {
+	refcount_t		usage;
+	int			exit_code;	/* The exit code of 'init' */
+	struct rusage		rusage;		/* Resource usage of 'init' */
+	struct user_namespace	*user_ns;	/* Owning user namespace */
+	struct nsproxy		*ns;		/* This rootns's namespaces */
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
index 000000000000..77ebc1dcf489
--- /dev/null
+++ b/include/uapi/linux/rootns.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2026 Opinsys Oy
+ */
+
+#ifndef _UAPI_LINUX_ROOTNS_H
+#define _UAPI_LINUX_ROOTNS_H
+
+#include <linux/ioctl.h>
+
+/**
+ * enum rootns_flags - Flags for rootns_create()
+ * @ROOTNS_KILL_ON_CLOSE: Send %SIGKILL to rootns init on final fd release.
+ * @ROOTNS_CLOSE_ON_EXEC: Set %O_CLOEXEC on the returned control fd.
+ * @ROOTNS_ALL_FLAGS: Mask of all valid flags accepted by rootns_create().
+ *
+ * Every root namespace allocates a full set of detached namespaces owned
+ * by a fresh user namespace.
+ */
+enum rootns_flags {
+	ROOTNS_KILL_ON_CLOSE	= 0x00000001,
+	ROOTNS_CLOSE_ON_EXEC	= 0x00000002,
+	ROOTNS_ALL_FLAGS	= 0x00000003,
+};
+
+#define ROOTNS_IOCTL_MAGIC	0xB9
+
+/**
+ * DOC: ROOTNS_GET_NSFD
+ *
+ * ``ioctl(rootnsfd, ROOTNS_GET_NSFD, nstype)`` opens an ``nsfs`` file
+ * descriptor (with ``O_CLOEXEC``) for the member namespace identified by
+ * ``nstype`` (one of ``CLONE_NEWNS``, ``CLONE_NEWCGROUP``,
+ * ``CLONE_NEWUTS``, ``CLONE_NEWIPC``, ``CLONE_NEWUSER``, ``CLONE_NEWPID``,
+ * ``CLONE_NEWNET``, or ``CLONE_NEWTIME``).
+ *
+ * Requires ``CAP_SYS_ADMIN`` in the ``rootns`` user namespace. Opening
+ * ``CLONE_NEWPID`` additionally requires running in an ancestor active PID
+ * namespace and that ``rootns`` init is running.
+ */
+#define ROOTNS_GET_NSFD		_IO(ROOTNS_IOCTL_MAGIC, 0x01)
+
+#endif /* _UAPI_LINUX_ROOTNS_H */
diff --git a/init/Kconfig b/init/Kconfig
index c8a7cfa60a6e..3b857b105d2c 100644
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
+	  with their own mount tree, user namespace, namespace set, and init
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
index 000000000000..4c08ac575f6c
--- /dev/null
+++ b/kernel/rootns.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ */
+
+/**
+ * DOC: Overview
+ *
+ * A root namespace binds a full set of detached namespaces, an initially empty
+ * mount namespace, an owning user namespace, and an init process behind a
+ * pollable control file descriptor:
+ *
+ * 1. ``rootns_create()`` allocates a detached ``rootns`` with a fresh user
+ *    namespace and dedicated mount (``CLONE_EMPTY_MNTNS``), PID, UTS, IPC,
+ *    network, cgroup, and time namespaces, returning its control fd.
+ *
+ * 2. Userspace configures superblocks via ``FSCONFIG_SET_ROOTNS``, retrieves
+ *    the mount namespace fd via ``ioctl(rootnsfd, ROOTNS_GET_NSFD,
+ *    CLONE_NEWNS)``, and installs ``"/"`` and relative submounts via
+ *    ``MOVE_MOUNT_T_MNTNS``.
+ *
+ * 3. ``clone3()`` with ``CLONE_INTO_ROOTNS`` spawns processes into the
+ *    ``rootns``; the first call commits PID 1 while concurrent bootstrap
+ *    callers wait killably.
+ *
+ * 4. When PID 1 exits, the PID namespace zaps and reaps all remaining tasks,
+ *    ``poll()`` reports ``EPOLLHUP``, and ``rootns_wait()`` returns the exit
+ *    status and ``rusage``.
+ */
+
+#include <linux/poll.h>
+#include <linux/wait.h>
+#include <uapi/linux/wait.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/anon_inodes.h>
+#include <linux/rootns.h>
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
+#include <linux/compat.h>
+#include <linux/idr.h>
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
+	if (c->init_pid)
+		put_pid(c->init_pid);
+	if (c->user_ns) {
+		ns_ref_active_put(c->user_ns);
+		put_user_ns(c->user_ns);
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
+static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct rootns *rootns = file->private_data;
+
+	if (cmd != ROOTNS_GET_NSFD)
+		return -ENOIOCTLCMD;
+
+	if (!ns_capable(rootns->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (arg == CLONE_NEWPID) {
+		if (!pidns_is_ancestor(rootns->ns->pid_ns_for_children,
+				       task_active_pid_ns(current)))
+			return -EXDEV;
+		if (READ_ONCE(rootns->state) != ROOTNS_RUNNING)
+			return -ESRCH;
+	}
+
+	return nsproxy_open_namespace(rootns->ns, rootns->user_ns, arg);
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
+	.unlocked_ioctl	= rootns_ioctl,
+	.compat_ioctl	= rootns_ioctl,
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

