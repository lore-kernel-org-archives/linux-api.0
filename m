From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 05/23] netconsole: Wrap the list and locking in a structure
Date: Mon, 08 Nov 2010 12:32:06 -0800
Message-ID: <20101108203205.22479.97761.stgit@crlf.mtv.corp.google.com>
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

In preparation for moving all the netpoll target handling code out of
netconsole proper and into netpoll, wrap the list and lock in a new
structure, netpoll_targets.

Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/net/netconsole.c |   85 ++++++++++++++++++++++++----------------------
 1 files changed, 44 insertions(+), 41 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 02ba5c4..f28681b 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -65,11 +65,14 @@ static int __init option_setup(char *opt)
 __setup("netconsole=", option_setup);
 #endif	/* MODULE */
 
-/* Linked list of all configured targets */
-static LIST_HEAD(target_list);
-
-/* This needs to be a spinlock because write_msg() cannot sleep */
-static DEFINE_SPINLOCK(target_list_lock);
+struct netpoll_targets {
+	struct list_head list;
+	spinlock_t lock;
+};
+#define DEFINE_NETPOLL_TARGETS(x) struct netpoll_targets x = \
+	{ .list = LIST_HEAD_INIT(x.list), \
+	  .lock = __SPIN_LOCK_UNLOCKED(x.lock) }
+static DEFINE_NETPOLL_TARGETS(targets);
 
 #define NETPOLL_DISABLED	0
 #define NETPOLL_SETTINGUP	1
@@ -78,7 +81,7 @@ static DEFINE_SPINLOCK(target_list_lock);
 
 /**
  * struct netconsole_target - Represents a configured netconsole target.
- * @list:	Links this target into the target_list.
+ * @list:	Links this target into the netpoll_targets.list.
  * @item:	Links us into the configfs subsystem hierarchy.
  * @np_state:	Enabled / Disabled / SettingUp / Cleaning
  *		Visible from userspace (read-write) as "enabled".
@@ -175,10 +178,10 @@ static void deferred_netpoll_cleanup(struct work_struct *work)
 	nt = container_of(work, struct netconsole_target, cleanup_work);
 	netpoll_cleanup(&nt->np);
 
-	spin_lock_irqsave(&target_list_lock, flags);
+	spin_lock_irqsave(&targets.lock, flags);
 	BUG_ON(nt->np_state != NETPOLL_CLEANING);
 	nt->np_state = NETPOLL_DISABLED;
-	spin_unlock_irqrestore(&target_list_lock, flags);
+	spin_unlock_irqrestore(&targets.lock, flags);
 
 	netconsole_target_put(nt);
 }
@@ -365,7 +368,7 @@ static ssize_t store_enabled(struct netconsole_target *nt,
 		return enabled;
 
 	if (enabled) {	/* 1 */
-		spin_lock_irqsave(&target_list_lock, flags);
+		spin_lock_irqsave(&targets.lock, flags);
 		if (nt->np_state != NETPOLL_DISABLED)
 			goto busy;
 		else {
@@ -377,7 +380,7 @@ static ssize_t store_enabled(struct netconsole_target *nt,
 			 * because there is a reference implicitly held by the
 			 * caller of the store operation.
 			 */
-			spin_unlock_irqrestore(&target_list_lock, flags);
+			spin_unlock_irqrestore(&targets.lock, flags);
 		}
 
 		/*
@@ -387,34 +390,34 @@ static ssize_t store_enabled(struct netconsole_target *nt,
 		netpoll_print_options(&nt->np);
 
 		err = netpoll_setup(&nt->np);
-		spin_lock_irqsave(&target_list_lock, flags);
+		spin_lock_irqsave(&targets.lock, flags);
 		if (err)
 			nt->np_state = NETPOLL_DISABLED;
 		else
 			nt->np_state = NETPOLL_ENABLED;
-		spin_unlock_irqrestore(&target_list_lock, flags);
+		spin_unlock_irqrestore(&targets.lock, flags);
 		if (err)
 			return err;
 
 		printk(KERN_INFO "netconsole: network logging started\n");
 	} else {	/* 0 */
-		spin_lock_irqsave(&target_list_lock, flags);
+		spin_lock_irqsave(&targets.lock, flags);
 		if (nt->np_state == NETPOLL_ENABLED)
 			nt->np_state = NETPOLL_CLEANING;
 		else if (nt->np_state != NETPOLL_DISABLED)
 			goto busy;
-		spin_unlock_irqrestore(&target_list_lock, flags);
+		spin_unlock_irqrestore(&targets.lock, flags);
 
 		netpoll_cleanup(&nt->np);
 
-		spin_lock_irqsave(&target_list_lock, flags);
+		spin_lock_irqsave(&targets.lock, flags);
 		nt->np_state = NETPOLL_DISABLED;
-		spin_unlock_irqrestore(&target_list_lock, flags);
+		spin_unlock_irqrestore(&targets.lock, flags);
 	}
 
 	return strnlen(buf, count);
 busy:
