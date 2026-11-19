Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795084975;
	b=helknvgc1g286l0ro+Q/TEQYgiRWbor67Its860hnEBGDCx1qhlYxClLIJbMFSwHt22/
	 jEcMHfkxAr9Ty8aYIYggbvMYR7Z6Zv2TW3VAXJKdtuhoIPV7vzcoP4PlJL4EiWUuxBTdt
	 +SXhLGDqteEdDvwzX8ddDgGtOwjFrp9JKrxgXS+nNoJf01l4EC8RgqkNsD8Jxvpo0l77V
	 tund0E1OgK+13yVxUhMw4bdaIk/ql2WxaqFzBIVDpe4z26inY6kJzlApvoIZ2P1goHPmd
	 tFSgx+AN8JsORk/tw6DItEScytaA3TFTCQaf7GNs6IunRNWsCzv1UfzFY5fevvjReEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795084975;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=mOW7ofy1LPlD15OpqWHQo9AwJhFfzJjmQIKIkC51Z3w=;
	b=dUurj0+d2EFLs5a7t/etcW3+t06fw4x1gy7HJu3EimZorotOiHYjd/OiqHD9FMmpHw+R
	 OcSMacC1co80+RtVcfgAd4parUpLyymW08N/70iyPWL+eXH9Qf5X7/J7kO3a57VvgDGVP
	 eP9JT1Z/KscRY5UICh1ShctAYzovvSDfxIkvwcRU+O6XHcvrYwgEcTV1ImETYLs9jB6Wx
	 uB6hZo9qohgh03sdBhHoLIyqf0z45tIgzb+Gui8XbHgxARpb9YQ4l3F3ulzxI4fxX7BkD
	 UFwc2m2q63JXkYuBspo/TOST9ydjDAmEmaeQlQHO8w95/UFx19Vn7vR0mLRT9ZMPVOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--halg.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Qr+SY+44;
	arc=none smtp.remote-ip=209.85.208.70
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAFC60A260D
	for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 10:42:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BAFC60A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--halg.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Qr+SY+44
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6b77cb01733so1894845a12.3
        for <linux-api@vger.kernel.org>; Thu, 19 Nov 2026 02:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795084970; x=1795689770; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mOW7ofy1LPlD15OpqWHQo9AwJhFfzJjmQIKIkC51Z3w=;
        b=Qr+SY+441tWmYJHirCAOL4CEA2BSz1czUGSTzmM0UEk2DUwt94lx+M5Ineci7N9ioN
         +TpEDBKqU9G55bY5SfTkO30HkfLttUK/O3XhCwgFPIEEk84dGSOK9hb/Nrl5j3zemnOs
         VfB0ZTpU2djGMl8YGQveQizRVOxm8LZd20K8lJe3aQeNBiQYspeFkvWUfq6dOMNEohMR
         JbE2tmeBh36PADftC31EGIavMwIVLqUS6kEJc0gO3ARQc2pOsDCBJSBUfNnSt1axBd1F
         VKIyO87p4ygzHbIl/+4y/mYfBz9zHEn/2nkwVjnm12tKB6fKL7lfLnL68kK6AvP1pKS2
         17rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795084970; x=1795689770;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mOW7ofy1LPlD15OpqWHQo9AwJhFfzJjmQIKIkC51Z3w=;
        b=M+ZONov7klYp2Fj7bR3vQtqAkysjNc1c7JCBZes/aMyRAU3sgDC/wdkUWN2p/74k+L
         WLyHgoB3tAKQIfHenCTsDSg2sGD1rjS6NLFxnGNlQiydwqrsH7fnabKIxEdiZe47bvZJ
         bfPDc1CHtLeE1pSsOgxmkVGWcyibVjJ2QB4GZtj3M78atyVqRyUaSJJMPPb5o7xzQ5pe
         gZ/IPcYqrImeI7kp2YyKVkYauR+Y6kcvkFsvrmXaMcsjBiCZZiOoDFiH/C3QLDL9gXHi
         Mp/E0d1eqU51eTHL/EFMIu+Ddy2yhTMplon50d5c+9wHlWrYlZEVPFNpEO9gUbx58mkz
         O7TQ==
