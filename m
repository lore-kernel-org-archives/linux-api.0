From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 10/23] netconsole: Rename netconsole_target ->
	netpoll_target
Date: Mon, 08 Nov 2010 12:32:35 -0800
Message-ID: <20101108203234.22479.22822.stgit@crlf.mtv.corp.google.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101108203120.22479.19708.stgit-+dUuAhMFdFN6FDdRrpk8kO4/NqBCd+6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>
Cc: adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, =?utf-8?q?Am=C3=A9rico?= Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Rename targets from "struct netconsole_target" to "struct netpoll_target" as
they will soon no longer be netconsole specific.

While here, also rename the configfs related types.

Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/net/netconsole.c |  238 +++++++++++++++++++++++-----------------------
 1 files changed, 119 insertions(+), 119 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index ec8bda2..068df64 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -84,7 +84,7 @@ static DEFINE_NETPOLL_TARGETS(targets);
 #define NETPOLL_CLEANING	3
 
 /**
- * struct netconsole_target - Represents a configured netconsole target.
+ * struct netpoll_target - Represents a configured netpoll target.
  * @list:	Links this target into the netpoll_targets.list.
  * @item:	Links us into the configfs subsystem hierarchy.
  * @np_state:	Enabled / Disabled / SettingUp / Cleaning
@@ -106,7 +106,7 @@ static DEFINE_NETPOLL_TARGETS(targets);
  *		local_mac	(read-only)
  *		remote_mac	(read-write)
  */
