From: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V4 7/8] audit: log creation and deletion of namespace instances
Date: Wed, 20 Aug 2014 21:09:40 -0400
Message-ID: <42339b6805dade06de519d871ef81f1c6ce2cb8b.1408581429.git.rgb@redhat.com>
References: <cover.1408581429.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <cover.1408581429.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1408581429.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1408581429.git.rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Log the creation and deletion of namespace instances in all 6 types of
namespaces.

Twelve new audit message types have been introduced:
AUDIT_NS_INIT_MNT       1330    /* Record mount namespace instance creation */
AUDIT_NS_INIT_UTS       1331    /* Record UTS namespace instance creation */
AUDIT_NS_INIT_IPC       1332    /* Record IPC namespace instance creation */
AUDIT_NS_INIT_USER      1333    /* Record USER namespace instance creation */
AUDIT_NS_INIT_PID       1334    /* Record PID namespace instance creation */
AUDIT_NS_INIT_NET       1335    /* Record NET namespace instance creation */
AUDIT_NS_DEL_MNT        1336    /* Record mount namespace instance deletion */
AUDIT_NS_DEL_UTS        1337    /* Record UTS namespace instance deletion */
AUDIT_NS_DEL_IPC        1338    /* Record IPC namespace instance deletion */
AUDIT_NS_DEL_USER       1339    /* Record USER namespace instance deletion */
AUDIT_NS_DEL_PID        1340    /* Record PID namespace instance deletion */
AUDIT_NS_DEL_NET        1341    /* Record NET namespace instance deletion */

As suggested by Eric Paris, there are 12 message types, one for each of
creation and deletion, one for each type of namespace so that text searches are
easier in conjunction with the AUDIT_NS_INFO message type, being able to search
for all records such as "netns=7 " and to avoid fields disappearing per message
type to make ausearch more efficient.

A typical startup would look roughly like:

	type=AUDIT_NS_INIT_UTS msg=audit(1408577534.868:5): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel old_utsns=0 utsns=2 res=1
	type=AUDIT_NS_INIT_USER msg=audit(1408577534.868:6): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel old_userns=0 userns=3 res=1
	type=AUDIT_NS_INIT_PID msg=audit(1408577534.868:7): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel old_pidns=0 pidns=4 res=1
	type=AUDIT_NS_INIT_MNT msg=audit(1408577534.868:8): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel old_mntns=0 mntns=5 res=1
	type=AUDIT_NS_INIT_IPC msg=audit(1408577534.868:9): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel old_ipcns=0 ipcns=1 res=1
	type=AUDIT_NS_INIT_NET msg=audit(1408577533.500:10): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=kernel old_netns=0 netns=7 res=1

And a CLONE action would result in:
	type=type=AUDIT_NS_INIT_NET msg=audit(1408577535.306:81): pid=481 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 old_netns=7 netns=8 res=1
	type=type=AUDIT_NS_INIT_MNT msg=audit(1408577535.307:83): pid=481 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 old_mntns=5 mntns=9 res=1

While deleting a namespace would result in:
	type=type=AUDIT_NS_DEL_MNT msg=audit(1408577552.221:85): pid=481 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 mntns=9 res=1

If non-zero, old_snum lists the namespace from which it was cloned.

Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/namespace.c             |   12 +++++++++++
 include/linux/audit.h      |    8 +++++++
 include/uapi/linux/audit.h |   12 +++++++++++
 ipc/namespace.c            |   10 +++++++++
 kernel/audit.c             |   47 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/pid_namespace.c     |   10 +++++++++
 kernel/user_namespace.c    |   11 ++++++++++
 kernel/utsname.c           |   11 ++++++++++
 net/core/net_namespace.c   |   12 +++++++++++
 9 files changed, 133 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index f433f21..cb05b3d 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -24,6 +24,7 @@
 #include <linux/proc_ns.h>
 #include <linux/magic.h>
 #include <linux/bootmem.h>
+#include <linux/audit.h>
 #include "pnode.h"
 #include "internal.h"
 
