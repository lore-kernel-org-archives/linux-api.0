From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/11] security: Add hooks to rule on setting a watch [ver
 #6]
Date: Thu, 29 Aug 2019 19:30:07 +0100
Message-ID: <156710340735.10009.5077888091140004991.stgit@warthog.procyon.org.uk>
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

Add security hooks that will allow an LSM to rule on whether or not a watch
may be set.  More than one hook is required as the watches watch different
types of object.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Casey Schaufler <casey@schaufler-ca.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>
cc: linux-security-module@vger.kernel.org
---

 include/linux/lsm_hooks.h |   22 ++++++++++++++++++++++
 include/linux/security.h  |   15 +++++++++++++++
 security/security.c       |   13 +++++++++++++
 3 files changed, 50 insertions(+)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index df1318d85f7d..19108185b254 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1413,6 +1413,20 @@
  *	@ctx is a pointer in which to place the allocated security context.
  *	@ctxlen points to the place to put the length of @ctx.
  *
+ * Security hooks for the general notification queue:
+ *
+ * @watch_key:
+ *	Check to see if a process is allowed to watch for event notifications
+ *	from a key or keyring.
+ *	@watch: The watch object
+ *	@key: The key to watch.
+ *
+ * @watch_devices:
+ *	Check to see if a process is allowed to watch for event notifications
+ *	from devices (as a global set).
+ *	@watch: The watch object
+ *
+ *
  * Security hooks for using the eBPF maps and programs functionalities through
  * eBPF syscalls.
  *
@@ -1688,6 +1702,10 @@ union security_list_options {
 	int (*inode_notifysecctx)(struct inode *inode, void *ctx, u32 ctxlen);
 	int (*inode_setsecctx)(struct dentry *dentry, void *ctx, u32 ctxlen);
 	int (*inode_getsecctx)(struct inode *inode, void **ctx, u32 *ctxlen);
+#ifdef CONFIG_WATCH_QUEUE
+	int (*watch_key)(struct watch *watch, struct key *key);
+	int (*watch_devices)(struct watch *watch);
+#endif /* CONFIG_WATCH_QUEUE */
 
 #ifdef CONFIG_SECURITY_NETWORK
 	int (*unix_stream_connect)(struct sock *sock, struct sock *other,
@@ -1964,6 +1982,10 @@ struct security_hook_heads {
 	struct hlist_head inode_notifysecctx;
 	struct hlist_head inode_setsecctx;
 	struct hlist_head inode_getsecctx;
+#ifdef CONFIG_WATCH_QUEUE
+	struct hlist_head watch_key;
+	struct hlist_head watch_devices;
+#endif /* CONFIG_WATCH_QUEUE */
 #ifdef CONFIG_SECURITY_NETWORK
 	struct hlist_head unix_stream_connect;
 	struct hlist_head unix_may_send;
diff --git a/include/linux/security.h b/include/linux/security.h
index 5f7441abbf42..feeade454308 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -57,6 +57,7 @@ struct mm_struct;
 struct fs_context;
 struct fs_parameter;
 enum fs_value_type;
+struct watch;
 
 /* Default (no) options for the capable function */
 #define CAP_OPT_NONE 0x0
@@ -392,6 +393,10 @@ void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
 int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
 int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
+#ifdef CONFIG_WATCH_QUEUE
+int security_watch_key(struct watch *watch, struct key *key);
+int security_watch_devices(struct watch *watch);
+#endif /* CONFIG_WATCH_QUEUE */
 #else /* CONFIG_SECURITY */
 
 static inline int call_blocking_lsm_notifier(enum lsm_event event, void *data)
@@ -1204,6 +1209,16 @@ static inline int security_inode_getsecctx(struct inode *inode, void **ctx, u32
 {
 	return -EOPNOTSUPP;
 }
+#ifdef CONFIG_WATCH_QUEUE
+static inline int security_watch_key(struct watch *watch, struct key *key)
+{
+	return 0;
+}
+static inline int security_watch_devices(struct watch *watch)
+{
+	return 0;
+}
+#endif /* CONFIG_WATCH_QUEUE */
 #endif	/* CONFIG_SECURITY */
 
 #ifdef CONFIG_SECURITY_NETWORK
diff --git a/security/security.c b/security/security.c
index 250ee2d76406..1ebd2c936a57 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1916,6 +1916,19 @@ int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
 }
 EXPORT_SYMBOL(security_inode_getsecctx);
 
+#ifdef CONFIG_WATCH_QUEUE
+int security_watch_key(struct watch *watch, struct key *key)
+{
+	return call_int_hook(watch_key, 0, watch, key);
+}
+
+int security_watch_devices(struct watch *watch)
+{
+	return call_int_hook(watch_devices, 0, watch);
+}
+
+#endif /* CONFIG_WATCH_QUEUE */
+
 #ifdef CONFIG_SECURITY_NETWORK
 
 int security_unix_stream_connect(struct sock *sock, struct sock *other, struct sock *newsk)
