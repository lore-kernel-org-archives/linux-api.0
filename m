From: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 5/8] smack: misc cleanups in preparation for a namespace patch
Date: Thu, 21 May 2015 13:53:39 +0200
Message-ID: <1432209222-8479-6-git-send-email-l.pawelczyk__14221.632658928$1432209310$gmane$org@samsung.com>
References: <1432209222-8479-1-git-send-email-l.pawelczyk@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1432209222-8479-1-git-send-email-l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ionut Alexa <ionut.m.alexa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Mauro Carvalho Chehab <mchehab@os>
Cc: Lukasz Pawelczyk <havner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch does some small miscellaneous cleanups and additions that
should not change the code behaviour in any way. Its only purpose is to
shape the code in a way that the smack namespace patches would be
smaller and easier to understand.

Changes:
- two small functions added
- one macro has been moved to a header
- minor code reformatting in several places for readability
- unnecessarily increasing string size has been fixed

This patch should not change the behaviour of the Smack in any way.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 security/smack/smack.h        | 25 ++++++++++++++++++-
 security/smack/smack_access.c | 18 +++++++++-----
 security/smack/smack_lsm.c    | 58 ++++++++++++++++---------------------------
 3 files changed, 58 insertions(+), 43 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index fa32495..3818d19 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -229,6 +229,7 @@ struct smk_audit_info {
 	struct smack_audit_data sad;
 #endif
 };
+
 /*
  * These functions are in smack_lsm.c
  */
@@ -240,7 +241,7 @@ struct inode_smack *new_inode_smack(struct smack_known *);
 int smk_access_entry(char *, char *, struct list_head *);
 int smk_access(struct smack_known *, struct smack_known *,
 	       int, struct smk_audit_info *);
