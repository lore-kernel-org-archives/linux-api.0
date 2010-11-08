From: Mike Waychison <mikew@google.com>
Subject: [PATCH v2 08/23] netconsole: Split out netpoll_targets init/exit
Date: Mon, 08 Nov 2010 12:32:23 -0800
Message-ID: <20101108203222.22479.14559.stgit@crlf.mtv.corp.google.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com, Matt Mackall <mpm@selenic.com>
Cc: adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com, Greg KH <greg@kroah.com>, =?utf-8?q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>, akpm@linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

As part of the factoring to move target handling out of netconsole,
abstract the construction and destruction of struct netpoll_targets
into their own functions.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/net/netconsole.c |   69 ++++++++++++++++++++++++++++------------------
 1 files changed, 42 insertions(+), 27 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 8ea4c5c..54d124c 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -660,13 +660,14 @@ static struct config_item_type netconsole_subsys_type = {
 	.ct_owner	= THIS_MODULE,
 };
 
-static int __init dynamic_netpoll_targets_init(struct netpoll_targets *nts)
+static int __init dynamic_netpoll_targets_init(const char *subsys_name,
+					       struct netpoll_targets *nts)
 {
 	struct configfs_subsystem *subsys = &nts->configfs_subsys;
 
 	config_group_init(&subsys->su_group);
 	mutex_init(&subsys->su_mutex);
-	strncpy((char *)&subsys->su_group.cg_item.ci_namebuf, "netconsole",
+	strncpy((char *)&subsys->su_group.cg_item.ci_namebuf, subsys_name,
 		CONFIGFS_ITEM_NAME_LEN);
 	subsys->su_group.cg_item.ci_type = &netconsole_subsys_type;
 	return configfs_register_subsystem(subsys);
@@ -814,13 +815,15 @@ static struct console netconsole = {
 	.write	= write_msg,
 };
 
-static int __init init_netconsole(void)
+static int __init register_netpoll_targets(const char *subsys_name,
+					   struct netpoll_targets *nts,
+					   char *static_targets)
 {
 	int err;
 	struct netconsole_target *nt, *tmp;
-	unsigned long flags;
 	char *target_config;
-	char *input = config;
+	char *input = static_targets;
+	unsigned long flags;
 
 	if (strnlen(input, MAX_PARAM_LENGTH)) {
 		while ((target_config = strsep(&input, ";"))) {
@@ -829,41 +832,33 @@ static int __init init_netconsole(void)
 				err = PTR_ERR(nt);
 				goto fail;
 			}
-			/* Dump existing printks when we register */
-			netconsole.flags |= CON_PRINTBUFFER;
 
-			spin_lock_irqsave(&targets.lock, flags);
-			list_add(&nt->list, &targets.list);
-			spin_unlock_irqrestore(&targets.lock, flags);
+			spin_lock_irqsave(&nts->lock, flags);
+			list_add(&nt->list, &nts->list);
+			spin_unlock_irqrestore(&nts->lock, flags);
 		}
 	}
 
-	targets.netdev_notifier.notifier_call = netconsole_netdev_event;
-	err = register_netdevice_notifier(&targets.netdev_notifier);
+	nts->netdev_notifier.notifier_call = netconsole_netdev_event;
+	err = register_netdevice_notifier(&nts->netdev_notifier);
 	if (err)
 		goto fail;
 
-	err = dynamic_netpoll_targets_init(&targets);
+	err = dynamic_netpoll_targets_init(subsys_name, nts);
 	if (err)
 		goto undonotifier;
 
-	register_console(&netconsole);
-	printk(KERN_INFO "netconsole: network logging started\n");
-
-	return err;
+	return 0;
 
 undonotifier:
-	unregister_netdevice_notifier(&targets.netdev_notifier);
-
+	unregister_netdevice_notifier(&nts->netdev_notifier);
 fail:
-	printk(KERN_ERR "netconsole: cleaning up\n");
-
 	/*
 	 * Remove all targets and destroy them (only targets created
 	 * from the boot/module option exist here). Skipping the list
 	 * lock is safe here, and netpoll_cleanup() will sleep.
 	 */
-	list_for_each_entry_safe(nt, tmp, &targets.list, list) {
+	list_for_each_entry_safe(nt, tmp, &nts->list, list) {
 		list_del(&nt->list);
 		free_param_target(nt);
 	}
@@ -871,13 +866,12 @@ fail:
 	return err;
 }
 
-static void __exit cleanup_netconsole(void)
+static void __exit unregister_netpoll_targets(struct netpoll_targets *nts)
 {
 	struct netconsole_target *nt, *tmp;
 
-	unregister_console(&netconsole);
-	dynamic_netpoll_targets_exit(&targets);
-	unregister_netdevice_notifier(&targets.netdev_notifier);
+	dynamic_netpoll_targets_exit(nts);
+	unregister_netdevice_notifier(&nts->netdev_notifier);
 
 	/*
 	 * Targets created via configfs pin references on our module
@@ -887,11 +881,32 @@ static void __exit cleanup_netconsole(void)
 	 * destroy them. Skipping the list lock is safe here, and
 	 * netpoll_cleanup() will sleep.
 	 */
-	list_for_each_entry_safe(nt, tmp, &targets.list, list) {
+	list_for_each_entry_safe(nt, tmp, &nts->list, list) {
 		list_del(&nt->list);
 		free_param_target(nt);
 	}
 }
 
+static int __init init_netconsole(void)
+{
+	int err;
+	err = register_netpoll_targets("netconsole", &targets, config);
+	if (err)
+		return err;
+	/* Dump existing printks if we registered any targets */
+	if (!list_empty(&targets.list))
+		netconsole.flags |= CON_PRINTBUFFER;
+	register_console(&netconsole);
+	printk(KERN_INFO "netconsole: network logging started\n");
+
+	return 0;
+}
+
+static void __exit cleanup_netconsole(void)
+{
+	unregister_console(&netconsole);
+	unregister_netpoll_targets(&targets);
+}
+
 module_init(init_netconsole);
 module_exit(cleanup_netconsole);
