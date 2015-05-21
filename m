From: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 4/8] smack: abstraction layer for 2 common Smack operations
Date: Thu, 21 May 2015 13:53:38 +0200
Message-ID: <1432209222-8479-5-git-send-email-l.pawelczyk__16980.4360637956$1432209388$gmane$org@samsung.com>
References: <1432209222-8479-1-git-send-email-l.pawelczyk@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1432209222-8479-1-git-send-email-l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ionut Alexa <ionut.m.alexa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Mauro Carvalho Chehab <mchehab@os>
Cc: Lukasz Pawelczyk <havner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch adds two new functions that provide an abstraction layer for
two common internal Smack operations:

smk_find_label_name() - returns a label name (char*) from a struct
                        smack_known pointer
smk_get_label()       - either finds or imports a label from a raw label
                        name (char*) and returns struct smack_known point

This patch also simplifies some pieces of code due to addition of those
2 functions (e.g. smack_inode_post_setxattr, smk_fill_rule,
smk_write_revoke_subj).

It is meant as a preparation for namespaces patches. Those 2 functions
will serve as entry points for namespace operations.

This patch should not change the Smack behaviour in any way.

Signed-off-by: Lukasz Pawelczyk <l.pawelczyk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 security/smack/smack.h        |   2 +
 security/smack/smack_access.c |  40 ++++++++++++
 security/smack/smack_lsm.c    |  76 ++++++++++++-----------
 security/smack/smackfs.c      | 137 ++++++++++++++++++++++--------------------
 4 files changed, 155 insertions(+), 100 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index fa8fa87..fa32495 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -249,6 +249,8 @@ int smk_netlbl_mls(int, char *, struct netlbl_lsm_secattr *, int);
 struct smack_known *smk_import_entry(const char *, int);
 void smk_insert_entry(struct smack_known *skp);
 struct smack_known *smk_find_entry(const char *);
