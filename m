From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/6] security: Add hooks to rule on setting a superblock or
 mount watch [ver #5]
Date: Fri, 28 Jun 2019 16:50:23 +0100
Message-ID: <156173702349.15650.1484210092464492434.stgit@warthog.procyon.org.uk>
References: <156173701358.15650.8735203424342507015.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <156173701358.15650.8735203424342507015.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>dhowells@redhat.com, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add security hooks that will allow an LSM to rule on whether or not a watch
may be set on a mount or on a superblock.  More than one hook is required
as the watches watch different types of object.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Casey Schaufler <casey@schaufler-ca.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>
cc: linux-security-module@vger.kernel.org
---

 include/linux/lsm_hooks.h |   16 ++++++++++++++++
 include/linux/security.h  |   10 ++++++++++
 security/security.c       |   10 ++++++++++
 3 files changed, 36 insertions(+)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 5fe387d35990..3a4d7a260572 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1433,6 +1433,18 @@
  *	from devices (as a global set).
  *	@watch: The watch object
  *
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
  * @post_notification:
  *	Check to see if a watch notification can be posted to a particular
  *	queue.
@@ -1721,6 +1733,8 @@ union security_list_options {
 #ifdef CONFIG_WATCH_QUEUE
 	int (*watch_key)(struct watch *watch, struct key *key);
 	int (*watch_devices)(struct watch *watch);
+	int (*watch_mount)(struct watch *watch, struct path *path);
+	int (*watch_sb)(struct watch *watch, struct super_block *sb);
 	int (*post_notification)(const struct cred *w_cred,
 				 const struct cred *cred,
 				 struct watch_notification *n);
@@ -2007,6 +2021,8 @@ struct security_hook_heads {
 #ifdef CONFIG_WATCH_QUEUE
 	struct hlist_head watch_key;
 	struct hlist_head watch_devices;
+	struct hlist_head watch_mount;
+	struct hlist_head watch_sb;
 	struct hlist_head post_notification;
 #endif /* CONFIG_WATCH_QUEUE */
 #ifdef CONFIG_SECURITY_NETWORK
diff --git a/include/linux/security.h b/include/linux/security.h
index 8a9645472232..74ec6d41eca5 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -401,6 +401,8 @@ int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
 #ifdef CONFIG_WATCH_QUEUE
 int security_watch_key(struct watch *watch, struct key *key);
 int security_watch_devices(struct watch *watch);
+int security_watch_mount(struct watch *watch, struct path *path);
+int security_watch_sb(struct watch *watch, struct super_block *sb);
 int security_post_notification(const struct cred *w_cred,
 			       const struct cred *cred,
 			       struct watch_notification *n);
@@ -1233,6 +1235,14 @@ static inline int security_watch_devices(struct watch *watch)
 {
 	return 0;
 }
+static inline int security_watch_mount(struct watch *watch, struct path *path)
+{
+	return 0;
+}
+static inline int security_watch_sb(struct watch *watch, struct super_block *sb)
+{
+	return 0;
+}
 static inline int security_post_notification(const struct cred *w_cred,
 					     const struct cred *cred,
 					     struct watch_notification *n)
diff --git a/security/security.c b/security/security.c
index 1390fb1203e4..37fec6cec905 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1940,6 +1940,16 @@ int security_watch_devices(struct watch *watch)
 	return call_int_hook(watch_devices, 0, watch);
 }
 
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
 int security_post_notification(const struct cred *w_cred,
 			       const struct cred *cred,
 			       struct watch_notification *n)
