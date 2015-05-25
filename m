From: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 5/7] smack: namespace groundwork
Date: Mon, 25 May 2015 14:32:40 +0200
Message-ID: <1432557162-19123-6-git-send-email-l.pawelczyk__3234.81110758639$1432557260$gmane$org@samsung.com>
References: <1432209222-8479-1-git-send-email-l.pawelczyk@samsung.com>
 <1432557162-19123-1-git-send-email-l.pawelczyk@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1432557162-19123-1-git-send-email-l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Jingoo Han <jg1.han-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, John Johansen <john.johansen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Oleg
Cc: Lukasz Pawelczyk <havner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This commit introduces several changes to Smack to prepare it for
namespace implementation. All the changes are related to namespaces.

Overview of the changes:
- Adds required data structures for mapped labels and functions to
  operate on them.
- Implements the proc interface /proc/$PID/smack_map that can be used for
  remapping of labels for a specific namespace. Also for checking the map.
- Modifies handling of special built-in labels. Detects them on import
  and assigns the same char* pointer regardless whether it's used in a
  normal or a mapped label. This way we can always compare them by ==
  instead of strcmp().
- Adds User namespace hooks implementation

This patch introduces both internal and user-space visible APIs to
handle namespaced labels and Smack namespaces but the behaviour of Smack
should not be changed. The APIs are there, but they have no impact yet.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 fs/proc/base.c                 |  57 ++++++
 include/linux/user_namespace.h |   5 +
 security/smack/Kconfig         |  10 +
 security/smack/Makefile        |   1 +
 security/smack/smack.h         |  42 +++-
 security/smack/smack_access.c  |  46 ++++-
 security/smack/smack_lsm.c     |  76 ++++++++
 security/smack/smack_ns.c      | 432 +++++++++++++++++++++++++++++++++++++++++
 8 files changed, 662 insertions(+), 7 deletions(-)
 create mode 100644 security/smack/smack_ns.c

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 093ca14..22dde1c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2529,6 +2529,57 @@ static const struct file_operations proc_setgroups_operations = {
 };
 #endif /* CONFIG_USER_NS */
 