X-Forwarded-Encrypted: i=1; AL+hErGOOjVEjpQSieWBWxv/Mp7ERFRI5uZmZg+hVHnCLBRvvuD2L9Hk3SmnPcEjaIyQWHQaIj9ZQ9mwSRw=@vger.kernel.org
X-Gm-Message-State: APuU4Z8upybWazX0CFr3eHU9wvJBXqjs3DIbUDTCAV4A5NWLGUcYR1ZA
	z/QuaQzwa2fNjA0x4W5LieVadGxkHZZoZcXc38L2Ej5ZgOkTtebQhOwRBXN7nZn0naWS2qTUOQ=
	=
X-Received: from edqg26.prod.google.com ([2002:aa7:c59a:0:b0:6b8:7912:3485])
 (user=halg job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:23d1:b0:6b5:7312:4f48
 with SMTP id 4fb4d7f45d1cf-6b887ebfe91mr3734397a12.28.1795084970228; Thu, 19
 Nov 2026 02:42:50 -0800 (PST)
Date: Thu, 19 Nov 2026 10:42:05 +0000
In-Reply-To: <20261119104208.782900-1-halg@google.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261119104208.782900-1-halg@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261119104208.782900-2-halg@google.com>
Subject: [PATCH v2 1/4] userns: introduce capability bounding set for user namespaces
From: "Hallgrimur H. Gunnarsson" <halg@google.com>
To: Christian Brauner <brauner@kernel.org>, Serge Hallyn <sergeh@kernel.org>, 
	Andy Lutomirski <luto@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, Kees Cook <kees@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, 
	"=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>, Jonathan Calmels <jcalmels@3xx0.net>, Jann Horn <jannh@google.com>, 
	"=?UTF-8?q?G=C3=BCnther=20Noack?=" <gnoack@google.com>, KP Singh <kpsingh@kernel.org>, 
	Casey Schaufler <casey@schaufler-ca.com>, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
	containers@lists.linux.dev, keyrings@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Hallgrimur H. Gunnarsson" <halg@google.com>
Content-Type: text/plain; charset="UTF-8"

When a process creates a new user namespace, it receives a full set of
capabilities (CAP_FULL_SET) scoped to that namespace. While namespaced
in scope, several of these capabilities (such as CAP_NET_ADMIN and
CAP_NET_RAW) expose broad kernel attack surface that many sandboxes and
containers never need. However, there is currently no configurable way
to withhold such capabilities from user namespaces while still granting
them to workloads that require them.

Introduce a per-user-namespace capability bounding set
(user_ns->cap_bset) and a per-credential userns capability set
(cred->cap_userns) queried and modified via prctl(PR_CAP_USERNS).
Lowering or clearing capabilities in cap_userns (PR_CAP_USERNS_LOWER
and PR_CAP_USERNS_CLEAR_ALL) requires CAP_SETPCAP in the current user
namespace or no_new_privs, while raising a capability
(PR_CAP_USERNS_RAISE) requires holding it in cap_permitted.

By default, a credential's userns capability ceiling (cred_userns_bset)
combines cap_userns with cap_permitted (matching what the task could
raise via PR_CAP_USERNS_RAISE), so privileged tasks retain capabilities
they already hold even when cap_userns has been lowered. Setting
SECBIT_CAP_USERNS_STRICT enforces cap_userns strictly, ignores
cap_permitted, and disables PR_CAP_USERNS_RAISE, allowing privileged
launchers or outer containers to spawn trimmed descendant user
namespaces without dropping their own cap_permitted. Both
SECBIT_CAP_USERNS_STRICT and its lock bit persist across user namespace
transitions.

When a new user namespace is created, set its cap_bset to the
intersection of its parent's cap_bset and the creator's ceiling
(parent_ns->cap_bset & cred_userns_bset(cred)), so capability bounding
sets decrease monotonically down the namespace hierarchy.

On user namespace entry (during creation or via setns()), clamp the
task's permitted, effective, and bounding sets to user_ns->cap_bset &
cred_userns_bset(cred) instead of granting CAP_FULL_SET, and intersect
cap_userns with user_ns->cap_bset. Because user namespace transitions
only move downward in the hierarchy, bits absent from user_ns->cap_bset
can never be acquired in descendant namespaces. Clearing them keeps
cap_userns and PR_CAP_USERNS_IS_SET accurate after setns() and keeps
all six task capability sets as subsets of user_ns->cap_bset.

In cap_capable_helper(), bound implicit parent-owner capabilities by
the owned namespace's cap_bset, and grant them only when that cap_bset
is a subset of cred_userns_bset(cred), preventing tasks from exercising
privileges over less-restricted descendant namespaces.

Initialize both init_user_ns.cap_bset and init_cred.cap_userns to
CAP_FULL_SET, preserving existing behavior unless cap_userns is
explicitly restricted.

Suggested-by: Christian Brauner <brauner@kernel.org>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Hallgrimur H. Gunnarsson <halg@google.com>
---
 Documentation/security/credentials.rst | 12 ++++-
 include/linux/cred.h                   | 22 +++++++++
 include/linux/user_namespace.h         | 12 +++++
 include/uapi/linux/prctl.h             |  7 +++
 include/uapi/linux/securebits.h        | 16 +++++-
 init/init_task.c                       |  1 +
 kernel/user.c                          |  1 +
 kernel/user_namespace.c                | 33 +++++++++----
 security/commoncap.c                   | 68 ++++++++++++++++++++++++--
 security/keys/process_keys.c           |  1 +
 10 files changed, 158 insertions(+), 15 deletions(-)

diff --git a/Documentation/security/credentials.rst b/Documentation/security/credentials.rst
index a39a2a2f67aa..2645cc81515a 100644
--- a/Documentation/security/credentials.rst
+++ b/Documentation/security/credentials.rst
@@ -149,6 +149,7 @@ The Linux kernel supports the following types of credentials:
 	- Set of inheritable capabilities
 	- Set of effective capabilities
 	- Capability bounding set
+	- Set of userns capabilities
 
      These are only carried by tasks.  They indicate superior capabilities
      granted piecemeal to a task that an ordinary task wouldn't otherwise have.
@@ -170,12 +171,19 @@ The Linux kernel supports the following types of credentials:
      ``execve()``, especially when a binary is executed that will execute as
      UID 0.
 
+     The userns capabilities (manipulated via ``prctl(PR_CAP_USERNS)``) define
+     a ceiling on the capabilities a task may acquire when creating or entering
+     a user namespace, and prevent exercising implicit owner capabilities via
+     any owned user namespace whose bounding set exceeds this ceiling.
+     Capabilities held in the permitted set remain included in this ceiling by
+     default unless ``SECBIT_CAP_USERNS_STRICT`` is set.
+
  3. Secure management flags (securebits).
 
      These are only carried by tasks.  These govern the way the above
      credentials are manipulated and inherited over certain operations such as
-     execve().  They aren't used directly as objective or subjective
-     credentials.
+     execve() and user namespace transitions. They aren't used directly as
+     objective or subjective credentials.
 
  4. Keys and keyrings.
 
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 49c26af37349..20857d11e032 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -14,6 +14,7 @@
 #include <linux/atomic.h>
 #include <linux/refcount.h>
 #include <linux/uidgid.h>
+#include <linux/securebits.h>
 #include <linux/sched.h>
 #include <linux/sched/user.h>
 
@@ -128,6 +129,7 @@ struct cred {
 	kernel_cap_t	cap_effective;	/* caps we can actually use */
 	kernel_cap_t	cap_bset;	/* capability bounding set */
 	kernel_cap_t	cap_ambient;	/* Ambient capability set */
+	kernel_cap_t	cap_userns;	/* userns capability set */
 #ifdef CONFIG_KEYS
 	unsigned char	jit_keyring;	/* default keyring to attach requested
 					 * keys to */
@@ -178,6 +180,26 @@ static inline bool cap_ambient_invariant_ok(const struct cred *cred)
 					  cred->cap_inheritable));
 }
 
