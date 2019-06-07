From: David Howells <dhowells@redhat.com>
Subject: [PATCH 03/13] security: Add hooks to rule on setting a watch [ver
 #4]
Date: Fri, 07 Jun 2019 15:17:48 +0100
Message-ID: <155991706847.15579.4702772917586301113.stgit@warthog.procyon.org.uk>
References: <155991702981.15579.6007568669839441045.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155991702981.15579.6007568669839441045.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, linux-security-module@vger.kernel.org, dhowells@redhat.com, raven@themaw.net, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, keyrings@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add security hooks that will allow an LSM to rule on whether or not a watch
may be set.  More than one hook is required as the watches watch different
types of object.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Casey Schaufler <casey@schaufler-ca.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>
cc: linux-security-module@vger.kernel.org
---

 include/linux/lsm_hooks.h |   38 ++++++++++++++++++++++++++++++++++++++
 include/linux/security.h  |   25 +++++++++++++++++++++++++
 security/security.c       |   23 +++++++++++++++++++++++
 3 files changed, 86 insertions(+)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 2474c3f785ca..0543449c0f6e 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1420,6 +1420,32 @@
  *	@ctx is a pointer in which to place the allocated security context.
  *	@ctxlen points to the place to put the length of @ctx.
  *
+ * Security hooks for the general notification queue:
+ *
+ * @watch_mount:
+ *	Check to see if a process is allowed to watch for mount topology change
+ *	notifications on a mount subtree.
+ *	@watch: The watch object
+ *	@path: The root of the subtree to watch.
+ *
+ * @watch_sb:
+ *	Check to see if a process is allowed to watch for event notifications
+ *	from a superblock.
+ *	@watch: The watch object
+ *	@sb: The superblock to watch.
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
@@ -1698,6 +1724,12 @@ union security_list_options {
 	int (*inode_notifysecctx)(struct inode *inode, void *ctx, u32 ctxlen);
 	int (*inode_setsecctx)(struct dentry *dentry, void *ctx, u32 ctxlen);
 	int (*inode_getsecctx)(struct inode *inode, void **ctx, u32 *ctxlen);
+#ifdef CONFIG_WATCH_QUEUE
+	int (*watch_mount)(struct watch *watch, struct path *path);
+	int (*watch_sb)(struct watch *watch, struct super_block *sb);
+	int (*watch_key)(struct watch *watch, struct key *key);
+	int (*watch_devices)(struct watch *watch);
+#endif /* CONFIG_WATCH_QUEUE */
 
 #ifdef CONFIG_SECURITY_NETWORK
 	int (*unix_stream_connect)(struct sock *sock, struct sock *other,
@@ -1977,6 +2009,12 @@ struct security_hook_heads {
 	struct hlist_head inode_notifysecctx;
 	struct hlist_head inode_setsecctx;
 	struct hlist_head inode_getsecctx;
+#ifdef CONFIG_WATCH_QUEUE
+	struct hlist_head watch_mount;
+	struct hlist_head watch_sb;
+	struct hlist_head watch_key;
+	struct hlist_head watch_devices;
+#endif /* CONFIG_WATCH_QUEUE */
 #ifdef CONFIG_SECURITY_NETWORK
 	struct hlist_head unix_stream_connect;
 	struct hlist_head unix_may_send;
diff --git a/include/linux/security.h b/include/linux/security.h
index 23c8b602c0ab..ac3bf6b5f87b 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -58,6 +58,7 @@ struct fs_context;
 struct fs_parameter;
 enum fs_value_type;
 struct fsinfo_kparams;
+struct watch;
 
 /* Default (no) options for the capable function */
 #define CAP_OPT_NONE 0x0
@@ -396,6 +397,12 @@ void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
 int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
 int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
+#ifdef CONFIG_WATCH_QUEUE
+int security_watch_mount(struct watch *watch, struct path *path);
+int security_watch_sb(struct watch *watch, struct super_block *sb);
+int security_watch_key(struct watch *watch, struct key *key);
+int security_watch_devices(struct watch *watch);
+#endif /* CONFIG_WATCH_QUEUE */
 #else /* CONFIG_SECURITY */
 
 static inline int call_lsm_notifier(enum lsm_event event, void *data)
@@ -1215,6 +1222,24 @@ static inline int security_inode_getsecctx(struct inode *inode, void **ctx, u32
 {
 	return -EOPNOTSUPP;
 }
+#ifdef CONFIG_WATCH_QUEUE
+static inline int security_watch_mount(struct watch *watch, struct path *path)
+{
+	return 0;
+}
+static inline int security_watch_sb(struct watch *watch, struct super_block *sb)
+{
+	return 0;
+}
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
index 3af886e8fced..ee2f8539a0d5 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1929,6 +1929,29 @@ int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
 }
 EXPORT_SYMBOL(security_inode_getsecctx);
 
+#ifdef CONFIG_WATCH_QUEUE
+int security_watch_mount(struct watch *watch, struct path *path)
+{
+	return call_int_hook(watch_mount, 0, watch, path);
+}
+
+int security_watch_sb(struct watch *watch, struct super_block *sb)
+{
+	return call_int_hook(watch_sb, 0, watch, sb);
+}
+
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