+#ifdef CONFIG_SECURITY_SMACK_NS
+static int proc_smack_map_open(struct inode *inode, struct file *file)
+{
+	struct user_namespace *ns = NULL;
+	struct task_struct *task;
+	struct seq_file *seq;
+	int ret = -EINVAL;
+
+	task = get_proc_task(inode);
+	if (task) {
+		rcu_read_lock();
+		ns = get_user_ns(task_cred_xxx(task, user_ns));
+		rcu_read_unlock();
+		put_task_struct(task);
+	}
+	if (!ns)
+		goto err;
+
+	ret = seq_open(file, &proc_smack_map_seq_operations);
+	if (ret)
+		goto err_put_ns;
+
+	seq = file->private_data;
+	seq->private = ns;
+
+	return 0;
+
+err_put_ns:
+	put_user_ns(ns);
+err:
+	return ret;
+}
+
+static int proc_smack_map_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *seq = file->private_data;
+	struct user_namespace *ns = seq->private;
+
+	put_user_ns(ns);
+	return seq_release(inode, file);
+}
+
+static const struct file_operations proc_smack_map_operations = {
+	.open		= proc_smack_map_open,
+	.write		= proc_smack_map_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= proc_smack_map_release,
+};
+#endif /* CONFIG_SECURITY_SMACK_NS */
+
 static int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task)
 {
@@ -2637,6 +2688,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
 	REG("setgroups",  S_IRUGO|S_IWUSR, proc_setgroups_operations),
 #endif
+#ifdef CONFIG_SECURITY_SMACK_NS
+	REG("smack_map",    S_IRUGO|S_IWUSR, proc_smack_map_operations),
+#endif
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	REG("timers",	  S_IRUGO, proc_timers_operations),
 #endif
@@ -2982,6 +3036,9 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
 	REG("setgroups",  S_IRUGO|S_IWUSR, proc_setgroups_operations),
 #endif
+#ifdef CONFIG_SECURITY_SMACK_NS
+	REG("smack_map",    S_IRUGO|S_IWUSR, proc_smack_map_operations),
+#endif
 };
 
 static int proc_tid_base_readdir(struct file *file, struct dir_context *ctx)
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index a9400cc..a8941a5 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -76,6 +76,11 @@ extern ssize_t proc_projid_map_write(struct file *, const char __user *, size_t,
 extern ssize_t proc_setgroups_write(struct file *, const char __user *, size_t, loff_t *);
 extern int proc_setgroups_show(struct seq_file *m, void *v);
 extern bool userns_may_setgroups(const struct user_namespace *ns);
+#ifdef CONFIG_SECURITY_SMACK_NS
+extern const struct seq_operations proc_smack_map_seq_operations;
+ssize_t proc_smack_map_write(struct file *file, const char __user *buf,
+			     size_t size, loff_t *ppos);
+#endif /* CONFIG_SECURITY_SMACK_NS */
 #else
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
diff --git a/security/smack/Kconfig b/security/smack/Kconfig
index 271adae..b19a7fb 100644
--- a/security/smack/Kconfig
+++ b/security/smack/Kconfig
@@ -40,3 +40,13 @@ config SECURITY_SMACK_NETFILTER
 	  This enables security marking of network packets using
 	  Smack labels.
 	  If you are unsure how to answer this question, answer N.
+
+config SECURITY_SMACK_NS
+	bool "Smack namespace"
+	depends on SECURITY_SMACK
+	depends on USER_NS
+	help
+	  This enables Smack namespace that makes it possible to map
+	  specific labels within user namespace (analogously to mapping
+	  UIDs) and to gain MAC capabilities over them.
+	  If you are unsure how to answer this question, answer N.
diff --git a/security/smack/Makefile b/security/smack/Makefile
index ee2ebd5..5faebd7 100644
--- a/security/smack/Makefile
+++ b/security/smack/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_SECURITY_SMACK) := smack.o
 
 smack-y := smack_lsm.o smack_access.o smackfs.o
 smack-$(CONFIG_SECURITY_SMACK_NETFILTER) += smack_netfilter.o
+smack-$(CONFIG_SECURITY_SMACK_NS) += smack_ns.o
diff --git a/security/smack/smack.h b/security/smack/smack.h
index 3818d19..a53623a 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -21,6 +21,7 @@
 #include <linux/list.h>
 #include <linux/rculist.h>
 #include <linux/lsm_audit.h>
+#include <linux/user_namespace.h>
 
 /*
  * Smack labels were limited to 23 characters for a long time.
@@ -59,8 +60,36 @@ struct smack_known {
 	struct netlbl_lsm_secattr	smk_netlabel;	/* on wire labels */
 	struct list_head		smk_rules;	/* access rules */
 	struct mutex			smk_rules_lock;	/* lock for rules */
+#ifdef CONFIG_SECURITY_SMACK_NS
+	struct list_head		smk_mapped;	/* namespaced labels */
+	struct mutex			smk_mapped_lock;
+#endif /* CONFIG_SECURITY_SMACK_NS */
 };
 
