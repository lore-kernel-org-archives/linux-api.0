Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219791;
	b=ag0IYkaZOInKu3QkD3phLATLnYxTvixPTpUOf4UzJl1Eu7PaCrfrLOXwibyOMMLlj6QH
	 ziABOcvxXIyvHXWYrOwPUpYcX0sD2d9/UkGyUE/IMO9SQtGEOrf8oWVqmgzAYYmtN2uQc
	 4bQFiIZhQ90EhdINUap7IoR04HgYmow0bVBuoepZf9XaF2q9s7UmAddmd8BVE5OkpLt+S
	 Kz4QTa4mosc811gdA5DOyYarHFAfvDgv6fx4d7Ev2Au1nxjfzcvGh/A4LeZk1iGWqY7wz
	 GlQfLUNi1FZjYYa/jsalqABHno1354Tx5x3lf0+QtVGYbKM3YRzhGY4idCehOMbFlRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=5CbJrr0fmJ/8/RjFMDqcVzL22igR5/O53T1kshtB1fI=;
	b=OeVNYDf4KxmslKMAIdUJUe/aEmMtpCZkNiJTDqGjJgabZbVrUhK8qgrBCFKg5SkwkNHa
	 AN5YaEA24DknTMN+9tv+zuXUI9J+WmzvMZtoki9U0BHuXp2BQqnYIm3kV2rUi7XwRAbzE
	 XlQSuru48qs43GVUzoT+YtO0DBQDMBH2XVer+QtUYIMlvq1SKSvGdfv8Vsx8iWx3vd0j2
	 hReE1or9bAfy3X+FnEsiDGge6lybO5cwahnSJzZUrNWL81t8XCWRZoPe7ZZWTUZ99XiDt
	 cEx2HQfPQ4zG//zGl2/2bGawPYB1m94KgKeomIFTqGa0u3gkgvYjnKyesl/Cv1y+Gsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l39vwha0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 901EB60A260D;
	Sat, 21 Nov 2026 00:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l39vwha0
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9ECE31F000C0;
	Sat, 21 Nov 2026 00:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219791;
	bh=5CbJrr0fmJ/8/RjFMDqcVzL22igR5/O53T1kshtB1fI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l39vwha0Zy301QmNnNGYORrwB0yc3QYfTpAkLcafc2HA1qNszWZtidcT6rdP0VP2i
	 bGEsvcTeq4WIzErXvPfrAvqG2H9PcQhoEcwK6pqrmAzfktH+KF/kmyf5lb5Fjvrc+Z
	 /5vGmA2siKwD3UKAs+JcXN4xzsLZmiAa2CHIG/X4IqqdA5qnAyrcrlhhADFwhBlmPT
	 2sirMV+EUB02gSCmMbZFHhcyPS+vgWUwuChyLYtJfVPfv9HsdEJmXepRHTFq5mmGe1
	 JIXJI1i0hrFp5gZjWNu86UaQ52x6S4q8DBGZ47AFWSw9RHO6Pw6jnLoZSQ2h7dFwOk
	 gZ8s/j19XfiMA==
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
Subject: [RFC PATCH v5 13/25] rootns: Add rootns() system call
Date: Sat, 21 Nov 2026 02:08:32 +0200
Message-ID: <20261121000844.1863324-14-jarkko@kernel.org>
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

Setting up an isolated namespace environment from a multithreaded
manager process currently requires helper processes to call unshare()
and pass file descriptors back over sockets.

