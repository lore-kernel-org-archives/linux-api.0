From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 01/23] netconsole: Remove unneeded reference counting
Date: Mon, 08 Nov 2010 12:31:42 -0800
Message-ID: <20101108203141.22479.74390.stgit@crlf.mtv.corp.google.com>
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

The loops that iterate through the list of targets for emitting console
messages in the netconsole driver operating with interrupts disabled and
the list-protecting lock held.  There is no way for the elements of the
list to disappear, so we don't need to grab references to them.

This patch keeps the definitions however of netconsole_target_get() and
netconsole_target_put() as they are used in a subsequent patch.

Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/net/netconsole.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 94255f0..c87a49e 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -671,7 +671,6 @@ static int netconsole_netdev_event(struct notifier_block *this,
 
 	spin_lock_irqsave(&target_list_lock, flags);
 	list_for_each_entry(nt, &target_list, list) {
-		netconsole_target_get(nt);
 		if (nt->np.dev == dev) {
 			switch (event) {
 			case NETDEV_CHANGENAME:
@@ -693,7 +692,6 @@ static int netconsole_netdev_event(struct notifier_block *this,
 				break;
 			}
 		}
-		netconsole_target_put(nt);
 	}
 	spin_unlock_irqrestore(&target_list_lock, flags);
 	if (event == NETDEV_UNREGISTER || event == NETDEV_BONDING_DESLAVE)
@@ -722,7 +720,6 @@ static void write_msg(struct console *con, const char *msg, unsigned int len)
 
 	spin_lock_irqsave(&target_list_lock, flags);
 	list_for_each_entry(nt, &target_list, list) {
-		netconsole_target_get(nt);
 		if (nt->enabled && netif_running(nt->np.dev)) {
 			/*
 			 * We nest this inside the for-each-target loop above
@@ -738,7 +735,6 @@ static void write_msg(struct console *con, const char *msg, unsigned int len)
 				left -= frag;
 			}
 		}
-		netconsole_target_put(nt);
 	}
 	spin_unlock_irqrestore(&target_list_lock, flags);
 }
