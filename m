From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/11] security: Add a hook for the point of notification
 insertion [ver #6]
Date: Thu, 29 Aug 2019 19:30:16 +0100
Message-ID: <156710341641.10009.9324038712143541997.stgit@warthog.procyon.org.uk>
References: <156710338860.10009.12524626894838499011.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <156710338860.10009.12524626894838499011.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>dhowells@redhat.com, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add a security hook that allows an LSM to rule on whether a notification
message is allowed to be inserted into a particular watch queue.

The hook is given the following information:

 (1) The credentials of the triggerer (which may be init_cred for a system
     notification, eg. a hardware error).

 (2) The credentials of the whoever set the watch.

 (3) The notification message.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Casey Schaufler <casey@schaufler-ca.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>
cc: linux-security-module@vger.kernel.org
---

 include/linux/lsm_hooks.h |   10 ++++++++++
 include/linux/security.h  |   10 ++++++++++
 security/security.c       |    6 ++++++
 3 files changed, 26 insertions(+)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 19108185b254..e9f1f69cd04d 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1426,6 +1426,12 @@
  *	from devices (as a global set).
  *	@watch: The watch object
  *
+ * @post_notification:
+ *	Check to see if a watch notification can be posted to a particular
+ *	queue.
+ *	@w_cred: The credentials of the whoever set the watch.
+ *	@cred: The event-triggerer's credentials
+ *	@n: The notification being posted
  *
  * Security hooks for using the eBPF maps and programs functionalities through
  * eBPF syscalls.
@@ -1705,6 +1711,9 @@ union security_list_options {
 #ifdef CONFIG_WATCH_QUEUE
 	int (*watch_key)(struct watch *watch, struct key *key);
 	int (*watch_devices)(struct watch *watch);
+	int (*post_notification)(const struct cred *w_cred,
+				 const struct cred *cred,
+				 struct watch_notification *n);
 #endif /* CONFIG_WATCH_QUEUE */
 
 #ifdef CONFIG_SECURITY_NETWORK
@@ -1985,6 +1994,7 @@ struct security_hook_heads {
 #ifdef CONFIG_WATCH_QUEUE
 	struct hlist_head watch_key;
 	struct hlist_head watch_devices;
+	struct hlist_head post_notification;
 #endif /* CONFIG_WATCH_QUEUE */
 #ifdef CONFIG_SECURITY_NETWORK
 	struct hlist_head unix_stream_connect;
diff --git a/include/linux/security.h b/include/linux/security.h
index feeade454308..003437714eee 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -58,6 +58,7 @@ struct fs_context;
 struct fs_parameter;
 enum fs_value_type;
 struct watch;
+struct watch_notification;
 
 /* Default (no) options for the capable function */
 #define CAP_OPT_NONE 0x0
@@ -396,6 +397,9 @@ int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
 #ifdef CONFIG_WATCH_QUEUE
 int security_watch_key(struct watch *watch, struct key *key);
 int security_watch_devices(struct watch *watch);
+int security_post_notification(const struct cred *w_cred,
+			       const struct cred *cred,
+			       struct watch_notification *n);
 #endif /* CONFIG_WATCH_QUEUE */
 #else /* CONFIG_SECURITY */
 
@@ -1218,6 +1222,12 @@ static inline int security_watch_devices(struct watch *watch)
 {
 	return 0;
 }
+static inline int security_post_notification(const struct cred *w_cred,
+					     const struct cred *cred,
+					     struct watch_notification *n)
+{
+	return 0;
+}
 #endif /* CONFIG_WATCH_QUEUE */
 #endif	/* CONFIG_SECURITY */
 
diff --git a/security/security.c b/security/security.c
index 1ebd2c936a57..5afe966aea4e 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1927,6 +1927,12 @@ int security_watch_devices(struct watch *watch)
 	return call_int_hook(watch_devices, 0, watch);
 }
 
+int security_post_notification(const struct cred *w_cred,
+			       const struct cred *cred,
+			       struct watch_notification *n)
+{
+	return call_int_hook(post_notification, 0, w_cred, cred, n);
+}
 #endif /* CONFIG_WATCH_QUEUE */
 
 #ifdef CONFIG_SECURITY_NETWORK
