Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EA839DBD6;
	Fri, 28 Aug 2026 22:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787955833; cv=none; b=XmboS/gDRRenXWYfIYS+kdQlEe1aX7SWp091cyr4+nsZCryLtfd+ZfuA7gSvQmjiXEdVhCiG1JMdNvjCHq4n51+xL9AsUam2n+8l7RCc0fcFuVdrUH3YY2RuCUpyAiPxBgNmoDwskneNiw1ergbGKEYnBCrLMGnTIEH3lz9xCDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787955833; c=relaxed/simple;
	bh=8Oi9LnmhOpikFPJVdlsU5Egxb9il/A1QSK2LrPmao+I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s7YsOdYcwn4Q5akjB6vhHFlE25F418PPMTfz3+BiGivxX8mkq9FvdsOGUbmgb3nncj3Brfx7gwYKb+iei00XT1vkMAc95btZmvSTM31OsjVilqBH6DaCItI07lzAu1g6dqB/XsnHXm/IPFpfLO0ymojFadbFWetAwN5sU/sXsnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GIfNWY+6; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GIfNWY+6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787955831; x=1819491831;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8Oi9LnmhOpikFPJVdlsU5Egxb9il/A1QSK2LrPmao+I=;
  b=GIfNWY+6Z3cc/fvJyFaTPMDX5gKoW1P5LHqt6ywavo4CPqko3YcR4964
   q7WQ44H1sq/41PIXi1jtOCXjLZH8HUcbiRcAhw3upEO6q77Gtdw6O+DHB
   VqbJbPOy9W9Gnzj+J72LC/SQujtXLCx6oIALXek5QFI3g9rlLGpiDwZrm
   dAxLz+CF1NP0XliX1APyZnSmQjaI6e86dEiY0vpYBdLspeve00zRg4GOo
   9wBY8ha3y5Q63BkDHeGZr4wg7U5r/Iy9HokR3XqcmEA9cpjHHcguQIzVj
   Kasg0om9+Nr42R3S7WyxOVTQEavxsqcl3T3AbwLrH7UctvAqWbSYP8onQ
   g==;
X-CSE-ConnectionGUID: XUT5HnIbTOa3ktPZVX4F+w==
X-CSE-MsgGUID: etDAabgSRbq1RqenosIN6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="87412282"
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="87412282"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 15:23:50 -0700
X-CSE-ConnectionGUID: iR49H/2iS02RAiBq8pUpLQ==
X-CSE-MsgGUID: pSqkzZ2rTQiCHxlhSDr/Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="264540266"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by fmviesa010.fm.intel.com with ESMTP; 28 Aug 2026 15:23:49 -0700
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Qais Yousef <qyousef@layalina.io>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Madadi Vineeth Reddy <vineethr@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Jianyong Wu <jianyong.wu@outlook.com>,
	Yangyu Chen <cyy@cyyself.name>,
	Tingyin Duan <tingyin.duan@gmail.com>,
	Vern Hao <vernhao@tencent.com>,
	Vern Hao <haoxing990@gmail.com>,
	Len Brown <len.brown@intel.com>,
	Aubrey Li <aubrey.li@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Chen Yu <yu.chen.surf@gmail.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Adam Li <adamli@os.amperecomputing.com>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Tim Chen <tim.c.chen@intel.com>,
	Josh Don <joshdon@google.com>,
	Luo Gengkun <luogengkun2@huawei.com>,
	Gavin Guo <gavinguo@igalia.com>,
	Yi Lai <yi1.lai@intel.com>,
	Ricardo Neri <ricardo.neri@intel.com>,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [RFC PATCH 1/7] sched/cache: Decouple sched_cache_group from mm
Date: Fri, 28 Aug 2026 15:29:08 -0700
Message-Id: <4f82fe28ecdda1728e3ad29bd44f5287226a8d73.1787955777.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1787955777.git.tim.c.chen@linux.intel.com>
References: <cover.1787955777.git.tim.c.chen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the sched cache grouping is by mm.  But in the future,
the grouping could be by cgroup, cookie group, numa_group or others.

