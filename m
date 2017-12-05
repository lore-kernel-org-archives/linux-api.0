From: Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>
Subject: [PATCHv3 2/2] userns: control capabilities of some user namespaces
Date: Tue,  5 Dec 2017 14:31:05 -0800
Message-ID: <20171205223105.12845-1-mahesh@bandewar.net>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Kernel-hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>, Mahesh Bandewar <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Mahesh Bandewar <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

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

Acked-by: Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mahesh Bandewar <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
v3:
  Rebase
v2:
  Don't recalculate user-ns flags for every setns() call.
v1:
  Initial submission.

 include/linux/capability.h     |  4 ++++
 include/linux/user_namespace.h | 25 +++++++++++++++++++++++++
 kernel/capability.c            |  5 +++++
 kernel/user_namespace.c        |  4 ++++
 security/commoncap.c           |  8 ++++++++
 5 files changed, 46 insertions(+)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 7d79a4689625..383f31f066f0 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -251,6 +251,10 @@ extern bool ptracer_capable(struct task_struct *tsk, struct user_namespace *ns);
 extern int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps);
 int proc_douserns_caps_whitelist(struct ctl_table *table, int write,
 				 void __user *buff, size_t *lenp, loff_t *ppos);
+/* Controlled capability is capability that is missing from the capability-mask
+ * controlled_userns_caps_whitelist controlled via sysctl.
+ */
+bool is_capability_controlled(int cap);
 
 extern int cap_convert_nscap(struct dentry *dentry, void **ivalue, size_t size);
 
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index d6b74b91096b..a5c48684b317 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -32,6 +32,7 @@ struct uid_gid_map { /* 64 bytes -- 1 cache line */
 };
 
 #define USERNS_SETGROUPS_ALLOWED 1UL
+#define USERNS_CONTROLLED	 2UL
 
 #define USERNS_INIT_FLAGS USERNS_SETGROUPS_ALLOWED
 
@@ -112,6 +113,21 @@ static inline void put_user_ns(struct user_namespace *ns)
 		__put_user_ns(ns);
 }
 
+/* Controlled user-ns is the one that is created by a process that does not
+ * have CAP_SYS_ADMIN (or descended from such an user-ns).
+ * For more details please see the sysctl description of
+ * controlled_userns_caps_whitelist.
+ */
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
@@ -170,6 +186,15 @@ static inline struct ns_common *ns_get_owner(struct ns_common *ns)
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
index 246d4d4ce5c7..ca0556d466b6 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -141,6 +141,10 @@ int create_user_ns(struct cred *new)
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
index 4f8e09340956..5454e9c03ee8 100644
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
2.15.0.531.g2ccb3012c9-goog
