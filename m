From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/2] sched: Misc preps for cgroup unified hierarchy interface
Date: Fri, 5 Aug 2016 13:09:20 -0400
Message-ID: <20160805170920.GL2542@mtj.duckdns.org>
References: <20160805170752.GK2542@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160805170752.GK2542@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@fb.com
List-Id: linux-api@vger.kernel.org

>From 0d966df508ef4d6c0b1baae9e369f4fb0d3e10af Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 11 Mar 2016 07:31:23 -0500

Make the following changes in preparation for the cpu controller
interface implementation for the unified hierarchy.  This patch
doesn't cause any functional differences.

* s/cpu_stats_show()/cpu_cfs_stats_show()/

* s/cpu_files/cpu_legacy_files/

* Separate out cpuacct_stats_read() from cpuacct_stats_show().  While
  at it, remove pointless cpuacct_stat_desc[] array.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 kernel/sched/core.c    |  8 ++++----
 kernel/sched/cpuacct.c | 33 +++++++++++++++------------------
 2 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 97ee9ac..c148dfe 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8482,7 +8482,7 @@ static int __cfs_schedulable(struct task_group *tg, u64 period, u64 quota)
 	return ret;
 }
 
-static int cpu_stats_show(struct seq_file *sf, void *v)
+static int cpu_cfs_stats_show(struct seq_file *sf, void *v)
 {
 	struct task_group *tg = css_tg(seq_css(sf));
 	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
@@ -8522,7 +8522,7 @@ static u64 cpu_rt_period_read_uint(struct cgroup_subsys_state *css,
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
-static struct cftype cpu_files[] = {
+static struct cftype cpu_legacy_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
 		.name = "shares",
@@ -8543,7 +8543,7 @@ static struct cftype cpu_files[] = {
 	},
 	{
 		.name = "stat",
-		.seq_show = cpu_stats_show,
+		.seq_show = cpu_cfs_stats_show,
 	},
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -8568,7 +8568,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.fork		= cpu_cgroup_fork,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
-	.legacy_cftypes	= cpu_files,
+	.legacy_cftypes	= cpu_legacy_files,
 	.early_init	= true,
 };
 
diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 41f85c4..3eb9eda 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -242,36 +242,33 @@ static int cpuacct_percpu_seq_show(struct seq_file *m, void *V)
 	return __cpuacct_percpu_seq_show(m, CPUACCT_USAGE_NRUSAGE);
 }
 
-static const char * const cpuacct_stat_desc[] = {
-	[CPUACCT_STAT_USER] = "user",
-	[CPUACCT_STAT_SYSTEM] = "system",
-};
-
-static int cpuacct_stats_show(struct seq_file *sf, void *v)
+static void cpuacct_stats_read(struct cpuacct *ca, u64 *userp, u64 *sysp)
 {
-	struct cpuacct *ca = css_ca(seq_css(sf));
 	int cpu;
-	s64 val = 0;
 
+	*userp = 0;
 	for_each_possible_cpu(cpu) {
 		struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
-		val += kcpustat->cpustat[CPUTIME_USER];
-		val += kcpustat->cpustat[CPUTIME_NICE];
+		*userp += kcpustat->cpustat[CPUTIME_USER];
+		*userp += kcpustat->cpustat[CPUTIME_NICE];
 	}
-	val = cputime64_to_clock_t(val);
-	seq_printf(sf, "%s %lld\n", cpuacct_stat_desc[CPUACCT_STAT_USER], val);
 
-	val = 0;
+	*sysp = 0;
 	for_each_possible_cpu(cpu) {
 		struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
-		val += kcpustat->cpustat[CPUTIME_SYSTEM];
-		val += kcpustat->cpustat[CPUTIME_IRQ];
-		val += kcpustat->cpustat[CPUTIME_SOFTIRQ];
+		*sysp += kcpustat->cpustat[CPUTIME_SYSTEM];
+		*sysp += kcpustat->cpustat[CPUTIME_IRQ];
+		*sysp += kcpustat->cpustat[CPUTIME_SOFTIRQ];
 	}
+}
 
-	val = cputime64_to_clock_t(val);
-	seq_printf(sf, "%s %lld\n", cpuacct_stat_desc[CPUACCT_STAT_SYSTEM], val);
+static int cpuacct_stats_show(struct seq_file *sf, void *v)
+{
+	cputime64_t user, sys;
 
+	cpuacct_stats_read(css_ca(seq_css(sf)), &user, &sys);
+	seq_printf(sf, "user %lld\n", cputime64_to_clock_t(user));
+	seq_printf(sf, "system %lld\n", cputime64_to_clock_t(sys));
 	return 0;
 }
 
-- 
2.7.4
