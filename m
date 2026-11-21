Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219822;
	b=yFnireCyHb1nR/FYcHY22YwbOI9rE6tMnyHkmQHlv/VxUZMAc9SgQ2S5dkUK4+FzB1I+
	 GcnXjpa6S1CVhOMLgZT1BCmQyd8ouSUXz3v6z3KgK+ofTSprq+CBdjfV81624Di0lVbss
	 iYRIphzL8e8QPC+kIA9bVNXeHUu0hppaS9LkNj8JCNnzCKH2AQp5k+vyJ9WMA7qpzcCa4
	 bSwm+5XSzoO4VjCu1UDJetmeBq3q3A8A4VjtOdMCBxdPk3Vu+sM0cGD07yiQtz8A4UI0N
	 DMzfjTh05pKgbh5ZdLSozDVkEz0s3bD90hAiVpisvIJ8O8sEJm8/sjbLzcrqY6g/DJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Fv+4rTw2hN1zfy9KsnwOHnSYpn2531DaMXgpubCM6BE=;
	b=A4RZ23w828kA4G0dCuPDq8cUsAyyZuc2+xzwt5YRdrQ8HMT3IoTy7cBye0YxmaUS8jbt
	 sIp0BxMMvvGLS/NRwsxUTqEvm8t75gMvBeo57R0WfGGaqFB+s2tyB22hFcnW4wmaR7bW0
	 eyhK17dE9mGeU5WP/6FiWd0O72eTq3cQA0Xd/TrI/DHtFJP4PgK6FamokAhXHHRljLr/u
	 niXTNu5/oqyXucNzgmZgUvfzQVeDxLjRMJOU1iX33hUhsuHTHo4TOMZHKqCCrBacyMygj
	 z5PAIJnCPXIKHQYfhUZMp4+G19GdQ1yBuMVJbJXcNaI+NtCrX/KM/gkLNEeqZd2utFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QHmCpSNi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 54DDA606A699;
	Sat, 21 Nov 2026 00:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QHmCpSNi
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 361621F000D2;
	Sat, 21 Nov 2026 00:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219821;
	bh=Fv+4rTw2hN1zfy9KsnwOHnSYpn2531DaMXgpubCM6BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QHmCpSNi5+s2VCw6nAr8zwsBFvo9+GDOMY92DDhxqDWH5XcKurQ4h/9XEoBkpchwm
	 6pqeAPxWEQ1PiiBDWOB87AMs/upAJkB1UyE6R0M69FIljrbSqk5z4ym0MN2jBD+mtn
	 BZ9TvgU+2VamFdf1innh8LeyXEcvCmy3zHuV46epEa8yuDBbQS0yYgb7Zx4uBDxEz/
	 7q6xwmUT5b6IvZ/w9lX1/KtgDGGX6YC+LKc5mVobFr55Oisedr4fiNKyPAwcOcFPYR
	 VNPa1aQl9YgueiI3a815AVmj6I+9w6ApbxP/eHxy+tM2Rad3gCTo0XNAd8tNNeUtw1
	 GrXNckhTs5KBQ==
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
Subject: [RFC PATCH v5 20/25] security: Add rootns LSM hooks
Date: Sat, 21 Nov 2026 02:08:39 +0200
Message-ID: <20261121000844.1863324-21-jarkko@kernel.org>
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

Security modules need visibility into root namespace creation, teardown,
process entry, and container-wide signal delivery so policies can attach
per-rootns security state and mediate operations on rootns file
descriptors.

Add lbs_rootns and rootns->security blob management alongside
security_rootns_alloc(), security_rootns_free(), security_rootns_clone(),
and security_rootns_kill().

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/lsm_hook_defs.h |  7 +++
 include/linux/lsm_hooks.h     |  3 ++
 include/linux/rootns.h        |  3 ++
 include/linux/security.h      | 30 ++++++++++++
 kernel/rootns.c               | 44 +++++++++++++-----
 security/lsm_init.c           |  6 +++
 security/security.c           | 86 +++++++++++++++++++++++++++++++++++
 7 files changed, 167 insertions(+), 12 deletions(-)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 87d9d06710cb..2cb90ddedc14 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -480,3 +480,10 @@ LSM_HOOK(int, 0, bdev_alloc_security, struct block_device *bdev)
 LSM_HOOK(void, LSM_RET_VOID, bdev_free_security, struct block_device *bdev)
 LSM_HOOK(int, 0, bdev_setintegrity, struct block_device *bdev,
 	 enum lsm_integrity_type type, const void *value, size_t size)