-	spin_unlock_irqrestore(&target_list_lock, flags);
+	spin_unlock_irqrestore(&targets.lock, flags);
 	return -EBUSY;
 }
 
@@ -531,16 +534,16 @@ static ssize_t store_locked_##_name(struct netconsole_target *nt,	\
 {									\
 	unsigned long flags;						\
 	ssize_t ret;							\
-	spin_lock_irqsave(&target_list_lock, flags);			\
+	spin_lock_irqsave(&targets.lock, flags);			\
 	if (nt->np_state != NETPOLL_DISABLED) {				\
 		printk(KERN_ERR "netconsole: target (%s) is enabled, "	\
 				"disable to update parameters\n",	\
 				config_item_name(&nt->item));		\
-		spin_unlock_irqrestore(&target_list_lock, flags);	\
+		spin_unlock_irqrestore(&targets.lock, flags);		\
 		return -EBUSY;						\
 	}								\
 	ret = store_##_name(nt, buf, count);				\
-	spin_unlock_irqrestore(&target_list_lock, flags);		\
+	spin_unlock_irqrestore(&targets.lock, flags);			\
 	return ret;							\
 }
 
@@ -549,9 +552,9 @@ static ssize_t show_locked_##_name(struct netconsole_target *nt, char *buf) \
 {									\
 	unsigned long flags;						\
 	ssize_t ret;							\
-	spin_lock_irqsave(&target_list_lock, flags);			\
+	spin_lock_irqsave(&targets.lock, flags);			\
 	ret = show_##_name(nt, buf);					\
-	spin_unlock_irqrestore(&target_list_lock, flags);		\
+	spin_unlock_irqrestore(&targets.lock, flags);			\
 	return ret;							\
 }
 
@@ -668,9 +671,9 @@ static struct config_item *make_netconsole_target(struct config_group *group,
 	config_item_init_type_name(&nt->item, name, &netconsole_target_type);
 
 	/* Adding, but it is disabled */
-	spin_lock_irqsave(&target_list_lock, flags);
-	list_add(&nt->list, &target_list);
-	spin_unlock_irqrestore(&target_list_lock, flags);
+	spin_lock_irqsave(&targets.lock, flags);
+	list_add(&nt->list, &targets.list);
+	spin_unlock_irqrestore(&targets.lock, flags);
 
 	return &nt->item;
 }
