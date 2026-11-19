Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795063401;
	b=KD047gYZt5WhYfWp5Kk4QVkN2K5VsEUSvCYwpqTN7a4zJRFMBZbaYurqK6HZHHyy0zce
	 RF/nSHRArnD9uWjQHriowU8OlN4PTbDxNK1M1O+tn4tJYwKOzsemYX7WExr0Tq0HK2eoz
	 r156rcewc9VLdraZuLzblAnk6xWp47kcJfkC25FbPD/88OOC+9h6mxs0DDs7iEKtuAEiW
	 VA7xwpatIHdR/wUQ9f1fFGTrCO2qMp4FzisntHFUPusLfM7vzZk1OpVi+f4Eg6apk1B4r
	 10rotE5FnkW/2PDyn2V/WtZqPw/UHVfOLoICzZ09O6Aq4KwHsvRvZeiqmAUvOj857CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795063401;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=3qIBW706vCH+xbsegS9DAcvOmwBcfVL0uF3NP/SPApw=;
	b=K6mH6MB0RlVF2/WXv3bchkkd3r3Dq/HN7rm7sn5DdiFMAxwICEn+CNGhQlGOKft0vr6h
	 5KkXeiTG6NKSaqG4ewAmC+snWrcNr0ulATe+1gF/yEd27cF57VT6A6Ua4VQzk2WuYpYmE
	 AeaSdnAZbIsAR0vUHSCzUOwlSsIvQh4jQMu5nK/Q0iY+8M9iSyFtU30e2RyHHdvhqaQAg
	 ja5p7BBBW9wZQ6+qRxASpmHvW/SvI6bzFbNtx87hW98Jul+LFdKtB8L0NiSEPmReFs/03
	 bikoXl9NS+4rNwepA/nsH9GGpW3RRYbMv8x9ikIv0pQk6ArPLXjqhnOM/wP3Uuku21g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k6NE64nM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 5863B606A320;
	Thu, 19 Nov 2026 04:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k6NE64nM
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 575001F000C4;
	Thu, 19 Nov 2026 04:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795063401;
	bh=3qIBW706vCH+xbsegS9DAcvOmwBcfVL0uF3NP/SPApw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k6NE64nMYM6EWewxJQjSiwlPPeA8R8tlT/Ho/0tAhHE5x3tX4HqTtsroETKzi6Mcf
	 4xB2cGtvPKMjVS56eM2ntO449uRBrApgQ0WOsSq32bUbvmF3rtXnY0U+GttJci4ObQ
	 K74/69fntBF1h25AceI8iRzcm2B8W+SSD6RtTpHyDiT6C0zzT4qNnGB8e1x9HvokRa
	 3X9e8LhGJkrH5rZB9Tu7yG0sG8Ba1yM9IiOIqh5dwsHMPmZJZtAE/h3mQQD6k9+6iy
	 HhLtgONuaVfRqSk+OF637ZvAkDdKezkrlBxe4g/bEdPUpudPS/9LWq1LE/gMIHKaKB
	 0t0dyhgPNKHgw==
Date: Thu, 19 Nov 2026 06:43:17 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
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
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
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
Subject: Re: [RFC PATCH v3 00/13] Namespace for namespace roots
Message-ID: <av5-Zc4xhgkPxb7p@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
 <av4CdM-eW73oO4wB@kernel.org>
 <av4NonrcCxzMoDyz@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/8xEWiKCEXzb99xi"
Content-Disposition: inline
In-Reply-To: <av4NonrcCxzMoDyz@kernel.org>