+
+#ifdef CONFIG_ROOTNS
+LSM_HOOK(int, 0, rootns_alloc, struct rootns *rootns, unsigned int flags)
+LSM_HOOK(void, LSM_RET_VOID, rootns_free, struct rootns *rootns)
+LSM_HOOK(int, 0, rootns_clone, struct rootns *rootns)
+LSM_HOOK(int, 0, rootns_kill, struct rootns *rootns, int sig)
+#endif /* CONFIG_ROOTNS */
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 13621e9e233e..217a59d428b1 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -121,6 +121,9 @@ struct lsm_blob_sizes {
 	unsigned int lbs_bpf_map;
 	unsigned int lbs_bpf_prog;
 	unsigned int lbs_bpf_token;
+#ifdef CONFIG_ROOTNS
+	unsigned int lbs_rootns;
+#endif
 };
 
 /*
diff --git a/include/linux/rootns.h b/include/linux/rootns.h
index 68590b27e4ee..1301bc6961f1 100644
--- a/include/linux/rootns.h
+++ b/include/linux/rootns.h
@@ -32,6 +32,9 @@ enum rootns_state {
 struct rootns {
 	refcount_t		usage;
 	int			exit_code;	/* The exit code of 'init' */
+#ifdef CONFIG_SECURITY
+	void			*security;	/* LSM security blob */
+#endif
 	struct user_namespace	*user_ns;	/* Owning user namespace */
 	struct nsproxy		*ns;		/* This rootns's namespaces */
 	struct pid		*init_pid;	/* The 'init' task's TGID (pid ref) */
diff --git a/include/linux/security.h b/include/linux/security.h
index 40831fab5470..995292f1c92e 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -84,6 +84,7 @@ struct audit_krule;
 struct ns_common;
 struct user_namespace;
 struct timezone;
+struct rootns;
 
 enum lsm_event {
 	LSM_POLICY_CHANGE,
@@ -2469,4 +2470,33 @@ static inline void security_initramfs_populated(void)
 }
 #endif /* CONFIG_SECURITY */
 
+#ifdef CONFIG_ROOTNS
+#ifdef CONFIG_SECURITY
+int security_rootns_alloc(struct rootns *rootns, unsigned int flags);
+void security_rootns_free(struct rootns *rootns);
+int security_rootns_clone(struct rootns *rootns);
+int security_rootns_kill(struct rootns *rootns, int sig);
+#else
+static inline int security_rootns_alloc(struct rootns *rootns,
+					unsigned int flags)
+{
+	return 0;
+}
+
+static inline void security_rootns_free(struct rootns *rootns)
+{
+}
+
+static inline int security_rootns_clone(struct rootns *rootns)
+{
+	return 0;
+}
+
+static inline int security_rootns_kill(struct rootns *rootns, int sig)
+{
+	return 0;
+}
+#endif /* CONFIG_SECURITY */
+#endif /* CONFIG_ROOTNS */
+
 #endif /* ! __LINUX_SECURITY_H */
diff --git a/kernel/rootns.c b/kernel/rootns.c
index 6fb49c20cc2d..bf3174023d97 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -54,6 +54,7 @@
 #include <linux/user_namespace.h>
 #include <linux/compat.h>
 #include <linux/idr.h>
+#include <linux/security.h>
 #include <uapi/linux/rootns.h>
 
 /*
@@ -65,14 +66,8 @@ struct rootns *get_rootns(struct rootns *c)
 	return c;
 }
 
-/*
- * Drop a reference on a rootns and clear it if it is no longer in use.
- */
-void put_rootns(struct rootns *c)
+static void free_rootns(struct rootns *c)
 {
-	if (!c || !refcount_dec_and_test(&c->usage))
-		return;
-
 	if (c->ns)
 		put_nsproxy(c->ns);
 	if (c->init_pid)
@@ -84,6 +79,18 @@ void put_rootns(struct rootns *c)
 	kfree(c);
 }
 