@@ -2459,6 +2460,7 @@ dput_out:
 
 static void free_mnt_ns(struct mnt_namespace *ns)
 {
+	audit_log_ns_del(AUDIT_NS_DEL_MNT, ns->serial_num);
 	proc_free_inum(ns->proc_inum);
 	put_user_ns(ns->user_ns);
 	kfree(ns);
@@ -2519,6 +2521,7 @@ struct mnt_namespace *copy_mnt_ns(unsigned long flags, struct mnt_namespace *ns,
 	new_ns = alloc_mnt_ns(user_ns);
 	if (IS_ERR(new_ns))
 		return new_ns;
+	audit_log_ns_init(AUDIT_NS_INIT_MNT, ns->serial_num, new_ns->serial_num);
 
 	namespace_lock();
 	/* First pass: copy the tree topology */
@@ -2831,6 +2834,15 @@ static void __init init_mount_tree(void)
 	set_fs_root(current->fs, &root);
 }
 
+/* log the serial number of init mnt namespace after audit service starts */
+static int __init mnt_ns_init_log(void)
+{
+	struct mnt_namespace *init_mnt_ns = init_task.nsproxy->mnt_ns;
+	audit_log_ns_init(AUDIT_NS_INIT_MNT, 0, init_mnt_ns->serial_num);
+	return 0;
+}
+late_initcall(mnt_ns_init_log);
+
 void __init mnt_init(void)
 {
 	unsigned u;
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 5ea3609..c245837 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -466,6 +466,9 @@ extern void		    audit_log_key(struct audit_buffer *ab,
 					  char *key);
 extern void		    audit_log_link_denied(const char *operation,
 						  struct path *link);
+extern int		    audit_log_ns_init(int type, long long old_snum,
+					      long long snum);
+extern int		    audit_log_ns_del(int type, long long snum);
 extern void		    audit_log_lost(const char *message);
 #ifdef CONFIG_SECURITY
 extern void 		    audit_log_secctx(struct audit_buffer *ab, u32 secid);
@@ -524,6 +527,11 @@ static inline void audit_log_key(struct audit_buffer *ab, char *key)
 static inline void audit_log_link_denied(const char *string,
 					 const struct path *link)
 { }
+static inline int audit_log_ns_init(int type, long long old_snum,
+				    long long snum)
+{ }
+static inline int audit_log_ns_del(int type, long long snum)
+{ }
 static inline void audit_log_secctx(struct audit_buffer *ab, u32 secid)
 { }
 static inline int audit_log_task_context(struct audit_buffer *ab)
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 84bbcdb..fd13a02 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -111,6 +111,18 @@
 #define AUDIT_PROCTITLE		1327	/* Proctitle emit event */
 #define AUDIT_FEATURE_CHANGE	1328	/* audit log listing feature changes */
 #define AUDIT_NS_INFO		1329	/* Record process namespace IDs */
+#define AUDIT_NS_INIT_MNT	1330	/* Record mount namespace instance creation */
+#define AUDIT_NS_INIT_UTS	1331	/* Record UTS namespace instance creation */
+#define AUDIT_NS_INIT_IPC	1332	/* Record IPC namespace instance creation */
+#define AUDIT_NS_INIT_USER	1333	/* Record USER namespace instance creation */
+#define AUDIT_NS_INIT_PID	1334	/* Record PID namespace instance creation */
+#define AUDIT_NS_INIT_NET	1335	/* Record NET namespace instance creation */
+#define AUDIT_NS_DEL_MNT	1336	/* Record mount namespace instance deletion */
+#define AUDIT_NS_DEL_UTS	1337	/* Record UTS namespace instance deletion */
+#define AUDIT_NS_DEL_IPC	1338	/* Record IPC namespace instance deletion */
+#define AUDIT_NS_DEL_USER	1339	/* Record USER namespace instance deletion */
+#define AUDIT_NS_DEL_PID	1340	/* Record PID namespace instance deletion */
+#define AUDIT_NS_DEL_NET	1341	/* Record NET namespace instance deletion */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
diff --git a/ipc/namespace.c b/ipc/namespace.c
index 36ce7ff..538c4b9 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -13,6 +13,7 @@
 #include <linux/mount.h>
 #include <linux/user_namespace.h>
 #include <linux/proc_ns.h>
+#include <linux/audit.h>
 
 #include "util.h"
 
@@ -42,6 +43,7 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
 	atomic_inc(&nr_ipc_ns);
 
 	ns->serial_num = ns_serial();
+	audit_log_ns_init(AUDIT_NS_INIT_IPC, old_ns->serial_num, ns->serial_num);
 
 	sem_init_ns(ns);
 	msg_init_ns(ns);
@@ -121,6 +123,7 @@ static void free_ipc_ns(struct ipc_namespace *ns)
 	 */
 	ipcns_notify(IPCNS_REMOVED);
 	put_user_ns(ns->user_ns);
+	audit_log_ns_del(AUDIT_NS_DEL_IPC, ns->serial_num);
 	proc_free_inum(ns->proc_inum);
 	kfree(ns);
 }
@@ -207,3 +210,10 @@ const struct proc_ns_operations ipcns_operations = {
 	.inum		= ipcns_inum,
 	.snum		= ipcns_snum,
 };
+
+static int __init ipc_namespaces_init(void)
+{
+	return audit_log_ns_init(AUDIT_NS_INIT_IPC, 0, init_ipc_ns.serial_num);
+}
+
+late_initcall(ipc_namespaces_init);
diff --git a/kernel/audit.c b/kernel/audit.c
index a4c39a0..6d95d1c 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1970,6 +1970,53 @@ out:
 	kfree(name);
 }
 