--/8xEWiKCEXzb99xi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 18, 2026 at 10:42:10PM +0200, Jarkko Sakkinen wrote:
> > I.e. before PID 1 and /proc/<pid>/ns/* existss, nsfd for namespace other
> > than root nsfd can be acquired as follows:
> > 
> > 	int mnts_fd = ioctl(root_fd, ROOTNS_GET_NSFD, CLONE_NEWNS);
> 
> 
> Unprivileged caller becomes the owner of rootns->user_ns. Each mount
> syscall then just checks CAP_SYS_ADMIN against rootns->user_ns.
> 
> The user space wiring goes along the lines of:
> 
>         int root_fd = rootns_create(ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC);
>         int mntns_fd = ioctl(root_fd, ROOTNS_GET_NSFD, CLONE_NEWNS);
> 
>         int tmpfs_fd = fsopen("tmpfs", 0);
>         fsconfig(tmpfs_fd, FSCONFIG_SET_ROOTNS, NULL, NULL, root_fd);
>         fsconfig(tmpfs_fd, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
>         int rootfs_fd = fsmount(tmpfs_fd, 0, 0);
> 
>         move_mount(rootfs_fd, "", mntns_fd, "/", MOVE_MOUNT_F_EMPTY_PATH | MOVE_MOUNT_T_MNTNS);
> 
>         struct clone_args args = {
>                 .flags  = CLONE_INTO_ROOTNS,
>                 .rootns = root_fd,
>         };
>         pid_t pid = clone3(&args, sizeof(args));


[BTW, this patch set is pointed out to David and not fsdevel mailing by a
 mishap, apologies.]

I reduced syscalls can be further to only a single syscall: rootns()

The complete API after this:

1. rootns(flags)
2. ioctl(rootfs_fd, ROOTNS_GET_NSFD, ns)
3. ioctl(rootfs_fd, ROOTNS_WAIT, NULL)
4. ioctl(rootfs_fd, ROOTNS_KILL, signum)

An updated version of the patch set is available over here:

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=rootns

In order to find more evidence that the API is trimmed and code has no
extra fat, I tried how LSM hooks size-fit.

Attached are the experimental LSM hooks and while possibly not exactly
right they should not be at least in the ballpar (Paul?).

Not perfect, but very usable, and there's a steady track of convergence
where resolving a bottleneck leads into a better symmetry and coherency
overall.

Br, Jarkko

--/8xEWiKCEXzb99xi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-security-Add-LSM-hooks-for-rootns.patch"

From a72fe460eab3ac1ef459ab6294515a0d665f94c2 Mon Sep 17 00:00:00 2001
From: Jarkko Sakkinen <jarkko@kernel.org>
Date: Thu, 19 Nov 2026 06:20:07 +0200
Subject: [PATCH] security: Add LSM hooks for rootns

Add lbs_rootns and rootns->security blob management LSM hooks:

1. security_rootns_alloc()
2. security_rootns_free()
3. security_rootns_clone(),
4. security_rootns_kill()

Register the new hooks in bpf_lsm.c's sleepable and untrusted hook sets.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/lsm_hook_defs.h |  7 +++
 include/linux/lsm_hooks.h     |  3 ++
 include/linux/rootns.h        |  3 ++
 include/linux/security.h      | 30 ++++++++++++
 kernel/bpf/bpf_lsm.c          | 10 ++++
 kernel/rootns.c               | 44 +++++++++++++-----
 security/lsm_init.c           |  6 +++
 security/security.c           | 86 +++++++++++++++++++++++++++++++++++
 8 files changed, 177 insertions(+), 12 deletions(-)

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
index 802fc76bb66e..795a79584231 100644
--- a/include/linux/rootns.h
+++ b/include/linux/rootns.h
@@ -31,6 +31,9 @@ enum rootns_state {
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
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 468e63dbd922..bbcf1433fdc2 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -16,6 +16,7 @@
 #include <linux/btf_ids.h>
 #include <linux/ima.h>
 #include <linux/bpf-cgroup.h>
+#include <linux/rootns.h>
 
 /* For every LSM hook that allows attachment of BPF programs, declare a nop
  * function where a BPF program can be attached. Notably, we qualify each with
@@ -404,6 +405,11 @@ BTF_ID(func, bpf_lsm_task_setscheduler)
 BTF_ID(func, bpf_lsm_userns_create)
 BTF_ID(func, bpf_lsm_bdev_alloc_security)
 BTF_ID(func, bpf_lsm_bdev_setintegrity)
+#ifdef CONFIG_ROOTNS
+BTF_ID(func, bpf_lsm_rootns_alloc)
+BTF_ID(func, bpf_lsm_rootns_clone)
+BTF_ID(func, bpf_lsm_rootns_kill)
+#endif /* CONFIG_ROOTNS */
 BTF_SET_END(sleepable_lsm_hooks)
 
 BTF_SET_START(untrusted_lsm_hooks)
@@ -420,6 +426,10 @@ BTF_ID(func, bpf_lsm_sk_free_security)
 BTF_ID(func, bpf_lsm_task_free)
 BTF_ID(func, bpf_lsm_bdev_alloc_security)
 BTF_ID(func, bpf_lsm_bdev_free_security)
+#ifdef CONFIG_ROOTNS
+BTF_ID(func, bpf_lsm_rootns_alloc)
+BTF_ID(func, bpf_lsm_rootns_free)
+#endif /* CONFIG_ROOTNS */
 BTF_SET_END(untrusted_lsm_hooks)
 
 bool bpf_lsm_is_sleepable_hook(u32 btf_id)
diff --git a/kernel/rootns.c b/kernel/rootns.c
index 8d90f68160ed..202bdf210699 100644
--- a/kernel/rootns.c
+++ b/kernel/rootns.c
@@ -51,6 +51,7 @@
 #include <linux/user_namespace.h>
 #include <linux/compat.h>
 #include <linux/idr.h>
+#include <linux/security.h>
 #include <uapi/linux/rootns.h>
 
 /*
@@ -62,14 +63,8 @@ struct rootns *get_rootns(struct rootns *c)
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
@@ -81,6 +76,18 @@ void put_rootns(struct rootns *c)
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
@@ -159,6 +166,7 @@ static int rootns_kill_members(struct rootns *rootns, int sig)
 	bool any_perm = false;
 	int other_err = 0;
 	struct pid *pid;
+	int ret;
 	int nr;
 
 	if (!pidns_is_ancestor(pid_ns, task_active_pid_ns(current)))
@@ -166,6 +174,10 @@ static int rootns_kill_members(struct rootns *rootns, int sig)
 	if (READ_ONCE(rootns->state) != ROOTNS_RUNNING)
 		return -ESRCH;
 
+	ret = security_rootns_kill(rootns, sig);
+	if (ret)
+		return ret;
+
 	scoped_guard(rcu) {
 		read_lock(&tasklist_lock);
 		idr_for_each_entry(&pid_ns->idr, pid, nr) {
@@ -361,31 +373,35 @@ static struct rootns *create_rootns(unsigned int flags)
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
 
@@ -478,6 +494,10 @@ int rootns_prepare_fork(struct kernel_clone_args *args)
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


--/8xEWiKCEXzb99xi--
