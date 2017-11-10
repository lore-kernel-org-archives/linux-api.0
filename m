From: Mahesh Bandewar <mahesh@bandewar.net>
Subject: [PATCHv2 2/2] userns: control capabilities of some user namespaces
Date: Thu,  9 Nov 2017 21:37:57 -0800
Message-ID: <20171110053757.21170-1-mahesh@bandewar.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Cc: Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Serge Hallyn <serge@hallyn.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Mahesh Bandewar <mahesh@bandewar.net>, Mahesh Bandewar <maheshb@google.com>
List-Id: linux-api@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>

With this new notion of "controlled" user-namespaces, the controlled
user-namespaces are marked at the time of their creation while the
capabilities of processes that belong to them are controlled using the
global mask.

Init-user-ns is always uncontrolled and a process that has SYS_ADMIN
that belongs to uncontrolled user-ns can create another (child) user-
namespace that is uncontrolled. Any other process (that either does
not have SYS_ADMIN or belongs to a controlled user-ns) can only
create a user-ns that is controlled.

global-capability-whitelist (controlled_userns_caps_whitelist) is used
at the capability check-time and keeps the semantics for the processes
that belong to uncontrolled user-ns as it is. Processes that belong to
controlled user-ns however are subjected to different checks-

   (a) if the capability in question is controlled and process belongs
       to controlled user-ns, then it's always denied.
   (b) if the capability in question is NOT controlled then fall back
       to the traditional check.

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
v2:
  Don't recalculate user-ns flags for every setns() call.
v1:
  Initial submission.

 include/linux/capability.h     |  1 +
 include/linux/user_namespace.h | 20 ++++++++++++++++++++
 kernel/capability.c            |  5 +++++
 kernel/user_namespace.c        |  4 ++++
 security/commoncap.c           |  8 ++++++++
 5 files changed, 38 insertions(+)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 7d79a4689625..a1fd9e460379 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -251,6 +251,7 @@ extern bool ptracer_capable(struct task_struct *tsk, struct user_namespace *ns);
 extern int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps);
 int proc_douserns_caps_whitelist(struct ctl_table *table, int write,
 				 void __user *buff, size_t *lenp, loff_t *ppos);
+bool is_capability_controlled(int cap);
 
 extern int cap_convert_nscap(struct dentry *dentry, void **ivalue, size_t size);
 
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 3fe714da7f5a..647f825c7b5f 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -23,6 +23,7 @@ struct uid_gid_map {	/* 64 bytes -- 1 cache line */
 };
 
 #define USERNS_SETGROUPS_ALLOWED 1UL
+#define USERNS_CONTROLLED	 2UL
 
 #define USERNS_INIT_FLAGS USERNS_SETGROUPS_ALLOWED
 
@@ -103,6 +104,16 @@ static inline void put_user_ns(struct user_namespace *ns)
 		__put_user_ns(ns);
 }
 
+static inline bool is_user_ns_controlled(const struct user_namespace *ns)
+{
+	return ns->flags & USERNS_CONTROLLED;
+}
+
+static inline void mark_user_ns_controlled(struct user_namespace *ns)
+{
+	ns->flags |= USERNS_CONTROLLED;
+}
+
 struct seq_operations;
 extern const struct seq_operations proc_uid_seq_operations;
 extern const struct seq_operations proc_gid_seq_operations;
@@ -161,6 +172,15 @@ static inline struct ns_common *ns_get_owner(struct ns_common *ns)
 {
 	return ERR_PTR(-EPERM);
 }
+
+static inline bool is_user_ns_controlled(const struct user_namespace *ns)
+{
+	return false;
+}
+
+static inline void mark_user_ns_controlled(struct user_namespace *ns)
+{
+}
 #endif
 
 #endif /* _LINUX_USER_H */
diff --git a/kernel/capability.c b/kernel/capability.c
index 4a859b7d4902..bffe249922de 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -511,6 +511,11 @@ bool ptracer_capable(struct task_struct *tsk, struct user_namespace *ns)
 }
 
 /* Controlled-userns capabilities routines */
+bool is_capability_controlled(int cap)
+{
+	return !cap_raised(controlled_userns_caps_whitelist, cap);
+}
+
 #ifdef CONFIG_SYSCTL
 int proc_douserns_caps_whitelist(struct ctl_table *table, int write,
 				 void __user *buff, size_t *lenp, loff_t *ppos)
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index c490f1e4313b..600c7dcb9ff7 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -139,6 +139,10 @@ int create_user_ns(struct cred *new)
 		goto fail_keyring;
 
 	set_cred_user_ns(new, ns);
+	if (!ns_capable(parent_ns, CAP_SYS_ADMIN) ||
+	    is_user_ns_controlled(parent_ns))
+		mark_user_ns_controlled(ns);
+
 	return 0;
 fail_keyring:
 #ifdef CONFIG_PERSISTENT_KEYRINGS
diff --git a/security/commoncap.c b/security/commoncap.c
index fc46f5b85251..89103f16ac37 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -73,6 +73,14 @@ int cap_capable(const struct cred *cred, struct user_namespace *targ_ns,
 {
 	struct user_namespace *ns = targ_ns;
 
+	/* If the capability is controlled and user-ns that process
+	 * belongs-to is 'controlled' then return EPERM and no need
+	 * to check the user-ns hierarchy.
+	 */
+	if (is_user_ns_controlled(cred->user_ns) &&
+	    is_capability_controlled(cap))
+		return -EPERM;
+
 	/* See if cred has the capability in the target user namespace
 	 * by examining the target user namespace and all of the target
 	 * user namespace's parents.
-- 
2.15.0.448.gf294e3d99a-goog
