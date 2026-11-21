Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219782;
	b=FzgdcE7jkTZksCtFkWVutrMJWmvKFlyRWdLxfGy7y+CFabko9mxkCzKTzyR62Vp/H2OV
	 lqaCOHV29ndVq7FjappbgnBpvUivvqn+dhYd/e7wrXoRw5TDVK+20mjE++sDXT7X1BEpf
	 GQRlvG4EKaOBD4k1VrhWsyAiPHJoEvBLh1Nid4QrP5sNbqNXMbvSDEF/4sC7UetqEc6uA
	 WBdonjQg7uMnrtr32KcwE7THe09YCYGWiuH9j9gLD6LFccka+KilYg73rDgevidejDDss
	 SmOD6kNaYSZbqjrkKYBBkTfwzqrPz/zdChBXsBoAYubZc7DdR1P6peZfMCPX+CrKWhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=34NsR9qDEX93JLH24p1g9gWYVr+3rl2EHG0BTWzvYeg=;
	b=r+R3ROtjT8Nukvnwh6DYCRRnJ+em08Ws6DHuAoiutpW9lo7pga+fHVhpz/uZMNQnFoMe
	 JlFz5QbuyoixkS72Gk0l0QwvZ+O4MBbJ57B1o10gWhixLogQ0xiI+FAowCGAcB96Y+g3K
	 jiNqYkGV7cxdZCTeDIDPmLTfVMu7zQ3F8uUhFbCw7HnRqLpuV0Enelzjaj7JRImGun+J6
	 yIUBd1Ne/TrSggIBRlmJJrZ2gevIuNnJST0IWk0n7JuwOMvXQb6KRKCVgLqEo15g1kz1a
	 7KDRTDVLuPwbxowi+I+FBbJT9iiWcqUgDn//1SpHQJHjYhjElgIWkxkW/BSUL91MrPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eGlmyx+d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 79F4360A2617;
	Sat, 21 Nov 2026 00:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eGlmyx+d
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8F76C1F000F4;
	Sat, 21 Nov 2026 00:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219782;
	bh=34NsR9qDEX93JLH24p1g9gWYVr+3rl2EHG0BTWzvYeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eGlmyx+d7vmJOddR//D0BQKTFrq1yc81uhne+TWWDPcCYO9+q4+AzbumXzYCZxoD1
	 hmx8PXMmdy8iUvftVOdsH24NsdjNh0NGY8yI3l8SiTMPQ4eNc4N2vuOEHoz6IXkVFf
	 M+e1ouhcniuLfTASpu79zi/Zgpo8z1ABB1yv1w2oKtugequ1kdY8jW32dty5yhIqoI
	 f89orpbcXNez5/wKCOykePOMBKvoRq9ZklUSbVttHAhqL2XMcyt9VzNb3QoB/lupus
	 5VKLd/zRKpwLpfRzWng73o025PfnKBtODWOVsbPKLRDcYgNBsysxzr/3zEuXSakpOr
	 ofXwcJI4Wnk1A==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 11/25] rootns: Add core infrastructure for root namespaces
Date: Sat, 21 Nov 2026 02:08:30 +0200
Message-ID: <20261121000844.1863324-12-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
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
 include/linux/rootns.h      |  61 ++++++++++++
 include/uapi/linux/rootns.h |  44 +++++++++
 init/Kconfig                |   9 ++
 kernel/Makefile             |   2 +
 kernel/rootns.c             | 187 ++++++++++++++++++++++++++++++++++++
 5 files changed, 303 insertions(+)
 create mode 100644 include/linux/rootns.h
 create mode 100644 include/uapi/linux/rootns.h
 create mode 100644 kernel/rootns.c

