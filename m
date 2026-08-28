Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC70384CDD;
	Fri, 28 Aug 2026 22:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787955840; cv=none; b=Les51BU5OuxYGOiC1IG4eBtM9ufY7NeJYTlO56dRZljmLzBMNaohoHqvyK7ZiIRDXIYar6X8wO4hXmyW24ccvcGoAS6m89pXArfqf/h8yx403w6Cw3qkHDH3hv3WPTBKfZu+ggHSDMT9qbgxeCH7IySZMSRNeaaqOoXLYpw+5Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787955840; c=relaxed/simple;
	bh=EathXJ0ODYDs+CPUE4zzzr3s7RHPjcYP7FySau1gdaU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UBlDB19YQUPly5Iuwd7W76FVd2VmjBQ6yuE0WNGjur4P62OvJc69ghiKkwvqI8vpfuq0tzsnsJI/mAENghulkJoY9BE0ol92bKlNuyPjLoYP2/dAnwEMzQPtIxbQvIEFeILr2O39mJ4zOO1E+HBVRnKHX9ljjyOge4vtW0uPAUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XxdCkudF; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XxdCkudF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787955838; x=1819491838;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EathXJ0ODYDs+CPUE4zzzr3s7RHPjcYP7FySau1gdaU=;
  b=XxdCkudFtjVfAs515FlZwhBG/to7x2Gt+RRGAyMI1KUBUn38HcKacAoB
   J6rotPaf1DdT48y89bylP3JNhQu4O/c7f4dFwhfj6h66vfXGp1PYnc0ny
   AE4UeBETiKs/MKOOTk4V3dAB8NPR9VTyZgQS0WoFn5Bv+sO3WvqSZWq1t
   UN1hHBeCXoQu01DKeVxMaEom5fMmeGlZeBq3hpFyA2svi9ujVcA6BX1kz
   9Ll36cE6c5HY319Y1BratqXREldQS5cJ97alFR0Oyx26a2QEq7DQNJ+8H
   WMzL9x4v8HNdEGrT1NyQXwEf1BWEnRCDX3uZitt5liP73X/tInO8nVWJu
   Q==;
X-CSE-ConnectionGUID: traEC4DARHCAOUy3kN4kdg==
X-CSE-MsgGUID: quhGKK1iRUatloP60NqStg==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="87412360"
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="87412360"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 15:23:56 -0700
X-CSE-ConnectionGUID: Ak2S1tTATEabCtKMAI+WlA==
X-CSE-MsgGUID: ek2yFjTkT7SJyBt2zkQciw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="264540284"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by fmviesa010.fm.intel.com with ESMTP; 28 Aug 2026 15:23:55 -0700
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
Subject: [RFC PATCH 5/7] sched/cache: Allow a process to enable cache aware scheduling via prctl
Date: Fri, 28 Aug 2026 15:29:12 -0700
Message-Id: <14772dcf31c7eae3cec060fd6884579ed1c0f03b.1787955777.git.tim.c.chen@linux.intel.com>
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

Add the PR_SCHED_CACHE_ENABLE and PR_SCHED_CACHE_DISABLE subops to the
PR_SCHED_CACHE prctl interface, allowing a process to turn cache aware
scheduling on or off.

int prctl(PR_SCHED_CACHE, unsigned long subop, pid_t pid,
          unsigned long cookie, unsigned long type);

/* disable cache aware scheduling for this task */
prctl(PR_SCHED_CACHE, PR_SCHED_CACHE_DISABLE, 0, 0, PIDTYPE_PID);

/* enable cache aware scheduling for this task */
prctl(PR_SCHED_CACHE, PR_SCHED_CACHE_ENABLE, 0, 0, PIDTYPE_PID);

pid 0 targets the calling task; otherwise the group of the given pid is
used. Both return -ENOENT when the task has no cache scheduling group.

Co-developed-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 include/linux/sched.h      |  1 +
 include/uapi/linux/prctl.h |  4 +++-
 kernel/sched/cache_sched.c | 15 +++++++++++++++
 kernel/sched/fair.c        |  6 ++++++
 4 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 79f0079c3aa1..1529730c91a5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2399,6 +2399,7 @@ struct sched_cache_group {
 	unsigned long next_scan;
 	unsigned long footprint;
 	int cpu;
+	int enabled;
 	refcount_t refcnt;
 	struct rcu_head rcu;
 } ____cacheline_aligned_in_smp;
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index fed7bb028f9a..3fb31c4ab7b5 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -421,6 +421,8 @@ struct prctl_mm_map {
 # define PR_SCHED_CACHE_GET		0
 # define PR_SCHED_CACHE_CREATE		1
 # define PR_SCHED_CACHE_SHARE_FROM	2
-# define PR_SCHED_CACHE_MAX		3
+# define PR_SCHED_CACHE_DISABLE		3
+# define PR_SCHED_CACHE_ENABLE		4
+# define PR_SCHED_CACHE_MAX		5
 
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sched/cache_sched.c b/kernel/sched/cache_sched.c
index d1932f0c5ee8..c4ec6c553cca 100644
--- a/kernel/sched/cache_sched.c
+++ b/kernel/sched/cache_sched.c
@@ -60,6 +60,7 @@ static void sched_cache_group_init(struct sched_cache_group *grp,
 	grp->next_scan = jiffies;
 	grp->nr_running_avg = 0;
 	grp->footprint = 0;
+	grp->enabled = 1;
 	refcount_set(&grp->refcnt, 1);
 	/*
 	 * The update to grp->pcpu_sched should not be reordered
@@ -261,6 +262,20 @@ int sched_cache_prctl(int option, unsigned long arg2, unsigned long arg3,
 	}
 
 	switch (arg2) {
+	case PR_SCHED_CACHE_DISABLE:
+	case PR_SCHED_CACHE_ENABLE:
+		/*
+		 * Setting a single task is OK, because the sched_cache_group is
+		 * shared by multiple tasks, setting one equals to setting all.
+		 */
+		grp = task_cache_group_get(dst);
+		if (!grp) {
+			err = -ENOENT;
+			goto out_task;
+		}
+		WRITE_ONCE(grp->enabled, arg2 == PR_SCHED_CACHE_ENABLE);
+
+		goto out_group;
 	case PR_SCHED_CACHE_GET: {
 		unsigned long id = 0;
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d422b62ba987..e7c8b031946c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1652,6 +1652,9 @@ static int get_pref_llc(struct task_struct *p, struct sched_cache_group *grp)
 	if (!grp)
 		return -1;
 
+	if (!READ_ONCE(grp->enabled))
+		return -1;
+
 	mm_sched_cpu = READ_ONCE(grp->cpu);
 	if (mm_sched_cpu != -1) {
 		mm_sched_llc = llc_id(mm_sched_cpu);
@@ -1743,6 +1746,9 @@ static void task_tick_cache(struct rq *rq, struct task_struct *p)
 	    !grp->pcpu_sched)
 		return;
 
+	if (!READ_ONCE(grp->enabled))
+		return;
+
 	epoch = rq->cpu_epoch;
 	/* avoid moving backwards */
 	if (time_after_eq(grp->epoch, epoch))
-- 
2.32.0