+/*
+ * Drop a reference on a rootns and clear it if it is no longer in use.
+ */
+void put_rootns(struct rootns *c)
+{
+	if (!c || !refcount_dec_and_test(&c->usage))
+		return;
+
+	security_rootns_free(c);
+	free_rootns(c);
+}
+
 /*
  * Allow the user to poll for the rootns dying.
  */
@@ -167,6 +174,7 @@ static int rootns_kill_members(struct rootns *rootns, int sig)
 	bool any_perm = false;
 	int other_err = 0;
 	struct pid *pid;
+	int ret;
 	int nr;
 
 	if (!pidns_is_ancestor(pid_ns, task_active_pid_ns(current)))
@@ -174,6 +182,10 @@ static int rootns_kill_members(struct rootns *rootns, int sig)
 	if (READ_ONCE(rootns->state) != ROOTNS_RUNNING)
 		return -ESRCH;
 
+	ret = security_rootns_kill(rootns, sig);
+	if (ret)
+		return ret;
+
 	scoped_guard(rcu) {
 		read_lock(&tasklist_lock);
 		idr_for_each_entry(&pid_ns->idr, pid, nr) {
@@ -368,31 +380,35 @@ static struct rootns *create_rootns(unsigned int flags)
 	user_ns = create_rootns_user_ns();
 	if (IS_ERR(user_ns)) {
 		ret = PTR_ERR(user_ns);
-		goto err_put;
+		goto err_free;
 	}
 	c->user_ns = user_ns;
 	ns_ref_active_get(user_ns);
 
 	if (!ns_capable(user_ns, CAP_SYS_ADMIN)) {
 		ret = -EPERM;
-		goto err_put;
+		goto err_free;
 	}
 
 	ns = create_new_namespaces(clone_flags, current->nsproxy, user_ns,
 				   NULL);
 	if (IS_ERR(ns)) {
 		ret = PTR_ERR(ns);
-		goto err_put;
+		goto err_free;
 	}
 
 	timens_activate_nsproxy(ns);
 	c->ns = ns;
 	nsproxy_ns_active_get(ns);
 
+	ret = security_rootns_alloc(c, flags);
+	if (ret < 0)
+		goto err_free;
+
 	return c;
 
-err_put:
-	put_rootns(c);
+err_free:
+	free_rootns(c);
 	return ERR_PTR(ret);
 }
 
@@ -488,6 +504,10 @@ int rootns_prepare_fork(struct kernel_clone_args *args)
 	if (!pidns_is_ancestor(pid_ns, task_active_pid_ns(current)))
 		return -EXDEV;
 
+	ret = security_rootns_clone(rootns);
+	if (ret)
+		return ret;
+
 	ret = mnt_ns_get_root(rootns->ns->mnt_ns, &root);
 	if (ret)
 		return ret;
diff --git a/security/lsm_init.c b/security/lsm_init.c
index 8d5ecea99c46..56b515b20812 100644
--- a/security/lsm_init.c
+++ b/security/lsm_init.c
@@ -316,6 +316,9 @@ static void __init lsm_prepare(struct lsm_info *lsm)
 	lsm_blob_size_update(&blobs->lbs_bpf_map, &blob_sizes.lbs_bpf_map);
 	lsm_blob_size_update(&blobs->lbs_bpf_prog, &blob_sizes.lbs_bpf_prog);
 	lsm_blob_size_update(&blobs->lbs_bpf_token, &blob_sizes.lbs_bpf_token);
+#ifdef CONFIG_ROOTNS
+	lsm_blob_size_update(&blobs->lbs_rootns, &blob_sizes.lbs_rootns);
+#endif
 }
 
 /**
@@ -460,6 +463,9 @@ int __init security_init(void)
 		lsm_pr("blob(bpf_map) size %d\n", blob_sizes.lbs_bpf_map);
 		lsm_pr("blob(bpf_prog) size %d\n", blob_sizes.lbs_bpf_prog);
 		lsm_pr("blob(bpf_token) size %d\n", blob_sizes.lbs_bpf_token);
+#ifdef CONFIG_ROOTNS
+		lsm_pr("blob(rootns) size %d\n", blob_sizes.lbs_rootns);
+#endif
 	}
 
 	if (blob_sizes.lbs_file)
diff --git a/security/security.c b/security/security.c
index 4727b8347fc4..919d4bb63701 100644
--- a/security/security.c
+++ b/security/security.c
@@ -30,6 +30,7 @@
 #include <linux/overflow.h>
 #include <linux/perf_event.h>
 #include <linux/fs.h>
+#include <linux/rootns.h>
 #include <net/flow.h>
 #include <net/sock.h>
 
@@ -395,6 +396,22 @@ static int lsm_ns_alloc(struct ns_common *ns)
 	return lsm_blob_alloc(&ns->ns_security, blob_sizes.lbs_ns, GFP_KERNEL);
 }
 
+#ifdef CONFIG_ROOTNS
+/**
+ * lsm_rootns_alloc - allocate a composite rootns blob
+ * @rootns: the rootns that needs a blob
+ *
+ * Allocate the rootns blob for all the modules
+ *
+ * Return: Returns 0, or -ENOMEM if memory can't be allocated.
+ */
+static int lsm_rootns_alloc(struct rootns *rootns)
+{
+	return lsm_blob_alloc(&rootns->security, blob_sizes.lbs_rootns,
+			      GFP_KERNEL);
+}
+#endif /* CONFIG_ROOTNS */
+
 /**
  * lsm_fill_user_ctx - Fill a user space lsm_ctx structure
  * @uctx: a userspace LSM context to be filled
@@ -5795,3 +5812,72 @@ void security_initramfs_populated(void)
 {
 	call_void_hook(initramfs_populated);
 }
+
+#ifdef CONFIG_ROOTNS
+/**
+ * security_rootns_alloc() - Check creation of a new rootns and init LSM blob
+ * @rootns: the new rootns
+ * @flags: creation flags passed to rootns()
+ *
+ * Check whether a new rootns may be created and initialize its LSM security
+ * blob.
+ *
+ * Return: Returns 0 on success, negative error code on failure.
+ */
+int security_rootns_alloc(struct rootns *rootns, unsigned int flags)
+{
+	int rc;
+
+	rc = lsm_rootns_alloc(rootns);
+	if (unlikely(rc))
+		return rc;
+
+	rc = call_int_hook(rootns_alloc, rootns, flags);
+	if (unlikely(rc))
+		security_rootns_free(rootns);
+
+	return rc;
+}
+
+/**
+ * security_rootns_free() - Release LSM security data from a rootns
+ * @rootns: the rootns being freed
+ *
+ * Release security data attached to @rootns before the structure is freed.
+ */
+void security_rootns_free(struct rootns *rootns)
+{
+	call_void_hook(rootns_free, rootns);
+	kfree(rootns->security);
+	rootns->security = NULL;
+}
+
+/**
+ * security_rootns_clone() - Check permission to spawn a task into a rootns
+ * @rootns: the target rootns
+ *
+ * Check permission before spawning a child process into @rootns via
+ * clone3(CLONE_INTO_ROOTNS).
+ *
+ * Return: Returns 0 if permission is granted, negative error code on failure.
+ */
+int security_rootns_clone(struct rootns *rootns)
+{
+	return call_int_hook(rootns_clone, rootns);
+}
+
+/**
+ * security_rootns_kill() - Check permission to signal a rootns
+ * @rootns: the target rootns
+ * @sig: signal number to deliver (or 0 for permission check)
+ *
+ * Check permission before broadcasting @sig to member thread groups in @rootns
+ * via ioctl(ROOTNS_KILL).
+ *
+ * Return: Returns 0 if permission is granted, negative error code on failure.
+ */
+int security_rootns_kill(struct rootns *rootns, int sig)
+{
+	return call_int_hook(rootns_kill, rootns, sig);
+}
+#endif /* CONFIG_ROOTNS */
-- 
2.47.3

