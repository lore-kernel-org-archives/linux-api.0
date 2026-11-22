Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795310346;
	b=ftvh/bD9oKXharxjVGhUmiVzBdQRnPz632rIYZ64+IY4PQcn/op3fkk2AzPUgk8IYiu/
	 wSjexuubzn0s326fe0rqfvqyLVE1HqdezDaNrM+hmZM8EloTpo4aHeYev/T5S9p6i+iJO
	 /LHlzScgZnmWxYc9nX3cK9DbfToUgk026kDK+mjOjf+VQ3TR17YLzSqWh63R+0y/qxVun
	 vISZfxo/ykp6osX+9MgZdl97rB0YYD59SLiS3lHE1VFjgQQWqK7yAmvfMr+5SKa2O7gXI
	 3bBPVuku4nv+SizzqxuXJ/LRmHVTecB6n2Clb8+SUSjYi/TBe8vtItyD/Lx0MWIj6Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795310346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=yV/3lRQtOQxqgRWopxhp5rjcN498ncYUt5HOtng0GIw=;
	b=VsnrX3Sq0YHVjwkBmVQozVYxFsQ2B9tkAY7I6RpCSkp714aajn9Av09ColhrrcoI0cNy
	 oAECILZnB726sRQ3IJfzVfmE8Oh6c/UHwJE9y+ynUEEpxgrZDKELOy/xRMyKBFfoZLHNK
	 XPowEsbwO2doBWsriJYk2it8FYoABa7Uj8ToBZup2H4G9bKZarEgU/BXCBEvvL+4CTsNO
	 goEe4oiKaN3XmF99tDy21Y1+bfS6lvnABXyI7UnNqVXbAXX4lhvxUT8XqfU51GT/onmeZ
	 qYGL4k7HEZhNlWZ3YXTFeGxahIGxvNCzGIEybDQ8C5tqJXfM0mb40PGuKWCjrrBwmcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CIXU7+VK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 43459606A331;
	Sun, 22 Nov 2026 01:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CIXU7+VK
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 24FF01F000D1;
	Sun, 22 Nov 2026 01:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310345;
	bh=yV/3lRQtOQxqgRWopxhp5rjcN498ncYUt5HOtng0GIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CIXU7+VKFKJaP3nZlOBxh6leoLCIsRnbhWL84dTMd9gmRsmMZLObOTmFvSNXR1N+j
	 mPfbPHZLK8jrhmfKQGmfSupHrgitIRSqvOuyn2KDx5r69Osi1AVy2z1rprDC4Ywt1b
	 hw/tZ3RtNtRtosxt6m3ylXZZGNzPLOxI83gaVyOyCc8yABdPEFPo9udr8erHP1wT6f
	 BH8lLBW+gA+v/mjxA70JBjv3OnD7ZUcAuUqGgHPrBab+WFCkhbR28qRf9HZyMI4KnD
	 KH0aHNS5Ll/iIssvHEynMIopUZ2n5epcJSE3sMX1CYnLP7qU5d7ZGG3bVo/rcFsobK
	 W553ZabSFTrAg==
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
Subject: [RFC PATCH v6 12/26] userland: Add userland_open() system call
Date: Sun, 22 Nov 2026 03:17:55 +0200
Message-ID: <20261122011809.2667684-13-jarkko@kernel.org>
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

Setting up an isolated namespace environment from a multithreaded
manager process currently requires helper processes to call unshare()
and pass file descriptors back over sockets.

