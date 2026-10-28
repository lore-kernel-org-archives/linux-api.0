Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793225909;
	b=0xFVdOXlvaf2MSL5FZ/2yOPZkSBwYxBYnQWaJbrvIwI7k5rqalE83wNmFaVQJ1tvLQwg
	 uyiPgoJrrY3EQqhR9EJmRI8+Ka8oBLpxWTI4Enli3pE2JuLsGPNBR5teBdI8akoGGW+I2
	 N7cWOj7j8RjQUsibNxT/h4l5aGJTAcI0FgTQ7k/Rr7NhOTmimqyVqKLMdhy839bSENOCJ
	 jQ19PcAfeuNS4hbwr9Ld7IoLAlPFdseHsDwGRlIlp/DTVO1shHlsKYLjYXFq7P21pHZFM
	 WlzpWPThZzARAGTwnhtT9SvBbQThZiP820w2D5fPLLVEqRGx+G2+33vp9r6NJxBXP1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793225909;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=I/ZYYIcrC5oBnGUKKa5wL3lWDWpXYu+7qOwpTlnRuRw=;
	b=3+w6uN9V+Xph4th7ThwqZoLJ746fJz5zfRT3B6vJ1Khr/DlOinZnABLispgGsWeoZkA8
	 29C4O93exrHf+Xk99ncPGLmg35j6k0+wjatukqcOfkgAakXcDcwphYj+frHKKrcWGL2yl
	 p4tHaU5l909kqsBO5LQHEXhH3auNP3DQsLtj9bsBybxDqYngkEDJxXaDGbc3G9Zrw4CNf
	 E60ovbT227gwRKWv7wnR5AnyoPr/xmFKmG1bmS/dr77jCERBckJIeRd/yRW2gibzN3J5N
	 rCkrlB6oqMxCbPxVFMTK0BP+UlbhWQn39583kWnaglhsfsNUJMTOu/xGbhHE2zATXrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--halg.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CS4PVQ9p;
	arc=none smtp.remote-ip=209.85.208.70
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8D560A2606
	for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 22:18:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B8D560A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--halg.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CS4PVQ9p
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6b1d43907c2so1910194a12.0
        for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 15:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793225894; x=1793830694; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I/ZYYIcrC5oBnGUKKa5wL3lWDWpXYu+7qOwpTlnRuRw=;
        b=CS4PVQ9pMpggaF2ahRgFF/JfGzTGeOdH8F6qRhs6FJ+Gjmj0lrNjaWru1t7xeNO2GC
         NmEzooz1cXRFyTPBdCgAci6K2J5Yh7KB8RjbJ6q1SS0uED2G3cfW+CKnFa3NPz0Mxp0B
         xfE6hqGLDEw3Zkk2UdtHbPOPKxpeafhQCYYrU5+IZdmVg3eBoZRJGVXbWcy8ET9O+jI8
         vDUEqYbP0nEUETLR7iE4fMrWU4yx+KO/DyJrtmThHTytZ8FxDpjSVCkHSu4z81bDzok+
         BptuOnx/Yjj9pMjkLT7lO6FijkdKUpyIDnW6H88m158BwvmBQTJKgXzmLYYaL70E5SJ2
         Rasg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793225894; x=1793830694;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I/ZYYIcrC5oBnGUKKa5wL3lWDWpXYu+7qOwpTlnRuRw=;
        b=JSbLc+5Rc34N37F7ng5oN2yjeCbrykuZa7Z8oTHYGfK6W5jYNUNCR+pK+I2fT5ZMH8
         E3IV7pPYopFoDjrJpv9e/Bp6uwwGs/fK6EOXkgzIs8nzq3MYTz8FQeILzMD1UjewvFUE
         A29kEGFE18KU2bJa01IXt8KYng/A85Nt0D76TZJdkTFTG/eoyNkoRnpQ/PbcAFjT82PU
         Qr4xKjJGMw+VAS4AZyGyv/vwBdhPxBpQEEladg0XKc9P4hiXuiEe+A/97LoOXd3jbyyR
         aOnO3vCO0zUQMGkzLTUcfnWneetgwZaiJCn5GXkYGc0UC2xZR7c7W3d0O1lQXpi8zuoY
         dFPg==
X-Forwarded-Encrypted: i=1; AKwUvBy4/drZBFTgho2Nc60dDukub71CVU/E/kp4inifRWqf/aOP+B1Zu9CWb3YTZ6ZUY3IUroYyfbI4W2A=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ8P7G223QKgSPRexsgxkDj7W+sJGnHPKuD+2bIL2kvyMHPKhOY
	XsgY88PPRDGKg0GJY+3VfuF28NS0XifHmApu4ab6CNX//xLJGKCqnDENqOz38FfVg7AoI3etTQ=
	=