+static char* ns_name[] = {
+	"mnt",
+	"uts",
+	"ipc",
+	"user",
+	"pid",
+	"net",
+};
+
+/**
+ * audit_log_ns_init - report a namespace instance creation
+ * @type: type of audit namespace instance created message
+ * @old_snum: the serial number of the cloned namespace instance
+ * @snum: the serial number of the new namespace instance
+ */
+int audit_log_ns_init(int type, long long old_snum, long long snum)
+{
+	struct audit_buffer *ab;
+	char* audit_ns_name = ns_name[type - AUDIT_NS_INIT_MNT];
+
+	if (type < AUDIT_NS_INIT_MNT || type > AUDIT_NS_INIT_NET)
+		return 0;
+	audit_log_common_recv_msg(&ab, type);
+	audit_log_format(ab, " old_%sns=%llx %sns=%llx res=1",
+			 audit_ns_name, old_snum, audit_ns_name, snum);
+	audit_log_end(ab);
+	return 0;
+}
+
+/**
+ * audit_log_ns_del - report a namespace instance deleted
+ * @type: type of audit namespace instance deleted message
+ * @snum: the serial number of the namespace instance
+ */
+int audit_log_ns_del(int type, long long snum)
+{
+	struct audit_buffer *ab;
+	char* audit_ns_name = ns_name[type - AUDIT_NS_DEL_MNT];
+
+	if (type < AUDIT_NS_DEL_MNT || type > AUDIT_NS_DEL_NET)
+		return 0;
+	audit_log_common_recv_msg(&ab, type);
+	audit_log_format(ab, " %ssn=%llx res=1", audit_ns_name, snum);
+	audit_log_end(ab);
+	return 0;
+}
+
 /**
  * audit_log_end - end one audit record
  * @ab: the audit_buffer
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 059b330..7da351a 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -18,6 +18,7 @@
 #include <linux/proc_ns.h>
 #include <linux/reboot.h>
 #include <linux/export.h>
+#include <linux/audit.h>
 
 struct pid_cache {
 	int nr_ids;
@@ -110,6 +111,8 @@ static struct pid_namespace *create_pid_namespace(struct user_namespace *user_ns
 		goto out_free_map;
 
 	ns->serial_num = ns_serial();
+	audit_log_ns_init(AUDIT_NS_INIT_PID, parent_pid_ns->serial_num,
+			  ns->serial_num);
 
 	kref_init(&ns->kref);
 	ns->level = level;
@@ -144,6 +147,7 @@ static void destroy_pid_namespace(struct pid_namespace *ns)
 {
 	int i;
 
+	audit_log_ns_del(AUDIT_NS_DEL_PID, ns->serial_num);
 	proc_free_inum(ns->proc_inum);
 	for (i = 0; i < PIDMAP_ENTRIES; i++)
 		kfree(ns->pidmap[i].page);
@@ -397,3 +401,9 @@ static __init int pid_namespaces_init(void)
 }
 
 __initcall(pid_namespaces_init);
+
+static __init int pid_namespaces_late_init(void)
+{
+	return audit_log_ns_init(AUDIT_NS_INIT_PID, 0, init_pid_ns.serial_num);
+}
+late_initcall(pid_namespaces_late_init);
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 3f04df5..24497a0 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -22,6 +22,7 @@
 #include <linux/ctype.h>
 #include <linux/projid.h>
 #include <linux/fs_struct.h>
+#include <linux/audit.h>
 
 static struct kmem_cache *user_ns_cachep __read_mostly;
 
@@ -93,6 +94,8 @@ int create_user_ns(struct cred *new)
 	}
 
 	ns->serial_num = ns_serial();
+	audit_log_ns_init(AUDIT_NS_INIT_USER, parent_ns->serial_num,
+			  ns->serial_num);
 
 	atomic_set(&ns->count, 1);
 	/* Leave the new->user_ns reference with the new user namespace. */
