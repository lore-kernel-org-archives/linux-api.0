From: Richard Guy Briggs <rgb@redhat.com>
Subject: [RFC PATCH ghak90 (was ghak32) V3 07/10] audit: add support for containerid to network namespaces
Date: Wed,  6 Jun 2018 12:58:34 -0400
Message-ID: <562cfaf7629b64252aac7cf3cecdd70b471af5b5.1528304204.git.rgb@redhat.com>
References: <cover.1528304203.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1528304203.git.rgb@redhat.com>
In-Reply-To: <cover.1528304203.git.rgb@redhat.com>
References: <cover.1528304203.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Audit events could happen in a network namespace outside of a task
context due to packets received from the net that trigger an auditing
rule prior to being associated with a running task.  The network
namespace could in use by multiple containers by association to the
tasks in that network namespace.  We still want a way to attribute
these events to any potential containers.  Keep a list per network
namespace to track these audit container identifiiers.

Add/increment the audit container identifier on:
- initial setting of the audit container identifier via /proc
- clone/fork call that inherits an audit container identifier
- unshare call that inherits an audit container identifier
- setns call that inherits an audit container identifier
Delete/decrement the audit container identifier on:
- an inherited audit container identifier dropped when child set
- process exit
- unshare call that drops a net namespace
- setns call that drops a net namespace

See: https://github.com/linux-audit/audit-kernel/issues/92
See: https://github.com/linux-audit/audit-testsuite/issues/64
See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h | 23 ++++++++++++++++
 kernel/audit.c        | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/auditsc.c      |  5 ++++
 kernel/nsproxy.c      |  4 +++
 4 files changed, 104 insertions(+)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 1e37abf..7e2e51c 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -26,6 +26,7 @@
 #include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <uapi/linux/audit.h>
+#include <linux/refcount.h>
 
 #define AUDIT_INO_UNSET ((unsigned long)-1)
 #define AUDIT_DEV_UNSET ((dev_t)-1)
@@ -87,6 +88,12 @@ struct audit_field {
 	u32				op;
 };
 
+struct audit_contid {
+	struct list_head	list;
+	u64			id;
+	refcount_t		refcount;
+};
+
 extern int is_audit_feature_set(int which);
 
 extern int __init audit_register_class(int class, unsigned *list);
@@ -156,6 +163,10 @@ extern void audit_log_task_info(struct audit_buffer *ab,
 				struct task_struct *tsk);
 extern int audit_log_contid(struct audit_context *context,
 				     char *op, u64 contid);
+extern struct list_head *audit_get_contid_list(const struct net *net);
+extern void audit_contid_add(struct net *net, u64 contid);
+extern void audit_contid_del(struct net *net, u64 contid);
+extern void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p);
 
 extern int		    audit_update_lsm_rules(void);
 