Rename sched_cache_stat to sched_cache_group and turn it into a
refcounted object allocated from mm_struct.
The mm_struct now holds a pointer (sched_cache_grp) to this object
instead of embedding it.

Introduce kernel/sched/cache_sched.c to host the cache aware
scheduling helpers and define sched_cache_group_put() there.

Meanwhile skip kthreads in account_mm_sched(), consistently with
task_tick_cache().

Co-developed-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 include/linux/mm_types.h     |  15 ++---
 include/linux/sched.h        |   8 ++-
 kernel/exit.c                |   6 +-
 kernel/sched/build_utility.c |   4 ++
 kernel/sched/cache_sched.c   |  20 +++++++
 kernel/sched/fair.c          | 110 +++++++++++++++++++++--------------
 6 files changed, 105 insertions(+), 58 deletions(-)
 create mode 100644 kernel/sched/cache_sched.c

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b18c2b2e7d2c..2b109cdaaad8 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1211,7 +1211,7 @@ struct mm_struct {
 		struct mm_mm_cid mm_cid;
 
 		/* sched_cache related statistics */
-		struct sched_cache_stat sc_stat;
+		struct sched_cache_group *sched_cache_grp;
 #ifdef CONFIG_MMU
 		atomic_long_t pgtables_bytes;	/* size of all page tables */
 #endif
@@ -1609,8 +1609,9 @@ static inline unsigned int mm_cid_size(void)
 #endif /* CONFIG_SCHED_MM_CID */
 
 #ifdef CONFIG_SCHED_CACHE
-void mm_init_sched(struct mm_struct *mm,
-		   struct sched_cache_time __percpu *pcpu_sched);
+int mm_init_sched(struct mm_struct *mm,
+		  struct sched_cache_time __percpu *pcpu_sched);
+void mm_destroy_sched(struct mm_struct *mm);
 
 static inline int mm_alloc_sched_noprof(struct mm_struct *mm)
 {
@@ -1620,17 +1621,11 @@ static inline int mm_alloc_sched_noprof(struct mm_struct *mm)
 	if (!pcpu_sched)
 		return -ENOMEM;
 
-	mm_init_sched(mm, pcpu_sched);
-	return 0;
+	return mm_init_sched(mm, pcpu_sched);
 }
 
 #define mm_alloc_sched(...)	alloc_hooks(mm_alloc_sched_noprof(__VA_ARGS__))
 
-static inline void mm_destroy_sched(struct mm_struct *mm)
-{
-	free_percpu(mm->sc_stat.pcpu_sched);
-	mm->sc_stat.pcpu_sched = NULL;
-}
 #else /* !CONFIG_SCHED_CACHE */
 
 static inline int mm_alloc_sched(struct mm_struct *mm) { return 0; }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 373bcc0598d1..1974420e7bf2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2390,7 +2390,7 @@ struct sched_cache_time {
 	unsigned long epoch;
 };
 
-struct sched_cache_stat {
+struct sched_cache_group {
 	struct sched_cache_time __percpu *pcpu_sched;
 	raw_spinlock_t lock;
 	unsigned long epoch;
@@ -2398,11 +2398,15 @@ struct sched_cache_stat {
 	unsigned long next_scan;
 	unsigned long footprint;
 	int cpu;
+	refcount_t refcnt;
+	struct rcu_head rcu;
 } ____cacheline_aligned_in_smp;
 
+void sched_cache_group_put(struct sched_cache_group *grp);
+
 #else
 
-struct sched_cache_stat { };
+struct sched_cache_group { };
 
 #endif
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 2c0b1c02920f..ebe9a6145b35 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -561,12 +561,12 @@ static void exit_mm_sched_cache(struct mm_struct *mm)
 		return;
 	/*
 	 * No lock protection due to performance considerations.
-	 * Make sure mm->sc_stat.footprint does not become
+	 * Make sure the group footprint does not become
 	 * negative.
 	 */
-	fp = READ_ONCE(mm->sc_stat.footprint);
+	fp = READ_ONCE(mm->sched_cache_grp->footprint);
 	sub = min(fp, current->total_numa_faults);
-	WRITE_ONCE(mm->sc_stat.footprint, fp - sub);
+	WRITE_ONCE(mm->sched_cache_grp->footprint, fp - sub);
 }
 #else
 static inline void exit_mm_sched_cache(struct mm_struct *mm)
diff --git a/kernel/sched/build_utility.c b/kernel/sched/build_utility.c
index e2cf3b08d4e9..24202893b262 100644
--- a/kernel/sched/build_utility.c
+++ b/kernel/sched/build_utility.c
@@ -89,6 +89,10 @@
 # include "core_sched.c"
 #endif
 
+#ifdef CONFIG_SCHED_CACHE
+# include "cache_sched.c"
+#endif
+
 #ifdef CONFIG_PSI
 # include "psi.c"
 #endif
diff --git a/kernel/sched/cache_sched.c b/kernel/sched/cache_sched.c
new file mode 100644
index 000000000000..d492df55f9d5
--- /dev/null
+++ b/kernel/sched/cache_sched.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "sched.h"
+
+static void sched_cache_group_free_rcu(struct rcu_head *rcu)
+{
+	struct sched_cache_group *grp =
+		container_of(rcu, struct sched_cache_group, rcu);
+
+	/* free_percpu() may be called from atomic context. */
+	free_percpu(grp->pcpu_sched);
+	kfree(grp);
+}
+
+void sched_cache_group_put(struct sched_cache_group *grp)
+{
+	if (!grp || !refcount_dec_and_test(&grp->refcnt))
+		return;
+
+	call_rcu(&grp->rcu, sched_cache_group_free_rcu);
+}
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d78467ec6ee1..014a8826ac14 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1450,7 +1450,7 @@ static bool exceed_llc_capacity(struct mm_struct *mm, int cpu)
 		 * excluded.
 		 */
 		llc = sd->llc_bytes;
-		footprint = READ_ONCE(mm->sc_stat.footprint);
+		footprint = READ_ONCE(mm->sched_cache_grp->footprint);
 
 		/*
 		 * Scale the LLC size by 256*llc_aggr_tolerance
@@ -1495,7 +1495,7 @@ static bool invalid_llc_nr(struct mm_struct *mm, struct task_struct *p,
 	if (scale == INT_MAX)
 		return false;
 
-	return !fits_capacity((mm->sc_stat.nr_running_avg * cpu_smt_num_threads),
+	return !fits_capacity((mm->sched_cache_grp->nr_running_avg * cpu_smt_num_threads),
 			(scale * per_cpu(sd_llc_size, cpu)));
 }
 
@@ -1572,12 +1572,19 @@ static void account_llc_dequeue(struct rq *rq, struct task_struct *p)
 	}
 }
 
-void mm_init_sched(struct mm_struct *mm,
-		   struct sched_cache_time __percpu *_pcpu_sched)
+int mm_init_sched(struct mm_struct *mm,
+		  struct sched_cache_time __percpu *_pcpu_sched)
 {
+	struct sched_cache_group *grp;
 	unsigned long epoch = 0;
 	int i;
 
+	grp = kzalloc_obj(*grp);
+	if (!grp) {
+		free_percpu(_pcpu_sched);
+		return -ENOMEM;
+	}
+
 	for_each_possible_cpu(i) {
 		struct sched_cache_time *pcpu_sched = per_cpu_ptr(_pcpu_sched, i);
 		struct rq *rq = cpu_rq(i);
@@ -1588,18 +1595,28 @@ void mm_init_sched(struct mm_struct *mm,
 		epoch = rq->cpu_epoch;
 	}
 
-	raw_spin_lock_init(&mm->sc_stat.lock);
-	mm->sc_stat.epoch = epoch;
-	mm->sc_stat.cpu = -1;
-	mm->sc_stat.next_scan = jiffies;
-	mm->sc_stat.nr_running_avg = 0;
-	mm->sc_stat.footprint = 0;
+	raw_spin_lock_init(&grp->lock);
+	grp->epoch = epoch;
+	grp->cpu = -1;
+	grp->next_scan = jiffies;
+	grp->nr_running_avg = 0;
+	grp->footprint = 0;
+	refcount_set(&grp->refcnt, 1);
+	mm->sched_cache_grp = grp;
 	/*
-	 * The update to mm->sc_stat should not be reordered
-	 * before initialization to mm's other fields, in case
+	 * The update to grp->pcpu_sched should not be reordered
+	 * before initialization to grp's other fields, in case
 	 * the readers may get invalid mm_sched_epoch, etc.
 	 */
-	smp_store_release(&mm->sc_stat.pcpu_sched, _pcpu_sched);
+	smp_store_release(&grp->pcpu_sched, _pcpu_sched);
+	return 0;
+}
+
+void mm_destroy_sched(struct mm_struct *mm)
+{
+	if (mm->sched_cache_grp)
+		sched_cache_group_put(mm->sched_cache_grp);
+	mm->sched_cache_grp = NULL;
 }
 
 /* because why would C be fully specified */
@@ -1657,7 +1674,7 @@ static int get_pref_llc(struct task_struct *p, struct mm_struct *mm)
 	if (!mm)
 		return -1;
 
-	mm_sched_cpu = READ_ONCE(mm->sc_stat.cpu);
+	mm_sched_cpu = READ_ONCE(mm->sched_cache_grp->cpu);
 	if (mm_sched_cpu != -1) {
 		mm_sched_llc = llc_id(mm_sched_cpu);
 
@@ -1700,11 +1717,15 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 	/*
 	 * init_task, kthreads and user thread created
 	 * by user_mode_thread() don't have mm.
+	 *
+	 * A kthread can temporarily adopt an mm via kthread_use_mm(),
+	 * so p->mm alone does not imply a user task.
 	 */
-	if (!mm || !mm->sc_stat.pcpu_sched)
+	if (!mm || p->flags & PF_KTHREAD || !mm->sched_cache_grp ||
+	    !mm->sched_cache_grp->pcpu_sched)
 		return;
 
-	pcpu_sched = per_cpu_ptr(mm->sc_stat.pcpu_sched, cpu_of(rq));
+	pcpu_sched = per_cpu_ptr(mm->sched_cache_grp->pcpu_sched, cpu_of(rq));
 
 	scoped_guard (raw_spinlock, &rq->cpu_epoch_lock) {
 		__update_mm_sched(rq, pcpu_sched);
@@ -1717,11 +1738,11 @@ void account_mm_sched(struct rq *rq, struct task_struct *p, s64 delta_exec)
 	 * If this process hasn't hit task_cache_work() for a while invalidate
 	 * its preferred state.
 	 */
-	if ((long)(epoch - READ_ONCE(mm->sc_stat.epoch)) > llc_epoch_affinity_timeout ||
+	if ((long)(epoch - READ_ONCE(mm->sched_cache_grp->epoch)) > llc_epoch_affinity_timeout ||
 	    invalid_llc_nr(mm, p, cpu_of(rq)) ||
 	    exceed_llc_capacity(mm, cpu_of(rq))) {
-		if (READ_ONCE(mm->sc_stat.cpu) != -1)
-			WRITE_ONCE(mm->sc_stat.cpu, -1);
+		if (READ_ONCE(mm->sched_cache_grp->cpu) != -1)
+			WRITE_ONCE(mm->sched_cache_grp->cpu, -1);
 	}
 
 	mm_sched_llc = get_pref_llc(p, mm);
@@ -1745,19 +1766,19 @@ static void task_tick_cache(struct rq *rq, struct task_struct *p)
 		return;
 
 	if (!mm || p->flags & PF_KTHREAD ||
-	    !mm->sc_stat.pcpu_sched)
+	    !mm->sched_cache_grp->pcpu_sched)
 		return;
 
 	epoch = rq->cpu_epoch;
 	/* avoid moving backwards */
-	if (time_after_eq(mm->sc_stat.epoch, epoch))
+	if (time_after_eq(mm->sched_cache_grp->epoch, epoch))
 		return;
 
-	guard(raw_spinlock)(&mm->sc_stat.lock);
+	guard(raw_spinlock)(&mm->sched_cache_grp->lock);
 
 	if (work->next == work) {
 		task_work_add(p, work, TWA_RESUME);
-		WRITE_ONCE(mm->sc_stat.epoch, epoch);
+		WRITE_ONCE(mm->sched_cache_grp->epoch, epoch);
 	}
 }
 
@@ -1769,7 +1790,7 @@ static void get_scan_cpumasks(cpumask_var_t cpus, struct task_struct *p)
 	if (!static_branch_likely(&sched_numa_balancing))
 		goto out;
 
-	cpu = READ_ONCE(p->mm->sc_stat.cpu);
+	cpu = READ_ONCE(p->mm->sched_cache_grp->cpu);
 	if (cpu != -1)
 		nid = cpu_to_node(cpu);
 	curr_cpu = task_cpu(p);
@@ -1841,12 +1862,12 @@ static void task_cache_work(struct callback_head *work)
 	if (p->flags & PF_EXITING)
 		return;
 
-	next_scan = READ_ONCE(mm->sc_stat.next_scan);
+	next_scan = READ_ONCE(mm->sched_cache_grp->next_scan);
 	if (time_before(now, next_scan))
 		return;
 
 	/* only 1 thread is allowed to scan */
-	if (!try_cmpxchg(&mm->sc_stat.next_scan, &next_scan,
+	if (!try_cmpxchg(&mm->sched_cache_grp->next_scan, &next_scan,
 			 now + max_t(unsigned long,
 				     READ_ONCE(llc_epoch_period), 1)))
 		return;
@@ -1854,8 +1875,8 @@ static void task_cache_work(struct callback_head *work)
 	curr_cpu = task_cpu(p);
 	if (invalid_llc_nr(mm, p, curr_cpu) ||
 	    exceed_llc_capacity(mm, curr_cpu)) {
-		if (READ_ONCE(mm->sc_stat.cpu) != -1)
-			WRITE_ONCE(mm->sc_stat.cpu, -1);
+		if (READ_ONCE(mm->sched_cache_grp->cpu) != -1)
+			WRITE_ONCE(mm->sched_cache_grp->cpu, -1);
 
 		return;
 	}
@@ -1878,8 +1899,10 @@ static void task_cache_work(struct callback_head *work)
 				continue;
 
 			for_each_cpu(i, sched_domain_span(sd)) {
+				struct sched_cache_group *grp = mm->sched_cache_grp;
+
 				occ = fraction_mm_sched(cpu_rq(i),
-							per_cpu_ptr(mm->sc_stat.pcpu_sched, i));
+							per_cpu_ptr(grp->pcpu_sched, i));
 				a_occ += occ;
 				if (occ > m_occ) {
 					m_occ = occ;
@@ -1912,7 +1935,7 @@ static void task_cache_work(struct callback_head *work)
 				m_a_cpu = m_cpu;
 			}
 
-			if (llc_id(cpu) == llc_id(READ_ONCE(mm->sc_stat.cpu)))
+			if (llc_id(cpu) == llc_id(READ_ONCE(mm->sched_cache_grp->cpu)))
 				curr_m_a_occ = a_occ;
 
 			cpumask_andnot(cpus, cpus, sched_domain_span(sd));
@@ -1921,7 +1944,7 @@ static void task_cache_work(struct callback_head *work)
 
 	if (m_a_occ > (2 * curr_m_a_occ)) {
 		/*
-		 * Avoid switching sc_stat.cpu too fast.
+		 * Avoid switching sched_cache_grp->cpu too fast.
 		 * The reason to choose 2X is because:
 		 * 1. It is better to keep the preferred LLC stable,
 		 *    rather than changing it frequently and cause migrations
@@ -1930,10 +1953,10 @@ static void task_cache_work(struct callback_head *work)
 		 * 3. 2X is chosen based on test results, as it delivers
 		 *    the optimal performance gain so far.
 		 */
-		WRITE_ONCE(mm->sc_stat.cpu, m_a_cpu);
+		WRITE_ONCE(mm->sched_cache_grp->cpu, m_a_cpu);
 	}
 
-	update_avg_scale(&mm->sc_stat.nr_running_avg, nr_running);
+	update_avg_scale(&mm->sched_cache_grp->nr_running_avg, nr_running);
 	free_cpumask_var(cpus);
 }
 
@@ -3731,18 +3754,19 @@ static void task_numa_placement(struct task_struct *p)
 			 * heuristic and occasional lost updates are tolerable.
 			 *
 			 * If a task exits, its corresponding footprint must
-			 * be subtracted from the mm->sc_stat.footprint, otherwise
-			 * the mm->sc_stat.footprint will not converge:
-			 * the exiting thread's footprint remains unchanged/undecayed
-			 * in mm->sc_stat.footprint. See exit_mm().
+			 * be subtracted from the mm->sched_cache_grp->footprint,
+			 * otherwise the mm->sched_cache_grp->footprint will not
+			 * converge: the exiting thread's footprint remains
+			 * unchanged/undecayed in mm->sched_cache_grp->footprint.
+			 * See exit_mm().
 			 *
 			 * Lost updates and unsynchronized subtraction
 			 * in exit_mm() can cause footprint + diff to
 			 * go negative. Clamp to zero to prevent the
 			 * unsigned footprint from wrapping.
 			 */
-			new_fp = (long)READ_ONCE(p->mm->sc_stat.footprint) + diff;
-			WRITE_ONCE(p->mm->sc_stat.footprint,
+			new_fp = (long)READ_ONCE(p->mm->sched_cache_grp->footprint) + diff;
+			WRITE_ONCE(p->mm->sched_cache_grp->footprint,
 				   max(new_fp, 0L));
 #endif
 		}
@@ -10575,18 +10599,18 @@ static enum llc_mig can_migrate_llc_task(int src_cpu, int dst_cpu,
 	int cpu;
 
 	mm = p->mm;
-	if (!mm)
+	if (!mm || !mm->sched_cache_grp)
 		return mig_unrestricted;
 
-	cpu = READ_ONCE(mm->sc_stat.cpu);
+	cpu = READ_ONCE(mm->sched_cache_grp->cpu);
 	if (cpu < 0 || cpus_share_cache(src_cpu, dst_cpu))
 		return mig_unrestricted;
 
 	/* skip cache aware load balance for too many threads */
 	if (invalid_llc_nr(mm, p, dst_cpu) ||
 	    exceed_llc_capacity(mm, dst_cpu)) {
-		if (READ_ONCE(mm->sc_stat.cpu) != -1)
-			WRITE_ONCE(mm->sc_stat.cpu, -1);
+		if (READ_ONCE(mm->sched_cache_grp->cpu) != -1)
+			WRITE_ONCE(mm->sched_cache_grp->cpu, -1);
 		return mig_unrestricted;
 	}
 
-- 
2.32.0

