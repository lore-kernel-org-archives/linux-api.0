From: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 7/8] smack: namespace implementation
Date: Thu, 21 May 2015 13:53:41 +0200
Message-ID: <1432209222-8479-8-git-send-email-l.pawelczyk__16977.7150186293$1432209328$gmane$org@samsung.com>
References: <1432209222-8479-1-git-send-email-l.pawelczyk@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1432209222-8479-1-git-send-email-l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ionut Alexa <ionut.m.alexa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Mauro Carvalho Chehab <mchehab@os>
Cc: Lukasz Pawelczyk <havner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This commit uses all the changes introduced in "namespace groundwork"
and previous preparation patches and makes smack aware of its namespace
and mapped labels.

It modifies the following functions to be namespace aware:
- smk_access
- smk_find_label_name
- smk_get_label

And all functions that use them (e.g. smk_tskacc).

It also adds another function that is used throughout Smack LSM hooks:
- smk_labels_valid - it checks whether both, subject and object labels
  are properly mapped in a namespace where they are to be used. This
  function is used mostly together with a capability check when there is
  no proper access check that usually checks for that.

All the Smack LSM hooks have been adapted to be namespace aware.

The capabilities (CAP_MAC_ADMIN, CAP_MAC_OVERRIDE) has been allowed in
the namespace for few cases. Check the documentation for the details.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 security/smack/smack.h        |  61 ++++++-
 security/smack/smack_access.c |  99 ++++++++++--
 security/smack/smack_lsm.c    | 358 ++++++++++++++++++++++++++++++------------
 security/smack/smack_ns.c     |  41 ++++-
 security/smack/smackfs.c      |  57 ++++---
 5 files changed, 474 insertions(+), 142 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index a53623a..b8ed852 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -104,6 +104,7 @@ struct superblock_smack {
 	struct smack_known	*smk_floor;
 	struct smack_known	*smk_hat;
 	struct smack_known	*smk_default;
+	struct user_namespace	*smk_ns;
 	int			smk_initialized;
 };
 
@@ -111,6 +112,7 @@ struct socket_smack {
 	struct smack_known	*smk_out;	/* outbound label */
 	struct smack_known	*smk_in;	/* inbound label */
 	struct smack_known	*smk_packet;	/* TCP peer label */
+	struct user_namespace	*smk_ns;	/* user namespace */
 };
 
 /*
@@ -131,6 +133,14 @@ struct task_smack {
 	struct mutex		smk_rules_lock;	/* lock for the rules */
 };
 
+/*
+ * Used for IPC objects (sem, shm, etc)
+ */
+struct ipc_smack {
+	struct smack_known	*smk_known;	/* label for access control */
+	struct user_namespace	*smk_ns;	/* user namespace */
+};
+
 #define	SMK_INODE_INSTANT	0x01	/* inode is instantiated */
 #define	SMK_INODE_TRANSMUTE	0x02	/* directory is transmuting */
 #define	SMK_INODE_CHANGED	0x04	/* smack was transmuted */
@@ -269,18 +279,20 @@ struct inode_smack *new_inode_smack(struct smack_known *);
  */
 int smk_access_entry(char *, char *, struct list_head *);
 int smk_access(struct smack_known *, struct smack_known *,
-	       int, struct smk_audit_info *);
+	       struct user_namespace *, int, struct smk_audit_info *);
 int smk_tskacc(struct task_struct *, struct smack_known *,
+	       struct user_namespace *, u32, struct smk_audit_info *);
+int smk_curacc(struct smack_known *, struct user_namespace *,
 	       u32, struct smk_audit_info *);
-int smk_curacc(struct smack_known *, u32, struct smk_audit_info *);
 struct smack_known *smack_from_secid(const u32);
 char *smk_parse_smack(const char *string, int len, bool *allocated);
 int smk_netlbl_mls(int, char *, struct netlbl_lsm_secattr *, int);
 struct smack_known *smk_import_entry(const char *, int);
 void smk_insert_entry(struct smack_known *skp);
 struct smack_known *smk_find_entry(const char *);
