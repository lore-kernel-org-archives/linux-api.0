From: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 5/5] kdbus: make use of new lsm hooks
Date: Fri, 31 Oct 2014 17:36:37 +0100
Message-ID: <1414773397-26490-6-git-send-email-k.lewandowsk@samsung.com>
References: <54539AF3.6060302@samsung.com>
 <1414773397-26490-1-git-send-email-k.lewandowsk@samsung.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1414773397-26490-1-git-send-email-k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org
Cc: pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, inux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, casey.schaufler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lmctlx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, r.krypa-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

DANGEROUS:  This version has been compile-tested only!

Signed-off-by: Karol Lewandowski <k.lewandowsk-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
---
 drivers/misc/kdbus/bus.c        | 10 +++++++++-
 drivers/misc/kdbus/connection.c | 34 +++++++++++++++++++++++++++++++++-
 drivers/misc/kdbus/domain.c     |  7 +++++++
 drivers/misc/kdbus/endpoint.c   | 11 +++++++++++
 drivers/misc/kdbus/names.c      |  9 +++++++++
 5 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/kdbus/bus.c b/drivers/misc/kdbus/bus.c
index 6dcaf22..f9bb177 100644
--- a/drivers/misc/kdbus/bus.c
+++ b/drivers/misc/kdbus/bus.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/sched.h>
+#include <linux/security.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
@@ -97,6 +98,7 @@ static void __kdbus_bus_free(struct kref *kref)
 	kdbus_domain_unref(bus->domain);
 	kdbus_policy_db_clear(&bus->policy_db);
 	kdbus_meta_free(bus->meta);
+	security_kdbus_bus_free(bus);
 	kfree(bus->name);
 	kfree(bus);
 }