Add the rootns() system call to allocate a detached rootns instance
owning a fresh user namespace alongside dedicated empty mount
(CLONE_EMPTY_MNTNS), PID, UTS, IPC, network, cgroup, and time
namespaces, and return its control file descriptor. Finalize the nsproxy
time namespace and pin active references for the lifetime of the rootns.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/syscalls.h       |   1 +
 include/linux/time_namespace.h |  13 ++++
 kernel/rootns.c                | 106 +++++++++++++++++++++++++++++++++
 kernel/sys_ni.c                |   3 +
 4 files changed, 123 insertions(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 72308cc11908..8284bce1c31e 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1010,6 +1010,7 @@ asmlinkage long sys_lsm_get_self_attr(unsigned int attr, struct lsm_ctx __user *
 asmlinkage long sys_lsm_set_self_attr(unsigned int attr, struct lsm_ctx __user *ctx,
 				      u32 size, u32 flags);
 asmlinkage long sys_lsm_list_modules(u64 __user *ids, u32 __user *size, u32 flags);
+asmlinkage long sys_rootns(unsigned int flags);
 
 /*
  * Architecture-specific system calls
diff --git a/include/linux/time_namespace.h b/include/linux/time_namespace.h
index 58bd9728df58..bdc185543893 100644
--- a/include/linux/time_namespace.h
+++ b/include/linux/time_namespace.h
@@ -60,6 +60,15 @@ static inline void put_time_ns(struct time_namespace *ns)
 		free_time_ns(ns);
 }
 
+static inline void timens_activate_nsproxy(struct nsproxy *nsproxy)
+{
+	if (nsproxy->time_ns != nsproxy->time_ns_for_children) {
+		get_time_ns(nsproxy->time_ns_for_children);
+		put_time_ns(nsproxy->time_ns);
+		nsproxy->time_ns = nsproxy->time_ns_for_children;
+	}
+}
+
 void proc_timens_show_offsets(struct task_struct *p, struct seq_file *m);
 
 struct proc_timens_offset {
@@ -125,6 +134,10 @@ static inline void put_time_ns(struct time_namespace *ns)
 {
 }
 
+static inline void timens_activate_nsproxy(struct nsproxy *nsproxy)
+{
+}
+
 static inline
 struct time_namespace *copy_time_ns(u64 flags,
 				    struct user_namespace *user_ns,
diff --git a/kernel/rootns.c b/kernel/rootns.c
index fd8ce59de61a..5d59fc9a591d 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -222,3 +222,109 @@ void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk)
 	__wake_up(&c->waitq, TASK_NORMAL, 0, poll_to_key(EPOLLHUP));
 	put_rootns(c);
 }
+
+static struct user_namespace *create_rootns_user_ns(void)
+{
+	struct user_namespace *user_ns;
+	struct cred *new;
+	int ret;
+
+	new = prepare_creds();
+	if (!new)
+		return ERR_PTR(-ENOMEM);
+
+	ret = create_user_ns(new);
+	if (ret < 0) {
+		abort_creds(new);
+		return ERR_PTR(ret);
+	}
+
+	user_ns = get_user_ns(new->user_ns);
+	abort_creds(new);
+	return user_ns;
+}
+
+/*
+ * Create a new rootns.
+ */
+static struct rootns *create_rootns(unsigned int flags)
+{
+	u64 clone_flags = CLONE_NEWNS | CLONE_EMPTY_MNTNS | CLONE_NEWPID |
+			  CLONE_NEWCGROUP | CLONE_NEWUTS | CLONE_NEWIPC |
+			  CLONE_NEWNET |
+			  (IS_ENABLED(CONFIG_TIME_NS) ? CLONE_NEWTIME : 0);
+	struct user_namespace *user_ns;
+	struct nsproxy *ns;
+	struct rootns *c;
+	int ret;
+
+	c = kzalloc_obj(*c, GFP_KERNEL);
+	if (!c)
+		return ERR_PTR(-ENOMEM);
+
+	init_waitqueue_head(&c->waitq);
+	spin_lock_init(&c->lock);
+	refcount_set(&c->usage, 1);
+	c->flags = flags;
+
+	user_ns = create_rootns_user_ns();
+	if (IS_ERR(user_ns)) {
+		ret = PTR_ERR(user_ns);
+		goto err_put;
+	}
+	c->user_ns = user_ns;
+	ns_ref_active_get(user_ns);
+
+	if (!ns_capable(user_ns, CAP_SYS_ADMIN)) {
+		ret = -EPERM;
+		goto err_put;
+	}
+
+	ns = create_new_namespaces(clone_flags, current->nsproxy, user_ns,
+				   NULL);
+	if (IS_ERR(ns)) {
+		ret = PTR_ERR(ns);
+		goto err_put;
+	}
+
+	timens_activate_nsproxy(ns);
+	c->ns = ns;
+	nsproxy_ns_active_get(ns);
+
+	return c;
+
+err_put:
+	put_rootns(c);
+	return ERR_PTR(ret);
+}
+
+/**
+ * sys_rootns - Create a detached root namespace
+ * @flags: Combination of &enum rootns_flags values
+ *
+ * Allocate a detached root namespace owning a fresh user namespace and
+ * dedicated empty mount, PID, UTS, IPC, network, cgroup, and time namespaces.
+ *
+ * Return: Control file descriptor on success, negative error code on failure.
+ */
+SYSCALL_DEFINE1(rootns, unsigned int, flags)
+{
+	struct rootns *c;
+	int fd;
+
+	if (flags & ~ROOTNS_ALL_FLAGS)
+		return -EINVAL;
+	if (unlikely(!current->nsproxy))
+		return -EOPNOTSUPP;
+
+	c = create_rootns(flags);
+	if (IS_ERR(c))
+		return PTR_ERR(c);
+
+	fd = anon_inode_getfd("rootns", &rootns_fops, c,
+			      O_RDWR | (flags & ROOTNS_CLOSE_ON_EXEC ? O_CLOEXEC : 0));
+	if (fd < 0)
+		put_rootns(c);
+
+	return fd;
+}
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index e3202e7cc2a1..f095401bed24 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -399,3 +399,6 @@ COND_SYSCALL(rseq_slice_yield);
 
 COND_SYSCALL(uretprobe);
 COND_SYSCALL(uprobe);
+
+/* kernel/rootns.c */
+COND_SYSCALL(rootns);
-- 
2.47.3