@@ -681,9 +684,9 @@ static void drop_netconsole_target(struct config_group *group,
 	unsigned long flags;
 	struct netconsole_target *nt = to_target(item);
 
-	spin_lock_irqsave(&target_list_lock, flags);
+	spin_lock_irqsave(&targets.lock, flags);
 	list_del(&nt->list);
-	spin_unlock_irqrestore(&target_list_lock, flags);
+	spin_unlock_irqrestore(&targets.lock, flags);
 
 	/*
 	 * The target may have never been enabled, or was manually disabled
@@ -695,7 +698,7 @@ static void drop_netconsole_target(struct config_group *group,
 	if (nt->np_state == NETPOLL_ENABLED)
 		netpoll_cleanup(&nt->np);
 
-	config_item_put(&nt->item);
+	netconsole_target_put(nt);
 }
 
 static struct configfs_group_operations netconsole_subsys_group_ops = {
@@ -722,7 +725,7 @@ static struct configfs_subsystem netconsole_subsys = {
 
 /*
  * Call netpoll_cleanup on this target asynchronously.
- * target_list_lock is required.
+ * targets.lock is required.
  */
 static void defer_netpoll_cleanup(struct netconsole_target *nt)
 {
@@ -746,8 +749,8 @@ static int netconsole_netdev_event(struct notifier_block *this,
 	      event == NETDEV_BONDING_DESLAVE))
 		goto done;
 
-	spin_lock_irqsave(&target_list_lock, flags);
-	list_for_each_entry(nt, &target_list, list) {
+	spin_lock_irqsave(&targets.lock, flags);
+	list_for_each_entry(nt, &targets.list, list) {
 		if (nt->np_state == NETPOLL_ENABLED && nt->np.dev == dev) {
 			switch (event) {
 			case NETDEV_CHANGENAME:
@@ -763,7 +766,7 @@ static int netconsole_netdev_event(struct notifier_block *this,
 			}
 		}
 	}
-	spin_unlock_irqrestore(&target_list_lock, flags);
+	spin_unlock_irqrestore(&targets.lock, flags);
 	if (event == NETDEV_UNREGISTER || event == NETDEV_BONDING_DESLAVE)
 		printk(KERN_INFO "netconsole: network logging stopped, "
 			"interface %s %s\n",  dev->name,
@@ -785,11 +788,11 @@ static void write_msg(struct console *con, const char *msg, unsigned int len)
 	const char *tmp;
 
 	/* Avoid taking lock and disabling interrupts unnecessarily */
-	if (list_empty(&target_list))
+	if (list_empty(&targets.list))
 		return;
 
-	spin_lock_irqsave(&target_list_lock, flags);
-	list_for_each_entry(nt, &target_list, list) {
+	spin_lock_irqsave(&targets.lock, flags);
+	list_for_each_entry(nt, &targets.list, list) {
 		if (nt->np_state == NETPOLL_ENABLED
 		    && netif_running(nt->np.dev)) {
 			/*
@@ -807,7 +810,7 @@ static void write_msg(struct console *con, const char *msg, unsigned int len)
 			}
 		}
 	}
-	spin_unlock_irqrestore(&target_list_lock, flags);
+	spin_unlock_irqrestore(&targets.lock, flags);
 }
 
 static struct console netconsole = {
@@ -834,9 +837,9 @@ static int __init init_netconsole(void)
 			/* Dump existing printks when we register */
 			netconsole.flags |= CON_PRINTBUFFER;
 
-			spin_lock_irqsave(&target_list_lock, flags);
-			list_add(&nt->list, &target_list);
-			spin_unlock_irqrestore(&target_list_lock, flags);
+			spin_lock_irqsave(&targets.lock, flags);
+			list_add(&nt->list, &targets.list);
+			spin_unlock_irqrestore(&targets.lock, flags);
 		}
 	}
 
@@ -864,7 +867,7 @@ fail:
 	 * from the boot/module option exist here). Skipping the list
 	 * lock is safe here, and netpoll_cleanup() will sleep.
 	 */
-	list_for_each_entry_safe(nt, tmp, &target_list, list) {
+	list_for_each_entry_safe(nt, tmp, &targets.list, list) {
 		list_del(&nt->list);
 		free_param_target(nt);
 	}
@@ -888,7 +891,7 @@ static void __exit cleanup_netconsole(void)
 	 * destroy them. Skipping the list lock is safe here, and
 	 * netpoll_cleanup() will sleep.
 	 */
-	list_for_each_entry_safe(nt, tmp, &target_list, list) {
+	list_for_each_entry_safe(nt, tmp, &targets.list, list) {
 		list_del(&nt->list);
 		free_param_target(nt);
 	}
