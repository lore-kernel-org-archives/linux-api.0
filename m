From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 12/23] netpoll: Introduce netpoll_target configs
Date: Mon, 08 Nov 2010 12:32:47 -0800
Message-ID: <20101108203246.22479.60118.stgit@crlf.mtv.corp.google.com>
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

As preparation for moving netpoll_targets out of netconsole and making
them available to other clients, introduce new Kconfig options.

CONFIG_NETPOLL_TARGETS

Access to targets APIs.  Only supports parameter based parsing of
targets (via the kernel command line or module paramters).

CONFIG_NETPOLL_TARGETS_DYNAMIC

Extends the support that netpoll_targets provides by allowing for the
dynamic creation of targets in configfs on a per client basis.

Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/net/Kconfig      |   16 +++++++++++++---
 drivers/net/netconsole.c |   10 +++++-----
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index f6668cd..b014cd6 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -3367,14 +3367,15 @@ config NET_FC
 
 config NETCONSOLE
 	tristate "Network console logging support"
+	select NETPOLL_TARGETS
 	---help---
 	If you want to log kernel messages over the network, enable this.
 	See <file:Documentation/networking/netconsole.txt> for details.
 
 config NETCONSOLE_DYNAMIC
 	bool "Dynamic reconfiguration of logging targets"
-	depends on NETCONSOLE && SYSFS
-	select CONFIGFS_FS
+	depends on NETCONSOLE
+	select NETPOLL_TARGETS_DYNAMIC
 	help
 	  This option enables the ability to dynamically reconfigure target
 	  parameters (interface, IP addresses, port numbers, MAC addresses)
@@ -3382,7 +3383,16 @@ config NETCONSOLE_DYNAMIC
 	  See <file:Documentation/networking/netconsole.txt> for details.
 
 config NETPOLL
-	def_bool NETCONSOLE
+	def_bool false
+
+config NETPOLL_TARGETS
+	bool
+	select NETPOLL
+
+config NETPOLL_TARGETS_DYNAMIC
+	bool
+	select CONFIGFS_FS
+	select NETPOLL_TARGETS
 
 config NETPOLL_TRAP
 	bool "Netpoll traffic trapping"
diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 4348d23..2fe571d 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -68,7 +68,7 @@ __setup("netconsole=", option_setup);
 struct netpoll_targets {
 	struct list_head list;
 	spinlock_t lock;
-#ifdef	CONFIG_NETCONSOLE_DYNAMIC
+#ifdef	CONFIG_NETPOLL_TARGETS_DYNAMIC
 	struct configfs_subsystem configfs_subsys;
 #endif
 	struct notifier_block netdev_notifier;
@@ -110,7 +110,7 @@ static DEFINE_NETPOLL_TARGETS(targets);
 struct netpoll_target {
 	struct netpoll_targets *nts;
 	struct list_head	list;
-#ifdef	CONFIG_NETCONSOLE_DYNAMIC
+#ifdef	CONFIG_NETPOLL_TARGETS_DYNAMIC
 	struct config_item	item;
 #endif
 	int			np_state;
@@ -193,7 +193,7 @@ static void free_param_target(struct netpoll_target *nt)
 	kfree(nt);
 }
 
-#ifdef	CONFIG_NETCONSOLE_DYNAMIC
+#ifdef	CONFIG_NETPOLL_TARGETS_DYNAMIC
 
 /*
  * Our subsystem hierarchy is:
@@ -720,7 +720,7 @@ static void netpoll_target_put(struct netpoll_target *nt)
 		config_item_put(&nt->item);
 }
 
-#else	/* !CONFIG_NETCONSOLE_DYNAMIC */
+#else	/* !CONFIG_NETPOLL_TARGETS_DYNAMIC */
 
 static int __init dynamic_netpoll_targets_init(const char *subsys_name,
 					       struct netpoll_targets *nts)
@@ -744,7 +744,7 @@ static void netpoll_target_put(struct netpoll_target *nt)
 {
 }
 
-#endif	/* CONFIG_NETCONSOLE_DYNAMIC */
+#endif	/* CONFIG_NETPOLL_TARGETS_DYNAMIC */
 
 /*
  * Call netpoll_cleanup on this target asynchronously.
