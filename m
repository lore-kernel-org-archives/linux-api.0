Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794892145;
	b=5bYlUCMAffEx4v08wkIjeAWFOtPRyQH7OU7NZ4Ue+zgQNg2Tev4RGnTCcEZf7Ah/38Ki
	 MkhTNs4Myk38gl9Vf9W0zErbE9L/t6ZhK/SMbslb+ac44lXguf0XQPJYuWAp8DxEtOx3+
	 JO36WaSn9zyBOXraV9CejIKV4YTFxYky17CczJEbD2xC5VLZTli/oMPRVUsjBuUjooP/9
	 r3B0qA+3ONoU+FI20rk7QA6cgWjxf8rNttnmSlago5M5hVItZFkyd2YSmYEXEYThnWBtI
	 4C78h53xlQoX3hMQzlHKefga7PmXfcw7E/i90C0mZH3lbHSgHkXt0YsQco5A4njNPsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794892145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=CS+W/Sr3iq8tSqh2G3aDEjOmCeOgF+I/s/FCQs9Mcyo=;
	b=HMS3bjSacQ+MkFKNs9lPteqd8PY8FS61cZdH3YMKdxwiN/kHSeDnOCHObEWrtLvHEgmL
	 LG4pSSs6cApGWQJvf6D+kIiE7PEVlwXoMEztEsVLMcJH7gHNZn1N7NkHhUWP2UOE3XkL/
	 rCwbDPMrV+bsGF78q4BRQVSUR08Y+bYU1ymxVqmXpMJYS5lapwcTueTuqjTFdF0nt2ghm
	 Re9Xd+oQyi37+uhcQcm8YCgbBrnTOlkMOZWnDQXLIgTr90FUO10yCvXal6FCS6goD2deZ
	 jbsvx2RNmTEYzrTNachyGVFFS56jC529PDOrRgTREDR4mEpTB5NnVqPPdASb5EhjQKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HXVxRvh5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 899E2606A329;
	Tue, 17 Nov 2026 05:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HXVxRvh5
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5D36D1F000C8;
	Tue, 17 Nov 2026 05:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892145;
	bh=CS+W/Sr3iq8tSqh2G3aDEjOmCeOgF+I/s/FCQs9Mcyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HXVxRvh5/fiQop5nr2M8zWvioC2N9tW9u+UlSmlPu6c5FtuV19rqyyUABQtbAy9rd
	 JxPzVmZz1Nhxzw6AE/6Yx+i+c4hVipACpTZSGz9rr9vwXaPz242LAZ8RHQU4Xtv7Fb
	 n0UoBPbdv4yQRjAoum2DKxTzpnYn5AhB4NP7UkG41uyFtK48cxIAcj6LG2W4MIrHMf
	 og1HbN12g+TnlNsRUIi5aNGEHxECitxOMbV7L0yubwBNNBu6RFhmQnKzWuTGI4ikGY
	 Rpf3jdre8anNqWDp5hafEPQdb2oA0SzBDF9d7Jg+TFhywxgT9q5CcVx8bcHAQNFHSX
	 d/rSDkUFNyBOA==
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
Subject: [RFC PATCH 04/13] rootns: Add rootns_create() system call
Date: Tue, 17 Nov 2026 07:08:32 +0200
Message-ID: <20261117050841.3289652-5-jarkko@kernel.org>
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
 kernel/rootns.c          | 140 +++++++++++++++++++++++++++++++++++++++
 kernel/sys_ni.c          |   3 +
 3 files changed, 144 insertions(+)

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
index e3b203322ae2..904d75ce9d90 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -145,3 +145,143 @@ void exit_rootns(struct pid_namespace *pid_ns, struct task_struct *tsk)
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
+	ns->rootns = c;
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