diff --git a/include/linux/rootns.h b/include/linux/rootns.h
new file mode 100644
index 000000000000..dcdba08cfaeb
--- /dev/null
+++ b/include/linux/rootns.h
@@ -0,0 +1,61 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2026 Opinsys Oy
+ */
+
+#ifndef _LINUX_ROOTNS_H
+#define _LINUX_ROOTNS_H
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
+	struct user_namespace	*user_ns;	/* Owning user namespace */
+	struct nsproxy		*ns;		/* This rootns's namespaces */
+	struct pid		*init_pid;	/* The 'init' task's TGID (pid ref) */
+	spinlock_t		lock;		/* Guards rootns lifecycle state */
+	wait_queue_head_t	waitq;		/* Someone waiting for init to exit waits here */
+	unsigned int		flags;		/* Validated rootns() flags */
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
index 000000000000..bd643bdfb43c
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
+ * enum rootns_flags - Flags for rootns()
+ * @ROOTNS_KILL_ON_CLOSE: Send %SIGKILL to rootns init on final fd release.
+ * @ROOTNS_CLOSE_ON_EXEC: Set %O_CLOEXEC on the returned control fd.
+ * @ROOTNS_ALL_FLAGS: Mask of all valid flags accepted by rootns().
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
index c8a7cfa60a6e..58eafca2f42a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1283,6 +1283,15 @@ config NET_NS
 
 endif # NAMESPACES
 
+config ROOTNS
+	bool "Root namespace descriptor support"
+	depends on NAMESPACES && USER_NS && PID_NS && UTS_NS && IPC_NS && NET_NS && CGROUPS
+	help
+	  Allow user space to create and manage isolated namespace sets and
+	  their init process lifecycle through an anonymous-inode control file
+	  descriptor via rootns(), rootns ioctls, FSCONFIG_SET_ROOTNS, and
+	  clone3() with CLONE_INTO_ROOTNS.
+
 config CHECKPOINT_RESTORE
 	bool "Checkpoint/restore support"
 	depends on PROC_FS
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
index 000000000000..033e0aae386f
--- /dev/null
+++ b/kernel/rootns.c
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2017-2019 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2026 Opinsys Oy
+ */
+
+/**
+ * DOC: Overview
+ *
+ * A ``rootns`` is an anonymous-inode control file descriptor (not an ``nsfs``
+ * namespace) that binds a full set of detached namespaces, an initially empty
+ * mount namespace, an owning user namespace, and an init process lifecycle:
+ *
+ * 1. ``rootns()`` allocates a detached ``rootns`` with a fresh user namespace
+ *    and dedicated mount (``CLONE_EMPTY_MNTNS``), PID, UTS, IPC, network,
+ *    cgroup, and time namespaces, returning its control fd.
+ *
+ * 2. Userspace optionally maps UIDs/GIDs via ``userns_set_idmap()`` on the
+ *    ``CLONE_NEWUSER`` fd, configures superblocks via ``FSCONFIG_SET_ROOTNS``,
+ *    retrieves the mount namespace fd via ``ioctl(rootnsfd, ROOTNS_GET_NSFD,
+ *    CLONE_NEWNS)``, and installs ``"/"`` and relative or cloned
+ *    (``MOVE_MOUNT_CLONE``) submounts via ``MOVE_MOUNT_T_MNTNS``.
+ *
+ * 3. ``clone3()`` with ``CLONE_INTO_ROOTNS`` spawns processes into the
+ *    ``rootns``; the first call commits PID 1 while concurrent bootstrap
+ *    callers wait killably.
+ *
+ * 4. ``ioctl(rootnsfd, ROOTNS_KILL, sig)`` signals all member thread groups.
+ *    When PID 1 exits, the PID namespace zaps and reaps all remaining tasks,
+ *    ``poll()`` reports ``EPOLLHUP``, and ``ioctl(rootnsfd, ROOTNS_WAIT,
+ *    &args)`` returns init's exit status.
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
+static long rootns_get_nsfd(struct rootns *rootns, unsigned long nstype)
+{
+	if (nstype > UINT_MAX)
+		return -EINVAL;
+	if (!ns_capable(rootns->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (nstype == CLONE_NEWPID) {
+		if (!pidns_is_ancestor(rootns->ns->pid_ns_for_children,
+				       task_active_pid_ns(current)))
+			return -EXDEV;
+		if (READ_ONCE(rootns->state) != ROOTNS_RUNNING)
+			return -ESRCH;
+	}
+
+	return nsproxy_open_namespace(rootns->ns, rootns->user_ns, nstype);
+}
+
+static long rootns_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct rootns *rootns = file->private_data;
+
+	switch (cmd) {
+	case ROOTNS_GET_NSFD:
+		return rootns_get_nsfd(rootns, arg);
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
+#ifdef CONFIG_COMPAT
+static long rootns_compat_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
+{
+	switch (cmd) {
+	case ROOTNS_GET_NSFD:
+		return rootns_ioctl(file, cmd, arg);
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+#endif
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
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= rootns_compat_ioctl,
+#endif
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