+#ifdef CONFIG_SECURITY_SMACK_NS
+
+/*
+ * User namespace security pointer content.
+ */
+struct smack_ns {
+	struct list_head		smk_mapped;	/* namespaced labels */
+	struct mutex			smk_mapped_lock;
+};
+
+/*
+ * A single entry for a namespaced/mapped label.
+ */
+struct smack_known_ns {
+	struct list_head	smk_list_known;
+	struct list_head	smk_list_ns;
+	struct user_namespace	*smk_ns;
+	char			*smk_mapped;
+	struct smack_known	*smk_unmapped;
+	bool			smk_allocated;
+};
+
+#endif /* CONFIG_SECURITY_SMACK_NS */
+
 /*
  * Maximum number of bytes for the levels in a CIPSO IP option.
  * Why 23? CIPSO is constrained to 30, so a 32 byte buffer is
@@ -245,7 +274,7 @@ int smk_tskacc(struct task_struct *, struct smack_known *,
 	       u32, struct smk_audit_info *);
 int smk_curacc(struct smack_known *, u32, struct smk_audit_info *);
 struct smack_known *smack_from_secid(const u32);
-char *smk_parse_smack(const char *string, int len);
+char *smk_parse_smack(const char *string, int len, bool *allocated);
 int smk_netlbl_mls(int, char *, struct netlbl_lsm_secattr *, int);
 struct smack_known *smk_import_entry(const char *, int);
 void smk_insert_entry(struct smack_known *skp);
@@ -254,6 +283,17 @@ char *smk_find_label_name(struct smack_known *skp);
 struct smack_known *smk_get_label(const char *string, int len, bool import);
 
 /*
+ * These functions are in smack_ns.c
+ */
+#ifdef CONFIG_SECURITY_SMACK_NS
+struct user_namespace *smk_find_mapped_ns(struct user_namespace *ns);
+struct smack_known_ns *smk_find_mapped(struct smack_known *skp,
+				       struct user_namespace *ns);
+struct smack_known *smk_find_unmapped(const char *string, int len,
+				      struct user_namespace *ns);
+#endif /* CONFIG_SECURITY_SMACK_NS */
+
+/*
  * Shared data.
  */
 extern int smack_enabled;
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 47a9c92..c4d90d2 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -452,13 +452,16 @@ struct smack_known *smk_find_entry(const char *string)
 /**
  * smk_parse_smack - parse smack label from a text string
  * @string: a text string that might contain a Smack label
- * @len: the maximum size, or zero if it is NULL terminated.
+ * @len: the maximum size, or zero if it is NULL terminated
+ * @allocated: (out) indicates whether the return string has been
+ *             allocated and has to be freed with kfree() later
+ *             (built-in labels returned are not allocated)
  *
  * Returns a pointer to the clean label or an error code.
  */
-char *smk_parse_smack(const char *string, int len)
+char *smk_parse_smack(const char *string, int len, bool *allocated)
 {
-	char *smack;
+	char *smack = NULL;
 	int i;
 
 	if (len <= 0)
@@ -480,11 +483,33 @@ char *smk_parse_smack(const char *string, int len)
 	if (i == 0 || i >= SMK_LONGLABEL)
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * Look for special labels. This way we guarantee that we can compare
+	 * special labels in mapped entries by ==, without strcmp().
+	 */
+	if (len == 1 && !strcmp(string, smack_known_huh.smk_known))
+		smack = smack_known_huh.smk_known;
+	else if (len == 1 && !strcmp(string, smack_known_hat.smk_known))
+		smack = smack_known_hat.smk_known;
+	else if (len == 1 && !strcmp(string, smack_known_star.smk_known))
+		smack = smack_known_star.smk_known;
+	else if (len == 1 && !strcmp(string, smack_known_floor.smk_known))
+		smack = smack_known_floor.smk_known;
+	else if (len == 1 && !strcmp(string, smack_known_web.smk_known))
+		smack = smack_known_web.smk_known;
+
+	if (smack) {
+		*allocated = false;
+
+		return smack;
+	}
+
 	smack = kzalloc(i + 1, GFP_KERNEL);
 	if (smack == NULL)
 		return ERR_PTR(-ENOMEM);
 
 	strncpy(smack, string, i);
+	*allocated = true;
 
 	return smack;
 }
@@ -540,8 +565,9 @@ struct smack_known *smk_import_entry(const char *string, int len)
 	char *smack;
 	int slen;
 	int rc;
+	bool allocated;
 
-	smack = smk_parse_smack(string, len);
+	smack = smk_parse_smack(string, len, &allocated);
 	if (IS_ERR(smack))
 		return ERR_CAST(smack);
 