X-Received: from edtu10.prod.google.com ([2002:aa7:db8a:0:b0:6b4:92f8:2825])
 (user=halg job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:1945:b0:6ac:73f8:2e4f
 with SMTP id 4fb4d7f45d1cf-6b49cb7d69amr2368103a12.29.1793225893694; Wed, 28
 Oct 2026 15:18:13 -0700 (PDT)
Date: Wed, 28 Oct 2026 22:17:00 +0000
In-Reply-To: <20261028221705.3915340-1-halg@google.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261028221705.3915340-1-halg@google.com>
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028221705.3915340-4-halg@google.com>
Subject: [PATCH 3/8] userns: allow restricting capability bounding set via clone3()
From: "Hallgrimur H. Gunnarsson" <halg@google.com>
To: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Jan Kara <jack@suse.cz>, James Morris <jmorris@namei.org>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	"=?UTF-8?q?G=C3=BCnther=20Noack?=" <gnoack@google.com>, KP Singh <kpsingh@kernel.org>, 
	Jonathan Calmels <jcalmels@3xx0.net>, Casey Schaufler <casey@schaufler-ca.com>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-api@vger.kernel.org, containers@lists.linux.dev, netdev@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Hallgrimur H. Gunnarsson" <halg@google.com>
Content-Type: text/plain; charset="UTF-8"

While the unprivileged_userns_caps_allowed sysctl enforces a
system-wide capability ceiling for unprivileged users, the
clone3() support allows sandboxes and container runtimes to
voluntarily restrict the capability bounding set of a new user
namespace on a per-namespace basis.

Introduce the CLONE_NEWUSER_BSET flag and add a cap_bset field
to struct clone_args (CLONE_ARGS_SIZE_VER3). When specified alongside
CLONE_NEWUSER, the new user namespace's capability bounding set is
intersected with cap_bset in addition to the parent namespace's
bounding set and any applicable unprivileged sysctl ceiling.

Signed-off-by: Hallgrimur H. Gunnarsson <halg@google.com>
---
 Documentation/admin-guide/sysctl/kernel.rst |  5 +++++
 include/linux/cred.h                        |  3 ++-
 include/linux/sched/task.h                  |  1 +
 include/linux/user_namespace.h              |  4 ++--
 include/uapi/linux/sched.h                  |  7 +++++++
 kernel/cred.c                               | 10 ++++++++--
 kernel/fork.c                               | 18 +++++++++++++++---
 kernel/user_namespace.c                     | 11 +++++++----
 8 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/admin-guide/sysctl/kernel.rst
index 25fe46e7724b..4b6654e89c6d 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -1709,6 +1709,11 @@ Privileged creators (holding ``CAP_SYS_ADMIN`` in the parent namespace) are
 unaffected by this ceiling and inherit the parent namespace's bounding set
 unmodified.
 
+Regardless of privilege level, a creator using ``clone3(2)`` with the
+``CLONE_NEWUSER_BSET`` flag can further restrict the new namespace's
+bounding set by specifying a ``cap_bset`` mask in ``struct clone_args``,
+which is intersected with the resulting bounding set.
+
 Upon entering a user namespace during creation or via ``setns(2)``,
 the task's permitted, effective, and bounding capability sets are clamped
 to the namespace's bounding set. Tasks inside the namespace cannot exceed
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 6ef1750c93e2..39eeb1584ef7 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -19,6 +19,7 @@
 
 struct cred;
 struct inode;
+struct kernel_clone_args;
 
 extern struct task_struct init_task;
 
@@ -150,9 +151,9 @@ struct cred {
 	};
 } __randomize_layout;
 
+int copy_creds(struct task_struct *p, const struct kernel_clone_args *kargs);
 extern void __put_cred(struct cred *);
 extern void exit_creds(struct task_struct *);
-extern int copy_creds(struct task_struct *, u64);
 extern const struct cred *get_task_cred(struct task_struct *);
 extern struct cred *cred_alloc_blank(void);
 extern struct cred *prepare_creds(void);
diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index e0c1ca8c6a18..498db7adce5f 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -45,6 +45,7 @@ struct kernel_clone_args {
 	struct cgroup *cgrp;
 	struct css_set *cset;
 	unsigned int kill_seq;
+	u64 cap_bset;
 };
 
 /*
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index a0ccfb93f2a7..a584ee5775af 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -194,7 +194,7 @@ static inline bool userns_has_cap(const struct user_namespace *ns, int cap)
 	return cap_raised(ns->cap_bset, cap);
 }
 
-extern int create_user_ns(struct cred *new);
+int create_user_ns(struct cred *new, kernel_cap_t req_bset);
 extern int unshare_userns(unsigned long unshare_flags, struct cred **new_cred);
 extern void __put_user_ns(struct user_namespace *ns);
 
@@ -230,7 +230,7 @@ static inline bool userns_has_cap(const struct user_namespace *ns, int cap)
 	return true;
 }
 
-static inline int create_user_ns(struct cred *new)
+static inline int create_user_ns(struct cred *new, kernel_cap_t req_bset)
 {
 	return -EINVAL;
 }
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index efd00d9f8bd3..10e4a4733005 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -41,6 +41,7 @@
 #define CLONE_PIDFD_AUTOKILL	(1ULL << 36) /* Kill child when clone pidfd closes. */
 #define CLONE_EMPTY_MNTNS	(1ULL << 37) /* Create an empty mount namespace. */
 #define CLONE_NEWNET_LOOPBACK	(1ULL << 38) /* Create network namespace with loopback UP. */
+#define CLONE_NEWUSER_BSET	(1ULL << 39) /* Set userns capability bounding set. */
 
 /*
  * cloning flags intersect with CSIGNAL so can be used with unshare and clone3
@@ -96,6 +97,10 @@
  *                kernel's limit of nested PID namespaces.
  * @cgroup:       If CLONE_INTO_CGROUP is specified set this to
  *                a file descriptor for the cgroup.
+ * @cap_bset:     If CLONE_NEWUSER_BSET is specified, this
+ *                specifies the capability bounding set mask to
+ *                apply to the new user namespace. Unknown
+ *                capability bits (> CAP_LAST_CAP) are ignored.
  *
  * The structure is versioned by size and thus extensible.
  * New struct members must go at the end of the struct and
@@ -113,12 +118,14 @@ struct clone_args {
 	__aligned_u64 set_tid;
 	__aligned_u64 set_tid_size;
 	__aligned_u64 cgroup;
+	__aligned_u64 cap_bset;
 };
 #endif
 
 #define CLONE_ARGS_SIZE_VER0 64 /* sizeof first published struct */
 #define CLONE_ARGS_SIZE_VER1 80 /* sizeof second published struct */
 #define CLONE_ARGS_SIZE_VER2 88 /* sizeof third published struct */
+#define CLONE_ARGS_SIZE_VER3 96 /* sizeof fourth published struct */
 
 /*
  * Scheduling policies
diff --git a/kernel/cred.c b/kernel/cred.c
index 3df4e15bd67f..20f37a351602 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -260,8 +260,9 @@ struct cred *prepare_exec_creds(void)
  * The new process gets the current process's subjective credentials as its
  * objective and subjective credentials
  */
