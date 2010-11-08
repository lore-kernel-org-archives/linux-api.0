From: Mike Waychison <mikew@google.com>
Subject: [PATCH v2 13/23] netconsole: Move setting of default ports.
Date: Mon, 08 Nov 2010 12:32:53 -0800
Message-ID: <20101108203252.22479.95111.stgit@crlf.mtv.corp.google.com>
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

Clients of netpoll_targets need to be able to specify the default port
numbers.  Do this by specifying the default port numbers in struct
netpoll_targets directly.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/net/netconsole.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 2fe571d..0d77fc8 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -68,6 +68,7 @@ __setup("netconsole=", option_setup);
 struct netpoll_targets {
 	struct list_head list;
 	spinlock_t lock;
+	u16 default_local_port, default_remote_port;
 #ifdef	CONFIG_NETPOLL_TARGETS_DYNAMIC
 	struct configfs_subsystem configfs_subsys;
 #endif
@@ -161,8 +162,8 @@ static struct netpoll_target *alloc_param_target(struct netpoll_targets *nts,
 	nt->nts = nts;
 	nt->np.name = nts->subsys_name;
 	strlcpy(nt->np.dev_name, "eth0", IFNAMSIZ);
-	nt->np.local_port = 6665;
-	nt->np.remote_port = 6666;
+	nt->np.local_port = nts->default_local_port;
+	nt->np.remote_port = nts->default_remote_port;
 	memset(nt->np.remote_mac, 0xff, ETH_ALEN);
 	INIT_WORK(&nt->cleanup_work, deferred_netpoll_cleanup);
 
@@ -635,8 +636,8 @@ static struct config_item *make_netpoll_target(struct config_group *group,
 	nt->nts = nts;
 	nt->np.name = nts->subsys_name;
 	strlcpy(nt->np.dev_name, "eth0", IFNAMSIZ);
-	nt->np.local_port = 6665;
-	nt->np.remote_port = 6666;
+	nt->np.local_port = nts->default_local_port;
+	nt->np.remote_port = nts->default_remote_port;
 	memset(nt->np.remote_mac, 0xff, ETH_ALEN);
 	INIT_WORK(&nt->cleanup_work, deferred_netpoll_cleanup);
 
@@ -923,6 +924,10 @@ static void __exit unregister_netpoll_targets(struct netpoll_targets *nts)
 static int __init init_netconsole(void)
 {
 	int err;
+
+	targets.default_local_port = 6665;
+	targets.default_remote_port = 6666;
+
 	err = register_netpoll_targets("netconsole", &targets, config);
 	if (err)
 		return err;