@@ -351,9 +353,13 @@ int kdbus_bus_new(struct kdbus_domain *domain,
 	if (ret < 0)
 		goto exit_free_name;
 
+	ret = security_kdbus_bus_alloc(b);
+	if (ret)
+		goto exit_free_reg;
+
 	ret = kdbus_ep_new(b, "bus", mode, uid, gid, false, &b->ep);
 	if (ret < 0)
-		goto exit_free_reg;
+		goto exit_free_security;
 
 	/* link into domain */
 	mutex_lock(&domain->lock);
@@ -386,6 +392,8 @@ exit_unref_user_unlock:
 	kdbus_domain_user_unref(b->user);
 	kdbus_ep_disconnect(b->ep);
 	kdbus_ep_unref(b->ep);
+exit_free_security:
+	security_kdbus_bus_free(b);
 exit_free_reg:
 	kdbus_name_registry_free(b->name_registry);
 exit_free_name:
diff --git a/drivers/misc/kdbus/connection.c b/drivers/misc/kdbus/connection.c
index 5b1f3ed..96c5c52 100644
--- a/drivers/misc/kdbus/connection.c
+++ b/drivers/misc/kdbus/connection.c
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <linux/shmem_fs.h>
 #include <linux/sizes.h>
+#include <linux/security.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 
@@ -282,6 +283,10 @@ int kdbus_cmd_msg_recv(struct kdbus_conn *conn,
 	if (recv->offset > 0)
 		return -EINVAL;
 
+	ret = security_kdbus_recv(conn, conn->ep->bus);
+	if (ret)
+		return ret;
+
 	mutex_lock(&conn->lock);
 	ret = kdbus_queue_entry_peek(&conn->queue, recv->priority,
 				     recv->flags & KDBUS_RECV_USE_PRIORITY,
@@ -460,7 +465,12 @@ static int kdbus_conn_check_access(struct kdbus_ep *ep,
 	if (allowed)
 		return 0;
 
-	/* ... otherwise, ask the policy DBs for permission */
+	/* ... consult LSM */
+	ret = security_kdbus_talk(conn_src, conn_dst);
+	if (ret)
+		return ret;
+
+	/* ... finally, ask the policy DBs for permission */
 	ret = kdbus_ep_policy_check_talk_access(ep, conn_src, conn_dst);
 	if (ret < 0)
 		return ret;
@@ -596,6 +606,10 @@ static void kdbus_conn_broadcast(struct kdbus_ep *ep,
 		 * data, even when they did not ask for it.
 		 */
 		if (conn_src) {
+			ret = security_kdbus_talk(conn_src, conn_dst);
+			if (ret)
+				continue;
+
 			/* Check if conn_src is allowed to signal */
 			ret = kdbus_ep_policy_check_broadcast(conn_dst->ep,
 							      conn_src,
@@ -736,6 +750,10 @@ int kdbus_conn_kmsg_send(struct kdbus_ep *ep,
 	bool sync = msg->flags & KDBUS_MSG_FLAGS_SYNC_REPLY;
 	int ret = 0;
 
+	ret = security_kdbus_send(conn_src, bus);
+	if (ret)
+		return ret;
+
 	/* assign domain-global message sequence number */
 	BUG_ON(kmsg->seq > 0);
 	kmsg->seq = atomic64_inc_return(&bus->domain->msg_seq_last);
@@ -1086,6 +1104,7 @@ static void __kdbus_conn_free(struct kref *kref)
 	kdbus_ep_unref(conn->ep);
 	kdbus_bus_unref(conn->bus);
 	put_cred(conn->cred);
+	security_kdbus_conn_free(conn);
 	kfree(conn->name);
 	kfree(conn);
 }
@@ -1467,8 +1486,12 @@ int kdbus_conn_new(struct kdbus_ep *ep,
 	bool is_policy_holder;
 	bool is_activator;
 	bool is_monitor;
+	u32 len;
+	u32 sid;
+	char *label;
 	int ret;
 
+
 	BUG_ON(*c);
 
 	is_monitor = hello->flags & KDBUS_HELLO_MONITOR;
@@ -1542,6 +1565,9 @@ int kdbus_conn_new(struct kdbus_ep *ep,
 		return -ENOMEM;
 
 	if (is_activator || is_policy_holder) {
+		ret = security_kdbus_ep_setpolicy(bus);
+		if (ret)
+			goto exit_free_conn;
 		/*
 		 * Policy holders may install one name, and are
 		 * allowed to use wildcards.
@@ -1680,6 +1706,12 @@ int kdbus_conn_new(struct kdbus_ep *ep,
 		goto exit_unref_user_unlock;
 	}
 
+	security_task_getsecid(current, &sid);
+	security_secid_to_secctx(sid, &label, &len);
+	ret = security_kdbus_connect(conn, label, len);
+	if (ret < 0)
+		goto exit_unref_user_unlock;
+
 	/* link into bus and endpoint */
 	list_add_tail(&conn->ep_entry, &ep->conn_list);
 	hash_add(bus->conn_hash, &conn->hentry, conn->id);
diff --git a/drivers/misc/kdbus/domain.c b/drivers/misc/kdbus/domain.c
index eb2ce72..43b77ed 100644
--- a/drivers/misc/kdbus/domain.c
+++ b/drivers/misc/kdbus/domain.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/sizes.h>
+#include <linux/security.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 
@@ -156,6 +157,7 @@ static void __kdbus_domain_free(struct device *dev)
 	idr_destroy(&domain->user_idr);
 	kfree(domain->name);
 	kfree(domain->devpath);
+	security_kdbus_domain_free(domain);
 	kfree(domain);
 }
 
@@ -255,6 +257,10 @@ int kdbus_domain_new(struct kdbus_domain *parent, const char *name,
 	if (ret < 0)
 		goto exit_put;
 
+	ret = security_kdbus_domain_alloc(d);
+	if (ret)
+		goto exit_put;
+
 	if (parent) {
 		/* lock order: parent domain -> domain */
 		mutex_lock(&parent->lock);
@@ -444,6 +450,7 @@ static void __kdbus_domain_user_free(struct kref *kref)
 	hash_del(&user->hentry);
 	mutex_unlock(&user->domain->lock);
 
+	security_kdbus_domain_free(user->domain);
 	kdbus_domain_unref(user->domain);
 	kfree(user);
 }
diff --git a/drivers/misc/kdbus/endpoint.c b/drivers/misc/kdbus/endpoint.c
index 8304360..74444c3 100644
--- a/drivers/misc/kdbus/endpoint.c
+++ b/drivers/misc/kdbus/endpoint.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/security.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
@@ -197,6 +198,10 @@ int kdbus_ep_new(struct kdbus_bus *bus, const char *name,
 	if (ret < 0)
 		goto exit_put;
 
+	ret = security_kdbus_ep_create(bus);
+	if (ret)
+		goto exit_put;
+
 	mutex_lock(&bus->lock);
 
 	if (bus->disconnected) {
@@ -255,6 +260,12 @@ int kdbus_ep_policy_set(struct kdbus_ep *ep,
 			const struct kdbus_item *items,
 			size_t items_size)
 {
+	int ret;
+
+	ret = security_kdbus_ep_setpolicy(ep->bus);
+	if (ret)
+		return ret;
+
 	return kdbus_policy_set(&ep->policy_db, items, items_size, 0, true, ep);
 }
 
diff --git a/drivers/misc/kdbus/names.c b/drivers/misc/kdbus/names.c
index 5f8853c..c13b0fb 100644
--- a/drivers/misc/kdbus/names.c
+++ b/drivers/misc/kdbus/names.c
@@ -22,6 +22,7 @@
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/sched.h>
+#include <linux/security.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 
@@ -492,6 +493,10 @@ int kdbus_name_acquire(struct kdbus_name_registry *reg,
 	u32 hash;
 	int ret = 0;
 
+	ret = security_kdbus_name_acquire(conn, name);
+	if (ret)
+		return ret;
+
 	/* lock order: domain -> bus -> ep -> names -> conn */
 	mutex_lock(&conn->bus->lock);
 	down_write(&reg->rwlock);
@@ -876,6 +881,10 @@ int kdbus_cmd_name_list(struct kdbus_name_registry *reg,
 	size_t pos;
 	int ret;
 
+	ret = security_kdbus_name_list(conn->bus);
+	if (ret)
+		return ret;
+
 	policy_db = &conn->ep->policy_db;
 
 	/* lock order: domain -> bus -> ep -> names -> conn */
-- 
2.1.1
