From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 10/11] selinux: Implement the watch_key security hook [ver #7]
Date: Fri, 30 Aug 2019 15:41:30 +0100
Message-ID: <13308.1567176090@warthog.procyon.org.uk>
References: <21eb33e8-5624-0124-8690-bbea41a1b589@tycho.nsa.gov> <156717343223.2204.15875738850129174524.stgit@warthog.procyon.org.uk> <156717352079.2204.16378075382991665807.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <21eb33e8-5624-0124-8690-bbea41a1b589@tycho.nsa.gov>
Content-ID: <13307.1567176090.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, Casey Schaufler <casey@schaufler-ca.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

How about the attached instead, then?

David
---
commit 00444a695b35c602230ac2cabb4f1d7e94e3966d
Author: David Howells <dhowells@redhat.com>
Date:   Thu Aug 29 17:01:34 2019 +0100

    selinux: Implement the watch_key security hook
    
    Implement the watch_key security hook to make sure that a key grants the
    caller View permission in order to set a watch on a key.
    
    For the moment, the watch_devices security hook is left unimplemented as
    it's not obvious what the object should be since the queue is global and
    didn't previously exist.
    
    Signed-off-by: David Howells <dhowells@redhat.com>

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
