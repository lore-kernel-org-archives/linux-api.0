Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794957266;
	b=D/z6n3YlLeLb6vYRwfTfzaE5vRg/woEkVEcByG9Y+5HUNwWrdvPVy87Q+4z0LuO63qDS
	 rCO8C5Az2Bt1h1BnG3diUu53KLJCTIZ+aXO4w0u7GXoTrbAfJtXjKxpUaxaYQBiBu2kNF
	 WgiE3hsKaS4Hrj0O/bfZnTVH+bIuGXslEz/4bsmW1j0BA/li+hQG2Kl4nnSvD6bfv+zW2
	 TEpOeaMKNUgK1x8c6gBbbG70tO0ofIAZKROjiEkLzV9DzEmHN/qg+0ZpffXhENH+3c9tW
	 jkDlDsH8FkY8lvePUF3HAloDOooW/Uh9XKuH/Jgo4OLb4kDuKroK52cBeJl41ozR+0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794957266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=GLkPPSN4G9oNOjjtEMLGuFRN2z4NxY+gcMx+AxGI1Nc=;
	b=F9SGDAxY3eUdX+KM+PwECUtERTZKcGmW1JBZomcXxKdJDP9cXMNQJGeUbA4RvRhVygKG
	 tONWPk9QSBup+rMtiCDb5cmOEgzqKEcBSZe3u7UtNLh+nlCzVCAoKzSCgL9qXcz/An2yE
	 D1sd1w6mY1Bm3rDAS5GMF+Av699vMD+BAVFH4PwJMoI4+KU2XotIgWZzCrtqakm0DnPD1
	 kMSFZ1V/uaovxskjohdrpjgEIS1ghkQpLp4Hr2H2QJmVCDO+lUvvc5hIO5a9aaAdM5620
	 8L/8AmvIeM1G43S64upSzk9Nz6mnjOB1Ua1I2Ooc9to/4RXnD/d4MHUnvjoRUO34zMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UTjzZX97;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 6EE3C606A32A;
	Tue, 17 Nov 2026 23:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UTjzZX97
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8D9861F000CA;
	Tue, 17 Nov 2026 23:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957266;
	bh=GLkPPSN4G9oNOjjtEMLGuFRN2z4NxY+gcMx+AxGI1Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UTjzZX978haoKvloakiOf/KX2pOVH23VzeaEl7eRyIb4kreNndJnZF/cVfok/wI0g
	 QnGijXlTQt3ElCMBf5TgDkgwphy02SDD07pnqFHHcot3ICRwxnin2U/7k1g3Mv8KZm
	 HIrMk+8l5mG0ZPuI7Zs9qn+U9ThXL0HM+86nOguUbfOTfLUuzxBa8M/4td5H7MgVlO
	 miR6YnE9iX3OrntxT9uhi36Zis6mXm0DM7GZwKVOVzmn+HqjnKqvagJ94rX4FKG+Dt
	 A+4ggjYR+UYWjHkAVzuxNS7rPqnAuV1wSrH/ZwytoxpRMLITOLoD6mA5qPMpFxN115
	 aW68+xI5+pTiQ==
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
Subject: [RFC PATCH v2 04/13] rootns: Add rootns_create() system call
Date: Wed, 18 Nov 2026 01:13:43 +0200
Message-ID: <20261117231352.3816603-5-jarkko@kernel.org>
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

Setting up an isolated namespace environment from a multithreaded
manager process currently requires helper processes to call unshare()
and pass file descriptors back over sockets.