Add the userland_open() system call to allocate a userland owning a
fresh user namespace alongside dedicated empty mount
(CLONE_EMPTY_MNTNS), PID, UTS, IPC, network, cgroup, and time
namespaces, and return its anonymous-inode file descriptor. Because a
userland encapsulates process lifecycle and mount delegation rather than
an nsfs namespace entity, keep it separate from namespace creation APIs.
Finalize the nsproxy time namespace and pin active references for the
lifetime of the userland.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/syscalls.h |   1 +
 kernel/sys_ni.c          |   3 ++
 kernel/userland.c        | 107 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 111 insertions(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 72308cc11908..2ea8ebd71743 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1010,6 +1010,7 @@ asmlinkage long sys_lsm_get_self_attr(unsigned int attr, struct lsm_ctx __user *
 asmlinkage long sys_lsm_set_self_attr(unsigned int attr, struct lsm_ctx __user *ctx,
 				      u32 size, u32 flags);
 asmlinkage long sys_lsm_list_modules(u64 __user *ids, u32 __user *size, u32 flags);
+asmlinkage long sys_userland_open(unsigned int flags);
 
 /*
  * Architecture-specific system calls
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index e3202e7cc2a1..fca9663d09b7 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -399,3 +399,6 @@ COND_SYSCALL(rseq_slice_yield);
 
 COND_SYSCALL(uretprobe);
 COND_SYSCALL(uprobe);
+
+/* kernel/userland.c */
+COND_SYSCALL(userland_open);
diff --git a/kernel/userland.c b/kernel/userland.c
index e117b00cb8a2..d99b5d99fcc4 100644
--- a/kernel/userland.c
+++ b/kernel/userland.c
@@ -128,3 +128,110 @@ void userland_exit(struct pid_namespace *pid_ns, struct task_struct *tsk)
 	__wake_up(&c->waitq, TASK_NORMAL, 0, poll_to_key(EPOLLHUP));
 	userland_put(c);
 }
+
+static struct user_namespace *userland_create_user_ns(void)
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
+static struct userland *userland_create(unsigned int flags)
+{
+	u64 clone_flags = CLONE_NEWNS | CLONE_EMPTY_MNTNS | CLONE_NEWPID |
+			  CLONE_NEWCGROUP | CLONE_NEWUTS | CLONE_NEWIPC |
+			  CLONE_NEWNET |
+			  (IS_ENABLED(CONFIG_TIME_NS) ? CLONE_NEWTIME : 0);
+	struct user_namespace *user_ns;
+	struct nsproxy *ns;
+	struct userland *c;
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
+	user_ns = userland_create_user_ns();
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
+	ns = create_new_namespaces(clone_flags, current, user_ns, NULL);
+	if (IS_ERR(ns)) {
+		ret = PTR_ERR(ns);
+		goto err_put;
+	}
+
+	if (ns->time_ns != ns->time_ns_for_children) {
+		get_time_ns(ns->time_ns_for_children);
+		put_time_ns(ns->time_ns);
+		ns->time_ns = ns->time_ns_for_children;
+	}
+	c->ns = ns;
+	nsproxy_ns_active_get(ns);
+
+	return c;
+
+err_put:
+	userland_put(c);
+	return ERR_PTR(ret);
+}
+
+/**
+ * sys_userland_open - Open a new userland
+ * @flags: Combination of &enum userland_flags values
+ *
+ * Allocate a userland owning a fresh user namespace and dedicated
+ * empty mount, PID, UTS, IPC, network, cgroup, and time namespaces.
+ *
+ * Return: Userland file descriptor on success, negative error code on failure.
+ */
+SYSCALL_DEFINE1(userland_open, unsigned int, flags)
+{
+	struct userland *c;
+	int fd;
+
+	if (flags & ~USERLAND_ALL_FLAGS)
+		return -EINVAL;
+	if (unlikely(!current->nsproxy))
+		return -EOPNOTSUPP;
+
+	c = userland_create(flags);
+	if (IS_ERR(c))
+		return PTR_ERR(c);
+
+	fd = anon_inode_getfd("userland", &userland_fops, c,
+			      O_RDWR |
+			      (flags & USERLAND_CLOSE_ON_EXEC ? O_CLOEXEC : 0));
+	if (fd < 0)
+		userland_put(c);
+
+	return fd;
+}
-- 
2.47.3

