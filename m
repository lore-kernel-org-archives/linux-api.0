From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH v16 00/13] support "task_isolation" mode
Date: Thu, 12 Jul 2018 15:29:01 +0300
Message-ID: <20180712122901.GA5049@yury-thinkpad>
References: <1509728692-10460-1-git-send-email-cmetcalf@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1509728692-10460-1-git-send-email-cmetcalf@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, Francis Giraldeau <francis.giraldeau@gmail.com>, Sunil Goutham <sgoutham@cavium.com>, linux-mm@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.k
List-Id: linux-api@vger.kernel.org

On Fri, Nov 03, 2017 at 01:04:39PM -0400, Chris Metcalf wrote:
> Here, finally, is a new spin of the task isolation work (v16), with
> changes based on the issues that were raised at last year's Linux
> Plumbers Conference and in the email discussion that followed.

Hi Chris,

There's another possible way to break task isolation, by net subsystem.
See patch below.

Yury


>From 8025e9330bf06ce146d4ba96833aad6eafe24759 Mon Sep 17 00:00:00 2001
From: Yury Norov <ynorov@caviumnetworks.com>
Date: Sun, 8 Jul 2018 00:40:46 +0300
Subject: [PATCH] net: don't let user assign task isolation CPUs for RPS

Receive Packet Steering (RPS) subsystem distributes network traffic
handling to CPUs defined by user in
/sys/class/net/<dev>/queues/rx-<n>/rps_cpus.

If rps_cpus intersects with task_isolation_map, RPS may break task
isolation by assigning RPS work to CPU that runs isolated task.

In this patch user-provided rps_cpus map filtered to avoid that.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
---
 include/linux/isolation.h |  2 ++
 net/core/net-sysfs.c      | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/isolation.h b/include/linux/isolation.h
index f467545ad37d..b7f0a9085b13 100644
--- a/include/linux/isolation.h
+++ b/include/linux/isolation.h
@@ -14,6 +14,8 @@ struct task_struct;
 
 #ifdef CONFIG_TASK_ISOLATION
 
+extern cpumask_var_t task_isolation_map;
+
 /**
  * task_isolation_request() - prctl hook to request task isolation
  * @flags:	Flags from <linux/prctl.h> PR_TASK_ISOLATION_xxx.
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 927a6dcbad96..18e576893984 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -11,6 +11,7 @@
 
 #include <linux/capability.h>
 #include <linux/kernel.h>
+#include <linux/isolation.h>
 #include <linux/netdevice.h>
 #include <net/switchdev.h>
 #include <linux/if_arp.h>
@@ -727,6 +728,18 @@ static ssize_t store_rps_map(struct netdev_rx_queue *queue,
 		return err;
 	}
 
+#ifdef CONFIG_TASK_ISOLATION
+	if (cpumask_intersects(mask, task_isolation_map)) {
+		char tmp[256];
+
+		pr_warn("RPS is not allowed on CPUs allocated for isolated tasks\n");
+
+		cpumask_andnot(mask, mask, task_isolation_map);
+		cpumap_print_to_pagebuf(1, tmp, mask);
+		pr_warn("RPS CPUs list is reduced to: %s\n", tmp);
+	}
+#endif
+
 	map = kzalloc(max_t(unsigned int,
 			    RPS_MAP_SIZE(cpumask_weight(mask)), L1_CACHE_BYTES),
 		      GFP_KERNEL);
-- 
2.17.1
