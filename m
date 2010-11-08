From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 07/23] netconsole: Move netdev_notifier into netpoll_targets
Date: Mon, 08 Nov 2010 12:32:17 -0800
Message-ID: <20101108203217.22479.41193.stgit@crlf.mtv.corp.google.com>
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

Move the notifier chain node up into struct netpoll_targets, and use it
to get at the netpoll_targets struct whenever we get a NETDEV event.

Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/net/netconsole.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 55f72ba..8ea4c5c 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -71,6 +71,7 @@ struct netpoll_targets {
 #ifdef	CONFIG_NETCONSOLE_DYNAMIC
 	struct configfs_subsystem configfs_subsys;
 #endif
+	struct notifier_block netdev_notifier;
 };
 #define DEFINE_NETPOLL_TARGETS(x) struct netpoll_targets x = \
 	{ .list = LIST_HEAD_INIT(x.list), \
@@ -737,6 +738,8 @@ static int netconsole_netdev_event(struct notifier_block *this,
 				   unsigned long event,
 				   void *ptr)
 {
+	struct netpoll_targets *nts = container_of(this, struct netpoll_targets,
+						   netdev_notifier);
 	unsigned long flags;
 	struct netconsole_target *nt;
 	struct net_device *dev = ptr;
@@ -745,8 +748,8 @@ static int netconsole_netdev_event(struct notifier_block *this,
 	      event == NETDEV_BONDING_DESLAVE))
 		goto done;
 
-	spin_lock_irqsave(&targets.lock, flags);
-	list_for_each_entry(nt, &targets.list, list) {
+	spin_lock_irqsave(&nts->lock, flags);
+	list_for_each_entry(nt, &nts->list, list) {
 		if (nt->np_state == NETPOLL_ENABLED && nt->np.dev == dev) {
 			switch (event) {
 			case NETDEV_CHANGENAME:
@@ -762,7 +765,7 @@ static int netconsole_netdev_event(struct notifier_block *this,
 			}
 		}
 	}
-	spin_unlock_irqrestore(&targets.lock, flags);
+	spin_unlock_irqrestore(&nts->lock, flags);
 	if (event == NETDEV_UNREGISTER || event == NETDEV_BONDING_DESLAVE)
 		printk(KERN_INFO "netconsole: network logging stopped, "
 			"interface %s %s\n",  dev->name,
@@ -772,10 +775,6 @@ done:
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block netconsole_netdev_notifier = {
-	.notifier_call  = netconsole_netdev_event,
-};
-
 static void write_msg(struct console *con, const char *msg, unsigned int len)
 {
 	int frag, left;
@@ -839,7 +838,8 @@ static int __init init_netconsole(void)
 		}
 	}
 
-	err = register_netdevice_notifier(&netconsole_netdev_notifier);
+	targets.netdev_notifier.notifier_call = netconsole_netdev_event;
+	err = register_netdevice_notifier(&targets.netdev_notifier);
 	if (err)
 		goto fail;
 
@@ -853,7 +853,7 @@ static int __init init_netconsole(void)
 	return err;
 
 undonotifier:
-	unregister_netdevice_notifier(&netconsole_netdev_notifier);
+	unregister_netdevice_notifier(&targets.netdev_notifier);
 
 fail:
 	printk(KERN_ERR "netconsole: cleaning up\n");
@@ -877,7 +877,7 @@ static void __exit cleanup_netconsole(void)
 
 	unregister_console(&netconsole);
 	dynamic_netpoll_targets_exit(&targets);
-	unregister_netdevice_notifier(&netconsole_netdev_notifier);
+	unregister_netdevice_notifier(&targets.netdev_notifier);
 
 	/*
 	 * Targets created via configfs pin references on our module
