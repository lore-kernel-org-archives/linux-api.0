From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/11] security: Add hooks to rule on setting a watch [ver
 #7]
Date: Fri, 30 Aug 2019 14:57:30 +0100
Message-ID: <156717345053.2204.2379669144728869813.stgit@warthog.procyon.org.uk>
References: <156717343223.2204.15875738850129174524.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <156717343223.2204.15875738850129174524.stgit@warthog.procyon.org.uk>
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

 include/linux/lsm_hooks.h |   24 ++++++++++++++++++++++++
 include/linux/security.h  |   17 +++++++++++++++++
 security/security.c       |   14 ++++++++++++++
 3 files changed, 55 insertions(+)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index df1318d85f7d..b0cdefcda4e6 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1413,6 +1413,18 @@
  *	@ctx is a pointer in which to place the allocated security context.
  *	@ctxlen points to the place to put the length of @ctx.
  *
+ * Security hooks for the general notification queue:
+ *
+ * @watch_key:
+ *	Check to see if a process is allowed to watch for event notifications
+ *	from a key or keyring.
+ *	@key: The key to watch.
+ *
+ * @watch_devices:
+ *	Check to see if a process is allowed to watch for event notifications
+ *	from devices (as a global set).
+ *
+ *
  * Security hooks for using the eBPF maps and programs functionalities through
  * eBPF syscalls.
  *
@@ -1688,6 +1700,12 @@ union security_list_options {
 	int (*inode_notifysecctx)(struct inode *inode, void *ctx, u32 ctxlen);
 	int (*inode_setsecctx)(struct dentry *dentry, void *ctx, u32 ctxlen);
 	int (*inode_getsecctx)(struct inode *inode, void **ctx, u32 *ctxlen);
+#ifdef CONFIG_KEY_NOTIFICATIONS
+	int (*watch_key)(struct key *key);
+#endif
+#ifdef CONFIG_DEVICE_NOTIFICATIONS
+	int (*watch_devices)(void);
+#endif
 
 #ifdef CONFIG_SECURITY_NETWORK
 	int (*unix_stream_connect)(struct sock *sock, struct sock *other,
@@ -1964,6 +1982,12 @@ struct security_hook_heads {
 	struct hlist_head inode_notifysecctx;
 	struct hlist_head inode_setsecctx;
 	struct hlist_head inode_getsecctx;
+#ifdef CONFIG_KEY_NOTIFICATIONS
+	struct hlist_head watch_key;
+#endif
+#ifdef CONFIG_DEVICE_NOTIFICATIONS
+	struct hlist_head watch_devices;
+#endif
 #ifdef CONFIG_SECURITY_NETWORK
 	struct hlist_head unix_stream_connect;
 	struct hlist_head unix_may_send;
diff --git a/include/linux/security.h b/include/linux/security.h
index 5f7441abbf42..3be44354d308 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1206,6 +1206,23 @@ static inline int security_inode_getsecctx(struct inode *inode, void **ctx, u32
 }
 #endif	/* CONFIG_SECURITY */
 
+#if defined(CONFIG_SECURITY) && defined(CONFIG_KEY_NOTIFICATIONS)
+int security_watch_key(struct key *key);
+#else
+static inline int security_watch_key(struct key *key)
+{
+	return 0;
+}
+#endif
+#if defined(CONFIG_SECURITY) && defined(CONFIG_DEVICE_NOTIFICATIONS)
+int security_watch_devices(void);
+#else
+static inline int security_watch_devices(void)
+{
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_SECURITY_NETWORK
 
 int security_unix_stream_connect(struct sock *sock, struct sock *other, struct sock *newsk);
diff --git a/security/security.c b/security/security.c
index 250ee2d76406..007eb48bc848 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1916,6 +1916,20 @@ int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
 }
 EXPORT_SYMBOL(security_inode_getsecctx);
 
+#ifdef CONFIG_KEY_NOTIFICATIONS
+int security_watch_key(struct key *key)
+{
+	return call_int_hook(watch_key, 0, key);
+}
+#endif
+
+#ifdef CONFIG_DEVICE_NOTIFICATIONS
+int security_watch_devices(void)
+{
+	return call_int_hook(watch_devices, 0);
+}
+#endif
+
 #ifdef CONFIG_SECURITY_NETWORK
 
 int security_unix_stream_connect(struct sock *sock, struct sock *other, struct sock *newsk)