-int copy_creds(struct task_struct *p, u64 clone_flags)
+int copy_creds(struct task_struct *p, const struct kernel_clone_args *kargs)
 {
+	u64 clone_flags = kargs->flags;
 	struct cred *new;
 	int ret;
 
@@ -288,7 +289,12 @@ int copy_creds(struct task_struct *p, u64 clone_flags)
 		return -ENOMEM;
 
 	if (clone_flags & CLONE_NEWUSER) {
-		ret = create_user_ns(new);
+		kernel_cap_t cap_bset = CAP_FULL_SET;
+
+		if (clone_flags & CLONE_NEWUSER_BSET)
+			cap_bset = (kernel_cap_t){ .val = kargs->cap_bset };
+
+		ret = create_user_ns(new, cap_bset);
 		if (ret < 0)
 			goto error_put;
 		ret = set_cred_ucounts(new);
diff --git a/kernel/fork.c b/kernel/fork.c
index c0f7520e754a..a09f62cadeac 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2168,7 +2168,7 @@ __latent_entropy struct task_struct *copy_process(
 #ifdef CONFIG_PROVE_LOCKING
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
-	retval = copy_creds(p, clone_flags);
+	retval = copy_creds(p, args);
 	if (retval < 0)
 		goto bad_fork_free;
 
@@ -2932,7 +2932,9 @@ static noinline int copy_clone_args_from_user(struct kernel_clone_args *kargs,
 		     CLONE_ARGS_SIZE_VER1);
 	BUILD_BUG_ON(offsetofend(struct clone_args, cgroup) !=
 		     CLONE_ARGS_SIZE_VER2);
-	BUILD_BUG_ON(sizeof(struct clone_args) != CLONE_ARGS_SIZE_VER2);
+	BUILD_BUG_ON(offsetofend(struct clone_args, cap_bset) !=
+		     CLONE_ARGS_SIZE_VER3);
+	BUILD_BUG_ON(sizeof(struct clone_args) != CLONE_ARGS_SIZE_VER3);
 
 	if (unlikely(usize > PAGE_SIZE))
 		return -E2BIG;
@@ -2962,6 +2964,11 @@ static noinline int copy_clone_args_from_user(struct kernel_clone_args *kargs,
 	    (args.cgroup > INT_MAX || usize < CLONE_ARGS_SIZE_VER2))
 		return -EINVAL;
 
+	if ((args.flags & CLONE_NEWUSER_BSET) && usize < CLONE_ARGS_SIZE_VER3)
+		return -EINVAL;
+	if (!(args.flags & CLONE_NEWUSER_BSET) && args.cap_bset)
+		return -EINVAL;
+
 	*kargs = (struct kernel_clone_args){
 		.flags		= args.flags,
 		.pidfd		= u64_to_user_ptr(args.pidfd),
@@ -2973,6 +2980,7 @@ static noinline int copy_clone_args_from_user(struct kernel_clone_args *kargs,
 		.tls		= args.tls,
 		.set_tid_size	= args.set_tid_size,
 		.cgroup		= args.cgroup,
+		.cap_bset	= args.cap_bset & CAP_VALID_MASK,
 	};
 
 	if (args.set_tid &&
@@ -3020,7 +3028,7 @@ static bool clone3_args_valid(struct kernel_clone_args *kargs)
 	    ~(CLONE_LEGACY_FLAGS | CLONE_CLEAR_SIGHAND |
 	      CLONE_INTO_CGROUP | CLONE_AUTOREAP | CLONE_NNP |
 	      CLONE_PIDFD_AUTOKILL | CLONE_EMPTY_MNTNS |
-	      CLONE_NEWNET_LOOPBACK))
+	      CLONE_NEWNET_LOOPBACK | CLONE_NEWUSER_BSET))
 		return false;
 
 	/*
@@ -3038,6 +3046,10 @@ static bool clone3_args_valid(struct kernel_clone_args *kargs)
 	    kargs->exit_signal)
 		return false;
 
+	if ((kargs->flags & CLONE_NEWUSER_BSET) &&
+	    !(kargs->flags & CLONE_NEWUSER))
+		return false;
+
 	if (!clone3_stack_valid(kargs))
 		return false;
 
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 92f489e268a8..6e95dd1a1d04 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -143,7 +143,7 @@ static unsigned long enforced_nproc_rlimit(void)
  * This is called by copy_creds(), which will finish setting the target task's
  * credentials.
  */
-int create_user_ns(struct cred *new)
+int create_user_ns(struct cred *new, kernel_cap_t req_bset)
 {
 	struct user_namespace *ns, *parent_ns = new->user_ns;
 	kuid_t owner = new->euid;
@@ -184,15 +184,18 @@ int create_user_ns(struct cred *new)
 		goto fail_dec;
 
 	/*
+	 * Intersect the parent's bounding set with any voluntary
+	 * restrictions requested via clone3().
+	 *
 	 * If the caller has CAP_SYS_ADMIN in the parent namespace,
-	 * they are a privileged creator and inherit the parent's
+	 * they are a privileged creator and inherit this resulting
 	 * bounding set directly.
 	 *
 	 * Otherwise, enforce the unprivileged bounding ceiling, but
 	 * allow the child namespace to retain any capabilities the
 	 * creator already holds.
 	 */
-	cap_bset = parent_ns->cap_bset;
+	cap_bset = cap_intersect(parent_ns->cap_bset, req_bset);
 	if (!ns_capable_noaudit(parent_ns, CAP_SYS_ADMIN)) {
 		kernel_cap_t unpriv_bset = READ_ONCE(sysctl_unpriv_userns_bset);
 		kernel_cap_t allowed = cap_combine(unpriv_bset,
@@ -267,7 +270,7 @@ int unshare_userns(unsigned long unshare_flags, struct cred **new_cred)
 
 	cred = prepare_creds();
 	if (cred) {
-		err = create_user_ns(cred);
+		err = create_user_ns(cred, CAP_FULL_SET);
 		if (err)
 			put_cred(cred);
 		else
-- 
2.56.0.313.g2479322e68-goog