+char *smk_find_label_name(struct smack_known *skp);
+struct smack_known *smk_get_label(const char *string, int len, bool import);
 
 /*
  * Shared data.
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index 408e20b..3bf4cad 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -617,3 +617,43 @@ struct smack_known *smack_from_secid(const u32 secid)
 	rcu_read_unlock();
 	return &smack_known_invalid;
 }
+
+/**
+ * smk_find_label_name - A helper to get a string value of a label
+ * @skp: a label we want a string value from
+ *
+ * Returns a pointer to a label name or NULL if label name not found.
+ */
+char *smk_find_label_name(struct smack_known *skp)
+{
+	return skp->smk_known;
+}
+
+/**
+ * smk_get_label - A helper to get the smack_known value from a string using
+ *                 either import or find functions if it already exists
+ * @string: a name of a label we look for or want to import
+ * @len: the string size, or zero if it is NULL terminated
+ * @import: whether we should import the label if not found
+ *
+ * Returns a smack_known label that is either imported or found.
+ * NULL if label not found (only when import == false).
+ * Error code otherwise.
+ */
+struct smack_known *smk_get_label(const char *string, int len, bool import)
+{
+	struct smack_known *skp;
+	char *cp;
+
+	if (import) {
+		skp = smk_import_entry(string, len);
+	} else {
+		cp = smk_parse_smack(string, len);
+		if (IS_ERR(cp))
+			return ERR_CAST(cp);
+
+		skp = smk_find_entry(cp);
+	}
+
+	return skp;
+}
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index ee7bb63..4a197b6 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -608,7 +608,7 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 
 		if (strncmp(op, SMK_FSHAT, strlen(SMK_FSHAT)) == 0) {
 			op += strlen(SMK_FSHAT);
-			skp = smk_import_entry(op, 0);
+			skp = smk_get_label(op, 0, true);
 			if (IS_ERR(skp))
 				return PTR_ERR(skp);
 			sp->smk_hat = skp;
@@ -616,7 +616,7 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 
 		} else if (strncmp(op, SMK_FSFLOOR, strlen(SMK_FSFLOOR)) == 0) {
 			op += strlen(SMK_FSFLOOR);
-			skp = smk_import_entry(op, 0);
+			skp = smk_get_label(op, 0, true);
 			if (IS_ERR(skp))
 				return PTR_ERR(skp);
 			sp->smk_floor = skp;
@@ -625,7 +625,7 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 		} else if (strncmp(op, SMK_FSDEFAULT,
 				   strlen(SMK_FSDEFAULT)) == 0) {
 			op += strlen(SMK_FSDEFAULT);
-			skp = smk_import_entry(op, 0);
+			skp = smk_get_label(op, 0, true);
 			if (IS_ERR(skp))
 				return PTR_ERR(skp);
 			sp->smk_default = skp;
@@ -633,7 +633,7 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 
 		} else if (strncmp(op, SMK_FSROOT, strlen(SMK_FSROOT)) == 0) {
 			op += strlen(SMK_FSROOT);
-			skp = smk_import_entry(op, 0);
+			skp = smk_get_label(op, 0, true);
 			if (IS_ERR(skp))
 				return PTR_ERR(skp);
 			sp->smk_root = skp;
@@ -641,7 +641,7 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 
 		} else if (strncmp(op, SMK_FSTRANS, strlen(SMK_FSTRANS)) == 0) {
 			op += strlen(SMK_FSTRANS);
-			skp = smk_import_entry(op, 0);
+			skp = smk_get_label(op, 0, true);
 			if (IS_ERR(skp))
 				return PTR_ERR(skp);
 			sp->smk_root = skp;
@@ -1125,7 +1125,7 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
 		rc = -EPERM;
 
 	if (rc == 0 && check_import) {
-		skp = size ? smk_import_entry(value, size) : NULL;
+		skp = size ? smk_get_label(value, size, true) : NULL;
 		if (IS_ERR(skp))
 			rc = PTR_ERR(skp);
 		else if (skp == NULL || (check_star &&
@@ -1159,6 +1159,7 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
 				      const void *value, size_t size, int flags)
 {
 	struct smack_known *skp;
+	struct smack_known **skpp = NULL;
 	struct inode_smack *isp = d_backing_inode(dentry)->i_security;
 
 	if (strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0) {
@@ -1166,27 +1167,21 @@ static void smack_inode_post_setxattr(struct dentry *dentry, const char *name,
 		return;
 	}
 
-	if (strcmp(name, XATTR_NAME_SMACK) == 0) {
-		skp = smk_import_entry(value, size);
-		if (!IS_ERR(skp))
-			isp->smk_inode = skp;
-		else
-			isp->smk_inode = &smack_known_invalid;
-	} else if (strcmp(name, XATTR_NAME_SMACKEXEC) == 0) {
-		skp = smk_import_entry(value, size);
-		if (!IS_ERR(skp))
-			isp->smk_task = skp;
-		else
-			isp->smk_task = &smack_known_invalid;
-	} else if (strcmp(name, XATTR_NAME_SMACKMMAP) == 0) {
-		skp = smk_import_entry(value, size);
+	if (strcmp(name, XATTR_NAME_SMACK) == 0)
+		skpp = &isp->smk_inode;
+	else if (strcmp(name, XATTR_NAME_SMACKEXEC) == 0)
+		skpp = &isp->smk_task;
+	else if (strcmp(name, XATTR_NAME_SMACKMMAP) == 0)
+		skpp = &isp->smk_mmap;
+
+	if (skpp) {
+		skp = smk_get_label(value, size, true);
+
 		if (!IS_ERR(skp))
-			isp->smk_mmap = skp;
+			*skpp = skp;
 		else
-			isp->smk_mmap = &smack_known_invalid;
+			*skpp = &smack_known_invalid;
 	}
-
-	return;
 }
 
 /**
@@ -1280,15 +1275,17 @@ static int smack_inode_getsecurity(const struct inode *inode,
 	struct socket *sock;
 	struct super_block *sbp;
 	struct inode *ip = (struct inode *)inode;
-	struct smack_known *isp;
-	int ilen;
+	struct smack_known *isp = NULL;
 	int rc = 0;
 
-	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
+	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0)
 		isp = smk_of_inode(inode);
-		ilen = strlen(isp->smk_known);
-		*buffer = isp->smk_known;
-		return ilen;
+
+	if (isp) {
+		*buffer = smk_find_label_name(isp);
+		if (*buffer == NULL)
+			*buffer = smack_known_huh.smk_known;
+		return strlen(*buffer);
 	}
 
 	/*
@@ -1311,10 +1308,11 @@ static int smack_inode_getsecurity(const struct inode *inode,
 	else
 		return -EOPNOTSUPP;
 
-	ilen = strlen(isp->smk_known);
 	if (rc == 0) {
-		*buffer = isp->smk_known;
-		rc = ilen;
+		*buffer = smk_find_label_name(isp);
+		if (*buffer == NULL)
+			*buffer = smack_known_huh.smk_known;
+		rc = strlen(*buffer);
 	}
 
 	return rc;
@@ -3270,7 +3268,10 @@ static int smack_getprocattr(struct task_struct *p, char *name, char **value)
 	if (strcmp(name, "current") != 0)
 		return -EINVAL;
 
-	cp = kstrdup(skp->smk_known, GFP_KERNEL);
+	cp = smk_find_label_name(skp);
+	if (cp == NULL)
+		cp = smack_known_huh.smk_known;
+	cp = kstrdup(cp, GFP_KERNEL);
 	if (cp == NULL)
 		return -ENOMEM;
 
@@ -3314,7 +3315,7 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 	if (strcmp(name, "current") != 0)
 		return -EINVAL;
 
-	skp = smk_import_entry(value, size);
+	skp = smk_get_label(value, size, true);
 	if (IS_ERR(skp))
 		return PTR_ERR(skp);
 
@@ -4042,7 +4043,10 @@ static int smack_key_getsecurity(struct key *key, char **_buffer)
 		return 0;
 	}
 
-	copy = kstrdup(skp->smk_known, GFP_KERNEL);
+	copy = smk_find_label_name(skp);
+	if (copy == NULL)
+		copy = smack_known_huh.smk_known;
+	copy = kstrdup(copy, GFP_KERNEL);
 	if (copy == NULL)
 		return -ENOMEM;
 	length = strlen(copy) + 1;
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 3e42426..5ec1e8e 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -345,36 +345,17 @@ static int smk_fill_rule(const char *subject, const char *object,
 				struct smack_parsed_rule *rule, int import,
 				int len)
 {
-	const char *cp;
-	struct smack_known *skp;
-
-	if (import) {
-		rule->smk_subject = smk_import_entry(subject, len);
-		if (IS_ERR(rule->smk_subject))
-			return PTR_ERR(rule->smk_subject);
-
-		rule->smk_object = smk_import_entry(object, len);
-		if (IS_ERR(rule->smk_object))
-			return PTR_ERR(rule->smk_object);
-	} else {
-		cp = smk_parse_smack(subject, len);
-		if (IS_ERR(cp))
-			return PTR_ERR(cp);
-		skp = smk_find_entry(cp);
-		kfree(cp);
-		if (skp == NULL)
-			return -ENOENT;
-		rule->smk_subject = skp;
-
-		cp = smk_parse_smack(object, len);
-		if (IS_ERR(cp))
-			return PTR_ERR(cp);
-		skp = smk_find_entry(cp);
-		kfree(cp);
-		if (skp == NULL)
-			return -ENOENT;
-		rule->smk_object = skp;
-	}
+	rule->smk_subject = smk_get_label(subject, len, import);
+	if (IS_ERR(rule->smk_subject))
+		return PTR_ERR(rule->smk_subject);
+	if (rule->smk_subject == NULL)
+		return -ENOENT;
+
+	rule->smk_object = smk_get_label(object, len, import);
+	if (IS_ERR(rule->smk_object))
+		return PTR_ERR(rule->smk_object);
+	if (rule->smk_object == NULL)
+		return -ENOENT;
 
 	rule->smk_access1 = smk_perm_from_str(access1);
 	if (access2)
@@ -605,6 +586,9 @@ static void smk_seq_stop(struct seq_file *s, void *v)
 
 static void smk_rule_show(struct seq_file *s, struct smack_rule *srp, int max)
 {
+	char *sbj;
+	char *obj;
+
 	/*
 	 * Don't show any rules with label names too long for
 	 * interface file (/smack/load or /smack/load2)
@@ -618,9 +602,13 @@ static void smk_rule_show(struct seq_file *s, struct smack_rule *srp, int max)
 	if (srp->smk_access == 0)
 		return;
 
-	seq_printf(s, "%s %s",
-		   srp->smk_subject->smk_known,
-		   srp->smk_object->smk_known);
+	sbj = smk_find_label_name(srp->smk_subject);
+	obj = smk_find_label_name(srp->smk_object);
+
+	if (sbj == NULL || obj == NULL)
+		return;
+
+	seq_printf(s, "%s %s", sbj, obj);
 
 	seq_putc(s, ' ');
 
@@ -811,6 +799,7 @@ static int cipso_seq_show(struct seq_file *s, void *v)
 		 list_entry(list, struct smack_known, list);
 	struct netlbl_lsm_catmap *cmp = skp->smk_netlabel.attr.mls.cat;
 	char sep = '/';
+	char *cp;
 	int i;
 
 	/*
@@ -824,7 +813,11 @@ static int cipso_seq_show(struct seq_file *s, void *v)
 	if (strlen(skp->smk_known) >= SMK_LABELLEN)
 		return 0;
 
-	seq_printf(s, "%s %3d", skp->smk_known, skp->smk_netlabel.attr.mls.lvl);
+	cp = smk_find_label_name(skp);
+	if (cp == NULL)
+		return 0;
+
+	seq_printf(s, "%s %3d", cp, skp->smk_netlabel.attr.mls.lvl);
 
 	for (i = netlbl_catmap_walk(cmp, 0); i >= 0;
 	     i = netlbl_catmap_walk(cmp, i + 1)) {
@@ -913,7 +906,7 @@ static ssize_t smk_set_cipso(struct file *file, const char __user *buf,
 	 */
 	mutex_lock(&smack_cipso_lock);
 
-	skp = smk_import_entry(rule, 0);
+	skp = smk_get_label(rule, 0, true);
 	if (IS_ERR(skp)) {
 		rc = PTR_ERR(skp);
 		goto out;
@@ -1002,9 +995,14 @@ static int cipso2_seq_show(struct seq_file *s, void *v)
 		 list_entry(list, struct smack_known, list);
 	struct netlbl_lsm_catmap *cmp = skp->smk_netlabel.attr.mls.cat;
 	char sep = '/';
+	char *cp;
 	int i;
 
-	seq_printf(s, "%s %3d", skp->smk_known, skp->smk_netlabel.attr.mls.lvl);
+	cp = smk_find_label_name(skp);
+	if (cp == NULL)
+		return 0;
+
+	seq_printf(s, "%s %3d", cp, skp->smk_netlabel.attr.mls.lvl);
 
 	for (i = netlbl_catmap_walk(cmp, 0); i >= 0;
 	     i = netlbl_catmap_walk(cmp, i + 1)) {
@@ -1087,11 +1085,15 @@ static int netlbladdr_seq_show(struct seq_file *s, void *v)
 	unsigned char *hp = (char *) &skp->smk_host.sin_addr.s_addr;
 	int maskn;
 	u32 temp_mask = be32_to_cpu(skp->smk_mask.s_addr);
+	char *label = smk_find_label_name(skp->smk_label);
+
+	if (label == NULL)
+		return 0;
 
 	for (maskn = 0; temp_mask; temp_mask <<= 1, maskn++);
 
 	seq_printf(s, "%u.%u.%u.%u/%d %s\n",
-		hp[0], hp[1], hp[2], hp[3], maskn, skp->smk_label->smk_known);
+		hp[0], hp[1], hp[2], hp[3], maskn, label);
 
 	return 0;
 }
@@ -1237,7 +1239,7 @@ static ssize_t smk_write_netlbladdr(struct file *file, const char __user *buf,
 	 * If smack begins with '-', it is an option, don't import it
 	 */
 	if (smack[0] != '-') {
-		skp = smk_import_entry(smack, 0);
+		skp = smk_get_label(smack, 0, true);
 		if (IS_ERR(skp)) {
 			rc = PTR_ERR(skp);
 			goto free_out;
@@ -1566,6 +1568,7 @@ static ssize_t smk_read_ambient(struct file *filp, char __user *buf,
 				size_t cn, loff_t *ppos)
 {
 	ssize_t rc;
+	char *cp;
 	int asize;
 
 	if (*ppos != 0)
@@ -1576,12 +1579,14 @@ static ssize_t smk_read_ambient(struct file *filp, char __user *buf,
 	 */
 	mutex_lock(&smack_ambient_lock);
 
-	asize = strlen(smack_net_ambient->smk_known) + 1;
+	cp = smk_find_label_name(smack_net_ambient);
+	if (cp == NULL)
+		cp = smack_known_huh.smk_known;
+
+	asize = strlen(cp) + 1;
 
 	if (cn >= asize)
-		rc = simple_read_from_buffer(buf, cn, ppos,
-					     smack_net_ambient->smk_known,
-					     asize);
+		rc = simple_read_from_buffer(buf, cn, ppos, cp, asize);
 	else
 		rc = -EINVAL;
 
@@ -1619,7 +1624,7 @@ static ssize_t smk_write_ambient(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	skp = smk_import_entry(data, count);
+	skp = smk_get_label(data, count, true);
 	if (IS_ERR(skp)) {
 		rc = PTR_ERR(skp);
 		goto out;
@@ -1663,8 +1668,11 @@ static ssize_t smk_read_onlycap(struct file *filp, char __user *buf,
 	if (*ppos != 0)
 		return 0;
 
-	if (smack_onlycap != NULL)
-		smack = smack_onlycap->smk_known;
+	if (smack_onlycap != NULL) {
+		smack = smk_find_label_name(smack_onlycap);
+		if (smack == NULL)
+			smack = smack_known_huh.smk_known;
+	}
 
 	asize = strlen(smack) + 1;
 
@@ -1719,7 +1727,7 @@ static ssize_t smk_write_onlycap(struct file *file, const char __user *buf,
 	 *
 	 * But do so only on invalid label, not on system errors.
 	 */
-	skp = smk_import_entry(data, count);
+	skp = smk_get_label(data, count, true);
 	if (PTR_ERR(skp) == -EINVAL)
 		skp = NULL;
 	else if (IS_ERR(skp)) {
@@ -1760,8 +1768,11 @@ static ssize_t smk_read_unconfined(struct file *filp, char __user *buf,
 	if (*ppos != 0)
 		return 0;
 
-	if (smack_unconfined != NULL)
-		smack = smack_unconfined->smk_known;
+	if (smack_unconfined != NULL) {
+		smack = smk_find_label_name(smack_unconfined);
+		if (smack == NULL)
+			smack = smack_known_huh.smk_known;
+	}
 
 	asize = strlen(smack) + 1;
 
@@ -1808,7 +1819,7 @@ static ssize_t smk_write_unconfined(struct file *file, const char __user *buf,
 	 *
 	 * But do so only on invalid label, not on system errors.
 	 */
-	skp = smk_import_entry(data, count);
+	skp = smk_get_label(data, count, true);
 	if (PTR_ERR(skp) == -EINVAL)
 		skp = NULL;
 	else if (IS_ERR(skp)) {
@@ -2205,7 +2216,6 @@ static ssize_t smk_write_revoke_subj(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
 	char *data = NULL;
-	const char *cp = NULL;
 	struct smack_known *skp;
 	struct smack_rule *sp;
 	struct list_head *rule_list;
@@ -2230,13 +2240,11 @@ static ssize_t smk_write_revoke_subj(struct file *file, const char __user *buf,
 		goto free_out;
 	}
 
-	cp = smk_parse_smack(data, count);
-	if (IS_ERR(cp)) {
-		rc = PTR_ERR(cp);
+	skp = smk_get_label(data, count, false);
+	if (IS_ERR(skp)) {
+		rc = PTR_ERR(skp);
 		goto free_out;
 	}
-
-	skp = smk_find_entry(cp);
 	if (skp == NULL)
 		goto free_out;
 
@@ -2252,7 +2260,6 @@ static ssize_t smk_write_revoke_subj(struct file *file, const char __user *buf,
 
 free_out:
 	kfree(data);
-	kfree(cp);
 	return rc;
 }
 
@@ -2315,23 +2322,25 @@ static const struct file_operations smk_change_rule_ops = {
 static ssize_t smk_read_syslog(struct file *filp, char __user *buf,
 				size_t cn, loff_t *ppos)
 {
-	struct smack_known *skp;
 	ssize_t rc = -EINVAL;
+	char *cp;
 	int asize;
 
 	if (*ppos != 0)
 		return 0;
 
 	if (smack_syslog_label == NULL)
-		skp = &smack_known_star;
-	else
-		skp = smack_syslog_label;
+		cp = smack_known_star.smk_known;
+	else {
+		cp = smk_find_label_name(smack_syslog_label);
+		if (cp == NULL)
+			cp = smack_known_huh.smk_known;
+	}
 
-	asize = strlen(skp->smk_known) + 1;
+	asize = strlen(cp) + 1;
 
 	if (cn >= asize)
-		rc = simple_read_from_buffer(buf, cn, ppos, skp->smk_known,
-						asize);
+		rc = simple_read_from_buffer(buf, cn, ppos, cp, asize);
 
 	return rc;
 }
@@ -2362,7 +2371,7 @@ static ssize_t smk_write_syslog(struct file *file, const char __user *buf,
 	if (copy_from_user(data, buf, count) != 0)
 		rc = -EFAULT;
 	else {
-		skp = smk_import_entry(data, count);
+		skp = smk_get_label(data, count, true);
 		if (IS_ERR(skp))
 			rc = PTR_ERR(skp);
 		else
-- 
2.1.0
