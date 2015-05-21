From: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/8] smack: extend capability functions and fix 2 checks
Date: Thu, 21 May 2015 13:53:37 +0200
Message-ID: <1432209222-8479-4-git-send-email-l.pawelczyk__32195.2433129356$1432209394$gmane$org@samsung.com>
References: <1432209222-8479-1-git-send-email-l.pawelczyk@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1432209222-8479-1-git-send-email-l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ionut Alexa <ionut.m.alexa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Mauro Carvalho Chehab <mchehab@os>
Cc: Lukasz Pawelczyk <havner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch extends smack capability functions to a full list to those
equivalent in the kernel

has_ns_capability -> smack_has_ns_privilege
has_capability    -> smack_has_privilege
ns_capable        -> smack_ns_privileged
capable           -> smack_privileged

It also puts the smack related part to a common function:
smack_capability_allowed()

Those functions will be needed for capability checks in the upcoming
Smack namespace patches.

Additionally there were 2 smack capability checks that used generic
capability functions instead of specific Smack ones effectively ignoring
the onlycap rule. This has been fixed now with the introduction of those
new functions.

This has implications on the Smack namespace as well as the additional
Smack checks in smack_capability_allowed() will be extended beyond the
onlycap rule. Not using Smack specific checks in those 2 places could
mean breaking the Smack label namespace separation.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 security/smack/smack.h     | 63 +++++++++++++++++++++++++++++++++++++++++++---
 security/smack/smack_lsm.c |  4 +--
 2 files changed, 61 insertions(+), 6 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index b8c1a86..fa8fa87 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -332,21 +332,76 @@ static inline struct smack_known *smk_of_current(void)
 }
 
 /*
+ * Internal smack capability check complimentary to the
+ * set of kernel capable() and has_capability() functions
+ *
+ * For a capability in smack related checks to be effective it needs to:
+ * - have empty onlycap or the current label be the same as onlycap
+ * - be in the initial user ns
+ */
+static inline int smack_capability_allowed(struct smack_known *skp,
+					   struct user_namespace *user_ns)
+{
+	if (user_ns != &init_user_ns)
+		return 0;
+
+	if (smack_onlycap != NULL && smack_onlycap != skp)
+		return 0;
+
+	return 1;
+}
+
+/*
+ * Is the task privileged in a namespace and allowed to be privileged
+ * by additional smack rules.
+ */
+static inline int smack_has_ns_privilege(struct task_struct *task,
+					 struct user_namespace *user_ns,
+					 int cap)
+{
+	struct smack_known *skp = smk_of_task_struct(task);
+
+	if (!has_ns_capability(task, user_ns, cap))
+		return 0;
+	if (smack_capability_allowed(skp, user_ns))
+		return 1;
+	return 0;
+}
+
+/*
  * Is the task privileged and allowed to be privileged
- * by the onlycap rule.
+ * by additional smack rules.
  */
-static inline int smack_privileged(int cap)
+static inline int smack_has_privilege(struct task_struct *task, int cap)
+{
+	return smack_has_ns_privilege(task, &init_user_ns, cap);
+}
+
+/*
+ * Is the current task privileged in a namespace and allowed to be privileged
+ * by additional smack rules.
+ */
+static inline int smack_ns_privileged(struct user_namespace *user_ns, int cap)
 {
 	struct smack_known *skp = smk_of_current();
 
-	if (!capable(cap))
+	if (!ns_capable(user_ns, cap))
 		return 0;
-	if (smack_onlycap == NULL || smack_onlycap == skp)
+	if (smack_capability_allowed(skp, user_ns))
 		return 1;
 	return 0;
 }
 
 /*
+ * Is the current task privileged and allowed to be privileged
+ * by additional smack rules.
+ */
+static inline int smack_privileged(int cap)
+{
+	return smack_ns_privileged(&init_user_ns, cap);
+}
+
+/*
  * logging functions
  */
 #define SMACK_AUDIT_DENIED 0x1
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index a143328..ee7bb63 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -403,7 +403,7 @@ static int smk_ptrace_rule_check(struct task_struct *tracer,
 			rc = 0;
 		else if (smack_ptrace_rule == SMACK_PTRACE_DRACONIAN)
 			rc = -EACCES;
-		else if (capable(CAP_SYS_PTRACE))
+		else if (smack_has_privilege(tracer, CAP_SYS_PTRACE))
 			rc = 0;
 		else
 			rc = -EACCES;
@@ -1646,7 +1646,7 @@ static int smack_file_send_sigiotask(struct task_struct *tsk,
 	skp = file->f_security;
 	rc = smk_access(skp, tkp, MAY_WRITE, NULL);
 	rc = smk_bu_note("sigiotask", skp, tkp, MAY_WRITE, rc);
-	if (rc != 0 && has_capability(tsk, CAP_MAC_OVERRIDE))
+	if (rc != 0 && smack_has_privilege(tsk, CAP_MAC_OVERRIDE))
 		rc = 0;
 
 	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_TASK);
-- 
2.1.0
