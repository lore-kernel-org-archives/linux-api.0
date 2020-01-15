From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 14/14] smack: Implement the watch_key and
 post_notification hooks [ver #3]
Date: Wed, 15 Jan 2020 13:32:40 +0000
Message-ID: <157909516006.20155.16914270465856385214.stgit@warthog.procyon.org.uk>
References: <157909503552.20155.3030058841911628518.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <157909503552.20155.3030058841911628518.stgit@warthog.procyon.org.uk>
Sender: linux-block-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>dhowells@redhat.com, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Implement the watch_key security hook in Smack to make sure that a key
grants the caller Read permission in order to set a watch on a key.

Also implement the post_notification security hook to make sure that the
notification source is granted Write permission by the watch queue.

For the moment, the watch_devices security hook is left unimplemented as
it's not obvious what the object should be since the queue is global and
didn't previously exist.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
---

 include/linux/lsm_audit.h  |    1 +
 security/smack/smack_lsm.c |   82 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
index 915330abf6e5..734d67889826 100644
--- a/include/linux/lsm_audit.h
+++ b/include/linux/lsm_audit.h
@@ -74,6 +74,7 @@ struct common_audit_data {
 #define LSM_AUDIT_DATA_FILE	12
 #define LSM_AUDIT_DATA_IBPKEY	13
 #define LSM_AUDIT_DATA_IBENDPORT 14
+#define LSM_AUDIT_DATA_NOTIFICATION 15
 	union 	{
 		struct path path;
 		struct dentry *dentry;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index ecea41ce919b..71b6f37d49c1 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4273,7 +4273,7 @@ static int smack_key_permission(key_ref_t key_ref,
 	if (tkp == NULL)
 		return -EACCES;
 
-	if (smack_privileged_cred(CAP_MAC_OVERRIDE, cred))
+	if (smack_privileged(CAP_MAC_OVERRIDE))
 		return 0;
 
 #ifdef CONFIG_AUDIT
@@ -4319,8 +4319,81 @@ static int smack_key_getsecurity(struct key *key, char **_buffer)
 	return length;
 }
 
+
+#ifdef CONFIG_KEY_NOTIFICATIONS
+/**
+ * smack_watch_key - Smack access to watch a key for notifications.
+ * @key: The key to be watched
+ *
+ * Return 0 if the @watch->cred has permission to read from the key object and
+ * an error otherwise.
+ */
+static int smack_watch_key(struct key *key)
+{
+	struct smk_audit_info ad;
+	struct smack_known *tkp = smk_of_current();
+	int rc;
+
+	if (key == NULL)
+		return -EINVAL;
+	/*
+	 * If the key hasn't been initialized give it access so that
+	 * it may do so.
+	 */
+	if (key->security == NULL)
+		return 0;
+	/*
+	 * This should not occur
+	 */
+	if (tkp == NULL)
+		return -EACCES;
+
+	if (smack_privileged_cred(CAP_MAC_OVERRIDE, current_cred()))
+		return 0;
+
+#ifdef CONFIG_AUDIT
+	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_KEY);
+	ad.a.u.key_struct.key = key->serial;
+	ad.a.u.key_struct.key_desc = key->description;
+#endif
+	rc = smk_access(tkp, key->security, MAY_READ, &ad);
+	rc = smk_bu_note("key watch", tkp, key->security, MAY_READ, rc);
+	return rc;
+}
+#endif /* CONFIG_KEY_NOTIFICATIONS */
 #endif /* CONFIG_KEYS */
 
+#ifdef CONFIG_WATCH_QUEUE
+/**
+ * smack_post_notification - Smack access to post a notification to a queue
+ * @w_cred: The credentials of the watcher.
+ * @cred: The credentials of the event source (may be NULL).
+ * @n: The notification message to be posted.
+ */
+static int smack_post_notification(const struct cred *w_cred,
+				   const struct cred *cred,
+				   struct watch_notification *n)
+{
+	struct smk_audit_info ad;
+	struct smack_known *subj, *obj;
+	int rc;
+
+	/* Always let maintenance notifications through. */
+	if (n->type == WATCH_TYPE_META)
+		return 0;
+
+	if (!cred)
+		return 0;
+	subj = smk_of_task(smack_cred(cred));
+	obj = smk_of_task(smack_cred(w_cred));
+
+	smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_NOTIFICATION);
+	rc = smk_access(subj, obj, MAY_WRITE, &ad);
+	rc = smk_bu_note("notification", subj, obj, MAY_WRITE, rc);
+	return rc;
+}
+#endif /* CONFIG_WATCH_QUEUE */
+
 /*
  * Smack Audit hooks
  *
@@ -4709,8 +4782,15 @@ static struct security_hook_list smack_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(key_free, smack_key_free),
 	LSM_HOOK_INIT(key_permission, smack_key_permission),
 	LSM_HOOK_INIT(key_getsecurity, smack_key_getsecurity),
+#ifdef CONFIG_KEY_NOTIFICATIONS
+	LSM_HOOK_INIT(watch_key, smack_watch_key),
+#endif
 #endif /* CONFIG_KEYS */
 
+#ifdef CONFIG_WATCH_QUEUE
+	LSM_HOOK_INIT(post_notification, smack_post_notification),
+#endif
+
  /* Audit hooks */
 #ifdef CONFIG_AUDIT
 	LSM_HOOK_INIT(audit_rule_init, smack_audit_rule_init),