@@ -577,6 +603,10 @@ struct smack_known *smk_import_entry(const char *string, int len)
 	if (rc >= 0) {
 		INIT_LIST_HEAD(&skp->smk_rules);
 		mutex_init(&skp->smk_rules_lock);
+#ifdef CONFIG_SECURITY_SMACK_NS
+		INIT_LIST_HEAD(&skp->smk_mapped);
+		mutex_init(&skp->smk_mapped_lock);
+#endif /* CONFIG_SECURITY_SMACK_NS */
 		/*
 		 * Make sure that the entry is actually
 		 * filled before putting it on the list.
@@ -590,7 +620,8 @@ struct smack_known *smk_import_entry(const char *string, int len)
 	kfree(skp);
 	skp = ERR_PTR(rc);
 freeout:
-	kfree(smack);
+	if (allocated)
+		kfree(smack);
 unlockout:
 	mutex_unlock(&smack_known_lock);
 
@@ -649,16 +680,19 @@ char *smk_find_label_name(struct smack_known *skp)
 struct smack_known *smk_get_label(const char *string, int len, bool import)
 {
 	struct smack_known *skp;
+	bool allocated;
 	char *cp;
 
 	if (import) {
 		skp = smk_import_entry(string, len);
 	} else {
-		cp = smk_parse_smack(string, len);
+		cp = smk_parse_smack(string, len, &allocated);
 		if (IS_ERR(cp))
 			return ERR_CAST(cp);
 
 		skp = smk_find_entry(cp);
+		if (allocated)
+			kfree(cp);
 	}
 
 	return skp;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index bb74ca9..4ae9a9a 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -41,6 +41,7 @@
 #include <linux/msg.h>
 #include <linux/shm.h>
 #include <linux/binfmts.h>
+#include <linux/user_namespace.h>
 #include "smack.h"
 
 #define TRANS_TRUE	"TRUE"
@@ -4165,6 +4166,53 @@ static void smack_audit_rule_free(void *vrule)
 
 #endif /* CONFIG_AUDIT */
 
+#ifdef CONFIG_SECURITY_SMACK_NS
+
+static inline int smack_userns_create(struct user_namespace *ns)
+{
+	struct smack_ns *snsp;
+
+	snsp = kzalloc(sizeof(*snsp), GFP_KERNEL);
+	if (snsp == NULL)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&snsp->smk_mapped);
+	mutex_init(&snsp->smk_mapped_lock);
+
+	ns->security = snsp;
+	return 0;
+}
+
+static inline void smack_userns_free(struct user_namespace *ns)
+{
+	struct smack_ns *snsp = ns->security;
+	struct smack_known *skp;
+	struct smack_known_ns *sknp, *n;
+
+	list_for_each_entry_safe(sknp, n, &snsp->smk_mapped, smk_list_ns) {
+		skp = sknp->smk_unmapped;
+
+		mutex_lock(&skp->smk_mapped_lock);
+		list_del_rcu(&sknp->smk_list_known);
+		if (sknp->smk_allocated)
+			kfree(sknp->smk_mapped);
+		kfree(sknp);
+		mutex_unlock(&skp->smk_mapped_lock);
+
+		list_del(&sknp->smk_list_ns);
+	}
+
+	kfree(snsp);
+}
+
+static inline int smack_userns_setns(struct nsproxy *nsproxy,
+				     struct user_namespace *ns)
+{
+	return 0;
+}
+
+#endif /* CONFIG_SECURITY_SMACK_NS */
+
 /**
  * smack_ismaclabel - check if xattr @name references a smack MAC label
  * @name: Full xattr name to check.
@@ -4376,6 +4424,13 @@ struct security_hook_list smack_hooks[] = {
 	LSM_HOOK_INIT(audit_rule_free, smack_audit_rule_free),
 #endif /* CONFIG_AUDIT */
 