@@ -209,6 +220,18 @@ static inline void audit_log_task_info(struct audit_buffer *ab,
 static inline int audit_log_contid(struct audit_context *context,
 					    char *op, u64 contid)
 { }
+static inline struct list_head *audit_get_contid_list(const struct net *net)
+{
+	static LIST_HEAD(list);
+	return &list;
+}
+static inline void audit_contid_add(struct net *net, u64 contid)
+{ }
+static inline void audit_contid_del(struct net *net, u64 contid)
+{ }
+static inline void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
+{ }
+
 #define audit_enabled 0
 #endif /* CONFIG_AUDIT */
 
diff --git a/kernel/audit.c b/kernel/audit.c
index ba304a8..ecd2de4 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -106,6 +106,7 @@
  */
 struct audit_net {
 	struct sock *sk;
+	struct list_head contid_list;
 };
 
 /**
@@ -311,6 +312,76 @@ static struct sock *audit_get_sk(const struct net *net)
 	return aunet->sk;
 }
 
+/**
+ * audit_get_contid_list - Return the audit container ID list for the given network namespace
+ * @net: the destination network namespace
+ *
+ * Description:
+ * Returns the list pointer if valid, NULL otherwise.  The caller must ensure
+ * that a reference is held for the network namespace while the sock is in use.
+ */
+struct list_head *audit_get_contid_list(const struct net *net)
+{
+	struct audit_net *aunet = net_generic(net, audit_net_id);
+
+	return &aunet->contid_list;
+}
+
+void audit_contid_add(struct net *net, u64 contid)
+{
+	struct list_head *contid_list = audit_get_contid_list(net);
+	struct audit_contid *cont;
+
+	if (!cid_valid(contid))
+		return;
+	if (!list_empty(contid_list))
+		list_for_each_entry(cont, contid_list, list)
+			if (cont->id == contid) {
+				refcount_inc(&cont->refcount);
+				return;
+			}
+	cont = kmalloc(sizeof(struct audit_contid), GFP_KERNEL);
+	if (!cont)
+		return;
+	INIT_LIST_HEAD(&cont->list);
+	cont->id = contid;
+	refcount_set(&cont->refcount, 1);
+	list_add(&cont->list, contid_list);
+}
+
+void audit_contid_del(struct net *net, u64 contid)
+{
+	struct list_head *contid_list = audit_get_contid_list(net);
+	struct audit_contid *cont = NULL;
+	int found = 0;
+
+	if (!cid_valid(contid))
+		return;
+	if (!list_empty(contid_list))
+		list_for_each_entry(cont, contid_list, list)
+			if (cont->id == contid) {
+				found = 1;
+				break;
+			}
+	if (!found)
+		return;
+	list_del(&cont->list);
+	if (refcount_dec_and_test(&cont->refcount))
+		kfree(cont);
+}
+
+void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
+{
+	u64 contid = audit_get_contid(p);
+	struct nsproxy *new = p->nsproxy;
+
+	if (!cid_valid(contid))
+		return;
+	audit_contid_del(ns->net_ns, contid);
+	if (new)
+		audit_contid_add(new->net_ns, contid);
+}
+
 void audit_panic(const char *message)
 {
 	switch (audit_failure) {
@@ -1550,6 +1621,7 @@ static int __net_init audit_net_init(struct net *net)
 		return -ENOMEM;
 	}
 	aunet->sk->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
+	INIT_LIST_HEAD(&aunet->contid_list);
 
 	return 0;
 }
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index ea1ee35..6ab5e5e 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -75,6 +75,7 @@
 #include <linux/uaccess.h>
 #include <linux/fsnotify_backend.h>
 #include <uapi/linux/limits.h>
+#include <net/net_namespace.h>
 
 #include "audit.h"
 
@@ -2165,6 +2166,7 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 	uid_t uid;
 	struct tty_struct *tty;
 	char comm[sizeof(current->comm)];
+	struct net *net = task->nsproxy->net_ns;
 
 	/* Can't set if audit disabled */
 	if (!task->audit)
@@ -2185,10 +2187,13 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 	else if (cid_valid(oldcontid) && !task->audit->inherited)
 		rc = -EEXIST;
 	if (!rc) {
+		if (cid_valid(oldcontid))
+			audit_contid_del(net, oldcontid);
 		task_lock(task);
 		task->audit->contid = contid;
 		task->audit->inherited = false;
 		task_unlock(task);
+		audit_contid_add(net, contid);
 	}
 
 	if (!audit_enabled)
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index f6c5d33..dcb69fe 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -27,6 +27,7 @@
 #include <linux/syscalls.h>
 #include <linux/cgroup.h>
 #include <linux/perf_event.h>
+#include <linux/audit.h>
 
 static struct kmem_cache *nsproxy_cachep;
 
@@ -140,6 +141,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 	struct nsproxy *old_ns = tsk->nsproxy;
 	struct user_namespace *user_ns = task_cred_xxx(tsk, user_ns);
 	struct nsproxy *new_ns;
+	u64 contid = audit_get_contid(tsk);
 
 	if (likely(!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
 			      CLONE_NEWPID | CLONE_NEWNET |
@@ -167,6 +169,7 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 		return  PTR_ERR(new_ns);
 
 	tsk->nsproxy = new_ns;
+	audit_contid_add(new_ns->net_ns, contid);
 	return 0;
 }
 
@@ -224,6 +227,7 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
 	ns = p->nsproxy;
 	p->nsproxy = new;
 	task_unlock(p);
+	audit_switch_task_namespaces(ns, p);
 
 	if (ns && atomic_dec_and_test(&ns->count))
 		free_nsproxy(ns);
-- 
1.8.3.1
