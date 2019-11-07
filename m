From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 02/14] security: Add hooks to rule on setting a watch
 [ver #2]
Date: Thu, 07 Nov 2019 13:35:38 +0000
Message-ID: <157313373855.29677.3888607349866181437.stgit@warthog.procyon.org.uk>
References: <157313371694.29677.15388731274912671071.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157313371694.29677.15388731274912671071.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>dhowells@redhat.com, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
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
index a3763247547c..d62e92b768c4 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1416,6 +1416,18 @@
  *=09@ctx is a pointer in which to place the allocated security context.
  *=09@ctxlen points to the place to put the length of @ctx.
  *
+ * Security hooks for the general notification queue:
+ *
+ * @watch_key:
+ *=09Check to see if a process is allowed to watch for event notifications
+ *=09from a key or keyring.
+ *=09@key: The key to watch.
+ *
+ * @watch_devices:
+ *=09Check to see if a process is allowed to watch for event notifications
+ *=09from devices (as a global set).
+ *
+ *
  * Security hooks for using the eBPF maps and programs functionalities thr=
ough
  * eBPF syscalls.
  *
@@ -1698,6 +1710,12 @@ union security_list_options {
 =09int (*inode_notifysecctx)(struct inode *inode, void *ctx, u32 ctxlen);
 =09int (*inode_setsecctx)(struct dentry *dentry, void *ctx, u32 ctxlen);
 =09int (*inode_getsecctx)(struct inode *inode, void **ctx, u32 *ctxlen);
+#ifdef CONFIG_KEY_NOTIFICATIONS
+=09int (*watch_key)(struct key *key);
+#endif
+#ifdef CONFIG_DEVICE_NOTIFICATIONS
+=09int (*watch_devices)(void);
+#endif
=20
 #ifdef CONFIG_SECURITY_NETWORK
 =09int (*unix_stream_connect)(struct sock *sock, struct sock *other,
@@ -1977,6 +1995,12 @@ struct security_hook_heads {
 =09struct hlist_head inode_notifysecctx;
 =09struct hlist_head inode_setsecctx;
 =09struct hlist_head inode_getsecctx;
+#ifdef CONFIG_KEY_NOTIFICATIONS
+=09struct hlist_head watch_key;
+#endif
+#ifdef CONFIG_DEVICE_NOTIFICATIONS
+=09struct hlist_head watch_devices;
+#endif
 #ifdef CONFIG_SECURITY_NETWORK
 =09struct hlist_head unix_stream_connect;
 =09struct hlist_head unix_may_send;
diff --git a/include/linux/security.h b/include/linux/security.h
index a8d59d612d27..5d1867772022 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1271,6 +1271,23 @@ static inline int security_locked_down(enum lockdown=
_reason what)
 }
 #endif=09/* CONFIG_SECURITY */
=20
+#if defined(CONFIG_SECURITY) && defined(CONFIG_KEY_NOTIFICATIONS)
+int security_watch_key(struct key *key);
+#else
+static inline int security_watch_key(struct key *key)
+{
+=09return 0;
+}
+#endif
+#if defined(CONFIG_SECURITY) && defined(CONFIG_DEVICE_NOTIFICATIONS)
+int security_watch_devices(void);
+#else
+static inline int security_watch_devices(void)
+{
+=09return 0;
+}
+#endif
+
 #ifdef CONFIG_SECURITY_NETWORK
=20
 int security_unix_stream_connect(struct sock *sock, struct sock *other, st=
ruct sock *newsk);
diff --git a/security/security.c b/security/security.c
index 1bc000f834e2..4f970716fa6c 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1956,6 +1956,20 @@ int security_inode_getsecctx(struct inode *inode, vo=
id **ctx, u32 *ctxlen)
 }
 EXPORT_SYMBOL(security_inode_getsecctx);
=20
+#ifdef CONFIG_KEY_NOTIFICATIONS
+int security_watch_key(struct key *key)
+{
+=09return call_int_hook(watch_key, 0, key);
+}
+#endif
+
+#ifdef CONFIG_DEVICE_NOTIFICATIONS
+int security_watch_devices(void)
+{
+=09return call_int_hook(watch_devices, 0);
+}
+#endif
+
 #ifdef CONFIG_SECURITY_NETWORK
=20
 int security_unix_stream_connect(struct sock *sock, struct sock *other, st=
ruct sock *newsk)