-struct netconsole_target {
+struct netpoll_target {
 	struct netpoll_targets *nts;
 	struct list_head	list;
 #ifdef	CONFIG_NETCONSOLE_DYNAMIC
@@ -117,16 +117,16 @@ struct netconsole_target {
 	struct work_struct	cleanup_work;
 };
 
-static void netconsole_target_get(struct netconsole_target *nt);
-static void netconsole_target_put(struct netconsole_target *nt);
+static void netpoll_target_get(struct netpoll_target *nt);
+static void netpoll_target_put(struct netpoll_target *nt);
 
 static void deferred_netpoll_cleanup(struct work_struct *work)
 {
-	struct netconsole_target *nt;
+	struct netpoll_target *nt;
 	struct netpoll_targets *nts;
 	unsigned long flags;
 
-	nt = container_of(work, struct netconsole_target, cleanup_work);
+	nt = container_of(work, struct netpoll_target, cleanup_work);
 	nts = nt->nts;
 
 	netpoll_cleanup(&nt->np);
@@ -136,15 +136,15 @@ static void deferred_netpoll_cleanup(struct work_struct *work)
 	nt->np_state = NETPOLL_DISABLED;
 	spin_unlock_irqrestore(&nts->lock, flags);
 
-	netconsole_target_put(nt);
+	netpoll_target_put(nt);
 }
 
 /* Allocate new target (from boot/module param) and setup netpoll for it */
-static struct netconsole_target *alloc_param_target(struct netpoll_targets *nts,
-						    char *target_config)
+static struct netpoll_target *alloc_param_target(struct netpoll_targets *nts,
+						 char *target_config)
 {
 	int err = -ENOMEM;
-	struct netconsole_target *nt;
+	struct netpoll_target *nt;
 
 	/*
 	 * Allocate and initialize with defaults.
@@ -183,7 +183,7 @@ fail:
 }
 
 /* Cleanup netpoll for given target (from boot/module param) and free it */
-static void free_param_target(struct netconsole_target *nt)
+static void free_param_target(struct netpoll_target *nt)
 {
 	cancel_work_sync(&nt->cleanup_work);
 	if (nt->np_state == NETPOLL_CLEANING || nt->np_state == NETPOLL_ENABLED)
@@ -211,19 +211,19 @@ static void free_param_target(struct netconsole_target *nt)
  *				<target>/...
  */
 
-struct netconsole_target_attr {
+struct netpoll_target_attr {
 	struct configfs_attribute	attr;
-	ssize_t				(*show)(struct netconsole_target *nt,
+	ssize_t				(*show)(struct netpoll_target *nt,
 						char *buf);
-	ssize_t				(*store)(struct netconsole_target *nt,
+	ssize_t				(*store)(struct netpoll_target *nt,
 						 const char *buf,
 						 size_t count);
 };
 
-static struct netconsole_target *to_target(struct config_item *item)
+static struct netpoll_target *to_target(struct config_item *item)
 {
 	return item ?
-		container_of(item, struct netconsole_target, item) :
+		container_of(item, struct netpoll_target, item) :
 		NULL;
 }
 
@@ -256,41 +256,41 @@ static long strtol10_check_range(const char *cp, long min, long max)
 }
 
 /*
- * Attribute operations for netconsole_target.
+ * Attribute operations for netpoll_target.
  */
 
-static ssize_t show_enabled(struct netconsole_target *nt, char *buf)
+static ssize_t show_enabled(struct netpoll_target *nt, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%d\n",
 			nt->np_state == NETPOLL_ENABLED);
 }
 
-static ssize_t show_dev_name(struct netconsole_target *nt, char *buf)
+static ssize_t show_dev_name(struct netpoll_target *nt, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%s\n", nt->np.dev_name);
 }
 
-static ssize_t show_local_port(struct netconsole_target *nt, char *buf)
+static ssize_t show_local_port(struct netpoll_target *nt, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%d\n", nt->np.local_port);
 }
 
-static ssize_t show_remote_port(struct netconsole_target *nt, char *buf)
+static ssize_t show_remote_port(struct netpoll_target *nt, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%d\n", nt->np.remote_port);
 }
 
-static ssize_t show_local_ip(struct netconsole_target *nt, char *buf)
+static ssize_t show_local_ip(struct netpoll_target *nt, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%pI4\n", &nt->np.local_ip);
 }
 
-static ssize_t show_remote_ip(struct netconsole_target *nt, char *buf)
+static ssize_t show_remote_ip(struct netpoll_target *nt, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%pI4\n", &nt->np.remote_ip);
 }
 
-static ssize_t show_local_mac(struct netconsole_target *nt, char *buf)
+static ssize_t show_local_mac(struct netpoll_target *nt, char *buf)
 {
 	struct net_device *dev = nt->np.dev;
 	static const u8 bcast[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
@@ -298,7 +298,7 @@ static ssize_t show_local_mac(struct netconsole_target *nt, char *buf)
 	return snprintf(buf, PAGE_SIZE, "%pM\n", dev ? dev->dev_addr : bcast);
 }
 
-static ssize_t show_remote_mac(struct netconsole_target *nt, char *buf)
+static ssize_t show_remote_mac(struct netpoll_target *nt, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%pM\n", nt->np.remote_mac);
 }
@@ -310,7 +310,7 @@ static ssize_t show_remote_mac(struct netconsole_target *nt, char *buf)
  * would enable him to dynamically add new netpoll targets for new
  * network interfaces as and when they come up).
  */
-static ssize_t store_enabled(struct netconsole_target *nt,
+static ssize_t store_enabled(struct netpoll_target *nt,
 			     const char *buf,
 			     size_t count)
 {
@@ -377,7 +377,7 @@ busy:
 	return -EBUSY;
 }
 
-static ssize_t store_dev_name(struct netconsole_target *nt,
+static ssize_t store_dev_name(struct netpoll_target *nt,
 			      const char *buf,
 			      size_t count)
 {
@@ -393,7 +393,7 @@ static ssize_t store_dev_name(struct netconsole_target *nt,
 	return strnlen(buf, count);
 }
 
-static ssize_t store_local_port(struct netconsole_target *nt,
+static ssize_t store_local_port(struct netpoll_target *nt,
 				const char *buf,
 				size_t count)
 {
@@ -409,7 +409,7 @@ static ssize_t store_local_port(struct netconsole_target *nt,
 	return strnlen(buf, count);
 }
 
-static ssize_t store_remote_port(struct netconsole_target *nt,
+static ssize_t store_remote_port(struct netpoll_target *nt,
 				 const char *buf,
 				 size_t count)
 {
@@ -425,7 +425,7 @@ static ssize_t store_remote_port(struct netconsole_target *nt,
 	return strnlen(buf, count);
 }
 
-static ssize_t store_local_ip(struct netconsole_target *nt,
+static ssize_t store_local_ip(struct netpoll_target *nt,
 			      const char *buf,
 			      size_t count)
 {
@@ -434,7 +434,7 @@ static ssize_t store_local_ip(struct netconsole_target *nt,
 	return strnlen(buf, count);
 }
 
-static ssize_t store_remote_ip(struct netconsole_target *nt,
+static ssize_t store_remote_ip(struct netpoll_target *nt,
 			       const char *buf,
 			       size_t count)
 {
@@ -443,7 +443,7 @@ static ssize_t store_remote_ip(struct netconsole_target *nt,
 	return strnlen(buf, count);
 }
 
-static ssize_t store_remote_mac(struct netconsole_target *nt,
+static ssize_t store_remote_mac(struct netpoll_target *nt,
 				const char *buf,
 				size_t count)
 {
@@ -471,20 +471,20 @@ invalid:
 }
 
 /*
- * Attribute definitions for netconsole_target.
+ * Attribute definitions for netpoll_target.
  */
 
-#define __NETCONSOLE_TARGET_ATTR_RO(_name, _prefix_...)			\
-static struct netconsole_target_attr netconsole_target_##_name =	\
+#define __NETPOLL_TARGET_ATTR_RO(_name, _prefix_...)			\
+static struct netpoll_target_attr netpoll_target_##_name =	\
 	__CONFIGFS_ATTR(_name, S_IRUGO, show_##_prefix_##_name, NULL)
 
-#define __NETCONSOLE_TARGET_ATTR_RW(_name, _prefix_...)			\
-static struct netconsole_target_attr netconsole_target_##_name =	\
+#define __NETPOLL_TARGET_ATTR_RW(_name, _prefix_...)			\
+static struct netpoll_target_attr netpoll_target_##_name =	\
 	__CONFIGFS_ATTR(_name, S_IRUGO | S_IWUSR,			\
 			show_##_prefix_##_name, store_##_prefix_##_name)
 
-#define NETCONSOLE_WRAP_ATTR_STORE(_name)				\
-static ssize_t store_locked_##_name(struct netconsole_target *nt,	\
+#define NETPOLL_WRAP_ATTR_STORE(_name)					\
+static ssize_t store_locked_##_name(struct netpoll_target *nt,		\
 				    const char *buf,			\
 				    size_t count)			\
 {									\
@@ -504,8 +504,8 @@ static ssize_t store_locked_##_name(struct netconsole_target *nt,	\
 	return ret;							\
 }
 
-#define NETCONSOLE_WRAP_ATTR_SHOW(_name)				\
-static ssize_t show_locked_##_name(struct netconsole_target *nt, char *buf) \
+#define NETPOLL_WRAP_ATTR_SHOW(_name)					\
+static ssize_t show_locked_##_name(struct netpoll_target *nt, char *buf) \
 {									\
 	struct netpoll_targets *nts = nt->nts;				\
 	unsigned long flags;						\
@@ -516,53 +516,53 @@ static ssize_t show_locked_##_name(struct netconsole_target *nt, char *buf) \
 	return ret;							\
 }
 
-#define NETCONSOLE_TARGET_ATTR_RW(_name)				\
-		NETCONSOLE_WRAP_ATTR_STORE(_name)			\
-		NETCONSOLE_WRAP_ATTR_SHOW(_name)			\
-		__NETCONSOLE_TARGET_ATTR_RW(_name, locked_)
-
-#define NETCONSOLE_TARGET_ATTR_RO(_name)				\
-		NETCONSOLE_WRAP_ATTR_SHOW(_name)			\
-		__NETCONSOLE_TARGET_ATTR_RO(_name, locked_)
-
-__NETCONSOLE_TARGET_ATTR_RW(enabled);
-NETCONSOLE_TARGET_ATTR_RW(dev_name);
-NETCONSOLE_TARGET_ATTR_RW(local_port);
-NETCONSOLE_TARGET_ATTR_RW(remote_port);
-NETCONSOLE_TARGET_ATTR_RW(local_ip);
-NETCONSOLE_TARGET_ATTR_RW(remote_ip);
-NETCONSOLE_TARGET_ATTR_RO(local_mac);
-NETCONSOLE_TARGET_ATTR_RW(remote_mac);
-
-static struct configfs_attribute *netconsole_target_attrs[] = {
-	&netconsole_target_enabled.attr,
-	&netconsole_target_dev_name.attr,
-	&netconsole_target_local_port.attr,
-	&netconsole_target_remote_port.attr,
-	&netconsole_target_local_ip.attr,
-	&netconsole_target_remote_ip.attr,
-	&netconsole_target_local_mac.attr,
-	&netconsole_target_remote_mac.attr,
+#define NETPOLL_TARGET_ATTR_RW(_name)				\
+		NETPOLL_WRAP_ATTR_STORE(_name)			\
+		NETPOLL_WRAP_ATTR_SHOW(_name)			\
+		__NETPOLL_TARGET_ATTR_RW(_name, locked_)
+
+#define NETPOLL_TARGET_ATTR_RO(_name)				\
+		NETPOLL_WRAP_ATTR_SHOW(_name)			\
+		__NETPOLL_TARGET_ATTR_RO(_name, locked_)
+
+__NETPOLL_TARGET_ATTR_RW(enabled);
+NETPOLL_TARGET_ATTR_RW(dev_name);
+NETPOLL_TARGET_ATTR_RW(local_port);
+NETPOLL_TARGET_ATTR_RW(remote_port);
+NETPOLL_TARGET_ATTR_RW(local_ip);
+NETPOLL_TARGET_ATTR_RW(remote_ip);
+NETPOLL_TARGET_ATTR_RO(local_mac);
+NETPOLL_TARGET_ATTR_RW(remote_mac);
+
+static struct configfs_attribute *netpoll_target_attrs[] = {
+	&netpoll_target_enabled.attr,
+	&netpoll_target_dev_name.attr,
+	&netpoll_target_local_port.attr,
+	&netpoll_target_remote_port.attr,
+	&netpoll_target_local_ip.attr,
+	&netpoll_target_remote_ip.attr,
+	&netpoll_target_local_mac.attr,
+	&netpoll_target_remote_mac.attr,
 	NULL,
 };
 
 /*
- * Item operations and type for netconsole_target.
+ * Item operations and type for netpoll_target.
  */
 
-static void netconsole_target_release(struct config_item *item)
+static void netpoll_target_release(struct config_item *item)
 {
 	kfree(to_target(item));
 }
 
-static ssize_t netconsole_target_attr_show(struct config_item *item,
-					   struct configfs_attribute *attr,
-					   char *buf)
+static ssize_t netpoll_target_attr_show(struct config_item *item,
+					struct configfs_attribute *attr,
+					char *buf)
 {
 	ssize_t ret = -EINVAL;
-	struct netconsole_target *nt = to_target(item);
-	struct netconsole_target_attr *na =
-		container_of(attr, struct netconsole_target_attr, attr);
+	struct netpoll_target *nt = to_target(item);
+	struct netpoll_target_attr *na =
+		container_of(attr, struct netpoll_target_attr, attr);
 
 	if (na->show)
 		ret = na->show(nt, buf);
@@ -570,15 +570,15 @@ static ssize_t netconsole_target_attr_show(struct config_item *item,
 	return ret;
 }
 
-static ssize_t netconsole_target_attr_store(struct config_item *item,
-					    struct configfs_attribute *attr,
-					    const char *buf,
-					    size_t count)
+static ssize_t netpoll_target_attr_store(struct config_item *item,
+					 struct configfs_attribute *attr,
+					 const char *buf,
+					 size_t count)
 {
 	ssize_t ret = -EINVAL;
-	struct netconsole_target *nt = to_target(item);
-	struct netconsole_target_attr *na =
-		container_of(attr, struct netconsole_target_attr, attr);
+	struct netpoll_target *nt = to_target(item);
+	struct netpoll_target_attr *na =
+		container_of(attr, struct netpoll_target_attr, attr);
 
 	if (na->store)
 		ret = na->store(nt, buf, count);
@@ -586,15 +586,15 @@ static ssize_t netconsole_target_attr_store(struct config_item *item,
 	return ret;
 }
 
-static struct configfs_item_operations netconsole_target_item_ops = {
-	.release		= netconsole_target_release,
-	.show_attribute		= netconsole_target_attr_show,
-	.store_attribute	= netconsole_target_attr_store,
+static struct configfs_item_operations netpoll_target_item_ops = {
+	.release		= netpoll_target_release,
+	.show_attribute		= netpoll_target_attr_show,
+	.store_attribute	= netpoll_target_attr_store,
 };
 
-static struct config_item_type netconsole_target_type = {
-	.ct_attrs		= netconsole_target_attrs,
-	.ct_item_ops		= &netconsole_target_item_ops,
+static struct config_item_type netpoll_target_type = {
+	.ct_attrs		= netpoll_target_attrs,
+	.ct_item_ops		= &netpoll_target_item_ops,
 	.ct_owner		= THIS_MODULE,
 };
 
@@ -606,14 +606,14 @@ static struct netpoll_targets *group_to_targets(struct config_group *group)
 }
 
 /*
- * Group operations and type for netconsole_subsys.
+ * Group operations and type for netpoll_target_subsys.
  */
 
-static struct config_item *make_netconsole_target(struct config_group *group,
-						  const char *name)
+static struct config_item *make_netpoll_target(struct config_group *group,
+					       const char *name)
 {
 	struct netpoll_targets *nts = group_to_targets(group);
-	struct netconsole_target *nt;
+	struct netpoll_target *nt;
 	unsigned long flags;
 
 	/*
@@ -635,7 +635,7 @@ static struct config_item *make_netconsole_target(struct config_group *group,
 	INIT_WORK(&nt->cleanup_work, deferred_netpoll_cleanup);
 
 	/* Initialize the config_item member */
-	config_item_init_type_name(&nt->item, name, &netconsole_target_type);
+	config_item_init_type_name(&nt->item, name, &netpoll_target_type);
 
 	/* Adding, but it is disabled */
 	spin_lock_irqsave(&nts->lock, flags);
@@ -645,11 +645,11 @@ static struct config_item *make_netconsole_target(struct config_group *group,
 	return &nt->item;
 }
 
-static void drop_netconsole_target(struct config_group *group,
-				   struct config_item *item)
+static void drop_netpoll_target(struct config_group *group,
+				struct config_item *item)
 {
 	struct netpoll_targets *nts = group_to_targets(group);
-	struct netconsole_target *nt = to_target(item);
+	struct netpoll_target *nt = to_target(item);
 	unsigned long flags;
 
 	spin_lock_irqsave(&nts->lock, flags);
@@ -666,16 +666,16 @@ static void drop_netconsole_target(struct config_group *group,
 	if (nt->np_state == NETPOLL_ENABLED)
 		netpoll_cleanup(&nt->np);
 
-	netconsole_target_put(nt);
+	netpoll_target_put(nt);
 }
 
-static struct configfs_group_operations netconsole_subsys_group_ops = {
-	.make_item	= make_netconsole_target,
-	.drop_item	= drop_netconsole_target,
+static struct configfs_group_operations netpoll_subsys_group_ops = {
+	.make_item	= make_netpoll_target,
+	.drop_item	= drop_netpoll_target,
 };
 
-static struct config_item_type netconsole_subsys_type = {
-	.ct_group_ops	= &netconsole_subsys_group_ops,
+static struct config_item_type netpoll_subsys_type = {
+	.ct_group_ops	= &netpoll_subsys_group_ops,
 	.ct_owner	= THIS_MODULE,
 };
 
@@ -688,7 +688,7 @@ static int __init dynamic_netpoll_targets_init(const char *subsys_name,
 	mutex_init(&subsys->su_mutex);
 	strncpy((char *)&subsys->su_group.cg_item.ci_namebuf, subsys_name,
 		CONFIGFS_ITEM_NAME_LEN);
-	subsys->su_group.cg_item.ci_type = &netconsole_subsys_type;
+	subsys->su_group.cg_item.ci_type = &netpoll_subsys_type;
 	return configfs_register_subsystem(subsys);
 }
 
@@ -702,13 +702,13 @@ static void __exit dynamic_netpoll_targets_exit(struct netpoll_targets *nts)
  * do not exist in the configfs hierarchy (and have NULL names) and will
  * never go away, so make these a no-op for them.
  */
-static void netconsole_target_get(struct netconsole_target *nt)
+static void netpoll_target_get(struct netpoll_target *nt)
 {
 	if (config_item_name(&nt->item))
 		config_item_get(&nt->item);
 }
 
-static void netconsole_target_put(struct netconsole_target *nt)
+static void netpoll_target_put(struct netpoll_target *nt)
 {
 	if (config_item_name(&nt->item))
 		config_item_put(&nt->item);
@@ -730,11 +730,11 @@ static void __exit dynamic_netpoll_targets_exit(struct netpoll_targets *nts)
  * No danger of targets going away from under us when dynamic
  * reconfigurability is off.
  */
-static void netconsole_target_get(struct netconsole_target *nt)
+static void netpoll_target_get(struct netpoll_target *nt)
 {
 }
 
-static void netconsole_target_put(struct netconsole_target *nt)
+static void netpoll_target_put(struct netpoll_target *nt)
 {
 }
 
@@ -744,24 +744,24 @@ static void netconsole_target_put(struct netconsole_target *nt)
  * Call netpoll_cleanup on this target asynchronously.
  * nts->lock is required.
  */
-static void defer_netpoll_cleanup(struct netconsole_target *nt)
+static void defer_netpoll_cleanup(struct netpoll_target *nt)
 {
 	if (nt->np_state != NETPOLL_ENABLED)
 		return;
-	netconsole_target_get(nt);
+	netpoll_target_get(nt);
 	nt->np_state = NETPOLL_CLEANING;
 	schedule_work(&nt->cleanup_work);
 }
 
 /* Handle network interface device notifications */
-static int netconsole_netdev_event(struct notifier_block *this,
-				   unsigned long event,
-				   void *ptr)
+static int netpoll_targets_netdev_event(struct notifier_block *this,
+					unsigned long event,
+					void *ptr)
 {
 	struct netpoll_targets *nts = container_of(this, struct netpoll_targets,
 						   netdev_notifier);
 	unsigned long flags;
-	struct netconsole_target *nt;
+	struct netpoll_target *nt;
 	struct net_device *dev = ptr;
 
 	if (!(event == NETDEV_CHANGENAME || event == NETDEV_UNREGISTER ||
@@ -799,7 +799,7 @@ static void write_msg(struct console *con, const char *msg, unsigned int len)
 {
 	int frag, left;
 	unsigned long flags;
-	struct netconsole_target *nt;
+	struct netpoll_target *nt;
 	const char *tmp;
 
 	/* Avoid taking lock and disabling interrupts unnecessarily */
@@ -839,7 +839,7 @@ static int __init register_netpoll_targets(const char *subsys_name,
 					   char *static_targets)
 {
 	int err;
-	struct netconsole_target *nt, *tmp;
+	struct netpoll_target *nt, *tmp;
 	char *target_config;
 	char *input = static_targets;
 	unsigned long flags;
@@ -858,7 +858,7 @@ static int __init register_netpoll_targets(const char *subsys_name,
 		}
 	}
 
-	nts->netdev_notifier.notifier_call = netconsole_netdev_event;
+	nts->netdev_notifier.notifier_call = netpoll_targets_netdev_event;
 	err = register_netdevice_notifier(&nts->netdev_notifier);
 	if (err)
 		goto fail;
@@ -887,7 +887,7 @@ fail:
 
 static void __exit unregister_netpoll_targets(struct netpoll_targets *nts)
 {
-	struct netconsole_target *nt, *tmp;
+	struct netpoll_target *nt, *tmp;
 
 	dynamic_netpoll_targets_exit(nts);
 	unregister_netdevice_notifier(&nts->netdev_notifier);