Add the rootns_create() system call to allocate a detached rootns
instance with dedicated empty mount (CLONE_EMPTY_MNTNS) and PID
namespaces and return its control file descriptor. Create fresh optional
namespaces selected in flags while inheriting unset ones from the
caller, and pin active references for the lifetime of the rootns. Leave
the newly created rootns in ROOTNS_EMPTY until userspace installs a root
mount.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/syscalls.h |   1 +
 kernel/rootns.c          | 139 +++++++++++++++++++++++++++++++++++++++
 kernel/sys_ni.c          |   3 +
 3 files changed, 143 insertions(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 552d9710a0d5..272d54bddbe2 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1006,6 +1006,7 @@ asmlinkage long sys_lsm_get_self_attr(unsigned int attr, struct lsm_ctx __user *
 asmlinkage long sys_lsm_set_self_attr(unsigned int attr, struct lsm_ctx __user *ctx,
 				      u32 size, u32 flags);
 asmlinkage long sys_lsm_list_modules(u64 __user *ids, u32 __user *size, u32 flags);
+asmlinkage long sys_rootns_create(unsigned int flags);
 
 /*
  * Architecture-specific system calls
diff --git a/kernel/rootns.c b/kernel/rootns.c
index e3b203322ae2..caa810b65d0d 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -145,3 +145,142 @@ void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk)
 	wake_up_poll(&c->waitq, EPOLLHUP);
 	put_rootns(c);
 }
+
+/*
+ * Create credentials for a rootns. Drop keyrings from the new credential to
+ * avoid unnecessary pinning.
+ */
+static const struct cred *create_rootns_creds(unsigned int flags)
+{
+	struct cred *new;
+	int ret;
+
+	new = prepare_creds();
+	if (!new)
+		return ERR_PTR(-ENOMEM);
+
+#ifdef CONFIG_KEYS
+	key_put(new->thread_keyring);
+	new->thread_keyring = NULL;
+	key_put(new->process_keyring);
+	new->process_keyring = NULL;
+	key_put(new->session_keyring);
+	new->session_keyring = NULL;
+	key_put(new->request_key_auth);
+	new->request_key_auth = NULL;
+#endif
+	if (!(flags & ROOTNS_USER))
+		return new;
+
+	ret = create_user_ns(new);
+	if (ret < 0)
+		goto err;
+	new->euid = new->user_ns->owner;
+	new->egid = new->user_ns->group;
+
+	new->uid = new->euid;
+	new->suid = new->euid;
+	new->fsuid = new->euid;
+	new->gid = new->egid;
+	new->sgid = new->egid;
+	new->fsgid = new->egid;
+	ret = set_cred_ucounts(new);
+	if (ret < 0)
+		goto err;
+	return new;
+
+err:
+	abort_creds(new);
+	return ERR_PTR(ret);
+}
+
+/*
+ * Create a new rootns.
+ */
+static struct rootns *create_rootns(unsigned int flags)
+{
+	u64 clone_flags = CLONE_NEWNS | CLONE_EMPTY_MNTNS | CLONE_NEWPID;
+	const struct cred *cred;
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
+	cred = create_rootns_creds(flags);
+	if (IS_ERR(cred)) {
+		ret = PTR_ERR(cred);
+		goto err_put;
+	}
+	c->cred = cred;
+	ns_ref_active_get(cred->user_ns);
+
+	if (!ns_capable(cred->user_ns, CAP_SYS_ADMIN)) {
+		ret = -EPERM;
+		goto err_put;
+	}
+
+	if (flags & ROOTNS_CGROUP)
+		clone_flags |= CLONE_NEWCGROUP;
+	if (flags & ROOTNS_UTS)
+		clone_flags |= CLONE_NEWUTS;
+	if (flags & ROOTNS_IPC)
+		clone_flags |= CLONE_NEWIPC;
+	if (flags & ROOTNS_NET)
+		clone_flags |= CLONE_NEWNET;
+
+	ns = create_new_namespaces(clone_flags, current->nsproxy, cred->user_ns,
+				   NULL);
+	if (IS_ERR(ns)) {
+		ret = PTR_ERR(ns);
+		goto err_put;
+	}
+
+	c->ns = ns;
+	ns->pid_ns_for_children->rootns = c;
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
+ * sys_rootns_create - Create a detached root namespace
+ * @flags: Combination of &enum rootns_flags values
+ *
+ * Allocate a detached root namespace with dedicated empty mount and PID
+ * namespaces plus any optional namespaces requested in @flags.
+ *
+ * Return: Control file descriptor on success, negative error code on failure.
+ */
+SYSCALL_DEFINE1(rootns_create, unsigned int, flags)
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
index c8be0abaa407..4a6c4337cc74 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -398,3 +398,6 @@ COND_SYSCALL(rseq_slice_yield);
 
 COND_SYSCALL(uretprobe);
 COND_SYSCALL(uprobe);
+
+/* kernel/rootns.c */
+COND_SYSCALL(rootns_create);
-- 
2.47.3

