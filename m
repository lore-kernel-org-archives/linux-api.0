Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CAFB3AA504;
	Fri, 28 Aug 2026 22:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787955839; cv=none; b=PBCqxoZtClyqj/NhMSPFzbH01nvUdLhMJknf4Uk7dhYd0O5ji67I7h1wZolzj5vZQ/AlUs0K+TobLCpR+OvzW/GKkkhojq+QEmUqjg7mh3lwzH4TCJiG2XcaQikerEJDfx8ytjuo90bJoMHKHF2cEQdg/9JYi63QVt6CPvAbP10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787955839; c=relaxed/simple;
	bh=mGdivKR88nJONRsPiRnL4DiGPu+1f4won+EAVrdUSTY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RdfecNMktxRvRgT0PQAzY0qhBQ2r0XvfI+fqloyY3t4PdNbhzv9LRsIo1s9N6TwQqCSipS6/qJyMI5HzZAn94h4G6SuMZvxywlfGIBSmOGux4ar0VfWkI8bHFBW+vG42/j4PijnKseDVQ11668rsGVnQ3JX6HJmJFheEmnMcLIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PanimF4w; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PanimF4w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787955834; x=1819491834;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mGdivKR88nJONRsPiRnL4DiGPu+1f4won+EAVrdUSTY=;
  b=PanimF4wEbRu86u1sA/YFcxsGGp8V5aZZvtpeEHRwiRQjCyou6ka2XrE
   nvbve15tugYJS4CMM8lC1qHUCJnPONH3iCQDjKilMYsYSOp3JdNTIBdqP
   Rr1kg4PihvWVdJ00TXaTE0fPNvHW9dW9I/dackZGkgobkNLk4NF5S+tsJ
   D8qphlzwxEvfEesyXO1TfN92YtxUl9LgmttBdXdKlAASZrQmZVOrZtp43
   MkkmGZoXEyaimfsM30s7Kcf3LQn0caqTSSsY0ZLoyYJUJQurzUuu2p2sP
   /UstlwnKOTLGbDEs9dzj9v8uDfrlA6hGCoaOVTa8ZIdfAYDok30BT5z/3
   A==;
X-CSE-ConnectionGUID: JAwvw9jLRGm+chJ56eYKeA==
X-CSE-MsgGUID: F93bPWNrQ0ynqfjmxVVGuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="87412321"
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="87412321"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 15:23:53 -0700
X-CSE-ConnectionGUID: /VlTN/ymR9CI6AehwruSiA==
X-CSE-MsgGUID: Ey9yUyPYTliV5E7/NDGYWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="264540274"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by fmviesa010.fm.intel.com with ESMTP; 28 Aug 2026 15:23:52 -0700
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
Subject: [RFC PATCH 3/7] sched/cache: Extract sched_cache_alloc_group() helper
Date: Fri, 28 Aug 2026 15:29:10 -0700
Message-Id: <d6cd97ac68c817576d57658c2ebcffdbd3ac0341.1787955777.git.tim.c.chen@linux.intel.com>
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

Extract sched_cache_alloc_group() into kernel/sched/cache_sched.c as a
shared helper.

Convert mm_init_sched() to use the new helper instead of open-coding the
allocation and initialization.  This prepares for a second caller in the
upcoming prctl CREATE path.

No functional change.

Co-developed-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 include/linux/sched.h      |  2 ++
 kernel/sched/cache_sched.c | 46 ++++++++++++++++++++++++++++++++++++++
 kernel/sched/fair.c        | 32 ++------------------------
 3 files changed, 50 insertions(+), 30 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e7253cb332fd..e25347aa2cc5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2406,6 +2406,8 @@ struct sched_cache_group {
 void sched_cache_group_put(struct sched_cache_group *grp);
 struct sched_cache_group *sched_cache_group_get(struct sched_cache_group *grp);
 struct sched_cache_group *task_cache_group_get(struct task_struct *p);
+struct sched_cache_group *
+sched_cache_alloc_group(struct sched_cache_time __percpu *pcpu_sched);
 
 #else
 
diff --git a/kernel/sched/cache_sched.c b/kernel/sched/cache_sched.c
index 99d07e1e067c..860209a47931 100644
--- a/kernel/sched/cache_sched.c
+++ b/kernel/sched/cache_sched.c
@@ -37,3 +37,49 @@ void sched_cache_group_put(struct sched_cache_group *grp)
 
 	call_rcu(&grp->rcu, sched_cache_group_free_rcu);
 }
