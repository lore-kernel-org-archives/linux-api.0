Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BB9358D32;
	Fri, 28 Aug 2026 22:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787955846; cv=none; b=V4UkGASXChplL6U5ziCid8lC6L6R0WNiLPWMgSp+C4z1c1meQq0/mvwGarIp5O9lBSpVcUfZiRvKTODkPVnhIO21oGuXKKY/NBMEljzdCLngB5Ti83EEMeufxe3+FRPrhIl3oVD9WFNVmkVp6C/CzFopoWpi9gdIIwj7j7GvSn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787955846; c=relaxed/simple;
	bh=hxZbtaZ63m/+A+zqLGDwlA1agw5ugsOGWVeXCl/82Mk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pPecLwbgZoziuZNWfK9Ic9ime7U7ia71c8Kab7gnL8VRVuqqx0G5BXSlF4BX+VnpgkmJtDne4ODsQC47ihc9mgmxTNNdToR1eZQZxQSBOQ/Ilq/n+EVu+OjUlkvjLkXcDiSu53E9d8nIHaI/ygWOgBIimhdmymjgJ1bFQiFPiwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YmKT6iqf; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YmKT6iqf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787955840; x=1819491840;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hxZbtaZ63m/+A+zqLGDwlA1agw5ugsOGWVeXCl/82Mk=;
  b=YmKT6iqfJbtFCtx9Zrh8cB4rixc+Pz6gUBYtMSBrIxObYgjARbvP6FK0
   0OqCvoU/P1XiWTBD86ZzHyFpPvCGdFHjXc+8a4zuTM6kWYNOscToBvUe2
   GD25vXt60m35rkwyGUEvNw4deJrciiYlVJ3WwetAB/wS9hJ9UjsVrrWtB
   h3FCy+Bq6rLh7XGNRn4XOc//EaSxG+HRVKzmoJru+kxWVnyqcvHugWuHt
   4wGUj6N1ayu6AKpnY8koo9HhqZ7cU4rHA0hR5tsAw1hWa/btRgBTEOhk7
   3MfloOrhRYeRVcCbQyd2WzEw16qNfkHG2KG/p5Q3zsjn4hj2N9yJETaNz
   w==;
X-CSE-ConnectionGUID: b3hl+6ycQm6nn7AFmKh7jg==
X-CSE-MsgGUID: EiCI/gB5RLq0Ta2HWtJqEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="87412379"
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="87412379"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 15:23:58 -0700
X-CSE-ConnectionGUID: V3IRnfwvR1a36rUdKHkk5Q==
X-CSE-MsgGUID: Rod7V+T+RB2mi4mg9oS5IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="264540288"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by fmviesa010.fm.intel.com with ESMTP; 28 Aug 2026 15:23:57 -0700
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: Chen Yu <yu.c.chen@intel.com>,
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
	Adam Li <adamli@os.amperecomputing.com>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Tim Chen <tim.c.chen@intel.com>,
	Josh Don <joshdon@google.com>,
	Luo Gengkun <luogengkun2@huawei.com>,
	Gavin Guo <gavinguo@igalia.com>,
	Yi Lai <yi1.lai@intel.com>,
	Ricardo Neri <ricardo.neri@intel.com>,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: [RFC PATCH 6/7] sched/cache: Extend the enabled debugfs to more modes
Date: Fri, 28 Aug 2026 15:29:13 -0700
Message-Id: <fd341106e7e6cbd2f047656650f43ee87c6633c1.1787955777.git.tim.c.chen@linux.intel.com>
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

From: Chen Yu <yu.c.chen@intel.com>

A knob named "enabled" under debugfs llc_balancing is used to allow
the user to turn off and on the cache aware scheduling at runtime.
Since there is fine-gain control for per task cache-aware scheduling
control via prctl, enhance the "enabled" knob in to a three-value
mode, derived from the design of THP:
always, advise, never.

The design matrix is as followed:
                 prctl ENABLE   prctl DISABLE
  always              Y              Y
  advise              Y              N
  never               N              N

Y: cache aware scheduling for the task is enabled
N: cache aware scheduling for the task is disabled

The default mode is "always".

For backward compatibility, writing "1" or "0" is still accepted and
is treated as "always" or "never" respectively.

The same modes can also be selected at boot time via the
sched_cache= kernel command line parameter.

Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 .../admin-guide/kernel-parameters.txt         |  3 +
 kernel/sched/cache_sched.c                    |  2 +-
 kernel/sched/debug.c                          | 63 +++++++++++++++++--
 kernel/sched/fair.c                           |  7 ++-
 kernel/sched/sched.h                          | 21 ++++++-
 kernel/sched/topology.c                       | 32 ++++++++--
 6 files changed, 112 insertions(+), 16 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index b5493a7f8f22..33b965d4ba19 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6751,6 +6751,9 @@ Kernel parameters
 			solution to mutex-based priority inversion.
 			Format: <bool>
 