-int smk_tskacc(struct task_smack *, struct smack_known *,
+int smk_tskacc(struct task_struct *, struct smack_known *,
 	       u32, struct smk_audit_info *);
 int smk_curacc(struct smack_known *, u32, struct smk_audit_info *);
 struct smack_known *smack_from_secid(const u32);
@@ -287,6 +288,7 @@ extern struct hlist_head smack_known_hash[SMACK_HASH_SLOTS];
 static inline int smk_inode_transmutable(const struct inode *isp)
 {
 	struct inode_smack *sip = isp->i_security;
+
 	return (sip->smk_flags & SMK_INODE_TRANSMUTE) != 0;
 }
 
@@ -296,10 +298,31 @@ static inline int smk_inode_transmutable(const struct inode *isp)
 static inline struct smack_known *smk_of_inode(const struct inode *isp)
 {
 	struct inode_smack *sip = isp->i_security;
+
 	return sip->smk_inode;
 }
 
 /*
+ * Present a pointer to the smack label entry in an inode blob for an exec.
+ */
+static inline struct smack_known *smk_of_exec(const struct inode *isp)
+{
+	struct inode_smack *sip = isp->i_security;
+
+	return sip->smk_task;
+}
+
+/*
+ * Present a pointer to the smack label entry in an inode blob for an mmap.
+ */
+static inline struct smack_known *smk_of_mmap(const struct inode *isp)
+{
+	struct inode_smack *sip = isp->i_security;
+
+	return sip->smk_mmap;
+}
+
+/*
  * Present a pointer to the smack label entry in an task blob.
  */
 static inline struct smack_known *smk_of_task(const struct task_smack *tsp)
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 3bf4cad..47a9c92 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -167,6 +167,7 @@ int smk_access(struct smack_known *subject, struct smack_known *object,
 		if (subject == &smack_known_hat)
 			goto out_audit;
 	}
+
 	/*
 	 * Beyond here an explicit relationship is required.
 	 * If the requested access is contained in the available
@@ -183,6 +184,7 @@ int smk_access(struct smack_known *subject, struct smack_known *object,
 		rc = -EACCES;
 		goto out_audit;
 	}
+
 #ifdef CONFIG_SECURITY_SMACK_BRINGUP
 	/*
 	 * Return a positive value if using bringup mode.
@@ -225,10 +227,10 @@ out_audit:
  * non zero otherwise. It allows that the task may have the capability
  * to override the rules.
  */
-int smk_tskacc(struct task_smack *tsp, struct smack_known *obj_known,
+int smk_tskacc(struct task_struct *task, struct smack_known *obj_known,
 	       u32 mode, struct smk_audit_info *a)
 {
-	struct smack_known *sbj_known = smk_of_task(tsp);
+	struct smack_known *sbj_known = smk_of_task_struct(task);
 	int may;
 	int rc;
 
@@ -237,13 +239,19 @@ int smk_tskacc(struct task_smack *tsp, struct smack_known *obj_known,
 	 */
 	rc = smk_access(sbj_known, obj_known, mode, NULL);
 	if (rc >= 0) {
+		struct task_smack *tsp;
+
 		/*
 		 * If there is an entry in the task's rule list
 		 * it can further restrict access.
 		 */
+		rcu_read_lock();
+		tsp = __task_cred(task)->security;
 		may = smk_access_entry(sbj_known->smk_known,
 				       obj_known->smk_known,
 				       &tsp->smk_rules);
+		rcu_read_unlock();
+
 		if (may < 0)
 			goto out_audit;
 		if ((mode & may) == mode)
@@ -280,9 +288,7 @@ out_audit:
 int smk_curacc(struct smack_known *obj_known,
 	       u32 mode, struct smk_audit_info *a)
 {
-	struct task_smack *tsp = current_security();
-
-	return smk_tskacc(tsp, obj_known, mode, a);
+	return smk_tskacc(current, obj_known, mode, a);
 }
 
 #ifdef CONFIG_AUDIT
@@ -456,7 +462,7 @@ char *smk_parse_smack(const char *string, int len)
 	int i;
 
 	if (len <= 0)
-		len = strlen(string) + 1;
+		len = strlen(string);
 
 	/*
 	 * Reserve a leading '-' as an indicator that
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 4a197b6..bb74ca9 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -383,8 +383,6 @@ static int smk_ptrace_rule_check(struct task_struct *tracer,
 {
 	int rc;
 	struct smk_audit_info ad, *saip = NULL;
-	struct task_smack *tsp;
-	struct smack_known *tracer_known;
 
 	if ((mode & PTRACE_MODE_NOAUDIT) == 0) {
 		smk_ad_init(&ad, func, LSM_AUDIT_DATA_TASK);
@@ -392,13 +390,12 @@ static int smk_ptrace_rule_check(struct task_struct *tracer,
 		saip = &ad;
 	}
 
-	rcu_read_lock();
-	tsp = __task_cred(tracer)->security;
-	tracer_known = smk_of_task(tsp);
 
 	if ((mode & PTRACE_MODE_ATTACH) &&
 	    (smack_ptrace_rule == SMACK_PTRACE_EXACT ||
 	     smack_ptrace_rule == SMACK_PTRACE_DRACONIAN)) {
+		struct smack_known *tracer_known = smk_of_task_struct(tracer);
+
 		if (tracer_known->smk_known == tracee_known->smk_known)
 			rc = 0;
 		else if (smack_ptrace_rule == SMACK_PTRACE_DRACONIAN)
@@ -406,22 +403,18 @@ static int smk_ptrace_rule_check(struct task_struct *tracer,
 		else if (smack_has_privilege(tracer, CAP_SYS_PTRACE))
 			rc = 0;
 		else
-			rc = -EACCES;
+			rc = -EPERM;
 
 		if (saip)
 			smack_log(tracer_known->smk_known,
 				  tracee_known->smk_known,
 				  0, rc, saip);
 
-		rcu_read_unlock();
 		return rc;
 	}
 
 	/* In case of rule==SMACK_PTRACE_DEFAULT or mode==PTRACE_MODE_READ */
-	rc = smk_tskacc(tsp, tracee_known, smk_ptrace_mode(mode), saip);
-
-	rcu_read_unlock();
-	return rc;
+	return smk_tskacc(tracer, tracee_known, smk_ptrace_mode(mode), saip);
 }
 
 /*
@@ -440,9 +433,7 @@ static int smk_ptrace_rule_check(struct task_struct *tracer,
  */
 static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
 {
-	struct smack_known *skp;
-
-	skp = smk_of_task_struct(ctp);
+	struct smack_known *skp = smk_of_task_struct(ctp);
 
 	return smk_ptrace_rule_check(current, skp, mode, __func__);
 }
@@ -457,13 +448,9 @@ static int smack_ptrace_access_check(struct task_struct *ctp, unsigned int mode)
  */
 static int smack_ptrace_traceme(struct task_struct *ptp)
 {
-	int rc;
-	struct smack_known *skp;
-
-	skp = smk_of_task(current_security());
+	struct smack_known *skp = smk_of_current();
 
-	rc = smk_ptrace_rule_check(ptp, skp, PTRACE_MODE_ATTACH, __func__);
-	return rc;
+	return smk_ptrace_rule_check(ptp, skp, PTRACE_MODE_ATTACH, __func__);
 }
 
 /**
@@ -1529,13 +1516,14 @@ static int smack_mmap_file(struct file *file,
 	if (file == NULL)
 		return 0;
 
+	tsp = current_security();
+	skp = smk_of_task(tsp);
 	isp = file_inode(file)->i_security;
-	if (isp->smk_mmap == NULL)
-		return 0;
 	mkp = isp->smk_mmap;
 
-	tsp = current_security();
-	skp = smk_of_current();
+	if (mkp == NULL)
+		return 0;
+
 	rc = 0;
 
 	rcu_read_lock();
@@ -3348,11 +3336,13 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 static int smack_unix_stream_connect(struct sock *sock,
 				     struct sock *other, struct sock *newsk)
 {
-	struct smack_known *skp;
-	struct smack_known *okp;
 	struct socket_smack *ssp = sock->sk_security;
 	struct socket_smack *osp = other->sk_security;
 	struct socket_smack *nsp = newsk->sk_security;
+	struct smack_known *skp_out = ssp->smk_out;
+	struct smack_known *okp_out = osp->smk_out;
+	struct smack_known *skp_in = ssp->smk_in;
+	struct smack_known *okp_in = osp->smk_in;
 	struct smk_audit_info ad;
 	int rc = 0;
 #ifdef CONFIG_AUDIT
@@ -3360,19 +3350,15 @@ static int smack_unix_stream_connect(struct sock *sock,
 #endif
 
 	if (!smack_privileged(CAP_MAC_OVERRIDE)) {
-		skp = ssp->smk_out;
-		okp = osp->smk_in;
 #ifdef CONFIG_AUDIT
 		smk_ad_init_net(&ad, __func__, LSM_AUDIT_DATA_NET, &net);
 		smk_ad_setfield_u_net_sk(&ad, other);
 #endif
-		rc = smk_access(skp, okp, MAY_WRITE, &ad);
-		rc = smk_bu_note("UDS connect", skp, okp, MAY_WRITE, rc);
+		rc = smk_access(skp_out, okp_in, MAY_WRITE, &ad);
+		rc = smk_bu_note("UDS connect", skp_out, okp_in, MAY_WRITE, rc);
 		if (rc == 0) {
-			okp = osp->smk_out;
-			skp = ssp->smk_in;
-			rc = smk_access(okp, skp, MAY_WRITE, &ad);
-			rc = smk_bu_note("UDS connect", okp, skp,
+			rc = smk_access(okp_out, skp_in, MAY_WRITE, &ad);
+			rc = smk_bu_note("UDS connect", okp_out, skp_in,
 						MAY_WRITE, rc);
 		}
 	}
@@ -3381,8 +3367,8 @@ static int smack_unix_stream_connect(struct sock *sock,
 	 * Cross reference the peer labels for SO_PEERSEC.
 	 */
 	if (rc == 0) {
-		nsp->smk_packet = ssp->smk_out;
-		ssp->smk_packet = osp->smk_out;
+		nsp->smk_packet = skp_out;
+		ssp->smk_packet = okp_out;
 	}
 
 	return rc;
-- 
2.1.0