-char *smk_find_label_name(struct smack_known *skp);
-struct smack_known *smk_get_label(const char *string, int len, bool import);
+char *smk_find_label_name(struct smack_known *skp, struct user_namespace *ns);
+struct smack_known *smk_get_label(const char *string, int len, bool import,
+				  struct user_namespace *ns);
 
 /*
  * These functions are in smack_ns.c
@@ -291,6 +303,15 @@ struct smack_known_ns *smk_find_mapped(struct smack_known *skp,
 				       struct user_namespace *ns);
 struct smack_known *smk_find_unmapped(const char *string, int len,
 				      struct user_namespace *ns);
+bool smk_labels_valid(struct smack_known *sbj, struct smack_known *obj,
+		      struct user_namespace *ns);
+#else
+static inline bool smk_labels_valid(struct smack_known *sbj,
+				    struct smack_known *obj,
+				    struct user_namespace *ns)
+{
+	return true;
+}
 #endif /* CONFIG_SECURITY_SMACK_NS */
 
 /*
@@ -397,18 +418,48 @@ static inline struct smack_known *smk_of_current(void)
 }
 
 /*
+ * Present a pointer to the user namespace entry in an task blob.
+ */
+static inline
+struct user_namespace *ns_of_task_struct(const struct task_struct *t)
+{
+	struct user_namespace *ns;
+
+	rcu_read_lock();
+	ns = __task_cred(t)->user_ns;
+	rcu_read_unlock();
+
+	return ns;
+}
+
+/*
+ * Present a pointer to the user namespace entry in the current task blob.
+ */
+static inline struct user_namespace *ns_of_current(void)
+{
+	return current->cred->user_ns;
+}
+
+/*
  * Internal smack capability check complimentary to the
  * set of kernel capable() and has_capability() functions
  *
  * For a capability in smack related checks to be effective it needs to:
  * - have empty onlycap or the current label be the same as onlycap
- * - be in the initial user ns
+ * - be in the initial user ns or have a filled map in the child ns
  */
 static inline int smack_capability_allowed(struct smack_known *skp,
 					   struct user_namespace *user_ns)
 {
+#ifdef CONFIG_SECURITY_SMACK_NS
+	struct smack_ns *sns = user_ns->security;
+
+	if (user_ns != &init_user_ns && list_empty(&sns->smk_mapped))
+		return 0;
+#else
 	if (user_ns != &init_user_ns)
 		return 0;
+#endif /* CONFIG_SECURITY_SMACK_NS */
 
 	if (smack_onlycap != NULL && smack_onlycap != skp)
 		return 0;
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index c4d90d2..600e95c 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
+#include <linux/user_namespace.h>
 #include "smack.h"
 
 struct smack_known smack_known_huh = {
@@ -113,6 +114,7 @@ int smk_access_entry(char *subject_label, char *object_label,
  * smk_access - determine if a subject has a specific access to an object
  * @subject: a pointer to the subject's Smack label entry
  * @object: a pointer to the object's Smack label entry
+ * @ns: user namespace to check against (usually subject's)
  * @request: the access requested, in "MAY" format
  * @a : a pointer to the audit data
  *
@@ -123,10 +125,34 @@ int smk_access_entry(char *subject_label, char *object_label,
  * Smack labels are shared on smack_list
  */
 int smk_access(struct smack_known *subject, struct smack_known *object,
-	       int request, struct smk_audit_info *a)
+	       struct user_namespace *ns, int request, struct smk_audit_info *a)
 {
 	int may = MAY_NOT;
 	int rc = 0;
+	char *subject_label = subject->smk_known;
+	char *object_label = object->smk_known;
+#ifdef CONFIG_SECURITY_SMACK_NS
+	struct smack_known_ns *sknp;
+	struct smack_known_ns *oknp;
+
+	/*
+	 * For the namespaced case we need to check whether the labels
+	 * are mapped. If not, refuse. If yes check the builtin rules
+	 * on the mapped label strings so the builtin labels can
+	 * work properly inside the namespace.
+	 */
+	if (smk_find_mapped_ns(ns)) {
+		sknp = smk_find_mapped(subject, ns);
+		oknp = smk_find_mapped(object, ns);
+		if (!sknp || !oknp) {
+			rc = -EACCES;
+			goto out_audit;
+		}
+
+		subject_label = sknp->smk_mapped;
+		object_label = oknp->smk_mapped;
+	}
+#endif
 
 	/*
 	 * Hardcoded comparisons.
@@ -134,7 +160,7 @@ int smk_access(struct smack_known *subject, struct smack_known *object,
 	/*
 	 * A star subject can't access any object.
 	 */
-	if (subject == &smack_known_star) {
+	if (subject_label == smack_known_star.smk_known) {
 		rc = -EACCES;
 		goto out_audit;
 	}
@@ -143,18 +169,19 @@ int smk_access(struct smack_known *subject, struct smack_known *object,
 	 * Tasks cannot be assigned the internet label.
 	 * An internet subject can access any object.
 	 */
-	if (object == &smack_known_web || subject == &smack_known_web)
+	if (object_label == smack_known_web.smk_known ||
+	    subject_label == smack_known_web.smk_known)
 		goto out_audit;
 	/*
 	 * A star object can be accessed by any subject.
 	 */
-	if (object == &smack_known_star)
+	if (object_label == smack_known_star.smk_known)
 		goto out_audit;
 	/*
 	 * An object can be accessed in any way by a subject
 	 * with the same label.
 	 */
-	if (subject->smk_known == object->smk_known)
+	if (subject_label == object_label)
 		goto out_audit;
 	/*
 	 * A hat subject can read or lock any object.
@@ -162,9 +189,9 @@ int smk_access(struct smack_known *subject, struct smack_known *object,
 	 */
 	if ((request & MAY_ANYREAD) == request ||
 	    (request & MAY_LOCK) == request) {
-		if (object == &smack_known_floor)
+		if (object_label == smack_known_floor.smk_known)
 			goto out_audit;
-		if (subject == &smack_known_hat)
+		if (subject_label == smack_known_hat.smk_known)
 			goto out_audit;
 	}
 
@@ -174,6 +201,7 @@ int smk_access(struct smack_known *subject, struct smack_known *object,
 	 * access (e.g. read is included in readwrite) it's
 	 * good. A negative response from smk_access_entry()
 	 * indicates there is no entry for this pair.
+	 * For this check we need real, not mapped labels.
 	 */
 	rcu_read_lock();
 	may = smk_access_entry(subject->smk_known, object->smk_known,
@@ -219,6 +247,7 @@ out_audit:
  * smk_tskacc - determine if a task has a specific access to an object
  * @tsp: a pointer to the subject's task
  * @obj_known: a pointer to the object's label entry
+ * @obj_ns: an object's namespace to check the caps against
  * @mode: the access requested, in "MAY" format
  * @a : common audit data
  *
@@ -228,16 +257,18 @@ out_audit:
  * to override the rules.
  */
 int smk_tskacc(struct task_struct *task, struct smack_known *obj_known,
-	       u32 mode, struct smk_audit_info *a)
+	       struct user_namespace *obj_ns, u32 mode,
+	       struct smk_audit_info *a)
 {
 	struct smack_known *sbj_known = smk_of_task_struct(task);
+	struct user_namespace *sbj_ns = ns_of_task_struct(task);
 	int may;
 	int rc;
 
 	/*
 	 * Check the global rule list
 	 */
-	rc = smk_access(sbj_known, obj_known, mode, NULL);
+	rc = smk_access(sbj_known, obj_known, sbj_ns, mode, NULL);
 	if (rc >= 0) {
 		struct task_smack *tsp;
 
@@ -261,8 +292,10 @@ int smk_tskacc(struct task_struct *task, struct smack_known *obj_known,
 
 	/*
 	 * Allow for priviliged to override policy.
+	 * Either in init_ns or when both labels are mapped.
 	 */
-	if (rc != 0 && smack_privileged(CAP_MAC_OVERRIDE))
+	if (rc != 0 && smk_labels_valid(sbj_known, obj_known, sbj_ns)
+	    && smack_has_ns_privilege(task, obj_ns, CAP_MAC_OVERRIDE))
 		rc = 0;
 
 out_audit:
@@ -277,6 +310,7 @@ out_audit:
 /**
  * smk_curacc - determine if current has a specific access to an object
  * @obj_known: a pointer to the object's Smack label entry
+ * @obj_ns: an object's namespace to check the caps against
  * @mode: the access requested, in "MAY" format
  * @a : common audit data
  *
@@ -285,10 +319,10 @@ out_audit:
  * non zero otherwise. It allows that current may have the capability
  * to override the rules.
  */
-int smk_curacc(struct smack_known *obj_known,
+int smk_curacc(struct smack_known *obj_known, struct user_namespace *obj_ns,
 	       u32 mode, struct smk_audit_info *a)
 {
-	return smk_tskacc(current, obj_known, mode, a);
+	return smk_tskacc(current, obj_known, obj_ns, mode, a);
 }
 
 #ifdef CONFIG_AUDIT
@@ -656,14 +690,32 @@ struct smack_known *smack_from_secid(const u32 secid)
 }
 
 /**
- * smk_find_label_name - A helper to get a string value of a label
+ * smk_find_label_name - A helper to get a string value of either a label or a
+ *                       mapped label when inside a namespace
  * @skp: a label we want a string value from
+ * @ns: namespace against which we want to get the value
  *
  * Returns a pointer to a label name or NULL if label name not found.
  */
-char *smk_find_label_name(struct smack_known *skp)
+char *smk_find_label_name(struct smack_known *skp, struct user_namespace *ns)
 {
-	return skp->smk_known;
+	char *name = NULL;
+
+#ifdef CONFIG_SECURITY_SMACK_NS
+	struct smack_known_ns *sknp;
+
+	if (smk_find_mapped_ns(ns)) {
+		sknp = smk_find_mapped(skp, ns);
+		if (sknp != NULL)
+			name = sknp->smk_mapped;
+	} else {
+		name = skp->smk_known;
+	}
+#else
+	name = skp->smk_known;
+#endif
+
+	return name;
 }
 
 /**
@@ -672,17 +724,32 @@ char *smk_find_label_name(struct smack_known *skp)
  * @string: a name of a label we look for or want to import
  * @len: the string size, or zero if it is NULL terminated
  * @import: whether we should import the label if not found
+ * @ns: a namespace the looked for label should be in
  *
  * Returns a smack_known label that is either imported or found.
  * NULL if label not found (only when import == false).
  * Error code otherwise.
  */
-struct smack_known *smk_get_label(const char *string, int len, bool import)
+struct smack_known *smk_get_label(const char *string, int len, bool import,
+				  struct user_namespace *ns)
 {
 	struct smack_known *skp;
 	bool allocated;
 	char *cp;
 
+#ifdef CONFIG_SECURITY_SMACK_NS
+	if (smk_find_mapped_ns(ns)) {
+		skp = smk_find_unmapped(string, len, ns);
+
+		/* Label not found but we can't import in namespaces */
+		if (skp == NULL && import)
+			skp = ERR_PTR(-EBADR);
+
+		/* will also return error codes from smk_find_unmapped() */
+		return skp;
+	}
+#endif
+
 	if (import) {
 		skp = smk_import_entry(string, len);
 	} else {
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 4ae9a9a..af0a5fd 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -373,6 +373,7 @@ static inline unsigned int smk_ptrace_mode(unsigned int mode)
  * smk_ptrace_rule_check - helper for ptrace access
  * @tracer: tracer process
  * @tracee_known: label entry of the process that's about to be traced
+ * @tracee_ns: a tracee's namespace to check the caps against
  * @mode: ptrace attachment mode (PTRACE_MODE_*)
  * @func: name of the function that called us, used for audit
  *
@@ -380,6 +381,7 @@ static inline unsigned int smk_ptrace_mode(unsigned int mode)
  */
 static int smk_ptrace_rule_check(struct task_struct *tracer,
 				 struct smack_known *tracee_known,
+				 struct user_namespace *tracee_ns,
 				 unsigned int mode, const char *func)
 {
 	int rc;
@@ -391,21 +393,28 @@ static int smk_ptrace_rule_check(struct task_struct *tracer,
 		saip = &ad;
 	}
 
-
 	if ((mode & PTRACE_MODE_ATTACH) &&
 	    (smack_ptrace_rule == SMACK_PTRACE_EXACT ||
 	     smack_ptrace_rule == SMACK_PTRACE_DRACONIAN)) {
 		struct smack_known *tracer_known = smk_of_task_struct(tracer);
+		struct user_namespace *tracer_ns = ns_of_task_struct(tracer);
+
+		if (!smk_labels_valid(tracer_known, tracee_known, tracer_ns)) {
+			rc = -EACCES;
+			goto out;
+		}
 
 		if (tracer_known->smk_known == tracee_known->smk_known)
 			rc = 0;
 		else if (smack_ptrace_rule == SMACK_PTRACE_DRACONIAN)
 			rc = -EACCES;
-		else if (smack_has_privilege(tracer, CAP_SYS_PTRACE))
+		else if (smack_has_ns_privilege(tracer, tracee_ns,
+						CAP_SYS_PTRACE))
 			rc = 0;
 		else
 			rc = -EPERM;
 
+out:
 		if (saip)
 			smack_log(tracer_known->smk_known,
 				  tracee_known->smk_known,
@@ -415,7 +424,8 @@ static int smk_ptrace_rule_check(struct task_struct *tracer,
 	}
 
 	/* In case of rule==SMACK_PTRACE_DEFAULT or mode==PTRACE_MODE_READ */
-	return smk_tskacc(tracer, tracee_known, smk_ptrace_mode(mode), saip);
+	return smk_tskacc(tracer, tracee_known, tracee_ns,
+			  smk_ptrace_mode(mode), saip);
 }
 
 /*
@@ -435,8 +445,9 @@ static int smk_ptrace_rule_check(struct task_struct *tracer,
 static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
 {
 	struct smack_known *skp = smk_of_task_struct(ctp);
+	struct user_namespace *ns = ns_of_task_struct(ctp);
 
-	return smk_ptrace_rule_check(current, skp, mode, __func__);
+	return smk_ptrace_rule_check(current, skp, ns, mode, __func__);
 }
 
 /**
@@ -450,8 +461,10 @@ static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
 static int smack_ptrace_traceme(struct task_struct *ptp)
 {
 	struct smack_known *skp = smk_of_current();
+	struct user_namespace *ns = ns_of_current();
 
-	return smk_ptrace_rule_check(ptp, skp, PTRACE_MODE_ATTACH, __func__);
+	return smk_ptrace_rule_check(ptp, skp, ns, PTRACE_MODE_ATTACH,
+				     __func__);
 }
 
 /**
@@ -498,6 +511,7 @@ static int smack_sb_alloc_security(struct super_block *sb)
 	sbsp->smk_default = &smack_known_floor;
 	sbsp->smk_floor = &smack_known_floor;
 	sbsp->smk_hat = &smack_known_hat;
+	sbsp->smk_ns = get_user_ns(&init_user_ns);
 	/*
 	 * smk_initialized will be zero from kzalloc.
 	 */
@@ -513,6 +527,9 @@ static int smack_sb_alloc_security(struct super_block *sb)
  */
 static void smack_sb_free_security(struct super_block *sb)
 {
+	struct superblock_smack *sbsp = sb->s_security;
+
+	put_user_ns(sbsp->smk_ns);
 	kfree(sb->s_security);
 	sb->s_security = NULL;
 }
@@ -579,6 +596,7 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 	struct superblock_smack *sp = sb->s_security;
 	struct inode_smack *isp;
 	struct smack_known *skp;
+	struct user_namespace *ns = ns_of_current();
 	char *op;
 	char *commap;
 	int transmute = 0;
@@ -596,7 +614,7 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 
 		if (strncmp(op, SMK_FSHAT, strlen(SMK_FSHAT)) == 0) {
 			op += strlen(SMK_FSHAT);
-			skp = smk_get_label(op, 0, true);
+			skp = smk_get_label(op, 0, true, ns);
 			if (IS_ERR(skp))
 				return PTR_ERR(skp);
 			sp->smk_hat = skp;
@@ -604,7 +622,7 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 
 		} else if (strncmp(op, SMK_FSFLOOR, strlen(SMK_FSFLOOR)) == 0) {
 			op += strlen(SMK_FSFLOOR);
-			skp = smk_get_label(op, 0, true);
+			skp = smk_get_label(op, 0, true, ns);
 			if (IS_ERR(skp))
 				return PTR_ERR(skp);
 			sp->smk_floor = skp;
@@ -613,7 +631,7 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 		} else if (strncmp(op, SMK_FSDEFAULT,
 				   strlen(SMK_FSDEFAULT)) == 0) {
 			op += strlen(SMK_FSDEFAULT);
-			skp = smk_get_label(op, 0, true);
+			skp = smk_get_label(op, 0, true, ns);
 			if (IS_ERR(skp))
 				return PTR_ERR(skp);
 			sp->smk_default = skp;
@@ -621,7 +639,7 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 
 		} else if (strncmp(op, SMK_FSROOT, strlen(SMK_FSROOT)) == 0) {
 			op += strlen(SMK_FSROOT);
-			skp = smk_get_label(op, 0, true);
+			skp = smk_get_label(op, 0, true, ns);
 			if (IS_ERR(skp))
 				return PTR_ERR(skp);
 			sp->smk_root = skp;
@@ -629,7 +647,7 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 
 		} else if (strncmp(op, SMK_FSTRANS, strlen(SMK_FSTRANS)) == 0) {
 			op += strlen(SMK_FSTRANS);
-			skp = smk_get_label(op, 0, true);
+			skp = smk_get_label(op, 0, true, ns);
 			if (IS_ERR(skp))
 				return PTR_ERR(skp);
 			sp->smk_root = skp;
@@ -638,7 +656,12 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 		}
 	}
 
-	if (!smack_privileged(CAP_MAC_ADMIN)) {
+	/*
+	 * Check for non-privileged case. If current is inside the namespace
+	 * and the it has privileges the validity of labels has already been
+	 * checked during smk_get_label()
+	 */
+	if (!smack_ns_privileged(ns, CAP_MAC_ADMIN)) {
 		/*
 		 * Unprivileged mounts don't get to specify Smack values.
 		 */
@@ -651,6 +674,13 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 		sp->smk_root = skp;
 		sp->smk_default = skp;
 	}
+
+	/*
+	 * Set the superblock namespace from a mounting process
+	 */
+	put_user_ns(sp->smk_ns);
+	sp->smk_ns = get_user_ns(ns);
+
 	/*
 	 * Initialize the root inode.
 	 */
@@ -685,7 +715,7 @@ static int smack_sb_statfs(struct dentry *dentry)
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_DENTRY);
 	smk_ad_setfield_u_fs_path_dentry(&ad, dentry);
 
-	rc = smk_curacc(sbp->smk_floor, MAY_READ, &ad);
+	rc = smk_curacc(sbp->smk_floor, sbp->smk_ns, MAY_READ, &ad);
 	rc = smk_bu_current("statfs", sbp->smk_floor, MAY_READ, rc);
 	return rc;
 }
@@ -705,6 +735,7 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
 	struct inode *inode = file_inode(bprm->file);
 	struct task_smack *bsp = bprm->cred->security;
 	struct inode_smack *isp;
+	struct user_namespace *ns = ns_of_current();
 	int rc;
 
 	if (bprm->cred_prepared)
@@ -714,6 +745,13 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
 	if (isp->smk_task == NULL || isp->smk_task == bsp->smk_task)
 		return 0;
 
+#ifdef CONFIG_SECURITY_SMACK_NS
+	/* one label version of smk_labels_valid() */
+	if (smk_find_mapped_ns(ns) &&
+	    smk_find_mapped(isp->smk_task, ns) == NULL)
+		return -EACCES;
+#endif
+
 	if (bprm->unsafe & (LSM_UNSAFE_PTRACE | LSM_UNSAFE_PTRACE_CAP)) {
 		struct task_struct *tracer;
 		rc = 0;
@@ -721,9 +759,8 @@ static int smack_bprm_set_creds(struct linux_binprm *bprm)
 		rcu_read_lock();
 		tracer = ptrace_parent(current);
 		if (likely(tracer != NULL))
-			rc = smk_ptrace_rule_check(tracer,
-						   isp->smk_task,
-						   PTRACE_MODE_ATTACH,
+			rc = smk_ptrace_rule_check(tracer, isp->smk_task,
+						   ns, PTRACE_MODE_ATTACH,
 						   __func__);
 		rcu_read_unlock();
 
@@ -864,6 +901,7 @@ static int smack_inode_link(struct dentry *old_dentry, struct inode *dir,
 			    struct dentry *new_dentry)
 {
 	struct smack_known *isp;
+	struct user_namespace *ns = ns_of_current();
 	struct smk_audit_info ad;
 	int rc;
 
@@ -871,13 +909,13 @@ static int smack_inode_link(struct dentry *old_dentry, struct inode *dir,
 	smk_ad_setfield_u_fs_path_dentry(&ad, old_dentry);
 
 	isp = smk_of_inode(d_backing_inode(old_dentry));
-	rc = smk_curacc(isp, MAY_WRITE, &ad);
+	rc = smk_curacc(isp, ns, MAY_WRITE, &ad);
 	rc = smk_bu_inode(d_backing_inode(old_dentry), MAY_WRITE, rc);
 
 	if (rc == 0 && d_is_positive(new_dentry)) {
 		isp = smk_of_inode(d_backing_inode(new_dentry));
 		smk_ad_setfield_u_fs_path_dentry(&ad, new_dentry);
-		rc = smk_curacc(isp, MAY_WRITE, &ad);
+		rc = smk_curacc(isp, ns, MAY_WRITE, &ad);
 		rc = smk_bu_inode(d_backing_inode(new_dentry), MAY_WRITE, rc);
 	}
 
@@ -895,6 +933,7 @@ static int smack_inode_link(struct dentry *old_dentry, struct inode *dir,
 static int smack_inode_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *ip = d_backing_inode(dentry);
+	struct user_namespace *ns = ns_of_current();
 	struct smk_audit_info ad;
 	int rc;
 
@@ -904,7 +943,7 @@ static int smack_inode_unlink(struct inode *dir, struct dentry *dentry)
 	/*
 	 * You need write access to the thing you're unlinking
 	 */
-	rc = smk_curacc(smk_of_inode(ip), MAY_WRITE, &ad);
+	rc = smk_curacc(smk_of_inode(ip), ns, MAY_WRITE, &ad);
 	rc = smk_bu_inode(ip, MAY_WRITE, rc);
 	if (rc == 0) {
 		/*
@@ -912,7 +951,7 @@ static int smack_inode_unlink(struct inode *dir, struct dentry *dentry)
 		 */
 		smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_INODE);
 		smk_ad_setfield_u_fs_inode(&ad, dir);
-		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE, &ad);
+		rc = smk_curacc(smk_of_inode(dir), ns, MAY_WRITE, &ad);
 		rc = smk_bu_inode(dir, MAY_WRITE, rc);
 	}
 	return rc;
@@ -928,6 +967,7 @@ static int smack_inode_unlink(struct inode *dir, struct dentry *dentry)
  */
 static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
 {
+	struct user_namespace *ns = ns_of_current();
 	struct smk_audit_info ad;
 	int rc;
 
@@ -937,7 +977,8 @@ static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
 	/*
 	 * You need write access to the thing you're removing
 	 */
-	rc = smk_curacc(smk_of_inode(d_backing_inode(dentry)), MAY_WRITE, &ad);
+	rc = smk_curacc(smk_of_inode(d_backing_inode(dentry)), ns,
+			MAY_WRITE, &ad);
 	rc = smk_bu_inode(d_backing_inode(dentry), MAY_WRITE, rc);
 	if (rc == 0) {
 		/*
@@ -945,7 +986,7 @@ static int smack_inode_rmdir(struct inode *dir, struct dentry *dentry)
 		 */
 		smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_INODE);
 		smk_ad_setfield_u_fs_inode(&ad, dir);
-		rc = smk_curacc(smk_of_inode(dir), MAY_WRITE, &ad);
+		rc = smk_curacc(smk_of_inode(dir), ns, MAY_WRITE, &ad);
 		rc = smk_bu_inode(dir, MAY_WRITE, rc);
 	}
 
@@ -969,21 +1010,22 @@ static int smack_inode_rename(struct inode *old_inode,
 			      struct inode *new_inode,
 			      struct dentry *new_dentry)
 {
-	int rc;
 	struct smack_known *isp;
+	struct user_namespace *ns = ns_of_current();
 	struct smk_audit_info ad;
+	int rc;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_DENTRY);
 	smk_ad_setfield_u_fs_path_dentry(&ad, old_dentry);
 
 	isp = smk_of_inode(d_backing_inode(old_dentry));
-	rc = smk_curacc(isp, MAY_READWRITE, &ad);
+	rc = smk_curacc(isp, ns, MAY_READWRITE, &ad);
 	rc = smk_bu_inode(d_backing_inode(old_dentry), MAY_READWRITE, rc);
 
 	if (rc == 0 && d_is_positive(new_dentry)) {
 		isp = smk_of_inode(d_backing_inode(new_dentry));
 		smk_ad_setfield_u_fs_path_dentry(&ad, new_dentry);
-		rc = smk_curacc(isp, MAY_READWRITE, &ad);
+		rc = smk_curacc(isp, ns, MAY_READWRITE, &ad);
 		rc = smk_bu_inode(d_backing_inode(new_dentry), MAY_READWRITE, rc);
 	}
 	return rc;
@@ -1000,6 +1042,7 @@ static int smack_inode_rename(struct inode *old_inode,
  */
 static int smack_inode_permission(struct inode *inode, int mask)
 {
+	struct user_namespace *ns = ns_of_current();
 	struct smk_audit_info ad;
 	int no_block = mask & MAY_NOT_BLOCK;
 	int rc;
@@ -1016,7 +1059,7 @@ static int smack_inode_permission(struct inode *inode, int mask)
 		return -ECHILD;
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_INODE);
 	smk_ad_setfield_u_fs_inode(&ad, inode);
-	rc = smk_curacc(smk_of_inode(inode), mask, &ad);
+	rc = smk_curacc(smk_of_inode(inode), ns, mask, &ad);
 	rc = smk_bu_inode(inode, mask, rc);
 	return rc;
 }
@@ -1030,6 +1073,7 @@ static int smack_inode_permission(struct inode *inode, int mask)
  */
 static int smack_inode_setattr(struct dentry *dentry, struct iattr *iattr)
 {
+	struct user_namespace *ns = ns_of_current();
 	struct smk_audit_info ad;
 	int rc;
 
@@ -1041,7 +1085,8 @@ static int smack_inode_setattr(struct dentry *dentry, struct iattr *iattr)
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_DENTRY);
 	smk_ad_setfield_u_fs_path_dentry(&ad, dentry);
 
-	rc = smk_curacc(smk_of_inode(d_backing_inode(dentry)), MAY_WRITE, &ad);
+	rc = smk_curacc(smk_of_inode(d_backing_inode(dentry)), ns,
+			MAY_WRITE, &ad);
 	rc = smk_bu_inode(d_backing_inode(dentry), MAY_WRITE, rc);
 	return rc;
 }
@@ -1055,13 +1100,14 @@ static int smack_inode_setattr(struct dentry *dentry, struct iattr *iattr)
  */
 static int smack_inode_getattr(const struct path *path)
 {
+	struct user_namespace *ns = ns_of_current();
 	struct smk_audit_info ad;
 	struct inode *inode = d_backing_inode(path->dentry);
 	int rc;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 	smk_ad_setfield_u_fs_path(&ad, *path);
-	rc = smk_curacc(smk_of_inode(inode), MAY_READ, &ad);
+	rc = smk_curacc(smk_of_inode(inode), ns, MAY_READ, &ad);
 	rc = smk_bu_inode(inode, MAY_READ, rc);
 	return rc;
 }
@@ -1083,6 +1129,9 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
 {
 	struct smk_audit_info ad;
 	struct smack_known *skp;
+	struct smack_known *sbj = smk_of_current();
+	struct smack_known *obj = smk_of_inode(d_backing_inode(dentry));
+	struct user_namespace *ns = ns_of_current();
 	int check_priv = 0;
 	int check_import = 0;
 	int check_star = 0;
@@ -1109,11 +1158,12 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
 	} else
 		rc = cap_inode_setxattr(dentry, name, value, size, flags);
 
-	if (check_priv && !smack_privileged(CAP_MAC_ADMIN))
+	if (check_priv && !(smk_labels_valid(sbj, obj, ns) &&
+			    smack_ns_privileged(ns, CAP_MAC_ADMIN)))
 		rc = -EPERM;
 
 	if (rc == 0 && check_import) {
-		skp = size ? smk_get_label(value, size, true) : NULL;
+		skp = size ? smk_get_label(value, size, true, ns) : NULL;
 		if (IS_ERR(skp))
 			rc = PTR_ERR(skp);
 		else if (skp == NULL || (check_star &&
@@ -1125,7 +1175,7 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
 	smk_ad_setfield_u_fs_path_dentry(&ad, dentry);
 
 	if (rc == 0) {
-		rc = smk_curacc(smk_of_inode(d_backing_inode(dentry)), MAY_WRITE, &ad);
+		rc = smk_curacc(obj, ns, MAY_WRITE, &ad);
 		rc = smk_bu_inode(d_backing_inode(dentry), MAY_WRITE, rc);
 	}
 
@@ -1149,6 +1199,7 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
 	struct smack_known *skp;
 	struct smack_known **skpp = NULL;
 	struct inode_smack *isp = d_backing_inode(dentry)->i_security;
+	struct user_namespace *ns = ns_of_current();
 
 	if (strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0) {
 		isp->smk_flags |= SMK_INODE_TRANSMUTE;
@@ -1163,12 +1214,24 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
 		skpp = &isp->smk_mmap;
 
 	if (skpp) {
-		skp = smk_get_label(value, size, true);
+		skp = smk_get_label(value, size, true, ns);
 
 		if (!IS_ERR(skp))
 			*skpp = skp;
 		else
 			*skpp = &smack_known_invalid;
+
+		/*
+		 * The label we get above might be a different than the one
+		 * kernel has already set before calling this function.
+		 * Be consistent and set the final value in the filesystem.
+		 * The cases for this are errors and labels being used
+		 * in a namespace where we want to store an unmapped
+		 * value in the filesystem.
+		 */
+		dentry->d_inode->i_op->setxattr(dentry, name,
+						(*skpp)->smk_known,
+						size, flags);
 	}
 }
 
@@ -1181,13 +1244,15 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
  */
 static int smack_inode_getxattr(struct dentry *dentry, const char *name)
 {
+	struct user_namespace *ns = ns_of_current();
 	struct smk_audit_info ad;
 	int rc;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_DENTRY);
 	smk_ad_setfield_u_fs_path_dentry(&ad, dentry);
 
-	rc = smk_curacc(smk_of_inode(d_backing_inode(dentry)), MAY_READ, &ad);
+	rc = smk_curacc(smk_of_inode(d_backing_inode(dentry)), ns,
+			MAY_READ, &ad);
 	rc = smk_bu_inode(d_backing_inode(dentry), MAY_READ, rc);
 	return rc;
 }
@@ -1204,6 +1269,9 @@ static int smack_inode_getxattr(struct dentry *dentry, const char *name)
 static int smack_inode_removexattr(struct dentry *dentry, const char *name)
 {
 	struct inode_smack *isp;
+	struct smack_known *sbj = smk_of_current();
+	struct smack_known *obj = smk_of_inode(d_backing_inode(dentry));
+	struct user_namespace *ns = ns_of_current();
 	struct smk_audit_info ad;
 	int rc = 0;
 
@@ -1213,7 +1281,8 @@ static int smack_inode_removexattr(struct dentry *dentry, const char *name)
 	    strcmp(name, XATTR_NAME_SMACKEXEC) == 0 ||
 	    strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0 ||
 	    strcmp(name, XATTR_NAME_SMACKMMAP) == 0) {
-		if (!smack_privileged(CAP_MAC_ADMIN))
+		if (!smk_labels_valid(sbj, obj, ns) ||
+		    !smack_ns_privileged(ns, CAP_MAC_ADMIN))
 			rc = -EPERM;
 	} else
 		rc = cap_inode_removexattr(dentry, name);
@@ -1224,7 +1293,7 @@ static int smack_inode_removexattr(struct dentry *dentry, const char *name)
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_DENTRY);
 	smk_ad_setfield_u_fs_path_dentry(&ad, dentry);
 
-	rc = smk_curacc(smk_of_inode(d_backing_inode(dentry)), MAY_WRITE, &ad);
+	rc = smk_curacc(obj, ns, MAY_WRITE, &ad);
 	rc = smk_bu_inode(d_backing_inode(dentry), MAY_WRITE, rc);
 	if (rc != 0)
 		return rc;
@@ -1264,13 +1333,18 @@ static int smack_inode_getsecurity(const struct inode *inode,
 	struct super_block *sbp;
 	struct inode *ip = (struct inode *)inode;
 	struct smack_known *isp = NULL;
+	struct user_namespace *ns = ns_of_current();
 	int rc = 0;
 
 	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0)
 		isp = smk_of_inode(inode);
+	else if (strcmp(name, XATTR_SMACK_EXEC) == 0)
+		isp = smk_of_exec(inode);
+	else if (strcmp(name, XATTR_SMACK_MMAP) == 0)
+		isp = smk_of_mmap(inode);
 
 	if (isp) {
-		*buffer = smk_find_label_name(isp);
+		*buffer = smk_find_label_name(isp, ns);
 		if (*buffer == NULL)
 			*buffer = smack_known_huh.smk_known;
 		return strlen(*buffer);
@@ -1297,7 +1371,7 @@ static int smack_inode_getsecurity(const struct inode *inode,
 		return -EOPNOTSUPP;
 
 	if (rc == 0) {
-		*buffer = smk_find_label_name(isp);
+		*buffer = smk_find_label_name(isp, ns);
 		if (*buffer == NULL)
 			*buffer = smack_known_huh.smk_known;
 		rc = strlen(*buffer);
@@ -1408,18 +1482,19 @@ static int smack_file_ioctl(struct file *file, unsigned int cmd,
 {
 	int rc = 0;
 	struct smk_audit_info ad;
+	struct user_namespace *ns = ns_of_current();
 	struct inode *inode = file_inode(file);
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 	smk_ad_setfield_u_fs_path(&ad, file->f_path);
 
 	if (_IOC_DIR(cmd) & _IOC_WRITE) {
-		rc = smk_curacc(smk_of_inode(inode), MAY_WRITE, &ad);
+		rc = smk_curacc(smk_of_inode(inode), ns, MAY_WRITE, &ad);
 		rc = smk_bu_file(file, MAY_WRITE, rc);
 	}
 
 	if (rc == 0 && (_IOC_DIR(cmd) & _IOC_READ)) {
-		rc = smk_curacc(smk_of_inode(inode), MAY_READ, &ad);
+		rc = smk_curacc(smk_of_inode(inode), ns, MAY_READ, &ad);
 		rc = smk_bu_file(file, MAY_READ, rc);
 	}
 
@@ -1437,11 +1512,12 @@ static int smack_file_lock(struct file *file, unsigned int cmd)
 {
 	struct smk_audit_info ad;
 	int rc;
+	struct user_namespace *ns = ns_of_current();
 	struct inode *inode = file_inode(file);
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 	smk_ad_setfield_u_fs_path(&ad, file->f_path);
-	rc = smk_curacc(smk_of_inode(inode), MAY_LOCK, &ad);
+	rc = smk_curacc(smk_of_inode(inode), ns, MAY_LOCK, &ad);
 	rc = smk_bu_file(file, MAY_LOCK, rc);
 	return rc;
 }
@@ -1463,6 +1539,7 @@ static int smack_file_fcntl(struct file *file, unsigned int cmd,
 {
 	struct smk_audit_info ad;
 	int rc = 0;
+	struct user_namespace *ns = ns_of_current();
 	struct inode *inode = file_inode(file);
 
 	switch (cmd) {
@@ -1472,14 +1549,14 @@ static int smack_file_fcntl(struct file *file, unsigned int cmd,
 	case F_SETLKW:
 		smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 		smk_ad_setfield_u_fs_path(&ad, file->f_path);
-		rc = smk_curacc(smk_of_inode(inode), MAY_LOCK, &ad);
+		rc = smk_curacc(smk_of_inode(inode), ns, MAY_LOCK, &ad);
 		rc = smk_bu_file(file, MAY_LOCK, rc);
 		break;
 	case F_SETOWN:
 	case F_SETSIG:
 		smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 		smk_ad_setfield_u_fs_path(&ad, file->f_path);
-		rc = smk_curacc(smk_of_inode(inode), MAY_WRITE, &ad);
+		rc = smk_curacc(smk_of_inode(inode), ns, MAY_WRITE, &ad);
 		rc = smk_bu_file(file, MAY_WRITE, rc);
 		break;
 	default:
@@ -1509,6 +1586,7 @@ static int smack_mmap_file(struct file *file,
 	struct task_smack *tsp;
 	struct smack_known *okp;
 	struct inode_smack *isp;
+	struct user_namespace *sns;
 	int may;
 	int mmay;
 	int tmay;
@@ -1519,12 +1597,16 @@ static int smack_mmap_file(struct file *file,
 
 	tsp = current_security();
 	skp = smk_of_task(tsp);
+	sns = ns_of_current();
 	isp = file_inode(file)->i_security;
 	mkp = isp->smk_mmap;
 
 	if (mkp == NULL)
 		return 0;
 
+	if (!smk_labels_valid(skp, mkp, sns))
+		return -EACCES;
+
 	rc = 0;
 
 	rcu_read_lock();
@@ -1540,6 +1622,7 @@ static int smack_mmap_file(struct file *file,
 		 */
 		if (mkp->smk_known == okp->smk_known)
 			continue;
+
 		/*
 		 * If there is a matching local rule take
 		 * that into account as well.
@@ -1619,8 +1702,10 @@ static int smack_file_send_sigiotask(struct task_struct *tsk,
 				     struct fown_struct *fown, int signum)
 {
 	struct smack_known *skp;
-	struct smack_known *tkp = smk_of_task(tsk->cred->security);
+	struct smack_known *tkp;
 	struct file *file;
+	struct user_namespace *sns;
+	struct user_namespace *tns;
 	int rc;
 	struct smk_audit_info ad;
 
@@ -1628,12 +1713,17 @@ static int smack_file_send_sigiotask(struct task_struct *tsk,
 	 * struct fown_struct is never outside the context of a struct file
 	 */
 	file = container_of(fown, struct file, f_owner);
+	skp = file->f_security;
+	sns = file->f_cred->user_ns;
+
+	tkp = smk_of_task_struct(tsk);
+	tns = ns_of_task_struct(tsk);
 
 	/* we don't log here as rc can be overriden */
-	skp = file->f_security;
-	rc = smk_access(skp, tkp, MAY_WRITE, NULL);
+	rc = smk_access(skp, tkp, sns, MAY_WRITE, NULL);
 	rc = smk_bu_note("sigiotask", skp, tkp, MAY_WRITE, rc);
-	if (rc != 0 && smack_has_privilege(tsk, CAP_MAC_OVERRIDE))
+	if (rc != 0 && smk_labels_valid(skp, tkp, sns)
+	    && smack_has_ns_privilege(tsk, tns, CAP_MAC_OVERRIDE))
 		rc = 0;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
@@ -1653,6 +1743,7 @@ static int smack_file_receive(struct file *file)
 	int rc;
 	int may = 0;
 	struct smk_audit_info ad;
+	struct user_namespace *ns = ns_of_current();
 	struct inode *inode = file_inode(file);
 
 	if (unlikely(IS_PRIVATE(inode)))
@@ -1668,7 +1759,7 @@ static int smack_file_receive(struct file *file)
 	if (file->f_mode & FMODE_WRITE)
 		may |= MAY_WRITE;
 
-	rc = smk_curacc(smk_of_inode(inode), may, &ad);
+	rc = smk_curacc(smk_of_inode(inode), ns, may, &ad);
 	rc = smk_bu_file(file, may, rc);
 	return rc;
 }
@@ -1688,16 +1779,19 @@ static int smack_file_receive(struct file *file)
 static int smack_file_open(struct file *file, const struct cred *cred)
 {
 	struct task_smack *tsp = cred->security;
+	struct user_namespace *ns = cred->user_ns;
 	struct inode *inode = file_inode(file);
+	struct inode_smack *isp = file_inode(file)->i_security;
 	struct smk_audit_info ad;
 	int rc;
 
-	if (smack_privileged(CAP_MAC_OVERRIDE))
+	if (smk_labels_valid(tsp->smk_task, isp->smk_inode, ns) &&
+	    smack_ns_privileged(ns, CAP_MAC_OVERRIDE))
 		return 0;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
 	smk_ad_setfield_u_fs_path(&ad, file->f_path);
-	rc = smk_access(tsp->smk_task, smk_of_inode(inode), MAY_READ, &ad);
+	rc = smk_access(tsp->smk_task, smk_of_inode(inode), ns, MAY_READ, &ad);
 	rc = smk_bu_credfile(cred, file, MAY_READ, rc);
 
 	return rc;
@@ -1852,12 +1946,13 @@ static int smk_curacc_on_task(struct task_struct *p, int access,
 				const char *caller)
 {
 	struct smk_audit_info ad;
-	struct smack_known *skp = smk_of_task_struct(p);
+	struct smack_known *tkp = smk_of_task_struct(p);
+	struct user_namespace *tns = ns_of_task_struct(p);
 	int rc;
 
 	smk_ad_init(&ad, caller, LSM_AUDIT_DATA_TASK);
 	smk_ad_setfield_u_tsk(&ad, p);
-	rc = smk_curacc(skp, access, &ad);
+	rc = smk_curacc(tkp, tns, access, &ad);
 	rc = smk_bu_task(p, access, rc);
 	return rc;
 }
@@ -1998,6 +2093,7 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
 	struct smk_audit_info ad;
 	struct smack_known *skp;
 	struct smack_known *tkp = smk_of_task_struct(p);
+	struct user_namespace *tns = ns_of_task_struct(p);
 	int rc;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
@@ -2007,7 +2103,7 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
 	 * can write the receiver.
 	 */
 	if (secid == 0) {
-		rc = smk_curacc(tkp, MAY_WRITE, &ad);
+		rc = smk_curacc(tkp, tns, MAY_WRITE, &ad);
 		rc = smk_bu_task(p, MAY_WRITE, rc);
 		return rc;
 	}
@@ -2017,8 +2113,10 @@ static int smack_task_kill(struct task_struct *p, struct siginfo *info,
 	 * we can't take privilege into account.
 	 */
 	skp = smack_from_secid(secid);
-	rc = smk_access(skp, tkp, MAY_WRITE, &ad);
+
+	rc = smk_access(skp, tkp, tns, MAY_WRITE, &ad);
 	rc = smk_bu_note("USB signal", skp, tkp, MAY_WRITE, rc);
+
 	return rc;
 }
 
@@ -2073,6 +2171,7 @@ static void smack_task_to_inode(struct task_struct *p, struct inode *inode)
 static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t gfp_flags)
 {
 	struct smack_known *skp = smk_of_current();
+	struct user_namespace *ns = ns_of_current();
 	struct socket_smack *ssp;
 
 	ssp = kzalloc(sizeof(struct socket_smack), gfp_flags);
@@ -2082,6 +2181,7 @@ static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t gfp_flags)
 	ssp->smk_in = skp;
 	ssp->smk_out = skp;
 	ssp->smk_packet = NULL;
+	ssp->smk_ns = get_user_ns(ns);
 
 	sk->sk_security = ssp;
 
@@ -2096,7 +2196,11 @@ static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t gfp_flags)
  */
 static void smack_sk_free_security(struct sock *sk)
 {
+	struct socket_smack *ssp = sk->sk_security;
+
+	put_user_ns(ssp->smk_ns);
 	kfree(sk->sk_security);
+	sk->sk_security = NULL;
 }
 
 /**
@@ -2191,6 +2295,7 @@ static int smack_netlabel(struct sock *sk, int labeled)
 static int smack_netlabel_send(struct sock *sk, struct sockaddr_in *sap)
 {
 	struct smack_known *skp;
+	struct user_namespace *sns;
 	int rc;
 	int sk_lbl;
 	struct smack_known *hkp;
@@ -2210,7 +2315,8 @@ static int smack_netlabel_send(struct sock *sk, struct sockaddr_in *sap)
 #endif
 		sk_lbl = SMACK_UNLABELED_SOCKET;
 		skp = ssp->smk_out;
-		rc = smk_access(skp, hkp, MAY_WRITE, &ad);
+		sns = ssp->smk_ns;
+		rc = smk_access(skp, hkp, sns, MAY_WRITE, &ad);
 		rc = smk_bu_note("IPv4 host check", skp, hkp, MAY_WRITE, rc);
 	} else {
 		sk_lbl = SMACK_CIPSO_SOCKET;
@@ -2312,6 +2418,7 @@ static int smk_ipv6_port_check(struct sock *sk, struct sockaddr_in6 *address,
 	struct smk_port_label *spp;
 	struct socket_smack *ssp = sk->sk_security;
 	struct smack_known *skp;
+	struct user_namespace *sns = ssp->smk_ns;
 	unsigned short port = 0;
 	struct smack_known *object;
 	struct smk_audit_info ad;
@@ -2369,7 +2476,7 @@ auditout:
 	else
 		ad.a.u.net->v6info.daddr = address->sin6_addr;
 #endif
-	rc = smk_access(skp, object, MAY_WRITE, &ad);
+	rc = smk_access(skp, object, sns, MAY_WRITE, &ad);
 	rc = smk_bu_note("IPv6 port check", skp, object, MAY_WRITE, rc);
 	return rc;
 }
@@ -2394,12 +2501,13 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 	struct inode_smack *nsp = inode->i_security;
 	struct socket_smack *ssp;
 	struct socket *sock;
+	struct user_namespace *ns = ns_of_current();
 	int rc = 0;
 
 	if (value == NULL || size > SMK_LONGLABEL || size == 0)
 		return -EINVAL;
 
-	skp = smk_import_entry(value, size);
+	skp = smk_get_label(value, size, true, ns);
 	if (IS_ERR(skp))
 		return PTR_ERR(skp);
 
@@ -2584,14 +2692,14 @@ static void smack_msg_msg_free_security(struct msg_msg *msg)
 }
 
 /**
- * smack_of_shm - the smack pointer for the shm
+ * security_of_shm - the smack pointer for the shm
  * @shp: the object
  *
- * Returns a pointer to the smack value
+ * Returns a pointer to the security_smack struct
  */
-static struct smack_known *smack_of_shm(struct shmid_kernel *shp)
+static struct ipc_smack *security_of_shm(struct shmid_kernel *shp)
 {
-	return (struct smack_known *)shp->shm_perm.security;
+	return (struct ipc_smack *)shp->shm_perm.security;
 }
 
 /**
@@ -2603,9 +2711,16 @@ static struct smack_known *smack_of_shm(struct shmid_kernel *shp)
 static int smack_shm_alloc_security(struct shmid_kernel *shp)
 {
 	struct kern_ipc_perm *isp = &shp->shm_perm;
-	struct smack_known *skp = smk_of_current();
+	struct ipc_smack *ssp;
 
-	isp->security = skp;
+	ssp = kzalloc(sizeof(struct ipc_smack), GFP_KERNEL);
+	if (ssp == NULL)
+		return -ENOMEM;
+
+	ssp->smk_known = smk_of_current();
+	ssp->smk_ns = get_user_ns(ns_of_current());
+
+	isp->security = ssp;
 	return 0;
 }
 
@@ -2618,7 +2733,10 @@ static int smack_shm_alloc_security(struct shmid_kernel *shp)
 static void smack_shm_free_security(struct shmid_kernel *shp)
 {
 	struct kern_ipc_perm *isp = &shp->shm_perm;
+	struct ipc_smack *ssp = isp->security;
 
+	put_user_ns(ssp->smk_ns);
+	kfree(isp->security);
 	isp->security = NULL;
 }
 
@@ -2631,7 +2749,7 @@ static void smack_shm_free_security(struct shmid_kernel *shp)
  */
 static int smk_curacc_shm(struct shmid_kernel *shp, int access)
 {
-	struct smack_known *ssp = smack_of_shm(shp);
+	struct ipc_smack *ssp = security_of_shm(shp);
 	struct smk_audit_info ad;
 	int rc;
 
@@ -2639,8 +2757,8 @@ static int smk_curacc_shm(struct shmid_kernel *shp, int access)
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_IPC);
 	ad.a.u.ipc_id = shp->shm_perm.id;
 #endif
-	rc = smk_curacc(ssp, access, &ad);
-	rc = smk_bu_current("shm", ssp, access, rc);
+	rc = smk_curacc(ssp->smk_known, ssp->smk_ns, access, &ad);
+	rc = smk_bu_current("shm", ssp->smk_known, access, rc);
 	return rc;
 }
 
@@ -2711,14 +2829,14 @@ static int smack_shm_shmat(struct shmid_kernel *shp, char __user *shmaddr,
 }
 
 /**
- * smack_of_sem - the smack pointer for the sem
+ * security_of_sem - the smack pointer for the sem
  * @sma: the object
  *
- * Returns a pointer to the smack value
+ * Returns a pointer to the ipc_smack struct
  */
-static struct smack_known *smack_of_sem(struct sem_array *sma)
+static struct ipc_smack *security_of_sem(struct sem_array *sma)
 {
-	return (struct smack_known *)sma->sem_perm.security;
+	return (struct ipc_smack *)sma->sem_perm.security;
 }
 
 /**
@@ -2730,9 +2848,16 @@ static struct smack_known *smack_of_sem(struct sem_array *sma)
 static int smack_sem_alloc_security(struct sem_array *sma)
 {
 	struct kern_ipc_perm *isp = &sma->sem_perm;
-	struct smack_known *skp = smk_of_current();
+	struct ipc_smack *ssp;
 
-	isp->security = skp;
+	ssp = kzalloc(sizeof(struct ipc_smack), GFP_KERNEL);
+	if (ssp == NULL)
+		return -ENOMEM;
+
+	ssp->smk_known = smk_of_current();
+	ssp->smk_ns = get_user_ns(ns_of_current());
+
+	isp->security = ssp;
 	return 0;
 }
 
@@ -2745,7 +2870,10 @@ static int smack_sem_alloc_security(struct sem_array *sma)
 static void smack_sem_free_security(struct sem_array *sma)
 {
 	struct kern_ipc_perm *isp = &sma->sem_perm;
+	struct ipc_smack *ssp = isp->security;
 
+	put_user_ns(ssp->smk_ns);
+	kfree(isp->security);
 	isp->security = NULL;
 }
 
@@ -2758,7 +2886,7 @@ static void smack_sem_free_security(struct sem_array *sma)
  */
 static int smk_curacc_sem(struct sem_array *sma, int access)
 {
-	struct smack_known *ssp = smack_of_sem(sma);
+	struct ipc_smack *ssp = security_of_sem(sma);
 	struct smk_audit_info ad;
 	int rc;
 
@@ -2766,8 +2894,8 @@ static int smk_curacc_sem(struct sem_array *sma, int access)
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_IPC);
 	ad.a.u.ipc_id = sma->sem_perm.id;
 #endif
-	rc = smk_curacc(ssp, access, &ad);
-	rc = smk_bu_current("sem", ssp, access, rc);
+	rc = smk_curacc(ssp->smk_known, ssp->smk_ns, access, &ad);
+	rc = smk_bu_current("sem", ssp->smk_known, access, rc);
 	return rc;
 }
 
@@ -2852,9 +2980,16 @@ static int smack_sem_semop(struct sem_array *sma, struct sembuf *sops,
 static int smack_msg_queue_alloc_security(struct msg_queue *msq)
 {
 	struct kern_ipc_perm *kisp = &msq->q_perm;
-	struct smack_known *skp = smk_of_current();
+	struct ipc_smack *ssp;
+
+	ssp = kzalloc(sizeof(struct ipc_smack), GFP_KERNEL);
+	if (ssp == NULL)
+		return -ENOMEM;
+
+	ssp->smk_known = smk_of_current();
+	ssp->smk_ns = get_user_ns(ns_of_current());
 
-	kisp->security = skp;
+	kisp->security = ssp;
 	return 0;
 }
 
@@ -2867,19 +3002,22 @@ static int smack_msg_queue_alloc_security(struct msg_queue *msq)
 static void smack_msg_queue_free_security(struct msg_queue *msq)
 {
 	struct kern_ipc_perm *kisp = &msq->q_perm;
+	struct ipc_smack *ssp = kisp->security;
 
+	put_user_ns(ssp->smk_ns);
+	kfree(kisp->security);
 	kisp->security = NULL;
 }
 
 /**
- * smack_of_msq - the smack pointer for the msq
+ * security_of_msq - the smack pointer for the msq
  * @msq: the object
  *
- * Returns a pointer to the smack label entry
+ * Returns a pointer to the ipc_smack struct
  */
-static struct smack_known *smack_of_msq(struct msg_queue *msq)
+static struct ipc_smack *security_of_msq(struct msg_queue *msq)
 {
-	return (struct smack_known *)msq->q_perm.security;
+	return (struct ipc_smack *)msq->q_perm.security;
 }
 
 /**
@@ -2891,7 +3029,7 @@ static struct smack_known *smack_of_msq(struct msg_queue *msq)
  */
 static int smk_curacc_msq(struct msg_queue *msq, int access)
 {
-	struct smack_known *msp = smack_of_msq(msq);
+	struct ipc_smack *msp = security_of_msq(msq);
 	struct smk_audit_info ad;
 	int rc;
 
@@ -2899,8 +3037,8 @@ static int smk_curacc_msq(struct msg_queue *msq, int access)
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_IPC);
 	ad.a.u.ipc_id = msq->q_perm.id;
 #endif
-	rc = smk_curacc(msp, access, &ad);
-	rc = smk_bu_current("msq", msp, access, rc);
+	rc = smk_curacc(msp->smk_known, msp->smk_ns, access, &ad);
+	rc = smk_bu_current("msq", msp->smk_known, access, rc);
 	return rc;
 }
 
@@ -2994,7 +3132,7 @@ static int smack_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
  */
 static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
 {
-	struct smack_known *iskp = ipp->security;
+	struct ipc_smack *isp = ipp->security;
 	int may = smack_flags_to_may(flag);
 	struct smk_audit_info ad;
 	int rc;
@@ -3003,8 +3141,8 @@ static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_IPC);
 	ad.a.u.ipc_id = ipp->id;
 #endif
-	rc = smk_curacc(iskp, may, &ad);
-	rc = smk_bu_current("svipc", iskp, may, rc);
+	rc = smk_curacc(isp->smk_known, isp->smk_ns, may, &ad);
+	rc = smk_bu_current("svipc", isp->smk_known, may, rc);
 	return rc;
 }
 
@@ -3015,9 +3153,9 @@ static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
  */
 static void smack_ipc_getsecid(struct kern_ipc_perm *ipp, u32 *secid)
 {
-	struct smack_known *iskp = ipp->security;
+	struct ipc_smack *iskp = ipp->security;
 
-	*secid = iskp->smk_secid;
+	*secid = iskp->smk_known->smk_secid;
 }
 
 /**
@@ -3251,13 +3389,14 @@ unlockandout:
 static int smack_getprocattr(struct task_struct *p, char *name, char **value)
 {
 	struct smack_known *skp = smk_of_task_struct(p);
+	struct user_namespace *ns = ns_of_current();
 	char *cp;
 	int slen;
 
 	if (strcmp(name, "current") != 0)
 		return -EINVAL;
 
-	cp = smk_find_label_name(skp);
+	cp = smk_find_label_name(skp, ns);
 	if (cp == NULL)
 		cp = smack_known_huh.smk_known;
 	cp = kstrdup(cp, GFP_KERNEL);
@@ -3287,6 +3426,7 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 	struct task_smack *tsp;
 	struct cred *new;
 	struct smack_known *skp;
+	struct user_namespace *ns;
 
 	/*
 	 * Changing another process' Smack value is too dangerous
@@ -3295,7 +3435,9 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 	if (p != current)
 		return -EPERM;
 
-	if (!smack_privileged(CAP_MAC_ADMIN))
+	ns = ns_of_current();
+
+	if (!smack_ns_privileged(ns, CAP_MAC_ADMIN))
 		return -EPERM;
 
 	if (value == NULL || size == 0 || size >= SMK_LONGLABEL)
@@ -3304,7 +3446,7 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 	if (strcmp(name, "current") != 0)
 		return -EINVAL;
 
-	skp = smk_get_label(value, size, true);
+	skp = smk_get_label(value, size, true, ns);
 	if (IS_ERR(skp))
 		return PTR_ERR(skp);
 
@@ -3344,23 +3486,27 @@ static int smack_unix_stream_connect(struct sock *sock,
 	struct smack_known *okp_out = osp->smk_out;
 	struct smack_known *skp_in = ssp->smk_in;
 	struct smack_known *okp_in = osp->smk_in;
+	struct user_namespace *sns = ssp->smk_ns;
+	struct user_namespace *ons = osp->smk_ns;
 	struct smk_audit_info ad;
 	int rc = 0;
 #ifdef CONFIG_AUDIT
 	struct lsm_network_audit net;
 #endif
 
-	if (!smack_privileged(CAP_MAC_OVERRIDE)) {
+	if (!smack_ns_privileged(ons, CAP_MAC_OVERRIDE) ||
+	    !smk_labels_valid(skp_out, okp_in, sns) ||
+	    !smk_labels_valid(okp_out, skp_in, ons)) {
 #ifdef CONFIG_AUDIT
 		smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
 		smk_ad_setfield_u_net_sk(&ad, other);
 #endif
-		rc = smk_access(skp_out, okp_in, MAY_WRITE, &ad);
+		rc = smk_access(skp_out, okp_in, sns, MAY_WRITE, &ad);
 		rc = smk_bu_note("UDS connect", skp_out, okp_in, MAY_WRITE, rc);
 		if (rc == 0) {
-			rc = smk_access(okp_out, skp_in, MAY_WRITE, &ad);
+			rc = smk_access(okp_out, skp_in, ons, MAY_WRITE, &ad);
 			rc = smk_bu_note("UDS connect", okp_out, skp_in,
-						MAY_WRITE, rc);
+					 MAY_WRITE, rc);
 		}
 	}
 
@@ -3387,6 +3533,8 @@ static int smack_unix_may_send(struct socket *sock, struct socket *other)
 {
 	struct socket_smack *ssp = sock->sk->sk_security;
 	struct socket_smack *osp = other->sk->sk_security;
+	struct user_namespace *sns = ssp->smk_ns;
+	struct user_namespace *ons = osp->smk_ns;
 	struct smk_audit_info ad;
 	int rc;
 
@@ -3397,10 +3545,11 @@ static int smack_unix_may_send(struct socket *sock, struct socket *other)
 	smk_ad_setfield_u_net_sk(&ad, other->sk);
 #endif
 
-	if (smack_privileged(CAP_MAC_OVERRIDE))
+	if (smk_labels_valid(ssp->smk_out, osp->smk_in, sns) &&
+	    smack_ns_privileged(ons, CAP_MAC_OVERRIDE))
 		return 0;
 
-	rc = smk_access(ssp->smk_out, osp->smk_in, MAY_WRITE, &ad);
+	rc = smk_access(ssp->smk_out, osp->smk_in, sns, MAY_WRITE, &ad);
 	rc = smk_bu_note("UDS send", ssp->smk_out, osp->smk_in, MAY_WRITE, rc);
 	return rc;
 }
@@ -3640,7 +3789,7 @@ access_check:
 		 * This is the simplist possible security model
 		 * for networking.
 		 */
-		rc = smk_access(skp, ssp->smk_in, MAY_WRITE, &ad);
+		rc = smk_access(skp, ssp->smk_in, ssp->smk_ns, MAY_WRITE, &ad);
 		rc = smk_bu_note("IPv4 delivery", skp, ssp->smk_in,
 					MAY_WRITE, rc);
 		if (rc != 0)
@@ -3662,7 +3811,7 @@ access_check:
 		ad.a.u.net->netif = skb->skb_iif;
 		ipv6_skb_to_auditdata(skb, &ad.a, NULL);
 #endif /* CONFIG_AUDIT */
-		rc = smk_access(skp, ssp->smk_in, MAY_WRITE, &ad);
+		rc = smk_access(skp, ssp->smk_in, ssp->smk_ns, MAY_WRITE, &ad);
 		rc = smk_bu_note("IPv6 delivery", skp, ssp->smk_in,
 					MAY_WRITE, rc);
 #else /* CONFIG_SECURITY_SMACK_NETFILTER */
@@ -3875,7 +4024,7 @@ access_check:
 	 * Receiving a packet requires that the other end be able to write
 	 * here. Read access is not required.
 	 */
-	rc = smk_access(skp, ssp->smk_in, MAY_WRITE, &ad);
+	rc = smk_access(skp, ssp->smk_in, ssp->smk_ns, MAY_WRITE, &ad);
 	rc = smk_bu_note("IPv4 connect", skp, ssp->smk_in, MAY_WRITE, rc);
 	if (rc != 0)
 		return rc;
@@ -3979,6 +4128,7 @@ static int smack_key_permission(key_ref_t key_ref,
 	struct key *keyp;
 	struct smk_audit_info ad;
 	struct smack_known *tkp = smk_of_task(cred->security);
+	struct user_namespace *tns = cred->user_ns;
 	int request = 0;
 	int rc;
 
@@ -4005,7 +4155,7 @@ static int smack_key_permission(key_ref_t key_ref,
 		request = MAY_READ;
 	if (perm & (KEY_NEED_WRITE | KEY_NEED_LINK | KEY_NEED_SETATTR))
 		request = MAY_WRITE;
-	rc = smk_access(tkp, keyp->security, request, &ad);
+	rc = smk_access(tkp, keyp->security, tns, request, &ad);
 	rc = smk_bu_note("key access", tkp, keyp->security, request, rc);
 	return rc;
 }
@@ -4022,6 +4172,7 @@ static int smack_key_permission(key_ref_t key_ref,
 static int smack_key_getsecurity(struct key *key, char **_buffer)
 {
 	struct smack_known *skp = key->security;
+	struct user_namespace *ns = ns_of_current();
 	size_t length;
 	char *copy;
 
@@ -4030,7 +4181,7 @@ static int smack_key_getsecurity(struct key *key, char **_buffer)
 		return 0;
 	}
 
-	copy = smk_find_label_name(skp);
+	copy = smk_find_label_name(skp, ns);
 	if (copy == NULL)
 		copy = smack_known_huh.smk_known;
 	copy = kstrdup(copy, GFP_KERNEL);
@@ -4208,6 +4359,11 @@ static inline void smack_userns_free(struct user_namespace *ns)
 static inline int smack_userns_setns(struct nsproxy *nsproxy,
 				     struct user_namespace *ns)
 {
+	struct smack_known *skp = smk_of_current();
+
+	if (smk_find_mapped(skp, ns) == NULL)
+		return -EACCES;
+
 	return 0;
 }
 
diff --git a/security/smack/smack_ns.c b/security/smack/smack_ns.c
index 141a836..819c490 100644
--- a/security/smack/smack_ns.c
+++ b/security/smack/smack_ns.c
@@ -206,6 +206,45 @@ unlockout:
 	return sknp;
 }
 
+/**
+ * smk_labels_valid - A helper to check whether labels are valid/mapped
+ *                    in the namespace and can be used there
+ * @sbj: a subject label to be checked
+ * @obj: an object label to be checked
+ * @ns: user namespace to check against (usually subject's)
+ *
+ * Returns true if both valid/mapped, false otherwise.
+ * This helper is mostly used while checking capabilities.
+ * The access functions check the validity of labels by themselves.
+ */
+bool smk_labels_valid(struct smack_known *sbj, struct smack_known *obj,
+		      struct user_namespace *ns)
+{
+	struct user_namespace *user_ns;
+
+	/*
+	 * labels are always valid if there is no map
+	 * (init_user_ns or unmapped descendants)
+	 */
+	user_ns = smk_find_mapped_ns(ns);
+	if (user_ns == NULL)
+		return true;
+
+	/*
+	 * If we have a map though, both labels need to be mapped.
+	 */
+	if (__smk_find_mapped(sbj, user_ns) == NULL)
+		return false;
+	if (__smk_find_mapped(obj, user_ns) == NULL)
+		return false;
+
+	return true;
+}
+
+/*
+ * proc mapping operations
+ */
+
 static void *proc_smack_map_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	struct smack_known *skp;
@@ -253,7 +292,7 @@ static int proc_smack_map_seq_show(struct seq_file *seq, void *v)
 	 * to show identity in this syntax without printing all the labels.
 	 */
 	if (smk_find_mapped_ns(ns) == NULL) {
-		seq_puts("This namespace is not mapped.\n");
+		seq_puts(seq, "This namespace is not mapped.\n");
 	} else {
 		sknp = smk_find_mapped(skp, ns);
 		if (sknp)
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 5ec1e8e..7196861 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -345,13 +345,15 @@ static int smk_fill_rule(const char *subject, const char *object,
 				struct smack_parsed_rule *rule, int import,
 				int len)
 {
-	rule->smk_subject = smk_get_label(subject, len, import);
+	struct user_namespace *ns = ns_of_current();
+
+	rule->smk_subject = smk_get_label(subject, len, import, ns);
 	if (IS_ERR(rule->smk_subject))
 		return PTR_ERR(rule->smk_subject);
 	if (rule->smk_subject == NULL)
 		return -ENOENT;
 
-	rule->smk_object = smk_get_label(object, len, import);
+	rule->smk_object = smk_get_label(object, len, import, ns);
 	if (IS_ERR(rule->smk_object))
 		return PTR_ERR(rule->smk_object);
 	if (rule->smk_object == NULL)
@@ -586,6 +588,7 @@ static void smk_seq_stop(struct seq_file *s, void *v)
 
 static void smk_rule_show(struct seq_file *s, struct smack_rule *srp, int max)
 {
+	struct user_namespace *ns = ns_of_current();
 	char *sbj;
 	char *obj;
 
@@ -594,6 +597,7 @@ static void smk_rule_show(struct seq_file *s, struct smack_rule *srp, int max)
 	 * interface file (/smack/load or /smack/load2)
 	 * because you should expect to be able to write
 	 * anything you read back.
+	 * Show only fully mapped rules in a namespace (both labels mapped).
 	 */
 	if (strlen(srp->smk_subject->smk_known) >= max ||
 	    strlen(srp->smk_object->smk_known) >= max)
@@ -602,8 +606,8 @@ static void smk_rule_show(struct seq_file *s, struct smack_rule *srp, int max)
 	if (srp->smk_access == 0)
 		return;
 
-	sbj = smk_find_label_name(srp->smk_subject);
-	obj = smk_find_label_name(srp->smk_object);
+	sbj = smk_find_label_name(srp->smk_subject, ns);
+	obj = smk_find_label_name(srp->smk_object, ns);
 
 	if (sbj == NULL || obj == NULL)
 		return;
@@ -798,6 +802,7 @@ static int cipso_seq_show(struct seq_file *s, void *v)
 	struct smack_known *skp =
 		 list_entry(list, struct smack_known, list);
 	struct netlbl_lsm_catmap *cmp = skp->smk_netlabel.attr.mls.cat;
+	struct user_namespace *ns = ns_of_current();
 	char sep = '/';
 	char *cp;
 	int i;
@@ -813,7 +818,7 @@ static int cipso_seq_show(struct seq_file *s, void *v)
 	if (strlen(skp->smk_known) >= SMK_LABELLEN)
 		return 0;
 
-	cp = smk_find_label_name(skp);
+	cp = smk_find_label_name(skp, ns);
 	if (cp == NULL)
 		return 0;
 
@@ -866,6 +871,7 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 {
 	struct smack_known *skp;
 	struct netlbl_lsm_secattr ncats;
+	struct user_namespace *ns = ns_of_current();
 	char mapcatset[SMK_CIPSOLEN];
 	int maplevel;
 	unsigned int cat;
@@ -906,7 +912,7 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 	 */
 	mutex_lock(&smack_cipso_lock);
 
-	skp = smk_get_label(rule, 0, true);
+	skp = smk_get_label(rule, 0, true, ns);
 	if (IS_ERR(skp)) {
 		rc = PTR_ERR(skp);
 		goto out;
@@ -994,11 +1000,12 @@ static int cipso2_seq_show(struct seq_file *s, void *v)
 	struct smack_known *skp =
 		 list_entry(list, struct smack_known, list);
 	struct netlbl_lsm_catmap *cmp = skp->smk_netlabel.attr.mls.cat;
+	struct user_namespace *ns = ns_of_current();
 	char sep = '/';
 	char *cp;
 	int i;
 
-	cp = smk_find_label_name(skp);
+	cp = smk_find_label_name(skp, ns);
 	if (cp == NULL)
 		return 0;
 
@@ -1085,7 +1092,8 @@ static int netlbladdr_seq_show(struct seq_file *s, void *v)
 	unsigned char *hp = (char *) &skp->smk_host.sin_addr.s_addr;
 	int maskn;
 	u32 temp_mask = be32_to_cpu(skp->smk_mask.s_addr);
-	char *label = smk_find_label_name(skp->smk_label);
+	struct user_namespace *ns = ns_of_current();
+	char *label = smk_find_label_name(skp->smk_label, ns);
 
 	if (label == NULL)
 		return 0;
@@ -1182,6 +1190,7 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	int rc;
 	struct netlbl_audit audit_info;
 	struct in_addr mask;
+	struct user_namespace *ns = ns_of_current();
 	unsigned int m;
 	int found;
 	u32 mask_bits = (1<<31);
@@ -1239,7 +1248,7 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	 * If smack begins with '-', it is an option, don't import it
 	 */
 	if (smack[0] != '-') {
-		skp = smk_get_label(smack, 0, true);
+		skp = smk_get_label(smack, 0, true, ns);
 		if (IS_ERR(skp)) {
 			rc = PTR_ERR(skp);
 			goto free_out;
@@ -1567,6 +1576,7 @@ static const struct file_operations smk_mapped_ops = {
 static ssize_t smk_read_ambient(struct file *filp, char __user *buf,
 				size_t cn, loff_t *ppos)
 {
+	struct user_namespace *ns = ns_of_current();
 	ssize_t rc;
 	char *cp;
 	int asize;
@@ -1579,7 +1589,7 @@ static ssize_t smk_read_ambient(struct file *filp, char __user *buf,
 	 */
 	mutex_lock(&smack_ambient_lock);
 
-	cp = smk_find_label_name(smack_net_ambient);
+	cp = smk_find_label_name(smack_net_ambient, ns);
 	if (cp == NULL)
 		cp = smack_known_huh.smk_known;
 
@@ -1608,6 +1618,7 @@ static ssize_t smk_write_ambient(struct file *file, const char __user *buf,
 				 size_t count, loff_t *ppos)
 {
 	struct smack_known *skp;
+	struct user_namespace *ns = ns_of_current();
 	char *oldambient;
 	char *data;
 	int rc = count;
@@ -1624,7 +1635,7 @@ static ssize_t smk_write_ambient(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	skp = smk_get_label(data, count, true);
+	skp = smk_get_label(data, count, true, ns);
 	if (IS_ERR(skp)) {
 		rc = PTR_ERR(skp);
 		goto out;
@@ -1664,12 +1675,13 @@ static ssize_t smk_read_onlycap(struct file *filp, char __user *buf,
 	char *smack = "";
 	ssize_t rc = -EINVAL;
 	int asize;
+	struct user_namespace *ns = ns_of_current();
 
 	if (*ppos != 0)
 		return 0;
 
 	if (smack_onlycap != NULL) {
-		smack = smk_find_label_name(smack_onlycap);
+		smack = smk_find_label_name(smack_onlycap, ns);
 		if (smack == NULL)
 			smack = smack_known_huh.smk_known;
 	}
@@ -1696,6 +1708,7 @@ static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
 {
 	char *data;
 	struct smack_known *skp = smk_of_task(current->cred->security);
+	struct user_namespace *ns = ns_of_current();
 	int rc = count;
 
 	if (!smack_privileged(CAP_MAC_ADMIN))
@@ -1727,7 +1740,7 @@ static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
 	 *
 	 * But do so only on invalid label, not on system errors.
 	 */
-	skp = smk_get_label(data, count, true);
+	skp = smk_get_label(data, count, true, ns);
 	if (PTR_ERR(skp) == -EINVAL)
 		skp = NULL;
 	else if (IS_ERR(skp)) {
@@ -1764,12 +1777,13 @@ static ssize_t smk_read_unconfined(struct file *filp, char __user *buf,
 	char *smack = "";
 	ssize_t rc = -EINVAL;
 	int asize;
+	struct user_namespace *ns = ns_of_current();
 
 	if (*ppos != 0)
 		return 0;
 
 	if (smack_unconfined != NULL) {
-		smack = smk_find_label_name(smack_unconfined);
+		smack = smk_find_label_name(smack_unconfined, ns);
 		if (smack == NULL)
 			smack = smack_known_huh.smk_known;
 	}
@@ -1796,6 +1810,7 @@ static ssize_t smk_write_unconfined(struct file *file, const char __user *buf,
 {
 	char *data;
 	struct smack_known *skp;
+	struct user_namespace *ns = ns_of_current();
 	int rc = count;
 
 	if (!smack_privileged(CAP_MAC_ADMIN))
@@ -1819,7 +1834,7 @@ static ssize_t smk_write_unconfined(struct file *file, const char __user *buf,
 	 *
 	 * But do so only on invalid label, not on system errors.
 	 */
-	skp = smk_get_label(data, count, true);
+	skp = smk_get_label(data, count, true, ns);
 	if (PTR_ERR(skp) == -EINVAL)
 		skp = NULL;
 	else if (IS_ERR(skp)) {
@@ -1991,6 +2006,7 @@ static ssize_t smk_user_access(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos, int format)
 {
 	struct smack_parsed_rule rule;
+	struct user_namespace *ns = ns_of_current();
 	char *data;
 	int res;
 
@@ -2010,7 +2026,7 @@ static ssize_t smk_user_access(struct file *file, const char __user *buf,
 	}
 
 	if (res >= 0)
-		res = smk_access(rule.smk_subject, rule.smk_object,
+		res = smk_access(rule.smk_subject, rule.smk_object, ns,
 				 rule.smk_access1, NULL);
 	else if (res != -ENOENT)
 		return res;
@@ -2220,6 +2236,7 @@ static ssize_t smk_write_revoke_subj(struct file *file, const char __user *buf,
 	struct smack_rule *sp;
 	struct list_head *rule_list;
 	struct mutex *rule_lock;
+	struct user_namespace *ns = ns_of_current();
 	int rc = count;
 
 	if (*ppos != 0)
@@ -2240,7 +2257,7 @@ static ssize_t smk_write_revoke_subj(struct file *file, const char __user *buf,
 		goto free_out;
 	}
 
-	skp = smk_get_label(data, count, false);
+	skp = smk_get_label(data, count, false, ns);
 	if (IS_ERR(skp)) {
 		rc = PTR_ERR(skp);
 		goto free_out;
@@ -2322,6 +2339,7 @@ static const struct file_operations smk_change_rule_ops = {
 static ssize_t smk_read_syslog(struct file *filp, char __user *buf,
 				size_t cn, loff_t *ppos)
 {
+	struct user_namespace *ns = ns_of_current();
 	ssize_t rc = -EINVAL;
 	char *cp;
 	int asize;
@@ -2332,7 +2350,7 @@ static ssize_t smk_read_syslog(struct file *filp, char __user *buf,
 	if (smack_syslog_label == NULL)
 		cp = smack_known_star.smk_known;
 	else {
-		cp = smk_find_label_name(smack_syslog_label);
+		cp = smk_find_label_name(smack_syslog_label, ns);
 		if (cp == NULL)
 			cp = smack_known_huh.smk_known;
 	}
@@ -2359,6 +2377,7 @@ static ssize_t smk_write_syslog(struct file *file, const char __user *buf,
 {
 	char *data;
 	struct smack_known *skp;
+	struct user_namespace *ns = ns_of_current();
 	int rc = count;
 
 	if (!smack_privileged(CAP_MAC_ADMIN))
@@ -2371,7 +2390,7 @@ static ssize_t smk_write_syslog(struct file *file, const char __user *buf,
 	if (copy_from_user(data, buf, count) != 0)
 		rc = -EFAULT;
 	else {
-		skp = smk_get_label(data, count, true);
+		skp = smk_get_label(data, count, true, ns);
 		if (IS_ERR(skp))
 			rc = PTR_ERR(skp);
 		else
-- 
2.1.0