+	sched_cache=	[KNL] Set the cache aware scheduling mode.
+			Format: { "always" | "advise" | "never" }
+
 	sched_verbose	[KNL,EARLY] Enables verbose scheduler debug messages.
 
 	schedstats=	[KNL,X86] Enable or disable scheduled statistics.
diff --git a/kernel/sched/cache_sched.c b/kernel/sched/cache_sched.c
index c4ec6c553cca..c50eb3bebec3 100644
--- a/kernel/sched/cache_sched.c
+++ b/kernel/sched/cache_sched.c
@@ -60,7 +60,7 @@ static void sched_cache_group_init(struct sched_cache_group *grp,
 	grp->next_scan = jiffies;
 	grp->nr_running_avg = 0;
 	grp->footprint = 0;
-	grp->enabled = 1;
+	grp->enabled = 0;
 	refcount_set(&grp->refcnt, 1);
 	/*
 	 * The update to grp->pcpu_sched should not be reordered
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 40584b27ea0c..ddefbaf48d47 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -211,19 +211,58 @@ static const struct file_operations sched_scaling_fops = {
 };
 
 #ifdef CONFIG_SCHED_CACHE
+
+static const char * const sc_modes_names[] = {
+	[SC_ENABLED_ALWAYS] = "always",
+	[SC_ENABLED_ADVISE] = "advise",
+	[SC_ENABLED_NEVER] = "never",
+};
+
+static int sched_cache_set_mode(const char *str)
+{
+	int mode;
+	bool val;
+
+	mode = match_string(sc_modes_names, ARRAY_SIZE(sc_modes_names), str);
+	if (mode < 0) {
+		if (kstrtobool(str, &val))
+			return mode;
+
+		mode = val ? SC_ENABLED_ALWAYS : SC_ENABLED_NEVER;
+	}
+
+	WRITE_ONCE(sysctl_sched_cache_mode, mode);
+
+	return 0;
+}
+
+static int __init setup_sched_cache_mode(char *str)
+{
+	return sched_cache_set_mode(str) ? 0 : 1;
+}
+
+__setup("sched_cache=", setup_sched_cache_mode);
+
 static ssize_t
 sched_cache_enable_write(struct file *filp, const char __user *ubuf,
 			 size_t cnt, loff_t *ppos)
 {
-	bool val;
+	char buf[16];
 	int ret;
 
-	ret = kstrtobool_from_user(ubuf, cnt, &val);
-	if (ret)
-		return ret;
+	if (cnt > sizeof(buf) - 1)
+		return -EINVAL;
 
-	sysctl_sched_cache_user = val;
+	if (copy_from_user(buf, ubuf, cnt))
+		return -EFAULT;
 
+	buf[cnt] = 0;
+	/* 1. parse user provide mode */
+	ret = sched_cache_set_mode(strstrip(buf));
+	if (ret < 0)
+		return ret;
+
+	/* 2. adjust the static keys */
 	sched_cache_active_set();
 
 	*ppos += cnt;
@@ -233,7 +272,19 @@ sched_cache_enable_write(struct file *filp, const char __user *ubuf,
 
 static int sched_cache_enable_show(struct seq_file *m, void *v)
 {
-	seq_printf(m, "%d\n", sysctl_sched_cache_user);
+	int mode = READ_ONCE(sysctl_sched_cache_mode);
+	int i;
+
+	for (i = 0; i < SC_ENABLED_NR; i++) {
+		if (i)
+			seq_putc(m, ' ');
+		if (i == mode)
+			seq_printf(m, "[%s]", sc_modes_names[i]);
+		else
+			seq_puts(m, sc_modes_names[i]);
+	}
+	seq_putc(m, '\n');
+
 	return 0;
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e7c8b031946c..cf83b24e925d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1652,7 +1652,7 @@ static int get_pref_llc(struct task_struct *p, struct sched_cache_group *grp)
 	if (!grp)
 		return -1;
 
-	if (!READ_ONCE(grp->enabled))
+	if (!sched_cache_group_enabled(grp))
 		return -1;
 
 	mm_sched_cpu = READ_ONCE(grp->cpu);
@@ -1746,7 +1746,7 @@ static void task_tick_cache(struct rq *rq, struct task_struct *p)
 	    !grp->pcpu_sched)
 		return;
 
-	if (!READ_ONCE(grp->enabled))
+	if (!sched_cache_group_enabled(grp))
 		return;
 
 	epoch = rq->cpu_epoch;
@@ -10601,6 +10601,9 @@ static enum llc_mig can_migrate_llc_task(int src_cpu, int dst_cpu,
 	if (!grp)
 		return mig_unrestricted;
 
+	if (!sched_cache_group_enabled(grp))
+		return mig_unrestricted;
+
 	cpu = READ_ONCE(grp->cpu);
 	if (cpu < 0 || cpus_share_cache(src_cpu, dst_cpu))
 		return mig_unrestricted;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7dbe070979d7..d013850dd253 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -4092,9 +4092,17 @@ static inline void mm_cid_switch_to(struct task_struct *prev, struct task_struct
 #endif /* !CONFIG_SCHED_MM_CID */
 
 #ifdef CONFIG_SCHED_CACHE
+enum sc_modes {
+	SC_ENABLED_ALWAYS	= 0,
+	SC_ENABLED_ADVISE	= 1,
+	SC_ENABLED_NEVER	= 2,
+	SC_ENABLED_NR,
+};
+
 DECLARE_STATIC_KEY_FALSE(sched_cache_present);
 DECLARE_STATIC_KEY_FALSE(sched_cache_active);
-extern int sysctl_sched_cache_user;
+DECLARE_STATIC_KEY_FALSE(sched_cache_adv);
+extern int sysctl_sched_cache_mode;
 extern unsigned int llc_aggr_tolerance;
 extern unsigned int llc_epoch_period;
 extern unsigned int llc_epoch_affinity_timeout;
@@ -4106,6 +4114,17 @@ static inline bool sched_cache_enabled(void)
 	return static_branch_unlikely(&sched_cache_active);
 }
 
+static inline bool sched_cache_group_enabled(struct sched_cache_group *grp)
+{
+	if (!static_branch_unlikely(&sched_cache_active))
+		return false;
+
+	if (!static_branch_likely(&sched_cache_adv))
+		return true;
+
+	return READ_ONCE(grp->enabled);
+}
+
 DEFINE_FREE(sched_cache_group_put, struct sched_cache_group *,
 	    sched_cache_group_put(_T));
 
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 622e2e01974c..0ae9d270ebf8 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -853,8 +853,12 @@ DEFINE_STATIC_KEY_FALSE(sched_cache_present);
  * is active, used by the scheduler.
  */
 DEFINE_STATIC_KEY_FALSE(sched_cache_active);
-/* user wants cache aware scheduling [0 or 1] */
-int sysctl_sched_cache_user = 1;
+DEFINE_STATIC_KEY_FALSE(sched_cache_adv);
+/*
+ * User provided cache aware scheduling modes:
+ * always, advise, never.
+ */
+int sysctl_sched_cache_mode = SC_ENABLED_ALWAYS;
 
 /*
  * Get the effective LLC size in bytes that @cpu's bottom sched_domain
@@ -952,6 +956,7 @@ static void _sched_cache_active_set(void)
 	/* hardware does not support */
 	if (!static_branch_likely(&sched_cache_present)) {
 		static_branch_disable_cpuslocked(&sched_cache_active);
+		static_branch_disable_cpuslocked(&sched_cache_adv);
 		if (sched_debug())
 			pr_info("%s: cache aware scheduling not supported on this platform\n", __func__);
 		return;
@@ -963,14 +968,29 @@ static void _sched_cache_active_set(void)
 	 * It is not in the critical path, leave as-is
 	 * for now.
 	 */
-	if (sysctl_sched_cache_user) {
+	switch (READ_ONCE(sysctl_sched_cache_mode)) {
+	case SC_ENABLED_ALWAYS:
+		static_branch_disable_cpuslocked(&sched_cache_adv);
 		static_branch_enable_cpuslocked(&sched_cache_active);
 		if (sched_debug())
-			pr_info("%s: enabling cache aware scheduling\n", __func__);
-	} else {
+			pr_info("%s: cache aware scheduling switch to [always]\n", __func__);
+		break;
+	case SC_ENABLED_ADVISE:
+		static_branch_enable_cpuslocked(&sched_cache_adv);
+		static_branch_enable_cpuslocked(&sched_cache_active);
+		if (sched_debug())
+			pr_info("%s: cache aware scheduling switch to [advise]\n", __func__);
+		break;
+	case SC_ENABLED_NEVER:
 		static_branch_disable_cpuslocked(&sched_cache_active);
+		static_branch_disable_cpuslocked(&sched_cache_adv);
 		if (sched_debug())
-			pr_info("%s: disabling cache aware scheduling\n", __func__);
+			pr_info("%s: cache aware scheduling switch to [never]\n", __func__);
+		break;
+	default:
+		if (sched_debug())
+			pr_info("%s: Invalid cache aware scheduling mode\n", __func__);
+		break;
 	}
 }
 
-- 
2.32.0

