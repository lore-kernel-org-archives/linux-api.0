From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 08/12] netoops: Add one-shot mode
Date: Tue, 02 Nov 2010 18:30:13 -0700
Message-ID: <20101103013012.4641.15217.stgit@crlf.mtv.corp.google.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101103012917.4641.57113.stgit-+dUuAhMFdFN6FDdRrpk8kO4/NqBCd+6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
Cc: adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Sometimes it is possible to have a kernel crashing that continuously Oopses.
In this case, we do not want the network dumper get called over and over again,
as we may only be interested in the first Oops that a kernel emits (especially
in cases where we panic_on_oops).

In order to support this dumping policy, this commit introduces a file call
/proc/sys/kernel/net_dump_one_shot that contains a boolean as to whether or not
the netoops driver will operate in one-shot mode.

Note that 'soft' dumps do not disable the netoops driver when one-shot mode is
enabled.

Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
TODO: ABI needs a better home.
---
 drivers/net/netoops.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/net/netoops.c b/drivers/net/netoops.c
index 13c4d51..01432d7 100644
--- a/drivers/net/netoops.c
+++ b/drivers/net/netoops.c
@@ -86,6 +86,8 @@ static struct netpoll *np;
 static struct neighbour *netoops_neighbour;
 static DEFINE_SPINLOCK(netoops_lock);
 static struct netoops_msg msg;
+static int network_dumper_one_shot = 1;
+static int network_dumper_disabled;
 
 static char netoops_fw_version[80];
 static char netoops_board_name[80];
@@ -209,6 +211,7 @@ static void enable_netoops(char *dev_name, u32 dest_ip, u32 src_ip,
 	np = new_np;
 	neighbour = netoops_neighbour;
 	netoops_neighbour = dest_neighbour;
+	network_dumper_disabled = 0;
 	spin_unlock_irqrestore(&netoops_lock, flags);
 
 	/* refcount cannot be decreased with interrupt disabled. */
@@ -415,7 +418,7 @@ static void netoops(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
 	if (!spin_trylock(&netoops_lock))
 		return;
 
-	if (np == NULL || np->dev == NULL) {
+	if (np == NULL || np->dev == NULL || network_dumper_disabled) {
 		spin_unlock(&netoops_lock);
 		return;
 	}
@@ -442,6 +445,10 @@ static void netoops(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
 		netoops_send_segment(packet_count_2, s1, l1);
 	}
 
+	/* Should we disable ourselves now? */
+	if (!soft_dump && network_dumper_one_shot)
+		network_dumper_disabled = 1;
+
 	spin_unlock(&netoops_lock);
 }
 
@@ -577,6 +584,13 @@ static struct ctl_table kern_table[] = {
 		.mode           = 0644,
 		.proc_handler   = &proc_netoops_device,
 	},
+	{
+		.procname       = "net_dump_one_shot",
+		.data           = &network_dumper_one_shot,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+	},
 	{},
 };
 
