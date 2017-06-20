From: Zhen Lei <thunder.leizhen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/1] mm: only dispaly online cpus of the numa node
Date: Tue, 20 Jun 2017 20:43:28 +0800
Message-ID: <1497962608-12756-1-git-send-email-thunder.leizhen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Cc: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Xinwei Hu <huxinwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tianhong Ding <dingtianhong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hanjun Guo <guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Zhen Lei <thunder.leizhen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

When I executed numactl -H(which read /sys/devices/system/node/nodeX/cpumap
and display cpumask_of_node for each node), but I got different result on
X86 and arm64. For each numa node, the former only displayed online CPUs,
and the latter displayed all possible CPUs. Unfortunately, both Linux
documentation and numactl manual have not described it clear.

I sent a mail to ask for help, and Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> replied
that he preferred to print online cpus because it doesn't really make much
sense to bind anything on offline nodes.

Signed-off-by: Zhen Lei <thunder.leizhen-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/base/node.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 5548f96..d5e7ce7 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -28,12 +28,14 @@ static struct bus_type node_subsys = {
 static ssize_t node_read_cpumap(struct device *dev, bool list, char *buf)
 {
 	struct node *node_dev = to_node(dev);
-	const struct cpumask *mask = cpumask_of_node(node_dev->dev.id);
+	struct cpumask mask;
+
+	cpumask_and(&mask, cpumask_of_node(node_dev->dev.id), cpu_online_mask);

 	/* 2008/04/07: buf currently PAGE_SIZE, need 9 chars per 32 bits. */
 	BUILD_BUG_ON((NR_CPUS/32 * 9) > (PAGE_SIZE-1));

-	return cpumap_print_to_pagebuf(list, buf, mask);
+	return cpumap_print_to_pagebuf(list, buf, &mask);
 }

 static inline ssize_t node_read_cpumask(struct device *dev,
--
2.5.0
