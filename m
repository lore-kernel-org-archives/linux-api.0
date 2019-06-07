From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/13] security: Add a hook for the point of notification
 insertion [ver #4]
Date: Fri, 07 Jun 2019 15:17:59 +0100
Message-ID: <155991707918.15579.12255928917117357405.stgit@warthog.procyon.org.uk>
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

Add a security hook that allows an LSM to rule on whether a notification
message is allowed to be inserted into a particular watch queue.

The hook is given the following information:

 (1) The credentials of the triggerer (which may be init_cred for a system
     notification, eg. a hardware error).

 (2) The credentials of the creator of the watch buffer.

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
index 0543449c0f6e..94fb6067fed5 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1445,6 +1445,12 @@
  *	from devices (as a global set).
  *	@watch: The watch object
  *
+ * @post_notification:
+ *	Check to see if a watch notification can be posted to a particular
+ *	queue.
+ *	@q_cred: The credentials of the target watch queue.
+ *	@cred: The event-triggerer's credentials
+ *	@n: The notification being posted
  *
  * Security hooks for using the eBPF maps and programs functionalities through
  * eBPF syscalls.
@@ -1729,6 +1735,9 @@ union security_list_options {
 	int (*watch_sb)(struct watch *watch, struct super_block *sb);
 	int (*watch_key)(struct watch *watch, struct key *key);
 	int (*watch_devices)(struct watch *watch);
+	int (*post_notification)(const struct cred *q_cred,
+				 const struct cred *cred,
+				 struct watch_notification *n);
 #endif /* CONFIG_WATCH_QUEUE */
 
 #ifdef CONFIG_SECURITY_NETWORK
@@ -2014,6 +2023,7 @@ struct security_hook_heads {
 	struct hlist_head watch_sb;
 	struct hlist_head watch_key;
 	struct hlist_head watch_devices;
+	struct hlist_head post_notification;
 #endif /* CONFIG_WATCH_QUEUE */
 #ifdef CONFIG_SECURITY_NETWORK
 	struct hlist_head unix_stream_connect;
diff --git a/include/linux/security.h b/include/linux/security.h
index ac3bf6b5f87b..ed301edeaa19 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -59,6 +59,7 @@ struct fs_parameter;
 enum fs_value_type;
 struct fsinfo_kparams;
 struct watch;
+struct watch_notification;
 
 /* Default (no) options for the capable function */
 #define CAP_OPT_NONE 0x0
@@ -402,6 +403,9 @@ int security_watch_mount(struct watch *watch, struct path *path);
 int security_watch_sb(struct watch *watch, struct super_block *sb);
 int security_watch_key(struct watch *watch, struct key *key);
 int security_watch_devices(struct watch *watch);
+int security_post_notification(const struct cred *q_cred,
+			       const struct cred *cred,
+			       struct watch_notification *n);
 #endif /* CONFIG_WATCH_QUEUE */
 #else /* CONFIG_SECURITY */
 
@@ -1239,6 +1243,12 @@ static inline int security_watch_devices(struct watch *watch)
 {
 	return 0;
 }
+static inline int security_post_notification(const struct cred *q_cred,
+					     const struct cred *cred,
+					     struct watch_notification *n)
+{
+	return 0;
+}
 #endif /* CONFIG_WATCH_QUEUE */
 #endif	/* CONFIG_SECURITY */
 
diff --git a/security/security.c b/security/security.c
index ee2f8539a0d5..8a04ac74b4fe 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1950,6 +1950,12 @@ int security_watch_devices(struct watch *watch)
 	return call_int_hook(watch_devices, 0, watch);
 }
 
+int security_post_notification(const struct cred *q_cred,
+			       const struct cred *cred,
+			       struct watch_notification *n)
+{
+	return call_int_hook(post_notification, 0, q_cred, cred, n);
+}
 #endif /* CONFIG_WATCH_QUEUE */
 
 #ifdef CONFIG_SECURITY_NETWORK