+/**
+ * cred_userns_bset - Ceiling on capabilities a userns may grant @cred
+ * @cred: Credentials to evaluate
+ *
+ * By default, capabilities already held in cap_permitted are also allowed
+ * (matching what @cred could raise via PR_CAP_USERNS_RAISE). When
+ * SECBIT_CAP_USERNS_STRICT is set, cap_userns is enforced strictly and
+ * cap_permitted is ignored. Because both cap_userns and cap_permitted are
+ * bounded by cred->user_ns->cap_bset, the returned mask never exceeds the
+ * enclosing user namespace's bounding set.
+ *
+ * Return: Capability mask @cred may acquire in or exercise over a userns.
+ */
+static inline kernel_cap_t cred_userns_bset(const struct cred *cred)
+{
+	if (cred->securebits & SECBIT_CAP_USERNS_STRICT)
+		return cred->cap_userns;
+	return cap_combine(cred->cap_userns, cred->cap_permitted);
+}
+
 static inline const struct cred *override_creds(const struct cred *override_cred)
 {
 	const struct cred *old = current->cred;
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 91232053775d..5f31390aa583 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -3,6 +3,7 @@
 #define _LINUX_USER_NAMESPACE_H
 
 #include <linux/kref.h>
+#include <linux/capability.h>
 #include <linux/nsproxy.h>
 #include <linux/ns_common.h>
 #include <linux/rculist_nulls.h>
@@ -84,6 +85,7 @@ struct user_namespace {
 	int			level;
 	kuid_t			owner;
 	kgid_t			group;
+	kernel_cap_t		cap_bset;
 	struct ns_common	ns;
 	unsigned long		flags;
 	/* parent_could_setfcap: true if the creator if this ns had CAP_SETFCAP
@@ -183,6 +185,11 @@ static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 	return ns;
 }
 
+static inline bool userns_has_cap(const struct user_namespace *ns, int cap)
+{
+	return cap_raised(ns->cap_bset, cap);
+}
+
 extern int create_user_ns(struct cred *new);
 extern int unshare_userns(unsigned long unshare_flags, struct cred **new_cred);
 extern void __put_user_ns(struct user_namespace *ns);
@@ -221,6 +228,11 @@ static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 	return &init_user_ns;
 }
 
+static inline bool userns_has_cap(const struct user_namespace *ns, int cap)
+{
+	return true;
+}
+
 static inline int create_user_ns(struct cred *new)
 {
 	return -EINVAL;
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index b6ec6f693719..137a5d0a6704 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -416,4 +416,11 @@ struct prctl_mm_map {
 # define PR_CFI_DISABLE		_BITUL(1)
 # define PR_CFI_LOCK		_BITUL(2)
 
+/* Control the userns capability mask */
+#define PR_CAP_USERNS			82
+# define PR_CAP_USERNS_IS_SET		1
+# define PR_CAP_USERNS_RAISE		2
+# define PR_CAP_USERNS_LOWER		3
+# define PR_CAP_USERNS_CLEAR_ALL	4
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/uapi/linux/securebits.h b/include/uapi/linux/securebits.h
index 3fba30dbd68b..cc8ed81683e2 100644
--- a/include/uapi/linux/securebits.h
+++ b/include/uapi/linux/securebits.h
@@ -69,12 +69,26 @@
 #define SECBIT_EXEC_DENY_INTERACTIVE_LOCKED \
 			(issecure_mask(SECURE_EXEC_DENY_INTERACTIVE_LOCKED))
 
+/*
+ * When set, creating or entering a user namespace only grants capabilities
+ * present in cap_userns (ignoring cap_permitted), and PR_CAP_USERNS_RAISE
+ * is disabled.
+ */
+#define SECURE_CAP_USERNS_STRICT		12
+#define SECURE_CAP_USERNS_STRICT_LOCKED		13 /* make bit-12 immutable */
+
+#define SECBIT_CAP_USERNS_STRICT \
+			(issecure_mask(SECURE_CAP_USERNS_STRICT))
+#define SECBIT_CAP_USERNS_STRICT_LOCKED \
+			(issecure_mask(SECURE_CAP_USERNS_STRICT_LOCKED))
+
 #define SECURE_ALL_BITS		(issecure_mask(SECURE_NOROOT) | \
 				 issecure_mask(SECURE_NO_SETUID_FIXUP) | \
 				 issecure_mask(SECURE_KEEP_CAPS) | \
 				 issecure_mask(SECURE_NO_CAP_AMBIENT_RAISE) | \
 				 issecure_mask(SECURE_EXEC_RESTRICT_FILE) | \
-				 issecure_mask(SECURE_EXEC_DENY_INTERACTIVE))
+				 issecure_mask(SECURE_EXEC_DENY_INTERACTIVE) | \
+				 issecure_mask(SECURE_CAP_USERNS_STRICT))
 #define SECURE_ALL_LOCKS	(SECURE_ALL_BITS << 1)
 
 #define SECURE_ALL_UNPRIVILEGED (issecure_mask(SECURE_EXEC_RESTRICT_FILE) | \