@@ -138,6 +141,7 @@ void free_user_ns(struct user_namespace *ns)
 #ifdef CONFIG_PERSISTENT_KEYRINGS
 		key_put(ns->persistent_keyring_register);
 #endif
+		audit_log_ns_del(AUDIT_NS_DEL_USER, ns->serial_num);
 		proc_free_inum(ns->proc_inum);
 		kmem_cache_free(user_ns_cachep, ns);
 		ns = parent;
@@ -918,3 +922,10 @@ static __init int user_namespaces_init(void)
 	return 0;
 }
 subsys_initcall(user_namespaces_init);
+
+static __init int user_namespaces_late_init(void)
+{
+	return audit_log_ns_init(AUDIT_NS_INIT_USER, 0,
+				 init_user_ns.serial_num);
+}
+late_initcall(user_namespaces_late_init);
diff --git a/kernel/utsname.c b/kernel/utsname.c
index ffeac1b..05ecc2d 100644
--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/user_namespace.h>
 #include <linux/proc_ns.h>
+#include <linux/audit.h>
 
 static struct uts_namespace *create_uts_ns(void)
 {
@@ -49,6 +50,7 @@ static struct uts_namespace *clone_uts_ns(struct user_namespace *user_ns,
 	}
 
 	ns->serial_num = ns_serial();
+	audit_log_ns_init(AUDIT_NS_INIT_UTS, old_ns->serial_num, ns->serial_num);
 
 	down_read(&uts_sem);
 	memcpy(&ns->name, &old_ns->name, sizeof(ns->name));
@@ -86,6 +88,7 @@ void free_uts_ns(struct kref *kref)
 
 	ns = container_of(kref, struct uts_namespace, kref);
 	put_user_ns(ns->user_ns);
+	audit_log_ns_del(AUDIT_NS_DEL_UTS, ns->serial_num);
 	proc_free_inum(ns->proc_inum);
 	kfree(ns);
 }
@@ -148,3 +151,11 @@ const struct proc_ns_operations utsns_operations = {
 	.inum		= utsns_inum,
 	.snum		= utsns_snum,
 };
+
+static int __init uts_namespaces_init(void)
+{
+	return audit_log_ns_init(AUDIT_NS_INIT_UTS, 0,
+				 init_uts_ns.serial_num);
+}
+
+late_initcall(uts_namespaces_init);
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index c402eea..295ecc3 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -17,6 +17,7 @@
 #include <linux/user_namespace.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
+#include <linux/audit.h>
 
 /*
  *	Our network namespace constructor/destructor lists
@@ -253,6 +254,8 @@ struct net *copy_net_ns(unsigned long flags,
 	mutex_lock(&net_mutex);
 	rv = setup_net(net, user_ns);
 	if (rv == 0) {
+		audit_log_ns_init(AUDIT_NS_INIT_NET, old_net->serial_num,
+				  net->serial_num);
 		rtnl_lock();
 		list_add_tail_rcu(&net->list, &net_namespace_list);
 		rtnl_unlock();
@@ -395,6 +398,7 @@ static __net_init int net_ns_net_init(struct net *net)
 
 static __net_exit void net_ns_net_exit(struct net *net)
 {
+	audit_log_ns_del(AUDIT_NS_DEL_NET, net->serial_num);
 	proc_free_inum(net->proc_inum);
 }
 
@@ -441,6 +445,14 @@ static int __init net_ns_init(void)
 
 pure_initcall(net_ns_init);
 
+/* log the serial number of init_net namespace after audit service starts */
+static int __init net_ns_init_log(void)
+{
+	audit_log_ns_init(AUDIT_NS_INIT_NET, 0, init_net.serial_num);
+	return 0;
+}
+late_initcall(net_ns_init_log);
+
 #ifdef CONFIG_NET_NS
 static int __register_pernet_operations(struct list_head *list,
 					struct pernet_operations *ops)
-- 
1.7.1
