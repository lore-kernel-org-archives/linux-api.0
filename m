From: David Howells <dhowells@redhat.com>
Subject: [PATCH 10/11] selinux: Implement the watch_key security hook [ver
 #8]
Date: Wed, 04 Sep 2019 23:17:14 +0100
Message-ID: <156763543468.18676.2518876207052977804.stgit@warthog.procyon.org.uk>
References: <156763534546.18676.3530557439501101639.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <156763534546.18676.3530557439501101639.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>dhowells@redhat.com, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Implement the watch_key security hook to make sure that a key grants the
caller View permission in order to set a watch on a key.

For the moment, the watch_devices security hook is left unimplemented as
it's not obvious what the object should be since the queue is global and
didn't previously exist.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
---

 security/selinux/hooks.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 74dd46de01b6..88df06969bed 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6533,6 +6533,17 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 	*_buffer = context;
 	return rc;
 }
+
+#ifdef CONFIG_KEY_NOTIFICATIONS
+static int selinux_watch_key(struct key *key)
+{
+	struct key_security_struct *ksec = key->security;
+	u32 sid = current_sid();
+
+	return avc_has_perm(&selinux_state,
+			    sid, ksec->sid, SECCLASS_KEY, KEY_NEED_VIEW, NULL);
+}
+#endif
 #endif
 
 #ifdef CONFIG_SECURITY_INFINIBAND
@@ -6965,6 +6976,9 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(key_free, selinux_key_free),
 	LSM_HOOK_INIT(key_permission, selinux_key_permission),
 	LSM_HOOK_INIT(key_getsecurity, selinux_key_getsecurity),
+#ifdef CONFIG_KEY_NOTIFICATIONS
+	LSM_HOOK_INIT(watch_key, selinux_watch_key),
+#endif
 #endif
 
 #ifdef CONFIG_AUDIT