+ /* Namespace hooks */
+#ifdef CONFIG_SECURITY_SMACK_NS
+	LSM_HOOK_INIT(userns_create, smack_userns_create),
+	LSM_HOOK_INIT(userns_free, smack_userns_free),
+	LSM_HOOK_INIT(userns_setns, smack_userns_setns),
+#endif /* CONFIG_SECURITY_SMACK_NS */
+
 	LSM_HOOK_INIT(ismaclabel, smack_ismaclabel),
 	LSM_HOOK_INIT(secid_to_secctx, smack_secid_to_secctx),
 	LSM_HOOK_INIT(secctx_to_secid, smack_secctx_to_secid),
@@ -4388,6 +4443,27 @@ struct security_hook_list smack_hooks[] = {
 
 static __init void init_smack_known_list(void)
 {
+#ifdef CONFIG_SECURITY_SMACK_NS
+	/*
+	 * Initialize mapped list locks
+	 */
+	mutex_init(&smack_known_huh.smk_mapped_lock);
+	mutex_init(&smack_known_hat.smk_mapped_lock);
+	mutex_init(&smack_known_floor.smk_mapped_lock);
+	mutex_init(&smack_known_star.smk_mapped_lock);
+	mutex_init(&smack_known_invalid.smk_mapped_lock);
+	mutex_init(&smack_known_web.smk_mapped_lock);
+	/*
+	 * Initialize mapped lists
+	 */
+	INIT_LIST_HEAD(&smack_known_huh.smk_mapped);
+	INIT_LIST_HEAD(&smack_known_hat.smk_mapped);
+	INIT_LIST_HEAD(&smack_known_star.smk_mapped);
+	INIT_LIST_HEAD(&smack_known_floor.smk_mapped);
+	INIT_LIST_HEAD(&smack_known_invalid.smk_mapped);
+	INIT_LIST_HEAD(&smack_known_web.smk_mapped);
+#endif /* CONFIG_SECURITY_SMACK_NS */
+
 	/*
 	 * Initialize rule list locks
 	 */
diff --git a/security/smack/smack_ns.c b/security/smack/smack_ns.c
new file mode 100644
index 0000000..141a836
--- /dev/null
+++ b/security/smack/smack_ns.c
@@ -0,0 +1,432 @@
+/*
+ * Copyright (C) 2014 Samsung Electronics.
+ *
+ * Smack namespaces
+ *
+ * Author(s):
+ *    Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
+ *
+ * This program is free software, you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/file.h>
+#include <linux/ctype.h>
+#include <linux/rculist.h>
+#include <linux/seq_file.h>
+#include <linux/user_namespace.h>
+#include "smack.h"
+
+/**
+ * smk_find_mapped_ns - Finds a first namespace from this one through
+ * its parrents that has a map. This map is the effective map in this
+ * namespace.
+ * @ns: a user namespace for which we search for a mapped ns
+ *
+ * Returns a namespace that has a non-NULL map, or NULL if there is
+ * no mapped namespace.
+ *
+ * Can be effectively used to answer a question: "is there a Smack
+ * map for this namespace?"
+ */
+struct user_namespace *smk_find_mapped_ns(struct user_namespace *ns)
+{
+	struct user_namespace *user_ns = ns;
+
+	do {
+		struct smack_ns *sns = user_ns->security;
+
+		if (sns && !list_empty(&sns->smk_mapped))
+			break;
+
+		user_ns = user_ns->parent;
+	} while (user_ns);
+
+	return user_ns;
+}
+
+/**
+ * __smk_find_mapped - an internal version of smk_find_mapped
+ *                     that doesn't use smk_find_mapped_ns, but
+ *                     operates directly on the passed one.
+ */
+static struct smack_known_ns *__smk_find_mapped(struct smack_known *skp,
+						struct user_namespace *ns)
+{
+	struct smack_known_ns *sknp;
+
+	if (ns == NULL)
+		return NULL;
+
+	list_for_each_entry_rcu(sknp, &skp->smk_mapped, smk_list_known)
+		if (sknp->smk_ns == ns)
+			return sknp;
+
+	return NULL;
+}
+
+/**
+ * smk_find_mapped - Finds a mapped label on the smack_known's mapped list
+ * @skp: a label which mapped label we look for
+ * @ns: a user namespace the label we search for is assigned to
+ *
+ * Returns a pointer to the mapped label if one exists that is
+ * assigned to the specified user namespace or NULL if not found.
+ */
+struct smack_known_ns *smk_find_mapped(struct smack_known *skp,
+				       struct user_namespace *ns)
+{
+	struct user_namespace *user_ns = smk_find_mapped_ns(ns);
+
+	return __smk_find_mapped(skp, user_ns);
+}
+
+/**
+ * __smk_find_unmapped - an internal version of smk_find_unmapped
+ *                       that doesn't use smk_find_mapped_ns, but
+ *                       operates directly on the passed one.
+ */
+static struct smack_known *__smk_find_unmapped(const char *string, int len,
+					       struct user_namespace *ns)
+{
+	struct smack_ns *snsp;
+	struct smack_known *skp = NULL;
+	struct smack_known_ns *sknp;
+	char *smack;
+	bool allocated = false;
+
+	if (ns == NULL)
+		return NULL;
+
+	snsp = ns->security;
+
+	smack = smk_parse_smack(string, len, &allocated);
+	if (IS_ERR(smack))
+		return ERR_CAST(smack);
+
+	list_for_each_entry_rcu(sknp, &snsp->smk_mapped, smk_list_ns) {
+		if (strcmp(smack, sknp->smk_mapped) == 0) {
+			skp = sknp->smk_unmapped;
+			break;
+		}
+	}
+
+	if (allocated)
+		kfree(smack);
+	return skp;
+}
+
+/**
+ * smk_find_unmapped - Finds an original label by a mapped label string
+ *                     and the namespace it could be mapped in
+ * @string: a name of a mapped label we look for
+ * @len: the string size, or zero if it is NULL terminated.
+ * @ns: a namespace the looked for label should be mapped in
+ *
+ * Returns a smack_known label that is mapped as 'string' in 'ns',
+ * NULL if not found or an error code.
+ */
+struct smack_known *smk_find_unmapped(const char *string, int len,
+				      struct user_namespace *ns)
+{
+	struct user_namespace *user_ns = smk_find_mapped_ns(ns);
+
+	return __smk_find_unmapped(string, len, user_ns);
+}
+
+/**
+ * smk_import_mapped - Imports a mapped label effectively creating a mapping.
+ * @skp: a label we map
+ * @ns: a user namespace this label will be mapped in
+ * @string: a text string of the mapped label
+ * @len: the maximum size, or zero if it is NULL terminanted
+ *
+ * Returns a pointer to the mapped label entry or an error code.
+ *
+ * The mapped label will be added to 2 lists:
+ *   - a list of mapped labels of skp
+ *   - a list of labels mapped in ns
+ */
+static struct smack_known_ns *smk_import_mapped(struct smack_known *skp,
+						struct user_namespace *ns,
+						const char *string, int len)
+{
+	struct smack_ns *snsp = ns->security;
+	struct smack_known_ns *sknp;
+	char *mapped;
+	bool allocated;
+
+	/* Mapping init_user_ns is against the design and pointless */
+	if (ns == &init_user_ns)
+		return ERR_PTR(-EBADR);
+
+	mapped = smk_parse_smack(string, len, &allocated);
+	if (IS_ERR(mapped))
+		return ERR_CAST(mapped);
+
+	mutex_lock(&skp->smk_mapped_lock);
+
+	/*
+	 * Don't allow one<->many mappings in namespace, rename.
+	 * This code won't get triggered for now as trying to assign
+	 * a duplicate is forbidden in proc_smack_map_write().
+	 * Leaving this as this function might be also used elsewhere.
+	 */
+	sknp = smk_find_mapped(skp, ns);
+	if (sknp != NULL) {
+		if (sknp->smk_allocated)
+			kfree(sknp->smk_mapped);
+		sknp->smk_mapped = mapped;
+		sknp->smk_allocated = allocated;
+		goto unlockout;
+	}
+
+	sknp = kzalloc(sizeof(*sknp), GFP_KERNEL);
+	if (sknp == NULL) {
+		sknp = ERR_PTR(-ENOMEM);
+		if (allocated)
+			kfree(mapped);
+		goto unlockout;
+	}
+
+	sknp->smk_ns = ns;
+	sknp->smk_mapped = mapped;
+	sknp->smk_allocated = allocated;
+	sknp->smk_unmapped = skp;
+	list_add_rcu(&sknp->smk_list_known, &skp->smk_mapped);
+
+	mutex_lock(&snsp->smk_mapped_lock);
+	list_add_rcu(&sknp->smk_list_ns, &snsp->smk_mapped);
+	mutex_unlock(&snsp->smk_mapped_lock);
+
+unlockout:
+	mutex_unlock(&skp->smk_mapped_lock);
+
+	return sknp;
+}
+
+static void *proc_smack_map_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct smack_known *skp;
+	struct user_namespace *ns = seq->private;
+	loff_t counter = *pos;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(skp, &smack_known_list, list)
+		if (smk_find_mapped(skp, ns) && counter-- == 0)
+			return skp;
+
+	return NULL;
+}
+
+static void proc_smack_map_seq_stop(struct seq_file *seq, void *v)
+{
+	rcu_read_unlock();
+}
+
+static void *proc_smack_map_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct smack_known *skp = v;
+	struct user_namespace *ns = seq->private;
+
+	list_for_each_entry_continue_rcu(skp, &smack_known_list, list) {
+		if (smk_find_mapped(skp, ns)) {
+			(*pos)++;
+			return skp;
+		}
+	}
+
+	return NULL;
+}
+
+static int proc_smack_map_seq_show(struct seq_file *seq, void *v)
+{
+	struct smack_known *skp = v;
+	struct user_namespace *ns = seq->private;
+	struct smack_known_ns *sknp;
+
+	/*
+	 * QUESTION: linux-api
+	 * What to print when in init_map_ns where the map is empty
+	 * effectively meaning identity? Unfortunately it's impossible
+	 * to show identity in this syntax without printing all the labels.
+	 */
+	if (smk_find_mapped_ns(ns) == NULL) {
+		seq_puts("This namespace is not mapped.\n");
+	} else {
+		sknp = smk_find_mapped(skp, ns);
+		if (sknp)
+			seq_printf(seq, "%s -> %s\n",
+				   skp->smk_known, sknp->smk_mapped);
+	}
+
+	return 0;
+}
+
+const struct seq_operations proc_smack_map_seq_operations = {
+	.start = proc_smack_map_seq_start,
+	.stop = proc_smack_map_seq_stop,
+	.next = proc_smack_map_seq_next,
+	.show = proc_smack_map_seq_show,
+};
+
+static DEFINE_MUTEX(smk_map_mutex);
+
+static bool mapping_permitted(const struct file *file,
+			      struct user_namespace *user_ns)
+{
+	/*
+	 * Do not allow mapping own label. This is in contrast to user
+	 * namespace where you can always map your own UID. In Smack having
+	 * administrative privileges over your own label (which Smack
+	 * namespace effectively gives you) is not equivalent to user
+	 * namespace. E.g. things like setting exec/transmute labels that
+	 * otherwise would be denied. Hence no own_label param here.
+	 */
+
+	/*
+	 * Adjusting namespace settings requires capabilities on the target.
+	 */
+	if (!file_ns_capable(file, user_ns, CAP_MAC_ADMIN))
+		return false;
+
+	/*
+	 * And it requires capabilities in the parent.
+	 *
+	 * If the Smack namespace was properly hierarchical the user_ns to
+	 * check against could be 'user_ns->parent'. Right now because of
+	 * security concerns only privileged initial namespace is allowed
+	 * to fill the map. For a hierarchical namespaces one would
+	 * implement mapping (in the child namespaces) of only mapped labels
+	 * (in parent namespace) and change '&init_user_ns' to
+	 * 'user_ns->parent'. This will be added in the future.
+	 */
+	if (smack_ns_privileged(&init_user_ns, CAP_MAC_ADMIN) &&
+	    file_ns_capable(file, &init_user_ns, CAP_MAC_ADMIN))
+		return true;
+
+	return false;
+}
+
+ssize_t proc_smack_map_write(struct file *file, const char __user *buf,
+			     size_t size, loff_t *ppos)
+{
+	struct seq_file *seq = file->private_data;
+	struct user_namespace *ns = seq->private;
+	struct user_namespace *seq_ns = seq_user_ns(seq);
+	struct smack_known *skp;
+	struct smack_known_ns *sknp;
+	unsigned long page = 0;
+	char *kbuf, *pos, *next_line, *tok[2];
+	ssize_t ret;
+	int i;
+
+	/* Mapping labels for the init ns makes no sense */
+	if (ns == &init_user_ns)
+		return -EBADR;
+
+	if ((seq_ns != ns) && (seq_ns != ns->parent))
+		return -EPERM;
+
+	mutex_lock(&smk_map_mutex);
+
+	ret = -EPERM;
+	if (!mapping_permitted(file, ns))
+		goto out;
+
+	/* Get a buffer */
+	ret = ENOMEM;
+	page = __get_free_page(GFP_TEMPORARY);
+	if (!page)
+		goto out;
+	kbuf = (char *)page;
+
+	/* Only allow <= page size writes at the beginning of the file */
+	ret = -EINVAL;
+	if ((*ppos != 0) || (size >= PAGE_SIZE))
+		goto out;
+
+	/* Slurp in the user data */
+	ret = -EFAULT;
+	if (copy_from_user(kbuf, buf, size))
+		goto out;
+	kbuf[size] = '\0';
+
+	/* Parse the user data */
+	pos = kbuf;
+
+	for (; pos; pos = next_line) {
+		ret = -EINVAL;
+
+		/* Find the end of line and ensure I don't look past it */
+		next_line = strchr(pos, '\n');
+		if (next_line) {
+			*next_line = '\0';
+			next_line++;
+			if (*next_line == '\0')
+				next_line = NULL;
+		}
+
+		/* Find tokens in line */
+		for (i = 0; i < 2; ++i) {
+			while (isspace(*pos))
+				*(pos++) = '\0';
+
+			/* unexpected end of file */
+			if (*pos == '\0')
+				goto out;
+
+			tok[i] = pos;
+
+			/* find the end of the token */
+			while (*pos != '\0' && !isspace(*pos))
+				++pos;
+		}
+
+		/* NUL terminate the last token if not EOL */
+		while (isspace(*pos))
+			*(pos++) = '\0';
+
+		/* there should not be any trailing data */
+		if (*pos != '\0')
+			goto out;
+
+		/* do not allow to map 2 different labels to one name */
+		skp = __smk_find_unmapped(tok[1], 0, ns);
+		if (IS_ERR(skp)) {
+			ret = PTR_ERR(skp);
+			goto out;
+		}
+		if (skp != NULL) {
+			ret = -EEXIST;
+			goto out;
+		}
+
+		skp = smk_import_entry(tok[0], 0);
+		if (IS_ERR(skp)) {
+			ret = PTR_ERR(skp);
+			goto out;
+		}
+
+		/* do not allow remapping */
+		ret = -EEXIST;
+		if (__smk_find_mapped(skp, ns))
+			goto out;
+
+		sknp = smk_import_mapped(skp, ns, tok[1], 0);
+		if (IS_ERR(sknp)) {
+			ret = PTR_ERR(sknp);
+			goto out;
+		}
+	}
+
+	ret = size;
+
+out:
+	mutex_unlock(&smk_map_mutex);
+	if (page)
+		free_page(page);
+
+	return ret;
+}
-- 
2.1.0