+
+static void sched_cache_group_init(struct sched_cache_group *grp,
+				   struct sched_cache_time __percpu *_pcpu_sched)
+{
+	unsigned long epoch = 0;
+	int i;
+
+	for_each_possible_cpu(i) {
+		struct sched_cache_time *pcpu_sched = per_cpu_ptr(_pcpu_sched, i);
+		struct rq *rq = cpu_rq(i);
+
+		pcpu_sched->runtime = 0;
+		/* a slightly stale cpu epoch is acceptible */
+		pcpu_sched->epoch = rq->cpu_epoch;
+		epoch = rq->cpu_epoch;
+	}
+
+	raw_spin_lock_init(&grp->lock);
+	grp->epoch = epoch;
+	grp->cpu = -1;
+	grp->next_scan = jiffies;
+	grp->nr_running_avg = 0;
+	grp->footprint = 0;
+	refcount_set(&grp->refcnt, 1);
+	/*
+	 * The update to grp->pcpu_sched should not be reordered
+	 * before initialization to grp's other fields, in case
+	 * the readers may get invalid mm_sched_epoch, etc.
+	 */
+	smp_store_release(&grp->pcpu_sched, _pcpu_sched);
+}
+
+struct sched_cache_group *
+sched_cache_alloc_group(struct sched_cache_time __percpu *_pcpu_sched)
+{
+	struct sched_cache_group *grp;
+
+	grp = kzalloc_obj(*grp);
+	if (!grp) {
+		free_percpu(_pcpu_sched);
+		return NULL;
+	}
+
+	sched_cache_group_init(grp, _pcpu_sched);
+	return grp;
+}
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 281b4c896bf4..be1f3568c3aa 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1575,40 +1575,12 @@ static void account_llc_dequeue(struct rq *rq, struct task_struct *p)
 int mm_init_sched(struct mm_struct *mm,
 		  struct sched_cache_time __percpu *_pcpu_sched)
 {
-	struct sched_cache_group *grp;
-	unsigned long epoch = 0;
-	int i;
+	struct sched_cache_group *grp = sched_cache_alloc_group(_pcpu_sched);
 
-	grp = kzalloc_obj(*grp);
-	if (!grp) {
-		free_percpu(_pcpu_sched);
+	if (!grp)
 		return -ENOMEM;
-	}
-
-	for_each_possible_cpu(i) {
-		struct sched_cache_time *pcpu_sched = per_cpu_ptr(_pcpu_sched, i);
-		struct rq *rq = cpu_rq(i);
-
-		pcpu_sched->runtime = 0;
-		/* a slightly stale cpu epoch is acceptible */
-		pcpu_sched->epoch = rq->cpu_epoch;
-		epoch = rq->cpu_epoch;
-	}
 
-	raw_spin_lock_init(&grp->lock);
-	grp->epoch = epoch;
-	grp->cpu = -1;
-	grp->next_scan = jiffies;
-	grp->nr_running_avg = 0;
-	grp->footprint = 0;
-	refcount_set(&grp->refcnt, 1);
 	mm->sched_cache_grp = grp;
-	/*
-	 * The update to grp->pcpu_sched should not be reordered
-	 * before initialization to grp's other fields, in case
-	 * the readers may get invalid mm_sched_epoch, etc.
-	 */
-	smp_store_release(&grp->pcpu_sched, _pcpu_sched);
 	return 0;
 }
 
-- 
2.32.0