diff --git a/init/init_task.c b/init/init_task.c
index ce7c2b07d855..a5c4bf902dcc 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -92,6 +92,7 @@ static struct cred init_cred = {
 	.cap_permitted		= CAP_FULL_SET,
 	.cap_effective		= CAP_FULL_SET,
 	.cap_bset		= CAP_FULL_SET,
+	.cap_userns		= CAP_FULL_SET,
 	.user			= INIT_USER,
 	.user_ns		= &init_user_ns,
 	.group_info		= &init_groups,
diff --git a/kernel/user.c b/kernel/user.c
index 21bafdc11379..97d95e733a8c 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -68,6 +68,7 @@ struct user_namespace init_user_ns = {
 	},
 	.owner = GLOBAL_ROOT_UID,
 	.group = GLOBAL_ROOT_GID,
+	.cap_bset = CAP_FULL_SET,
 	.flags = USERNS_INIT_FLAGS,
 #ifdef CONFIG_KEYS
 	.keyring_name_list = LIST_HEAD_INIT(init_user_ns.keyring_name_list),
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index cd748e1cbace..96cdc29f3611 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -4,6 +4,7 @@
 #include <linux/export.h>
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
+#include <linux/capability.h>
 #include <linux/sched/signal.h>
 #include <linux/user_namespace.h>
 #include <linux/proc_ns.h>
@@ -44,18 +45,30 @@ static void dec_user_namespaces(struct ucounts *ucounts)
 
 static void set_cred_user_ns(struct cred *cred, struct user_namespace *user_ns)
 {
-	/* Start with the same capabilities as init but useless for doing
-	 * anything as the capabilities are bound to the new user namespace.
-	 * The exec securebits grant nothing, they are restrictions the task
-	 * placed on itself. Keep them and their locks.
+	unsigned int keep_secbits;
+	kernel_cap_t caps;
+
+	/*
+	 * Preserve unprivileged and userns-strict securebits and their locks
+	 * across user namespace transitions.
+	 */
+	keep_secbits = SECURE_ALL_UNPRIVILEGED | SECBIT_CAP_USERNS_STRICT;
+	cred->securebits &= keep_secbits | (keep_secbits << 1);
+	cred->securebits |= SECUREBITS_DEFAULT;
+
+	/*
+	 * Invariant: for every credential in a user namespace, all six task
+	 * capability masks (effective, permitted, inheritable, ambient, bset,
+	 * and userns) are subsets of user_ns->cap_bset.
 	 */
-	cred->securebits = SECUREBITS_DEFAULT |
-		(cred->securebits & (SECURE_ALL_UNPRIVILEGED | SECURE_ALL_UNPRIVILEGED << 1));
+	caps = cap_intersect(user_ns->cap_bset, cred_userns_bset(cred));
+
 	cred->cap_inheritable = CAP_EMPTY_SET;
-	cred->cap_permitted = CAP_FULL_SET;
-	cred->cap_effective = CAP_FULL_SET;
+	cred->cap_permitted = caps;
+	cred->cap_effective = caps;
 	cred->cap_ambient = CAP_EMPTY_SET;
-	cred->cap_bset = CAP_FULL_SET;
+	cred->cap_bset = caps;
+	cred->cap_userns = cap_intersect(user_ns->cap_bset, cred->cap_userns);
 #ifdef CONFIG_KEYS
 	key_put(cred->request_key_auth);
 	cred->request_key_auth = NULL;
@@ -148,6 +161,8 @@ int create_user_ns(struct cred *new)
 	set_userns_rlimit_max(ns, UCOUNT_RLIMIT_SIGPENDING, rlimit(RLIMIT_SIGPENDING));
 	set_userns_rlimit_max(ns, UCOUNT_RLIMIT_MEMLOCK, rlimit(RLIMIT_MEMLOCK));
 	ns->ucounts = ucounts;
+	ns->cap_bset = cap_intersect(parent_ns->cap_bset,
+				     cred_userns_bset(new));
 
 	/* Inherit USERNS_SETGROUPS_ALLOWED from our parent */
 	mutex_lock(&userns_state_mutex);
diff --git a/security/commoncap.c b/security/commoncap.c
index d47ab3022343..ddac8e917680 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -88,11 +88,15 @@ static inline int cap_capable_helper(const struct cred *cred,
 		if (ns->level <= cred_ns->level)
 			return -EPERM;
 
-		/* 
+		/*
 		 * The owner of the user namespace in the parent of the
-		 * user namespace has all caps.
+		 * user namespace has all caps within the owned namespace's
+		 * bounding set, as long as it does not exceed the caller's
+		 * userns capability ceiling.
 		 */
-		if ((ns->parent == cred_ns) && uid_eq(ns->owner, cred->euid))
+		if (ns->parent == cred_ns && uid_eq(ns->owner, cred->euid) &&
+		    cap_issubset(ns->cap_bset, cred_userns_bset(cred)) &&
+		    userns_has_cap(ns, cap))
 			return 0;
 
 		/*
@@ -1283,6 +1287,59 @@ static int cap_prctl_drop(unsigned long cap)
 	return commit_creds(new);
 }
 
+static int prctl_cap_userns(unsigned long op, unsigned long cap)
+{
+	const struct cred *cred = current_cred();
+	kernel_cap_t userns = cred->cap_userns;
+	struct cred *new;
+
+	switch (op) {
+	case PR_CAP_USERNS_IS_SET:
+		if (!cap_valid(cap))
+			return -EINVAL;
+		return cap_raised(userns, cap);
+
+	case PR_CAP_USERNS_RAISE:
+		if (!cap_valid(cap))
+			return -EINVAL;
+		if (!cap_raised(cred->cap_permitted, cap) ||
+		    (cred->securebits & SECBIT_CAP_USERNS_STRICT))
+			return -EPERM;
+		cap_raise(userns, cap);
+		break;
+
+	case PR_CAP_USERNS_LOWER:
+		if (!cap_valid(cap))
+			return -EINVAL;
+		if (!task_no_new_privs(current) &&
+		    !ns_capable(current_user_ns(), CAP_SETPCAP))
+			return -EPERM;
+		cap_lower(userns, cap);
+		break;
+
+	case PR_CAP_USERNS_CLEAR_ALL:
+		if (cap)
+			return -EINVAL;
+		if (!task_no_new_privs(current) &&
+		    !ns_capable(current_user_ns(), CAP_SETPCAP))
+			return -EPERM;
+		cap_clear(userns);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (cap_isidentical(userns, cred->cap_userns))
+		return 0;
+
+	new = prepare_creds();
+	if (!new)
+		return -ENOMEM;
+	new->cap_userns = userns;
+	return commit_creds(new);
+}
+
 /**
  * cap_task_prctl - Implement process control functions for this security module
  * @option: The process control function requested
@@ -1434,6 +1491,11 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			return commit_creds(new);
 		}
 
+	case PR_CAP_USERNS:
+		if (arg4 || arg5)
+			return -EINVAL;
+		return prctl_cap_userns(arg2, arg3);
+
 	default:
 		/* No functionality available - continue with default */
 		return -ENOSYS;
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 3af71c6322af..183fe18a8f62 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -1026,6 +1026,7 @@ void key_change_session_keyring(struct callback_head *twork)
 	new->cap_effective	= old->cap_effective;
 	new->cap_ambient	= old->cap_ambient;
 	new->cap_bset		= old->cap_bset;
+	new->cap_userns		= old->cap_userns;
 
 	new->jit_keyring	= old->jit_keyring;
 	new->thread_keyring	= key_get(old->thread_keyring);
-- 
2.56.1.708.g77570a6a1d-goog

